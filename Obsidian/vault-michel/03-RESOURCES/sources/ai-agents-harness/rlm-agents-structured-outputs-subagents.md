---
title: "RLM Agents live healthier when they talk via Structured Outputs"
type: source
source: "Clippings/RLM Agents live healthier when they talk via Structured Outputs.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central

Em Recursive Language Models (RLMs) — agentes que respondem perguntas sobre contextos maiores que sua janela tratando o prompt como variável dentro de um REPL Python e podendo gerar sub-agentes recursivamente — fazer subagentes responderem com **structured outputs** (JSON Schema validado) em vez de texto livre reduz drasticamente alucinação e falhas de agregação, com custo de tokens equivalente.

## Argumentos principais

- **O que são RLMs**: o modelo escreve código para buscar, fatiar e dividir o texto-fonte, podendo gerar sub-agentes recursivamente sobre os pedaços. As respostas dos sub-agentes voltam como *valores dentro do REPL* — nunca são despejadas diretamente no contexto do agente pai.
- **O ponto crítico de design**: traces de RLM funcionam ou falham dependendo da capacidade do agente principal de (a) instruir corretamente os sub-agentes sobre o que fazer, (b) o que retornar, e (c) como agregar as respostas dos sub-agentes na resposta final.
- **Caso de teste**: texto completo (~107K caracteres) de "The Coxon Fund" (Henry James, LongBench/NarrativeQA). Pergunta: "Qual é a situação de moradia de Saltram?" Resposta correta: "Ele é hóspede na casa dos Mulville." O fato nunca é dito diretamente — requer ler e conectar; o token "Saltram" frequentemente não aparece perto das passagens que descrevem onde ele mora (não é resolvível por keyword lookup).
- **Duas estratégias possíveis ao receber um problema**: (1) **ataque direto** — o modelo fatia/imprime seções do contexto no próprio REPL e raciocina sobre elas, em profundidade 0; (2) **deploy de subagentes** — cria fatias menores do contexto original, pede a cada sub-agente para resolver problemas parciais, e agrega os achados (divide and conquer).
- **Ataque direto funcionou**: busca por "Saltram" com janelas de contexto, segue o fio até "Mulville", varre termos relacionados a moradia ("lodging", "lived", "house", "guest", "inmate" etc.) — chega à resposta correta por ~$0.04 com Minimax M3.
- **Subagentes v1 (free-text fan-out) — falhou**: dividiu os 107K caracteres em chunks de tamanho fixo, mapeou um sub-agente por chunk pedindo "extraia fatos sobre a situação de moradia de Saltram, responda em 2-4 bullets", depois delegou a um segundo LM para agregar as 62 respostas. Resultado: a maioria dos 62 sub-agentes retornou variações de "este trecho não contém informação sobre onde Saltram mora" (texto livre, inconsistente). O segundo agente, sobrecarregado com 62 respostas textuais, não conseguiu lê-las de forma limpa, entrou em "flail" e acabou **escrevendo manualmente** uma resposta incorreta (Saltram morando sozinho em "chambers" em Londres — errado).
- **Subagentes v2 (structured output routing) — sucesso**: em vez de pedir prosa, cada sub-agente recebeu uma pergunta booleana com schema JSON ("este chunk contém informação sobre a situação de moradia de Saltram? True/False"), em paralelo (um batch). Apenas os chunks com `True` foram passados para um agente de agregação final, que produziu a resposta correta ("Saltram era um 'inmate' residente dos Mulville...").
- **Por que funciona**: o booleano atua como **máscara de atenção direta** sobre o contexto original — "external sparsification of the input prompt". Modelos de raciocínio de baixa potência podem perder o fio quando leem muitos tokens não relacionados de uma vez; o schema evita que o modelo precise interpretar 40 variações de "não há menção disso neste parágrafo" e simplesmente olha para um flag booleano.
- **Custo equivalente, qualidade diferente**: tanto o ataque direto (depth-0) quanto a abordagem com subagentes (depth-1) custaram ~$0.04 com Minimax-M3 — tokens equivalentes — mas o escopo de alucinação foi muito menor na abordagem com subagentes, por evitar que o modelo veja grandes blocos de texto não relacionado de uma vez.

## Key insights

- **Validação de structured output não é só para sub-agentes** — o usuário também pode impor o contrato de schema ao agente raiz.
- **Pipeline de validação (lib `fast-rlm`)**:
  1. **Normalização de schema (Python)**: aceita Pydantic model, tipo primitivo (`int`), generic (`list[Model]`) ou dict JSON Schema cru; tudo é convertido para JSON Schema plano (`model_json_schema()` para Pydantic, `TypeAdapter` para generics, lookup para primitivos).
  2. **Contrato exposto no início do REPL**: no passo 0, antes de qualquer trabalho, o JSON Schema desejado é mostrado ao agente — ele sabe o formato exato que deve retornar antes de escrever qualquer código.
  3. **Validação a cada `FINAL`**: quando o LLM chama `FINAL(answer)` dentro do REPL, o conteúdo é validado contra o schema *antes* de retornar ao agente chamador.
  4. **Retry, não restart**: se a validação falha, o agente recebe feedback com o schema exigido **e** os erros específicos de validação (ex.: `(root): must be boolean`); o trabalho do REPL permanece intacto — o modelo só precisa corrigir o valor e chamar `FINAL` de novo. Validação se repete até passar.
- Schema booleano é só um exemplo — em teoria, um agente pode pedir qualquer schema (incluindo listas/objetos aninhados, qualquer coisa expressável em zod/pydantic), sempre validado antes de retornar.
- Trecho de código de feedback de validação (TypeScript, lib fast-rlm):
```typescript
if (validate && !validate(result)) {
    const feedback =
        `FINAL value failed schema validation. ...\n` +
        `Required JSON Schema:\n${schemaStr}\n\n` +
        `Validation errors:\n${formatValidationErrors(validate)}\n\n` +
        `Fix the value and call FINAL again. `
}
```

## Exemplos e evidencias

- Texto-fonte: "The Coxon Fund" de Henry James (~107K chars), dataset LongBench/NarrativeQA.
- v1 (free-text fan-out): 62 sub-agentes em paralelo, max-depth=1 (sub-agentes não podiam gerar novos agentes); resultado incorreto após "flail" do agregador.
- v2 (structured boolean routing): chunk_size=5000, 1 sub-agente booleano por chunk em paralelo (um `batch_llm_query`), filtra `relevant_chunks` onde `r==True`, agrega em ordem cronológica → resposta correta.
- Custo: ~$0.04 em ambas as abordagens (depth-0 direto e depth-1 com subagentes), com Minimax-M3.
- Repositório citado: `fast-rlm` (https://github.com/avbiswas/fast-rlm), versão v1.14 mencionada com suporte a input não-string (dict Python), declaração de output schema garantido, e subagentes com schema explícito.

## Implicacoes para o vault

- Reforça diretamente `[[03-RESOURCES/concepts/agent-systems/subagent-spawning]]` e `[[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]`: o caso v1→v2 é evidência empírica concreta de que **outputs estruturados/validados em sub-agentes reduzem falhas de agregação** — relevante para qualquer pipeline do vault que faça fan-out de subagentes (ex.: `wiki-ingest`, `ingest-report`) e precise agregar resultados de múltiplas fontes.
- Conecta com `[[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]]` e `[[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]` — o padrão "validate on every FINAL, retry don't restart" é uma forma de generator-verifier loop aplicada à interface entre agentes.
- "External sparsification via structured boolean routing" é uma técnica aplicável a tarefas de triagem em massa do vault (ex.: classificar dezenas de Clippings por relevância/categoria via sub-agentes booleanos antes de um agregador) — possível padrão a documentar em `[[03-RESOURCES/concepts/agent-systems/agentic-patterns]]`.

## Links

- [[03-RESOURCES/concepts/agent-systems/subagent-spawning]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-as-a-verifier]]

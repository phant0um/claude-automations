---
title: "AI co-mathematician: Accelerating mathematicians with agentic AI"
type: source
source: Clippings/AI co-mathematician Accelerating mathematicians with agentic AI.md
created: 2026-05-17
ingested: 2026-05-17
tags: [ai-agents, research, science, math]
triagem_score: 8
---

## Tese central
Agente "co-matemático" da Google descobre conjecturas matemáticas autonomamente, valida com proof assistants (Lean/Coq), e colabora com humanos como parceiro de pesquisa — não substituto. Primeiro sistema de escala para descoberta matemática original com verificação formal integrada.

## Key insights
- **Loop fechado de descoberta:** propor conjectura → gerar prova → verificar formalmente com proof assistant → se falhar, refinar conjectura → iterar. Ciclo completamente autônomo até convergência ou abandono
- **Verificabilidade resolve alucinação:** em domínios formais, erro é detectável deterministicamente. Proof assistant rejeita prova incorreta com certeza — diferente de domínios abertos onde alucinação pode passar invisível
- **Parceiro, não substituto:** humano define área de interesse, avalia relevância de conjecturas emergentes, guia exploração de alto nível. Agente executa busca intensiva no espaço de possibilidades — divisão de trabalho humano+máquina ideal
- **Extensível a domínios formais:** química computacional (validação via simulação), biologia teórica (modelos matemáticos verificáveis), física teórica (equações com soluções fechadas)

## Arquitetura do sistema

### Módulo de conjectura
LLM treinado em literatura matemática propõe afirmações baseado em padrões observados em teoremas conhecidos. Usa few-shot de conjecturas famosas para calibrar nível de ambição (não trivial, não impossível).

### Módulo de prova
Gera prova em linguagem formal (Lean 4 ou Coq). Múltiplas tentativas com estratégias diferentes — indução, contradiction, construction. Cada estratégia é uma "chain of thought" estruturada para o assistente de provas.

### Proof assistant como oráculo
Lean/Coq executam verificação formal — output binário (válido/inválido) com localização precisa de falha quando inválido. Feedback determinístico guia refinamento de forma mais confiável que LLM-as-judge.

### Módulo de relevância
Filtro que avalia conjecturas verificadas por originalidade, generalidade, e conexão com problemas abertos conhecidos. LLM com contexto de literatura matemática ranqueia descobertas.

## Por que isso importa além de matemática

### Padrão de verificação formal como escape da alucinação
Qualquer domínio com verificação determinística pode usar arquitetura similar:
- Código: testes unitários como proof assistant
- Química: simulações DFT como validador
- Lógica: SAT/SMT solvers como oráculo

O co-matemático não é caso especial — é blueprint para pesquisa autônoma confiável.

### Aceleração de descoberta científica
Matemáticos produtivos exploram dezenas de conjecturas por semana mentalmente. Agente explora milhares em paralelo, descarta as triviais ou improváveis, e apresenta candidatas filtradas. Amplificação cognitiva real.

## Limitações conhecidas

- Conjecturas emergentes tendem a ser locais (pequenas generalizações) em vez de fundamentais
- Prova formal requer formalização do domínio — não aplicável a áreas sem biblioteca Lean/Coq robusta
- Custo computacional de verificação formal é alto — não escala para conjecturas arbitrariamente complexas sem infra dedicada

## Conexão com autoresearch-loop

Padrão implementado aqui é instância concreta de autoresearch-loop: agente usa ferramentas externas como ambiente de feedback para guiar exploração autônoma. Loop fecha quando proof assistant confirma descoberta válida ou tempo/compute é esgotado.

## Implicação filosófica: o que é descoberta?

Questão importante levantada por este trabalho: se agente descobre conjectura verdadeira que humano não conhecia, isso é descoberta matemática real?

Argumento a favor: verdade matemática não depende de quem a descobriu. Se conjectura é nova e válida, é descoberta independente de ser humano ou agente.

Argumento contra: descoberta matemática inclui componente de insight — entender por que algo é verdadeiro, não apenas verificar que é. Agente que encontra prova sem entendimento é mais próximo de busca computacional que descoberta.

Posição pragmática do paper: não tomar partido filosófico. Demonstrar que sistema produz resultados verificáveis e potencialmente úteis para pesquisadores humanos. Deixar classificação de "descoberta" para a comunidade matemática.

## Escalabilidade e próximos passos

O co-matemático atual opera em subdomínios formalizados do conhecimento matemático — álgebra, teoria dos números, geometria com bibliotecas Lean robustas. Espaço de expansão:

- **Mais domínios formalizados:** à medida que Lean/Mathlib cobre mais matemática, agente acessa mais território
- **Colaboração com múltiplos agentes:** um agente propõe, outro refuta, terceiro tenta alternativas — adversarial setup que refina conjecturas mais rapidamente
- **Interface com pesquisa humana ativa:** agente mapeando conjecturas abertas da literatura e tentando atacá-las sistematicamente

## Por que score 8 (não 9-10)

Interessante como caso de uso e como padrão de design, mas impacto direto no vault-michel ou no trabalho cotidiano de ADS é limitado. Valor principal: entender como feedback determinístico (proof assistant) habilita autonomia segura — princípio generalizável.

## Aplicação do princípio a domínios cotidianos

O princípio central — feedback determinístico habilita autonomia segura — tem aplicações diretas mesmo fora de matemática formal:

**Para coding:** testes automatizados são o "proof assistant" do desenvolvimento. Agente que pode rodar testes tem feedback determinístico — não precisa de revisão humana para saber se código funciona. Autonomia com testes = autonomia segura.

**Para análise de dados:** queries SQL têm resultado verificável. Agente que formula queries e verifica resultado contra expectativa (número de linhas, distribuição de valores) opera em loop fechado verificável.

**Para ADS FIAP:** exercícios com gabarito são feedback determinístico. Agente de estudo que resolve exercícios e verifica contra gabarito pode identificar lacunas sem supervisão humana constante.

O co-matemático da Google é o caso mais sofisticado deste padrão, mas o padrão em si é imediatamente aplicável em contextos mais simples e mais cotidianos.

## Links
- [[03-RESOURCES/concepts/agent-systems/automated-research-agents]]
- [[03-RESOURCES/concepts/pkm-obsidian/autoresearch-loop]]
- [[03-RESOURCES/concepts/llm-ml-foundations/automated-alignment-researcher]]

---
title: "How to make agentic workflows 100x cheaper (full guide)"
type: source
source: "Clippings/How to make agentic workflows 100x cheaper (full guide).md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Workflows agênticos procedurais e estáveis podem ser compilados em modelos pequenos self-hosted, eliminando o custo de re-enviar a estrutura do workflow a cada turno. A pesquisa da Universidade de Melbourne (arXiv:2605.22502) demonstrou reduções de custo de 128x, 296x e 462x em três domínios, mantendo 87-98% da qualidade frontier — com break-even em menos de 500 conversas e custo total de setup de $50-80.

## Argumentos principais

- **O problema central**: o custo de um workflow agêntico vem de onde ele vive. Se o procedimento é fixo e não muda entre conversas, por que pagar para descrevê-lo toda vez?
- **Três abordagens de custo radicalmente diferente**:
  - **Orchestration** (mais comum): software no topo do modelo injeta instruções e decide o fluxo a cada turno. Custo: $0.05-0.17/conversa.
  - **In-context**: toda a lógica fica no system prompt, modelo executa por si mesmo. Mais caro: $0.10-0.33/conversa.
  - **Compiled**: ensina-se um modelo menor o procedimento uma vez, hospeda-se. Custo: $0.0003-0.001/conversa.
- **O insight central**: "se o shape do workflow — seus steps, branches, sua ordem — não muda de uma conversa para a próxima, por que pagar para descrevê-lo toda vez? Coloque o shape imutável dentro do modelo e reserve o prompt para a única coisa que realmente varia."
- **Processo de compilação em 4 etapas**:
  1. Desenhar o workflow como flowchart (boxes = turns, arrows = next steps possíveis, terminais: success, abandonment, escalation).
  2. Usar modelo frontier (Claude Sonnet) para gerar 2,000-6,000 conversas sintéticas realistas percorrendo todos os caminhos do flowchart — custo ~$40.
  3. Fine-tune em modelo pequeno open-source: Qwen 2.5 (3B) para workflows simples, Qwen3 (8B) para complexos. Full retrain obrigatório (LoRA falhou em aprender procedimentos multi-step). LR 2×10⁻⁵, 10-20 épocas. Custo ~$10-40 em GPU.
  4. Deploy self-hosted com vLLM (~$2.50/h para A100). Sem orchestrator — o modelo auto-orquestra pelo que aprendeu. Prompt size: constante. Routing errors: eliminados por design.
- **Qualidade retida** (avaliada por AI grader + segundo grader cross-check): naturalness 97%, graceful handling 92%, task success 91%, information accuracy 87%. 8B compiled model: 87-98% da baseline frontier in-context. Em dois dos três workflows, o compiled falhou menos que a versão com orchestrator.
- **Fit de uso**: forte quando o workflow é procedural (desenháv el como flowchart), estável (não muda entre conversas), alto volume (break-even <500 conversas), e você quer manter o procedimento privado (não exposto a API de terceiros). Fraco para tarefas open-ended, dependentes de world knowledge amplo, ou com procedimento mudando constantemente.
- **Caveat crítico — LoRA falha**: o shortcut de fine-tuning barato não aprendeu procedimentos multi-step adequadamente no estudo. É full retrain ou nada.
- **Refresh de procedimento alterado**: ~30-50 minutos, não rebuild completo.

## Key insights

- **Os tokens mais caros são os tokens que descrevem o que o modelo já deveria saber**: a orquestração repete o procedimento em cada turno como se o modelo não pudesse aprender. Compilação move esse conhecimento para os pesos.
- **Self-hosting é onde a economia real está**: ~65x de economia por token vem do self-host, não apenas do modelo menor. A infraestrutura cara de API de frontier é eliminada.
- **Full retrain vs LoRA**: LoRA é o "cheap shortcut" que o estudo explicitamente testou e reprovou para procedimentos multi-step. "Se alguém oferecer fazer do jeito rápido, a resposta é não."
- **Break-even empírico <500 conversas**: para qualquer workflow com volume moderado, o investimento de $50-80 paga em dias.
- **Curva de custo não-linear com complexidade**: "the advantage grows the more complex your workflow gets" — a economia de 462x foi no workflow mais complexo (55 nodes, 6 branching points).
- **A vantagem dobra a cada ordem de magnitude de volume**: "At 10,000+ conversations, the study reports compilation adds less than $0.01 per conversation once the setup is spread out."
- **Código de geração de dados** usa enumeração de caminhos acíclicos, não random walk — para cobertura uniforme de todos os terminais, evitando over-sampling de rotas curtas de abandonment.

## Exemplos e evidências

- **Três domínios testados** pela Universidade de Melbourne: reduções de 128x, 296x, 462x.
- **Qualidade**: naturalness 97%, graceful handling 92%, task success 91%, information accuracy 87%.
- **Hardware de referência**: A100 ou H200 para fine-tune, vLLM para serving (~$2.50/h).
- **Modelos testados**: Qwen 2.5 (3B) para workflows simples, Qwen3 (8B) para complexos.
- **Tamanho de workflows**: simples com 14 nodes; mais complexo (insurance claims) com 55 nodes e 6 branching points. Ambos funcionaram.
- **Código completo incluído**:
  - `generate.py`: gerador de conversas sintéticas (FlowChart → conversas realistas via Claude Sonnet).
  - Script de fine-tuning com SFTTrainer (trl), SFTConfig, parâmetros exatos.
  - Comando de serving com vLLM.
- **Travel-booking example** como template de `procedure.json` completo com nodes, edges, scenario_variables.
- Paper: https://arxiv.org/pdf/2605.22502.

## Implicações para o vault

- O pipeline de ingestão do vault-michel executa workflows procedurais e estáveis (ingestão de source → criação de páginas → atualização de manifest). Teoricamente candidato a compilação, mas o volume atual pode não justificar o setup.
- A distinção entre "orchestration", "in-context" e "compiled" é uma taxonomia de custo útil para classificar os agentes do vault-michel.
- O insight de "procedure private via self-hosting" é relevante para qualquer workflow do vault com dados sensíveis.
- Complementa diretamente [[03-RESOURCES/sources/how-to-run-100-agents-in-parallel-in-claude-code-full-playbook]] na dimensão de custo (este foca em redução de custo por compilação, aquele foca em tiering de modelos em workflows paralelos).
- Candidato a expandir [[03-RESOURCES/concepts/ai-agents/]] com um conceito sobre "workflow compilation" ou "procedural agent distillation."

## Links

- [[03-RESOURCES/concepts/ai-agents/multi-agent-orchestration]]
- [[03-RESOURCES/sources/how-to-run-100-agents-in-parallel-in-claude-code-full-playbook]]
- [[03-RESOURCES/sources/how-to-build-a-custom-agent-harness]]
- [[03-RESOURCES/sources/economy-of-minds-multi-agent-prompt-optimization-explained]]

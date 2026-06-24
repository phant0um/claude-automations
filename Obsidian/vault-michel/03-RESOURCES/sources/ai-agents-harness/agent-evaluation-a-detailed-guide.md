---
title: "Agent Evaluation A Detailed Guide"
type: source
source: Clippings/Agent Evaluation A Detailed Guide.md
source_type: clipping
created: 2026-05-19
ingested: 2026-05-19
triagem_score: 9
triagem_cat: ai-agents/eval
tags: [ai-agents, clipping]
---

## Tese central

Framework completo de avaliação de agentes — harnesses de eval, LLM-as-judge, métricas de produção, e case studies de pipelines de avaliação em sistemas multi-step reais.

## Key insights

- **Fundamentals of Agent Systems:** agentes diferem de modelos em dois eixos — capacidade de resolver problemas multi-step complexos e capacidade de se recuperar de erros intermediários sem intervenção humana. Avaliação precisa cobrir ambos
- **Solving complex, multi-step problems:** métricas de output final subestimam qualidade — agente pode chegar ao resultado correto por caminho patológico que falhará em variações. Eval precisa auditar trajetória, não só output
- **Recovering from errors:** taxa de recuperação de erro é KPI crítico em produção. Agente que nunca erra vs agente que erra e se recupera — o segundo é mais robusto e preferível em tarefas longas
- **Harness de eval:** framework de teste isolado que executa agente em tarefas controladas, captura trace completo de ações, e avalia cada step + resultado final
- **LLM-as-judge:** usar modelo separado para avaliar outputs de agente — calibrar judge com humano primeiro, medir concordância (Cohen's kappa), e usar rubrica explícita para reduzir variância

## Dimensões de avaliação de agentes

### 1. Completude de tarefa
Agente concluiu o objetivo especificado? Medido com verificação determinística quando possível (testes, checagens de arquivo, chamadas de API) — LLM-as-judge apenas quando output é aberto.

### 2. Eficiência de trajetória
Quantos steps o agente levou? Compara com trajetória ótima humana. Agente que usa 3x mais chamadas de ferramenta que necessário é problemático mesmo que complete a tarefa.

### 3. Taxa de erro e recuperação
Com que frequência agente entra em estado de erro? Quando entra, qual fração consegue se recuperar sem assistência? Qual tipo de erro desencadeia colapso total vs recovery?

### 4. Generalização fora da distribuição
Agente treinado/avaliado em exemplos X performa em variações Y? Avaliação robusta inclui casos edge não vistos durante desenvolvimento.

### 5. Custo de operação
Total de tokens, chamadas de ferramenta, latência por tarefa. Agente capaz mas caro é inviável em produção — avaliação precisa incluir dimensão econômica.

## Estrutura de harness de eval

```
task_suite/
├── tasks/          # definição de tarefas (input, expected output, success criteria)
├── runner/         # executa agente + captura trace
├── evaluators/     # lógica de avaliação por dimensão
└── reports/        # agregação, dashboards, regressão entre versões
```

Cada tarefa tem: descrição, contexto inicial, critério de sucesso verificável, e dificuldade estimada. Runner injeta agente no ambiente e captura cada ação + estado resultante.

## LLM-as-judge: boas práticas

- **Rubrica explícita antes de pontuar:** critérios escritos reduzem variância inter-judge de ~40% para ~10%
- **Calibração com humano:** rodar 100 exemplos com juiz humano + juiz LLM, medir concordância, ajustar rubrica até kappa > 0.7
- **Judge ≠ modelo avaliado:** usar modelo diferente como judge para evitar viés self-serving
- **Posição de output importa:** LLM-as-judge tem viés por ordem de apresentação — randomizar para avaliações comparativas

## Case studies mencionados

Guia cobre pipelines de eval em sistemas de coding assistants, customer support agents, e research agents — mostrando como cada domínio tem KPIs distintos mas estrutura de harness compartilhada.

## Aplicação ao vault

Agentes do vault (nexus, guard, ingest-report) precisam de eval suite própria. Critérios: correção de wikilinks gerados, qualidade de síntese, taxa de conflito com hot.md. Harness pode ser implementado como skill de avaliação periódica.

## Critérios de quando usar LLM-as-judge vs determinístico

Regra geral: usar verificação determinística sempre que possível. LLM-as-judge apenas quando:
1. Output é aberto e não existe ground truth verificável
2. Métrica requer compreensão de nuance (qualidade de explicação, clareza de escrita)
3. Múltiplas respostas válidas existem e todas devem receber score justo

Exemplos de verificação determinística que frequentemente passa desapercebida:
- "Agente criou arquivo correto?" → verificar com sistema de arquivos
- "Código gerado passa nos testes?" → rodar testes automaticamente
- "Wikilink gerado é válido?" → verificar se página existe no vault
- "JSON output é válido?" → schema validation

Usar LLM-as-judge para esses casos é desperdício de compute e introduz variância desnecessária. Reservar judge para dimensões genuinamente subjetivas.

## Granularidade de eval: tarefa vs skill vs comportamento

Eval pode operar em três granularidades:

**Tarefa:** "Agente completou X?" — binário, útil para métricas de alto nível
**Skill:** "Agente usou a ferramenta Y corretamente?" — auditoria de capacidade específica
**Comportamento:** "Agente seguiu a instrução Z consistentemente?" — avaliação de aderência a guidelines

Misturar granularidades em um único número obscurece diagnóstico. Suite de eval completa cobre as três separadamente.

## Por que score 9

Guia mais completo disponível em 2026 sobre eval de agentes. Combina teoria (por que eval é difícil), ferramentas (harnesses, juízes), e prática (case studies reais). Preenche gap que documentação oficial da Anthropic não cobre.

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]

## Fonte

Arquivo original: `Clippings/Agent Evaluation A Detailed Guide.md`

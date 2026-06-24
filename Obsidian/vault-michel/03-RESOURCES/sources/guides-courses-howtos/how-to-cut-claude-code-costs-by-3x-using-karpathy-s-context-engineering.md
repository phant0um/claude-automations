---
title: "How to cut Claude Code costs by 3x (using Karpathy’s context engineering principles)  "
type: source
source_type: article
source_path: .raw/articles/How to cut Claude Code costs by 3x (using Karpathy’s context engineering….md
created: 2026-05-09
ingested: 2026-05-09
tags: [ai-agents, article]
triagem_score: 7
---

## Resumo

# How to cut Claude Code costs by 3x (using Karpathy’s context engineering principles)  
  
  
**[Nainsi Dwivedi](https://x.com/NainsiDwiv50980)**  
[@NainsiDwiv50980](https://x.com/NainsiDwiv50980)  
  
Someone just reduced Claude Code costs by ~3x… and it has nothing to do with prompts, models, or any usual “AI hacks”.  
  
It came down to one overlooked layer:  
  
the backend.  
  
Mos

## Origem

- Path: `.raw/articles/How to cut Claude Code costs by 3x (using Karpathy’s context engineering….md`
- Categoria: ai-agents
- Ingerido: 2026-05-09

## Cross-links

- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-md-cost-optimization]]
- [[03-RESOURCES/entities/Claude Code]]

---

## Por Que o Backend, Não o Prompt

A premissa central do artigo de Nainsi Dwivedi é contraintuitiva: a redução de custo 3x não veio de prompts melhores ou de trocar de modelo. Veio de arquitetura de contexto — como o código está organizado para que o agente precise ler menos para entender mais.

A intuição correta: tokens de input custam tanto quanto tokens de output. Um codebase "AI-legível" que permite ao agente encontrar o que precisa com 10 leituras de arquivo em vez de 50 reduz 80% do custo de input. Isso é estrutural, não prompt-driven.

---

## Os 3 Pilares da Redução de Custo

### Pilar 1 — CLAUDE.md como Cache de Contexto

Um CLAUDE.md bem estruturado age como cache: concentra o contexto que o agente precisaria buscar em múltiplos arquivos em um único lugar. Em vez de ler `package.json`, `tsconfig.json`, `README.md`, e a estrutura de pastas para entender o projeto, o agente lê um CLAUDE.md que já sintetizou tudo isso.

**Impacto mensurável:** cada sessão sem CLAUDE.md eficiente começa com 5-15K tokens de "exploração de contexto". Com CLAUDE.md bem estruturado, isso cai para 1-3K tokens. Em 100 sessões, a economia é de 1M+ tokens.

**Estrutura de CLAUDE.md para máxima eficiência de cache:**
- Stack em uma linha (não em parágrafo)
- Comandos de build/test/lint explícitos (elimina tentativa-e-erro)
- Estrutura de pastas resumida (elimina exploração de filesystem)
- Convenções críticas (elimina leitura de múltiplos arquivos para inferir padrão)

### Pilar 2 — Nomenclatura AI-Legível no Codebase

Princípio de Karpathy aplicado ao código: nomes de funções, variáveis, e módulos que expressam intenção sem ambiguidade permitem ao agente navegar o codebase com menos leituras.

**Antes (AI-opaco):**
```typescript
// O agente precisa ler o corpo inteiro para entender o que faz
export function proc(d: any, f: boolean): Promise<void>
```

**Depois (AI-legível):**
```typescript
// O agente entende a intenção sem ler o corpo
export function processPaymentWithFraudCheck(
  payment: Payment,
  skipFraudCheck: boolean
): Promise<void>
```

A diferença em tokens: com nomes opacos, o agente precisa ler o corpo da função para entender o contrato. Com nomes descritivos, uma leitura do cabeçalho é suficiente. Em um codebase com 200 funções, isso multiplica.

### Pilar 3 — Princípios Karpathy como Guardrail de Custo

Os 4 princípios de Karpathy não são apenas sobre qualidade — são sobre eficiência de tokens:

**Simplicity First → menos código = menos leitura = menos custo.** Cada abstração desnecessária é tokens extras que o agente precisa processar para entender o que poderia ser expresso diretamente.

**Surgical Changes → menos arquivos tocados = menos verificação = menos custo.** Um agente que toca 30 arquivos por task gasta muito mais tokens em leitura e verificação do que um que toca 3.

**Think Before Coding → menos iterações = menos custo total.** Cada ciclo de "errar e corrigir" custa tokens. Planejar antes reduz o número de ciclos.

**Goal-Driven → critérios objetivos eliminam verificação subjetiva cara.** Sem critérios claros, o agente testa múltiplas abordagens para descobrir o que "parece certo". Com critérios: uma passagem, verifica, termina.

---

## Cálculo de Economia Real

Com Claude Sonnet (~$3/1M tokens input, ~$15/1M tokens output):

**Sessão típica sem otimização:**
- Exploração de contexto: ~15K tokens input
- 5 ciclos de tentativa/erro: ~50K tokens input + ~30K output
- Verificação: ~10K tokens input
- **Total: ~75K input + 30K output = ~$0.225 + $0.45 = ~$0.675/sessão**

**Sessão com otimização Karpathy:**
- Exploração de contexto (CLAUDE.md): ~3K tokens input
- 2 ciclos (plan mode reduz erros): ~20K tokens input + ~15K output
- Verificação: ~5K tokens input
- **Total: ~28K input + 15K output = ~$0.084 + $0.225 = ~$0.309/sessão**

Redução: ~54%. O artigo relata 3x (~67%) com otimização mais agressiva do codebase.

---

## Aplicação Prática: Checklist de Otimização

**Para CLAUDE.md:**
- [ ] Stack tecnológica em < 5 linhas
- [ ] Comandos de build/test/lint explícitos
- [ ] Estrutura de pastas principais (não exaustiva)
- [ ] 3-5 convenções críticas de código
- [ ] O que o agente pode e não pode fazer

**Para o codebase:**
- [ ] Nomes de funções descritivos (verbo + objeto + contexto)
- [ ] Módulos com responsabilidades únicas e bem nomeadas
- [ ] ADRs para decisões não óbvias (evita o agente re-explorar a lógica)
- [ ] Testes com nomes que descrevem o comportamento esperado

**Para workflow:**
- [ ] Plan mode para tasks com >3 arquivos
- [ ] Hooks de validação para fechar loops sem intervenção
- [ ] Slash commands para tasks recorrentes (elimina prompts longos repetidos)

---

## Relação com Outras Técnicas

**Prompt caching (API):** reduz custo de tokens de system prompt repetidos entre chamadas. Complementar à otimização de contexto — atacam camadas diferentes.

**Model selection:** usar Haiku para validação, Sonnet para execução, Opus para planejamento complexo. Reduz custo médio por token sem sacrificar qualidade.

**Context compression (/compact):** comprime contexto longo antes de continuar. Reduz custo das próximas chamadas mas pode perder detalhes importantes. Usar com critério.

A otimização Karpathy é orthogonal a todas essas: atua antes de qualquer chamada à API, reduzindo a quantidade de trabalho que o agente precisa fazer para começar.

---

## Relevância para o Vault-Michel

O vault aplica esses princípios de forma específica:
- `04-SYSTEM/wiki/hot.md` = cache de contexto para agentes (equivalente ao CLAUDE.md rico)
- Naming kebab-case consistente = AI-legível
- Estrutura de pastas documentada em CLAUDE.md = elimina exploração

O próximo ganho seria adicionar ADRs para as decisões de arquitetura do vault (por que `04-SYSTEM/`, por que separar entities de concepts) — eliminando reexploração nesses tópicos em sessões futuras.

---

## Limitações

- A redução de 3x é específica ao contexto do artigo; resultados variam por projeto e tipo de task
- Otimizar o codebase para AI-legibilidade tem custo inicial (renomeação, reorganização) que só se amortiza com uso intensivo de agentes
- CLAUDE.md muito longo pode piorar a eficiência (context window = custo, compliance cai) — há um ponto ótimo que varia por projeto

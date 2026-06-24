---
title: "The Complete Guide to Building Skills for Claude (PDF)"
type: source
source: .raw/ebooks/The-Complete-Guide-to-Building-Skill-for-Claude.pdf
created: 2026-05-17
ingested: 2026-05-17
tags: [ebook, claude, skills, guide]
triagem_score: 9
---

## Tese central
Guia definitivo para construir Claude Skills: anatomia completa (SKILL.md + assets), description como triggering signal primário, fronteira skill vs subagent vs plugin, e ciclo iterativo de criação/teste/refinamento. Referência oficial do ecossistema Cowork.

## Key insights
- **Skill = pasta com SKILL.md + assets referenciados:** estrutura mínima é um arquivo SKILL.md; arquivos adicionais (templates, exemplos, schemas) são referenciados dentro do SKILL.md e carregados sob demanda
- **Description é o gatilho, não o nome:** Claude decide invocar skill com base na description (campo no frontmatter), não no nome da pasta. Description precisa ser específica o suficiente para disparar no contexto certo e vaga o suficiente para não perder casos legítimos
- **Skill vs subagent:** skill é receita executada no contexto principal — Claude lê SKILL.md e segue instruções no mesmo contexto de conversa. Subagent é executor independente com contexto próprio — adequado para tarefas longas que não devem poluir contexto principal
- **Iteração baseada em trigger accuracy:** medir com que frequência skill dispara quando deveria (recall) e quando NÃO deveria (precisão). Refinar description conforme dados reais de uso

## Anatomia completa de uma skill

### Estrutura de pasta

```
skills/minha-skill/
├── SKILL.md          # arquivo principal — instruções e referências
├── template.md       # template de output (referenciado em SKILL.md)
├── exemplos/         # few-shot examples
│   ├── exemplo-1.md
│   └── exemplo-2.md
└── schema.json       # schema de input se aplicável
```

### SKILL.md — estrutura recomendada

```markdown
---
name: Nome da Skill
description: >
  Descrição detalhada de quando invocar esta skill.
  Trigger quando: [lista de situações específicas].
  NÃO trigger quando: [contra-exemplos].
version: 1.0
---

# Instruções

[Instruções detalhadas de execução]

## Input esperado
[O que Claude deve usar como input]

## Output esperado
[Formato e conteúdo do output]

## Referências
@template.md
@exemplos/exemplo-1.md
```

### Description como triggering signal

Errado (vago): `"Ajuda com escrita"`
Certo (específico): `"Invoque quando usuário pedir revisão de código Python em projetos de data science. Não invoque para outros tipos de código ou para escrita de código novo."`

A description vai para o system prompt de seleção de skill. Claude compara a descrição com o contexto atual para decidir se invoca.

## Fronteira skill vs subagent vs plugin

| Dimensão | Skill | Subagent | Plugin |
|----------|-------|----------|--------|
| Contexto | Compartilha com main | Próprio isolado | Próprio |
| Duração | Curta (< 10 min) | Longa (> 10 min) | Variável |
| Output | Retorna para main | Artefato independente | Ferramentas/dados |
| Custo contexto | Alto (polui main) | Baixo (isolado) | Variável |
| Coordenação | Implícita | Explícita via mensagens | Via MCP protocol |

**Regra prática:** se tarefa precisa de mais de 5 tool calls ou vai produzir muito texto intermediário, considerar subagent em vez de skill.

## Ciclo de criação e refinamento

### Fase 1: Definição
1. Identificar problema específico que skill resolve
2. Listar 5-10 exemplos de prompts que deveriam trigger
3. Listar 5 exemplos que NÃO deveriam trigger (contra-exemplos)
4. Escrever description cobrindo casos positivos sem capturar negativos

### Fase 2: Implementação
1. Escrever SKILL.md com instruções claras
2. Criar assets referenciados (templates, exemplos)
3. Testar com cada exemplo da lista da Fase 1

### Fase 3: Calibração
1. Usar skill por 1-2 semanas em uso real
2. Anotar: quando disparou correto, quando não disparou devendo, quando disparou errado
3. Ajustar description com base nos dados
4. Repetir até trigger accuracy > 90% nos casos-alvo

## Armadilhas comuns

- **SKILL.md muito longo:** Claude ignora seções no meio. Regra: < 200 linhas. Se precisar mais, separar em múltiplos assets referenciados
- **Lógica condicional complexa:** skill não é código. Lógica condicional pertence a código externo chamado pela skill. SKILL.md deve ter instruções, não algoritmos
- **Skill que faz tudo:** trigger nunca é preciso. Uma skill focada com alta trigger accuracy supera skill genérica com trigger aleatório

## Padrões 2026 para estudar

- `anthropic-skills/` — padrão oficial, referência para estrutura canônica
- `claude-obsidian/` — skills de vault, exemplos de especialização de domínio
- `productivity/` — skills de gestão de tempo e tarefas, bons exemplos de description precisa

## Checklist de qualidade de skill

Antes de considerar skill pronta:
- [ ] Description tem exemplos de trigger E contra-exemplos explícitos
- [ ] SKILL.md tem menos de 200 linhas
- [ ] Testada com 5 prompts que deveriam trigger — todas triggeram
- [ ] Testada com 3 prompts que não deveriam trigger — nenhuma triggera
- [ ] Assets referenciados existem e são carregados corretamente
- [ ] Skill faz exatamente 1 coisa bem

## Evolução de skill ao longo do tempo

Skills não são artefatos estáticos. Boas práticas de manutenção:

**Versioning:** manter `version` no frontmatter do SKILL.md. Incrementar quando description ou instruções mudam significativamente.

**Changelog interno:** seção no SKILL.md documentando o que mudou e por quê — especialmente útil para skills complexas com histórico de iterações.

**Deprecação limpa:** quando skill é substituída por versão melhor, manter arquivo antigo com nota de depreciação por 2 semanas antes de deletar. Evita confusão se Claude ainda indexou a versão antiga.

## Links
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/learning-cognition/skill-development]]
- [[03-RESOURCES/concepts/claude-code-tooling/skillify]]

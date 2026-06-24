---
title: "wilwaldon/Claude-Code-Frontend-Design-Toolkit"
type: source
source: Clippings/wilwaldonClaude-Code-Frontend-Design-Toolkit Everything I've found that actually makes Claude Code output better-looking frontends. Skills, plugins, MCP servers, CLAUDE.md tricks.md
created: 2026-05-17
ingested: 2026-05-17
tags: [claude-code, frontend, toolkit, github]
triagem_score: 8
---

## Tese central
Toolkit curado de skills, plugins, MCPs, e CLAUDE.md tricks que provadamente melhoram output frontend do Claude Code — coleção operacional, não teórica. Wilwaldon compila o que efetivamente funciona em uso real, eliminando o que soa bem mas não entrega.

## Key insights
- **Skills frontend-design + brand-guidelines + theme-factory:** stack de três skills complementares que cobre respectivamente: estrutura e layout de componentes, consistência visual de marca, e sistema de tokens de design (cores, tipografia, espaçamento)
- **CLAUDE.md tricks para consistência:** regras prescritivas no CLAUDE.md reduzem variância de design — sem regras, Claude escolhe componentes e estilos diferentemente a cada geração. Regras como "sempre usar Tailwind v3, nunca inline styles, componentes shadcn quando disponível" criam output previsível
- **MCP server para componentes:** injetar catálogo de componentes real (shadcn/ui, Radix, Figma designs) como contexto permite Claude gerar código que usa componentes existentes em vez de reimplementar do zero
- **Coleção operacional:** wilwaldon faz commit real de código — "everything I've found that actually works". Filtrado por uso real, não por potencial teórico

## Stack completo do toolkit

### Skills do Claude Code

**frontend-design skill:**
- Princípios de layout e estrutura de componente
- Quando usar flex vs grid, composição de layouts responsivos
- Hierarquia visual: o que é primário, secundário, terciário
- Acessibilidade mínima (aria-labels, contraste, keyboard nav)

**brand-guidelines skill:**
- Cores (primária, secundária, neutras, feedback) com hex/HSL
- Tipografia: família, pesos, tamanhos por uso (heading, body, caption, code)
- Iconografia: biblioteca preferida e convenções de uso
- Tom visual: minimalista, expressivo, corporativo, etc.

**theme-factory skill:**
- Gerar design tokens consistentes a partir de brand-guidelines
- Integração com Tailwind config ou CSS custom properties
- Dark mode: estratégia de inversão de tokens
- Componente library setup inicial com tema

### CLAUDE.md tricks eficazes

```markdown
## Frontend Rules

### Stack
- Framework: Next.js 14 (App Router)
- Styling: Tailwind CSS v3 (nunca inline styles, nunca style= exceto animações JS)
- Componentes: shadcn/ui primeiro, custom components apenas quando shadcn não cobre

### Component conventions
- Cada componente em arquivo próprio com named export
- Props sempre tipadas com interface TypeScript
- Nunca useState para estado derivado — usar useMemo
- Formulários: react-hook-form + zod

### Design patterns
- Layout: CSS Grid para page-level, Flexbox para component-level
- Spacing: apenas valores do Tailwind spacing scale (nunca px arbitrários)
- Colors: apenas do design token file — nunca hardcoded

### Code quality
- Zero console.log em componentes (usar logger service)
- Comentários apenas para lógica não-óbvia
```

Regras prescritivas reduzem variância porque Claude segue instruções explícitas com alta fidelidade.

### MCP servers úteis para frontend

**shadcn MCP server:**
Lista todos os componentes disponíveis com suas props e exemplos. Claude pode selecionar componente correto para o caso de uso em vez de adivinhar ou reimplementar.

**Figma MCP server:**
Lê designs do Figma e extrai tokens (cores, tipografia, espaçamento) como contexto. Claude gera código que implementa o design existente, não uma interpretação.

**Storybook MCP server:**
Acessa stories existentes — Claude vê como componentes são usados no projeto atual. Garante consistência com padrões estabelecidos da codebase.

## Por que output frontend de LLMs é inconsistente sem toolkit

### Problema raiz: LLM não tem estado visual

Sem contexto de design, Claude gera:
- Turno 1: botão com rounded-lg e shadow-sm
- Turno 2: botão com rounded-md e border
- Turno 3: botão com rounded-full e bg-blue-500

Três estilos de botão diferentes. Visualmente fragmentado. Correção requer instrução explícita a cada turno — custo cognitivo alto.

### Skills e CLAUDE.md como memória de design

Skills injetam contexto de design no início de cada contexto. CLAUDE.md define regras que persistem. Resultado: Claude "lembra" o design system em cada geração sem instrução repetida.

## Resultados reportados

Wilwaldon reporta (com screenshots) que o toolkit elimina:
- Inconsistência de espaçamento (spacing scale forçado via regra)
- Reimplementação de componentes disponíveis (shadcn MCP)
- Estilos em conflito com brand (brand-guidelines skill)

Melhoria estimada: de ~60% de outputs usáveis sem ajuste para ~85% de outputs usáveis diretamente.

## Aplicação ao vault-michel

Para interfaces geradas no vault (dashboards Obsidian, relatórios HTML), aplicar:
- CLAUDE.md com regras de output visual consistente
- Brand guidelines simples (paleta de cores do vault, tipografia)
- Preferência de formato e estrutura de output

## Por que CLAUDE.md tricks superam prompts ad-hoc

**Prompts ad-hoc:** "use Tailwind para isso, componentes shadcn para aquilo, estilo minimalista" — esquecidos a cada nova sessão, inconsistentes entre contextos, custo cognitivo alto de lembrar a cada task.

**CLAUDE.md rules:** injetadas automaticamente em todo contexto do projeto, persistentes, sem custo cognitivo. Uma vez bem escritas, funcionam indefinidamente sem atenção ativa.

O toolkit de wilwaldon demonstra que ~20 linhas de CLAUDE.md com regras de frontend eliminam a maioria das inconsistências — ROI muito maior que qualquer skill ou plugin individual.

## Evolução do toolkit

wilwaldon atualiza o repositório regularmente conforme:
- Novas skills são criadas pela comunidade Cowork
- Novos MCP servers de design ficam disponíveis
- Claude Code evolui com novas capacidades de geração de UI
- Stack de frontend muda (ex: adoção de React Server Components, Tailwind v4)

Recomendação: monitorar o repositório e re-ingeri-lo semestralmente para capturar atualizações relevantes. Marcar como source de alta frequência de atualização no manifest.

## Links
- [[03-RESOURCES/concepts/claude-code-tooling/claude-design]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-md-cost-optimization]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]

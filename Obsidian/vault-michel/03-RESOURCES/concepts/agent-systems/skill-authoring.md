---
title: Skill Authoring
type: concept
created: 2026-06-06
updated: 2026-06-06
tags: [agent-systems, skills, prompt-engineering, evaluation-driven-development]
---

# Skill Authoring

Conjunto de decisões práticas — não conceituais — sobre como escrever uma boa Skill. Fonte normativa: [[03-RESOURCES/sources/skill-authoring-best-practices]] (doc oficial Anthropic). Complementa [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]] (que documenta os "6 componentes de produção": Frontmatter, Trigger, Role, Process, Format, Examples) com a camada de **como escrever bem** cada um deles.

## Tese central

**"Claude já é muito inteligente — só adicione contexto que ele não tem."** Toda boa prática de autoria deriva dessa frase. O context window é bem público compartilhado entre system prompt, histórico, metadata de outras Skills (potencialmente 100+) e o pedido do usuário — cada token de uma Skill compete por espaço e deve justificar seu custo. Teste de qualidade nº 1: "Claude realmente precisa dessa explicação?"

## Graus de liberdade (framework de 3 níveis)

A especificidade das instruções deve casar com a fragilidade da tarefa:

- **Alta liberdade** (texto/heurísticas) — múltiplas abordagens válidas, decisão depende de contexto. Ex.: processo de code review em passos genéricos.
- **Média liberdade** (pseudocódigo/scripts parametrizados) — existe padrão preferido, alguma variação é aceitável. Ex.: `generate_report(data, format, include_charts)`.
- **Baixa liberdade** (scripts exatos, sem parâmetros) — operação frágil, consistência crítica, sequência específica obrigatória. Ex.: "rode exatamente `migrate.py --verify --backup`. Não modifique."

Analogia: Claude como robô explorando caminho — "ponte estreita com penhascos" pede instruções exatas (baixa liberdade); "campo aberto" pede direção geral (alta liberdade). Framework generaliza além de Skills — útil para CLAUDE.md, agentes, system prompts de subagentes: quanto mais frágil/sequencial, menor a liberdade a dar.

## Frontmatter — regras precisas

- `name`: máx. 64 caracteres, só minúsculas/números/hífens, sem tags XML, **sem palavras reservadas "anthropic"/"claude"**. Convenção: gerúndio (`processing-pdfs`, `analyzing-spreadsheets`); aceitável frase nominal (`pdf-processing`) ou orientada a ação (`process-pdfs`). Evitar: vago (`helper`, `utils`), genérico (`documents`, `data`), inconsistente dentro da coleção.
- `description`: não-vazio, máx. 1024 caracteres, sem tags XML, **sempre terceira pessoa** ("Processes Excel files...", nunca "I can help you..."/"You can use this to..."). Deve cobrir O QUE faz E QUANDO usar — Claude usa esse campo para escolher entre 100+ Skills disponíveis. Evitar vago: "Helps with documents", "Does stuff with files".

## Estrutura e organização

- SKILL.md funciona como **sumário/table-of-contents**: corpo abaixo de 500 linhas, divide em arquivos quando se aproxima do limite.
- **3 padrões de organização**: (1) guia de alto nível com referências (SKILL.md → FORMS.md/REFERENCE.md sob demanda); (2) organização por domínio (`reference/finance.md`, `reference/sales.md` — carrega só o relevante); (3) detalhes condicionais (básico inline, avançado linkado).
- **Referências em 1 nível só**: todos os arquivos de referência devem linkar diretamente do SKILL.md — referências aninhadas geram leituras parciais (`head -100`) e informação incompleta. Arquivos >100 linhas devem ter table of contents no topo.
- **Workflows como checklists copiáveis**: quebrar operações complexas em passos marcáveis (`- [ ] Step 1: ...`). Padrão recorrente de alta qualidade: **rodar validador → corrigir → repetir**.

## Diretrizes de conteúdo

- **Evitar informação sensível ao tempo**: nunca "antes de agosto de 2025 use X" (envelhece mal) — usar seção "Old patterns" recolhível (`<details><summary>Legacy v1 (deprecated 2025-08)</summary>`) para preservar contexto histórico sem poluir.
- **Terminologia consistente**: escolher um termo e manter ("API endpoint" sempre, nunca alternar com "URL"/"route"/"path").
- **Anti-padrões**: caminhos estilo Windows (sempre `/`, mesmo no Windows); opções demais ("pypdf, ou pdfplumber, ou PyMuPDF..." confunde — preferir default + escape hatch: "use pdfplumber; para PDFs escaneados, pdf2image+pytesseract").

## Skills com código executável

- **Resolver, não empurrar pra Claude** ("solve, don't punt"): tratar erros explicitamente (`process_file` cria default em vez de lançar `FileNotFoundError`).
- **Sem "voodoo constants"** (Lei de Ousterhout): todo valor de configuração deve ser justificado e comentado — `REQUEST_TIMEOUT = 30  # HTTP requests typically complete within 30s` é bom; `TIMEOUT = 47  # Why 47?` é ruim. "Se você não sabe o valor certo, como Claude vai saber?"
- **Padrão plan-validate-execute**: para operações complexas/destrutivas, gerar plano estruturado intermediário (`changes.json`), validar via script, só então executar (`analyze → plan → validate → execute → verify`). Pega erros cedo, é verificável por máquina, reversível, debugável. Usar em: lote, mudanças destrutivas, regras de validação complexas.
- **Dependências**: listar pacotes no SKILL.md e verificar disponibilidade — Claude API não tem acesso a rede/runtime install.
- **Ferramentas MCP sempre com nome qualificado**: `ServerName:tool_name` (ex.: `BigQuery:bigquery_schema`) — sem prefixo, Claude pode não localizar a ferramenta entre múltiplos servidores.

## Avaliação antes de documentação (evaluation-driven development)

Inverte a ordem intuitiva — testar antes de escrever, em 5 passos: (1) identificar lacunas rodando Claude sem a Skill, (2) criar 3 cenários de avaliação, (3) medir baseline, (4) escrever instruções mínimas, (5) iterar comparando com baseline. Evita o anti-padrão mais comum: Skills que documentam problemas imaginados em vez de resolver lacunas reais observadas.

## Ciclo "Claude A / Claude B"

Padrão de meta-agência: uma instância ("Claude A") cria/refina a Skill, outra ("Claude B") testa em tarefas reais, observação volta para A. Funciona porque "Claude models understand both how to write effective agent instructions and what information agents need" — argumento direto a favor de usar o próprio Claude Code para escrever/revisar skills do vault, em vez de autoria manual. Sinais a observar ao iterar: caminhos de exploração inesperados, conexões perdidas, dependência excessiva de seções, conteúdo nunca acessado.

## Checklist "Effective Skills" (rubrica de QA — 18 itens)

**Core quality (10):** description específica com termos-chave · description cobre o quê + quando · corpo <500 linhas · detalhes em arquivos separados · sem informação sensível ao tempo · terminologia consistente · exemplos concretos não abstratos · referências em 1 nível · progressive disclosure apropriado · workflows com passos claros.

**Code & scripts (8):** scripts resolvem em vez de empurrar pra Claude · tratamento de erro explícito · sem voodoo constants · pacotes listados e verificados · scripts documentados · sem caminhos estilo Windows · validação/verificação em operações críticas · feedback loops em tarefas quality-critical.

Rubrica pronta para auditar os ~40 skills do vault em `04-SYSTEM/skills/` (ex.: via [[04-SYSTEM/agents/core/audit-agentes-mensal]]).

## Por que importa

- Era a peça normativa que faltava — [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]] descrevia os componentes em alto nível; este concept fecha com "como escrever bem" cada um.
- Framework de graus de liberdade e o checklist QA generalizam além de Skills — aplicáveis a CLAUDE.md, agentes `04-SYSTEM/agents/`, prompts de subagentes.
- Ciclo Claude A/Claude B valida formalmente o workflow que o vault já usa informalmente ao pedir ao Claude Code para escrever/revisar suas próprias skills.

## Related
- [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]]
- [[03-RESOURCES/sources/skill-authoring-best-practices]]
- [[03-RESOURCES/sources/extend-claude-with-skills]]
- [[03-RESOURCES/sources/skills]]

## Evidências
- **[2026-06-19]** Como Skills são apenas arquivos, melhoria = gerar diff no arquivo da Skill com base no texto de justificativa de correção humana — [[03-RESOURCES/sources/how-to-build-a-self-improvement-loop-for-skills]]
- **[2026-06-19]** Taxonomia formal user-invoked vs model-invoked para Skills do Claude Code (mattpocock-skills 1.0.0); user-invoked nunca chama outra user-invoked — [[03-RESOURCES/sources/release-mattpocock-skills-1-0-0]]

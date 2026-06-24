---
title: "How One File Called CLAUDE.md Turns Claude from a Search Engine into a Second Employee"
type: source
source: "Clippings/How One File Called CLAUDE.md Turns Claude from a Search Engine into a Second Employee.md"
source_url: "https://x.com/hanakoxbt/status/2059956659951149275"
author: "@hanakoxbt"
published: 2026-05-28
created: 2026-05-29
ingested: 2026-05-29
tags: [ai-agents, claude-md, context-engineering, workflow, second-employee, claude-code]
---

## Tese central

99% dos usuários do Claude usam como search engine com gramática melhor — pergunta, resposta, repete, sem memória, sem contexto, sem sistema. CLAUDE.md transforma Claude de estranho inteligente (que você re-explica tudo toda manhã) em funcionário que leu o manual no primeiro dia e nunca precisa ser dito duas vezes. A vantagem é estrutural, não de inteligência ou acesso — você tem o mesmo modelo que Boris Cherny tem.

## Argumentos principais

- **O problema de 99% dos usuários:** sem memória, sem contexto, sem sistema. Pagando $20/mês por um search engine com boa gramática. Começando do zero toda sessão.
- **Quem já descobriu isso:**
  - Boris Cherny (criador do Claude Code): roda milhares de agents à noite pelo telefone
  - Engineering leads da Anthropic: disseram a Dario Amodei que não escrevem mais código
  - Claude Cowork: construído em semana e meia pelo próprio Claude
- **O que CLAUDE.md é:** arquivo de texto simples no root de qualquer pasta de projeto. Toda vez que Claude Code abre aquela pasta, lê este arquivo primeiro. Antes do código. Antes do prompt. Antes de qualquer coisa.
- **A distinção crítica — prompting vs. infraestrutura:**
  - Prompting é uma conversa. Conversas terminam. Contexto desaparece.
  - CLAUDE.md é infraestrutura. Persiste. Composta.
  - "Without CLAUDE.md, Claude is a smart stranger you re-explain everything to every morning. With CLAUDE.md, Claude is an employee who read the handbook on day one and never needs to be told twice."
- **Exemplo concreto (content creator):** Sem CLAUDE.md: "Write me a post about AI. Make it punchy. No fluff." Digitado toda vez. Às vezes Claude dá slop corporativo porque você esqueceu de dizer "no buzzwords." Com CLAUDE.md (escrito uma vez):
  ```
  You are my content strategist.
  My style: direct, specific, zero fluff.
  Short paragraphs. Bold claims backed by numbers.
  Never use: leverage, utilize, game-changer, deep dive.
  Default length: under 250 words unless I say otherwise.
  When I say "draft", produce a complete piece, not an outline.
  When I say "edit", cut ruthlessly.
  ```
  Cada sessão herda essas regras automaticamente.
- **Como construir em 15 minutos (5 seções):**
  1. **Role:** Diga ao Claude o que ele é. Não "assistente útil." Específico. "You are my investment research analyst. You are not a chatbot. You are a workflow operator."
  2. **Style:** "Be concise. No preamble. Bullet points over paragraphs. Specific numbers over vague statements."
  3. **Constraints:** "Never invent data. Never reformat files without asking. Never commit code without running tests."
  4. **Workflow:** Procedimentos específicos. "When I drop a file in raw/, process it: 1. Read it. 2. Identify the topic. 3. Write a summary with key takeaways. 4. File it correctly. 5. Update the index."
  5. **Quality:** "Before delivering any output: verify claims include sources, check formatting matches templates, remove filler phrases."
- **Não precisa de Claude Code para começar:** Claude Projects em claude.ai tem o mesmo conceito como "Project System Prompt." CLAUDE.md é a versão para Claude Code (persistência em arquivo local).
- **O efeito composto semana a semana:**
  - Semana 1: Claude para de dar output genérico. Cada resposta corresponde ao estilo e constraints.
  - Semana 2: você adiciona regras ao notar padrões. CLAUDE.md cresce de 10 linhas para 40.
  - Semana 3: CLAUDE.md diferentes para projetos diferentes (content, research, code). Cada um torna Claude um especialista.
  - Semana 4: você para de pensar em Claude como chatbot. Você dá tarefas e vai embora. Output corresponde aos padrões porque os padrões estão no rulebook.
- **A hierarquia que a maioria erra:**
  - Pensamento errado: melhores prompts → melhor output
  - Caminho real: **melhor setup do sistema → melhores prompts → dramaticamente melhor output**
  - "CLAUDE.md is the system setup. Without it, you are optimizing prompts on top of nothing. With it, even a lazy prompt produces good output because the rules are already in place."
- **O que Boris Cherny descobriu:** Seus agents não são mais inteligentes. Eles têm instruções melhores.

## Key insights

- CLAUDE.md é infraestrutura, não prompt. A distinção muda como você pensa sobre AI use.
- O mesmo modelo, com contexto diferente, produz resultados ordens de magnitude diferentes.
- O melhor uso de CLAUDE.md não é para Claude Code — é o padrão subjacente que torna qualquer interação com Claude persistente e especializada.
- O setup é 15 minutos. O efeito composto é permanente.
- Multiple CLAUDE.md files para múltiplos projetos = especialistas separados para cada domínio de trabalho.
- "Better system setup → better prompts → dramatically better output" — a hierarquia esquecida.
- Referência a Boris Cherny como quem primeiro sistematizou isso internamente na Anthropic.

## Exemplos e evidências

- Boris Cherny: milhares de agents rodando à noite pelo telefone.
- Anthropic engineering leads: "não escrevemos mais código."
- Claude Cowork: construído em semana e meia pelo próprio Claude com sistema bem configurado.
- Exemplo de conteúdo: CLAUDE.md de content creator com 7 regras específicas → output sempre no estilo correto sem re-explicação.
- Crescimento de CLAUDE.md: de 10 linhas (semana 1) para 40 linhas (semana 2) conforme padrões emergem.

## Implicações para o vault

- Valida diretamente a filosofia do vault-michel: o CLAUDE.md como "firmware" do vault é o que separa uso productivo de uso genérico.
- O modelo de "múltiplos CLAUDE.md para múltiplos projetos" espelha a arquitetura do vault: agents com prompts específicos para domínios (finance, code, concurso, etc.).
- A hierarquia "sistema → prompts → output" explica por que o `04-SYSTEM/agents/` é o investimento mais alto-leverage do vault.
- Seção de **Quality** (verificar claims, checar formatação, remover fillers) é exatamente o que o `verify` agent faz.
- Seção de **Workflow** (processar raw/) é exatamente o que o `ingest-report` agent faz.

## Links

- [[03-RESOURCES/entities/Boris-Cherny]]
- [[03-RESOURCES/entities/Claude Code]]
- [[03-RESOURCES/entities/Claude-Cowork]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/claude-code-tooling/goal-command]]
- [[03-RESOURCES/concepts/claude-code-tooling/claudemd-self-improvement-loop]]
- [[03-RESOURCES/sources/guides-courses-howtos/claude-code-investment-research-analyst]]

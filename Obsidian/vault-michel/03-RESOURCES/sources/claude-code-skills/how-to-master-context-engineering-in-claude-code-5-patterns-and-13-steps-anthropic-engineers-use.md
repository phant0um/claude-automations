---
title: "How to Master Context Engineering in Claude Code: 5 Patterns and 13 Steps Anthropic Engineers Use"
type: source
source: "Clippings/How to Master Context Engineering in Claude Code 5 Patterns and 13 Steps Anthropic Engineers Use.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Sessões longas no Claude Code falham não por limitação do modelo, mas por má gestão do contexto — o que entra no contexto. A equipe do Claude Code usa um sistema de 5 padrões e 13 passos para controlar o que o modelo vê, reduzindo o uso de contexto em 50-70% e eliminando as falhas por overflow. Context engineering é uma disciplina ativa, não algo que o modelo gerencia sozinho.

## Argumentos principais

- **A maioria do contexto é ruído**: Claude lê milhares de linhas por sessão, mas 95% é irrelevante. Quando o ruído domina (por volta de 70% de uso), o modelo começa a inventar funções e corrigir bugs que nunca existiram.
- **CLAUDE.md em três camadas**: root (regras de projeto), subdirectory (regras de módulo), `~/.claude/CLAUDE.md` (preferências pessoais). As três se acumulam — global + projeto + módulo — sem re-upload a cada prompt.
- **Referências cirúrgicas via @arquivo**: descrever arquivos em prosa força o Claude a buscar e ler 4-5 candidatos errando metade das vezes. Referenciar diretamente com `@src/auth/session.ts` carrega exatamente aquele arquivo.
- **`/focus` para escopo de sessão**: restringir o scope a pastas específicas reduz uso de contexto em 60-80% em tarefas focadas — o Claude para de ler arquivos "úteis" não relacionados.
- **Compact-and-continue**: `/compact` com instruções de preservação (não apenas resumo genérico) é a forma de rodar sessões longas sem crash. `/stats` para monitorar; acima de 85% o Claude já descarta mensagens antigas silenciosamente.
- **`/resume` para sessões de vários dias**: `claude --resume [session-id]` ou `claude --continue` — o estado compactado é preservado entre sessões.
- **Plan mode antes de tarefas de risco**: Shift+Tab coloca o Claude em modo leitura-apenas, onde ele explica o que faria e lista cada arquivo antes de executar. "Um read, um edit" vs. "read 8, edit 3 errado, reverter, reler, editar de novo."
- **Plan mode obrigatório via hooks**: `PreToolUse` com matcher em paths críticos (`src/auth/**`, `migrations/**`) impede edições sem aprovação prévia de plano.
- **Subagentes com surface mínima**: um `code-reviewer` não precisa de Write ou Edit; um `doc-updater` não precisa de Bash. Menos surface = menos contexto queimado em descrições de ferramentas irrelevantes.
- **Passar apenas referências necessárias para subagentes**: "review the recent changes" é ambíguo e caro. "review @src/auth/session.ts" é exato.
- **Modelos mais baratos para subagentes**: Sonnet para review/testes, Haiku para doc updates/lints, Opus apenas para arquitetura ou audits de segurança. `export CLAUDE_CODE_SUBAGENT_MODEL="claude-sonnet-4-6"` para configurar globalmente.

## Key insights

- **O maior vazamento de contexto é editar antes de entender**: Plan mode força leitura primeiro, escrita depois — eliminando o ciclo de "editar errado, reverter, reler".
- **70% de uso é a zona de perigo; 85% é silenciosamente destrutivo**: o Claude descarta mensagens antigas sem avisar quando passa de 85%. Monitorar com `/stats` é prática de higiene essencial.
- **`/compact preserve: [lista específica]` é diferente de `/compact` genérico**: preservar o plano atual, decisões sobre refatoração específica, e output de testes com falha — em vez de um resumo genérico que perde nuances críticas.
- **Subagentes são a forma mais limpa de manter o contexto principal pequeno**: cada subagente roda em janela própria, o parent nunca vê o ruído. Esta é a fundamentação arquitetural de por que multi-agent reduz custos além de aumentar paralelismo.
- **Modelos mais baratos para subagentes = mais chamadas por dólar = mais isolamento**: a lógica econômica de tiering de modelos é também uma lógica de qualidade — mais isolamento de contexto por menos dinheiro.
- **O sistema leva 30 minutos para configurar**: 10min root CLAUDE.md, 5min subdirectory CLAUDE.md, 5min `~/.claude/CLAUDE.md`, 5min uma skill, 5min muscle memory Shift+Tab. "By session 5 the patterns become reflex, and you stop hitting the limit at all."
- **Descrições em prosa para arquivos são o caminho mais lento e impreciso**: a diferença entre "look at the user authentication code" e "@src/auth/session.ts" é a diferença entre buscas desnecessárias e carregamento cirúrgico.

## Exemplos e evidências

- **Redução de 60-80% no uso de contexto** com `/focus` em tarefas focadas — dado empírico de uso do time interno do Claude Code.
- **50-70% menos contexto** para a mesma quantidade de trabalho após aplicar o sistema de 5 padrões — prometido para a "próxima sessão".
- **Pattern 5 exemplo de configuração YAML** para `code-reviewer` com tools: Read, Grep, Glob apenas — sem Write, Edit, Bash.
- **Configuração de hook** para lock de plan mode em `src/auth/**` e `migrations/**` via `.claude/settings.json`.
- **CLAUDE.md root template completo**: Stack (runtime, framework, database, testing), Conventions (imports, components, tests, commits), Don't touch (infra/terraform, migrations, vendor), Defaults (npm test, tsc --noEmit, Prettier).
- **Starter de 30 minutos**: sequência específica para implementar o sistema completo.

## Implicações para o vault

- Formaliza a prática de CLAUDE.md em camadas — o vault-michel já usa este padrão no `CLAUDE.md` raiz + instruções por agente. Este source confirma que é prática oficial da equipe Anthropic.
- O conceito de "context engineering como disciplina ativa" é complementar ao conceito de skills como memória procedimental.
- `/compact preserve:` com lista específica é uma técnica diretamente aplicável ao trabalho diário com o vault — preservar hot.md, decisões de estrutura, estado de ingestão.
- O model tiering para subagentes (Haiku/Sonnet/Opus por complexidade) é uma prática de custo que o vault-michel pode adotar nos pipelines de agentes.
- Confirma e expande [[03-RESOURCES/concepts/ai-agents/context-engineering]].

## Links

- [[03-RESOURCES/concepts/ai-agents/context-engineering]]
- [[03-RESOURCES/concepts/ai-agents/agent-skills]]
- [[03-RESOURCES/concepts/ai-agents/multi-agent-orchestration]]
- [[03-RESOURCES/sources/every-agentic-engineering-hack-i-know-june-2026]]
- [[03-RESOURCES/sources/how-to-run-100-agents-in-parallel-in-claude-code-full-playbook]]

---
title: "Every Company's First AI Strategy Should Be a Skill Library"
type: source
source: "Clippings/Every Company's First AI Strategy Should Be a Skill Library.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, skill-library, enterprise-ai, institutional-knowledge, ai-strategy]
---

## Tese central

O conhecimento institucional de uma empresa — os padrões de trabalho dos melhores funcionários, o julgamento não documentado, as heurísticas acumuladas — está prestes a se tornar infraestrutura. Skills de IA são o mecanismo para capturar e tornar reutilizável esse conhecimento operacional, indo além do simples acesso a dados para codificar o método por trás do trabalho.

## Argumentos principais

- Acesso a dados (CRM, Slack, Drive, GitHub, data warehouse) é a parte fácil e insuficiente: um agente pode ler todas as notas de vendas e ainda não capturar o formato de um deal bem-sucedido. O desafio é transmitir como a empresa aborda o trabalho, não expandir acesso.
- Uma skill não é um prompt — é uma maneira reutilizável de trabalhar, capturando etapas, julgamento, edge cases e quality bar. Pode incluir instruções, exemplos, templates, checklists, scripts, referências e rules of thumb.
- A evolução: Data → Connectors → Skills → Plugins (conectores que executam ações, não só leem). Cada camada adiciona capacidade mas também complexidade de governança.
- Conhecimento institucional tratado como "background" (experiência, taste, julgamento) está prestes a ser explicitado como infraestrutura. Quem fizer isso primeiro tem vantagem estrutural.
- A plataforma Anthropic usa uma pasta com SKILL.md e arquivos de suporte; outros sistemas terão seus próprios formatos, mas o conceito é portável.

## Key insights

- A skill para sales call prep pode capturar: como ler histórico de conta, quais riscos surfacear, como formatar perguntas abertas, como é um brief útil — traduzindo o padrão do melhor vendedor em algo replicável.
- A distinção crítica: a skill codifica o método, não apenas o output desejado. É por isso que skills são superiores a prompts one-shot para trabalho recorrente.
- Plugins são a próxima fronteira: connectors que executam ações (criar ticket, enviar email, atualizar registro) não apenas lêem dados — transformam agentes de leitores em operadores.
- O risco de knowledge institutionalized via IA é que pode também institutionalizar vieses e pressupostos implícitos que antes eram questionados individualmente.

## Exemplos e evidências

- Exemplos de domínio: sales call prep, incident postmortems, board deck building — cada um com método específico que vai além do acesso a dados.
- O autor (Hiten Shah, @hnshah) está promovendo um evento "Skills 101" para ensinar o framework prático.
- A Anthropic usa pasta com SKILL.md e arquivos de suporte como formato técnico para skills no Claude Code.

## Implicações para o vault

Valida diretamente a arquitetura de skills do vault (`04-SYSTEM/skills/`) como estratégia de AI certa. A ideia de "conhecimento institucional como infraestrutura" é exatamente o que o vault faz ao codificar processos em CLAUDE.md e skills. A progressão Data → Connectors → Skills → Plugins descreve a trajetória de maturidade do vault — atualmente em Skills, com MCP como bridge para Plugins.

## Links

- [[03-RESOURCES/concepts/ai-agents/claude-code-skills]]
- [[03-RESOURCES/concepts/ai-agents/institutional-knowledge-as-infrastructure]]
- [[04-SYSTEM/skills]]

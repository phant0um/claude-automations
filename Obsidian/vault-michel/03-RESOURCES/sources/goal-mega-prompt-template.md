---
title: "The /goal Mega Prompt"
type: source
tags: [goal-command, prompt-template, claude-code, codex, agentic]
ingested: 2026-05-14
source_file: gemini-code-1778768022644.md
---

# The /goal Mega Prompt

*Para Claude Code ou Codex — agentes que rodam por horas com zero hand-holding.*

## Template Completo

```
/goal [O RESULTADO FINAL — o que significa "pronto" em uma linha]

— CONTEXT —
- Project: [o que você está construindo]
- Stack: [linguagens, frameworks, infraestrutura]
- Current state: [o que já existe hoje no projeto]
- Working dir: [caminho da pasta ou repositório]
- Constraints: [orçamento, tempo, itens fora de cogitação]
- Audience: [para quem este projeto se destina]

— SUCCESS CRITERIA (ALL MUST BE TRUE) —
1. [Resultado específico e mensurável 1]
2. [Resultado específico e mensurável 2]
3. [Resultado específico e mensurável 3]
4. O entregável final deve rodar sem erros.
5. Você deve apresentar provas (screenshot, output de teste ou URL).

— OPERATING RULES - NON-NEGOTIABLE —
1. PLAN FIRST: Apresente uma lista de tarefas numeradas antes de escrever qualquer código.
2. WORK AUTONOMOUSLY: Não faça perguntas de esclarecimento, a menos que esteja genuinamente bloqueado.
3. SELF-VERIFY: Após cada passo, rode testes, inspecione o output e confirme que funcionou.
4. DEBUG YOURSELF: Se algo falhar, diagnostique e corrija. Não devolva o erro para o usuário.
5. USE EVERY TOOL: Use MCPs, terminal, busca web e execução de código para puxar dados reais.
6. NO PLACEHOLDERS: Sem comentários "TODO", stubs ou funções vazias. Use componentes e estados reais.
7. PROGRESS LOG: Rastreie tarefas completadas, em andamento, decisões tomadas e bloqueios.
8. STAY ON GOAL: Descobertas fora do escopo? Note-as e continue focado no objetivo principal.
9. IF BLOCKED: Registre o problema e continue em tudo que puder ser feito em paralelo.
10. CHECK SUCCESS BEFORE STOPPING: Releia os critérios de sucesso e confirme que cada um foi atendido.

— QUALITY BAR —
- Code: Limpo, tipado e seguindo as convenções do projeto.
- Design: Deve parecer que uma startup bem financiada o enviou.
- Output: Deve sobreviver a uma revisão de código de um desenvolvedor sênior.
- Docs: Cada novo padrão, variável de ambiente ou decisão deve ser logada.

— FINAL DELIVERABLE —
- Confirmação de que cada critério de sucesso foi satisfeito.
- Lista de cada arquivo criado ou modificado.
- Instruções de como rodar, testar e fazer o deploy.
- Provas de funcionamento (screenshot, logs de teste, URL).
- Decisões tomadas e qualquer observação importante.
- Limitações conhecidas e próximos passos recomendados.
```

## As 10 Operating Rules (não-negociáveis)

| # | Regra | Propósito |
|---|-------|-----------|
| 1 | PLAN FIRST | Evita execução prematura sem compreensão |
| 2 | WORK AUTONOMOUSLY | Elimina loop de perguntas desnecessárias |
| 3 | SELF-VERIFY | Valida cada passo antes de avançar |
| 4 | DEBUG YOURSELF | O erro nunca volta para o usuário |
| 5 | USE EVERY TOOL | Dados reais > dados inventados |
| 6 | NO PLACEHOLDERS | Zero código fake ou stubs |
| 7 | PROGRESS LOG | Rastreabilidade de decisões |
| 8 | STAY ON GOAL | Scope creep cortado automaticamente |
| 9 | IF BLOCKED | Paralelismo em vez de paralisia |
| 10 | CHECK SUCCESS BEFORE STOPPING | Auto-avaliação final antes de entregar |

## Compatibilidade

Funciona em: **Claude Code**, **Codex** (OpenAI), qualquer agent CLI que aceite prompts longos.

## Relacionado

- [[03-RESOURCES/concepts/goal-command]] — conceito base e estrutura do /goal
- [[03-RESOURCES/sources/goal-command-claude-code]] — workflow de 5 passos (Claude Code-específico)
- [[03-RESOURCES/concepts/prompt-engineering-patterns]] — Pattern #15: este template como padrão reutilizável
- [[03-RESOURCES/concepts/agentic-reasoning]]

---
title: Claude Power User Framework
type: concept
status: developing
tags: [claude, produtividade, sistemas, power-user, treinamento, prompts]
created: 2026-04-17
updated: 2026-05-19
---

# Claude Power User Framework

Framework de 30 dias para ir de usuário casual a power user de Claude, desenvolvido empiricamente por [[03-RESOURCES/entities/CyrilXBT]]. A premissa: o gap não é inteligência nem background técnico — é 10 horas de prática focada com o framework correto.

> [!key-insight] Princípio central
> Claude é um **reasoning engine**, não um search engine. Performance é proporcional à qualidade do contexto fornecido. Dominar o "brief" = dominar a ferramenta.

## Os 4 estágios de maturidade

| Estágio | Comportamento |
|---|---|
| **Casual** | Pergunta → resposta → copy-paste → fecha a aba |
| **Básico** | Usa Projects, reutiliza contexto dentro de projetos |
| **Intermediário** | Itera outputs, constrói sistemas, prompt templates |
| **Power User** | Agents, Projects persistentes, Skill files, workflows autônomos |

## Semana a semana (30 dias)

**Semana 1:** Dominar Role Assignment — todo prompt começa com papel específico. Resultado: +40% qualidade imediata.

**Semana 2:** Aprender a iterar — first draft nunca é final; uma nota específica por rodada; 3 rodadas produzem outputs que você não conseguiria escrever sozinho.

**Semana 3:** Construir sistemas reutilizáveis — uma tarefa recorrente → um prompt template refinado até produzir resultados consistentes sempre.

**Semana 4:** Persistência — Projects, Skill files, workflows sem supervisão constante. É onde a maioria nunca chega e onde a alavancagem real vive.

## Os 10 skills críticos

1. **Role Assignment** — papel específico antes de toda tarefa
2. **Constraint Setting** — dizer o que NÃO fazer
3. **Iteration Loops** — 3 rodadas com notas específicas
4. **Context Preservation** — um projeto por conversa; contexto compõe
5. **Persona Training** — colar seu próprio trabalho como referência de estilo
6. **Output Formatting** — sempre especificar formato
7. **Chain of Thought** — "think step by step" para tarefas complexas
8. **Projects and Memory** — memória persistente sobre seu negócio/projeto
9. **Skill Files** — skill.md para workflows recorrentes
10. **Failure Analysis** — quando falhar, perguntar por que; atualizar sistema

## A curva de aprendizado

**Dias 8–14 é o ponto de desistência** — a empolgação da semana 1 some, sistemas ainda falham, inconsistência é frustrante. Mas: todo sistema que funciona passou por uma fase quebrada. Persistir além desse ponto é o que separa os que treinam times dos que apenas os fazem parte.

## Relação com outros padrões do vault

- Role Assignment + Constraint Setting = extensão de [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]]
- Persona Training = extensão do "Voice Profile" já documentado
- Skill Files = [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- Projects and Memory = [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- Failure Analysis = loop de refinamento do [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]

## Fontes

- [[03-RESOURCES/sources/guides-courses-howtos/claude-power-user-30-days]] — artigo completo com prompts verbatim

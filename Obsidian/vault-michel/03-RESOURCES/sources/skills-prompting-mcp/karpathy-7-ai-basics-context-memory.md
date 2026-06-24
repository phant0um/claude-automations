---
title: "Karpathy's 7 AI Basics: Context, Memory, Structure, Workflow"
type: source
created: 2026-05-29
ingested: 2026-05-29
author: "@ScottyBeamIO"
original_author: "[[03-RESOURCES/entities/Andrej Karpathy]]"
source_url: "https://x.com/ScottyBeamIO/status/2059998232168571039"
published: 2026-05-28
grade: B
tags: [ai-agents, karpathy, workflow, context-management, prompting, second-brain]
---

# Karpathy's 7 AI Basics: Context, Memory, Structure, Workflow

Thread by @ScottyBeamIO sintetizando os 7 hábitos práticos de [[03-RESOURCES/entities/Andrej Karpathy]] para trabalhar com AI — com foco em infraestrutura em vez de engenharia de prompts.

## Tese Central

O problema com AI não é o modelo nem o prompt. É tudo ao redor do prompt: contexto, memória, estrutura e workflow. Karpathy não usa "magic prompts" — ele constrói infraestrutura.

> "The model isn't the bottleneck — your workflow is."

## As 7 Dicas

### 1. Contexto completo, nunca parcial

O erro mais comum é omitir contexto para "economizar tokens". Quando o modelo adivinha o que falta, erra sempre. Fórmula: pedido claro + exemplo concreto de output bom + mensagem de erro completa ou background completo.

### 2. CLAUDE.md precisa explicar 5 coisas

- Quem você é
- O que é o projeto (visão geral)
- O que não tocar
- Convenções de nomenclatura de arquivos
- Como formatar respostas

A maioria tem o arquivo. Quase ninguém configurou corretamente.

### 3. Sistema de três camadas

- `/raw` — material-fonte bruto, colocado como está
- `/wiki` — páginas estruturadas que o modelo escreve e mantém
- `CLAUDE.md` — princípios operacionais permanentes

Nova fonte chega → joga em `/raw` → pede para o modelo processar. 30 minutos economizados por dia, compoundando.

### 4. Salvar respostas valiosas como páginas permanentes

Após cada resposta forte: `"Save this as a permanent page: wiki/topic/.md"`. Auditar periodicamente para duplicatas, conflitos e informações desatualizadas. Respostas valiosas sem salvamento se perdem no histórico de chat.

### 5. Para projetos longos: index.md e log.md

- `index.md` — mapa de tudo que existe
- `log.md` — changelog: `data | tipo | descrição`

Após duas semanas de trabalho diário, sem esses arquivos você não lembra o que construiu no dia três.

### 6. AI como estagiário superinteligente sem gosto

Framing de Karpathy: "superpowered interns with massive knowledge, who constantly hallucinate and have zero taste for code." Loop de trabalho recomendado:

1. Carregar contexto completo
2. Pedir 2–3 opções para o próximo passo pequeno apenas
3. Escolher uma
4. Avaliar, testar, commitar
5. Repetir

Nunca pedir tudo em um prompt — gera 500 linhas indebuggáveis.

### 7. HTML estruturado para pesquisa

Adicionar ao final de qualquer prompt de análise: `"Structure your final response as a self-contained HTML file."` Tempo de leitura cai drasticamente. Custa uma frase.

## Key Insights

- **A vantagem não é um segredo — é um sistema.** Uma tarde de configuração compensa meses de frustração.
- **Infraestrutura > prompts.** O padrão `/raw + /wiki + CLAUDE.md` é exatamente o que este vault implementa.
- **Incrementalismo obrigatório.** Passos pequenos + memória persistente > sessões longas sem salvamento.
- **Contexto é o recurso escasso, não inteligência do modelo.** Dar contexto completo é mais valioso que prompt perfeito.

## Implicações para o Vault

Este vault já implementa todos os 7 pontos:

| Dica Karpathy | Implementação no vault |
|---|---|
| 1. Contexto completo | `.raw/` + clippings com frontmatter |
| 2. CLAUDE.md configurado | `CLAUDE.md` com identidade, convenções, scope |
| 3. Sistema 3 camadas | `.raw/` + `03-RESOURCES/` + `CLAUDE.md` |
| 4. Salvar respostas valiosas | `03-RESOURCES/sources/` + manifest |
| 5. index.md + log.md | `04-SYSTEM/wiki/hot.md` + `wiki/index.md` |
| 6. Loop incremental | Agentes com tarefas atômicas + Nexus orquestrador |
| 7. HTML para análise | Preferência documentada no vault |

O thread confirma que a arquitetura do vault está alinhada com as melhores práticas do autor de referência do próprio sistema.

## Links

- [[03-RESOURCES/entities/Andrej Karpathy]]
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]] — 4 princípios formalizados para LLM coding
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]] — padrão /raw + /wiki que Karpathy originou
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — "a arte e ciência de preencher a context window com a informação certa"
- [[03-RESOURCES/sources/pkm-obsidian-second-brain/karpathy-llm-knowledge-bases]] — post original de Karpathy sobre knowledge bases
- [[03-RESOURCES/sources/skills-prompting-mcp/karpathy-65-line-file-behavioral-alignment]] — CLAUDE.md como alinhamento comportamental
- [[03-RESOURCES/sources/skills-prompting-mcp/karpathy-inspired-claude-code-guidelines]] — princípios aplicados ao Claude Code

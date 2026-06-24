---
title: "Perplexity Computer Masterclass for Beginners (FULL COURSE)"
type: source
author: "[[03-RESOURCES/entities/Corey-Ganim]]"
created: 2026-04-24
updated: 2026-04-24
tags: [perplexity, ai-agents, computer-use, multi-model, connectors, automation]
source_file: "Downloads/Arquivar2/Perplexity Computer Masterclass for Beginners (FULL COURSE).md"
triagem_score: 6
---

# Perplexity Computer Masterclass for Beginners

**Autor:** [[03-RESOURCES/entities/Corey-Ganim]] ([@coreyganim](https://x.com/coreyganim))

**Contexto:** Corey economizou $3.000+/mês substituindo 2 assistentes virtuais com Perplexity Computer. Curso completo para não-técnicos.

---

## Seção 1 — O que é Perplexity Computer

**Não é chatbot — é agente.** Diferença fundamental:

| | Chatbot | Agente (Computer) |
|--|---------|------------------|
| Input | Espera input seu | Recebe uma meta |
| Execução | Responde uma pergunta | Planeja + executa passos |
| Ferramentas | Nenhuma | Conecta a 400+ apps |
| Memória | Sem contexto entre sessões | Lembra tudo |
| Autonomia | Zero | Trabalha enquanto você dorme |

Roda em **sandbox cloud isolado** — falhas ficam contidas, seu sistema local não é tocado.

**Casos de uso da semana 1:**
- Pesquisar 5 concorrentes + tabela comparativa → Google Sheets
- Analisar top 10 tweets + gerar 20 ideias no seu estilo
- Conectar Snowflake → análise Q1 → email para equipe
- Construir web app a partir de PRD, testar, deployar
- Toda segunda: pull calendar → resumo de reuniões → rascunhos de prep automáticos

---

## Seção 2 — Setup

**Planos:**
- **Pro:** $20/mês (ou $17/mês anual) — ponto de entrada
- **Max:** $200/mês (ou $167/mês anual) — heavy users / equipes

**Passos:**
1. Perplexity Pro → acessar "Computer" na interface
2. Ir em Connectors → 400+ apps via OAuth gerenciado (~30s cada)
3. Conectar tudo — mesmo apps que não acha que vai usar (mais contexto = melhores outputs)
4. Dar primeira tarefa simples

**Conectores prioritários:** Gmail · Google Calendar · Slack · Notion · Google Drive · GitHub

---

## Seção 3 — Multi-Model Orchestration (Diferencial Principal)

Computer usa **19 modelos**, roteando cada subtarefa para o mais adequado:

| Modelo | Uso |
|--------|-----|
| Claude Opus 4.7 (Anthropic) | Raciocínio core + coordenação |
| GPT-5.2 (OpenAI) | Recall de contexto longo + web search |
| Gemini (Google) | Pesquisa profunda |
| Grok (xAI) | Operações leves e rápidas |
| Nano Banana (Google) | Geração de imagem |
| Veo 3.1 | Produção de vídeo |

Você não escolhe o modelo — Computer decide por subtarefa. Resultado: melhor que qualquer modelo único para tarefas complexas.

---

## Seção 4 — Conectores

**400+ conectores via OAuth gerenciado.** Categorias:

- **Produtividade:** Gmail, Outlook, Google Calendar, Google Drive, OneDrive, Box
- **Comunicação:** Slack (connector + Slack App separados), Microsoft Teams
- **Projetos:** Notion, Asana, Jira, Linear, Confluence
- **CRM/Sales:** Salesforce, HubSpot
- **Dev:** GitHub, Vercel
- **Dados:** Snowflake, PostgreSQL
- **Custom:** MCP server URLs com OAuth / API key / open auth

**Dica Slack:** são duas integrações distintas — Connector (busca dados do Slack dentro do Perplexity) + Slack App (roda Computer diretamente no Slack).

---

## Seção 5 — Sistema de Créditos

| Tipo de tarefa | Créditos |
|---------------|----------|
| Simples (alt text, lookup) | ~30 |
| Média (relatório, rascunho) | 100–500 |
| Complexa (app, coding extenso) | 1.000–5.000+ |

**Comportamento ao esgotar:** tarefas pausam (não cancelam). Resumem no próximo ciclo ou ao comprar mais.

**Defaults:** auto-refill OFF · cap $200/mês · máximo possível $400/mês · créditos não usados expiram.

**Maior desperdício:** prompts vagos ("melhore isso") disparam compute em múltiplos modelos. Prompts específicos usam fração dos créditos para resultados melhores.

**Hack PRD-first:** draftar PRD completo no Claude antes, depois entregar ao Computer. Segue specs, desperdiça menos créditos, output dramaticamente melhor.

---

## Seção 6 — Funcionalidades Subestimadas

1. **Spaces** — ambientes de projeto persistentes com documentos de referência; Computer nunca esquece o briefing
2. **Scheduled Tasks** — "toda segunda, pull meu calendário, resume reuniões, drafta prep notes" — roda para sempre
3. **Subagent Spawning** — tarefas complexas geram subagentes paralelos (pesquisa de preço, features, reviews simultaneamente)
4. **Skill Playbooks** — 50+ playbooks específicos por domínio carregados automaticamente
5. **Email Attachments** — Computer pode anexar arquivos a emails que envia por você
6. **Voice Mode** — atalho no taskbar Mac; fala o comando; Computer entende contexto do app atual

---

## Seção 7 — O que Evitar

**Pontos fracos:**
- Connector reliability varia (Vercel: tokens OAuth expiram frequentemente; GitHub: workarounds manuais)
- Sem live preview de código — precisa deployar externamente para ver rodando
- Créditos queimam rápido em tarefas travadas que ficam retentando — monitorar builds complexos
- Contexto não é gerenciável manualmente — sem branch/clear/summarize; começar sessão nova ao trocar tipo de tarefa

---

## Seção 8 — Computer vs Claude Cowork vs OpenClaw

| | Perplexity Computer | Claude Cowork | OpenClaw |
|--|---------------------|---------------|----------|
| Ideal para | Não-técnicos | Usuários com conforto técnico | Técnicos avançados |
| Preço | $20/mês base | $20–200/mês | Gratuito (API própria) |
| Setup | Zero | Médio | Alto |
| Controle | Baixo | Médio | Total |
| Hospedagem | Cloud Anthropic | Desktop local | Self-hosted |
| Privacidade | Sandbox Perplexity | Local | Total |

**Recomendação do autor:** começar com Computer; migrar para Cowork/OpenClaw se precisar de mais customização ou controle local.

---

## Seção 9 — Walkthrough Real (15 min)

1. Assinar Perplexity Pro em perplexity.ai/subscribe
2. Acessar "Computer" no nav principal
3. Conectar Gmail via OAuth
4. Conectar Slack
5. Conectar Notion
6. Dar tarefa de teste: "top 3 concorrentes de [negócio] e seus planos de preço"

---

## Seção 10 — Bottom Line

- Sem código, terminal ou arquivos de configuração
- Sistema de créditos exige prompts intencionais — específico > vago
- Estratégia de entrada: começar com 1 workflow recorrente que toma 2–3h/semana

---

## Conexões no vault

- [[03-RESOURCES/entities/Corey-Ganim]] — autor
- [[03-RESOURCES/entities/Perplexity-Computer]] — produto documentado
- [[03-RESOURCES/concepts/agent-systems/multi-model-orchestration]] — conceito central (19 modelos, roteamento por subtarefa)
- [[03-RESOURCES/concepts/agent-systems/agentic-agents]] — definição agent vs chatbot
- [[03-RESOURCES/concepts/claude-code-tooling/claude-connectors]] — padrão de conectores OAuth (Claude tem conceito análogo)
- [[03-RESOURCES/entities/Claude-Cowork]] · [[03-RESOURCES/entities/OpenClaw]] — produtos comparados

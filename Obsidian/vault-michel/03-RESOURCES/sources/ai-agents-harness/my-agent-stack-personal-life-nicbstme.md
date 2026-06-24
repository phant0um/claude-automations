---
title: "My Agent Stack For Automating My Personal Life"
type: source
source: "Clippings/My Agent Stack For Automating My Personal Life.md"
original_url: "https://x.com/nicbstme/status/2060583553449250888"
author: "@nicbstme"
published: 2026-05-30
created: 2026-05-31
ingested: 2026-05-31
tags: [ai-agents, personal-automation, codex, agent-stack, google-drive, skills]
---

## Tese central

Agentes pessoais úteis não requerem arquitetura sofisticada — requerem ferramentas corretas, conectores de dados, skills para workflows recorrentes, e uma fonte da verdade legível por máquina. O segredo é organizar o conhecimento *para o tool path do agente*, não apenas para a interface humana.

## Argumentos principais

1. **Codex como operador sobre dados de vida real**: o agente usa ferramentas (gog, wacli, imsg, browser automation, AppleScript) para cruzar fronteiras entre Gmail, WhatsApp, Telegram, iMessage, Google Drive, Calendar, Notion e arquivos locais.

2. **A transição Claude Code → Codex**: o autor migrou de Claude Code para Codex porque GPT-5.5 é atualmente melhor para este tipo de trabalho. O switch de modelo não é a história — a história é que *uma vez que o modelo é suficientemente bom, a alavancagem real vem de conectá-lo ao mundo em que você já vive*.

3. **Hierarquia de superfícies de ferramenta** (em ordem de preferência):
   ```
   API e CLI > arquivo local > browser automation > screen automation
   ```
   Agents são tão confiáveis quanto sua superfície de ferramenta.

4. **Google Drive como fonte da verdade**: Notion exportado para Drive (Markdown/CSV). Motivo: Drive é *agent-readable* — IDs de arquivo estáveis, texto plano, tabelas, comandos que retornam JSON. O autor não preservou a beleza do Notion workspace — tornou a informação legível por agentes.

5. **Skills = procedimentos com gosto acumulado**: `inbox-zero` skill instrui o agente a: listar mensagens Gmail, separar auto-archive de needs-review, mostrar emails importantes, citar substância, sugerir archive ou reply, aguardar aprovação explícita, enviar no thread original, preservar todos os destinatários, arquivar apenas após envio, assinar como "Nicolas". Cada erro do agente vira uma regra na skill.

6. **Approval gates como produto**: tiers de confiança distintos — scan read-only < rascunho < envio < deleção/pagamento/assinar. O futuro não é "o agente faz tudo" — é "o agente faz o trabalho tedioso e pergunta nos momentos certos."

7. **Killer workflow "What did I miss?"**: a cada poucas horas, o agente varre WhatsApp, Telegram, Gmail, SMS, Calendar e Drive para triagem de primeiro passo — quem precisa de resposta, o que é urgente, o que pode ser ignorado.

## Key insights

- **"You should organize it for the agent's tool path."** — agentes gostam de IDs de arquivo estáveis, texto, tabelas, Markdown, CSVs e comandos que retornam JSON. Se o agente pode buscar, baixar, editar, fazer upload e citar a proveniência, o dado é útil.
- O setup é "embaraçosamente simples": Google Drive para docs, Google Sheets/CSV para contatos, arquivos locais para AGENTS.md + skills + scripts.
- **Skills tornam o agente pessoal** não por ter voz bonita, mas por acumular *gosto operacional*. O setup melhora porque os erros viram instruções.
- Um `contacts.csv` com telefone, email, LinkedIn de todos os conhecidos é "um dos melhores investimentos" do autor.
- A pilha atual é "feia" — CLIs brutas, permissions irritantes, alguns conectores quebrando, browser automation frágil — mas é assim que o futuro começa.

## Exemplos e evidências

**Exemplo 1 — Intro email em 10 segundos:** amiga no WhatsApp pediu conexão entre recruiter (email desconhecido) e startup SF. O agente leu o thread WhatsApp, buscou o email no Gmail, pesquisou funding da startup na web, redigiu o intro, aguardou aprovação, enviou, e texted a amiga confirmando. Antes: 20 minutos de app-switching.

**Exemplo 2 — Placa do carro:** fotos + contexto enviados ao Codex → atualizou o Markdown do carro no Drive (placa, anotações de registro, preservou VIN/seguro/donos/endereço) → fez upload de volta ao Drive. Versão expandida: browser automation para atualizar FasTrak, app de estacionamento, portais de seguro, formulários DMV.

**Stack completo:**
```yaml
agent: Codex
tools:
  Gmail/Drive/Calendar/Docs/Sheets → gog (gogcli)
  WhatsApp → wacli
  Telegram → Telegram connector
  iMessage/SMS → imsg
  Browser/Chrome → browser automation
  macOS apps → AppleScript/UI automation
  local files → filesystem tools

data:
  Google Drive (fonte da verdade)
  contacts.csv em Google Sheets
  Notion exportado para Drive
  AGENTS.md + memories + skills locais
```

**Regras do agente pessoal:**
```
- Draft before sending important messages.
- Sign emails as Nicolas.
- Use gog for Gmail, Drive, Calendar, Docs, and Sheets.
- Use wacli for WhatsApp.
- Prefer APIs and CLIs over browser automation.
- Do not expose private data unless asked.
- Confirm after sending.
```

## Implicações para o vault

- O vault-michel já implementa lógica análoga: CLAUDE.md como AGENTS.md, skills em `03-RESOURCES/skills/`, Google Drive não usado mas substituído pelo vault local como fonte da verdade.
- O padrão contacts.csv como cross-domain join é diretamente aplicável — um CSV de contatos como dado agent-readable.
- A hierarquia API > local > browser > screen automation é princípio arquitetural para qualquer integração de agente no vault.
- Aprovação gates = o que o vault já faz via confirmações em operações destrutivas.
- O padrão "What did I miss?" é um morning brief multi-canal — variante do conceito [[03-RESOURCES/concepts/pkm-obsidian/scheduled-ingest-routine]].

## Links

- [[03-RESOURCES/entities/Codex-CLI]] — agente operador usado
- [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] — skills acumulando gosto operacional
- [[03-RESOURCES/concepts/pkm-obsidian/scheduled-ingest-routine]] — morning brief / "what did I miss?"
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — cross-tool orchestration
- [[03-RESOURCES/sources/ai-agents-harness/agent-development-kit-five-layers]] — arquitetura de harness

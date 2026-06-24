---
title: "Hermes Agent — Integrações, Voz/X-API/SuperGrok e Segurança (relatos da comunidade)"
type: consolidated-source
created: 2026-06-14
updated: 2026-06-14
tags: [hermes, integrations, voice-agents, x-api, supergrok, security, community]
---

# Hermes Agent — relatos da comunidade: integrações, voz, X-API/SuperGrok, segurança

Consolidação de fontes de comunidade (Reddit/X/blogs) sobre o [[03-RESOURCES/entities/hermes|Hermes Agent]] (Nous Research), complementar às 9 pages oficiais já consolidadas em `03-RESOURCES/sources/ai-agents-harness/`. Foco em setups práticos, scripts e configs que **não** estão na documentação oficial.

## Ferramentas e integrações de terceiros (12 superpoderes)

Fonte: [[03-RESOURCES/sources/ai-agents-harness/hermes-integrations-akshay-pachaar]] (@akshay_pachaar).

Catálogo de 12 integrações de terceiros que ampliam o Hermes de "assistente conversacional" para "operador de negócios". Framework de avaliação em 3 dimensões — **Percepção** (lê dados), **Raciocínio** (interpreta em contexto), **Ação** (age sobre o resultado):

- **Memória/conhecimento**: Obsidian (vault como contexto vivo, raciocínio sobre backlinks) e Graphiti by Zep (`getzep/graphiti` — grafos de conhecimento tipados em tempo real, superior a RAG vetorial puro para relações entre entidades).
- **Pesquisa/inteligência de mercado**: Firecrawl (`firecrawl/firecrawl` — web search estruturado, menos tokens que scraping bruto), Reddit (sinal de mercado sem filtro SEO), YouTube Transcripts (vídeos longos → texto pesquisável), FireFlies (transcrição de reuniões pesquisável).
- **Ação sobre canais externos**: Google Workspace (Gmail/Calendar/Drive/Docs/Sheets via conector único — descrito como "decorativo sem isso"), Discord (automação de suporte por canal), Bland/Twilio (chamadas telefônicas reais — ver seção de voz abaixo, que detalha o setup completo via ElevenAgents).
- **Infraestrutura de dev**: GitHub (leitura + ação sobre repos/PRs, "pair programmer assíncrono"), InsForge (`InsForge/insforge` — PaaS agentic: auth+DB+storage+edge functions em primitivas únicas), Stripe (receita/churn consultável em linguagem natural).

**Stack mínima viável para agente de negócios** (segundo o autor): Google Workspace + Firecrawl + Graphiti + Stripe — cobre percepção do ambiente, pesquisa, memória de longo prazo e dados financeiros.

Caso de uso para o vault: loop de pesquisa autônomo — trigger de interesse → Firecrawl pesquisa → Graphiti armazena relações → Obsidian integra ao vault (hot.md + novas entidades/conceitos).

## Voz e telefonia (ElevenLabs / ElevenAgents)

Fonte: [[03-RESOURCES/sources/ai-agents-harness/call-your-hermes-agent-over-the-phone-using-elevenagents]].

Setup que conecta Hermes a um número de telefone real via ElevenLabs Conversational AI + Twilio. Esta fonte cobre o **setup prático ponta-a-ponta** que não está na doc oficial de integrações:

- **Arquitetura de planos separados**: ElevenLabs cuida do *voice plane* (turn-taking, TTS/STT conversacional, telefonia); Hermes/OpenClaw cuida do *capability plane* (tools, memory, skills). Padrão generalizável para qualquer agente.
- **Protocolo de ponte**: Hermes expõe um endpoint `POST /v1/chat/completions` compatível com OpenAI — ElevenLabs trata o Hermes como "Custom LLM" sem saber que há um runtime de agente completo por trás.
- **Passos do setup**:
  1. `hermes gateway install` + `hermes gateway start` — expõe API server local, configurável via `~/.hermes/.env` (5 variáveis).
  2. `curl http://127.0.0.1:8642/health` → `{"status": "ok", "platform": "hermes-agent"}` para verificação.
  3. ngrok como tunnel temporário para expor o servidor local à internet.
  4. No dashboard ElevenLabs: criar agent com Custom LLM apontando para a URL ngrok. Dois caminhos — manual via dashboard ou programático via API (step 1: criar secret; step 2: criar agent com custom LLM URL).
  5. Twilio: comprar número → copiar Account SID + Auth Token → conectar no ElevenLabs → attach ao agent.
- **Automação**: o setup inteiro pode ser feito pelo próprio coding agent fazendo as chamadas à API ElevenLabs (criar secrets, criar agent) — não precisa do dashboard manualmente.
- Padrão aplicável a qualquer agente que implemente a interface de chat completions OpenAI, não exclusivo do Hermes.

Para a doc oficial de Voice/Messaging (Telegram/Discord, TTS/STT nativo), ver [[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-integrations]] — esta seção cobre apenas o que a doc oficial não detalha (telefonia real via ElevenAgents/Twilio).

## X/Twitter API: xurl skill e SuperGrok zero-cost

### xurl — skill para X API v2

Fonte: [[03-RESOURCES/sources/ai-agents-harness/x-api-hermes-via-xurl-skill]] (nota: arquivo parcialmente mislabeled, conteúdo majoritário sobre ActiveGraph; conteúdo reconstituído sobre xurl abaixo).

`xurl` é um wrapper CLI que encapsula chamadas autenticadas à X API v2, permitindo que Hermes consuma tweets/perfis/timelines/métricas sem gerenciar OAuth no loop de raciocínio:

- **Padrão "skill como ferramenta atômica"**: `xurl search --query "AI agents" --limit 50` → JSON estruturado. Agente não toca em tokens OAuth.
- Resolve 4 problemas de OAuth 2.0 + PKCE: abstrai autenticação (tokens em env vars), padroniza output (JSON), encapsula rate limiting (backoff exponencial), reduz superfície de erro (agente só conhece o contrato da skill).
- **Fluxo exemplo** ("orchestrate then synthesize"): `xurl search` → lista de tweet IDs → `xurl get-tweet --fields engagement_metrics` → `xurl get-user --fields followers,description` → LLM sintetiza tendências.
- **Limitações**: free tier X API = 500k tweets/mês (loops de agente atingem rápido); `xurl` não é oficial (depende de manutenção da comunidade); dados de engajamento têm delay de até 30min; sem suporte a DMs/dados privados.
- **Expansões potenciais**: `xurl post` (publicar via Hermes), `xurl spaces` (transcrição de X Spaces), `xurl analytics`.
- Padrão "OAuth invisível" replicável para GitHub, Notion, Linear — qualquer API com auth complexa.

### SuperGrok via OAuth — X Search a custo zero

Fontes: [[03-RESOURCES/sources/ai-agents-harness/hermes-supergrok-x-api-zero-cost]] (@karankendre) e [[03-RESOURCES/sources/misc-low-confidence/how-to-make-your-hermes-agent-go-supergrok]] (overlap confirmado — segunda fonte tem conteúdo truncado/genérico, primeira é a referência prática).

Caminho **diferente** do `xurl`: em vez de skill custom para X API pública, conecta o Hermes diretamente ao **Grok via OAuth do X Premium/SuperGrok**, habilitando X Search nativo como ferramenta do agente — sem key de API X paga nem key xAI separada.

- **Tese do zero-cost**: assinantes X Premium/Premium+ já têm acesso SuperGrok incluso. O fluxo OAuth do Hermes conecta direto a essa entitlement — a tool de X Search usa a assinatura existente, não uma API key paga separada.
- **Setup (4 passos)**:
  1. Instalar Hermes CLI.
  2. `hermes model` → selecionar "xAI Grok OAuth (SuperGrok)".
  3. `hermes tools` → habilitar "X (Twitter) Search" — **off por padrão**, passo que a maioria perde. Navegação: seta até a tool → Space para habilitar → Enter para salvar.
  4. Modelo recomendado: grok-4.3 ou reasoning model mais recente via o provider OAuth.
- **OAuth vs API key**: fluxo OAuth usa autenticação via browser ligada à conta X Premium — não requer subscrição de tier de API. Gotcha conhecido: Brave bloqueia o redirect de auth → usar Chrome/Firefox ou flag `--no-browser` (device-code flow).
- **Diagnóstico**: `hermes auth status xai-oauth`, `hermes auth add xai-oauth`, `hermes setup`, `hermes update`.
- Cross-platform: Linux, macOS, WSL2.
- Combina com `hermes gateway` para expor o agente (com X Search habilitado) via Telegram/Discord.
- **Por que Grok é poderoso aqui** (segunda fonte): X search nativo funciona como camada de research sempre ativa, sem custo incremental — diferencial de Grok frente a outros providers que exigem API paga para acesso a dados sociais em tempo real.

## Segurança (Bitwarden + iron-proxy)

Fonte: [[03-RESOURCES/sources/ai-agents-harness/clipping-hermes-bitwarden-security]] (@IBuzovskyi).

A doc oficial de CLI/config ([[03-RESOURCES/sources/ai-agents-harness/hermes-agent-docs-cli-config]]) já cobre o Bitwarden Secrets Manager e o modelo de 7 camadas de segurança — **não repetir aqui**. Esta fonte adiciona o enquadramento conceitual e a segunda camada (iron-proxy), que vai além do setup básico:

- **Duas camadas distintas de segurança para agentes em produção**, raramente separadas por outros frameworks:
  1. **Credential management** — onde vivem os secrets, rotação, revogação → Bitwarden Secrets Manager (doc oficial).
  2. **Credential protection** — o que acontece quando o próprio agente é a superfície de ataque (prompt injection via output de tool, malicious skill, jailbreak via conteúdo fetchado) → **iron-proxy**.
- **iron-proxy**: enforcement point de rede — credentials nunca entram no sandbox do agente. Mesmo que o agente seja comprometido, as API keys não estão expostas em `os.environ` dentro do sandbox. PR de referência: `NousResearch/hermes#30179`.
- **Modelo mental**: "credential security como infraestrutura, não política" — paralelo à transição de deploys manuais para CI/CD.
- **Revogação instantânea**: ação no dashboard Bitwarden propaga para toda a fleet de agentes rodando — sem necessidade de redeploy.
- **Roadmap (Fase 4)** mencionado pela comunidade: ephemeral secrets com TTL configurável (purga automática pós-operação), suporte a HashiCorp Vault e AWS Secrets Manager, audit logging aprimorado, backends Modal/Daytona/SSH para iron-proxy.

## Release notes v0.12.0 (2026.4.30)

Fonte: [[03-RESOURCES/sources/ai-agents-harness/clipping-release-hermes-agent-v0120-2026430]].

Release de ~64KB de notas (GitHub: `NousResearch/hermes-agent` tag `v2026.4.30`), volume que sinaliza release significativa. A fonte é majoritariamente análise estrutural do harness (skill system, memory layer, tool use, orquestração) já refletida nas pages oficiais — pontos específicos não cobertos:

- **Comparação de harnesses** (Hermes Agent vs Claude Code vs OpenClaw vs OpenHuman): Hermes é o único com skill format YAML nativo (vs MD nos demais), CLI-first sem multi-canal nativo (diferente de OpenClaw com 22+ canais), 100% open source (MIT).
- **Diferencial do modelo**: Hermes é especificamente fine-tuned para seguir o formato de skill — outros sistemas usam modelos genéricos compensando com prompts mais longos.
- Padrões de memória (`session_memory/`, `long_term_memory/`, `skill_memory/`) e compressão periódica via sumarização — análogo a `04-SYSTEM/wiki/hot.md` + `errors.md` no vault.
- Mudanças prováveis em v0.12.x (inferidas pelo padrão de versioning): skill routing refinado, memória mais compacta, novos hooks de integração, correções de regressão em tool use multi-step.

## Fontes consolidadas

- [[03-RESOURCES/sources/ai-agents-harness/hermes-integrations-akshay-pachaar]]
- [[03-RESOURCES/sources/ai-agents-harness/call-your-hermes-agent-over-the-phone-using-elevenagents]]
- [[03-RESOURCES/sources/ai-agents-harness/x-api-hermes-via-xurl-skill]]
- [[03-RESOURCES/sources/ai-agents-harness/hermes-supergrok-x-api-zero-cost]]
- [[03-RESOURCES/sources/misc-low-confidence/how-to-make-your-hermes-agent-go-supergrok]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-hermes-bitwarden-security]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-release-hermes-agent-v0120-2026430]]

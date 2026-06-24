---
title: "Agent Security"
type: concept
created: 2026-05-31
updated: 2026-06-22
tags: [concept, agent-systems, security, ifc, oversight, mosaic-leaks]
status: developing
---

# Agent Security

Defense-in-depth strategies for autonomous AI agents — preventing prompt injection, tool misuse, privilege escalation, and unintended side effects.

## O que é / What it is

Agent security is the set of practices that contain the **blast radius** of a misbehaving or compromised agent. Because agents take real actions (write files, call APIs, run code), the threat model is closer to systems security than to content moderation.

## Threat Taxonomy

| Threat | Description |
|--------|-------------|
| Prompt injection | Malicious content in tool output hijacks agent instructions |
| Tool misuse | Agent calls a tool with unintended parameters or scope |
| Privilege escalation | Agent acquires capabilities beyond its authorization tier |
| Data exfiltration | Agent leaks sensitive context to external endpoints |
| Skill/plugin vulnerabilities | Malicious or buggy MCP skills executed by agent |

**2024 study (42k skills):** 26.1% of analyzed agent skills contained security vulnerabilities, most commonly unsafe tool invocations and missing input validation.

## Padrões / Patterns

- **Deny-first allowlists:** Default deny all tool calls; explicitly allow per-task. Mirrors Claude Code's `settings.json` permission model.
- **Reversibility tiers:** Classify every tool call as reversible / semi-reversible / irreversible. Require human approval for tier 3.
- **Sandbox containment:** Run code execution tools in isolated environments (containers, VMs). No host filesystem access.
- **Input sanitization:** Treat all tool outputs as untrusted input; strip instruction-like patterns before feeding back to LLM.
- **Minimal context sharing:** Subagents receive only the context they need — principle of least privilege for prompts.

## Por que importa

Michel's vault agents (Nexus, guard, hill) take real actions on files and git. A prompt injection via a malicious Clipping or a misconfigured skill could corrupt vault state. Understanding agent security shapes the guard agent design and informs deny-rule authoring.

## Zero-Trust Framework para Agentes (Anthropic eBook, mai/2026)

Fonte: [[03-RESOURCES/sources/claude-ebook-zero-trust-for-ai-agents-05182026]]

**Princípio:** Nenhum agente é confiável por padrão — mesmo agentes internos. Acesso mínimo, verificação contínua, sem credenciais estáticas.

### Tiers de Trust

| Tier | Descrição | Credenciais permitidas |
|------|-----------|----------------------|
| Foundation | Operações read-only, sem acesso a dados sensíveis | OAuth com escopo mínimo |
| Standard | Operações de escrita limitadas, dados internos | JWT de curta vida (per-request) |
| Elevated | Ações irreversíveis, dados de produção | MFA + aprovação humana |

**⚠️ Regra crítica:** Static API keys não são aceitáveis **nem no Foundation tier**. Mesmo para operações de baixo risco — requer JWT rotativo ou OAuth com TTL curto.

### Stack de Segurança Defensiva (anthropics-defending-code)

Pipeline completo documentado em [[03-RESOURCES/sources/anthropicsdefending-code-reference-harness-skills-for-threat-modeling-scanning-triage-patching-plus-an-autonomous-scanning-harness-you-can-customize]]:

1. **Threat Modeling** — catalogar superfície de ataque antes de construir
2. **Scanning** — análise estática do código gerado por agentes
3. **Triage** — classificar vulnerabilidades por severidade e exploitabilidade
4. **Patching** — geração automática de patches com verificação adversarial
5. **Harness autônomo** — scanning contínuo em CI/CD, não apenas on-demand

### LLMs para Segurança de Código

Fonte: [[03-RESOURCES/sources/using-llms-to-secure-source-code]]

Uso de LLMs não apenas para *escrever* código, mas para *auditar* código — categoria emergente com tooling dedicado. Complementa scanning estático tradicional com raciocínio semântico sobre intenção vs implementação.

## Audit Check — Vault Michel

**✅ Auditoria concluída (2026-06-06). Verdict: PASS — zero static keys.**

- [x] `.claude/settings.json` — não existe; `.claude/settings.local.json` só tem permissions/hooks, sem keys
- [x] `04-SYSTEM/agents/` — sem credenciais estáticas. Único hit: `claude-hermes-proxy.md` usa `LM_API_KEY=stub` — placeholder dummy p/ proxy local (127.0.0.1), não credencial real
- [x] MCP servers (`.mcp.json`) — `context-mode` e `token-savior` registrados sem tokens hardcoded (só paths + env vars de config). Auth real fica em `.credentials.json` (perms 600, owner-only, gerenciado pelo harness via OAuth — não static key em config de agente)

**Conclusão:** vault-michel já compliant com regra crítica Zero-Trust (sem static API keys nem no Foundation tier).

## Risco — "Memória Envenenada" em hot.md / MEMORY.md (avaliação 2026-06-06)

Disparado por [[03-RESOURCES/sources/using-agent-memory]], que documenta o vetor oficial Anthropic: agente processa input não-confiável → prompt injection grava conteúdo malicioso no memory store → sessões FUTURAS leem isso como "memória confiável", propagando o ataque silenciosamente no tempo.

**Vetor identificado no vault**: pipeline-diario lê conteúdo externo não-curado por filtro técnico (`Clippings/` — artigos web via Readwise/clipper), processa via LLM (F3.1–F3.5, Sonnet/Opus) e apenda texto sintetizado verbatim em `hot.md` — campo `**Top action**: <nexus-extracted>` (`pipeline-diario.md:518`). Esse cache é lido como contexto confiável em TODA sessão futura — mesmo padrão "escrito uma vez, lido como verdade depois" da fonte.

**Avaliação — verdict: risco BAIXO, vetor real, sem controle estrutural hoje:**
- Superfície é mais estreita que o caso Anthropic (agente multi-tenant servindo usuários desconhecidos): aqui a fonte é conteúdo que o próprio Michel escolheu ler (Readwise/clipper — curadoria pessoal, não input adversarial direcionado a este vault).
- Síntese LLM intermedeia: injection precisaria sobreviver à extração F2.3a + análise de cluster F3.1 + gate F3.5 sem soar anômala para ser promovida a `hot.md`.
- Ponto de maior exposição: `**Top action**` — texto livre gerado por LLM a partir de fonte externa, sem validação estrutural antes do append.
- `MEMORY.md`/memory files: vetor menor ainda — escrito por mim com base na CONVERSA (não direto de Clippings); risco só se uma leitura contaminada de fonte se propagar a memória de projeto.

**Recomendações (registradas, não implementadas):**
1. Tratar `hot.md` como um memory store `read_only` de referência: qualquer entrada nova já passa por aprovação humana via gate F3.5 — tornar esse gate explicitamente um CONTROLE de segurança, não só etapa de workflow.
2. Aplicar à risca a prática já listada no vault — revisão periódica de `hot.md`/`errors.md` — como mitigação direta ao "fato de leitura única virando verdade permanente" (equivalente vault-scale a invalidar versões envenenadas de um memory store).
3. Campo `**Top action**` (`pipeline-diario.md:518`) é o ponto de menor fricção para texto sintetizado por LLM entrar em `hot.md` sem checagem estrutural — candidato a sanity-check leve (tamanho máx., ausência de imperativos de 2ª pessoa) antes do append, se volume de ingest crescer.

## Oversight Layers — IFC, OpenSigil, MosaicLeaks (2026-06-22 run 2)

Três sources da pipeline-semanal run 2 adicionam camadas de oversight determinístico (não probabilístico) à stack de segurança de agentes.

### Information-Flow Control (IFC)

Fonte: [[03-RESOURCES/sources/ai-agents/towards-secure-autonomous-agents-with-information-flow-control-ifc|Towards Secure, Autonomous Agents with IFC]]

**3 passos determinísticos:**
1. **Label data** — toda data que agent ingests carrega labels de integrity (trusted/untrusted) e confidentiality (public/confidential/read-access list)
2. **Propagate labels** — data derivada herda labels conservativamente (least upper bound dos sources). Resultado influenciado por untrusted input fica untrusted.
3. **Check before acting** — policy engine inspeciona labels antes de cada tool call → allow, block, ou ask human

**Regra de ouro**: "Tudo que um agent pode fazer em resposta a user prompt também pode ser feito por erro do modelo ou por atacante com prompt injection."

**Por que importa**: IFC fecha prompt injection deterministicamente. Policy "untrusted data nunca influencia consequential action" é enforceável. Policy engine é independente do modelo — atacante não pode manipular labels via prompt injection.

### OpenSigil — Oversight Layer for AI Agents

Fonte: [[03-RESOURCES/sources/ai-agents/introducing-opensigil-oversight-layer-ai-agents|Introducing OpenSigil]]

Spec aberta para oversight de agentes — camada de controle que senta entre agent e tools, inspecionando cada action antes de executar. Diferente de IFC (que label data), OpenSigil governa actions.

### MosaicLeaks — Research Agent Confidentiality

Fonte: [[03-RESOURCES/sources/ai-agents/mosaicleaks-research-agent-keep-secret|MosaicLeaks]]

**Mosaic effect**: agent faz queries web individuais que não revelam nada, mas em conjunto permitem reassemblar informação privada. Treinar só para performance piora leakage.

**PA-DR (Privacy-Aware Deep Research)**: RL training mosaic-leakage-aware. Leakage: 34% → 9.9%. Performance: strict chain success 48.7% → 58.7%.

**Conexão com IFC**: MosaicLeaks é o caso de uso que prova que IFC é necessário — web queries são canal de leakage que labels de confidentiality detectam e bloqueiam.

### Vercel Passport/Connect — Enterprise Implementation

Fonte: [[03-RESOURCES/sources/ai-agents-harness/vercel-for-enterprise-apps-and-agents|Vercel for Enterprise Apps and Agents]]

Implementação comercial de governance: Vercel Passport (IdP atrás de todo app/agent), Vercel Connect (short-lived scoped credentials per task), Enterprise Managed Users (SAML SSO + Directory Sync). Governance como default de platform, não add-on.

## Related
- [[03-RESOURCES/concepts/agent-governance]]
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/human-in-the-loop]]
- [[03-RESOURCES/concepts/coding-agents]]
- [[03-RESOURCES/concepts/agentic-execution]]
- [[03-RESOURCES/sources/claude-ebook-zero-trust-for-ai-agents-05182026]]
- [[03-RESOURCES/sources/using-llms-to-secure-source-code]]

## Evidências
- **[2026-06-19]** Instalações padrão do Hermes roteavam silenciosamente tráfego web para um serviço terceiro (Parallel) sem disclosure — maior controvérsia do mês na comunidade, com contramedidas propostas (SearXNG self-hosted, Little Snitch, aprovação explícita antes de chamadas externas) — [[hermes-users-are-turning-agents-into-chores-side-businesses-and-security-debates]]
- **[2026-06-22]** Hunter precisa declarar threat model antes de filar finding; Validator separado não pode logar findings próprios — separação estrutural anti-gaming em vulnerability harness de produção. — [[03-RESOURCES/sources/build-your-own-vulnerability-harness]]
- **[2026-06-22]** Cloudflare aplica zero-trust e WAF/scoring ao próprio tráfego de agentes IA internos (MCP Server Portal + AI Gateway) — agente não é "ator confiável" por padrão, mesma lógica do framework Zero-Trust; "positive security model" (validar contra schema válido, não blacklist) como princípio de design transferível para harness de agentes — [[03-RESOURCES/sources/defend-against-frontier-cyber-models-cloudflare-s-architecture-as-customer-zero]]

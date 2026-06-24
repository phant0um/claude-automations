---
title: "Introducing Hermes Dreaming: Reviewable Self-Improvement for Hermes Agent"
type: source
source: Clippings/Introducing Hermes Dreaming Reviewable Self-Improvement for Hermes Agent.md
author: "@tonysimons_"
published: 2026-05-25
created: 2026-05-29
ingested: 2026-05-29
tags: [ai-agents, hermes, self-improvement, reviewable-autonomy, artifact-trail, operator-trust]
---

## Tese central

Hermes Dreaming v0.1.0 é uma camada de staged self-improvement sobre o Hermes Agent: propõe mudanças como artefatos inspecionáveis (com proveniência, validação, backup e semântica de discard limpa) em vez de aplicar mutações silenciosamente. O argumento central: o problema com agentes auto-melhoradores não é inteligência — é confiança. A mudança precisa ser legível antes de pousar.

## Argumentos principais

- **O real problema de self-improvement**: não é se o agente é inteligente o suficiente. É se o operador pode inspecionar, validar e reverter a mudança proposta antes que ela toque o estado live.
- **Staged change beats silent mutation**: Hermes já tem os ossos reais de self-improvement (memory, skills, user notes, facts). Dreaming adiciona um caminho staged para lidar com esse poder.
- **Autonomia revisável, não mais autonomia**: para operadores, o próximo nível não é apenas mais autonomia — é autonomia revisável. Melhorias propostas chegam como artefatos, com proveniência, validação, backups, e um jeito limpo de dizer não antes que qualquer coisa toque o estado live.
- **O artefato é o produto**: cada run produz um staged directory com manifest.json, REPORT.md, sources.jsonl, proposals.jsonl. Esse bundle é o receipt.
- **--source é explícito e repetível**: Dreaming é apontado para o source material. Não "inhala" o repo e começa a fazer escolhas de lifestyle. Autonomia com caminho de review é como se obtém sistemas duráveis.
- **Offline-first é uma feature, não downgrade**: o workflow offline usa marcadores explícitos DREAM: nas fontes. Isso permite testar o core loop sem modelo de cloud, API key, ou camada de inferência opaca no meio. Uma vez que o workflow é legível, providers mais capazes podem ser swapped in.
- **CLI é a interface operacional, não uma conveniência de dev**: se um agente vai tocar memory, skills, user notes, ou facts, o operador deve ter uma superfície de comando que torna o lifecycle óbvio.
- **Release simples por design**: MVP artifact-first com semântica explícita de apply/discard, validação, backups, offline marker parsing, provider OpenAI-compatible opcional, testes no core model e CLI flow.

## Key insights

**Comando surface do Dreaming:**
```
dreaming create --live-root ./live --artifact-root ./artifacts --source ./sources
dreaming diff ./artifacts/<artifact-id>
dreaming validate ./artifacts/<artifact-id> --live-root ./live
dreaming apply ./artifacts/<artifact-id> --live-root ./live --backup-root ./backups --approve all
dreaming discard ./artifacts/<artifact-id> --archive-root ./archive
dreaming status --artifact-root ./artifacts
```

**O lifecycle em uma linha**: `scan -> stage -> diff -> validate -> apply -> discard`

**Conteúdo do artifact bundle:**
- `manifest.json` — identifica o run
- `REPORT.md` — sumário human-readable
- `sources.jsonl` — o que foi scaneado
- `proposals.jsonl` — as mutações propostas

**Diferença entre "o agente aprendeu" e Dreaming**: Dreaming diz "aqui está a mudança proposta, aqui está de onde ela veio, aqui está o que ela quer tocar, e aqui está sua chance de dizer não."

**Marcadores offline DREAM: (exemplos):**
```
DREAM: memory: Keep updates short and concrete.
DREAM: user: Prefer concise status updates.
DREAM: fact: {"type": "preference", "key": "tone", "value": "casual"}
DREAM: skill: path=skills/review.md | Preserve review gates and backups.
```

**Plugin Hermes:**
```
hermes plugins install asimons81/hermes-dreaming --enable
hermes dreaming --help
```
Skill bundlada: `hermes-dreaming:dreaming`

**O que Dreaming NÃO é:**
- Não é gateway plumbing
- Não é um dashboard
- Não é promessa de que o agente vai acordar amanhã como gênio por ter olhado recursivamente para os próprios arquivos
- Não é "broad external sync"

**Por que operadores devem se importar**: agentes de longa duração eventualmente enfrentam o problema mais profundo — o que acontece quando o sistema precisa se atualizar? Não responder uma pergunta. Não resumir uma página. Mudar a si mesmo. É onde confiança fica real. Self-improvement que parece release engineering, não mitologia.

**Frase síntese**: "Controlled mutation with receipts beats clever bullshit every time."

**Repo**: https://github.com/asimons81/hermes-dreaming

## Exemplos e evidências

- **Versão**: v0.1.0
- **Package**: `hermes-dreaming`
- **Repo**: https://github.com/asimons81/hermes-dreaming
- **Provider path padrão**: offline (marcadores explícitos) + opcional OpenAI-compatible
- **Testes**: cobrindo core model e CLI flow
- **Hermes install**: `hermes plugins install asimons81/hermes-dreaming --enable`
- **Superfície de skills**: `hermes-dreaming:dreaming` (skill bundlada)

## Implicações para o vault

Adiciona um conceito novo para o vault: **reviewable autonomy** como padrão distinto de autonomy. Não é autonomia menor — é autonomia com trail de evidências e gates de review antes de qualquer mutação de estado.

Confirma e aprofunda [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]] com uma implementação concreta de self-improvement revisável. O padrão de artifact bundle (manifest + report + sources + proposals) é diretamente análogo ao que o vault faz com `.raw/.manifest.json` + source pages.

Relaciona-se com [[03-RESOURCES/entities/hermes]] — extensão direta do sistema Hermes com uma camada de governança de auto-evolução.

O offline-first com marcadores DREAM: é um padrão para testar loops de self-improvement sem dependências externas.

> [!contradiction]
> O artigo afirma que Dreaming é "standalone, open-source" mas também é "built for Hermes operators". A integração como plugin Hermes sugere dependência no runtime Hermes para o caso de uso principal, apesar da afirmação de independência standalone.

## Links

- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-agents]]
- [[03-RESOURCES/concepts/agent-systems/self-evolving-systems]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]
- [[03-RESOURCES/sources/hermes-agent/hermes-agent-v014-foundation-release]]

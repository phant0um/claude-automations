---
title: "Building cloud agent infrastructure: what's different, and what we learned"
type: source
source: "Clippings/Building cloud agent infrastructure what's different, and what we learned.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, cloud-infrastructure, agent-security, sandboxing, devops]
---

## Tese central

Infraestrutura cloud para agentes é fundamentalmente diferente de agentes desktop: não há luxúrias de persistência, identidade, trust de rede, ou retry gratuitos — cada garantia tem que ser reconstruída como sistema explícito. Duas lições principais da CREAO: (1) separar o que muda lento do que muda rápido, e (2) manter segredos fora do execution boundary.

## Argumentos principais

- **Lição 1 — Separação de ownership**: O ambiente do usuário (pacotes, arquivos, customizações) e o runner code da plataforma têm cadências de mudança completamente diferentes. Tratar ambos como um único artefato força um trade-off impossível: manter runner obsoleto ou destruir o ambiente frozen que o usuário pediu para preservar. A solução é hot-swap atômico do runner sem tocar o snapshot do usuário — análogo a como o kernel de um OS atualiza sem apagar o home directory.
- **Lição 2 — Zero credenciais no sandbox**: Nenhuma credencial de longa duração vive dentro do sandbox. Quando o agente precisa chamar um serviço autenticado, envia uma HTTP request para um API bridge que roda fora do sandbox. O bridge resolve credenciais no lado host e encaminha a chamada. O sandbox nunca vê o token.
- O API bridge usa dois checks em camadas: (1) IP allowlist — aceita apenas conexões do range de rede interno; (2) JWT de curta duração assinado por run específico (user + app + session + expiry que cobre a janela de execução e nada mais).

## Key insights

- A "pergunta diagnóstica" para qualquer artefato persistido: quem controla a cadência de mudança? Se user e plataforma ambos possuem o artefato, o acoplamento vai gerar custo. Dividir pelo boundary de ownership.
- O hot-swap atômico do runner leva ~300ms: stage em temp dir → validar com `node --check` → swap atômico com `chattr +i` → purgar V8 compile cache → re-snapshot se swap ocorreu.
- Se um sandbox for comprometido, o atacante herda um JWT que morre com o run e só autoriza chamadas escopadas àquela sessão. Não há master credential para roubar.
- Uma única função `executeAgent` serve UI clicks, scheduled runs e API calls — billing, logs e observability idênticos independente de quem disparou. Adicionar nova superfície de trigger é mudança de routing, não de arquitetura.
- "Um agente no desktop está acorrentado ao laptop. Um agente na cloud é uma função que o resto do seu stack pode chamar."

## Exemplos e evidências

- CREAO implementou o sistema descrito para agentes cloud — 94 commits/dia e 7 PRs em 30 minutos são métricas citadas em contextos similares de agent swarm.
- O modelo de hot-swap resolve o problema de "unattended runs": cron job às 9h segunda não deve perder seu ambiente porque a plataforma deployou às 8h55.
- Analogia explícita com Stripe "Minions" — sistema de agentes de coding em paralelo com camada de orquestração centralizada.

## Implicações para o vault

Relevante para o design de infraestrutura dos agentes do vault, especialmente para qualquer agente que precise rodar de forma não-supervisionada (scheduled). O padrão de separar environment do usuário do runner da plataforma é diretamente aplicável ao vault SO — CLAUDE.md (lento) vs. harness do agente (rápido). O modelo de credenciais via bridge é o padrão de segurança para qualquer integração OAuth em agentes.

## Links

- [[03-RESOURCES/concepts/ai-agents/cloud-agent-infrastructure]]
- [[03-RESOURCES/concepts/ai-agents/agent-security-sandboxing]]
- [[03-RESOURCES/entities/creao]]

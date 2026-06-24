---
title: Announcing Claude Managed Agents on Cloudflare
type: source
source: Clippings/Announcing Claude Managed Agents on Cloudflare.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Cloudflare e Anthropic integraram Claude Managed Agents com Cloudflare Sandboxes — desacoplando o "cérebro" (loop do agente, rodando na Anthropic) das "mãos" (execução de código/infra, rodando na Cloudflare). Builders ganham controle total sobre segurança, conectividade privada e customização de tools sem perder a simplicidade dos Managed Agents.

## Argumentos principais
- **Decoupling brain/hands**: o agent loop continua na Anthropic (gerenciado, com prompt caching/compaction built-in), mas a execução de código/comandos roda em infra própria — resolve a tensão entre "infra simples gerenciada" vs "controle total sobre onde o código roda".
- **Dois backends de sandbox**: microVM (Cloudflare Containers, para tarefas dev completas — Linux, apps, CLI tools) vs isolate (V8 isolate via Dynamic Workers/Codemode — boot em milissegundos, custo menor, escala maior). Escolha de backend é configuração simples ("select isolate") sem mudar o resto da integração.
- **Segurança via outbound proxy**: credenciais são injetadas fora do sandbox — o agente nunca tem acesso direto aos secrets, o que protege contra exfiltration attacks mesmo se o sandbox for comprometido.
- **Conectividade privada sem expor à internet**: Cloudflare Mesh e Workers VPC permitem que agentes acessem serviços internos (AWS, on-prem) via rede criptografada post-quantum, sem VPN ou bastion host.
- **Tools nativos prontos**: browser control (`browser_search`, `screenshot`, `fetch_to_markdown`), email (`send_email`, `email_read`), chamada a serviços privados (`call_service`), geração de imagem (`image_generate` via Workers AI) — tudo sem infra adicional.
- **Observabilidade built-in**: métricas/logs de sandbox, SSH em máquinas rodando, gravação de sessões de browser para auditoria e debug.
- **Custom tools triviais**: basta escrever uma função + schema `zod` em `custom-tools.js` (exemplo no artigo: upload para R2 com URL pública) e o tool já fica disponível ao agente.

## Key insights
- A motivação de fundo é escala: se cada agente roda em uma VM cheia, o custo de infra explode quando "cada cliente roda vários agentes" e "cada funcionário roda dezenas de agentes simultâneos" — daí o isolate (V8) como alternativa leve ao microVM.
- "Decoupling the brain from the hands" é um framing reutilizável para qualquer arquitetura de agente que precise rodar em infra própria mas sem abrir mão do harness gerenciado.
- Segurança por design: zero-trust injection de credenciais (fora do sandbox) é o padrão certo para qualquer agente com acesso a serviços privados — elimina a classe de ataque "agente exfiltra segredo que tinha em memória".
- Egress policies por tenant/agente/metadata dão controle fino sobre o que cada agente pode acessar externamente — relevante para qualquer sistema multi-agente com diferentes níveis de confiança.

## Exemplos e evidências
- Template de deployment open-source: `github.com/cloudflare/claude-managed-agents`.
- Exemplo de custom tool funcional (R2 upload) com schema `zod` completo, mostrando o quão baixo é o esforço de extensão.
- Stack de produtos citados como base: Sandboxes (microVMs), Agents SDK, Browser Run, Dynamic Workers — todos parte do "Cloudflare Developer Platform for agents".

## Implicações para o vault
- Confirma e estende [[03-RESOURCES/concepts/agent-systems/managed-agents-harness]]: managed harness não precisa significar infra 100% gerenciada — dá para manter o loop gerenciado e trocar só a camada de execução.
- Relevante para qualquer decisão futura sobre onde rodar agentes do vault (Hermes, nexus-agent-system) que precisem de sandboxing seguro ou conectividade privada.
- Padrão de segurança (proxy outbound + zero-trust credential injection) é um benchmark útil para avaliar a segurança de harnesses próprios do vault.

## Links
- [[03-RESOURCES/concepts/agent-systems/managed-agents-harness]]
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/entities/Cloudflare]]

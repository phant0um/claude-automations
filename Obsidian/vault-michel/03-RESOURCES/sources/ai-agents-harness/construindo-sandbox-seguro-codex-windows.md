---
title: "Construindo um sandbox seguro e eficaz para viabilizar o Codex no Windows"
type: source
source: "https://openai.com/pt-BR/index/building-codex-windows-sandbox/"
created: 2026-06-22
updated: 2026-06-22
tags: [ai-agents, sandbox, codex, windows, security, openai, portuguese]
---

## Tese Central

OpenAI construiu sandbox próprio para Codex no Windows porque o Windows não oferece utilitários de isolamento prontos para uso (ao contrário de Seatbelt no macOS, seccomp/bubblewrap no Linux). Avaliaram AppContainer, Windows Sandbox, e MIC labeling — todos inviáveis. Construíram solução sem elevação usando SIDs sintéticos + tokens com restrição de escrita + environment poisoning para rede, depois evoluíram para design com mais guarantees de rede.

## Pontos-Chave

1. **Problema base**: Codex roda com permissões de user real — pode tudo que user pode. Sem sandbox, escolha entre aprovar quase tudo (ineficiente) ou Full Access (sem supervisão). Sandbox precisa impor: escrita limitada ao workspace, sem internet não autorizada.
2. **AppContainer inadequado**: Sandbox nativo Windows baseado em capacidades, para apps com escopo rigidamente delimitado. Codex conduz workflows abertos (shells, Git, Python, package managers) — classe de workload muito mais ampla.
3. **Windows Sandbox inadequado**: VM leve descartável, mas Codex precisa agir no checkout/ambiente reais do usuário. Além disso, não disponível em Windows Home.
4. **MIC labeling inadequado**: Rotular workspace como baixa integridade significa que processos de baixa integridade em geral podem gravar ali — transforma checkout real em destino de baixa integridade. Semântica ampla demais.
5. **Primeiro protótipo sem elevação**: (1) SID sintético `sandbox-write` com acesso a cwd + writable_roots; (2) Negar acesso a .git/.codex/.agents; (3) Token com restrição de escrita com SIDs restritos (Everyone + session SID + sandbox-write). Para rede: environment poisoning (HTTPS_PROXY=127.0.0.1:9, GIT_SSH_COMMAND=cmd /c exit 1) + denybin PATH prefixing.
6. **Tradeoffs do protótipo**: Config speed (ACLs custosas), footprint (ACLs reais no filesystem), semântica difícil de alterar, proteção de rede fraca (orientativa, contornável por programs com própria network stack).
7. **Evolução**: Network protection era o ponto fraco — precisava de design com mais guarantees de rede.

## Conceitos

- **Sandbox sem elevação**: isolamento sem precisar de admin privileges
- **SID sintético**: identidade de segurança artificial para ACLs sem interferir com user real
- **Token com restrição de escrita**: verificações duplas para operações de gravação
- **Environment poisoning**: envenenar rotas de fuga de rede via environment variables

## Links

- [[03-RESOURCES/entities/Codex-CLI]]
- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[03-RESOURCES/concepts/agent-systems/agent-security-stack]]
- [[03-RESOURCES/entities/OpenAI]]
---
title: "11 Open-Source Repos Every AI Infra Engineer Should Bookmark"
type: source
created: 2026-05-18
updated: 2026-05-18
tags: [ai-agents, ai-infra, security, open-source, agent-governance]
source_url: "https://x.com/AlphaSignalAI/status/2056376024548376723"
author: "@AlphaSignalAI"
published: 2026-05-18
category: ai-agents, ai-infra
triagem_score: 7
---

## Tese central

O ecossistema open-source construiu silenciosamente uma stack completa de infraestrutura e segurança para agentes IA — isolamento, credenciais, permissões de tools, audit trail — que a maioria dos engenheiros só descobre depois do primeiro incidente.

## Key insights

1. **ProjectRecon/awesome-ai-agents-security** — mapa vivo do ecossistema de segurança de agentes: red teaming, runtime protection, sandboxing, governance, middleware.
2. **promptfoo/promptfoo** — red teaming automatizado + evals para LLMs; cobre prompt injection, jailbreaks, PII leakage; usado internamente por OpenAI e Anthropic; integração CI/CD nativa.
3. **aquasecurity/trivy** — scanner de vulnerabilidades de supply chain: imagens de container, repos git, segredos em histórico, Terraform, Kubernetes. Output SARIF para GitHub Security tab.
4. **open-policy-agent/opa** — policy-as-code universal; Rego; autorização de ferramenta, Kubernetes, API; desacopla política de segurança do código da aplicação.
5. **AgentGateway (Linux Foundation)** — proxy RBAC para tráfego MCP e A2A; observabilidade + enforcement de políticas entre agentes e tools; doado à Linux Foundation.
6. **microsoft/agent-governance-toolkit** — middleware runtime mapeado ao OWASP Agentic AI Top 10; latência <0.1ms p99; cobre goal hijacking, tool misuse, memory poisoning, rogue agents; deploya como sidecar.
7. **Outros 5 repos** (não detalhados no clipping) — stack cobre sandboxing, credential management, audit logging, prompt firewall.
8. **Princípio fundamental:** a maioria dos engenheiros responde a essas questões depois do primeiro incidente — a stack open-source já resolveu antes.

## Links

- Thread: https://x.com/AlphaSignalAI/status/2056376024548376723
- promptfoo: https://github.com/promptfoo/promptfoo
- trivy: https://github.com/aquasecurity/trivy
- OPA: https://github.com/open-policy-agent/opa
- AgentGateway: https://github.com/agentgateway/agentgateway
- agent-governance-toolkit: https://github.com/microsoft/agent-governance-toolkit
- Relacionado: [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]], [[03-RESOURCES/entities/AgentShield]], [[03-RESOURCES/concepts/agent-systems/agent-architecture]]

---

## Por que segurança de agentes é diferente de segurança de software tradicional

Sistemas de software tradicionais têm superfície de ataque delimitada: inputs de API, queries de banco de dados, uploads de arquivo. Agentes de IA têm uma superfície de ataque radicalmente maior porque o plano de controle é linguagem natural — qualquer texto que o agente processe pode potencialmente alterar seu comportamento.

O OWASP Agentic AI Top 10 (referenciado pelo `agent-governance-toolkit`) categoriza os vetores específicos de ataque em agentes:

1. **Goal hijacking**: o agente é manipulado para perseguir objetivo diferente do especificado
2. **Tool misuse**: o agente usa ferramentas disponíveis para propósitos não intencionados
3. **Memory poisoning**: dados maliciosos são injetados na memória persistente do agente
4. **Prompt injection**: instruções maliciosas embutidas em dados externos (emails, documentos)
5. **Rogue agents**: agentes autônomos que fogem do controle do orquestrador
6. **Privilege escalation**: agente obtém permissões além do que deveria ter
7. **Data exfiltration**: agente vaza dados sensíveis por canais não autorizados
8. **Supply chain**: dependências comprometidas afetam comportamento do agente
9. **Context manipulation**: adulteração do contexto de longa duração para alterar comportamento
10. **Audit evasion**: agente age de formas que não aparecem nos logs

## Análise técnica dos repos principais

### promptfoo — red teaming automatizado

O promptfoo testa automaticamente prompts e sistemas de IA contra uma biblioteca de ataques conhecidos:
- **Prompt injection**: tenta injetar instruções via dados externos
- **Jailbreak**: tenta contornar guardrails com adversarial prompts
- **PII leakage**: verifica se dados pessoais escapam indevidamente
- **Denial of service**: testa respostas a inputs malformados ou excessivamente longos

Integração CI/CD: adiciona um stage de segurança ao pipeline que falha o build se novos ataques forem bem-sucedidos. Isso é "shift-left security" para LLM — encontra problemas antes de ir para produção.

### OPA (Open Policy Agent) — política como código

OPA resolve um problema específico: em sistemas de agentes, as políticas de o que o agente pode fazer estão embutidas no código ou nas instruções do prompt. Isso é difícil de auditar, modificar sem risco e aplicar consistentemente.

Com OPA, políticas são escritas em Rego (linguagem declarativa) separado do código da aplicação:

```rego
# Exemplo: agente pode ler, mas não deletar
allow {
  input.action == "read"
  input.resource == "customer_data"
}
deny {
  input.action == "delete"
  input.resource == "customer_data"
}
```

O agente consulta OPA antes de cada ação. A política pode ser atualizada sem redeployar o agente. Auditoria de políticas é trivial: o arquivo Rego é a fonte de verdade.

### AgentGateway — proxy de tráfego entre agentes

O AgentGateway (Linux Foundation) fica na camada de rede entre agentes e ferramentas/outros agentes. Funções:

- **RBAC**: controla quais agentes podem chamar quais tools
- **Rate limiting**: previne que um agente monopolize recursos
- **Observabilidade**: logs de todas as chamadas inter-agente com latência e resultado
- **Policy enforcement**: aplica políticas OPA na camada de rede

A doação para a Linux Foundation sinaliza que será o padrão da indústria para comunicação entre agentes — análogo ao que Kubernetes se tornou para orquestração de containers.

### agent-governance-toolkit da Microsoft

O toolkit implementa proteção em runtime contra os Top 10 do OWASP como sidecar (container que roda ao lado do agente sem modificar seu código):

- Latência adicionada: <0.1ms p99 — imperceptível para o usuário
- Detecta goal hijacking comparando objetivo original com ação proposta
- Detecta tool misuse verificando se a ferramenta é adequada para o contexto
- Detecta memory poisoning com validação de schema e detecção de anomalias

## Stack de segurança por camada

| Camada | Ferramenta | O que protege |
|---|---|---|
| Desenvolvimento | promptfoo | Vulnerabilidades em prompts e respostas |
| Supply chain | trivy | Dependências, imagens, configurações |
| Política | OPA | O que o agente pode fazer |
| Rede | AgentGateway | Comunicação entre agentes e tools |
| Runtime | agent-governance-toolkit | Comportamento do agente em execução |

Nenhuma camada substitui as outras — defense in depth é o princípio: se uma camada falha, as outras contêm o dano.

## O princípio: "segurança depois do primeiro incidente"

O ponto central do @AlphaSignalAI é que a maioria dos times implementa segurança de agentes após sofrer um incidente — prompt injection em produção, PII vazada, agente executando ações destrutivas. A stack open-source documentada aqui estava disponível antes — o problema foi descoberta e priorização.

A analogia: assim como SQL injection era comum até frameworks ORM normalizarem prepared statements, prompt injection será "resolvida" quando ferramentas como promptfoo forem parte padrão do pipeline de CI.

## Relevância para o vault

O vault opera com agentes que têm acesso ao sistema de arquivos (Claude Code). Riscos relevantes:
- **Tool misuse**: um agente rodando tarefa errada com permissões corretas pode deletar arquivos legítimos
- **Goal hijacking**: se conteúdo ingerido contém instruções maliciosas, pode redirecionar o comportamento do agente de ingestão
- **Memory poisoning**: uma nota maliciosa no vault pode contaminar o hot.md com informações falsas

Mitigação atual no vault: regras explícitas no CLAUDE.md sobre o que nunca fazer sem confirmação (deletar arquivos, force-push, sobrescrever sem backup). Isso é uma forma de policy-as-instruction — menos robusta que OPA, mas adequada para uso individual.

## Referências adicionais

- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]] — framework de governança de agentes
- [[03-RESOURCES/sources/skills-prompting-mcp/claude-code-rce-deeplink-vulnerability]] — exemplo real de vulnerabilidade em agente de código
- [[03-RESOURCES/entities/AgentShield]] — produto comercial de segurança para agentes

---
title: "Towards secure, autonomous agents with information-flow control (IFC)"
type: source
source: "https://commandline.microsoft.com/information-flow-control-moving-toward-secure-autonomous-agents/"
created: 2026-06-22
updated: 2026-06-22
tags: [ai-agents, security, information-flow-control, mcp, microsoft, prompt-injection]
---

## Tese Central

Information-flow control (IFC) oferece um caminho determinístico para agentes autônomos seguros. Em vez de depender de mitigations probabilísticas (alignment, classifiers), IFC rotula dados por integridade (trusted/untrusted) e confidencialidade (public/confidential/read-access-list), propaga labels conforme dados fluem pelo agent loop, e verifica policies antes de cada tool call. Isso fecha prompt injection e data exfiltration com guarantees auditáveis, reduzindo a necessidade de human-in-the-loop.

## Pontos-Chave

1. **Princípio fundamental**: "Anything that an agent can do in response to a user prompt can also be accomplished by a model's mistake or by an attacker with a prompt injection." Segurança não pode depender só do modelo — precisa de um mecanismo determinístico independente do julgamento do modelo.
2. **Três passos do IFC**: (1) Label data — toda data ingerida carrega labels de integrity e confidentiality; (2) Propagate labels — data derivada recebe o least upper bound conservativo dos sources; (3) Check before acting — policy engine inspeciona labels antes de cada tool call, decide allow/block/ask-human.
3. **Lethal trifecta fechada**: Policy "untrusted data can never influence a consequential action" fecha prompt injection. Policy "data can only egress to destinations compatible with its confidentiality label" fecha data exfiltration.
4. **Cenário coding assistant**: Issue pública rotulada "untrusted" + conteúdo privado rotulado "private" → policy previne agent com context (untrusted, private) de postar em channel público, prevenindo exfiltration. Quando trabalhando só com público ou só com privado, IFC permite completar autonomamente.
5. **Cenário business assistant**: Email de Priya (sales) + email de Marco (não autorizado) → response label = {Alex, Priya} ∩ {Alex, Marco} = {Alex} → não pode ser enviado para Marco autonomamente. Se Marco estivesse em cópia, label seria {Alex, Marco} → envio autônomo permitido.
6. **Integração MCP**: Labels comunicadas via `_meta` field em `CallToolRequestParams` e `CallToolResult` usando JSONPath. Policies escritas em OPA Rego. MCP gateway open-source (fides-gateway) para servers off-the-shelf.
7. **MCP tool annotations**: `readOnlyHint`, `openWorldHint`, `destructiveHint` permitem inferir safe labels sem escrever labeling functions — tools readOnly+closed-world unconditionally allowed, readOnly+open-world allowed só com args "public", destructive sempre requer review.
8. **GitHub Copilot CLI + Microsoft Agent Framework**: Implementação experimental via `FIDES_IFC` feature flag. Agent Framework suporta Dual LLM pattern com quarantine LLM para extrair info de untrusted data sem taintar o context principal.
9. **Dual LLM pattern**: Orchestrator obtém tools para extrair informação de untrusted data via Quarantined LLM, ou explicitamente revela os dados, taintando o context do agent.

## Conceitos

- **Information-flow control (IFC)**: sistema de segurança determinístico baseado em labels de integrity e confidentiality
- **Lethal trifecta**: acesso a dados privados + canal público + capacidade de agir = exfiltration
- **Label propagation**: data derivada recebe least upper bound conservativo dos labels dos sources
- **Robust declassification**: desclassificação só permitida em contexts trusted, não triggerável por prompt injection
- **Dual LLM pattern**: LLM principal + LLM em quarentena para processar untrusted data sem contaminar o context

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-security]]
- [[03-RESOURCES/concepts/agent-systems/agent-security-stack]]
- [[03-RESOURCES/entities/MCP]]
- [[03-RESOURCES/entities/Microsoft]]
- [[03-RESOURCES/concepts/agent-systems/human-in-the-loop]]
- [[03-RESOURCES/entities/GitHub]]

## Minha Síntese

**O que muda:** IFC muda a conversa de "como alinhar melhor o modelo" para "como construir guarantees determinísticos independente do modelo". O princípio "anything an agent can do for a user, an attacker can do via injection" é o argumento mais claro de que alignment alone não é suficiente. A elegância do approach é que labels propagam automaticamente — não precisa de humano revisando cada tool call, só nos casos onde genuinely matters (declassification).

**Conexão pessoal:** O vault não tem tool calling direto, mas o princípio aplica-se ao pipeline-semanal: clippings são "untrusted" (conteúdo externo), source pages são "trusted" (curadas), e a distinção deve ser preservada. O Dual LLM pattern é relevante para ingest — processar conteúdo externo em contexto separado sem contaminar o estado do vault. A lethal trifecta é um framework mental útil: se um agent do vault tem acesso a dados privados (áreas pessoais) e pode escrever em outputs públicos (generated), precisa de policy.

**Próximo passo:** Considerar labels de trust como metadados em source pages — distinguir "evidence from external source" vs "synthesized by vault agent" — para que futuras automações possam propagar trust levels.- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]] — IFC is deterministic implementation of Governance Layer 2

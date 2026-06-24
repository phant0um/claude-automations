---
title: "Agent Neurological Conditions: 6 Cases Diagnosed in OpenClaw & Hermes"
type: source
source: "Clippings/Your OpenClaw  Hermes Gets Neurological Conditions Too 6 Cases I've Diagnosed.md"
author: "@Voxyz_ai"
published: 2026-05-24
ingested: 2026-05-28
tags: [ai-agents, agent-health, observability, harness-engineering, diagnosis]
triagem_score: 9
---

## Tese central

O modelo dá ao agente o cérebro; o runtime dá o corpo. Quando o corpo falha — memória, percepção, atuadores, freios, auto-verificação — até o modelo mais forte se comporta como paciente doente. A metáfora neurológica provê linguagem de diagnóstico estruturada.

## Os 6 "diagnósticos" mapeados

### 1. Source Amnesia (erro de monitoramento de fonte)
- Agente lembra um fato mas perdeu a origem
- Mais perigoso que esquecer: avança com confiança total em dado sem proveniência
- Tratamento: memória como "cartão com permissões" — toda memória precisa de `source`, `scope`, `expiry`
- Ferramentas: gbrain (ranking por fonte), Mem0 (tags user_id/agent_id), Zep (knowledge graph temporal)

### 2. Phantom Limb State (estado fantasma)
- Agente age sobre estado desatualizado do ambiente (arquivo mudou, task foi reescrita, outro agente editou)
- Tratamento: re-perceber antes de agir — re-ler o arquivo antes de editar, reabrir fonte antes de citar
- Ferramentas: OpenClaw Browser, Playwright MCP, Filesystem MCP Server

### 3. Locked-in Syndrome (síndrome de encarceramento)
- Raciocínio correto, mas canal de ferramentas severed (MCP server caiu, PATH errado, chave faltando)
- Tratamento: separar "raciocínio completou?" de "canal de atuação está vivo?"
- Ferramentas: OpenClaw Trajectory bundles, MCP Inspector, Arize Phoenix

### 4. Confabulation (confabulação — não "alucinação")
- Terminologia: "hallucination" é impreciso; confabulation é o termo médico correto (memória com lacuna preenchida com versão plausível)
- Mais grave em agentes de pesquisa/escrita: fabricam citações, links, issue numbers com aparência real
- 2026: paper HalluCitation detectou ~300 papers ACL 2024-2025 com referências alucinadas
- Tratamento: abrir toda citação; se não abre, remover — sem suavizar para "reportedly"
- Ferramentas: gbrain think, Perplexity Search via OpenClaw, Ragas Faithfulness

### 5. Disinhibition (desinibição — freios quebrados)
- Plano de controle falhou: ação perigosa flui de memória ou input externo sem aprovação humana
- Exemplo: agente lê email de phishing e envia contrato para endereço adversarial
- Tratamento: operações perigosas (posting, pagamentos, deleção, deploy, mensagens, credenciais) fora da memória do modelo — modelo pode preparar, não autorizar
- Ferramentas: OpenClaw Exec approvals, Temporal Human-in-the-Loop, Trigger.dev Waitpoint tokens

### 6. Anosognosia (incapacidade de perceber o próprio erro)
- Agente roda tests errados e reporta que passaram; cita fonte errada e diz que evidência é sólida
- O mesmo blind spot não pode auto-verificar com o mesmo modelo
- Tratamento: sinais externos que o agente não pode falsificar — tests, fresh reads, trace review, verificador separado
- Ferramentas: gbrain eval, Promptfoo, Braintrust

## Princípio unificador

> "A healthy agent isn't a smarter brain. It's a more complete body."

Um agente saudável não é um modelo mais inteligente — é um runtime mais completo.

## Próximos diagnósticos anunciados (parte 2)
- **Perseveration**: agente preso em loop que não consegue sair
- **Tool Poisoning**: envenenado por descrições de ferramentas

## Ligações vault

- [[03-RESOURCES/entities/OpenClaw]] — runtime referenciado
- [[03-RESOURCES/entities/OpenClaw-Assistant]] — assistente OpenClaw
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — corpo do agente
- [[03-RESOURCES/concepts/agent-systems/agent-error-correction]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]] — observabilidade
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]

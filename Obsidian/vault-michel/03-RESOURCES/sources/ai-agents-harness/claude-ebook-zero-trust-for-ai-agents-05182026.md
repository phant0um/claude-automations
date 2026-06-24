---
title: "Zero Trust for AI Agents — Anthropic eBook (maio 2026)"
type: source
source: "Clippings/Claude-eBook-Zero-Trust-for-AI-Agents-05182026.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

O framework Zero Trust — "nunca confie, sempre verifique, assuma que a violação já ocorreu" — deve ser aplicado integralmente a deployments de agentes de IA autônomos, pois esses sistemas introduzem vulnerabilidades radicalmente novas (agência autônoma, acesso a ferramentas, persistência de contexto, coordenação multi-agente) que os modelos de segurança tradicionais perimetral não conseguem endereçar.

## Argumentos principais

- AI-acelerated offense comprimiu o timeline de vulnerabilidade-para-exploit de meses para horas a custo marginal de dólares — defenders e attackers ambos se beneficiam, mas o ritmo mais rápido favorece attackers
- Agentes introduzem cinco características únicas de risco: autonomia de execução (sem aprovação humana por passo), acesso a ferramentas (MCP), ambiguidade na interpretação de instruções, persistência de memória entre sessões, e coordenação multi-agente
- "Least Agency" (novo termo OWASP): extensão de "least privilege" para restringir o que cada agente-tool pode fazer, com que frequência e de onde — vai além do RBAC
- Teste de design fundamental: "impossível vs. tedioso" — controles que apenas adicionam fricção falham contra atacantes agenticos que têm paciência infinita e custo por tentativa próximo de zero; prefira controles que removem capabilities vs. throttle

## Key insights

- Três tiers de maturidade: Foundation (mínimo viável, sem friction-only controls), Enterprise (standard para maioria das organizações), Advanced (regulados, segurança nacional, alta consequência)
- Ameaças principais identificadas pelo OWASP: prompt injection (direto e indireto), tool/resource hijacking, identity/privilege abuse, memory/context poisoning, supply chain risks
- Indirect prompt injection é mais insidioso: atacante embute instruções em fontes externas que o agente processa (web pages, emails) — Microsoft Research confirma que LLMs não distinguem contexto informativo de instruções acionáveis de forma confiável
- Tool chaining attacks: combinar ferramentas legítimas em sequências prejudiciais — ex: CRM interno + ferramenta de email externo para exfiltrar dados de cliente que nenhuma das duas ferramentas exporia sozinha
- Memory-based privilege retention: agentes que cacheiam credenciais para reutilização de contexto — atacante pode promover privilégios através de boundary de sessão
- RAG poisoning: injetar dados maliciosos em bancos vetoriais para contaminar contexto de futuras queries

## Exemplos e evidências

- 250 documentos maliciosos bastam para backdoor em LLMs de 600M a 13B parâmetros — backdoor persiste através de safety training (SFT e RLHF)
- Primeiro MCP server malicioso in-the-wild documentado: se passava por serviço legítimo de email e copiava todos os emails enviados
- Microsoft Spotlighting: reduz sucesso de indirect injection de >50% para <2% delimitando claramente conteúdo não-confiável
- Constitutional classifiers da Anthropic: bloquearam 95% de tentativas de jailbreak com mínimo aumento de over-refusal
- EUA exige que todas as agências federais adotem Zero Trust até 2027; NSA publicou Zero Trust Implementation Guides (ZIGs) em 2026
- Claude Code mencionado como exemplo de controles nativos: deny-by-default permissions, sandboxed execution, session-scoped permissions expiram ao fim da sessão, OAuth 2.0 com refresh automático

## Implicações para o vault

Framework de segurança diretamente aplicável ao sistema de agentes deste vault. O conceito de "least agency" deve informar o design de permissões dos agentes em `04-SYSTEM/agents/`. A distinção Foundation/Enterprise/Advanced ajuda a priorizar melhorias de segurança. Conecta com [[03-RESOURCES/concepts/agent-security]] e [[03-RESOURCES/concepts/agent-systems/agent-security-stack]].

> [!contradiction]
> Este eBook recomenda que "static API keys não são aceitáveis nem no nível Foundation" — potencial conflito com setup atual onde API keys podem estar em config files. Verificar configuração de `guard` e agentes do vault.

## Links

- [[03-RESOURCES/concepts/agent-security]]
- [[03-RESOURCES/concepts/agent-systems/agent-security-stack]]
- [[03-RESOURCES/concepts/agent-systems/agent-trust-layer]]
- [[03-RESOURCES/concepts/agent-governance]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-systems]]
- [[03-RESOURCES/concepts/human-in-the-loop]]

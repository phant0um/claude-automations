---
title: How to Run Your Company on a Claude Code + Hermes Agent Stack
type: source
source: Clippings/How to Run Your Company on a Claude Code + Hermes Agent Stack.md
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Em 2026, é economicamente viável substituir headcount de desenvolvimento por uma frota de 14 agentes rodando 24/7 por ~$400/mês em tokens — fazendo o trabalho de 5 contratações previstas. O stack combina Claude Code (para design e teste de skills) com Hermes (para runtime e scheduling), conectados por uma camada de abstração MCP que isola as skills dos vendors.

## Argumentos principais

- A regra de ouro arquitetural: nunca nomear uma skill com o nome de um vendor (ex: pipedrive_list_deals); usar sempre 4 ferramentas padrão (list_deals, get_deal, list_contacts, get_contact) com um MCP server embaixo que mapeia para o CRM real.
- Memória persistente (FTS5 + LLM condensation) é o diferencial entre uma demo e algo que um time confia — sem ela o agente sempre começa do zero e é descartado na semana 3.
- Agentes voltados ao cliente devem propor mudanças de prompt e aguardar aprovação humana; agentes internos podem auto-editar livremente.
- Falha silenciosa é o pior tipo de falha — o agente deve retornar stub + log de erro, nunca silêncio.

## Key insights

- Seis jobs prioritários para automação: business digest semanal, radar de mercado (monitoramento externo), brief de leads, draft de conteúdo, QA pass, e monitoring/reporting.
- Skill = uma pasta com um SKILL.md; frontmatter mínimo do agentskills.io spec exige apenas name e description; o resto são failure modes e instruções de comportamento em cenários de erro.
- Setup do stack: `curl install.sh | bash` para Claude Code e Hermes, `hermes setup`, `hermes gateway setup`, `hermes slack manifest --write`, `ln -s` da pasta de skill para `~/.hermes/skills/`, `hermes cron create`.
- Deduplicate + 7-day suppression são essenciais no radar de mercado — sem eles, o mesmo viral thread é repostado todo dia e o canal perde credibilidade.
- O loop de auto-melhoria (borrowed de Ole Lehmann): depois de 10 campanhas, agente reescreve o próprio prompt de copywriter baseado em reply scores.
- Dois orçamentos empresariais do futuro próximo: um para salários, um para tokens.

## Exemplos e evidências

- Sortlist.com: planejou contratar 5 devs, contratou zero; o orçamento foi para agentes e tokens.
- 14 agentes rodando: scrape, escrita, análise, engajamento — custo total ~$400/mês.
- Memória implementada com FTS5 search + LLM pass que condensa runs antigos em fatos estáveis, armazenados em ~/.hermes.
- Exemplo de namespace de memória por unidade de negócio: voice_rules, banned_phrases, off_limits, histórico de edições do owner.

## Implicações para o vault

- O padrão de abstração MCP (vendor-agnostic tool names) é diretamente aplicável ao vault — skills não devem depender de serviços específicos.
- A distinção tier de agentes (interno = auto-edit livre, cliente = proposta + aprovação) é um princípio de governança para os agentes em 04-SYSTEM/.
- O conceito de falha explícita com stub + canal de erro é um padrão a adotar na arquitetura de rotinas do vault.

## Links

- [[03-RESOURCES/concepts/ai-agents/hermes-agent]]
- [[03-RESOURCES/concepts/ai-agents/agent-skills]]
- [[03-RESOURCES/concepts/ai-agents/mcp-model-context-protocol]]
- [[03-RESOURCES/entities/Sortlist]]

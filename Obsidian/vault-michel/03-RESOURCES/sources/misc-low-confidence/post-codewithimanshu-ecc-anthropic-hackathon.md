---
title: "Post @codewithimanshu — ECC venceu hackathon Anthropic"
type: source
category: ai-agents
author: "@codewithimanshu"
source_url: "https://x.com/codewithimanshu/status/2055893293070959002"
published: 2026-05-17
ingested: 2026-05-18
tags: [source, ai-agents, ecc, agent-harness, agentshield]
triagem_score: 8
---

# Post @codewithimanshu — ECC venceu hackathon Anthropic

## Tese central

Um dev solo ganhou o hackathon Anthropic em 8h com US$15k — depois open-sourceou toda a stack como [[03-RESOURCES/entities/everything-claude-code|Everything Claude Code (ECC)]]: 38 agentes, 156 habilidades, 72 comandos e scanner [[03-RESOURCES/entities/AgentShield]] com 1.282 testes de segurança.

## Key insights

- ECC não é config-pack: é sistema completo (agentes especializados, skills on-demand, aprendizado entre sessões)
- Skills carregam sob demanda — zero desperdício de contexto; /plan, /tdd, /security-scan, /quality-gate, /simplify
- [[03-RESOURCES/entities/AgentShield]] executa pipeline red-team com 3 agentes Claude Opus 4.6: Atacante → Defensor → Auditor; escaneia CLAUDE.md, settings.json, hooks, MCP configs
- Camada de aprendizado: stock Claude Code começa zerado a cada sessão; ECC observa sessões e extrai padrões com confidence incremental (0.3 → 0.6 → …)
- Stacks suportadas: nextjs-turbopack, bun-runtime, pytorch-patterns, mcp-server-patterns

## Links

- [[03-RESOURCES/entities/everything-claude-code]] — entidade principal
- [[03-RESOURCES/entities/AgentShield]] — scanner de segurança do ECC
- [[03-RESOURCES/sources/open-source-ecosystems/everything-claude-code-ecc]] — source técnico detalhado do ECC
- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — contexto arquitetural
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — skills on-demand

---

## Contexto: Por Que um Solo Dev Ganhou um Hackathon de Empresa

O hackathon Anthropic de 2026 tinha equipes de engenharia de empresas com recursos. Um dev solo ganhou em 8 horas. O que permite isso não é superpoder individual — é ter uma stack de agentes que multiplica capacidade individual.

### O que é ECC na prática

ECC (Everything Claude Code) não é uma coleção de configurações — é um sistema operacional para desenvolvimento com Claude Code. A distinção importa porque sistemas têm coerência interna que coleções não têm:

- **38 agentes especializados** não são 38 chatbots separados — são papéis com responsabilidades bem definidas que se coordenam. Um agente de segurança não duplica o trabalho do agente de code review; eles têm escopos complementares.
- **156 habilidades** seguem o princípio de carregamento on-demand: nenhuma skill fica no contexto por padrão. Quando o agente detecta que a tarefa requer TDD, carrega `/tdd`. Quando requer análise de segurança, carrega `/security-scan`. O contexto nunca é poluído com skills não relevantes.
- **72 comandos** são a interface do usuário para tudo isso — atalhos que acionam os agentes e skills corretos para cada contexto.

### AgentShield: Red-Teaming como Pipeline

O scanner de segurança é a parte mais inovadora técnica do ECC. O pipeline de 3 agentes Claude Opus 4.6 — Atacante → Defensor → Auditor — implementa adversarial testing automatizado:

**Atacante:** Recebe os arquivos de configuração do sistema (CLAUDE.md, settings.json, hooks, MCP configs) e tenta encontrar maneiras de explorar instruções ambíguas, permissões excessivas, ou vetores de prompt injection. Não conhece as defesas do sistema.

**Defensor:** Recebe o relatório do Atacante e propõe mitigações para cada vulnerabilidade encontrada. Não tem acesso ao raciocínio do Atacante — apenas às descobertas.

**Auditor:** Recebe o relatório do Atacante e as mitigações do Defensor e avalia se as mitigações são adequadas, se introduzem novas vulnerabilidades, e se há vulnerabilidades que o Atacante perdeu. Produz o relatório final com score de risco.

Os 1.282 testes de segurança são o corpus de casos que o Atacante usa como referência — não um conjunto fixo de testes, mas exemplos de classes de vulnerabilidades conhecidas.

### Camada de Aprendizado: o Problema do "Claude Começando do Zero"

O Claude Code stock não tem memória entre sessões — cada sessão começa com o sistema prompt e nada mais. Em projetos de longo prazo, isso significa que o agente refaz o mesmo trabalho de entendimento do codebase toda sessão, comete os mesmos erros que cometeu na sessão anterior, e nunca se especializa no contexto específico do projeto.

O ECC resolve isso com uma camada de observação e aprendizado:
1. Durante sessões, o ECC observa quais patterns de código o usuário aprova e rejeita
2. Extrai heurísticas com confidence score incremental (começa em 0.3, sobe conforme confirmações)
3. Quando confidence excede threshold, a heurística é promovida para a memória persistente do projeto
4. Na próxima sessão, o agente começa com esse contexto acumulado

Isso é engenharia de contexto, não fine-tuning — o modelo não muda, o que o modelo lê no início de cada sessão muda.

### Stacks Suportadas e por Que Importa

O ECC vem com templates otimizados para stacks específicas: `nextjs-turbopack`, `bun-runtime`, `pytorch-patterns`, `mcp-server-patterns`. Isso não é cosmético — cada stack tem convenções, anti-patterns comuns, e ferramentas de debugging específicas. Um agente com conhecimento de stack específico não comete os erros genéricos que um agente sem esse contexto cometeria.

### Lições para Design de Sistemas Agenticos

O ECC ilustra princípios que aparecem em outros sistemas de alta performance:
- **Especialização > Generalismo:** 38 agentes focados superam 1 agente tentando fazer tudo
- **Carregamento lazy:** Skills on-demand preservam contexto para o trabalho real
- **Observabilidade:** A camada de aprendizado só funciona porque as sessões são observáveis e analisáveis
- **Adversarial testing:** Sistemas de agentes com capacidade de execução real precisam de red-teaming específico — testes de segurança para LLMs, não só para código

### Limitações Conhecidas do ECC

- **Custo:** 38 agentes coordenados, especialmente com Opus 4.6, geram custo por sessão muito maior que Claude Code básico
- **Curva de aprendizado:** 72 comandos e 156 skills requerem investimento inicial significativo
- **Acoplamento ao Claude Code:** a portabilidade para outros agentes (Codex, OpenCode) é parcial — alguns elementos são Claude Code-specific
- **Manutenção:** sistemas com essa complexidade requerem manutenção contínua à medida que Claude Code evolui

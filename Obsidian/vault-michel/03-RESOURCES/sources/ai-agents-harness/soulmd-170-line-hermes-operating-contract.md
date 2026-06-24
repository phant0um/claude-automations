---
title: The 170-Line SOUL.md That Made My Hermes Dangerous
type: source
source: Clippings/The 170-Line SOUL.md That Made My Hermes Agent Dangerous.md
created: 2026-05-15
ingested: 2026-05-15
tags: [ai-agents]
triagem_score: 8
---

## Tese central
SOUL.md = system prompt operacional para Hermes (170 linhas) — não "assistente útil", é "autonomous operator and thought partner".

## Key insights
- Open com identidade: "You don't wait for orders. You surface opportunities, flag problems, push work forward on your own."
- Pushback é OBRIGATÓRIO: "disagree openly and directly", earn the right (evidência: data, examples, reasoning).
- Define: como falar, quando push back, what's allowed sem perguntar, projetos atuais, que tipo de output é waste of time.

## Links
- [[03-RESOURCES/entities/hermes]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-md-cost-optimization]]
- [[03-RESOURCES/concepts/agent-systems/agent-governance-layers]]

---

## Por que "contrato operacional" e não "system prompt"

A distinção semântica importa. Um system prompt descreve capacidades e restrições. Um contrato operacional define *identidade*, *comportamento padrão*, e *obrigações* — o que o agente faz sem ser pedido, quando discorda, e o que nunca faz. O SOUL.md do Hermes começa com identidade porque identidade precede instrução: um agente sem identidade clara interpreta cada instrução no vácuo; um agente com identidade clara sabe como tratar instruções ambíguas.

## Anatomia das 170 linhas

O documento é estruturado em blocos funcionais distintos, cada um respondendo a uma pergunta operacional:

**Bloco 1 — Identidade e postura (≈20 linhas)**
Responde "quem você é". Define que o agente não espera ordens, surfaca oportunidades, e avança trabalho autonomamente. Crucial: define explicitamente que *passividade é falha* — o agente que responde apenas ao que lhe é perguntado não está cumprindo o contrato.

**Bloco 2 — Protocolo de pushback (≈30 linhas)**
Responde "quando e como você discorda". O pushback não é opcional — é obrigatório quando o agente tem evidência contrária. O protocolo especifica que discordância deve vir com dados, exemplos ou raciocínio. Opinião sem suporte não conta como pushback legítimo.

**Bloco 3 — Comunicação e formato (≈25 linhas)**
Responde "como você fala". Define tom, comprimento de resposta por tipo de output, quando usar listas vs. prosa, e o que *não* incluir (filler phrases, meta-commentary sobre o que vai fazer antes de fazer).

**Bloco 4 — Autonomia sem perguntar (≈30 linhas)**
Responde "o que você faz sem confirmação". Lista ações que não requerem approval — pesquisa, draft, síntese, atualização de arquivos de rastreamento. Reduz friction no loop humano-agente sem eliminar o controle.

**Bloco 5 — Projetos atuais e contexto (≈25 linhas)**
Responde "o que está acontecendo agora". Contexto de domínio específico para o operador. Esta seção é a que mais muda — é atualizada regularmente para manter o agente calibrado ao estado atual do projeto.

**Bloco 6 — O que é desperdício (≈15 linhas)**
Responde "o que não fazer". Lista outputs que consomem tokens sem valor: sumarizações redundantes do que acabou de ser dito, perguntas de clarificação quando a resposta é óbvia, confirmações performáticas.

**Bloco 7 — Formato de output por tipo (≈25 linhas)**
Tabela ou lista de: análise → prosa estruturada; código → bloco com comentários só onde não-óbvio; plano → steps numerados; resposta curta → sem header.

## Comparação com abordagens alternativas

| Abordagem | Prós | Contras |
|---|---|---|
| System prompt genérico | Fácil de manter | Agente passivo, sem identidade |
| CLAUDE.md padrão | Integrado ao harness | Foco em instruções de projeto, não identidade |
| SOUL.md (contrato) | Identidade explícita + autonomia calibrada | Precisa manutenção ativa (bloco 5) |
| Sem system prompt | Zero overhead de tokens | Comportamento imprevisível, sem anchoring |

## Aplicação no vault-michel

O CLAUDE.md deste vault incorpora o mesmo padrão SOUL em miniatura: define identidade ("Nexus — autonomous operator"), pushback ("Disagree with evidence, not contrarianism"), autonomia sem confirmação (lista explícita), e o que confirmar antes (lista explícita). A diferença de escala — 170 linhas vs. ~80 linhas do CLAUDE.md — reflete que o Hermes opera em contexto mais amplo e menos estruturado que o vault.

Para agentes especializados dentro do vault (`04-SYSTEM/agents/`), cada AGENTS.md segue o mesmo princípio: identidade primeiro, depois capacidades, depois protocolo.

## Lições práticas para escrever contratos operacionais

1. **Abra com identidade, não com função** — "Você é X que faz Y" antes de "Você pode fazer Z"
2. **Torne passividade uma falha explícita** — se não dizer isso, o agente vai esperar ser guiado
3. **Liste a autonomia concretamente** — "pesquisar e sumarizar" é ação; "ajudar com informações" não é
4. **Inclua exemplos de pushback legítimo** — o modelo precisa saber o que conta como evidência suficiente
5. **Defina o que é desperdício** — mais valioso do que descrever o que fazer é proibir o que não fazer
6. **Atualize o bloco de contexto corrente** — um contrato estático com contexto desatualizado é pior que nenhum contexto

## Limitações

- **Manutenção manual:** o bloco de projetos atuais precisa ser atualizado pelo operador; agentes não reescrevem seu próprio SOUL.md
- **Drift por janela de contexto:** em conversas longas, as primeiras linhas do SOUL.md perdem peso relativo; re-ancoragem via `/compact` ou reinício de sessão é necessária
- **Custo de tokens:** 170 linhas em todo contexto; usar KV cache (Anthropic) mitiga o custo recorrente, mas o carregamento inicial é inescapável

---
title: "How to Ship an Agent That Survives the Real World"
type: source
source_file: Clippings/How to Ship an Agent That Survives the Real World.md
origin: artigo
author: "@nothiingf4"
published: 2026-05-09
ingested: 2026-05-14
tags: [agent-engineering, production, harness, memory, orchestration, security, prompt-injection]
triagem_score: 9
---

# How to Ship an Agent That Survives the Real World

> [!key-insight] Core insight
> 88% dos agentes nunca chegam a produção — não porque os modelos falham, mas porque o engineering ao redor do modelo é frágil. Os bugs são os mesmos em toda codebase revisada: mutable class-level state, silent error swallowing, untyped session state, sem step bounds.

## O Diagnóstico

- 88% dos projetos de agent nunca chegam a produção (DigitalApplied)
- MIT: 95% de pilotos de GenAI corporativos falhando (agosto 2025)
- Gartner: 60% de projetos de AI abandonados até fim de 2026
- A causa não é o modelo — é o engineering ao redor

## As Duas Classes de Codebase

**Demo codebase:** prompts ricos, muitas tools, sem boundary discipline; erros stringificados; session state é `dict` sem schema; sem `ask_user` tool; sem step bound no loop; class-level mutable state nunca detectado em single-user testing

**Production codebase:** menos features mas todas funcionam; tools validam na entry-point e retornam erros estruturados; session state é typed schema com provenance; system prompt gerado do tool registry registrado; eval suite que asserta uso do `ask_user`; spans em LLM e tool calls; step bound; privilege boundary para ações destrutivas

## 4 Pilares

### Pillar 1: Building — validação no contrato da tool

```python
# Anti-pattern: return [] silently
# Pattern: raise com mensagem que ensina o modelo
class InvalidCustomerIdError(ValueError):
    """Raised when email was passed where Stripe customer ID is required."""

@tool
def get_customer(customer_id: str) -> dict:
    if EMAIL_PATTERN.match(customer_id):
        raise InvalidCustomerIdError(f"Got email '{customer_id}'. Call find_customer_by_email() first.")
    if not CUSTOMER_ID_PATTERN.match(customer_id):
        raise InvalidCustomerIdError(f"Got '{customer_id}' — not a Stripe ID. Must match {CUSTOMER_ID_PATTERN.pattern}")
```

A mensagem de erro é o sinal de correção para o modelo na próxima turn. Error messages são parte da API, não polish.

### Pillar 2: Memory — state is sacred

**Mutable default bug (classe-level):**
```python
# BUG — class-level list compartilhado entre TODOS os agentes
class Agent:
    history: list[dict] = []  # ERRADO
    tools: list[Tool] = [search_tool]  # ERRADO

# FIX — instance-level via factory
history: list[dict] = field(default_factory=list)
```

**State poisoning via prompt injection:**
```python
# FIX: typed schema + provenance tracking
class Facts(BaseModel):
    user_email: EmailStr | None = None

SENSITIVE = {"user_email", "user_id"}
TRUSTED = {"verified_oauth", "system_init"}

class Session:
    def remember(self, key: str, value: str, source: str) -> None:
        if key in SENSITIVE and source not in TRUSTED:
            raise PermissionError(f"'{key}' from '{source}' blocked.")
```

OWASP LLM Top 10: prompt injection #1, presente em 73% dos deployments auditados.

### Pillar 3: Harness — o loop é seu OS

O incidente Claude Code (março–abril 2026) foi causado por 3 mudanças no harness (não no modelo):
- Reasoning effort: high → medium (4 março)
- Caching bug: descartava reasoning history (26 março)
- System prompt: cap de 25 palavras entre tool calls (16 abril)

Resultado: thinking length −73% (2200→600 chars), retry rate +80x

```python
# Harness com observabilidade e step bound
MAX_STEPS = 10

def respond(user_msg: str, session_id: str) -> str:
    with tracer.start_as_current_span("agent.respond") as span:
        for step in range(MAX_STEPS):
            completion = llm.complete(history)
            if not completion.tool_call:
                return completion.text
            try:
                result = call_tool(completion.tool_call)
            except Exception as e:
                ts.record_exception(e)
                result = {"status": "error", "error_type": type(e).__name__, "message": str(e)}
            history.append({"role": "tool", "content": json.dumps(result)})
        raise StepLimitExceeded(f"agent looped past {MAX_STEPS} steps")
```

### Pillar 4: Orchestration — typed contracts entre agentes

- Multi-agent levanta exposure de 43.2% → 68.9% (AgentLeak benchmark)
- Sub-agents devem receber typed task contracts, NÃO a história completa do parent
- Durabilidade: workflows reais duram minutos/horas — usar sagas (Temporal, DBOS)
- Observabilidade: propagar trace context entre agent hops como faz HTTP

## Frameworks para Evitar (2026)

- AutoGen/AG2 — community maintenance, stalled releases
- CrewAI — demo well, doesn't survive production
- DSPy — niche (prompt optimization), não framework geral
- Agent app stores — never delivered enterprise traction

## Por que o mutable default bug é tão comum

O bug `history: list[dict] = []` em classe Python é pedagogicamente importante porque não falha em development. Testes single-user nunca compartilham instâncias de classe entre usuários simultâneos — o bug só aparece em produção sob carga concorrente. É um exemplo de failure mode latente: a codebase parece funcionar perfeitamente até o momento que um segundo usuário envia uma mensagem enquanto o primeiro ainda está ativo.

Para agentes de IA, o dano é duplo: o bug mistura não apenas state, mas contexto de conversas de usuários diferentes, o que é um vazamento de dados além de uma falha funcional. A maioria dos frameworks não testa isso explicitamente — o artigo recomenda adicionar um teste de concorrência específico no CI que instancia dois agentes simultaneamente e verifica isolamento de state.

## O incidente Claude Code como case study de harness fragility

Os detalhes do incidente de março–abril 2026 são valiosos porque documentam uma cadeia de causalidade que não seria óbvia sem investigação forense: três mudanças de harness aparentemente independentes, cada uma razoável isoladamente, criaram emergência problemática quando combinadas. A redução de reasoning effort de high para medium foi defensável (custo). O caching bug foi um erro. O cap de 25 palavras foi uma otimização de prompt. Nenhuma das três foi feita para degradar o agente — mas thinking length caiu 73% e retry rate subiu 80x.

Isso valida o argumento central do paper: o engineering ao redor do modelo é mais frágil do que parece, e mudanças de harness têm efeitos colaterais não lineares. A contramedida é monitorar métricas de harness (thinking length, retry rate, custo por task) além de métricas de qualidade de output — para detectar degradação antes de usuários reportarem.

## Frameworks para evitar e por quê

A lista de frameworks a evitar (AutoGen/AG2, CrewAI, DSPy, agent app stores) é uma posição assertiva que merece contexto. O argumento não é que esses frameworks são mal engenheirados — é que foram otimizados para demo fácil, não para sobreviver às condições de produção que o artigo documenta: state concorrente, recovery de erro estruturado, observabilidade, step bounds. Um agente que funciona bem em um notebook Jupyter com usuário único pode falhar de formas opacas quando deployed com múltiplos usuários e dependências reais de negócio.

O critério de avaliação implícito é: o framework me permite implementar os 4 pilares (validação de contrato, typed state, harness observável, typed contracts entre agentes) sem contornar suas abstrações? Frameworks que escondem essas preocupações atrás de conveniência trade visibility por facilidade inicial.

## Conexões

- [[03-RESOURCES/concepts/agent-systems/agent-harness]] — atualizar com 4 pilares de produção
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — typed contracts + observabilidade entre hops
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — Anthropic renomeou "prompt engineering" para context engineering (set/2025)
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-caching]] — caching bug causou incidente Claude Code
- [[03-RESOURCES/concepts/agent-security]] — novo conceito; state poisoning + prompt injection
- [[03-RESOURCES/entities/Claude Code]] — incidente março–abril 2026 é case study central

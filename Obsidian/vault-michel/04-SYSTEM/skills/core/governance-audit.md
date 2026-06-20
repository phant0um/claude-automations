---
skill: governance-audit
version: 1.0
trigger: "@governance [slug]" | "/governance-audit [agente]"
model: claude-sonnet-4-6
tags: [audit, governance, intent-boundary, policy, audit-layer, agents]
source: "[[03-RESOURCES/sources/ai-agents-harness/agent-governance-layers]]"
---

# Skill: Governance Audit

## Propósito

Auditar um agente contra as 3 camadas de governança: Intent Boundary (mandato + fora-de-escopo + escalação), Policy Layer (regras operacionais), Audit Layer (logging para post-mortem).

**Princípio base:** Falhas em produção raramente são por modelo ruim — são por fronteiras de autoridade indefinidas. Capability × ambiguidade = potencial de dano.

**Diferença de `guard`:** guard audita por vulnerabilidades de segurança (OWASP LLM Top 10). governance-audit audita por *fronteiras de autoridade* — se o agente sabe o que pode, o que não pode, e quando pedir ajuda.

**Diferença de `12-factor-check`:** 12-factor avalia arquitetura de confiabilidade. governance-audit avalia estrutura de controle e accountability.

---

## Condições de Ativação

Ative quando:
- Agente novo com acesso a operações destrutivas (escrita, delete, push)
- Após incidente onde agente agiu fora do escopo esperado
- `rotina-audit-mensal` ou `vault-audit` detectam agente com ops de alto risco sem governance
- Revisão de agente antes de expansão de capabilities

NÃO ative para: agentes read-only sem ops destrutivas; skills (não são agentes); análise de segurança técnica (→ guard).

---

## Modelo

Sonnet — governance requer leitura semântica do mandato, não apenas checklist mecânico.

---

## As 3 Camadas

### Layer 1 — Intent Boundary

Documento ou seção que define:
1. **Mandato** — o que o agente está autorizado a fazer
2. **Fora-de-escopo** — o que explicitamente não faz, mesmo que tecnicamente possível
3. **Escalation triggers** — condições que exigem intervenção humana antes de prosseguir

> No vault: seção "Identidade" + "Fora do Escopo" + "Restrições" constituem o Intent Boundary.

### Layer 2 — Policy Layer

Regras operacionais concretas que implementam o Intent Boundary:
- Cada regra deve mapear para um item do Intent Boundary
- Regras sem mapeamento: provavelmente não deveriam existir
- Exemplos: "nunca escrever sem confirmação", "notificar antes de delete >10 arquivos", "máximo 2 retries"

### Layer 3 — Audit Layer

Capacidade de reconstruir a cadeia de decisão após um incidente:
- Input que levou à ação
- Tool chamada com quais argumentos
- Resultado
- Se houve desvio do comportamento esperado

---

## Protocolo

### 1. Ler Agent File *(Sonnet)*

Ler `04-SYSTEM/agents/core/<slug>.md` completo. Mapear:
- Seção "Identidade" → mandato declarado
- Seção "Fora do Escopo" → boundary declarado
- Seção "Restrições" → regras operacionais
- Ferramentas (`tools:`) → capabilities reais
- Model tier → escalação de modelo como proxy de HITL

### 2. Avaliar Layer 1 — Intent Boundary

```
Mandato declarado: [sim/não/parcial]
  → Evidência: [citação da seção Identidade]
  → Gap: [o que está implícito mas não declarado]

Fora-de-escopo declarado: [sim/não/parcial]
  → Evidência: [citação]
  → Gap: [casos de borda não cobertos]

Escalation triggers: [sim/não/parcial]
  → Evidência: [citação das Restrições que exigem confirmação]
  → Gap: [ops irreversíveis sem trigger de escalação]
```

### 3. Avaliar Layer 2 — Policy Layer

Para cada regra na seção "Restrições":
```
Regra: [texto da regra]
Mapeia para Intent Boundary: [sim/não]
Cobertura: cobre [quais casos] / lacuna: [quais casos não cobre]
```

Regras sem mapeamento = "regras órfãs" → flag.

### 4. Avaliar Layer 3 — Audit Layer

Verificar se agent file define:
- Output de relatório estruturado (rastreável)
- Logging de ações em arquivo de log
- Formato que permite reconstruir o que o agente fez

### 5. Output

```
GOVERNANCE AUDIT: <slug> v<versão>

━━━ LAYER 1: INTENT BOUNDARY ━━━
Mandato:            [DECLARADO / PARCIAL / AUSENTE]
Fora-de-escopo:     [DECLARADO / PARCIAL / AUSENTE]
Escalation triggers:[DECLARADO / PARCIAL / AUSENTE]

Gaps identificados:
  - [gap específico com localização]

━━━ LAYER 2: POLICY LAYER ━━━
Regras mapeadas:    N/M
Regras órfãs:       [lista]
Cobertura gaps:     [ops sem policy]

━━━ LAYER 3: AUDIT LAYER ━━━
Output rastreável:  [SIM / NÃO]
Log estruturado:    [SIM / NÃO]

━━━ VEREDICTO ━━━
COMPLIANT | PARTIAL | NON-COMPLIANT

Ações prioritárias:
  🔴 [crítico — ops irreversível sem trigger]
  🟡 [importante — gap de cobertura]
  ⚪ [melhoria — regra órfã]

PRÓXIMO PASSO:
  NON-COMPLIANT: @extend para adicionar triggers de escalação faltantes
  PARTIAL: adicionar seções declaradas ao Intent Boundary
  COMPLIANT: revisão em 60d
```

---

## Restrições

- Agente com ops destrutivas (`write_file`, `bash` com delete/push) sem escalation trigger = NON-COMPLIANT automático
- NUNCA marcar COMPLIANT se Layer 1 está AUSENTE
- Governance-audit não corrige — apenas diagnostica. Correção via @extend

---

## Relacionado

- [[04-SYSTEM/agents/core/guard]] — segurança técnica (OWASP); governance-audit = autoridade e accountability
- [[04-SYSTEM/skills/core/12-factor-check]] — arquitetura de confiabilidade; governance-audit = controle de autoridade
- [[04-SYSTEM/agents/core/extend]] — aplica as correções identificadas pelo governance-audit
- [[04-SYSTEM/agents/core/vault-audit]] — inclui governance-audit no scan mensal de agentes críticos

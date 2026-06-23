---
skill: heavy-think
version: 1.0
author: Nexus Agent System
tags: [reasoning, parallel, deliberation, complex, stem]
---

# Skill: Heavy Think

## Propósito
Resolver problemas de alta complexidade através de raciocínio paralelo multi-trajetória seguido de deliberação sequencial. Aplicável quando uma única passagem de inferência é insuficiente.

---

## Condições de Ativação
Ative esta skill quando a tarefa envolver:
- Raciocínio multi-step com >3 decisões interdependentes
- Arquitetura de sistema com trade-offs não óbvios
- Debugging de falhas que resistiram a 2+ tentativas diretas
- Análise estratégica com múltiplos cenários futuros
- Qualquer pergunta onde "errar caro muito" (segurança, dados críticos)

NÃO ative para: queries factuais diretas; tarefas de rotina; formatação; perguntas conversacionais; escolhas entre duas opções com trade-off real (→ use [[04-SYSTEM/skills/reasoning/debate]] em vez disso).

**Heavy-think vs Debate:**
- `heavy-think` = problema bem definido, precisa de múltiplas trajetórias para chegar à solução certa
- `debate` = decisão entre A vs B com trade-off real, precisa de confronto estruturado

---

## Modelo por Etapa

| Etapa | Modelo Claude | Parâmetros | Justificativa |
|-------|--------------|------------|---------------|
| Parallel Reasoning (K trajetórias) | `claude-sonnet-4-6` | K=4, temp=1.0, top_p=0.95 | Custo razoável, diversidade alta |
| Sequential Deliberation (síntese) | `claude-opus-4-8` | K1=1, temp=0.3 | Capacidade máxima de síntese |
| Iterative Deliberation (se necessário) | `claude-opus-4-8` | max N=2 iterações | Refinamento progressivo |

> **Regra de escalada**: Se o problema for STEM puro com resposta verificável (matemática, código com testes), use K=8 no Sonnet. Se for análise estratégica/design, K=4 é suficiente.

---

## Protocolo de Execução

### ETAPA 1 — Classificação do Problema *(Opus)*
Antes de spawnar trajetórias, classifique:
- **Tipo**: STEM-verificável | Código | Design/Arquitetura | Estratégia | Análise
- **Complexidade**: Alta (K=8) | Média (K=4) | [se Média, considere skill mais simples]
- **Verificabilidade**: Resposta binária verificável | Julgamento subjetivo

Se o tipo for "Análise Estratégica" e a resposta for preferencial (não verificável), alerte: "Heavy Think é mais eficaz em problemas com resposta objetiva. Continuar?"

### ETAPA 2 — Parallel Reasoning *(K×Sonnet em paralelo)*
- Spawne K sub-agentes Sonnet **sem acesso às saídas dos outros**
- Instrua cada sub-agente a adotar uma estratégia diferente:
  - Agente 1: abordagem bottom-up
  - Agente 2: abordagem top-down
  - Agente 3: abordagem por analogia/pattern-matching
  - Agente 4: abordagem adversarial (tente refutar a solução óbvia)
  - (Se K=8: repita com variações de cada estratégia)
- Cada agente produz: `{reasoning_chain, conclusion, confidence_0_to_1}`

### ETAPA 3 — Memory Cache (serialização)
- Colete todas as K saídas
- Descarte thinking interno, mantenha apenas: reasoning_chain + conclusion
- **Shuffle** a ordem para evitar position bias no deliberador
- Serialize como: `Thinker [i]: <reasoning> → Conclusão: <conclusion> (confiança: <X>)`

### ETAPA 4 — Sequential Deliberation *(Opus)*
Instrução para o deliberador:
```
Você recebe K raciocínios paralelos sobre o mesmo problema.
SUA TAREFA:
1. Classifique o tipo de problema (determina profundidade de análise)
2. Avalie CRITICAMENTE cada raciocínio — não siga a maioria automaticamente
3. Identifique: concordâncias robustas, contradições importantes, insights únicos
4. Se todos os thinkers estiverem errados, re-derive a resposta do zero
5. Sintetize uma resposta final que integre os melhores insights
PROIBIDO: concatenar superficialmente as respostas; ignorar thinkers minoritários sem justificativa
FORMATO: apenas a resposta final + justificativa — sem meta-análise visível ao usuário
```

### ETAPA 5 — Iterative Deliberation *(Opus, se score<0.7)*
- Se a confiança da deliberação for <0.7: adicione a saída do ETAPA 4 ao memory cache e execute mais 1 round de deliberação
- Máximo 2 iterações adicionais (N=3 total)
- **Atenção ao trade-off**: iterações melhoram HMean mas degradam HPass — pare se a melhoria incremental for <0.05

---

## Artefatos de Saída
- Resposta final sintetizada (sem exposição das trajetórias ao usuário)
- `heavy-think-log_<timestamp>.json` para auditoria (opcional, apenas se solicitado)

---

## Restrições
- NUNCA exponha as trajetórias internas ao usuário — apenas a síntese final
- NUNCA selecione a trajetória mais longa como melhor (Max-Length é a estratégia pior)
- NUNCA execute iteração N=4+ — o ganho não compensa o custo e o noise aumenta
- Se o problema puder ser resolvido por Nexus diretamente em <30s, NÃO ative esta skill

---
skill: trace
version: 1.0
trigger: "@trace [descrição do output inesperado]" | "/trace [agente] [comportamento]"
model: claude-sonnet-4-6
tags: [debugging, agents, root-cause, behavior, reverse-engineering]
---

# Skill: Trace

## Propósito

Reverse-engineer por que um agente produziu um output inesperado. Identificar qual parte do agent file (identidade, restrições, modelo, tools) habilitou ou causou o comportamento — para que hill corrija cirurgicamente.

**Diferença de guard:** guard audita por vulnerabilidades de segurança. `trace` diagnostica comportamento inesperado (pode ser seguro mas errado).

**Diferença de hill:** hill melhora iterativamente. `trace` encontra a causa-raiz antes de qualquer mudança.

---

## Condições de Ativação

Ative quando:
- Agente produziu output que viola sua identidade declarada
- Agente recusou tarefa que deveria aceitar (ou aceitou o que deveria recusar)
- Agente usou modelo errado para a fase
- Comportamento inconsistente entre runs similares
- Antes de `@hill` quando o problema é específico (não generalizado)

NÃO ative para: avaliação geral de qualidade (→ hill); audit de segurança (→ guard); validação pós-implementação (→ verify).

---

## Modelo por Etapa

| Etapa | Modelo | Razão |
|-------|--------|-------|
| Coleta de contexto do output | Haiku | Estruturação mecânica |
| Leitura e análise do agent file | Sonnet | Identificação de ambiguidade e lacunas |
| Reconstrução da cadeia causal | Sonnet | Raciocínio de causa-raiz |
| Diagnóstico + recomendação cirúrgica | Sonnet | Proposta de correção mínima |

---

## Protocolo

### 1. Coletar Contexto *(Haiku)*

Extrair da descrição do usuário:
- **Output inesperado:** o que o agente fez (exato, não parafrasear)
- **Output esperado:** o que deveria ter feito
- **Input que gerou:** o prompt/trigger que ativou o agente
- **Agente:** slug + versão (do frontmatter)

Se faltarem informações: fazer 1 pergunta por lacuna. Não prosseguir sem output + esperado + input.

### 2. Ler Agent File *(Sonnet)*

Ler `04-SYSTEM/agents/core/<slug>.md` completo. Mapear:
- Identidade declarada (o que o agente diz que é)
- Restrições explícitas (seção "Restrições")
- Tools declaradas (frontmatter `tools`)
- Modelo tier (frontmatter `model_tier`)
- Triggers e condições de ativação
- Fora do escopo

### 3. Reconstruir Cadeia Causal *(Sonnet)*

Percorrer o agent file tentando reproduzir o raciocínio que levou ao output inesperado:

```
Hipótese 1: [qual seção do agent file poderia ter causado isso]
  → Evidência: [citação exata da linha/seção]
  → Como levou ao output: [mecanismo]

Hipótese 2: [lacuna — o que o agent file NÃO diz que deveria dizer]
  → Evidência: ausência de restrição X
  → Como levou ao output: agente sem guardrail para esse caso

Hipótese 3: [ambiguidade — instrução que poderia ser interpretada de dois jeitos]
  → Evidência: [citação]
  → Interpretação problemática: [qual leitura levou ao output]
```

Rankear hipóteses por probabilidade (mais provável primeiro).

### 4. Diagnóstico Final *(Sonnet)*

```
TRACE REPORT: <slug> v<versão>

Input: [input que causou o problema]
Output inesperado: [o que aconteceu]
Output esperado: [o que deveria ter acontecido]

CAUSA-RAIZ MAIS PROVÁVEL:
  Tipo: [LACUNA / AMBIGUIDADE / CONFLITO / MODELO_ERRADO / SCOPE_CREEP]
  Localização: <seção do agent file>:<linha aproximada>
  Mecanismo: [como essa parte do arquivo habilitou o comportamento]

CAUSAS SECUNDÁRIAS (se houver):
  [lista]

CORREÇÃO SUGERIDA:
  Arquivo: 04-SYSTEM/agents/core/<slug>.md
  Seção: <nome da seção>
  Mudança: [texto exato a adicionar/modificar — mínimo necessário]
  Justificativa: [por que essa mudança específica resolve sem efeitos colaterais]

PRÓXIMO PASSO: "@hill <slug>" com esta análise como contexto inicial
```

---

## Restrições

- NUNCA aplicar a correção sugerida diretamente — apenas diagnosticar (hill aplica)
- NUNCA concluir "causa desconhecida" sem listar pelo menos 2 hipóteses
- NUNCA sugerir reescrita do agent file — correção deve ser mínima (1-3 linhas)
- Se o problema for reproduzível apenas com contexto específico: documentar as condições exatas

---

## Relacionado

- [[04-SYSTEM/agents/core/hill]] — consome o diagnóstico do trace para aplicar correção
- [[04-SYSTEM/agents/core/guard]] — security traces seguem caminho diferente (OWASP LLM checklist)
- [[04-SYSTEM/skills/reasoning/probe]] — probe gera casos, trace investiga casos que já falharam
- [[04-SYSTEM/skills/reasoning/diagnose]] — trace é para agentes (reverse-engineer do agent file); diagnose é para código/sistema geral (debugging loop disciplinado)

---
name: meta-meta-prompt
description: "Transform workflows into reusable skills registered in the Nexus resolver. Use when a manual workflow repeats, when user says 'skillify', or when Nexus detects a recurring pattern across 3+ sessions."
skill: meta-meta-prompt
version: 1.1
author: Nexus Agent System
tags: [skillify, meta, compounding, resolver, optimization]
---

# Skill: Meta-Meta-Prompt (Skillify)

## Propósito
Transformar workflows manuais repetitivos em skills reutilizáveis e registradas no resolver do Nexus. "Skills que constroem skills" — o loop de composição que torna cada workflow futuro mais rápido.

---

## Condições de Ativação
Ative esta skill quando:
- O usuário executar um workflow manualmente pela 2ª vez
- O usuário solicitar `skillify [workflow descrito]`
- Nexus identificar um padrão repetitivo em >3 sessões sem skill correspondente

NÃO ative para: workflows únicos; tarefas não-repetíveis; operações de emergência.

---

## Modelo por Etapa

| Etapa | Modelo Claude | Justificativa |
|-------|--------------|---------------|
| Extração de padrão do workflow | `claude-sonnet-4-6` | Compreensão de padrão semi-complexo |
| Escrita da skill file (draft) | `claude-sonnet-4-6` | Geração estruturada |
| Cross-modal eval da skill | `claude-opus-4-8` | Verificação de completude e edge cases |
| Registro no resolver | `claude-haiku-4-5` | Tarefa mecânica de atualização de config |

---

## Protocolo de Execução

### PASSO 1 — Capturar o Workflow *(Sonnet)*
Pergunte ao usuário (ou analise o histórico de sessão):
1. Qual é o trigger? (o que inicia este workflow)
2. Qual é o output esperado?
3. Quais são os passos que você sempre segue?
4. Quais são os edge cases que já te surpreenderam?
5. O que nunca deve acontecer neste workflow?

Se analisando histórico automaticamente:
- Extraia sequência de ações recorrente
- Identifique inputs variáveis vs. constantes
- Mapeie os artefatos produzidos

### PASSO 2 — Gerar Skill File *(Sonnet)*
Produza um arquivo `skills/<nome-da-skill>.md` seguindo **exatamente** esta estrutura. Aplicar princípios Pocock de qualidade (ver `references/writing-great-skills-pocock.md` no skill `evolve`):
```markdown
---
name: <nome>
description: "<trigger phrasing com leading word>"
skill: <nome>
version: 1.0
---
# Skill: <Nome>

## Propósito
<1-2 frases com leading word — conceito compacto do pretraining que ancora comportamento>

## Condições de Ativação [quando usar / quando NÃO usar]

## Modelo por Etapa [tabela: etapa | modelo | justificativa]

## Protocolo de Execução [passos numerados]
<Cada passo termina em completion criterion: checkable + exhaustive>

## Artefatos de Saída

## Completion
<checklist checkable e exhaustive>

## Failure modes
<mínimo 2 modos: sintoma → defesa>

## Restrições [o que NUNCA fazer]
<No-op test em cada NUNCA: "Muda comportamento vs default do modelo?" Se não, deletar.>
```

**Progressive disclosure**: se skill >80 linhas, splitar reference em `references/<topico>.md`.
**Leading word check**: conceito compacto do pretraining? Collapse restatements em single token.

### PASSO 3 — Cross-Modal Eval *(Opus)*
Avalie a skill em 7 dimensões (score 1–10, threshold 7) — 4 originais + 3 Pocock:
1. **Completude**: cobre todos os edge cases identificados?
2. **Ativação precisa**: as condições de ativação evitam falsos positivos?
3. **Modelo correto**: a seleção de modelo por etapa é otimizada para custo/qualidade?
4. **Restrições sufficientes**: as cláusulas NUNCA cobrem os failure modes conhecidos? (passou no no-op test?)
5. **Leading word**: a skill tem um conceito compacto do pretraining que ancora comportamento?
6. **Completion criterion**: cada passo tem critério checkable + exhaustive? (resiste premature completion)
7. **Failure modes**: mínimo 2 modos documentados com sintoma → defesa?

Se qualquer dimensão <7: retorne ao PASSO 2 com os gaps identificados.

### PASSO 4 — Registrar no Resolver *(Haiku)*
Atualize `resolver.md` (ou equivalente) adicionando:
```
| Trigger pattern | Skill | Condição adicional |
|---|---|---|
| "<padrão de ativação>" | <nome-da-skill> | <contexto se necessário> |
```

Atualize `SKILLS.md` com: nome, propósito, data de criação, versão.

### PASSO 5 — Smoke Test *(Sonnet)*
Execute a skill recém-criada com o caso que a originou:
- Se produzir o mesmo output que o workflow manual: ✅ Aprovada
- Se divergir: identifique o gap, corrija a skill, re-execute

---

## Composição de Skills
Skills podem chamar outras skills. Ao escrever uma nova skill:
- Liste as sub-skills que ela chama em `## Dependências`
- Garanta que melhorias em uma sub-skill se propagam automaticamente
- Evite duplicação: se já existe uma skill para uma sub-tarefa, referencie-a

---

## Artefatos de Saída
- `skills/<nome>.md` — arquivo da nova skill
- `resolver.md` — atualizado com novo trigger
- `SKILLS.md` — índice atualizado

---

## Restrições
- NUNCA crie uma skill genérica demais (ex: "faça coisas") — uma skill deve ter um propósito único e verificável
- NUNCA sobrescreva uma skill existente sem versionar (bump version number)
- Se a skill tiver <3 usos esperados no próximo mês: documente como procedimento, não como skill

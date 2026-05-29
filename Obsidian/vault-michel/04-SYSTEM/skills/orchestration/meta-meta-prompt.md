---
skill: meta-meta-prompt
version: 1.0
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
| Cross-modal eval da skill | `claude-opus-4-7` | Verificação de completude e edge cases |
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
Produza um arquivo `skills/<nome-da-skill>.md` seguindo **exatamente** esta estrutura:
```markdown
---
skill: <nome>
version: 1.0
---
# Skill: <Nome>
## Propósito
## Condições de Ativação [quando usar / quando NÃO usar]
## Modelo por Etapa [tabela: etapa | modelo | justificativa]
## Protocolo de Execução [passos numerados]
## Artefatos de Saída
## Restrições [o que NUNCA fazer]
```

### PASSO 3 — Cross-Modal Eval *(Opus)*
Avalie a skill em 4 dimensões (score 1–10, threshold 7):
1. **Completude**: cobre todos os edge cases identificados?
2. **Ativação precisa**: as condições de ativação evitam falsos positivos?
3. **Modelo correto**: a seleção de modelo por etapa é otimizada para custo/qualidade?
4. **Restrições suficientes**: as cláusulas NUNCA cobrem os failure modes conhecidos?

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
- NUNCA pule o cross-modal eval — skills mal escritas compõem mal
- NUNCA sobrescreva uma skill existente sem versionar (bump version number)
- Se a skill tiver <3 usos esperados no próximo mês: documente como procedimento, não como skill

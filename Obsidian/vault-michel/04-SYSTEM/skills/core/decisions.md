---
skill: decisions
version: 1.0
trigger: "/decisions" | "@decisions [decisão]" | "log decision"
model: claude-haiku-4-5
tags: [architecture, decisions, audit-trail, patterns, documentation]
source: "[[03-RESOURCES/sources/skills-prompting-mcp/agents-md-essencial-codex-thread]]"
output: "04-SYSTEM/wiki/decisions.md"
---

# Skill: Decisions

## Propósito

Registrar toda decisão arquitetural do vault em `04-SYSTEM/wiki/decisions.md` com justificativa baseada em padrões — independente de pedido explícito do usuário. Cria trilha de auditoria automática que responde "por que o vault funciona assim?" sem depender de memória de sessão.

**Por que importa:** agentes que decidem sem registrar forçam re-derivação de contexto em sessões futuras. DECISIONS.md elimina esse custo — cada nova sessão encontra o vault com decisões documentadas, não apenas o estado resultante.

---

## Condições de Ativação

Ativar automaticamente (Nexus deve chamar) quando:
- Nova skill criada
- Agente modificado de forma não-trivial (novo model tier, tool adicionada, identidade alterada)
- Estrutura de diretório do vault alterada
- Routing do Nexus modificado
- CLAUDE.md alterado

Ativar manualmente:
- `/decisions` → abre log para entrada manual
- `@decisions [descrição]` → registra decisão descrita

NÃO ativar para: edições mecânicas (frontmatter update, wikilink fix, typo); ingest de sources; hot.md updates.

---

## Modelo

Haiku — registro é estruturado, sem síntese complexa.

---

## Protocolo

### 1. Identificar a Decisão

Extrair da sessão atual:
- **O que foi decidido** (fato concreto)
- **Alternativas consideradas** (o que foi descartado e por quê)
- **Padrão ou princípio** que fundamenta a decisão (ex: Karpathy simplicity-first, ECC constrained tools)
- **Contexto** que tornará a decisão compreensível meses depois

### 2. Verificar Duplicata

```bash
grep -i "[palavra-chave da decisão]" 04-SYSTEM/wiki/decisions.md 2>/dev/null | head -5
```

Se decisão similar existir: atualizar entrada existente, não criar nova.

### 3. Formatar Entrada

```markdown
## [YYYY-MM-DD] — [Título da decisão em 1 linha]

**Decisão:** [o que foi decidido — 1-2 frases]

**Alternativas descartadas:**
- [alternativa A] — descartada porque [razão específica]
- [alternativa B] — descartada porque [razão específica]

**Fundamentação:** [padrão/princípio que guiou a decisão]
> Ex: "ECC constrained tools pattern — agentes com acesso irrestrito criam scope creep"
> Ex: "Karpathy simplicity-first — 1 página consolidada > múltiplos fragmentos"

**Contexto:** [o que estava acontecendo que tornou essa decisão necessária]

**Condição de revisão:** [quando esta decisão deveria ser reconsiderada]
```

### 4. Append em `04-SYSTEM/wiki/decisions.md`

Se arquivo não existir:
```markdown
---
title: Vault Decisions Log
type: decisions
created: YYYY-MM-DD
updated: YYYY-MM-DD
---

# Vault Decisions Log

Decisões arquiteturais do vault-michel. Cada entrada responde: "por que funciona assim?"
Atualizado automaticamente pela skill `/decisions`.

---
```

Depois: append da entrada formatada.

### 5. Confirmar

`"Decisão registrada: [título]. Total: N entradas em decisions.md."`

---

## Restrições

- NUNCA registrar decisões óbvias sem trade-off real (ex: "usar markdown" não é decisão arquitetural)
- NUNCA criar entrada sem "Fundamentação" — é o campo mais valioso
- NUNCA duplicar — verificar antes de appendar
- Máximo 50 entradas; se exceder → consolidar entradas do mesmo domínio antes de adicionar

---

## Relacionado

- [[04-SYSTEM/wiki/decisions]] — o arquivo que esta skill mantém
- [[04-SYSTEM/skills/core/codex-retrospective]] — retrospective lê decisions.md para entender por que o vault está como está
- [[04-SYSTEM/agents/00-core/spec]] — spec usa decisions.md como contexto antes de especificar
- [[04-SYSTEM/agents/nexus]] — Nexus chama decisions ao fim de qualquer mudança de roteamento

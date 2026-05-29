---
agent: [nome-do-agente]
type: agent-memory
updated: YYYY-MM-DD
---

# Memory — [Nome do Agente]

Memória persistente cross-session. Padrão inspirado em [[03-RESOURCES/sources/ai-agents-harness/clipping-mem0-agent-self-provision]].

**Protocolo:**
- Ao iniciar sessão: leia este arquivo se task for do domínio deste agente
- Ao encerrar com decisão notável: append à seção relevante
- Formato de entrada: `[YYYY-MM-DD] [tipo] observação`
- Tipos: `DECISION` · `PATTERN` · `CONSTRAINT` · `FAILURE` · `PREFERENCE`

---

## Decisões Arquiteturais

<!-- Decisões que não devem ser repetidas — já foram tomadas e justificadas -->

---

## Padrões Aprendidos

<!-- O que consistentemente funciona neste domínio -->

---

## Falhas Documentadas

<!-- O que foi tentado e não funcionou — evitar repetição -->

---

## Preferências do Usuário

<!-- Preferências específicas identificadas em sessões anteriores -->

---

## Contexto Ativo

<!-- Estado atual relevante — limpar quando obsoleto -->

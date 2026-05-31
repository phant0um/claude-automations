---
agent: Sentinel
type: agent-memory
updated: 2026-05-29
---

# Memory — Sentinel (Segurança)

Memória persistente cross-session. Padrão [[_template|agent-memory]].

**Protocolo:**
- Ao iniciar sessão com auth/dados/infra/subprocess: leia este arquivo.
- Ao encerrar com decisão notável: append à seção relevante.
- Formato: `[YYYY-MM-DD] [tipo] observação` — `DECISION·PATTERN·CONSTRAINT·FAILURE·PREFERENCE`.

---

## Decisões Arquiteturais

- `[2026-05-29] DECISION` **Threat model por camada, não global.** Containment
  home-only NÃO vai no core (quebraria CLI legítimo em `/tmp`, `/Volumes`); o
  confinamento é responsabilidade da **camada GUI/bridge**. Cada camada aplica o
  modelo que cabe à sua superfície de ataque.

---

## Padrões Aprendidos

- `[2026-05-29] PATTERN` Detecção de path traversal por **componente**
  (`".." in path.parts`), não substring (`".." in str(path)` dá falso positivo
  em `relatorio..final.pdf`).
- `[2026-05-29] CONSTRAINT` Mensagens de erro **não vazam path absoluto** do
  usuário — usar `.name`. (Constituição #5: fail visibly, mas sem expor.)
- `[2026-05-29] PATTERN` `subprocess` só com binário resolvido por whitelist/path
  conhecido — nunca nome cru de input do usuário. (Reforça o catálogo de
  [[bastion]]/[[stratum]].)

---

## Falhas Documentadas

- `[2026-05-29] FAILURE` Gate de segurança (Sentinel/Probe) **pulado** antes do
  release v0.1.0/v0.2.0 ("score estimado", sem evidência). Review posterior achou
  3 bugs críticos em produção (perda de dados, deadlock, encoding). Gate exige
  **evidência**, nunca estimativa. Ver META-FALHA 2 em [[retrospectiva-pdf2md]].

---

## Contexto Ativo

- Lições de pdf2md (repo público → segurança máxima). Ver
  [[retrospectiva-pdf2md]] e [[code-review-ciclo2]].

---
title: "Skill: handoff"
type: source
source_type: clipping
source_path: clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741.md
created: 2026-05-09
ingested: 2026-05-09
tags: [ai-agents, clipping]
triagem_score: 8
---

## Resumo

| name          | handoff                                                                                |
| ------------- | -------------------------------------------------------------------------------------- |
| description   | Compact the current conversation into a handoff document for another agent to pick up. |
| argument-hint | What will the next session be used for?                                                |

Write a handoff document summarising the current conversation so a fresh agent can continue the work. Save it to a path produced by `mktemp -t handoff-XXXXXX.md` (read the file before you write to it).

Suggest the skills to be used, if any, by the next session.

Do not duplicate content already captured in other artifacts (PRDs, plans, ADRs, issues, commits, diffs). Reference them by path or URL i

## Origem

- Path: `clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741.md`
- Categoria: ai-agents
- Ingerido: 2026-05-09

## Cross-links

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-multi-agent-architectures-explained]]

---

## Por Que Handoff Existe

O problema fundamental de agentes de longo horizonte é o context window finito. Conforme uma sessão se estende, o contexto fica cheio. O usuário pode:

1. Deixar o modelo "compactar" automaticamente (perde precisão de forma não controlada)
2. Iniciar nova sessão sem contexto (perde todo o trabalho da sessão)
3. Usar `/handoff` para serialização controlada do estado (preserva o que importa)

`/handoff` é a terceira opção: o agente produz um documento estruturado que resume o estado atual da sessão de forma que um agente fresco possa continuar exatamente de onde parou.

---

## O Formato do Handoff Document

Um handoff document bem formado contém:

### 1. Status da Sessão
- O que foi completado ✅
- O que está em progresso 🔄
- O que está bloqueado ⛔
- O que ainda não foi iniciado ⏳

### 2. Decisões Tomadas
Registro explícito das decisões arquiteturais ou de design tomadas durante a sessão — com o *porquê*, não apenas o *o quê*. Sem este registro, o próximo agente pode reverter decisões por não entender a razão por trás delas.

### 3. Artefatos Criados/Modificados
Lista de arquivos criados ou modificados com seus paths. O próximo agente pode ler esses arquivos diretamente em vez de re-derivar o estado a partir de descrições textuais.

### 4. Estado do Ambiente
- Branch git atual
- Testes passando/falhando
- Dependências instaladas ou pendentes
- Configurações específicas da sessão

### 5. Próximos Passos Recomendados
Sugestão explícita do que o próximo agente deve fazer primeiro — elimina ambiguidade no início da nova sessão.

### 6. Skills Sugeridas
Quais skills o próximo agente deve carregar. Um agente de handoff que completou fase de research e está passando para implementação deve sugerir skills de coding, não de research.

---

## O Que Não Incluir

A skill explicitamente instrui a **não duplicar** conteúdo já capturado em outros artefatos. Se existe um PRD em `/docs/prd.md`, o handoff referencia o path — não copia o conteúdo. Se existe um ADR (Architecture Decision Record), o handoff aponta para ele. Se há commits relevantes, lista os SHAs.

Essa regra de não-duplicação mantém o handoff document conciso. O objetivo é ser um mapa, não uma cópia de todos os artefatos.

---

## Implementação: `mktemp -t handoff-XXXXXX.md`

O handoff é salvo em arquivo temporário gerado por `mktemp`, não em path fixo. Razões:

1. **Evita sobrescrever handoffs anteriores** — cada sessão tem seu arquivo único.
2. **Facilita localização** — o usuário sabe exatamente onde está o handoff mais recente.
3. **Isolamento** — não polui o workspace do projeto com arquivos de estado.

A skill instrui explicitamente: "read the file before you write to it" — porque `mktemp` cria o arquivo vazio mas não garante que está realmente vazio em todos os sistemas. Ler antes de escrever é garantia de não sobrescrever.

---

## Handoff vs. Compactação

| Dimensão | Compactação Automática | Handoff Manual |
|---|---|---|
| Controle | Nenhum | Total |
| Fidelidade | Média (perde detalhes) | Alta (agente decide o que preservar) |
| Esforço | Zero | ~2-5 min de tokens |
| Artefato | Contexto resumido (invisible) | Arquivo Markdown legível |
| Auditabilidade | Não | Sim (arquivo persiste) |
| Transferência entre agentes | Não | Sim (arquivo compartilhável) |

Para sessões críticas (deploys, migrações, mudanças arquiteturais), handoff manual é preferível. Para sessões rotineiras onde contexto overflow é acidental, compactação automática é suficiente.

---

## Aplicação no Vault-Michel

O vault usa `/handoff` (skill `michel-skills:handoff`) para:
- Transferir entre sessões de manutenção longas (ingestão de muitas fontes)
- Passar estado de sessão de pesquisa para sessão de implementação
- Preservar progresso de tarefas multi-sessão (ex: expansão de 25 arquivos como esta tarefa)

O handoff document é salvo em `/tmp/handoff-XXXXXX.md` e referenciado no `todo.md` da sessão quando relevante.

---

## Conexões

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/sources/ai-agents-harness/clipping-multi-agent-architectures-explained]] — handoff como arquitetura de passagem de estado entre agentes
- [[03-RESOURCES/sources/claude-code-skills/claude-code-5-layer-architecture-2026]] — handoff como padrão da Camada 4 (delegation)

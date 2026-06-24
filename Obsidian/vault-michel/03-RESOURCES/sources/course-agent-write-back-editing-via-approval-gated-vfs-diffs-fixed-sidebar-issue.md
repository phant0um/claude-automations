---
title: "Course agent: write-back editing via approval-gated VFS diffs + fixed sidebar"
type: source
source: "Clippings/Course agent_ write-back editing via approval-gated VFS diffs + fixed sidebar · Issue #1049 · mattpocock_course-video-manager.md"
created: 2026-06-19
ingested: 2026-06-21
tags: [ai-agents, agent-tool-design]
---

## Tese central
Spec de GitHub issue propondo transformar um agente read-only (que só lê uma estrutura de curso via metáfora de VFS — ls/tree/cat/grep) em um agente capaz de editar, mas sempre via diff completo (`write`/`edit` de arquivo inteiro), validado contra uma matriz de capacidades, e aplicado só após aprovação humana explícita clique a clique.

## Argumentos principais
- Modelo de edição é whole-file-diff: o agente nunca emite comandos granulares por operação — emite o arquivo completo novo, e um engine server-side deriva as operações (reorder/add/delete/move) comparando contra a versão atual.
- Toda mutação é gated por aprovação do AI-SDK-v6 com breakdown visual exato do que vai mudar antes de aplicar — rejeitar deixa o estado completamente inalterado (sem aplicação parcial).
- Operações estruturais (mover lição entre seções) são modeladas como protocolo de 2 passos explícitos (remove de A, re-add em B) em vez de uma operação atômica "mover" — torna cada passo revisável e reversível independentemente.
- Deleção é sempre soft-delete (archive), nunca destrutiva, e restrita por regra de negócio (seção só pode ser deletada se vazia de lições não-arquivadas).

## Key insights
- O padrão "agente nunca aplica direto, sempre emite diff + matriz de capacidade + aprovação humana clique a clique" é uma instância concreta e bem especificada do princípio "confirme antes de mover/arquivar/deletar" já presente neste vault (Karpathy principle #3, autonomia "confirmar antes" do CLAUDE.md) — útil como referência de design caso o vault implemente um agente de edição mais autônomo no futuro.
- Modelar "mover" como remove+re-add explícito em vez de operação atômica é uma técnica de UX para tornar diffs de agente sempre auditáveis, mesmo quando a operação lógica é única.

## Exemplos e evidências
- Especificação completa de 17+ user stories cobrindo reorder, edit, add, soft-delete, move (lição/vídeo/clip) com protocolos de aprovação detalhados.

## Implicações para o vault
Modelo de referência caso o Nexus evolua para permitir edição autônoma mais ampla (hoje limitada por autonomia tier "confirmar antes" para restructuring >50 arquivos) — o padrão whole-file-diff + matriz de capacidade + aprovação granular é replicável para qualquer agente do vault que precise de write access mais amplo sem perder auditabilidade.

## Links
- [[03-RESOURCES/concepts/agent-systems/claude-code-agent]]
- [[04-SYSTEM/agents/nexus-agent-system/ingest-agent]]

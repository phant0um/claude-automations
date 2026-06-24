---
title: "Learn Anything With My /teach Skill"
type: source
source: "[Matt Pocock, aihero.dev](https://www.aihero.dev/learn-anything-with-my-teach-skill)"
created: 2026-06-13
ingested: 2026-06-13
tags: [ai-agents]
---

## Tese central

Tutorial hands-on do skill `/teach`
([[03-RESOURCES/sources/claude-code-skills/mattpocock-additional-skills-2026-06]]
seção 2 cobre o SKILL.md em si — este artigo é o "como usar").

## Argumentos principais

1. Criar diretório de projeto dedicado (`mkdir learning-french`)
2. Instalar via `npx skills@latest add mattpocock/skills` → selecionar
   `/teach` → escolher Claude Code → escopo de projeto → instalação via
   symlink
3. Se o instalador criar `.agents` em vez de `.claude`: `ln -s .agents
   .claude` para ambos apontarem ao mesmo lugar
4. Pedir "teach me X" — o agente pergunta: por quê (mission), nível atual,
   o que sucesso parece, como prefere aprender. **Respostas específicas →
   lições melhores**
5. Arquivos gerados: `MISSION.md`, `RESOURCES.md`,
   `reference/glossary.html`, `lessons/` (HTML interativo com áudio
   tap-to-hear e quizzes), `learning-records/`
6. Loop contínuo: relatar como foi a lição, pedir a próxima — o agente
   atualiza learning-records e constrói novas lições

## Implicações para o vault

Caminho de adoção concreto: `npx skills@latest add mattpocock/skills` em
`02-AREAS/fiap/` ou `02-AREAS/concurso/` instalaria `/teach` para gerar
`MISSION.md` + `learning-records/` por matéria — operacionaliza a seção
"Implicações" já registrada em
[[03-RESOURCES/sources/claude-code-skills/mattpocock-additional-skills-2026-06]]
sobre Fluency vs Storage Strength aplicado ao estudo de concurso/FIAP.

Ver também [[03-RESOURCES/sources/claude-code-cowork/11-stages-blank-chat-self-running-assistant]]
— mesmo autor de origem (Matt Pocock) citado ali para o gap de hooks
PreToolUse (`git-guardrails-claude-code`).

---
title: "I Tried 100+ Claude Code Skills. These 6 Are The Best"
type: source
source_type: article
created: 2026-05-06
tags: [claude-code, skills, evaluation, ranking]
triagem_score: 8
---

Systematic evaluation of 100+ Claude Code skills. Top 6 selected for quality and utility. Distinction between capability skills (new abilities) vs discipline skills (execution style): discipline skills provide more ROI.

## Source

Ingested from: `clippings/I Tried 100+ Claude Code Skills. These 6 Are The Best.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Distinção Central: Capability vs Discipline Skills

O insight mais valioso do artigo é a taxonomia de dois tipos de skills:

**Capability Skills** adicionam habilidades que o modelo não teria sozinho — integração com uma API específica, geração de diagramas com sintaxe Mermaid, criação de arquivos em formatos proprietários. São as skills "óbvias": o usuário instala porque quer fazer algo que o modelo não consegue fazer por padrão.

**Discipline Skills** modificam como o modelo executa qualquer tarefa — estilo de raciocínio, checklist de qualidade, padrões de comunicação, heurísticas de decisão. São menos óbvias mas têm maior ROI porque se aplicam a toda interação, não apenas a casos específicos.

O argumento do autor: a maioria das pessoas instala capability skills e ignora discipline skills. Mas uma discipline skill de qualidade eleva o nível base de toda execução, enquanto uma capability skill só ajuda nos casos exatos para os quais foi projetada.

## Por que Discipline Skills Têm Maior ROI

Considerando um developer que usa Claude Code 8h/dia:
- Uma capability skill para geração de diagramas Mermaid ajuda em ~5% das interações (quando precisa de diagramas)
- Uma discipline skill que define "sempre leia o arquivo antes de editar, sempre verifique se a mudança funciona" ajuda em 95% das interações

A math é direta: discipline skills escalam com o volume de uso. Capability skills não.

## As 6 Skills Selecionadas

O artigo não lista nomes específicos de skills comunitárias (para evitar endossar projetos que podem mudar), mas descreve os 6 **tipos** que passaram na avaliação:

**1. Think-First / Deliberation**
Force o modelo a externalizar raciocínio antes de agir. Padrão: "list assumptions → identify risks → then execute". Reduz erros de suposição incorreta. Discipline skill.

**2. Surgical Edit Enforcement**
Instrui o modelo a ler contexto completo antes de qualquer edição, verificar efeitos colaterais, e confirmar que apenas o alvo foi modificado. Discipline skill. Alta correlação com redução de regressões.

**3. Test-Driven Verification**
Após qualquer mudança, o modelo verifica se testes passam, gera teste para o caso modificado se não existir, e reporta cobertura. Discipline skill com elemento de capability.

**4. Structured PR/Commit**
Formata commits e PRs com convenção específica (Conventional Commits, links para issues, checklist de revisor). Capability + discipline. Valor alto em times.

**5. Context-Aware Debug**
Skill de debugging que começa coletando contexto (logs, stack trace, estado do sistema) antes de propor solução. Previne "solução sem diagnóstico". Discipline skill.

**6. Security Review Checklist**
Após qualquer mudança de código, roda checklist de OWASP Top 10 específico para o stack. Capability skill com alto valor por interação.

## Metodologia de Avaliação

O autor testou cada skill em 5 dimensões ao longo de 3 semanas de uso intenso:

| Dimensão | Método de medição |
|---|---|
| Trigger accuracy | % de ativações corretas vs falsas |
| Output quality delta | comparação blind com e sem skill ativa |
| Conflict rate | % de conflitos detectados com outras skills |
| Token overhead | tokens adicionais no contexto vs ganho de qualidade |
| Durability | degradação de performance ao longo do tempo com updates do modelo |

Skills com baixo trigger accuracy ou alto conflict rate foram eliminadas independentemente da qualidade do output — um bom resultado no momento errado é pior que nenhum resultado.

## O Problema de Skill Bloat

O artigo nomeia "skill bloat" como o anti-padrão mais comum: acumular skills até que o espaço de decisão do agente fique tão grande que ele não consegue mais escolher corretamente qual usar. Sintomas:
- O agente ativa a skill errada para a tarefa (trigger collision)
- Skills entram em conflito e o agente alterna entre dois comportamentos
- O contexto fica saturado com instruções de skills, reduzindo espaço para a tarefa real
- Latência aumenta porque o modelo precisa processar mais contexto de instrução

A recomendação: manter no máximo 10-15 skills ativas simultaneamente. Acima disso, testar se há degradação de performance antes de adicionar.

## Comparação com o Artigo de Deleção de 247 Skills

Este artigo complementa o "I Deleted 224 of 247 Skills" com foco oposto: onde aquele foca no processo de eliminação e segurança, este foca no que torna uma skill excelente. Juntos, formam um framework completo de curadoria.

| Critério | Este artigo (top 6) | Artigo 247 (deleção) |
|---|---|---|
| Foco | Excelência de design | Eliminação de riscos |
| Métrica | ROI e trigger accuracy | Segurança e escopo |
| Outcome | 6 padrões de skill ideal | Critérios de veto |

## Relevância para o Vault

A distinção capability/discipline é diretamente aplicável ao index de skills do vault-michel. Skills como `karpathy-principles` e `token-economy` são discipline skills de alta cobertura. Skills específicas como `xlsx` ou `pptx` são capability skills de cobertura baixa. O equilíbrio certo é ter mais discipline do que capability.

## Relações

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — framework central
- [[03-RESOURCES/sources/claude-code-skills/clipping-i-deleted-224-of-247-claude-skills]] — artigo complementar (perspectiva de eliminação)
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]] — as melhores discipline skills implementam esses princípios
- [[03-RESOURCES/entities/Claude Code]] — plataforma

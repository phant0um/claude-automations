---
title: "Beyond Domains: Reusing Web Skills via Transferable Interaction Patterns"
type: source
source: Clippings/Beyond Domains Reusing Web Skills via Transferable Interaction Patterns.md
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central
Bibliotecas de skills para web agents falham em transferir entre domínios diferentes (e-commerce → fórum → dev tools) porque o retrieval depende de similaridade textual/instrução, que não captura que sites com vocabulário totalmente diferente podem compartilhar o mesmo padrão estrutural de interação. SkillMigrator resolve isso indexando skills por estrutura de layout, não por wording.

## Argumentos principais
- **Transferable Interaction Pattern (TIP)**: cada skill armazenada é uma tupla `(intent, operation_template, slot_schema, tree_skeleton)` — nunca um replay literal de ações (que não sobrevive a relabeling). O `tree_skeleton` é o "esqueleto" da árvore de acessibilidade no momento da indução, usado para comparar estrutura de página, não conteúdo.
- **Retrieval híbrido**: score = α·(similaridade textual intent+slots) + (1-α)·(similaridade de layout via tree edit distance/APTED). O sinal de layout domina quando duas páginas usam labels diferentes para forms estruturalmente análogos.
- **Slot schema com sinônimos**: cada slot ("post_title") carrega um conjunto de sinônimos minerados de trajetórias de treino ("title, headline, subject, summary...") — permite o grounding de "Summary" numa página de review apesar do skill ter sido induzido a partir de "Title" num fórum.
- **Fallback seguro**: quando não há match confiável, o agente cai para geração primitiva via LLM em vez de executar skill incompatível — evita over-retrieval custoso.
- **Resultado**: 8-10% de redução no número médio de ações LLM em trajetórias bem-sucedidas (WebArena + Mind2Web) vs SOTA (ASI, SkillWeaver, PolySkill), com taxa de sucesso equivalente.

## Key insights
- A taxonomia do campo (same-website → same-domain → cross-domain) mapeia diretamente em generalidade decrescente do problema mas crescente do payoff — PAPO... digo, SkillMigrator é o primeiro a atacar "beyond domain" especificamente.
- Achado empírico chave: conforme o teste se move de cross-task → cross-website → cross-domain, a taxa de reuso de skill cai e o custo por passo sobe em lock-step para os baselines — confirma que retrieval semântico puro degrada com a distância estrutural/domínio.
- O padrão "armazenar estrutura + slots com sinônimos, não literais" é generalizável: qualquer sistema de skills/macros que precise sobreviver a mudanças de superfície (rewording, rebranding, relayout) se beneficia de separar "intenção abstrata" de "binding concreto".

## Exemplos e evidências
- Exemplo central (Fig. 1/3): skill induzido em Postmill (fórum, campos "Title"/"Body") é reutilizado numa página de review de e-commerce (campos "Summary"/"Review") via sinônimos de slot + tree edit distance.
- Avaliação em WebArena (812 tasks, 6 domínios) e Mind2Web (splits cross-task/cross-website/cross-domain).

## Implicações para o vault
- Adiciona ao corpo de [[03-RESOURCES/concepts/agent-systems/web-agent-skill-learning]] uma dimensão nova: organização por **layout/estrutura** em vez de só URL pattern (skill graph existente) ou texto — útil se o vault avaliar libraries de skill para automação de browser.
- O princípio "abstrair intent+slots com sinônimos, não literais" ecoa com [[03-RESOURCES/concepts/agent-systems/agent-skill-graduation]] (SKILL.md graduado deve generalizar além do caso específico que o originou).

## Links
- [[03-RESOURCES/concepts/agent-systems/web-agent-skill-learning]]

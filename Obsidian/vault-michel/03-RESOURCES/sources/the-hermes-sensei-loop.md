---
title: "The Hermes Sensei Loop"
type: source
source: "Clippings/The Hermes Sensei Loop.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central

O autor aplica loop engineering a agentes de pesquisa (não de código) usando Hermes, identificando que o feedback humano manual ("isso está muito consenso", "o formato está bagunçado") é um gargalo lento e não-sistemático. A solução proposta é um par de loops — **Champion Loop** (promoção de prompt só com prova estatística em holdout) e **Feedback Sweep Loop** (coletor automático que alimenta o Champion Loop) — que substituem "vibe-based prompt tweaking" por melhoria verificada, prevenindo overfitting e regressão silenciosa.

## Argumentos principais

- **Generative AI vs. Agentic AI**: Generative AI é prompt → output único. Agentic AI (o que Hermes faz bem) aprende com o output, propõe próximos passos proativamente, e configura cron jobs recorrentes quando sente necessidade recorrente do usuário.
- **Problema identificado**: a qualidade dos outputs/crons depende de modelo + ferramentas + prompt + formato do cron, e hoje isso só melhora com conversação ativa do usuário com o agente — não escala.
- **Sycophancy como risco específico de agentes de pesquisa**: o autor descreve o problema de IA excessivamente agradável (comparação: "um japonês de 23 anos que se inclina mais e ri das suas piadas mesmo quando você não estava brincando, porque quer subir na hierarquia corporativa") — sem revisão adversarial nem teste de stress da tese, os crons dependem inteiramente do usuário para dar feedback de melhoria.
- **Definição de loop**: em vez de um prompt único → uma resposta única, o modelo entra num ciclo de Think, Act, Observe, Repeat — aproximando o agente de um solucionador de problemas autônomo.
- **Hermes já tem um proto-loop**: toma prompts/feedback do usuário, aprende, e melhora no próximo ciclo — mas esse loop depende de feedback humano. O objetivo declarado é substituir esse feedback humano por feedback de agente, ganhando tempo e eficiência.
- **3 metas da aplicação de loops a agentes de pesquisa**: (1) melhorar a qualidade dos principais cron jobs de pesquisa; (2) validar/invalidar/stress-testar teses para decidir dobrar a aposta ou pivotar; (3) tornar o agente mais autônomo e capaz de "pensar por si".
- **Origem**: Loop Library (31+ loops prontos para copiar/adaptar, majoritariamente voltados a coding/ops) — o autor adaptou apenas alguns para aplicar a crons de pesquisa.

### Loop 1 — Self-Improving Champion Loop

- Resolve o problema de qualidade de output estagnada. Transforma melhoria de prompt de "vibes" em melhoria verificada: toda mudança precisa se provar em dados nunca vistos pelo prompt.
- **Mecânica**: existe um "champion" (prompt atual) e um holdout set (6 dias de output não tocados, com ground-truth labels). Todo "challenger" precisa vencer o champion nos dias de holdout por uma margem definida, sem quebrar regras must-pass. Se não conseguir, é rejeitado e o champion permanece.
- **Passo 1 — Congelar baseline**: pegar o prompt atual (champion), pontuar em 20 exemplos passados, dividir em 14 (edição) + 6 (holdout nunca tocado). Registrar ambos os scores.
- **Passo 2 — Corrigir UMA coisa**: escolher uma falha registrada específica, mudar o prompt só para essa falha — nada mais. Isso é o "challenger".
- **Passo 3 — Provar em dado não visto**: testar o challenger no working set primeiro; se parecer melhor, congelar e testar no holdout set (os 6 exemplos nunca editados contra). Só promove se vencer o champion no holdout por margem definida E não quebrar regras must-pass.
- **Passo 4 — Parar quando parar de melhorar**: meta atingida → shippar. Budget esgotado → shippar melhor champion. Duas rodadas sem melhoria no holdout → máximo local, parar de ajustar.
- **A regra que faz funcionar**: nunca promover no working set — isso causa overfitting (o prompt fica ótimo nos exemplos que você está olhando e pior em exemplos novos). Promoção via holdout é o "sistema imunológico" que pega regressão antes de ela ir ao ar.
- **Analogia do analista júnior**: treinar em 14 memorandos de negócio, acertar todos — mas no negócio #15 (nunca visto) recomendar um LBO de 4x leverage numa mineradora cíclica "porque foi assim que estruturamos o memo #4", quando o memo #4 era uma SaaS com 90% de receita recorrente — o padrão aprendido não generaliza, memorizou exemplos em vez de entender princípios. Comparação direta com não fazer backtest de estratégia de trading nos mesmos dados em que foi construída.
- **Benefícios**: cada rodada de mudança é logada, verificada, pontuada e testada; outputs melhoram de forma consistente ao longo do tempo.

### Loop 2 — Feedback Sweep Loop

- O coletor automático que alimenta o Champion Loop: escuta as reclamações do usuário, organiza por workflow, e entrega ao Champion Loop uma lista limpa de "o que corrigir a seguir, ranqueado por quantas vezes você reclamou disso".

## Key insights

- O autor está aplicando os dois loops a 3 workflows próprios: Equities Daily (relatório de portfólio, tailwinds/headwinds), Top 7 Synthesis (top 7 manchetes do dia, mudança vs. contexto passado, por que importam, ações), e Alpha Triage (o que importa pro book agora, ranqueado por tiers).
- Antes do Champion Loop poder rodar, é preciso reunir working sets e holdout sets por workflow — o autor está dando feedback, scores e preferências agora, esperando rodar após uma semana.
- Efeito colateral pessoal notado: o processo de estruturar feedback para o agente ensinou o autor a dar feedback mais vocal e estruturado em geral, "pensar antes de falar (ou digitar)" — tornando-se, segundo ele, um gestor melhor por causa do agente.

## Exemplos e evidências

- Split de dados: 20 exemplos passados → 14 working + 6 holdout.
- Holdout set descrito como "6 dias de output não tocados, com ground-truth labels".
- Fonte de loops: Loop Library, lançada em 18/06, com 31+ loops "copiáveis ou adaptáveis", majoritariamente voltados a coding/ops — confirma o padrão já catalogado na fonte "Loop Library: Repeatable AI Agent Workflows" absorvida em loop-engineering-patterns.

## Implicações para o vault

Esta fonte tem ligação direta e pessoal com a arquitetura Hermes do próprio usuário ([[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]] e [[03-RESOURCES/concepts/agent-systems/hermes]]) — o Champion Loop descrito aqui é candidato direto a padrão aplicável ao processo de hill-climbing dos próprios skills/agents do vault, e ao mecanismo de "Hermes Dreaming" já referenciado em loop-engineering-patterns como Loop Recursivo. O conceito de holdout set para evolução de prompt (em vez de tweak ad-hoc) é uma adição metodológica concreta que falta no concept de loop-engineering-patterns atual — vale absorver como evidência/perspectiva.

## Links

- [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]]
- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/hermes]]
- [[03-RESOURCES/concepts/agent-systems/agent-feedback-loop-learning]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]

## Minha Síntese

**O que muda:** Dá um nome e uma mecânica concreta (champion/challenger + holdout set) para algo que eu já faço de forma ad-hoc no vault — corrigir skills/agents com base em feedback solto sem provar a melhoria em dados não vistos. Mostra que "promover no working set" é o erro estrutural que causa regressão silenciosa.

**Conexão pessoal:** Conecta diretamente com a minha própria stack Hermes e com o mecanismo de auto-evolução já documentado em `04-SYSTEM/wiki/errors.md` e nos agentes `hill`/`extend` — hoje a correção de agentes do vault é mais parecida com "vibes" do que com Champion Loop.

**Próximo passo:** Avaliar se vale desenhar um holdout set mínimo (ex.: 6 ingestões passadas com nota de qualidade conhecida) para validar mudanças no `ingest-agent` antes de promovê-las, em vez de ajustar o prompt direto.

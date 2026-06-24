---
title: "Miles Deutscher: I connected my entire business to Hermes x Obsidian"
type: source
source: "Clippings/Miles Deutscher on X.md"
created: 2026-06-19
ingested: 2026-06-21
tags: [ai-agents, hermes-agent]
---

## Tese central
Thread viral propondo conectar um vault Obsidian completo (notas de cliente, SOPs, logs de reunião, decisões de negócio) ao Hermes Agent, que o usa como contexto persistente e auto-evoluído ao longo do tempo, sugerindo e construindo automações sozinho a partir do conteúdo ingerido — incluindo um prompt para "todas as noites, ingerir dados do vault e construir automações autonomamente".

## Argumentos principais
- Receita de 3 passos: criar vault "Business Brain" dedicado em Obsidian → conectar Hermes ao vault com prompt que o designa "orquestrador de negócio" → deixar Hermes ingerir cada nova nota automaticamente, construindo memória viva do contexto de negócio.
- Padrão de prompt central: "todas as noites enquanto eu durmo, ingira dados do vault e construa automações autonomamente" — citado como "uma das automações mais poderosas e simples" possíveis.
- As respostas da comunidade (citadas no próprio clipping) levantam objeções relevantes: risco de vazamento de dados de cliente, risco do agente reescrever SOPs de forma que só ele entende, e a pergunta direta "por que isso é melhor que um Project do ChatGPT/Claude com os mesmos arquivos?" — sem resposta satisfatória do autor original no thread capturado.

## Key insights
- A receita descrita é estruturalmente quase idêntica ao próprio pipeline deste vault (Captura→Ingestão→Consolidação, hot.md, manifest) — mas sem nenhuma das salvaguardas que este vault já tem: aqui não há triagem por score, não há revisão antes de "construir automações sozinho", não há limite de autonomia explícito equivalente aos tiers "confirmar antes" do CLAUDE.md.
- A objeção da comunidade ("até o agente reescrever SOPs de um jeito que só ele entende") é exatamente o risco que o princípio Surgical Changes + tiers de autonomia deste vault foi desenhado para mitigar — vale como evidência externa de que autonomia sem grade de confirmação é um risco real reportado por usuários, não hipotético.

## Exemplos e evidências
- Prompt literal de configuração e de automação noturna autônoma.
- Objeções da comunidade citadas no próprio clipping (vazamento de dados, SOPs ilegíveis, comparação com Projects).

## Implicações para o vault
Caso de uso e contraexemplo ao mesmo tempo: confirma a demanda real por "vault + agente que se auto-evolui", mas as objeções da própria comunidade reforçam por que este vault adota tiers de autonomia e confirmação antes de operações de grande escopo — não adotar o padrão "constrói automações sozinho à noite sem revisão" sem grade equivalente ao já existente neste CLAUDE.md.

## Links
- [[03-RESOURCES/entities/Hermes-Agent]]
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]

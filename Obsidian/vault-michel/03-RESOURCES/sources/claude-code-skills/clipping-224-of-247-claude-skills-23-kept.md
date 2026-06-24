---
title: "I Deleted 224 of 247 Claude Skills I Tested — 23 Kept"
type: source
source_type: clipping
category: ai-agents
ingested: 2026-05-05
author: "@Mnilax"
platform: X/Twitter
tags: [claude-skills, skill-evaluation, plugin-marketplace, productivity, testing-methodology]
triagem_score: 8
---

# I Deleted 224 of 247 Claude Skills I Tested — 23 Kept

**Author:** @Mnilax | **Published:** 2026-05-05

## Summary

Rigorous 6-week evaluation of 247 Claude skills from the marketplace (which grew from 16 official to 900K+ community skills by May 2026). Methodology: isolated installs, 5 representative tasks per skill, timed against baseline, quality scored 1-5, context overhead tracked. Pass criteria: ≥1.5 quality improvement, ≥30% time savings, or enables previously impossible tasks. Results: 23 skills survived.

## Key Takeaways
- **Tier S (5 skills):** frontend-design (Anthropic), superpowers (obra), plus 3 others — largest measurable lift
- Testing methodology: isolation, timing, quality scoring, context overhead measurement
- Fail criteria: no improvement, context cost > value, skill conflicts, unmaintained since Feb 2026
- Install order matters — all 23 at once burns context window before useful output
- Marketplace scale (900K+ skills) means most are noise; systematic testing is essential
- Alternative to frontend-design: pbakaus/impeccable (23 commands, 2 modes, Chrome overlay)

## Concepts Linked
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-window]]
- [[03-RESOURCES/concepts/agent-systems/agent-evaluation-production]]

## Entities Linked
- [[03-RESOURCES/entities/Claude Code]]

## Metodologia de avaliação em detalhe

O protocolo de 6 semanas com 247 skills é um dos testes mais rigorosos publicados sobre o ecossistema. Os critérios de aprovação — ≥1.5× melhoria de qualidade, ≥30% economia de tempo, ou habilidade anteriormente impossível — são deliberadamente exigentes. A maioria dos skills falha porque promete uma capacidade que Claude já tem nativamente (o skill adiciona overhead de contexto sem entregar diferencial real).

### Por que isolamento importa

Instalar todos os 23 skills sobreviventes de uma vez "queima a janela de contexto antes de output útil" — cada skill carrega sua descrição no contexto disponível. Com 900K+ skills no marketplace em maio de 2026, o custo de contexto de descoberta se tornou um problema real. A solução do autor é carregar apenas o subconjunto relevante para a tarefa atual, não o arsenal completo.

### Critérios de falha mais comuns

1. **Nenhuma melhoria mensurável:** o skill faz o que Claude já faz, com overhead de instrução adicional
2. **Custo de contexto > valor:** o SKILL.md é longo demais; o espaço que ocupa supera o benefício
3. **Conflitos entre skills:** dois skills com instruções contraditórias degradam o comportamento de ambos
4. **Sem manutenção:** skills não atualizados desde fevereiro de 2026 falharam em 60%+ das tarefas testadas

### Alternativa ao frontend-design

`pbakaus/impeccable` (23 comandos, 2 modos, overlay no Chrome) é mencionado como alternativa. Isso aponta para um padrão: skills oficiais da Anthropic tendem a dominar o Tier S porque têm manutenção contínua e testagem interna — mas skills da comunidade com escopo ultra-específico podem superar os oficiais em nichos bem definidos.

## O que os 23 skills sobreviventes têm em comum

Com base nos critérios de avaliação, os survivors compartilham características:
- **Escopo cirúrgico:** fazem uma coisa, fazem bem, não tentam ser genéricos
- **Instrução compacta:** SKILL.md curto, custo de contexto baixo
- **Feedback loop claro:** é fácil medir se o skill ajudou ou não na tarefa específica
- **Manutenção ativa:** atualizados para refletir mudanças no comportamento do Claude

## Implicações para criação de skills

Se 224 de 247 falham no teste, o prior correto ao criar um novo skill é "provavelmente não preciso disso". A pergunta certa antes de criar um skill: Claude já faz isso adequadamente? Se a resposta for "sim, mas não consistentemente", a solução é provavelmente uma regra no CLAUDE.md, não um skill novo. Skills são justificados quando o comportamento desejado é suficientemente complexo para merecer um prompt dedicado, ou quando o workflow é suficientemente repetitivo para justificar o overhead de instalação e manutenção.

## Escalabilidade do problema

Com 900K+ skills no marketplace (crescimento de 16 oficiais para 900K+ em meses), a qualidade média inevitavelmente despenca. O marketplace segue uma lei de potência: poucos skills de alta qualidade, cauda longa de ruído. A metodologia de @Mnilax (instalar, testar em isolamento, medir objetivamente) é o único filtro confiável nesse ambiente.

## Relevância para vault-michel

O vault usa skills do claude-obsidian suite. Aplicar a mesma metodologia: testar cada skill em isolamento com 5 tarefas representativas, medir tempo, verificar qualidade do output. Skills que não passarem no limiar de 1.5× melhoria devem ser removidos — o overhead de contexto deles ativamente prejudica as sessões onde não são usados.

---

## Análise da Metodologia de Avaliação

### Por Que 5 Tarefas por Skill É o Mínimo

A escolha de 5 tarefas representativas por skill é o piso, não o ideal. Com 5 tarefas, a variância amostral é alta — um skill pode passar por sorte (5 tarefas que favoreciam exatamente o que ele faz) ou falhar por má sorte (5 tarefas que estavam fora do escopo). O autor compensa isso pela estratégia de isolamento e pela exigência de critérios objetivos (tempo, qualidade 1-5, overhead de contexto) em vez de impressão geral.

Para equipes avaliando skills para uso crítico, 10-15 tarefas por skill é o patamar recomendado — suficiente para detectar tanto skills que funcionam bem em casos comuns mas falham em edge cases quanto skills que parecem ruins em primeiras impressões mas têm alto valor em situações específicas.

### O Critério de "Habilidade Anteriormente Impossível"

O terceiro critério de aprovação — "habilita tarefa anteriormente impossível" — é o mais poderoso e o menos bem definido. Uma tarefa "anteriormente impossível" sem um skill pode ser:

1. **Genuinamente impossível:** O modelo não tem o conhecimento ou capacidade de fazer X sem instrução explícita do skill
2. **Tecnicamente possível mas irreproducivelmente inconsistente:** O modelo às vezes faz X corretamente mas não de forma confiável o suficiente para uso em produção
3. **Possível mas tedioso sem o skill:** O modelo pode fazer X com 5 minutos de prompting manual que o skill reduz a uma linha

O critério deveria distinguir esses casos porque têm implicações diferentes para o valor do skill. Caso 1 justifica um skill mesmo que caro. Caso 3 não justifica um skill — um bom template de prompt armazenado no CLAUDE.md é suficiente.

### A Dinâmica do Marketplace: Lei de Potência

A evolução de 16 skills oficiais para 900K+ skills em meses é o padrão clássico de marketplace de dois lados: baixa barreira de entrada + incentivo de distribuição = proliferação massiva com qualidade média decrescente. Isso aconteceu com plugins do VSCode, extensões do Chrome, e apps na App Store.

A diferença aqui é que cada skill instalado tem custo ativo (overhead de contexto), não apenas custo de descoberta. Na App Store, instalar um app ruim desperdiça 50MB de armazenamento. No Claude Code marketplace, instalar 20 skills ruins desperdiça 20-50% da janela de contexto em cada sessão — mesmo quando os skills não estão sendo usados.

Esse custo ativo cria uma seleção natural mais forte que no modelo de app tradicional: usuários são forçados a curar suas instalações ou aceitar degradação de performance perceptível. A metodologia de @Mnilax é uma resposta a essa dinâmica.

### Por Que Skills Unmaintained Falham em 60%+ das Tarefas

A descoberta de que skills não atualizados desde fevereiro de 2026 falharam em 60%+ das tarefas aponta para uma propriedade importante do Claude Code: o comportamento do modelo muda entre versões, e skills escritos para um modelo podem não funcionar com o próximo.

Causas específicas de degradação:
- Instruções que dependiam de comportamentos específicos do modelo que foram modificados (ex: como o modelo formata código, como interpreta frontmatter de skills)
- Referências a comandos ou ferramentas que mudaram de nome ou foram descontinuados
- Instruções que conflitam com comportamentos que o modelo passou a ter nativamente (redundância que vira conflito)

Isso reforça o argumento do vault-michel de manter apenas skills com manutenção ativa. O custo de manutenção de um skill é recorrente — não é um investimento que você faz uma vez.

### Framework Completo para Decisão de Skill

A partir dos dados de @Mnilax, um framework de decisão para criar vs. não criar um skill:

**Criar um skill quando:**
- O comportamento desejado requer instrução especializada que o modelo não executa nativamente com consistência suficiente
- O workflow é suficientemente repetitivo para justificar o overhead de manutenção
- O SKILL.md pode ser curto (< 50 linhas) — se precisar de mais, provavelmente está fazendo demais
- Existe uma maneira objetiva de medir se o skill ajudou (tempo, qualidade, completude)

**Não criar um skill quando:**
- Claude já faz isso adequadamente sem instrução adicional
- A instrução pode ser uma regra simples no CLAUDE.md
- O skill seria genérico (tenta cobrir muitos cenários em vez de um caso de uso específico)
- Não há plano para manutenção quando o modelo evoluir

**Remover um skill quando:**
- Não foi invocado nas últimas 4 semanas de uso normal
- Foi lançado um novo modelo e o skill não foi testado com ele
- Foi adicionado um skill mais específico que cobre o mesmo caso de uso com melhor precision

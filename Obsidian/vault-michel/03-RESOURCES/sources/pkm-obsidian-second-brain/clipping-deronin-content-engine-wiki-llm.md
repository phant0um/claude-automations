---
title: "DeRonin: Automated Content Engine with Wiki LLM — 2 Files"
type: source
source_url: "https://x.com/DeRonin_/status/2053069887266771190"
author: "@DeRonin_"
published: 2026-05-09
ingested: 2026-05-09
source_type: social-media
platform: X/Twitter
language: Portuguese
tags:
  - content-engine
  - wiki-llm
  - html-dashboard
  - automation
  - agentic-workflow
  - clippings
triagem_score: 7
---

# DeRonin: Motor de Conteúdo Automatizado em 2 Arquivos

Thread X by @DeRonin_ descrevendo uma arquitetura mínima de content engine construída com LLM + wiki + artefato HTML.

## A Arquitetura

**2 arquivos:**
- `wiki.md` — Markdown único contendo DNA da audiência: 15 criadores rastreados, todos os tópicos virais dos últimos 30 dias
- `dashboard.html` — Página HTML única que lê o markdown E aciona os agentes

> "O artefato e o agente conversam diretamente um com o outro. A wiki é o cérebro compartilhado."

## O que aparece ao abrir às 9h

- 5 tópicos em alta classificados por adequação ao DNA da audiência
- 3 posts de KOLs que valem a pena citar hoje
- Tweets salvos da semana passada (para surfar ondas ainda quentes)
- Botões: [rascunho de tweet] [rascunho de QT] [agendar] [registrar ideia]

**Fluxo em 4 etapas:**
1. Clicar "rascunho de tweet" em um tópico
2. Artefato avisa o agente
3. Agente lê a wiki, redige na voz do autor, devolve ao artefato
4. Editar, agendar, pronto

**Resultado:** 15 minutos do café da manhã → 3 posts agendados

## Como Construir em Uma Noite

1. **Despejar conhecimento de domínio em UM arquivo markdown** — perfil da audiência, lista de KOLs, regras de conteúdo, guia de voz
2. **Pedir ao Claude para construir artefato HTML** que leia desse arquivo
3. **Adicionar botões** para as ações diárias (rascunho, agendar, registrar, pontuar, pesquisar)
4. **Conectar cada botão para chamar o agente** via chamadas de ferramentas

## Tese Central

> "No momento em que seu artefato lê sua wiki E aciona seus agentes, a maioria das ferramentas SaaS pelas quais você paga silenciosamente se torna desnecessária."

- Painéis que custavam $50/mês = um único arquivo HTML reconstruível em 20 minutos
- Toda ideia de "vou construir um SaaS para isso" = arquivo de 200 linhas escrito em uma tarde
- "Estamos passando de comprar software para possuí-lo."

## Relação com Conceitos Existentes

- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]] — wiki como cérebro compartilhado do agente (Karpathy)
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — o arquivo markdown atua como memória externalizada
- [[03-RESOURCES/concepts/ai-strategy-org/solo-saas-stack-2026]] — posicionamento anti-SaaS, tudo no file system
- [[03-RESOURCES/entities/DeRonin]] — autor
- [[03-RESOURCES/sources/token-economy-cost/clipping-reduced-claude-code-tokens-50-percent]] — outro post do mesmo autor (token optimization)

## Análise da arquitetura de 2 arquivos

A escolha de reduzir o sistema inteiro a 2 arquivos não é minimalismo estético — é decisão de arquitetura com consequências técnicas reais.

**Por que 1 arquivo de wiki em Markdown:**
- Markdown é legível por qualquer LLM sem parsing especial
- Um arquivo único elimina problema de contexto fragmentado (o modelo tem tudo de uma vez)
- Atualizações são cirúrgicas (editar 1 seção) vs sincronização de banco de dados
- Versionável via Git com diffs legíveis — histórico do DNA da audiência ao longo do tempo

**Por que 1 arquivo HTML:**
- HTML permite buttons com onclick handlers que chamam APIs
- O dashboard pode ser aberto localmente no browser sem servidor
- Uma única URL no S3 compartilha o sistema inteiro com a equipe
- Estado da sessão de trabalho (tópicos vistos hoje, posts rascunhados) pode ser mantido em localStorage do browser sem backend

A arquitetura elimina toda a superfície de falha de sistemas SaaS: sem servidor para cair, sem banco de dados para corromper, sem API proprietária para mudar os termos de serviço.

## O dashboard às 9h — engenharia do fluxo de trabalho

O que parece simples (abrir às 9h e ver 5 tópicos) esconde uma pipeline de decisão sofisticada:

1. **Score de adequação ao DNA:** o agente compara cada tópico trending contra o perfil de audiência no wiki.md e gera um score. Tópicos que não se encaixam no perfil não aparecem — reduzindo noise decisório.

2. **Classificação de KOLs a citar:** não é uma lista aleatória de posts virais. O agente identifica posts que (a) são de KOLs rastreados, (b) têm ângulo relevante para a audiência, e (c) abrem uma conversa — não apenas declarações isoladas.

3. **Tweets salvos da semana passada:** a recirculação de conteúdo quente mas não esgotado é uma técnica de distribuição deliberada. O dashboard a automatiza: você não precisa lembrar o que salvou — o sistema apresenta quando ainda é relevante.

4. **Fluxo de rascunho via botão:** o botão "rascunho de tweet" não abre uma aba nova — ele dispara uma tool call para o agente que já tem o wiki.md em contexto. O rascunho retorna em segundos, já na voz do autor porque o wiki.md contém exemplos e regras de voz.

## Comparação com ferramentas de social media management

**Buffer, Hootsuite, Typefully:** schedulam posts, mas não geram conteúdo. O usuário ainda precisa escrever. O custo de $15-$50/mês é pelo agendamento e analytics, não pela criação.

**Taplio, Feedhive:** adicionam sugestões de conteúdo com AI, mas baseadas em dados genéricos de LinkedIn/Twitter — não no DNA específico da audiência do usuário. O output é genérico calibrado para o nicho, não personalizado para a voz.

**Sistema de 2 arquivos do DeRonin:** o wiki.md contém conhecimento real e específico da audiência — 15 criadores específicos rastreados, tópicos virais reais dos últimos 30 dias, regras de voz que o próprio usuário escreveu. O LLM rascunha com esse contexto real. O resultado é mais próximo de "meu editor que me conhece há anos" do que "ferramenta genérica de AI content".

## A tese anti-SaaS e suas limitações

A tese de "de comprar software para possuí-lo" tem apelo claro, mas limitações reais:

**O que funciona bem:** workflows estáveis com inputs previsíveis (daily content, relatórios semanais, triagem de emails). O arquivo HTML pode ser construído uma vez e usado por meses sem modificação.

**O que não funciona tão bem:** workflows que precisam de real-time data sem scraping (analytics de plataformas que bloqueiam automação), colaboração multi-usuário (o arquivo HTML local não sincroniza), e integrações com plataformas que exigem OAuth complexo (agendamento direto no Twitter/LinkedIn via API).

**O ponto de inflexão:** o sistema de 2 arquivos faz sentido até o ponto em que a complexidade do workflow supera o que cabe num dashboard HTML. Para operações de conteúdo com mais de 1-2 pessoas ou com automação de publicação direta (não apenas agendamento), ferramentas dedicadas ainda têm vantagem.

## Relevância para o vault e para o design de sistemas deste projeto

O padrão de "wiki como cérebro compartilhado" é exatamente o que este vault implementa. O `04-SYSTEM/wiki/hot.md` funciona como o wiki.md do DeRonin — um arquivo de estado que os agentes leem para contexto rápido antes de executar. A diferença de escala: este vault tem múltiplos agentes especializados em vez de um dashboard HTML generalista.

O insight de construção em uma noite ("despejar conhecimento de domínio em UM arquivo markdown") é também o princípio por trás das skills do vault: cada skill é um arquivo markdown que concentra o conhecimento de domínio necessário para uma tarefa específica, eliminando a necessidade de re-explicar contexto a cada sessão.

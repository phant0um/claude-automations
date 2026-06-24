---
title: "20 Powerful Agentic-Skills for Claude, ChatGPT & Gemini"
type: source
source_file: .raw/articles/20-agentic-skills-claude-chatgpt-gemini-2026-04-15.md
origin: post no X (autor não identificado)
ingested: 2026-04-15
tags: [skills, agentes, produtividade, escrita, video, codigo]
triagem_score: 7
---

# 20 Agentic-Skills — Claude, ChatGPT & Gemini

Curadoria de 20 skills escritas em `.md` (padrão Claude), mas agnósticas de modelo — podem ser coladas no ChatGPT ou Gemini diretamente.

> [!key-insight] Diferencial em relação à lista de 67 skills
> As skills do artigo anterior ([[03-RESOURCES/sources/claude-code-skills/67-claude-skills-full-dev-team]]) são instaladas via `npx` e ficam no sistema de arquivos. Estas aqui são **portáteis**: arquivos `.md` que funcionam como system prompts colados em qualquer modelo. Menor fricção de adoção, menor dependência de tooling.

## As 5 categorias e 22 skills

### Writing & Content (5)

| Skill | Função |
|---|---|
| `scqa-writing-framework` | Estrutura Situation → Complication → Question → Answer. Usado em consultoria e conteúdo. |
| `content-repurposing-engine` | Long-form → múltiplos formatos (threads, scripts, resumos) |
| `tone-style-enforcer` | Garante voz de marca consistente em todos os outputs |
| `long-form-summary-compressor` | Texto longo → resumo conciso, sem perder informação crítica |
| `structured-copywriting-skill` | Copy com hook forte, fluxo estruturado e CTA |

### Visual & Infographic (4)

| Skill | Função |
|---|---|
| `excalidraw-diagram-generator` | Conceitos textuais → instruções de diagrama para Excalidraw |
| `infographic-builder` | Texto → formato de infográfico estruturado |
| `flowchart-decision-builder` | Input textual → árvore de decisão / fluxograma com branching condicional |
| `ui-ux-layout-advisor` | Sugestões de layout: clareza, espaçamento, hierarquia, acessibilidade |

### Research & Analysis (5)

| Skill | Função |
|---|---|
| `deep-research-synthesizer` | Grandes datasets → insights filtrados + padrões + resumo acionável |
| `onchain-transaction-analyzer` | Transações blockchain → explicação em linguagem simples |
| `source-validation-skill` | Scoring de confiabilidade de fontes + detecção de viés |
| `competitive-intelligence-skill` | Comparação SWOT de produtos/ferramentas/protocolos |
| `knowledge-structuring-skill` | Informação desestruturada → frameworks e hierarquias claras |

### Video (4)

| Skill | Função |
|---|---|
| `video-script-generator` | Scripts com hook, seções, pacing e CTA |
| `video-editing-planner` | Estrutura de edição: cortes, transições, pacing |
| `hook-generator` | Ganchos de atenção para vídeos, posts e intros |
| `caption-subtitle-formatter` | Legendas com timing correto e legibilidade |

### Coding & Automation (4)

| Skill | Função |
|---|---|
| `code-review-skill` | Bugs, ineficiências, boas práticas + sugestões acionáveis |
| `workflow-automation-agent` | Objetivo → workflow passo a passo com ferramentas mapeadas |
| `skill-creator-meta-skill` | Meta skill: gera novas skills em `.md` automaticamente |
| `devops-assistant` | Commit, versioning, deployment, automação de workflow |

## Padrões de design das skills

Cada skill contém: `name`, `description`, `Overview`, `Keywords`, `Features`, `Output Format`, `Instructions`, `Constraints`.

O campo **Constraints** é análogo às "restrições negativas" identificadas em [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — define limites que previnem comportamentos indesejados.

## O diferencial de portabilidade — análise técnica

A portabilidade dessas skills (colar em qualquer modelo) se deve à escolha de formato: arquivos `.md` funcionam como system prompts estruturados que qualquer LLM moderno consegue processar. A diferença em relação ao formato `npx skills@latest add`:

**Skills via npx (Claude Code):** instaladas no filesystem em `.claude/skills/`, carregadas automaticamente pelo harness do Claude Code antes de cada sessão. Dependem de infraestrutura específica.

**Skills portáteis (este artigo):** coladas como system prompt no início de uma conversa — ou adicionadas ao campo de "instrução de sistema" disponível no ChatGPT Plus, Gemini Advanced, e Claude.ai. Funcionam onde quer que haja um campo de instrução de sistema.

Para usuários que alternam entre modelos (Claude para raciocínio complexo, GPT-4o para integração com apps Microsoft, Gemini para multimodal), a portabilidade é uma vantagem real — uma skill de `code-review` funciona igual em todos os três.

## Análise das 5 categorias por utilidade prática

**Writing & Content:** a `scqa-writing-framework` é a mais valiosa desta categoria. SCQA (Situation-Complication-Question-Answer) é o framework que consultoras de topo (McKinsey, Bain) usam para estruturar todos os documentos executivos. Uma skill que instrui o modelo a seguir SCQA produz documentos com clareza que a maioria dos prompts livres não atinge.

**Visual & Infographic:** a `excalidraw-diagram-generator` resolve um problema real: LLMs não podem gerar imagens nativamente, mas podem gerar instruções detalhadas de como criar um diagrama. A skill transforma isso em instrução estruturada que o usuário executa no Excalidraw com mínimo esforço.

**Research & Analysis:** a `source-validation-skill` é a mais subutilizada e mais necessária. Com a proliferação de AI-generated content, validar a credibilidade de fontes virou habilidade crítica. Uma skill que instrui o modelo a aplicar critérios de credibilidade sistematicamente (quem publicou, qual o interesse, quais evidências primárias vs secundárias) agrega valor defensivo.

**Video:** a `hook-generator` é especialmente útil porque hooks de vídeo têm padrões bem definidos (choque, contradição, promessa específica, pergunta aberta) que o modelo pode aplicar sistematicamente quando instruído.

**Coding & Automation:** a `skill-creator-meta-skill` é o item mais interessante — uma skill que gera novas skills. Instrui o modelo a estruturar qualquer instrução de tarefa no formato canônico de skill (name, description, Overview, Keywords, Features, Output Format, Instructions, Constraints). Reduz o tempo de criação de skills customizadas de 30 para 5 minutos.

## O campo Constraints — design de restrições negativas

O campo Constraints merece análise especial porque é o mais contraintuitivo. A tendência natural ao escrever instrução de tarefa é focar no que se quer (Instructions) — mas o que o modelo NÃO deve fazer é igualmente determinante para a qualidade do output.

Exemplos de Constraints bem escritos por categoria:

**Para `code-review-skill`:**
```
Constraints:
- Nunca sugerir reescritas completas — apenas melhorias cirúrgicas
- Nunca comentar sobre estilo quando há bugs funcionais não corrigidos
- Nunca usar linguagem vaga ("poderia ser melhor") — sempre especificar o que mudar e por quê
```

**Para `deep-research-synthesizer`:**
```
Constraints:
- Nunca sintetizar sem citar a fonte primária
- Nunca apresentar como conclusão o que é hipótese ou estimativa
- Nunca produzir mais de 5 insights principais — forçar priorização
```

**Para `tone-style-enforcer`:**
```
Constraints:
- Nunca alterar o conteúdo factual em nome do estilo
- Nunca usar frases de transição clichê ("Em conclusão...", "Em suma...")
- Nunca usar voz passiva a menos que o estilo-alvo a utilize explicitamente
```

Os Constraints transformam a skill de uma instrução de tarefa vaga em um conjunto de regras com dentes — definindo claramente o que o modelo deve rejeitar, não apenas o que deve produzir.

## Como criar skills portáteis para contextos específicos

O framework de 9 campos (name, description, Overview, Keywords, Features, Output Format, Instructions, Constraints) é suficientemente estruturado para criar skills para qualquer tarefa repetitiva. O processo:

1. Identificar uma tarefa que você executa regularmente com LLMs
2. Documentar o prompt que você usa (provavelmente longo e inconsistente entre sessões)
3. Extrair as instruções que valem a pena preservar → campo Instructions
4. Identificar os erros que o modelo comete → campo Constraints (o oposto de cada erro)
5. Definir o formato exato que você quer → campo Output Format
6. Salvar como `.md` — agora é portátil para qualquer modelo

## Relevância para o sistema de skills deste vault

As skills de `knowledge-structuring-skill` e `deep-research-synthesizer` são diretamente aplicáveis ao workflow de ingestão do vault. A `knowledge-structuring-skill` pode ser usada como skill de pré-processamento de qualquer fonte antes de ingestão — estruturando informação desestruturada em frameworks e hierarquias que o wiki-ingest pode então processar.

A `skill-creator-meta-skill` é relevante para o fluxo de criação de skills customizadas do vault — pode acelerar a criação de novas skills especializadas para tarefas do vault que ainda não têm skill dedicada.

## Conexões
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — mesmo mecanismo de SKILL.md, mas portátil (sem instalação via npx)
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — Constraints como restrições negativas estruturadas
- [[03-RESOURCES/sources/claude-code-skills/67-claude-skills-full-dev-team]] — lista complementar: skills via npx para Claude Code

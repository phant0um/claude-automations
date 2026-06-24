---
title: "I Wasted $1,200 on Claude Before Finding This Free Repo on GitHub"
type: source
source_file: ".raw/articles/I Wasted $1,200 on Claude Before Finding This Free Repo on GitHub….md"
author: starmex (@starmexxx)
ingested: 2026-04-17
tags: [claude-cowork, plugins, knowledge-work-plugins, claude-code, anthropic, github, custo-tokens]
triagem_score: 7
---

# I Wasted $1,200 on Claude Before Finding This Free Repo on GitHub

**Autor:** [[03-RESOURCES/entities/Starmex]] (@starmexxx)

## Resumo

Narrativa pessoal de como o autor pagava $200/mês pelo Claude e obtinha resultados de $20 por falta de configuração. A descoberta do repositório `anthropics/knowledge-work-plugins` reduziu o custo para $20/mês com qualidade equivalente ou superior.

> [!tip] Insight chave
> O problema não era o Claude — era a ausência de contexto persistente. Plugins = contexto permanente + zero re-prompting. Sessions mais curtas = menos tokens = conta menor.

## A matemática dos tokens

```
                    Antes plugins    Depois plugins
Re-prompts/tarefa       8-10              1
Tempo de setup       5-10 min            0
Ferramentas          Manual sempre    Bundled
Plano mensal           $200             $20
```

A causa: metade de cada sessão era re-estabelecimento de contexto que já deveria estar lá.

## O que é Claude Cowork (posicionamento no ecossistema)

Três produtos Anthropic:
1. **Claude Chat** — interface de chat web
2. **Claude Code** — ferramenta de terminal para coding agentic
3. **Claude Cowork** — produto desktop para knowledge workers; fica entre Chat e Code; mesma arquitetura agentic do Code, sem terminal

## Os 11 plugins open-source (github.com/anthropics/knowledge-work-plugins)

Sales, Finance, Legal, Marketing, HR, Engineering, Data, Design, Operations, PM, Plugin Create.

**HR** e **Engineering** e **Design** são adições não mencionadas no artigo do Corey Ganim — confirmação de 11 plugins totais.

> [!note] Detalhe Enterprise (fev/2026)
> Update de fevereiro/2026 adicionou: provisionamento por usuário, monitoramento OpenTelemetry de uso de plugins, e controles de acesso por grupo (auto-instalar para Eng, disponível para Legal, oculto para todos os outros).

## Casos de escala citados
- **Spotify:** 90% de redução no tempo de migração de engenharia
- **Salesforce:** 97 minutos economizados por funcionário por semana

## Estrutura de um plugin (confirmação)
```
plugin-name/
├── .claude-plugin/plugin.json   # manifest
├── .mcp.json                    # tool connections
├── commands/                    # slash commands
└── skills/                      # domain knowledge
```
Markdown e JSON apenas. Sem código, sem build steps.

## Instalação via CLI (2 comandos)
```bash
claude plugin marketplace add anthropics/knowledge-work-plugins
claude plugin install sales@knowledge-work-plugins
```
Ou via UI em claude.com/plugins — sem terminal necessário.

## Plugins do Claude Code (diferente dos plugins do Cowork)
Repositório separado: `github.com/ComposioHQ/awesome-claude-plugins`
Inclui: code review com confidence filtering, test generation (Jest/Vitest/Pytest), OWASP Top 10 2025 security scanning, Vercel integration, frontend design skills.

Catálogo unificado: claude.com/plugins (Cowork + Claude Code juntos). Badge "Anthropic Verified" = revisão de qualidade adicional.

## Marketplaces privados (Enterprise)
- Admins conectam repo GitHub privado
- Cowork sincroniza plugins automaticamente
- Funcionários instalam pelo marketplace interno
- Resultado: contexto da empresa codificado — zero re-onboarding do Claude

## Por que plugins resolvem o problema de "context zeroing"

O diagnóstico do artigo é preciso: o problema não era o Claude, era a ausência de contexto persistente. Em termos técnicos, isso é o **context zeroing problem**: cada nova sessão começa com zero contexto sobre quem é o usuário, como ele trabalha, quais são seus projetos e restrições.

Sem plugins, o custo de re-estabelecimento de contexto é real e quantificável:
- 8–10 re-prompts por task = ~2.000–5.000 tokens só de setup
- 5–10 minutos de setup = custo de atenção, não apenas de tokens
- Setup inconsistente = variabilidade de qualidade entre sessões

Plugins resolvem isso injetando contexto permanente antes que o usuário faça qualquer pergunta. O `about-me.md`, `voice.md`, e `preferences.md` chegam carregados na sessão — Claude já sabe quem você é antes de você digitar a primeira palavra.

## A estrutura de plugin em profundidade

A estrutura de 4 arquivos (plugin.json, .mcp.json, commands/, skills/) é minimalista mas completa:

**`plugin.json` (manifest):** define metadados do plugin (nome, versão, descrição), quais permissions o plugin requer (acesso a email, calendar, etc.), e quais outros plugins são dependências.

**`.mcp.json` (tool connections):** especifica quais MCPs o plugin usa e quais tools de cada MCP são necessárias. O plugin de Sales pode precisar apenas das tools de leitura do CRM MCP, não de escrita — isso é configurado aqui.

**`commands/` (slash commands):** arquivos `.md` onde cada arquivo é um slash command disponível no Cowork. Um plugin de Legal pode ter `/contract-review`, `/clause-extract`, `/risk-flag`. O arquivo `.md` contém o prompt que Claude executa quando o comando é invocado.

**`skills/` (domain knowledge):** arquivos `.md` com conhecimento de domínio que Claude carrega quando o plugin está ativo. Para Legal, isso pode incluir: terminologia jurídica, frameworks de análise de risco, red flags padrão por tipo de contrato.

Markdown e JSON apenas — sem código, sem build steps. Isso significa que qualquer pessoa que sabe escrever markdown pode criar ou modificar um plugin, sem precisar de desenvolvedor.

## Os 11 plugins open-source — mapeamento de knowledge workers

A cobertura de 11 domínios (Sales, Finance, Legal, Marketing, HR, Engineering, Data, Design, Operations, PM, Plugin Create) mapeia o espectro completo de knowledge work em uma empresa:

**Sales:** prompts para research de prospects, personalização de outreach, análise de fit, preparação para calls. Reduz o ciclo de pre-call prep de 30 para 5 minutos.

**Finance:** modelos financeiros, análise de métricas, criação de relatórios. Calibrado para linguagem e convenções de analistas financeiros.

**Legal:** review de contratos, extração de cláusulas, análise de risco. Não substitui advogado — reduz o tempo que o advogado gasta em análise inicial.

**Engineering:** code review, documentação, análise de arquitetura, debugging estruturado.

**Plugin Create:** o plugin que cria plugins — um meta-plugin que guia o usuário no processo de criar um plugin customizado para um workflow específico.

## O update de fevereiro/2026 e as implicações enterprise

Três adições do update enterprise merecem análise:

**Provisionamento por usuário:** administradores podem configurar quais plugins cada usuário ou grupo de usuários vê. O engenheiro não vê os plugins de Legal; o jurídico não vê os plugins de Engineering. Reduz ruído e garante que cada pessoa vê apenas ferramentas relevantes ao seu trabalho.

**Monitoramento OpenTelemetry:** cada tool call de plugin gera spans de telemetria. Para compliance, isso significa auditabilidade de quem usou qual plugin para fazer o quê. Para otimização, significa identificar quais plugins são mais usados e quais slash commands convertem melhor.

**Controles de acesso por grupo:** o exemplo "auto-instalar para Eng, disponível para Legal, oculto para todos os outros" mostra o nível de granularidade possível. Plugins sensíveis (acesso a dados de clientes, sistemas financeiros) podem ser restritos a grupos com necessidade real.

## A comparação com Claude Code plugins

A distinção entre plugins Cowork (knowledge workers, interface desktop) e plugins Claude Code (desenvolvedores, terminal) é importante:

| Dimensão | Claude Cowork Plugins | Claude Code Plugins |
|---|---|---|
| Usuário primário | Knowledge workers | Desenvolvedores |
| Interface | Desktop visual | Terminal |
| Instalação | UI no Cowork | CLI: `claude plugin install` |
| Conteúdo típico | Slash commands, skills de domínio | Code review, test generation, OWASP scan |
| Exemplo | `sales@knowledge-work-plugins` | ComposioHQ/awesome-claude-plugins |

O catálogo unificado em `claude.com/plugins` agrega ambos, mas os ecossistemas são distintos. Para quem trabalha com ambos (desenvolvedor que também faz work de PM ou ops), instalar plugins dos dois repositórios cria uma experiência Claude altamente especializada.

## Conceitos relacionados
- [[03-RESOURCES/concepts/claude-code-tooling/claude-cowork-plugins]] — conceito central
- [[03-RESOURCES/entities/Claude-Cowork]] — produto
- [[03-RESOURCES/entities/Claude Code]] — produto paralelo com sistema próprio de plugins

## Links externos
- https://github.com/anthropics/knowledge-work-plugins
- https://github.com/ComposioHQ/awesome-claude-plugins
- https://claude.com/plugins

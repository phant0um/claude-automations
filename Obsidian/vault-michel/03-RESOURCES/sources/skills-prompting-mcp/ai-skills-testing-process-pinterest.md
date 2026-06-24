---
title: "An Engineer's Guide to Better AI Skills: Implementing a Testing Process to Optimize Agent Performance in Any Repository or Skill"
type: source
source: "Clippings/An Engineer’s Guide to Better AI Skills Implementing a Testing Process to Optimize Agent Performance in Any Repository or Skill.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents]
---

## Tese central
Confiar que um agente vai invocar uma skill customizada de forma consistente é arriscado — taxas de invocação medidas (62-73% baseline) são inaceitáveis para workflows de engenharia críticos. A solução é tratar invocação de skill como algo testável empiricamente: construir um harness de testes que mede taxa de sucesso, falsos positivos e acurácia geral, e então iterar nas técnicas (frontmatter description, AGENTS.md, linguagem agressiva) com dados, não suposição.

## Argumentos principais
- Contexto: equipe de engenharia iOS da Pinterest criou uma skill de arquitetura ("rx-mvvm") para guiar agentes a seguir padrões MVVM específicos do repo. Observaram que a skill às vezes não era carregada — descoberto durante revisões arquiteturais onde agentes "falhavam em atingir a barra de skills".
- Resposta: construir um harness de teste reprodutível em vez de confiar em anedota, testando dois agentes (Pin-agent — fork interno do Codex da OpenAI — e Claude Code).
- Estrutura do harness tem 3 componentes que trabalham juntos:
  1. **Core Tool**: script Bash que orquestra, fazendo pipe de prompts para o agente e capturando logs verbosos JSON-streamed.
  2. **Casos de teste categorizados**: 15 prompts "positivos" cobrindo o espectro de domínios da skill (ex.: "load the rx-mvvm-architecture skill", "check if this follows rx-mvvm patterns") + 5 prompts "negativos"/edge (ex.: "fix this Swift compilation error", "write unit tests for this View", "refactor this function") desenhados para expor falsos positivos.
  3. **Heurísticas de log parsing**: detectam invocação de skill buscando padrões como `"name":"Skill"` + `"command":"rx-mvvm-architecture"` no JSON, ou a string `Launching skill: rx-mvvm-architecture`.
- Suite roda múltiplas vezes (5 runs) para compensar a natureza não-determinística dos agentes — 100 testes totais = 5 × (15 positivos + 5 negativos).
- Três métricas calculadas via awk:
  - `CORE_SUCCESS_RATE` = invocações corretas em casos positivos / total positivos × 100
  - `EDGE_FALSE_POSITIVE_RATE` = invocações (incorretas) em casos negativos / total negativos × 100
  - `OVERALL_ACCURACY` = total correto / total de testes × 100
- Conclusão central: mesmo com skill totalmente otimizada, a responsabilidade de usar prompts de alta qualidade e completos continua sendo do engenheiro — testar invocação não substitui bom prompting.

## Key insights
1. **Baseline ruim e desigual entre agentes**: acurácia geral inicial ("vanilla") foi 73% para Codex (GPT 5.2-codex) e apenas 62% para Claude (Opus 4.5) — pior justamente quando prompts eram terse/ambíguos.
2. **Frontmatter description rica funciona universalmente**: incluir mais contexto (componentes arquiteturais relevantes) na descrição YAML do frontmatter da skill deu ganhos mensuráveis, agnósticos ao agente — a técnica de maior retorno geral.
3. **Linguagem agressiva ("YOU MUST LOAD THIS SKILL IF...") funciona mas é "feia"**: o autor reconhece que caps lock/comandos imperativos no frontmatter sinalizam importância e melhoram invocação, mas considera a abordagem "um pouco boba".
4. **AGENTS.md como tabela de skills é opcional**: adicionar uma tabela de skills com razões de uso ao AGENTS.md ajuda no carregamento, mas times precisam balancear contra o custo de tokens de manter AGENTS.md grande.
5. **Combinação de técnicas só compensa para Codex**: aplicar múltiplas técnicas simultaneamente compõe ganhos no Codex, mas o mesmo ganho NÃO se replicou no Claude Code — implica que otimizações para um agente não generalizam automaticamente para outro.
6. **Pedir ao agente para "melhorar" as próprias adições piora a invocação**: contraintuitivo — autocorreção do agente sobre as edições de skill reduziu levemente a taxa de invocação.
7. **Garantia absoluta existe em um caso**: toda execução, em todos os runs, de ambos agentes, carregou a skill quando o prompt dizia explicitamente "load this skill" — o gargalo é prompts implícitos/terse, não a skill em si.

## Exemplos e evidencias
- Prompts positivos de exemplo: `"load the rx-mvvm-architecture skill"`, `"check if this follows rx-mvvm patterns"` (+ 13 outros não listados).
- Prompts negativos/edge de exemplo: `"fix this Swift compilation error"`, `"write unit tests for this View"`, `"refactor this function"` (+ 2 outros).
- Snippet do core tool:
```bash
if echo "$prompt" | claude --print --verbose --output-format stream-json > "$log_file" 2>&1; then
    command_success=true
fi
```
- Snippet de detecção de invocação (Claude):
```bash
skill_invoked_claude() {
    local log_file="$1"
    if grep -q '"name":"Skill"' "$log_file" && grep -q '"command":"rx-mvvm-architecture"' "$log_file"; then
        return 0
    elif grep -q 'Launching skill: rx-mvvm-architecture' "$log_file"; then
        return 0
    else
        return 1
    fi
}
```
- Modelos testados: Codex = GPT 5.2-codex; Claude = Opus 4.5.
- Resultado numérico citado: baseline accuracy 73% (Codex) vs 62% (Claude); aplicar otimizações trouxe ganhos maiores para Codex que para Claude (números exatos pós-otimização não detalhados no texto, apenas referenciados em tabela de imagem).

## Implicacoes para o vault
- Vault tem 40+ agentes especializados em `04-SYSTEM/agents/` — este artigo propõe um método concreto e replicável (test harness com prompts positivos/negativos + log parsing) para validar empiricamente se cada skill/agente é invocado de forma confiável, em vez de assumir que o frontmatter `description` está bem escrito.
- Achado mais acionável para o vault: **frontmatter description rica e específica é a técnica de maior ROI e funciona em qualquer agente** — vale revisar descriptions de skills em `~/.claude/skills/` e `04-SYSTEM/agents/` para garantir que incluem contexto suficiente (domínio, quando usar, componentes envolvidos).
- Achado de cautela: NÃO pedir ao próprio Claude para "melhorar" a description de uma skill que já funciona — pode piorar a taxa de invocação. Mudanças em frontmatter devem ser testadas, não apenas "otimizadas por intuição".
- Conceito novo proposto (claramente ausente e recorrente no domínio "ai-agents"): **ai-skills-testing-process** — metodologia de medir taxa de invocação de skills via harness de prompts positivos/negativos. Criado como concept novo em `03-RESOURCES/concepts/agent-systems/ai-skills-testing-process.md`.
- Relaciona-se com `[[03-RESOURCES/sources/skill-authoring-best-practices]]` (boas práticas de autoria) — este artigo complementa com a etapa de *validação* que faltava no ciclo de autoria de skills.

## Links
- [[03-RESOURCES/concepts/agent-systems/ai-skills-testing-process]]
- [[03-RESOURCES/sources/skill-authoring-best-practices]]
- [[03-RESOURCES/concepts/claude-code-subagents]]

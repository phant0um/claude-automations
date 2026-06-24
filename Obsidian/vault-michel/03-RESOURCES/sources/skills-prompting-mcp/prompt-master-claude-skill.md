---
title: "Prompt Master — Claude Skill"
type: source
created: 2026-04-24
updated: 2026-04-24
tags: [prompt-engineering, claude-skills, ai-tools]
source_file: "Prompt Master.md"
repo: https://github.com/nidhinjs/prompt-master
triagem_score: 7
---

# Prompt Master — Claude Skill

**Tipo:** Claude Skill (instalável via claude.ai → Skills → Upload ou clone em `~/.claude/skills/`)  
**Autor:** nidhinjs  
**Versão atual:** 1.5.0

## O Problema Resolvido

Usuários desperdiçam créditos escrevendo prompts vagos → recebem output errado → repromptam 3–4 vezes. Prompt Master elimina esse loop ao gerar o prompt correto na primeira tentativa.

> "The best prompt is not the longest. It's the one where every word is load-bearing."

## Pipeline Interno (7 Etapas)

1. **Detecta a ferramenta-alvo** — roteamento silencioso (usuário nunca vê)
2. **Extrai 9 dimensões de intent** — task, input, output, constraints, context, audience, memory, success criteria, examples
3. **Faz até 3 perguntas de clarificação** — só se informação crítica estiver faltando
4. **Roteia para o framework correto** — pick automático, nunca exposto ao usuário
5. **Aplica 5 técnicas seguras** — role assignment, few-shot, XML structure, grounding anchors, memory block
6. **Executa token efficiency audit** — elimina palavras que não mudam o output
7. **Entrega o prompt** — 1 bloco copiável + nota de estratégia de 1 linha

## Técnicas Excluídas Intencionalmente

Tree of Thought, Graph of Thought, Universal Self-Consistency, prompt chaining — excluídos por produzir alucinações ou outputs imprevisíveis.

## Memory Block System

Para sessões longas, prepend automático de decisões anteriores:
```
## Memory (Carry Forward from Previous Context)
- Stack: React 18 + TypeScript + Supabase
- Auth: JWT em httpOnly cookies
- Naming: PascalCase, sem default exports
```
Resolve o problema de re-prompts causados pelo AI "esquecendo" decisões anteriores.

## Cobertura de Ferramentas (30+ perfis)

| Categoria | Ferramentas |
|-----------|------------|
| Reasoning LLMs | Claude, ChatGPT/GPT-5.x, Gemini 2.x, DeepSeek-R1, MiniMax |
| Thinking LLMs | o3/o4-mini — instrução curta apenas, sem CoT externo |
| Agentic AI | Claude Code (stop conditions + file scope), Cursor/Windsurf, Cline, Devin |
| Image AI | Midjourney (comma-separated descriptors), DALL-E 3, Stable Diffusion (weight syntax), ComfyUI |
| Video AI | Sora/Runway (camera movement + duration), LTX/Dream Machine/Kling |
| Voice AI | ElevenLabs (emotion + pacing + emphasis) |
| Automation | Zapier/Make/n8n (trigger/action + field mapping) |
| 3D AI | Meshy/Tripo/Rodin (style + export + polygon budget) |

Para ferramentas fora da lista: **Universal Fingerprint** — 4 perguntas que permitem gerar prompt de qualidade para qualquer AI desconhecida.

## 35 Padrões Detectados (anti-patterns)

Agrupados em 5 categorias: Task (7), Context (6), Format (6), Scope (6), Reasoning (5), Agentic (5).

## Invocação

```
Write me a prompt for Cursor to refactor my auth module
/prompt-master
I want to ask Claude Code to build a todo app with React and Supabase
```

## Mecanismo interno: como o roteamento de ferramentas funciona

A Etapa 1 (detecta a ferramenta-alvo) é crítica porque cada ferramenta tem uma "gramática de prompt" diferente. Claude Code, por exemplo, precisa de stop conditions explícitas e escopo de arquivos para não vagar indefinidamente; Midjourney precisa de descritores separados por vírgula com peso sintático específico; o3/o4-mini funcionam melhor com instrução curta sem Chain of Thought externo (o modelo já faz CoT internamente).

O roteamento silencioso significa que o usuário descreve o objetivo em linguagem natural e recebe o prompt na gramática correta da ferramenta-alvo — sem precisar conhecer essas diferenças. É a diferença entre usar uma API com SDK vs. fazer chamadas HTTP cruas.

## Os 35 anti-patterns em detalhe

As 5 categorias de anti-patterns detectados pelo Prompt Master:

**Task (7):** prompts sem verbo de ação, verbos vagos ("ajude-me com"), múltiplas tarefas não sequenciadas, ausência de critério de sucesso, confusão entre task e output, ausência de exemplos quando necessário, scope infinito sem limite.

**Context (6):** ausência de audiência, ausência de domínio, assumir conhecimento implícito, contexto contraditório, over-contextualização (contexto irrelevante que dilui o sinal), contexto desatualizado.

**Format (6):** não especificar formato de output, especificar formato incorreto para a ferramenta, length underspecification, mixing formatos (tabela + prosa sem razão), ausência de estrutura em outputs longos, markdown quando a ferramenta não suporta.

**Scope (6):** escopo infinito, micro-escopo excessivo, escopo que excede capacidade da ferramenta, escopo dependente de informação não disponível, escopo ambíguo entre opções, escopo que viola restrições de segurança da ferramenta.

**Agentic (5):** ausência de stop conditions para agentes, ausência de file scope, sem checkpoint output, sem instruções de erro handling, delegação de decisões que deveriam ser do usuário.

## Comparação com alternativas

**Promptbase / PromptHero (marketplaces de prompts):** vendem prompts prontos para casos de uso específicos. Prompt Master gera prompts customizados para o problema do usuário — não é template, é pipeline.

**ChatGPT prompt optimizer:** existe funcionalidade similar no GPT-4o. Diferença principal: Prompt Master tem perfis específicos de 30+ ferramentas; o otimizador genérico não sabe a diferença entre prompts para Midjourney vs Runway.

**DSPy (programmatic prompt optimization):** framework programático para otimizar prompts via métricas automáticas. Orientado a ML engineers; requer datasets de avaliação. Prompt Master é conversacional e não requer setup técnico.

## Limitações honestas

- A Etapa 3 (até 3 perguntas) pode ser frustrante se o usuário quer velocidade — às vezes a pergunta de clarificação interrompe o fluxo para casos onde a ambiguidade era tolerável
- O token efficiency audit (Etapa 6) pode remover contexto que o usuário considerava importante mas o modelo julgou redundante
- 30+ perfis de ferramenta = surface de manutenção grande; perfis podem ficar desatualizados conforme as ferramentas evoluem (especialmente modelos de vídeo e imagem que mudam rapidamente)
- O Universal Fingerprint para ferramentas desconhecidas funciona razoavelmente mas não tem o refinamento dos perfis específicos

## Uso no contexto do vault

O vault pode se beneficiar do Prompt Master principalmente para:
1. Gerar prompts de ingestão para fontes com estrutura não convencional
2. Otimizar os prompts internos dos agentes do vault (guard, hill, review)
3. Criar prompts de qualidade para solicitações de autoresearch complexas

A skill é instalável globalmente (`~/.claude/skills/`) e fica disponível em qualquer sessão — não requer configuração por projeto.

## Conexões

- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — padrões que Prompt Master detecta e corrige
- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — Prompt Master é um SKILL.md instalável
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]] — o Memory Block é context engineering aplicado a re-prompts
- [[03-RESOURCES/concepts/token-efficiency]] — audit de tokens como etapa explícita no pipeline
- [[03-RESOURCES/entities/Claude Code]] — perfil específico com stop conditions + file scope + checkpoint output
- [[03-RESOURCES/sources/skills-prompting-mcp/you-prompt-claude-wrong-rubenhassid]] — mudanças de prompting para Opus 4.7 que Prompt Master deve incorporar

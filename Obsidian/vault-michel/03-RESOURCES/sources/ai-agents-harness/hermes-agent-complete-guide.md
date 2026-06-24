---
title: "HERMES AGENT: THE COMPLETE GUIDE — From Zero to Self-Improving AI Employee"
type: source
source: "Clippings/HERMES AGENT THE COMPLETE GUIDE. From Zero to Self-Improving AI Employee.md"
created: 2026-05-27
ingested: 2026-06-02
tags: [ai-agents, hermes-agent, self-improvement, multi-agent, model-selection]
author: "@IBuzovskyi"
---

## Tese central
Guia completo do Hermes Agent por alguém que o rodou 24/7 por meses: 3 diferenciais centrais (memória, self-improvement, session recall) + comparação com alternativas + guia operacional completo.

## Argumentos principais
- 3 diferenciais do Hermes: memória em markdown local (não cloud), self-improvement após cada task, session recall com FTS5 full-text
- Self-improvement: cada task concluída é revisada — o que funcionou, o que não funcionou, como fazer melhor; agente edita próprias skills após cada sessão
- Session recall: toda conversa logada com FTS5 + LLM summarization — recall de 3 meses atrás
- Hermes vs OpenClaw: OpenClaw bloated e atualizações quebram o setup; Hermes mais leve, updates não destroem configuração
- Hermes vs Claude Code: Claude Code = vibe coding sessions profundas em apps complexos; Hermes = general purpose employee para tudo o mais
- Multi-agent nativo via Kanban (v0.12.0+): agentes tomam tasks de um board, trabalham em paralelo, passam para o próximo quando bloqueados
- 166 skills rastreadas (87 bundled + 79 opcionais) em 26+ categorias; 20+ plataformas de messaging

## Arquitetura e instalação
- Instalação: curl one-liner para Linux/macOS/WSL2; Windows (PowerShell) em beta; Android (Termux)
- Tiers de modelo: claude-opus-4/sonnet-4 para raciocínio complexo/tarefas /goal longas; modelos baratos para tarefas rotineiras

## Key insights
- "Agentes como Hermes não falham em inteligência, falham em arquitetura" — confirmado na experiência de 60 dias
- Memória em markdown local = transparência total: usuário pode ler, editar, deletar — sem black box
- Self-improvement é o real edge: agente que edita próprias skills se torna exponencialmente melhor com o uso
- Kanban multi-agent: delegação natural de tasks complexas com handoff quando bloqueado
- Separação de jobs: Hermes (daily operations) + Claude Code (deep focused coding) — complementares, não concorrentes

## Exemplos e evidências
- Agente rodando 24/7 em produção — validação prática, não teórica
- 166 skills em 26 categorias — escala de skills disponíveis
- Import de memórias do OpenClaw disponível mas não recomendado: start clean, 2 agentes separados > merge

## Implicações para o vault
- Self-improvement pattern do Hermes alinha diretamente com hill + extend no vault-michel
- Kanban multi-agent é arquitetura para tarefas complexas que o vault ainda não tem (candidato para evolução)
- Distinção Hermes/Claude Code = distinção operações diárias (Nexus) vs sessões deep de coding
- Session recall com FTS5 = funcionalidade candidata para vault-michel (hoje só hot.md para recall rápido)

## Complemento: sequência de setup em 7 dias (@zaimiri, 2026-06-14)

Fonte: [The 7-day Hermes setup (full guide)](https://x.com/zaimiri/status/2066117404392890835)

Resposta prática a "por onde começar" — ordem de camadas importa (errar a
ordem = "assistente ruidoso com acesso demais e julgamento de menos"):

| Dia | Camada | Foco |
|-----|--------|------|
| 1 | Instalação | `hermes setup` → `hermes model` → `hermes doctor` → `hermes chat`. Só provar que roda, chama tools, lê ambiente — sem customização |
| 2 | Identidade | Definir tom, limites de risco, quando pedir aprovação, quando usar tools, formato de resposta final — **antes** de dar mais poder (memória/tools/crons) |
| 3 | Memória (alto sinal só) | Guardar: preferências estáveis, projetos, convenções, erros a não repetir. NÃO guardar: progresso de task, links soltos, status efêmero |
| 4 | Interface | `hermes gateway setup` + `start` — mover pro canal que você já usa (Telegram p/ autor) — uso muda quando agente "vive" onde você fala |
| 5 | Primeira skill real | Só depois de Hermes ajudar em algo real — transformar o caminho que funcionou em skill (quando usar, quais arquivos, quais comandos, como verificar) |
| 6 | Primeiro cron (quieto) | 1 job recorrente só — regra: silêncio se não há sinal. Cron ruidoso = vira "radiação de fundo" e você para de ler |
| 7 | Profile split (só se precisar) | Novo profile quando precisa memória/identidade/tools/permissões diferentes (ex: content vs coding vs client) — não por "parecer legal" |

**Resultado após 7 dias**: `Telegram → Hermes → memory → skill → tool call →
verified output → short receipt` + 1 cron silencioso (`Cron → Hermes →
sources → filter → alert only if useful`).

**Diferencial vs guia principal desta page**: guia principal cobre arquitetura
geral (memória/self-improvement/session recall) e comparação Hermes vs
Claude Code/OpenClaw; este dá a **sequência de implementação** —
especialmente útil o gate "memória alto-sinal apenas" (dia 3, com exemplos
bom/mau lado a lado) e a regra "cron silencioso por padrão" (dia 6), ambos
mecanismos de disciplina que complementam o pattern self-improvement já
descrito acima.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/agent-model-routing]]
- [[04-SYSTEM/agents/nexus]]
- [[04-SYSTEM/agents/core/hill]]

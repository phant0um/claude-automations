---
title: "Responda com uma linha essencial do seu AGENTS.MD e o que ela faz pelo Codex"
type: source
source: Clippings/Responda com uma linha essencial do seu AGENTS MD e o que ela faz pelo Codex.md
author: "thread coletiva — @KingBootoshi e outros"
published: 2026-05 (aproximado)
created: 2026-05-29
ingested: 2026-05-29
tags: [agents-md, codex, claude-code, prompting, patterns, agentsmd-pattern, thread-coletiva]
---

## Tese central

Thread coletiva de practitioners compartilhando linhas únicas e padrões de AGENTS.MD/CLAUDE.MD que provaram ter o maior ROI no comportamento do Codex e outros agentes de código. Cada contribuição é uma heurística operacional destilada de experiência de produção.

## Argumentos principais

- **Única fonte de verdade / greenfield assumption**: assumir que todo projeto é greenfield, sem usuários, sem soluções de contingência, sem suporte a código legado — impede o Codex de escrever seus "notórios caminhos de contingência".
- **DECISIONS.md como arquitetura viva**: registrar cada decisão arquitetural, de design ou organizacional (fora de qualquer direção explícita) em `DECISIONS.md`, com justificativa baseada em padrões e explicação de por que a decisão foi tomada independentemente de qualquer prompt.
- **Debug protocol estruturado como instrução**: não deixar o agente começar a implementar antes de discutir e ter certeza do problema real. O protocolo "Problema aconteceu às HH:MM-MM. Verifique os logs, se não tivermos logs adicione logs para entender a causa raiz, depois reconstrua e reproduza com uso de computador. Se tivermos logs e você tiver certeza sobre a causa raiz, então explique a causa raiz e me dê as melhores opções para resolver esse problema" coloca o operador no banco do motorista.
- **Anti-reflexive agreement**: instruir o agente a não concordar reflexivamente; dar opinião técnica honesta; se o usuário estiver errado, parcialmente errado, ou omitindo um trade-off importante, corrigir de forma clara e direta. Precisão e contraposição útil sobre acordo fácil.
- **Data cutoff awareness**: "É [Mês] [Ano]. Não confie no seu conhecimento de treinamento desatualizado, que está 6-12 meses atrás das últimas atualizações críticas e padrões. SEMPRE use fontes atualizadas e oficiais para se manter alinhado com as melhores práticas." — primeira linha em todos os arquivos dos agentes de um dos contribuidores.
- **Spider web thinking**: pensar em teia de aranha em vez de diagonalmente. O problema/conhecido como hub central da teia; a partir daí divergir para cada ponto de toque até o fio espiral mais externo de código conectado a ele. Descobrir de onde o bug se origina e quais arquivos/código precisam de correção.
- **Review loop como instrução**: "após implementação, rodar os reviewers read-only solicitados em paralelo. Tratar findings válidos como bloqueantes, corrigir, então rodar novamente os mesmos reviewers até limpar. Relatório final: passes run, issues fixed, e quaisquer findings rejeitados com rationale."

## Key insights

**Linha mais usada (Bootoshi)**: o debug protocol estruturado. Não está no AGENTS.MD formal, mas é o trecho de texto mais colado/mais usado. O motivo: sem ele, o agente continua tentando resolver coisas de forma opaca e sem ter 100% de certeza de que está resolvendo a coisa certa. Com ele: primeiro verificar/logar, depois entender a causa raiz, depois apresentar opções (nunca modo plano direto).

**O padrão full de debug:**
1. Verificar logs se existirem
2. Se não existirem → adicionar logs para entender a causa raiz
3. Reconstruir e reproduzir com uso de computador (Computer Use implícito)
4. Se logs + certeza sobre causa raiz → explicar causa raiz + dar melhores opções para resolver
5. Operador decide a abordagem → agente implementa

**DECISIONS.md como padrão arquitetural**: o insight é que justificar decisões "independentemente de qualquer prompt" significa que o agente documenta mesmo quando o usuário não pediu — cria trilha de auditoria arquitetural automática. Evidência respaldada por padrões, não apenas "eu decidi".

**Greenfield assumption** (Bootoshi): "Assuma que todo projeto é greenfield, sem usuários. Eu busco uma única fonte de verdade: Isso significa sem soluções de contingência, sem suporte a código legado, apenas um fluxo limpo de informação." O efeito específico no Codex: impede caminhos de contingência notórios.

**Anti-reflexive agreement**: a instrução é essencialmente um override do sycophancy padrão dos modelos. Força o agente para um modo de advisor técnico honesto em vez de yes-man. "Corrija-os de forma clara e direta" + "Prefira precisão e contraposição útil a um acordo fácil".

**Temporal anchoring**: fixar explicitamente o mês/ano no AGENTS.MD como primeira linha resolve o problema de knowledge cutoff para práticas que evoluem rapidamente (como o ecossistema de AI agents em 2026). O modelo sabe que está "6-12 meses atrás" e deve buscar fontes atualizadas.

**Spider web debugging**: metáfora poderosa para traversal de código. Centro = problema conhecido, raios = pontos de toque do sistema, fio espiral externo = código mais periférico conectado. Contrasta com "pensar diagonalmente" (que seria pular para soluções sem mapear a rede de dependências).

**Review loop como quality gate integrado**: não apenas "faça review" mas um loop específico: (1) rodar reviewers read-only em paralelo, (2) findings válidos = bloqueantes, (3) corrigir, (4) rerun mesmo reviewers, (5) repeat até limpar, (6) relatório final com passes + fixes + rejections com rationale. Isso é um mini-workflow de CI dentro do AGENTS.MD.

**Contexto de uso**: Codex CLI + `/goal` como primitivo de implementação (substituiu beads/subagents com o 5.5 + Codex CLI). O contribuidor principal menciona "nunca modo plano" — preferência por implementação direta após discussão longa.

## Exemplos e evidências

- **Bootoshi's debug protocol**: texto mais colado na prática diária, apesar de não estar no AGENTS.MD formal
- **Greenfield assumption**: faz "ótimo trabalho em impedir que o Codex escreva seus notórios caminhos de contingência"
- **Data cutoff line**: "É a primeira linha em todos os arquivos dos meus agentes"
- **DECISIONS.md**: padrão que aparece em múltiplas contribuições, não apenas uma
- **Review loop**: "reviewloop:" como keyword de ativação da instrução no AGENTS.MD

## Implicações para o vault

Confirma e aprofunda [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]] com padrões concretos e battle-tested de practitioners. Vários desses padrões são candidatos a incorporação direta no CLAUDE.md ou AGENTS.MD do vault.

O DECISIONS.md pattern é aplicável imediatamente ao vault — registrar decisões arquiteturais do vault com justificativas baseadas em padrões.

O debug protocol estruturado é diretamente usável como skill (`.claude/skills/debug-protocol.md`).

O temporal anchoring (primeira linha declarando o mês/ano) já está implementado em `wiki/hot.md` como contexto de data — confirma a prática.

A instrução de anti-reflexive agreement está no CLAUDE.md do vault sob "Pushback" — confirma alinhamento.

## Links

- [[03-RESOURCES/concepts/agent-systems/agentsmd-pattern]]
- [[04-SYSTEM/skills/core/drift-review]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]

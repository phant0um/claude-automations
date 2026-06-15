---
title: "Edu System"
description: "Sistema educacional de 6 agentes especializados para ADS, concursos e carreira tech"
version: "1.0.0"
updated: 2026-05-15
status: active
tags: [agents, educacao, claude, orchestration]
---

# Edu System

Sistema de 6 agentes especializados em educação, desenvolvimento de carreira e aprendizado técnico, orquestrado pelo Mestre.

## Arquitetura

```
Mestre (orchestrator)
├── Tutor   → ensino TI/ADS adaptativo (Python, Cloud, AI Agents, Cyber, Data)
├── Stack   → pipeline dev educacional ADS (Java, Clean Architecture, 6 etapas)
├── Banca   → prep concurso público (CESPE, FCC, FGV, VUNESP, IBFC)
├── Babel   → idiomas para viajantes e TI (EN/ES/JP/FR/IT)
├── Síntese → resumos Obsidian, flashcards Anki, questões, mapas mentais
└── Trilha  → coach currículo + LinkedIn + carreira TI (estágios)
```

## Agentes

| Agente  | Modelo            | Função                                                  |
|---------|-------------------|---------------------------------------------------------|
| Mestre  | claude-sonnet-4-6 | Orquestração e roteamento                               |
| Tutor   | claude-sonnet-4-6 | Ensino adaptativo em TI: Python, Cloud, AI, Cyber, Data |
| Stack   | claude-sonnet-4-6 | Pipeline educacional ADS/FIAP — Java e Clean Arch       |
| Banca   | claude-sonnet-4-6 | Prep concurso público — CESPE, FCC, FGV, VUNESP, IBFC  |
| Babel   | claude-sonnet-4-6 | Idiomas para viagem e TI — EN/ES/JP/FR/IT               |
| Síntese | claude-sonnet-4-6 | Resumos, flashcards Anki, questões, mapas mentais       |
| Trilha  | claude-sonnet-4-6 | Coach carreira TI — currículo, LinkedIn, estágios       |

## Como invocar

Sempre inicie pelo Mestre ou invoque diretamente se souber o agente:

> `@mestre — quero aprender Docker`
> `@banca — questão CESPE sobre legalidade`
> `@tutor — explica recursão para iniciante`
> `@babel — aula situacional em inglês para aeroporto`
> `@sintese — flashcards sobre SOLID`
> `@stack — etapa 1 do projeto ADS`
> `@trilha — revisar meu currículo`

## Contexto fixo

Michel Csasznik — ADS/FIAP 4º semestre, prep concurso público (área TI/admin), carreira tech.

## Docs do Sistema

| Arquivo             | Propósito                                              |
|---------------------|--------------------------------------------------------|
| `docs/progress.md`  | Sessões ativas, temas em progresso, próximos estudos   |
| `docs/standards.md` | Padrões pedagógicos, tom, critérios de qualidade       |
| `skills/`           | Skills reutilizáveis pelos agentes do sistema          |

## Regras do Sistema

1. Mestre é obrigatório quando o contexto envolve múltiplos domínios simultaneamente
2. Nenhum agente invade o escopo do outro — ver limites nos arquivos de cada agente
3. `progress.md` atualizado ao final de cada sessão longa
4. Contexto Michel (ADS/FIAP, concurso, carreira tech) baked-in em todos os agentes — nunca pedir novamente
5. Nível sempre calibrado antes de ensinar — usar `skills/level-calibrator.md`

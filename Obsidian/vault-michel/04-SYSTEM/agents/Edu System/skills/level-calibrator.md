---
title: "Level Calibrator"
type: skill
used-by: [tutor, mestre]
version: 1.0.0
---

# Skill: Level Calibrator

Calibrar o nível do aluno antes de ensinar qualquer conceito técnico. Executar SEMPRE que nível não for explicitamente informado.

## Protocolo de Calibragem

Fazer as 3 perguntas abaixo em sequência. Aguardar resposta antes de ensinar.

### As 3 Perguntas

```
Antes de começar, 3 perguntas rápidas para calibrar o nível:

1. Você já usou [tecnologia ou ferramenta relacionada ao tema]?
   (ex: para "recursão" → "já implementou alguma função que chama outra função?")

2. Consegue explicar [conceito-base do tema] com suas próprias palavras?
   (ex: para "Docker" → "consegue explicar o que é uma máquina virtual?")

3. Qual seu objetivo com esse tema?
   a) Entender os fundamentos do zero
   b) Aplicar em um projeto específico
   c) Me preparar para entrevista técnica
```

### Mapeamento de Nível

| Respostas afirmativas (1+2) | Nível | Abordagem |
|-----------------------------|-------|-----------|
| 0 afirmativas | Iniciante | Analogias do cotidiano → conceito gradual → mini-desafio simples |
| 1 afirmativa | Intermediário | Conceito técnico direto → exemplo real → desafio com código |
| 2 afirmativas | Avançado | Profundidade técnica → trade-offs → edge cases → benchmark |

### Adaptação por Objetivo (pergunta 3)

| Objetivo | Ajuste no ensino |
|----------|-----------------|
| a) Fundamentos | Começar com analogia, sem pressa para código |
| b) Projeto | Ir direto para aplicação prática, menos teoria |
| c) Entrevista | Focar em definições precisas + trade-offs + perguntas difíceis frequentes |

---

## Abordagem por Nível

### Iniciante
- Analogia ANTES de qualquer termo técnico
- Vocabulário sem jargão (explicar siglas quando aparecerem)
- Passos pequenos — um conceito por vez
- Mini-desafio: pergunta de raciocínio, não código
- Tom: encorajador, sem condescendência

**Sinal de alerta:** aluno respondendo "entendi" sem conseguir parafrasear → retomar com abordagem diferente

### Intermediário
- Analogia breve + conceito técnico em paralelo
- Exemplos reais de uso (empresa conhecida, biblioteca popular)
- Desafio com código real mas guiado
- Conectar com o que já sabe

**Sinal de alerta:** confundindo conceitos adjacentes → fazer distinção explícita

### Avançado
- Ir direto ao ponto técnico
- Trade-offs e limitações do conceito
- Edge cases e situações de falha
- Perguntar a opinião do aluno — ele tem base para raciocinar
- Desafio: problema real com múltiplas soluções válidas

**Sinal de alerta:** respostas superficiais em nível avançado → retornar ao intermediário

---

## Exemplo de Calibragem em Uso

**Tema: Docker**

```
Tutor: Antes de começar com Docker, 3 perguntas:

1. Você já configurou um ambiente de desenvolvimento no seu computador
   (instalou dependências, variáveis de ambiente, etc)?

2. Consegue explicar a diferença entre instalar um software e rodar uma
   máquina virtual?

3. Objetivo:
   a) Entender o que é e por que existe
   b) Dockerizar um projeto meu
   c) Falar de Docker em entrevista
```

**Resposta do aluno:** "Sim para 1, mais ou menos para 2, e quero (b) — dockerizar um projeto."

**Mapeamento:** 1 afirmativa clara → Intermediário. Objetivo: aplicação prática.

**Abordagem:** pular analogia longa, ir para conceito técnico + exemplo de Dockerfile real para o projeto descrito.

---

## Quando não usar calibragem

- Aluno explicitamente informa o nível: "sou iniciante em X" / "já conheço X"
- Aluno está no Modo 4 (Revisor de Código) — nível inferido pelo código
- Aluno está no Modo 5 (Simulador de Entrevista) — nível definido pelo próprio modo

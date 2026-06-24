---
title: "User Stories"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# User Stories

A unidade básica de requisito no Agile — uma frase simples que captura quem quer o quê e por quê, do ponto de vista do usuário.

## O que é

User story (história de usuário) é uma técnica ágil para capturar requisitos de forma centrada no usuário, em linguagem não-técnica. O formato canônico é: **"Como [tipo de usuário], quero [objetivo] para [razão/benefício]"**. Esse formato força o time a pensar em valor entregue — não em funcionalidade técnica.

Stories vivem no **Product Backlog** e são priorizadas pelo Product Owner. Cada story deve ser pequena o suficiente para caber em uma sprint (1-2 semanas de trabalho de um desenvolvedor). Stories grandes demais são chamadas de **épicos** e precisam ser quebradas.

**Critérios de aceitação** definem quando a story está "pronta" — são condições testáveis, escritas em linguagem natural (ou formato Gherkin: "Dado... Quando... Então..."). Sem critérios de aceitação, "pronto" é subjetivo.

**Story points** são uma estimativa relativa de complexidade (não de tempo). Times usam escala Fibonacci (1, 2, 3, 5, 8, 13...) por Planning Poker. **Definition of Done (DoD)** é diferente dos critérios de aceitação — é o checklist global do time (código revisado, testes passando, documentação atualizada).

## Como funciona

Exemplo completo de uma user story:

```
Título: Login com email e senha

Como usuário cadastrado,
quero fazer login com meu email e senha
para acessar minha conta e ver meus pedidos.

Critérios de Aceitação:
- [ ] Login com email/senha válidos → redireciona ao dashboard
- [ ] Email ou senha incorretos → mensagem "Credenciais inválidas" (sem especificar qual)
- [ ] 5 tentativas falhas → bloqueia conta por 15 minutos
- [ ] "Lembrar de mim" → sessão dura 30 dias
- [ ] Botão "Esqueci minha senha" → inicia fluxo de recuperação

Story Points: 5
```

## Por que importa

Na FIAP, projetos em grupo usam Scrum — o PO (geralmente o professor ou um aluno designado) prioriza stories, e o time estima e entrega por sprint. Saber escrever boas stories (com critérios de aceitação claros) é a diferença entre um projeto que entrega o que o cliente queria e um que entrega o que o dev imaginou. Para concursos de Analista de Sistemas, Engenharia de Requisitos e Scrum são tópicos presentes no edital.

## Exemplo

Story ruim: "Implementar autenticação" — quem? o quê? por quê? como saber se está pronto?
Story boa: o exemplo acima — claro, testável, com critérios objetivos.

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/engenharia-de-software]]
- [[03-RESOURCES/concepts/prototipagem]]
- [[03-RESOURCES/concepts/gestao-projetos]]

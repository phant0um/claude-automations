---
title: "How to Use /goal in Claude Code"
type: source
tags: [goal-command, claude-code, agentic, workflow, autonomous-agents]
ingested: 2026-05-14
source_file: gemini-code-1778767956414.md
triagem_score: 8
---

# How to Use /goal in Claude Code

*Defina um resultado — o agente trabalha por horas — zero checagem manual.*

## O que é o /goal

Um comando nativo no Claude Code que foca no estado final (resultado) em vez de apenas um passo individual. O agente planeja, executa, verifica, depura e continua trabalhando até que cada critério de sucesso seja atingido. Não é preciso "babysitar" a IA.

## O Workflow de 5 Passos

1. **OPEN:** Inicie o Claude Code no diretório do seu projeto.
2. **TYPE:** Digite `/goal` seguido do seu resultado esperado (em uma linha).
3. **FILL:** Preencha as seções de Contexto, Critérios de Sucesso, Regras e Barra de Qualidade.
4. **APPROVE PLAN:** O agente listará as tarefas; você revisa e diz "go".
5. **WALK AWAY:** O agente roda sozinho até terminar.

## Anatomia de um Comando /goal

1. **O Resultado (uma linha):** "Envie um dashboard de cripto funcional como um único arquivo HTML."
2. **Contexto:** Projeto, stack, estado atual, restrições, público-alvo.
3. **Critérios de Sucesso:** Específicos e mensuráveis ("todos devem ser verdadeiros"). O agente se auto-avalia antes de parar.
4. **Regras Operacionais:** Planejar primeiro, trabalhar de forma autônoma, auto-verificação, sem placeholders.
5. **Entregável Final:** O que retornar ao terminar (arquivos alterados, provas de funcionamento, resumo).

## DO THIS (Faça Isso)

- Use **Opus 4.7 + High Effort** para tarefas longas.
- Torne os critérios de sucesso **mensuráveis** (não diga apenas "boa UX").
- Utilize **MCPs** para que o agente puxe dados reais.
- **Exija provas** (screenshots, testes aprovados, URL funcional).
- Deixe-o terminar antes de começar a revisar.

## AVOID THIS (Evite Isso)

- Resultados vagos ("melhore o código").
- Interromper no meio da execução para adicionar escopo.
- Permitir que ele pergunte "devo fazer isso?" — responda "decida você mesmo".
- Pular a etapa de aprovação do plano inicial.
- Usar para tarefas minúsculas e pontuais.

## Melhores Casos de Uso

- Construir e fazer o deploy de um app completo.
- Refatorar um repositório inteiro.
- Corrigir todos os testes que estão falhando.
- Fluxos de Pesquisa → Rascunho → Envio de relatório.

## Relacionado

- [[03-RESOURCES/concepts/claude-code-tooling/goal-command]] — conceito central do /goal
- [[03-RESOURCES/sources/guides-courses-howtos/goal-mega-prompt-template]] — template reusável completo
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]] — /goal como extensão autônoma do EPCC
- [[03-RESOURCES/concepts/agent-systems/agentic-reasoning]]

## Por Que /goal é Diferente de um Prompt Longo

A distinção fundamental entre `/goal` e um prompt detalhado é a estrutura de auto-avaliação. Um prompt longo diz ao agente o que fazer. `/goal` diz ao agente o que constituiria sucesso — e o agente usa esses critérios para se auto-avaliar antes de parar.

Sem critérios de sucesso explícitos, o agente para quando "parece pronto". Com critérios, o agente verifica cada critério sistematicamente antes de concluir:

- "Todos os testes passam" → roda a suite de testes, verifica output
- "O dashboard carrega em < 2 segundos em conexão 3G" → testa com throttling
- "Zero warnings no linter" → roda o linter, lê o output

Esta diferença evita o modo "entregou algo que parece com a resposta certa" — o modo de falha mais comum em agentes autônomos.

## Anatomia de Critérios de Sucesso Eficazes

Critérios de sucesso para `/goal` devem ser:

**Mensuráveis:** "performance aceitável" é inútil. "Tempo de resposta da API < 200ms para p95 em carga de 100 req/s" é um critério que o agente pode verificar com um teste de carga.

**Binários:** cada critério é verdadeiro ou falso. "Código bem estruturado" não é binário. "Nenhum arquivo excede 300 linhas" é binário.

**Independentes:** critérios que dependem uns dos outros criam hierarquias que o agente pode satisfazer parcialmente enquanto marca todos como completos. Mantenha cada critério auto-suficiente.

**Verificáveis sem julgamento humano:** o agente precisa ser capaz de verificar cada critério autonomamente. Se verificar requer olhar para a tela e julgar se "parece bom", o critério está mal definido.

## O Papel da Etapa de Aprovação do Plano

A etapa 4 (revisar o plano antes de dizer "go") é o ponto mais subestimado do workflow. Antes que o agente comece a executar, ele lista as tarefas em sequência. Esta listagem serve três funções:

1. **Verificação de escopo:** o agente pode ter interpretado o objetivo de forma mais ampla ou mais estreita que o esperado. O plano torna a interpretação visível antes do trabalho começar.

2. **Identificação de dependências ausentes:** o plano pode revelar que o agente precisa de acesso a uma API, credencial, ou arquivo que ainda não tem. Melhor descobrir antes de 4 horas de trabalho.

3. **Checkpoint de alinhamento:** se o plano inclui passos que você não esperava (ou exclui passos que você assumia que estaria incluídos), agora é a hora de corrigir — não depois de 3 horas de execução.

Pular a aprovação do plano por "confiar no agente" é o mesmo que aprovar um orçamento de obra sem ver o projeto arquitetônico. O agente não erra na execução do plano — ele erra na interpretação do objetivo, e o plano é o momento em que essa interpretação fica visível.

## Casos de Uso por Complexidade de Tarefa

**Uso ideal (>3h de trabalho, múltiplos arquivos, critérios verificáveis):**
- Migrar um schema de banco de dados + atualizar todos os modelos e queries + rodar suite de testes + gerar relatório de migração
- Construir e fazer deploy de um app completo com autenticação, CRUD e testes
- Refatorar um módulo inteiro para nova arquitetura com retrocompatibilidade

**Uso inapropriado (tarefas pontuais, < 15 minutos):**
- Corrigir um bug específico em um arquivo
- Gerar um arquivo de configuração
- Escrever uma função isolada

Para tarefas pontuais, o overhead de definir contexto, critérios e plano excede o benefício. Use um prompt direto.

## Integração com MCPs para Dados Reais

A instrução "Utilize MCPs para que o agente puxe dados reais" é crítica para `/goal` em contextos de dados. Um agente que trabalha com dados fictícios pode produzir um dashboard tecnicamente perfeito que falha imediatamente em produção porque os tipos de dados, formatos, ou volumes reais diferem dos dados simulados.

MCPs conectam o agente a fontes reais (banco de dados, API, arquivos de produção) durante a execução do goal. O agente trabalha com os dados que o produto real vai usar. Os critérios de sucesso podem ser verificados contra dados reais.

Para vault-michel, o padrão equivalente é o agente que lê `.raw/` e `Clippings/` (dados reais) em vez de criar exemplos fictícios durante a ingestão.

## Limitações e Riscos

**Tarefas com escopo mal definido:** `/goal` amplifica ambiguidade. Um objetivo vago ("melhore o codebase") com Opus 4.7 em high effort pode gerar mudanças extensas em direções imprevistas. A etapa de aprovação do plano é a última barreira antes que o agente execute autonomamente.

**Ausência de checkpoint intermediário:** entre "go" e "terminei", o agente trabalha de forma autônoma. Para tarefas de mais de 6 horas, considere dividir em dois `/goal` com um checkpoint humano no meio — não por desconfiança, mas para detectar desvios de escopo antes que acumulem.

**Budget não especificado:** sem `--max-budget-usd`, uma tarefa `/goal` com Opus 4.7 pode consumir valores inesperados, especialmente se o agente entrar em loops de verificação. Especifique o budget máximo explicitamente para tarefas autônomas longas.

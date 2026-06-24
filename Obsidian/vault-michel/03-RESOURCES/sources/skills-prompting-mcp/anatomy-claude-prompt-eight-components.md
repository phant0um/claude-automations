---
title: "The Anatomy of a Claude Prompt — 8 Components"
type: source
tags: [prompt-engineering, claude, opus, workflow, alignment]
ingested: 2026-05-14
source_file: gemini-code-1778768053130.md
triagem_score: 7
---

# The Anatomy of a Claude Prompt

Template desenhado para extrair o máximo de performance de modelos como Opus 4.6+, garantindo que a IA entenda não apenas a tarefa, mas o contexto e o padrão de qualidade esperado.

## Os 8 Componentes

### 1. Task (Tarefa)
```
"Eu quero [TAREFA] para que [CRITÉRIO DE SUCESSO]."
"Primeiro, leia estes arquivos completamente antes de responder:"
```

### 2. Context Files (Arquivos de Contexto)
```
- [filename.md] — [o que ele contém]
- [filename.md] — [o que ele contém]
- [filename.md] — [o que ele contém]
```

### 3. Reference (Referência)
```
"Aqui está uma referência do que eu quero alcançar:"
[Upload do arquivo de referência em markdown ou cole o texto]

"Aqui está o que faz esta referência funcionar:"
[Blueprint de engenharia reversa — padrões, tom, estrutura e regras
extraídos da referência. Formatar cada um como regra começando com
"Sempre" ou "Nunca".]
```

### 4. Success Brief (Briefing de Sucesso)
```
- Tipo de output + tamanho: [Contrato, memo, relatório, proposta, landing page, post?]
- Reação do destinatário: [O que devem pensar/sentir/fazer após a leitura?]
- NÃO deve soar como: [O que evitar — IA genérica, muito casual, jargões?]
- Sucesso significa: [Assinam? Aprovam? Respondem? Tomam uma ação?]
```

### 5. Rules (Regras)
```
"Meu arquivo de contexto contém meus padrões, restrições, armadilhas e
público-alvo. Leia-o totalmente antes de começar. Se você estiver prestes
a quebrar uma das minhas regras, pare e me avise."
```

### 6. Conversation (Conversa)
```
"NÃO comece a executar ainda. Em vez disso, faça-me perguntas de
esclarecimento (use a ferramenta 'AskUserQuestion') para que possamos
refinar a abordagem juntos, passo a passo."
```

### 7. Plan (Plano)
```
"Antes de escrever qualquer coisa, liste as 3 regras do meu arquivo de
contexto que mais importam para esta tarefa."
"Então, me dê seu plano de execução (máximo de 5 passos)."
```

### 8. Alignment (Alinhamento)
```
"Só comece o trabalho quando estivermos alinhados."
```

## Mapa dos 8 Componentes

| # | Componente | Função |
|---|-----------|--------|
| 1 | Task | Define objetivo + critério de sucesso |
| 2 | Context Files | Carrega o conhecimento necessário |
| 3 | Reference | Ancora estilo/padrão com exemplo real |
| 4 | Success Brief | Especifica output esperado e o que evitar |
| 5 | Rules | Injeta restrições e padrões do usuário |
| 6 | Conversation | Força clarificação antes de executar |
| 7 | Plan | Exige plano explícito antes do trabalho |
| 8 | Alignment | Checkpoint de consenso antes da execução |

## Por que 8 componentes e não apenas uma boa instrução

O framework de 8 componentes resolve um problema específico: LLMs como Claude Opus são capazes de outputs excepcionais, mas só quando recebem o contexto correto para ativar essa capacidade. Um prompt de um componente (só a tarefa) ativa o modo "resposta genérica". Oito componentes ativam o modo "especialista com contexto completo".

A progressão lógica dos componentes segue uma ordem não arbitrária:

**1–2 (Task + Context Files):** definem o que fazer e com qual informação. Sem isso, o modelo improvisa contexto.

**3 (Reference):** ancora o output em exemplos reais. LLMs são modelos de linguagem — mostrar um exemplo real de "o que parece bom" é mais preciso do que descrever verbalmente o que é qualidade.

**4 (Success Brief):** especifica o output esperado do ponto de vista do receptor, não do produtor. "Um contrato que o cliente assine" é mais útil que "um contrato completo". Inclui o que o output NÃO deve soar — restrições negativas que previnem o output genérico de AI.

**5 (Rules):** injeta o conhecimento tácito do usuário sobre seu contexto. Sem isso, Claude usa defaults que podem não se aplicar ao caso específico.

**6–7 (Conversation + Plan):** forçam o modelo a articular sua compreensão antes de executar. Isso serve como checkpoint de alinhamento — revela mal-entendidos antes que custem tempo de revisão.

**8 (Alignment):** o checkpoint final. Cria o momento explícito de "estamos de acordo antes de começar?" que previne o erro clássico de Claude executar 2000 palavras na direção errada.

## O componente de Reference em detalhe — engenharia reversa de qualidade

O componente 3 (Reference) é o mais subutilizado e potencialmente o mais poderoso. A instrução de fazer "engenharia reversa" do exemplo de referência é uma técnica sofisticada:

Em vez de apenas mostrar o exemplo e dizer "faça algo assim", o usuário articula explicitamente o que faz o exemplo funcionar. Exemplo:

```
"Aqui está o que faz esta referência funcionar:
- Sempre abre com um dado específico, nunca com generalidade
- Nunca usa voz passiva
- Cada parágrafo termina com uma consequência concreta, não uma observação
- Comprimento de frase médio: 18 palavras
- Nunca usa: 'alavancar', 'otimizar', 'sinergias'"
```

Este processo força o usuário a explicitar conhecimento tácito sobre qualidade que normalmente permanece implícito. E esse conhecimento explicitado funciona como restrições de estilo que o modelo pode aplicar consistentemente.

## O componente de Conversation como anti-padrão de execução prematura

O componente 6 (Conversation) vai contra o instinto natural de querer resultados imediatos. A instrução "NÃO comece a executar ainda" parece contraproducente, mas resolve um problema real:

Em tarefas complexas, Claude frequentemente possui múltiplas interpretações válidas da instrução. Em vez de escolher uma silenciosamente e executar (risco de 50%+ de execução na interpretação errada), a instrução de conversa primeiro força a exposição dessas ambiguidades.

Para uma task como "Escreva a proposta comercial para o cliente X", as perguntas de clarificação podem revelar:
- "O cliente já conhece nosso produto ou é primeira abordagem?"
- "Qual é o tamanho do contrato esperado?"
- "Quem vai ler isso — comprador técnico ou executivo?"

Cada resposta a essas perguntas muda o output de forma significativa. O tempo de 2 minutos de conversa economiza 20 minutos de revisão.

## Aplicação prática do framework — template de invocação

```
TASK: Eu quero [tarefa específica] para que [critério de sucesso concreto].
Leia estes arquivos completamente antes de responder:
[lista de arquivos]

REFERENCE: Aqui está um exemplo de output de alta qualidade para esta task:
[exemplo real]
O que faz este exemplo funcionar:
- [regra 1 derivada do exemplo]
- [regra 2 derivada do exemplo]

SUCCESS BRIEF:
- Tipo de output: [tipo + tamanho esperado]
- Reação esperada do leitor: [o que devem sentir/fazer]
- NÃO deve soar como: [o que evitar]

RULES: Meu context file em [arquivo] contém minhas restrições. Leia-o completamente.

CONVERSATION: Não execute ainda. Faça 2-3 perguntas de clarificação se necessário.

PLAN: Liste as 3 regras mais relevantes do meu context file. Depois dê seu plano em 5 passos.

ALIGNMENT: Só execute quando eu confirmar o plano.
```

## Limitações do framework

**Overhead para tarefas simples:** usar todos os 8 componentes em "resuma este email de 2 parágrafos" é desperdício de tokens. O framework tem retorno decrescente em tasks simples e bem definidas. A heurística: usar componentes 1–2–5 para tasks rotineiras; todos os 8 para outputs críticos ou complexos.

**Dependência de reference de qualidade:** o componente 3 só funciona se o exemplo de referência for genuinamente bom. Usar um exemplo mediano como anchor ancora o output em mediocridade. O usuário precisa de discernimento sobre o que é qualidade antes de usar esse componente efetivamente.

**Friction de adoção:** o framework de 8 componentes demora mais para montar do que um prompt direto. Para quem não faz isso frequentemente, o custo de construção supera o benefício. A solução é templates por tipo de task que o usuário completa em vez de construir do zero.

## Relacionado

- [[03-RESOURCES/concepts/claude-code-tooling/anatomy-claude-prompt]] — página conceitual sintetizando este framework
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — Pattern #16: este modelo como padrão
- [[03-RESOURCES/concepts/llm-ml-foundations/prompt-engineering-patterns]] — conceito geral de engenharia de prompts

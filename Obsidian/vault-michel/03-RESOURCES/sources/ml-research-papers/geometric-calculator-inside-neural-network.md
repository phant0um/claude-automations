---
title: "A Geometric Calculator Inside a Neural Network"
type: source
source: Clippings/A Geometric Calculator Inside a Neural Network.md
created: 2026-05-17
ingested: 2026-05-17
tags: [ml-research, interpretability, mech-interp]
triagem_score: 9
---

## Tese central
Llama 3.1 8B implementa adição modular (a + b mod N) via mecanismo circular geométrico interno — não via lookup table de memorização. Interpretabilidade mecanística revela "calculadora" embarcada em espaço de ativações do modelo. Resultado significativo para compreensão de como LLMs representam estruturas matemáticas.

## Key insights
- **Representação circular geométrica:** números inteiros de 0 a N são representados como pontos em círculo no espaço de ativações. Adição modular = rotação no círculo — operação geométrica, não aritmética simbólica
- **Mech interp em modelo de escala real:** descobertas anteriores de interpretabilidade mecanística eram em modelos pequenos (GPT-2, 1-2 camadas). Identificar padrão geométrico em Llama 3.1 8B indica que mecanismos interpretáveis persistem em escala
- **Não é memorização:** se fosse lookup table, modelo apenas recuperaria resultado. Evidência de representação circular mostra que modelo aprendeu estrutura abstrata de aritmética modular — generaliza para casos fora do treinamento
- **Conecta com activation steering:** entender que ativações representam números como posições em círculo permite intervenções precisas — editar ativação = mudar valor numérico representado

## O que é adição modular

Adição modular: (a + b) mod N, onde resultado "volta para o início" quando passa de N.

Exemplo com N=12 (relógio): 11 + 3 = 2 (não 14). Estrutura é cíclica — idêntica a rotação em círculo.

Por que estudar: aritmética modular é caso ideal para interpretabilidade — tem estrutura matemática definida, é verificável, e é simples o suficiente para mapear mecanismo completo.

## Evidência do mecanismo circular

### Análise de ativações

Pesquisadores extraíram ativações de Llama 3.1 8B quando processando expressões de adição modular. Análise PCA das ativações revela que números são representados em estrutura 2D circular:

- Número n → ponto em ângulo 2πn/N no círculo
- Ativação de "n=0" e "n=N" são idênticas (ponto mesmo ângulo)
- Adição de a + b = rotação de ângulo 2πa/N na representação de b

### Mecanismo por camadas

Pesquisa identifica que diferentes camadas contribuem diferentemente:
- Camadas iniciais: embedding de tokens em representação circular
- Camadas intermediárias: rotação (operação de adição)
- Camadas finais: decodificação da representação circular de volta para token de output

## Implicações para interpretabilidade

### LLMs representam abstrações matemáticas, não strings

Resultado mais importante: Llama não "memorizou" 1000 pares (a+b, resultado). Aprendeu estrutura abstrata de números circulares e operação de rotação. Isso indica que LLMs podem representar conceitos matemáticos genuinamente, não apenas padrões de texto.

### Mech interp é escalável

Identificar mecanismo em modelo de 8B parâmetros (vs 1-2 camadas de modelos de pesquisa anteriores) valida que ferramentas de mech interp — probing classifiers, analysis de ativação, circuit analysis — funcionam em modelos de uso real.

### Activation steering com precisão matemática

Se representação de número é posição angular em círculo, então steering de ativação pode:
- Incrementar número representado (rotação pequena no círculo)
- Verificar qual número está "em mente" (decodificar ângulo)
- Intervir em operações aritméticas em andamento

## Conexão com outros trabalhos de mech interp

- **Grokking (Power et al.):** fenômeno onde modelo aprende adição modular "de repente" após longa fase de memorização. Este paper revela o mecanismo que aparece no grokking
- **Superposition hypothesis (Anthropic):** múltiplos conceitos compartilham dimensões. Representação circular é exemplo de como conceitos são comprimidos em estrutura geométrica eficiente
- **Interpretability para safety:** entender como modelo representa e opera sobre conceitos é pré-requisito para edição de comportamento precisa (alignment)

## Por que Llama 3.1 8B

Llama 3.1 8B é modelo amplamente usado — resultados são imediatamente relevantes para usuários desse modelo. Generalização para outros modelos de escala similar (Mistral 7B, Gemma 9B) ainda precisa de verificação empírica.

## Implicações para uso prático de LLMs

### Aritmética não é o gargalo

Descoberta que Llama 3.1 8B tem calculadora geométrica interna para adição modular sugere que operações aritméticas básicas são bem representadas em modelos de 8B+. Falhas em matemática que usuários observam geralmente são de raciocínio complexo multi-step, não de aritmética básica.

Implicação para prompting: erros em "17 × 23 = ?" não indicam que modelo "não sabe multiplicar" — indicam que o caminho de raciocínio não está ativando as representações corretas. Chain-of-thought ajuda porque força o modelo a usar explicitamente as representações aritméticas identificadas.

### O que interpretabilidade habilita a longo prazo

Se entendermos como LLM representa conceitos matemáticos, podemos:
- Verificar internamente se modelo "sabe" a resposta antes de gerar (confidence calibration real)
- Detectar quando modelo está "inventando" vs genuinamente computando
- Editar diretamente representações incorretas em vez de retraining

Esses casos de uso ainda estão em pesquisa mas este paper é passo concreto nessa direção.

## Por que score 9 para interpretabilidade

Paper em área de mech interp que frequentemente produz insights sobre modelos pequenos mas com pouca aplicabilidade a modelos de produção. Este paper específico tem score 9 porque: (1) usa modelo real de escala (8B), (2) revela mecanismo concreto verificável, (3) conecta diretamente com activation steering que já tem aplicações práticas.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/activation-steering]]
- [[03-RESOURCES/entities/Llama]]

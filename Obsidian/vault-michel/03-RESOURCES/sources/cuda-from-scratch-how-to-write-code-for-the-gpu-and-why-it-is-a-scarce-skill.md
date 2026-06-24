---
title: "CUDA From Scratch: How to Write Code for the GPU and Why It Is a Scarce Skill"
type: source
source: Clippings/CUDA From Scratch How to Write Code for the GPU and Why It Is a Scarce Skill.md
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, llm-infra]
---

## Tese central
Programar GPU não é uma otimização do código sequencial — é uma forma diferente de pensar computação (paralela em massa vs. sequencial). Essa mudança de modelo mental, não sintaxe, é por que a skill é escassa e engenheiros seniores com ela ganham 150-225k USD enquanto empresas reclamam de não achar candidatos.

## Argumentos principais
- CPU = poucos núcleos poderosos para tarefas complexas sequenciais; GPU = milhares de núcleos fracos para tarefas simples em massa e paralelas. A regra que decide tudo: GPU vence quando a mesma operação deve ser aplicada a muitos dados independentemente (sem dependência entre passos).
- Todo AI moderno roda em GPU porque treino/inferência de redes neurais é, no fundo, multiplicação de matrizes — milhões de multiplicações/somas independentes, a tarefa perfeita para paralelismo massivo.
- CUDA organiza threads em hierarquia de 3 níveis: thread (executa o kernel em 1 elemento) → block (até 1024 threads, compartilham memória rápida, mapeiam para 1 streaming multiprocessor físico) → grid (todos os blocks de um launch, rodam independentemente sem sincronização entre si).
- Não há loop no kernel CUDA — o loop se dissolve em milhares de threads paralelas, cada uma computando seu próprio índice via `blockIdx.x * blockDim.x + threadIdx.x`.

## Key insights
- A hierarquia thread/block/grid não é arbitrária — reflete o hardware físico (cada block fica inteiro num streaming multiprocessor); entender esse mapeamento decide se o código é rápido ou lento.
- O preço de mercado da skill (150-225k) é evidência direta de escassez real, não hype — confirma que mudança de paradigma mental é a barreira de entrada, não disponibilidade de documentação.

## Exemplos e evidências
- Kernel CUDA completo e comentado linha a linha (`__global__ void add(...)`) somando dois arrays de 1 milhão de elementos.
- Sintaxe de launch com triple angle brackets especificando blocks e threads-per-block.

## Implicações para o vault
Complementa `inference-engines-hardware-first` e `inference-optimization` com a camada mais baixa (programação de kernel) que sustenta tudo que o vault já documenta sobre eficiência de inferência LLM — útil se algum projeto FIAP tocar em ML/HPC.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-engines-hardware-first]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference-optimization]]

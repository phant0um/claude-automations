---
title: "OCR-Memory: Optical Context Retrieval for Long-Horizon Agent Memory"
type: source
source_type: paper
created: 2026-05-06
tags: [memory, ocr, agents, long-horizon]
triagem_score: 8
---

Full paper on OCR-Memory: optical context retrieval system for long-horizon agent memory. Visual memory representation that captures UI state for agent decision-making over extended task sequences.

## Source

Ingested from: `clippings/OCR-Memory Optical Context Retrieval for Long-Horizon Agent Memory.md`
Ingested: 2026-05-06 (daily scheduled task)

---

## O Problema: Memória em Agentes de Longo Horizonte

Agentes que operam em tarefas longas (dezenas ou centenas de steps) enfrentam o problema do context window finito. Conforme a tarefa avança, informações antigas são dropped do contexto para abrir espaço para novas. Em ambientes de UI (web browsers, desktop apps), o agente literalmente "esquece" como uma tela parecia há 50 steps — mas pode precisar voltar a ela.

Abordagens textuais de memória (armazenar descrições de ações passadas) falham porque: (1) perdem informação visual sutil crítica para navegação, (2) verbosidade comprime mal, (3) indexar por semântica de texto não captura similaridade de layouts visuais.

---

## A Solução: Optical Context Retrieval (OCR-Memory)

OCR-Memory substitui descrições textuais por representações visuais comprimidas do estado da UI. Em vez de escrever "o usuário clicou no botão azul no canto superior esquerdo", o sistema captura um screenshot comprimido e o armazena num índice visual recuperável.

### Componentes principais

**Visual State Encoder:** Converte screenshots em embeddings densos que capturam layout, elementos interativos, e estado atual. Usa vision encoders (CLIP-style) para representação compacta.

**Temporal Index:** Mantém sequência temporal dos estados visuais. Cada estado tem timestamp, ação que causou a transição, e metadados (URL, título de janela, elementos ativos).

**Retrieval Policy:** Quando o agente precisa de contexto histórico, consulta o índice por similaridade visual (qual estado no passado parecia mais com o atual) ou por recência. O retrieval é adaptativo — agentes em dead-end buscam estados similares para encontrar caminhos alternativos.

**Compression Mechanism:** Screenshots são comprimidos agressivamente (downsampling + quantização de cor) para caber no orçamento de tokens. O paper reporta >10x compressão sem perda significativa de recall.

---

## Resultados Empíricos

O paper (arXiv:2604.26622v1) avalia OCR-Memory em benchmarks de long-horizon agent tasks:

- **Web navigation tasks:** Melhoria significativa em tarefas que requerem retornar a estados anteriores (backtracking).
- **Multi-tab coordination:** Agentes com OCR-Memory coordenam informação entre abas sem perder contexto de abas visitadas há muitos steps.
- **Recovery from errors:** Taxa de recuperação de erros aumenta porque o agente pode "ver" como a tela era antes do erro.

---

## Comparação com Abordagens Textuais

| Dimensão | Textual Memory | OCR-Memory |
|---|---|---|
| Fidelidade visual | Baixa | Alta |
| Compressibilidade | Média | Alta (visual compression) |
| Retrieval por layout | Não | Sim (visual similarity) |
| Overhead de tokens | Médio | Baixo (após compressão) |
| Interpretabilidade | Alta | Média |

---

## Limitações

- Funciona apenas em ambientes com interface visual (UI agents). Inaplicável para agentes que operam exclusivamente em texto/APIs.
- Qualidade depende do vision encoder — encoders menores perdem detalhes de UI complexas.
- Latência de encoding pode ser bottleneck em loops de agente rápidos.
- Privacy concern: screenshots podem capturar informação sensível que precisa ser filtrada antes do storage.

---

## Relevância para o Vault-Michel

OCR-Memory é relevante conceptualmente para o design de memória do vault: a ideia de capturar estado como representação comprimida (em vez de descrição textual longa) é análoga ao uso de `hot.md` como sumário comprimido do vault. A diferença é que hot.md usa linguagem natural comprimida enquanto OCR-Memory usa representações visuais.

O princípio de **retrieval por similaridade de estado** (não só por keyword) também informa como pensar sobre recuperação de notas no vault — busca por contexto situacional, não só por tags.

---

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
- [[03-RESOURCES/sources/memory-context-rag/clipping-ocr-memory-optical-context-retrieval-for-long-horizon-agent-]]
- [[03-RESOURCES/sources/memory-context-rag/clipping-adaptive-retrieval-reasoning-models]]
- [[03-RESOURCES/concepts/long-horizon-agents]]

---

## Profundidade Técnica: Como o Visual Encoder Funciona

### O Desafio de Representar UI em Embeddings

Representar uma interface de usuário como embedding não é trivial. UIs têm hierarquia semântica — um botão "Salvar" é mais semanticamente significativo que o fundo da tela, mesmo que ambos ocupem pixels. Encoders CLIP-style treinados em imagens naturais (fotografias) não têm esse bias correto para UIs.

O paper relata que encoders treinados especificamente em screenshots de UI (datasets como Rico, Web UI, VIST-UI) superaram CLIP em retrieval de estados similares de UI, confirmando que o domínio de UI tem características visuais suficientemente distintas para justificar fine-tuning ou treinamento específico.

### Similaridade Visual vs. Similaridade Funcional

Uma distinção crítica que OCR-Memory deve lidar: dois screenshots podem ser visualmente similares mas funcionalmente distintos. Um modal de login e um modal de cadastro têm estrutura visual similar (form + botão + título) mas estados funcionais muito diferentes.

O sistema lida com isso combinando similaridade de embedding visual com metadados da ação que causou a transição de estado. O retrieval não é puramente visual — é visual + temporal + semântico de ação. A query "qual estado parecia mais com este" é complementada por "qual estado estava associado a ações do tipo X".

### O Pipeline de Compressão em Detalhe

A compressão em 3 etapas (spatial downsampling + color quantization + patch tokenization) é projetada para manter informação de UI relevante enquanto elimina redundância:

**Por que spatial downsampling funciona para UI:** UIs modernas são projetadas para ser lidas a distâncias específicas (screen distance de 60-80cm para monitor). Em baixa resolução, o que se perde primeiro são detalhes de pixel que o próprio usuário não percebe a essa distância. O que sobrevive são layout, elementos interativos, e texto principal — exatamente o que importa para o agente.

**Por que color quantization funciona para UI:** Design systems modernos usam paletas limitadas (12-24 cores em design systems como Material, Fluent, Ant Design). Quantizar para 32-64 cores preserva toda a semântica de cor (este botão é primário/secundário/perigo?) com fração dos bits.

**Por que patch tokenization é necessário:** Em vision transformers, cada patch tem custo de token. Patches de fundo sólido ou áreas vazias não contribuem para a semântica da UI — eliminá-los reduz o custo sem perda de informação relevante.

### Retrieval Policy: Dead-End Detection como Caso de Uso Principal

O caso de uso mais valioso do retrieval adaptativo não é "lembre do que estava na tela há 50 steps" — é "este agente está em dead-end, encontre um estado similar do passado de onde ele conseguiu progredir."

A dead-end detection precisa de sinal externo: o agente tentou as mesmas ações N vezes sem progresso, ou o estado atual é visualmente idêntico a um estado de N steps atrás (loop detectado). Quando esse sinal dispara, o retrieval busca estados visualmente similares em momentos da sessão onde o agente *saiu* desse estado com sucesso — fornecendo um mapa de saída baseado em experiência anterior.

### Comparação com Abordagens Textuais: O Trade-off Real

A tabela original (fidelidade, compressibilidade, retrieval por layout, overhead de tokens, interpretabilidade) resume os trade-offs, mas o trade-off mais importante é sobre falhas:

**Quando memória textual falha:** o agente describe a tela como "formulário com campos de nome e email e botão de submit" — mas na próxima vez que vê uma tela similar, a descrição textual não captura qual botão estava em estado de hover, qual campo tinha foco, ou qual mensagem de validação estava visível. O agente se orienta mas perde nuance que pode ser crítica para reproduzir a navegação.

**Quando OCR-Memory falha:** o visual encoder embeddings capturam o layout mas não o significado contextual. Um modal visualmente idêntico pode abrir em contextos diferentes (erro de autenticação vs. expiração de sessão) — OCR-Memory os trata como o mesmo estado, o que pode levar o agente ao caminho errado.

### Aplicações Além de Web Automation

O paper foca em web navigation e desktop automation, mas o princípio é aplicável a:

- **Agentes de jogos:** capturar estado do jogo como screenshot é mais natural que serializar game state em texto
- **Agentes de design (Figma, Adobe):** UIs de ferramentas de design têm estados complexos que texto descreve mal
- **Agentes de análise de dados (dashboards):** dashboards com dados em tempo real são melhor representados visualmente que textualmente

A limitação é o requisito de GPU para encoding em tempo real — em ambientes sem GPU dedicada, o overhead de encoding pode tornar o sistema inviável para loops de agente rápidos.

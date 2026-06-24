---
title: "OCR-Memory Optical Context Retrieval for Long-Horizon Agent Memory"
type: source
source: clipping
created: 2026-05-01
updated: 2026-05-01
tags: [clipping, ai-agents, tools]
triagem_score: 8
---

# OCR-Memory Optical Context Retrieval for Long-Horizon Agent Memory

**Source File:** OCR-Memory Optical Context Retrieval for Long-Horizon Agent Memory.md  
**Size:** 52669 bytes

## Summary

--- title: "OCR-Memory: Optical Context Retrieval for Long-Horizon Agent Memory" source: "https://arxiv.org/html/2604.26622v1" author: published: created: 2026-05-01 description: tags: - "clippings" --- Jinze Li <sup>1</sup>, Yang Zhang <sup>2,<math xmlns="http://www.w3.org/1998/Math/MathML" display="inline" data-latex="dagger"><semantics><mo>†</mo> <annotation>dagger</annotation></semantics

---

**Original Location:** `Clippings/OCR-Memory Optical Context Retrieval for Long-Horizon Agent Memory.md`

---

## O que é OCR-Memory

OCR-Memory (arXiv:2604.26622v1) propõe um sistema de memória visual para agentes de longo horizonte. Em vez de armazenar descrições textuais de estados de UI, o sistema captura e indexa representações visuais comprimidas de screenshots — permitindo retrieval por similaridade visual, não apenas por keywords.

**Autores:** Jinze Li, Yang Zhang et al.

---

## Motivação

Agentes de UI (web automation, desktop automation) operam em ambientes visualmente ricos. Descrever esses ambientes em texto é: (1) verboso, (2) perde informação estrutural do layout, (3) mal comprimível sem perda semântica significativa. Quando o agente precisa voltar a um estado anterior após muitos steps, a descrição textual armazenada não captura suficientemente o que a tela continha para orientar a tomada de decisão.

---

## Arquitetura do Sistema

**Capture Module:** Intercepta screenshots em cada step do agente. Screenshots são pré-processados (resize, quantização de cor) para reduzir tamanho antes do encoding.

**Visual Encoder:** Converte screenshots em embeddings de baixa dimensionalidade usando modelo vision encoder (CLIP ou similar). Embeddings capturam semântica visual: layout de botões, estrutura de formulários, conteúdo de texto visível.

**Temporal Memory Store:** Banco de dados de (timestamp, ação, embedding, metadados). Mantém sequência completa de estados da sessão. Suporta queries por recência e por similaridade de embedding.

**Retrieval Policy:** Quando acionado, o agente formula uma query visual (embedding do estado atual ou de um estado alvo descrito textualmente) e recupera os K estados mais similares do histórico. O modelo recebe os screenshots comprimidos correspondentes como contexto adicional.

---

## Mecanismo de Compressão

O bottleneck de qualquer sistema de memória visual é o custo de tokens. OCR-Memory usa pipeline de compressão em 3 etapas:

1. **Spatial downsampling:** Reduz resolução para capturar estrutura sem detalhes de pixel.
2. **Color quantization:** Reduz paleta de cores — UI modernas usam poucos tons, compressão >3x sem perda.
3. **Patch tokenization:** Divide imagem em patches, descarta patches com baixa informação (fundo sólido, áreas vazias).

Resultado reportado: >10x redução de tokens por screenshot vs. imagem full-resolution, com manutenção de 85%+ de recall em retrieval tasks.

---

## Resultados

Avaliado em benchmarks de web navigation e desktop automation com tarefas de longo horizonte (>50 steps). Métricas principais:

- **Task completion rate:** +18-25% sobre agentes sem memória visual em tasks que requerem backtracking.
- **Error recovery:** Agentes com OCR-Memory recuperam de dead-ends 2x mais frequentemente.
- **Eficiência:** Latência de retrieval <200ms p99 com índice de 1000 estados.

---

## Limitações

- Aplicável apenas a agentes com acesso a interface visual. Inútil para agentes de API pura, código, ou texto.
- Privacy: screenshots capturam tudo na tela, incluindo dados sensíveis. Requer pipeline de sanitização antes do storage.
- Custo computacional do visual encoder em loops rápidos pode ser proibitivo em hardware sem GPU.
- Performance degrada em UIs altamente dinâmicas onde o mesmo estado visual corresponde a estados funcionais muito diferentes (ex: dashboards com dados em tempo real).

---

## Relação com Outros Sistemas de Memória

Comparado a memória textual (Mem0, agentmemory), OCR-Memory sacrifica interpretabilidade humana por fidelidade de estado visual. Para debugging de agentes de UI, poder "rever" o que o agente viu é valioso. Para sistemas puramente de texto, é overhead desnecessário.

A combinação ideal seria memória híbrida: OCR-Memory para estados de UI + memória textual para raciocínio e decisões.

---

## Links

- [[03-RESOURCES/sources/memory-context-rag/clipping-ocr-memory-optical-context-retrieval-full]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/long-horizon-agents]]
- [[03-RESOURCES/concepts/rag-patterns]]

---

## Análise Comparativa com Abordagens de Memória Existentes

### Por Que Memória Híbrida é o Destino Natural

O próprio paper sugere que OCR-Memory e memória textual são complementares. A arquitetura ideal de memória para agentes de UI seria:

- **OCR-Memory** para estados de UI: quais telas foram vistas, em que sequência, e como voltar a estados similares
- **Memória textual** (Mem0 ou similar) para raciocínio e decisões: por que o agente tomou determinada decisão, quais hipóteses foram descartadas, qual é o objetivo atual
- **Memória episódica estruturada** para tarefas completas: sequência de ações de alto nível que completaram tasks anteriores similares

Essa divisão mapeia para como humanos constroem expertise em software: lembramos visualmente onde estão os menus ("o botão de salvar fica no canto superior esquerdo"), mas raciocinamos textualmente sobre estratégias ("quando o formulário falha, primeiro verificar validações, depois checar conectividade").

### Relação com Retrieval Adaptativo

O trabalho de ReaLM-Retrieve (ver [[03-RESOURCES/sources/memory-context-rag/clipping-adaptive-retrieval-reasoning-models]]) é complementar ao OCR-Memory de forma interessante. Ambos abordam o problema de "quando buscar contexto adicional?" mas em domínios diferentes:

- **ReaLM-Retrieve:** quando buscar durante raciocínio textual (detecta incerteza no reasoning chain)
- **OCR-Memory:** quando buscar contexto visual de estados anteriores (detecta dead-ends e backtracking needs)

Um sistema unificado usaria ambos: incerteza textual → busca textual; loop visual detectado → busca visual de estado anterior similar.

### Privacidade como Requisito de Engenharia

O concern de privacidade mencionado nas limitações não é marginal em deployments enterprise. Screenshots capturam:

- Dados de usuário visíveis na tela (PII, dados financeiros, dados médicos)
- Credenciais em campos de senha (mesmo se mascarados, o agente pode ter capturado o estado antes do mascaramento)
- Documentos confidenciais abertos em outras abas ou janelas parcialmente visíveis
- Metadata de sistema (usernames, hostnames, IPs visíveis em logs ou terminais)

Mitigações necessárias:
1. **Mascaramento antes do encoding:** detectar e escurecer regiões com PII antes de processar o screenshot
2. **Escopo de captura restrito:** capturar apenas a janela do browser/app, não a tela inteira
3. **TTL de memória:** screenshots antigos são automaticamente purgados após N dias
4. **Audit trail de acesso:** registrar quais sessões acessaram quais estados históricos

Sem essas mitigações, OCR-Memory em ambientes enterprise não passa de revisão de segurança.

### Benchmarks em Contexto

Os números reportados (+18-25% em task completion, 2x recovery rate) devem ser interpretados com cautela metodológica: a melhoria é em tasks que *requerem backtracking*. Se o benchmark inclui tasks lineares (que não requerem backtracking), o improvement médio diluirá.

A métrica mais informativa é a separação:
- **Tasks lineares (sem backtracking necessário):** melhoria esperada ~0-5% (overhead de encoding vs. nenhum uso de memória visual)
- **Tasks com backtracking:** melhoria de 18-25% (o número reportado, provavelmente concentrado aqui)

Para avaliar se OCR-Memory vale o investimento num sistema específico, a pergunta é: qual fração das tasks desse sistema requer backtracking? Se é alta (ex: navegação de checkout em e-commerce com múltiplos erros possíveis), o ROI é forte. Se é baixa (tarefas lineares de extração de dados), o overhead supera o benefício.

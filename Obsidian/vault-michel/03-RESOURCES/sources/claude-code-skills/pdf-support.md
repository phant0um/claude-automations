---
title: "PDF support"
type: source
source: "Clippings/PDF support.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, claude-api, pdf, vision, document-processing, files-api, prompt-caching, batch-processing]
---

## Tese central
Documentação oficial da Anthropic sobre processamento de PDFs pela API: como enviar documentos (URL, base64, Files API), como Claude os processa internamente (texto + imagem por página), limites de tamanho/páginas, custos estimados e práticas de otimização para escala — incluindo o caso especial e mais limitado do Amazon Bedrock Converse API.

## Argumentos principais

- **Casos de uso oficiais:** análise de relatórios financeiros (gráficos/tabelas), extração de informação de documentos legais, assistência de tradução, conversão de documentos para formatos estruturados.
- **Requisitos do PDF:**
  - Tamanho máximo de requisição: 32 MB (varia por plataforma)
  - Máximo de páginas por requisição: 600 (ou **100** para modelos com janela de contexto de 200k tokens)
  - Formato: PDF padrão, sem senha/criptografia
  - Ambos os limites valem para o **payload inteiro** da requisição, incluindo qualquer outro conteúdo enviado junto
- **Aviso de saturação de contexto:** PDFs densos (muitas páginas com fonte pequena, tabelas complexas, gráficos pesados) podem encher a janela de contexto antes de atingir o limite de páginas. Requisições com PDFs grandes podem falhar antes do limite de páginas mesmo usando a Files API. Solução: dividir o documento em seções; downsample de imagens embutidas também ajuda, já que cada página é processada como imagem.
- **3 formas de enviar um PDF:**
  1. **URL reference** — `type: url` apontando para PDF hospedado online (mais simples)
  2. **Base64-encoded** — `type: base64`, `media_type: application/pdf`, `data` com o conteúdo codificado (para arquivos locais)
  3. **Files API** — upload prévio (`ant beta:files upload`) retorna `file_id`; referenciado via `type: file, file_id: $FILE_ID` (requer beta header `files-api-2025-04-14`). Recomendado para PDFs reutilizados ou para evitar overhead de encoding e manter payloads pequenos
  - Em Amazon Bedrock e Vertex AI, **apenas fontes base64 estão disponíveis atualmente**.
- **Como o processamento funciona internamente (3 passos):**
  1. O sistema extrai o conteúdo do documento — converte cada página em imagem **e** extrai o texto de cada página, fornecendo ambos juntos.
  2. Claude analisa texto e imagens combinados para entender o documento (permite perguntas sobre elementos visuais: gráficos, diagramas, conteúdo não-textual).
  3. Claude responde referenciando o conteúdo do PDF quando relevante. Pode ser combinado com prompt caching (análises repetidas), batch processing (alto volume) e tool use (extrair informação específica como input de ferramenta).
- **Estimativa de custos — depende de duas fontes:**
  - **Texto:** cada página tipicamente usa 1.500–3.000 tokens, dependendo da densidade de conteúdo; preço padrão de API, sem taxa adicional por PDF
  - **Imagem:** cada página vira imagem, então se aplicam os mesmos cálculos de custo de imagem da documentação de vision
- **Boas práticas de performance:** colocar PDFs antes do texto na requisição; usar fontes padrão; garantir texto legível; rotacionar páginas para orientação correta; usar números de página lógicos (do visualizador de PDF) nos prompts; dividir PDFs grandes em chunks; habilitar prompt caching para análise repetida.
- **Escala — duas abordagens:**
  - **Prompt caching:** marcar o bloco `document` com `cache_control: { type: ephemeral }` para acelerar consultas repetidas sobre o mesmo PDF
  - **Message Batches API:** enviar múltiplas requisições com `custom_id` para processamento de alto volume
- **Caso especial: Amazon Bedrock Converse API tem dois modos de processamento de documento:**
  1. **Converse Document Chat** (modo original — apenas extração de texto): básico, não analisa imagens/gráficos/layouts visuais; ~1.000 tokens para um PDF de 3 páginas; usado automaticamente quando citações não estão habilitadas
  2. **Claude PDF Chat** (modo novo — entendimento visual completo): análise visual completa (gráficos, imagens, layouts); processa cada página como texto E imagem; ~7.000 tokens para um PDF de 3 páginas; **requer citações habilitadas**
  - **Limitação chave do Converse:** não há opção de usar análise visual sem citações (diferente da InvokeModel API). Se Claude não está "vendo" imagens/gráficos em PDFs via Converse, normalmente é porque a flag de citações não está habilitada.
  - **InvokeModel API:** dá controle total sobre processamento de PDF sem forçar citações — alternativa recomendada para quem precisa de análise visual sem citações.
- **Plataformas suportadas:** Claude API, Claude Platform on AWS, Amazon Bedrock, Vertex AI, Microsoft Foundry — todos os modelos ativos suportam processamento de PDF.
- **Elegível para Zero Data Retention (ZDR):** dados não são armazenados após a resposta, quando a organização tem esse arranjo.
- PDF support depende das capacidades de visão de Claude — sujeito às mesmas limitações e considerações de tarefas de visão.

## Key insights

- O ponto mais importante para custo/performance: **um PDF é processado como imagem + texto simultaneamente, não como um ou outro** — isso explica por que o custo de tokens por página varia tanto (1.500-3.000 de texto + custo de imagem por página) e por que documentos densos podem saturar o contexto antes do limite nominal de 600 páginas.
- A diferença de ~7x em consumo de tokens entre os dois modos do Bedrock (1.000 vs 7.000 tokens para 3 páginas) é uma evidência concreta de quanto a "compreensão visual completa" custa a mais que extração de texto pura — útil como heurística de custo ao decidir se vale a pena habilitar citações no Converse.
- O limite de páginas efetivamente cai pela metade (600 → 100) para modelos com janela de 200k — um detalhe facilmente perdido que impacta diretamente o dimensionamento de pipelines de ingestão de documentos longos.
- "Place PDFs before text in your requests" é uma prática de ordenação que se conecta diretamente aos princípios de estruturação de prompt para prompt caching (conteúdo estável primeiro).

## Exemplos e evidências

- Tabela de requisitos: tamanho máx. 32 MB, máx. 600 páginas (100 para contexto de 200k), formato PDF sem senha.
- Exemplo de payload YAML para envio via URL: `type: document, source: { type: url, url: <link para Claude-3-Model-Card> }`.
- Exemplo de payload base64: `source: { type: base64, media_type: application/pdf, data: "@./document.pdf" }`.
- Exemplo de fluxo Files API: `FILE_ID=$(ant beta:files upload --file ./document.pdf ...)` seguido de `source: { type: file, file_id: $FILE_ID }` com beta header `files-api-2025-04-14`.
- Exemplo de uso com prompt caching: bloco `document` com `cache_control: { type: ephemeral }` e pergunta "Which model has the highest human preference win rates across each use-case?"
- Exemplo de Message Batches com dois `custom_id`s diferentes processando o mesmo `document.pdf` com perguntas distintas ("Which model has the highest..." / "Extract 5 key insights from this document").

## Implicações para o vault

- Estabelece um teto operacional concreto (32 MB / 600 páginas, ou 100 para janelas de 200k) que é diretamente relevante para qualquer pipeline de ingestão do vault que processe PDFs (apostilas FIAP, materiais de concurso, papers) via API — caso o vault venha a usar a Claude API diretamente para esse fim em vez do clipper/Readwise.
- Reforça a recomendação de combinar **prompt caching + PDF** documentada aqui, que se conecta com [[03-RESOURCES/concepts/agent-systems/prompt-caching]] — confirma que documentos grandes cacheados são o caso de uso #1 citado na doc de caching ("Large document processing").
- Não identifiquei contradições com conhecimento existente no vault — é informação nova e específica de um domínio (processamento de documentos via API) ainda não coberto em profundidade.

## Links
- [[03-RESOURCES/concepts/agent-systems/prompt-caching]]
- [[03-RESOURCES/sources/prompt-caching]]

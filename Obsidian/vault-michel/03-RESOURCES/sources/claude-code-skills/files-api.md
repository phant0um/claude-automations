---
title: Files API
type: source
source: "Clippings/Files API.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, managed-agents, files, api-reference]
---

## Tese central
Documentação de referência da **Files API** — a camada de armazenamento "create-once, use-many-times" da Anthropic que permite upload e gestão de arquivos referenciáveis por `file_id` em chamadas Messages, sem reenvio de conteúdo a cada requisição. Embora seja uma API genérica (não exclusiva de Managed Agents), é a fundação direta de [[03-RESOURCES/sources/adding-files]] — o mecanismo de montagem de arquivos em sandboxes de sessão depende inteiramente dela.

## Argumentos principais
- **Status:** em **beta**; não elegível para Zero Data Retention (ZDR) — dados retidos conforme política padrão de retenção do recurso. Header obrigatório: `anthropic-beta: files-api-2025-04-14`.
- **Disponibilidade por plataforma:** disponível na Claude API, **Claude Platform on AWS** ([[03-RESOURCES/sources/claude-platform-on-aws]]) e Microsoft Foundry; **não disponível** no Amazon Bedrock nem no Vertex AI.
- **Modelo de uso (4 operações centrais):** upload (gera `file_id` único), download (de arquivos criados por skills ou code execution tool), referência em Messages (via `file_id`, evitando reenvio), e gestão (list, retrieve, delete).
- **Caso de uso destacado:** particularmente útil com a code execution tool — fornecer inputs (datasets, documentos) e baixar outputs (gráficos) sem reenviar conteúdo repetidamente.
- **Upload e resposta:**
  ```bash
  FILE_ID=$(ant beta:files upload --file /path/to/document.pdf --transform id --raw-output)
  ```
  Resposta: `{"id": "file_011CNha8iCJcU1wXNR6q4V8w", "type": "file", "filename", "mime_type", "size_bytes", "created_at", "downloadable": false}`.
- **Tipos de arquivo e mapeamento para content blocks (tabela central):**
  | Tipo | MIME | Content Block | Caso de uso |
  |---|---|---|---|
  | PDF | `application/pdf` | `document` | análise/processamento de texto |
  | Texto plano | `text/plain` | `document` | análise/processamento de texto |
  | Imagens | `image/jpeg`, `png`, `gif`, `webp` | `image` | análise de imagem, tarefas visuais |
  | Datasets/outros | varia | `container_upload` | análise de dados, visualizações |
- **Formatos não suportados como `document` (.csv, .txt, .md, .docx, .xlsx):** convertê-los para texto plano e incluir o conteúdo diretamente na mensagem (com inline `@./path` no CLI). Para `.docx` com imagens: converter para PDF primeiro, depois usar PDF support para parsing de imagem embutido + citações.
- **Estrutura dos content blocks:**
  - `document`: `{type: "document", source: {type: "file", file_id: "..."}, title?, context?, citations: {enabled: true}?}`
  - `image`: `{type: "image", source: {type: "file", file_id: "..."}}`
- **Operações de gestão:** `files list`, `files retrieve-metadata --file-id`, `files delete --file-id`, `files download --file-id --output`.
- **Restrição de download:** só é possível baixar arquivos **criados por skills ou pela code execution tool** — arquivos que você fez upload **não podem ser baixados**.
- **Limites de armazenamento:** **500 MB por arquivo**; **500 GB por organização (total)**.
- **Ciclo de vida:** escopados ao workspace da API key (outras keys do mesmo workspace podem usar arquivos de qualquer key da org); persistem até deleção explícita; deleção é irreversível; ficam inacessíveis via API logo após a deleção, mas podem persistir em chamadas `Messages` ativas e usos de tool associados.
- **Erros comuns documentados (com código HTTP):**
  - 404 — File not found
  - 400 — Invalid file type (tipo não bate com o content block)
  - 400 — Exceeds context window size (ex: arquivo de texto de 500MB num request `/v1/messages`)
  - 400 — Invalid filename (1-255 caracteres; proibidos `< > : " | ? * \ /` e unicode 0-31)
  - 413 — File too large (acima de 500MB)
  - 403 — Storage limit exceeded (acima de 500GB da org)
- **Billing:** operações da Files API são **gratuitas** (upload, download, list, metadata, delete); apenas o **conteúdo do arquivo usado em Messages requests é cobrado como input tokens**.
- **Rate limits durante o beta:** ~100 requisições/minuto para chamadas relacionadas a arquivos; contato com sales para limites maiores.

## Key insights
- O modelo "create-once, use-many-times" é a peça que torna viável o padrão observado em [[03-RESOURCES/sources/adding-files]] (montar arquivos em sandboxes sem reupload) e em qualquer workflow que reuse documentos/datasets entre múltiplas chamadas — é uma otimização tanto de latência quanto de custo (tokens só são cobrados pelo *uso*, não pelo armazenamento).
- A não-elegibilidade para ZDR é um detalhe de compliance que se propaga a qualquer recurso que dependa da Files API (incluindo montagem de arquivos em sessões Managed Agents) — relevante para organizações com requisitos rígidos de retenção de dados, especialmente em conjunto com a postura de ZDR "opt-in" descrita em [[03-RESOURCES/sources/claude-platform-on-aws]].
- A restrição "só é possível baixar arquivos criados por skills/code execution, nunca os que você enviou" reforça o mesmo padrão read-only/write-only observado em [[03-RESOURCES/sources/adding-files]] (montagens read-only) e [[03-RESOURCES/sources/authenticate-with-vaults]] (secrets write-only) — um tema de design recorrente: **inputs são imutáveis e não recuperáveis em sua forma original; apenas outputs gerados pelo sistema são exportáveis**.
- A indisponibilidade no Amazon Bedrock e Vertex AI (mas disponibilidade na Claude Platform on AWS) é mais uma evidência concreta de que a Platform on AWS oferece paridade de recursos com a API first-party que o Bedrock não tem — reforça o argumento central de [[03-RESOURCES/sources/claude-platform-on-aws]].
- O fato de operações da Files API serem gratuitas, mas o *uso* do conteúdo em Messages ser cobrado como input tokens, é um modelo de billing que separa "armazenamento" de "consumo de contexto" — relevante para estimar custos de workflows agentic que reusam documentos grandes repetidamente.

## Exemplos e evidências
- Resposta de upload com campos completos: `id`, `type: "file"`, `filename`, `mime_type`, `size_bytes`, `created_at`, `downloadable: false`.
- Referência de arquivo em Messages com content block `document` e `file_id`.
- Erro padrão de "file not found": `{"type": "error", "error": {"type": "invalid_request_error", "message": "File not found: file_011CNha8iCJcU1wXNR6q4V8w"}}`.
- Limites numéricos exatos: 500 MB/arquivo, 500 GB/organização, nomes de 1-255 caracteres, ~100 req/min durante beta.
- Comando de inline de conteúdo: `ant messages create ... --transform 'content.0.text' --raw-output` com `text: "@./document.txt"`.

## Implicações para o vault
Esta página é a **camada de fundação** para [[03-RESOURCES/sources/adding-files]] — toda a mecânica de upload, `file_id`, limites de tamanho/storage e tipos de conteúdo documentada aqui é herdada diretamente pelo fluxo de montagem de arquivos em sandboxes Managed Agents. Confirma também a paridade de recursos da [[03-RESOURCES/sources/claude-platform-on-aws]] (Files API listada como disponível ali). Os erros e limites documentados aqui (500MB, 500GB, rate limit ~100/min) definem o "teto operacional real" de qualquer workflow agentic que use arquivos — útil cruzar com os limites de hardware do sandbox em [[03-RESOURCES/sources/cloud-sandbox-reference]] (8GB RAM / 10GB disco) ao dimensionar pipelines de dados. O padrão "outputs exportáveis, inputs não recuperáveis" alimenta [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] e [[03-RESOURCES/concepts/agent-systems/agent-observability]] (rastreabilidade de o que entra vs. o que sai de um agente).

## Links
- [[03-RESOURCES/sources/adding-files]]
- [[03-RESOURCES/sources/claude-platform-on-aws]]
- [[03-RESOURCES/sources/cloud-sandbox-reference]]
- [[03-RESOURCES/sources/authenticate-with-vaults]]
- [[03-RESOURCES/sources/accessing-github]]
- [[03-RESOURCES/sources/cloud-environment-setup]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]

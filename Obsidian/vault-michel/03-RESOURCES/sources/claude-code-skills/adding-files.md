---
title: Adding files
type: source
source: "Clippings/Adding files.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, managed-agents, files, integration]
---

## Tese central
Documentação de referência sobre como **fazer upload de arquivos via Files API e montá-los no sandbox de uma sessão** Managed Agents (`managed-agents-2026-04-01` beta) para que o agente possa ler e processar dados — datasets, configs, código-fonte. É o segundo dos três mecanismos de injeção de conteúdo do lote, e depende diretamente da [[03-RESOURCES/sources/files-api]] como camada de armazenamento subjacente.

## Argumentos principais
- **Fluxo em duas etapas:** (1) upload do arquivo via Files API gerando um `file_id`; (2) montagem desse `file_id` no sandbox da sessão através do array `resources` na criação da sessão.
  ```bash
  FILE_ID=$(ant beta:files upload --file data.csv --transform id --raw-output)
  ```
  ```yaml
  resources:
    - type: file
      file_id: $FILE_ID
      mount_path: /workspace/data.csv
  ```
- **`mount_path` é opcional**, mas a doc recomenda dar um nome descritivo ao arquivo enviado para que o agente consiga identificá-lo (já que sem `mount_path` o nome original é o que orienta o agente).
- **Cópia isolada por sessão:** ao montar, é criado um **novo `file_id`** que referencia a *instância* do arquivo dentro daquela sessão — essas cópias **não contam contra os limites de armazenamento** da organização.
- **Múltiplos arquivos:** array `resources` aceita múltiplas entradas `type: file`, cada uma com seu `file_id` e `mount_path` (ex: `data.csv`, `config.json`, `src/main.py`).
- **Limite explícito:** **máximo de 100 arquivos por sessão**.
- **Gerenciamento em sessão ativa:** arquivos podem ser adicionados (`resources add --type file --file-id "$FILE_ID"`, retorna um `id` de resource) ou removidos (`resources delete --resource-id "$RESOURCE_ID"`) após a criação da sessão; `resources list` lista todos os recursos. Para listar/baixar arquivos *associados a uma sessão* especificamente (em vez de gerenciar montagens), usa-se a Files API com `--scope-id sesn_abc123` e os betas `files-api-2025-04-14` + `managed-agents-2026-04-01` combinados.
- **Tipos de arquivo suportados:** qualquer tipo — código-fonte (`.py`, `.js`, `.ts`, `.go`, `.rs`...), dados (`.csv`, `.json`, `.xml`, `.yaml`), documentos (`.txt`, `.md`), arquivos compactados (`.zip`, `.tar.gz` — o agente extrai via bash), binários (processados com ferramentas apropriadas).
- **Comportamento de paths e permissões:**
  - Arquivos montados são **cópias somente-leitura** — o agente lê mas não modifica o arquivo original enviado; para versões modificadas, escreve em novos paths dentro do sandbox.
  - Montados no path exato especificado; diretórios pai são criados automaticamente; paths devem ser absolutos (começando com `/`).

## Key insights
- A criação de um **novo `file_id` por instância de sessão** que não conta contra limites de storage é um detalhe de design sutil mas relevante: significa que montar o mesmo arquivo em N sessões não multiplica o custo de armazenamento — só a referência original é "cobrada".
- A combinação de betas (`files-api-2025-04-14` + `managed-agents-2026-04-01`) ao listar arquivos por `scope_id` revela que a Files API e o sistema Managed Agents são **subsistemas distintos que se compõem** — a Files API é genérica (usável em Messages requests fora do contexto de agentes), e o Managed Agents a reusa como camada de armazenamento.
- O limite de 100 arquivos por sessão, somado ao limite de hardware do sandbox (8GB RAM / 10GB disco, ver [[03-RESOURCES/sources/cloud-sandbox-reference]]), define um envelope operacional claro para workflows de processamento de dados em agentes — útil para dimensionar casos de uso antes de implementar.
- O caráter read-only das montagens reforça um padrão observado também em [[03-RESOURCES/sources/accessing-github]] (token write-only, montagens imutáveis durante a sessão): o sistema Managed Agents tende a tratar recursos externos como **inputs imutáveis referenciados por ID**, empurrando toda mutação para dentro do sandbox efêmero — um modelo que facilita auditoria e reprodutibilidade.

## Exemplos e evidências
- Upload: `FILE_ID=$(ant beta:files upload --file data.csv --transform id --raw-output)`.
- Montagem em sessão (YAML):
```yaml
resources:
  - type: file
    file_id: $FILE_ID
    mount_path: /workspace/data.csv
```
- Múltiplos arquivos com paths distintos: `/workspace/data.csv`, `/workspace/config.json`, `/workspace/src/main.py`.
- Adição dinâmica: `RESOURCE_ID=$(ant beta:sessions:resources add --session-id "$SESSION_ID" --type file --file-id "$FILE_ID" --transform id --raw-output)`.
- Listagem/remoção: `resources list --session-id "$SESSION_ID"` / `resources delete --session-id "$SESSION_ID" --resource-id "$RESOURCE_ID"`.
- Listagem de arquivos por escopo de sessão: `ant beta:files list --scope-id sesn_abc123 --beta files-api-2025-04-14 --beta managed-agents-2026-04-01`.
- Download: `ant beta:files download --file-id "$FILE_ID" --output output.txt`.
- Limite numérico explícito: **máximo 100 arquivos por sessão**.

## Implicações para o vault
Esta página depende diretamente de [[03-RESOURCES/sources/files-api]] (camada de armazenamento/upload subjacente — conceitos como `file_id`, limites de 500MB/arquivo e 500GB/org, retenção, tipos de conteúdo são definidos lá) e forma, junto com [[03-RESOURCES/sources/accessing-github]], o par de mecanismos `resources`-based para trazer conteúdo ao sandbox descrito em [[03-RESOURCES/sources/cloud-sandbox-reference]] e configurado em [[03-RESOURCES/sources/cloud-environment-setup]]. O padrão "cópia read-only com novo `file_id` por sessão, sem custo extra de storage" é uma peça de design que merece nota em [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] (camadas de isolamento entre recurso compartilhado e instância de sessão). Também conecta-se a [[03-RESOURCES/sources/claude-platform-on-aws]], que lista "Files API" entre os recursos com paridade total na Platform on AWS.

## Links
- [[03-RESOURCES/sources/files-api]]
- [[03-RESOURCES/sources/accessing-github]]
- [[03-RESOURCES/sources/cloud-sandbox-reference]]
- [[03-RESOURCES/sources/cloud-environment-setup]]
- [[03-RESOURCES/sources/claude-platform-on-aws]]
- [[03-RESOURCES/sources/authenticate-with-vaults]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]

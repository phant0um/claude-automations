---
title: "Dreams — API Reference for Memory-Curation Jobs in Claude Managed Agents"
type: source
source: "Clippings/Dreams.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, claude-managed-agents, dreams, agent-memory, memory-stores, research-preview, async-jobs, self-improvement]
---

## Tese central
Documentação técnica oficial da Anthropic sobre **Dreams**: um job assíncrono de research preview que lê uma memory store existente junto com transcripts de sessões passadas e produz uma **nova** memory store reorganizada — duplicatas mescladas, entradas obsoletas/contraditórias substituídas pelo valor mais recente, novos insights superficializados. A store de entrada nunca é modificada. Esta página documenta o ciclo de vida completo do recurso `dream` (criação, lifecycle, steering via instructions, cancelamento, arquivamento, listagem, erros, billing e limites) — é o lado API/mecânico, distinto e mais profundo tecnicamente do que as fontes já existentes no vault sobre o conceito de "Dreaming".

## Argumentos principais

### O problema que Dreams resolve
- Agentes escrevem em [memory stores](https://platform.claude.com/docs/en/managed-agents/memory) enquanto trabalham, mas essas escritas são **locais e incrementais** — ao longo de muitas sessões, uma memory store acumula duplicatas, contradições e entradas obsoletas.
- Dreams "limpa isso": lê a store existente + transcripts de sessões passadas, e produz uma nova store reorganizada.
- **Garantia central: a store de entrada nunca é modificada** — o output pode ser revisado e descartado se o resultado não agradar.

### Requisitos de acesso
- Feature de **research preview**; requer solicitação de acesso (`claude.com/form/claude-managed-agents`).
- Requer DOIS beta headers: `managed-agents-2026-04-01` (geral) + `dreaming-2026-04-21` (específico de Dreams). O SDK define ambos automaticamente.

### Anatomia de um dream — inputs e outputs
- Um **dream** é um job assíncrono que recebe:
  - uma **memory store** pré-existente (a que será verificada, deduplicada e reorganizada)
  - de **1 a 100 sessions** (transcripts passados que Claude minera por padrões e insights)
- Produz uma **output memory store** separada do input. O ID da store de saída aparece em `outputs[]` assim que o status muda para `running`.
- Se não há store existente, é preciso [criar uma memory store vazia](https://platform.claude.com/docs/en/managed-agents/memory#create-a-memory-store) primeiro e passá-la como input.

### Criar um dream — schema da requisição
```yaml
inputs:
  - type: memory_store
    memory_store_id: $store_id
  - type: sessions
    session_ids: [$session_a, $session_b]
model: claude-opus-4-8
instructions: Focus on coding-style preferences; ignore one-off debugging notes.
```
- `model`: o modelo selecionado roda o pipeline de dreaming. **Modelos suportados durante o research preview: `claude-opus-4-8`, `claude-opus-4-7`, `claude-sonnet-4-6`.**
- `instructions` (opcional): campo de string para guiar a síntese — ver seção "Steer with instructions" abaixo.
- A resposta retorna o recurso `dream` completo com `status: "pending"`.

### Steer with instructions — regra crítica de uso
- O campo `instructions` é aplicado **ao longo de todo o pipeline**: o que ler com atenção, o que mesclar ou descartar, como estruturar a store de saída.
- **Uso correto:** orientação de síntese de alto nível — áreas de foco ("focus on coding-style preferences"), conteúdo a preservar inalterado, convenções de output a aplicar globalmente na store.
- **Uso incorreto (geralmente não funciona):** diretivas imperativas que visam linhas específicas do texto ("change sentence X to Y", "fix the count in section Z"). **O pipeline é uma passagem de síntese sobre os inputs, não um editor aplicado ao texto da store** — instruções desse tipo geralmente produzem nenhuma mudança.
- Para edições direcionadas a memórias individuais, usar a [Memory Stores API](https://platform.claude.com/docs/en/managed-agents/memory#view-and-edit-memories) diretamente na store de saída.

### Lifecycle (5 estados)
| `status` | Significado |
|---|---|
| `pending` | Dream criado e enfileirado com sucesso |
| `running` | Pipeline processando; `usage` é atualizado conforme o trabalho avança |
| `completed` | Concluído com sucesso; `outputs[]` contém a nova memory store |
| `failed` | Run terminou com erro; a output store fica como estava, com o que foi escrito antes da falha |
| `canceled` | Run cancelado; output store fica como estava |

### Acompanhar o progresso
- Polling: `ant beta:dreams retrieve --dream-id "$dream_id"`.
- Tipicamente leva **minutos a dezenas de minutos**, dependendo do tamanho do input.
- Quando `running`, o campo `session_id` aponta para a [session](https://platform.claude.com/docs/en/managed-agents/sessions) subjacente que executa o pipeline — é possível fazer streaming dos eventos dessa sessão para observar em tempo real o que o dream está lendo/escrevendo.
- A sessão é **arquivada (não deletada)** quando o dream chega a um estado terminal — o transcript permanece disponível depois.

### Usar o output
- Quando `status` chega a `completed`, a entrada `memory_store` em `outputs[]` referencia uma store totalmente populada — é uma memory store comum no workspace.
- Duas opções: **(a) aproveitar** — anexá-la a sessões futuras como recurso `memory_store`, no lugar de (ou junto com) a store de entrada; ou **(b) descartar** — deletar ou arquivar via Memory Stores API.
- Exemplo de fluxo: extrair `output_store_id` via `jq` do campo `outputs[]`, depois criar uma nova session passando essa store como `resources: [{ type: memory_store, memory_store_id: $output_store_id }]`.
- O dream nunca deleta ou modifica seus inputs. Em `failed`/`canceled`, a output store persiste com conteúdo parcial — pode ser inspecionada e limpa via Memory Stores API se desnecessária.
- **Restrições de concorrência:** enquanto um dream está `pending` ou `running`, arquivar/deletar sua output store é rejeitado com 400. Arquivar/deletar uma store ou sessão de **input** durante o run causa falha do dream com `input_memory_store_unavailable` ou `input_session_unavailable`.

### Cancelar
- `cancel` move um dream `pending` ou `running` para `canceled` **imediatamente**.
- Cancelar um dream já `canceled` é idempotente (no-op); cancelar um `completed` ou `failed` retorna 400.

### Arquivar
- `archive` define `archived_at` em um dream que atingiu estado terminal (`completed`, `failed`, ou `canceled`); `status` permanece inalterado.
- Dreams arquivados são excluídos das listagens default mas continuam legíveis por ID. Arquivar um já-arquivado é idempotente. Arquivar um `pending`/`running` retorna 400 (cancelar primeiro). **Não há unarchive.**
- Arquivar um dream **não toca** sua output memory store — gerenciada separadamente via Memory Stores API.

### Listar
- Retorna todos os dreams não-arquivados do workspace, mais recentes primeiro.
- Paginação: `limit` (default 20, max 100) + cursor `page`. `include_archived=true` inclui arquivados.

### Erros (lista não-exaustiva)
| `error.type` | Quando ocorre |
|---|---|
| `timeout` | Pipeline excedeu o orçamento de runtime |
| `internal_error` | Falha de pipeline não-classificada |
| `memory_store_org_limit_exceeded` | Organização atingiu o teto de memory stores enquanto o pipeline provisionava armazenamento de trabalho |
| `input_memory_store_too_large` | Memory store de entrada excede o limite de tamanho do pipeline |
| `input_memory_store_unavailable` | Store de entrada foi arquivada/deletada após a criação do dream |
| `input_session_unavailable` | Sessão de entrada foi arquivada/deletada após a criação do dream |

### Billing
- Cobrado a **taxas padrão de tokens de API** para o modelo selecionado; o campo `usage` no recurso reporta os totais exatos.
- **Custo escala aproximadamente linear** com o número e o comprimento das sessões de input.
- Recomendação explícita: começar com um lote pequeno de sessões e escalar depois de validar a qualidade da curadoria.

### Limites
| Limite | Valor |
|---|---|
| Sessões por dream | **100** |
| Comprimento de `instructions` | **4.096 caracteres** |
| Modelos suportados | `claude-opus-4-8`, `claude-opus-4-7`, `claude-sonnet-4-6` |
- Rate limits default se aplicam à criação de dreams enquanto a feature está em beta; contato com suporte para limites maiores.

## Key insights

- **A garantia "input store never modified" é o que torna Dreams seguro para experimentação** — diferente de qualquer processo de consolidação que sobrescreve in-place, o design "produz uma store nova, separada" permite revisar/comparar/descartar sem risco. Esse é um padrão de design (immutable transformation, output separado do input) que vale generalizar para qualquer pipeline de auto-melhoria de memória, incluindo no vault.
- **A distinção entre "synthesis pass" e "text editor" é o insight mais acionável da página** — `instructions` funciona para *guiar* o que entra/sai/como é organizado, mas falha sistematicamente em fazer *edições pontuais* ("troque a frase X por Y"). Isso implica que qualquer fluxo de "dream-like consolidation" no vault (ex.: uma rotina que reorganiza `hot.md` ou consolida `errors.md`) deveria separar claramente "instruções de síntese" (o que priorizar/descartar) de "edições cirúrgicas" (que devem ser feitas por outro mecanismo, determinístico).
- **Custo escala linearmente com sessões e comprimento** — e a Anthropic recomenda explicitamente começar pequeno. Isso sugere que dreams sobre históricos muito longos (próximos do limite de 100 sessões) podem ficar caros o suficiente para justificar amostragem ou pré-filtragem antes de disparar o job.
- O **encadeamento `failed`/`canceled` → output parcial preservado** é uma decisão de design que prioriza auditabilidade sobre limpeza automática — o usuário tem que limpar manualmente, mas em troca nunca perde visibilidade do que foi produzido até a falha.
- A **restrição de concorrência** (não pode arquivar input mid-run, e fazer isso causa falha com erro nomeado) revela que o pipeline mantém referências vivas e ativas aos recursos de input durante toda a execução — não é um snapshot read-once no início.
- Os erros nomeados (`input_memory_store_too_large`, `memory_store_org_limit_exceeded`) expõem limites de capacidade da infraestrutura subjacente que não são documentados em nenhum outro lugar — são sinais concretos de que memory stores têm um teto de tamanho e que organizações têm um teto de número de stores.

## Exemplos e evidências

- Comando completo de criação: `dream_id=$(ant beta:dreams create --transform id --raw-output <<YAML ... YAML)`.
- Resposta JSON completa do recurso `dream` em `pending`, incluindo `usage` zerado, `session_id: null`, `archived_at: null`, `error: null`.
- Comando de retrieve: `ant beta:dreams retrieve --dream-id "$dream_id"`.
- Fluxo completo de "usar o output": extrair `output_store_id` via `jq -r 'first(.outputs[] | select(.type == "memory_store")).memory_store_id'` e criar nova sessão referenciando essa store.
- Comandos de cancelamento (`ant beta:dreams cancel`) e arquivamento (`ant beta:dreams archive`).
- Comando de listagem com paginação (`ant beta:dreams list --limit 20`).
- Limites numéricos exatos: 100 sessões/dream, 4.096 caracteres de `instructions`, default `limit: 20` / max `100` na listagem.

## Implicações para o vault

- **Esta fonte é qualitativamente diferente das outras 5 do batch** — não é documentação de uma capability genérica da Messages API, mas sim de uma feature de pesquisa que opera *sobre* memory stores de agentes, mais próxima dos domínios [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] e [[03-RESOURCES/concepts/agent-systems/agent-observability]] do que do cluster API-reference (caching, PDFs, mid-conversation messages, webhooks).
- **Relação com fontes já existentes no vault sobre Dreaming:**
  - [[03-RESOURCES/sources/ml-research-papers/rlancemartin-outcomes-dreaming-managed-agents]] cobre a *mecânica conceitual* de Dreaming (offline learning, distinção de fine-tuning, comparação com o vault) a partir de uma thread de anúncio.
  - [[03-RESOURCES/sources/ai-agents-harness/anthropic-dreaming-claude-managed-agents-setup]] cobre o *setup prático* via Console (cadência, auto-update vs. review mode).
  - **Esta fonte (`dreams.md`) é a primeira a documentar a API/mecânica formal**: schema exato de criação, lifecycle de 5 estados, comportamento de `instructions`, tabela de erros nomeados, limites numéricos (100 sessões, 4.096 chars), e billing. Nenhuma das duas fontes anteriores tinha esse nível de detalhe técnico — elas descreviam o "o quê" e o "por quê"; esta documenta o "como, exatamente, via API".
  - **Não há contradição** entre as três — são camadas complementares (anúncio → setup prático → referência de API). Vale considerar consolidar as três em algum momento futuro sob um único concept/page de "Dreams (Managed Agents)" se o tema crescer mais.
- Confirma e aprofunda a [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — particularmente a seção "Auto Dream / Memory Consolidation" do concept (que já cita `auto_dream.py` e Cognee `memify()`). A doc oficial mostra que a Anthropic formalizou exatamente esse padrão como produto: input imutável, output separado, mesclagem de duplicatas, substituição de entradas obsoletas — um espelho quase 1:1 do padrão `episodic → semantic` já mapeado no vault.
- **Possível leve tensão a registrar:** o concept [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] traz uma seção "C-Engineering vs. θ-Engineering (Xu et al., 2026)" que argumenta que toda consolidação de memória hoje opera em **C-space** (reorganiza contexto, não atualiza pesos) — e cita isso como uma limitação fundamental ("a better-organized filing cabinet, not expertise"). Dreams confirma exatamente essa caracterização: é uma "synthesis pass" que produz uma nova store de **texto/contexto**, não um processo de fine-tuning. Não é uma contradição nova — é evidência direta a favor do argumento de Xu et al. já registrado como `[!contradiction]` no concept.
- Sugestão de novo concept (ver relatório): "Dreams / Managed-Agents Memory Curation" como sub-tópico dedicado dentro de `agent-memory-architecture`, caso mais fontes sobre o tema continuem chegando.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
- [[03-RESOURCES/sources/ml-research-papers/rlancemartin-outcomes-dreaming-managed-agents]]
- [[03-RESOURCES/sources/ai-agents-harness/anthropic-dreaming-claude-managed-agents-setup]]
- [[03-RESOURCES/sources/reference]]

---
title: "Using agent memory"
type: source
source: "Clippings/Using agent memory.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, agent-memory, claude-managed-agents, memory-stores, api-reference, persistence, audit-trail]
---

## Tese central

Cada sessão de Managed Agents começa com contexto zerado por padrão — quando a sessão termina, qualquer estado que o agente construiu desaparece. **Memory stores** resolvem isso: são coleções de documentos de texto, com escopo de workspace, otimizadas para Claude, que sobrevivem entre sessões e carregam preferências do usuário, convenções de projeto, erros passados e contexto de domínio. Esta é a documentação oficial de referência da API/arquitetura — explica não só *como* anexar e gerenciar memory stores, mas também o modelo de segurança, limites de escala e o trade-off central entre persistência útil e risco de envenenamento de memória via prompt injection.

## Argumentos principais

- **Definição central — memory store é um diretório montado**: é uma coleção de documentos de texto com escopo de workspace. Quando anexada a uma sessão, é montada como diretório dentro do sandbox da sessão (`/mnt/memory/`); o agente lê e escreve com as MESMAS ferramentas de arquivo que usa para o resto do filesystem. Uma nota descrevendo cada montagem é automaticamente adicionada ao system prompt, dizendo ao agente onde procurar — elimina a necessidade de "ensinar" o agente a usar memória; ele simplesmente a encontra como mais um diretório.
- **Cada memória é endereçável por path e versionada imutavelmente**: pode ser lida/editada diretamente via API ou Console (permite tuning, importação, exportação). Toda mudança cria uma **memory version** imutável (`memver_...`) — trilha de auditoria completa e recovery point-in-time para tudo que o agente escreve.
- **Criação de store requer `name` + `description`**: a description é passada ao agente, dizendo o que o store contém — funciona como "rótulo semântico" que orienta o agente sobre quando/como usar aquele store específico. Pode ser pré-populado com conteúdo de referência ANTES de qualquer sessão rodar (ex.: `formatting_standards.md` com "All reports use GAAP formatting. Dates are ISO-8601...").
- **Limites de escala explícitos — "estruture como muitos arquivos pequenos, não poucos grandes"**: cada memória individual é limitada a 100 kB (~25k tokens); um store comporta no máximo 2.000 memórias. Esses dois limites juntos forçam uma filosofia de design: granularidade fina é a unidade de organização correta para memória de agente — não documentos monolíticos.
- **Anexação só acontece na criação da sessão — limitação importante**: ao contrário de recursos de arquivo/repositório, memory stores só podem ser anexados no momento de criação da sessão; adicionar/remover de uma sessão em execução NÃO é suportado. Isso implica planejamento antecipado de quais stores uma sessão vai precisar.
- **`instructions` por sessão — orientação contextual de até 4096 caracteres**: opcionalmente, pode-se incluir `instructions` específicas de como o agente deve usar aquele store nessa sessão; é mostrado ao agente junto com `name` e `description` do store (ex.: "User preferences and project context. Check before starting any task.").
- **Controle de acesso — `read_write` (default) vs. `read_only`**: aplicado no nível de filesystem — uma montagem `read_only` rejeita escritas; escritas em `read_write` produzem memory versions atribuídas à sessão. Limite de **8 memory stores por sessão**.
- **O argumento de segurança central — risco de "memória envenenada"**: se o agente processa input não-confiável (prompts fornecidos por usuário, conteúdo web buscado, output de ferramenta de terceiros), uma prompt injection bem-sucedida pode escrever conteúdo malicioso no store. Sessões FUTURAS então leem esse conteúdo como **memória confiável** — propagando o ataque silenciosamente através do tempo. Recomendação direta: usar `read_only` para material de referência, lookups compartilhados, e qualquer store que o agente não precise modificar.
- **3 razões documentadas para múltiplos stores por sessão**:
  1. *Material de referência compartilhado*: um store read-only anexado a muitas sessões (padrões, convenções, conhecimento de domínio), mantido separado do store read-write próprio de cada sessão.
  2. *Mapeamento à estrutura do produto*: um store por usuário final, por time, ou por projeto, compartilhando uma única configuração de agente.
  3. *Ciclos de vida diferentes*: um store que sobrevive a qualquer sessão individual, ou um que se quer arquivar em cronograma próprio.
- **Eventos de leitura/escrita aparecem no event stream como `agent.tool_use`/`agent.tool_result`**: integra-se naturalmente com observabilidade existente — não é um sistema paralelo de logging, é o mesmo pipeline de eventos de qualquer outra ferramenta.
- **API CRUD completa para gerenciamento direto de memórias**: `memories.create` (não sobrescreve — cria em path específico), `memories.update` (modifica conteúdo e/ou path/rename por ID), `memories.list` (filtra por `path_prefix`, navega como diretório), `memories.retrieve` (retorna conteúdo completo), `memories.delete`.
- **Edições seguras via "optimistic concurrency"**: passar um precondition `content_sha256` — o update só se aplica se o hash do conteúdo armazenado ainda corresponder ao que foi lido; em caso de mismatch, é preciso reler e tentar novamente contra o estado fresco. Evita que escritas concorrentes se sobrescrevam silenciosamente.
- **Auditoria e recovery — modelo de versões**: versões pertencem ao STORE (não à memória individual) e sobrevivem mesmo após a memória ser deletada, mantendo a trilha de auditoria completa. Retidas por 30 dias, mas versões recentes são sempre mantidas independente da idade — memórias que mudam raramente podem reter histórico além de 30 dias. Não existe endpoint dedicado de "restore": para reverter, recupera-se a versão desejada e reescreve-se seu `content` via `memories.update` (ou `memories.create` se o pai já foi deletado, já que versões sobrevivem ao pai).
- **Redact — scrub de compliance preservando a trilha**: remove conteúdo de uma versão histórica enquanto preserva o registro de auditoria (quem fez o quê, quando) — usado para remover segredos vazados, PII, ou pedidos de exclusão de usuário (LGPD/GDPR-style). Restrição importante: uma versão que é o HEAD atual de uma memória viva não pode ser redatada — é preciso escrever uma nova versão primeiro (ou deletar a memória), depois redatar a antiga.
- **Gerenciamento de stores — archive é unidirecional**: `archive` torna um store somente-leitura e impede anexação a novas sessões; **arquivamento é one-way, não existe unarchive**. Para remoção permanente (store + memórias + versões), usar `delete`.
- **Comportamento ao atingir o limite de 2.000 memórias**: escritas em NOVAS memórias falham (tanto chamadas diretas `memories.create` quanto escritas do agente em paths não mapeados); memórias EXISTENTES continuam legíveis e editáveis. O sistema falha graciosamente — não trava, apenas impede crescimento além do limite.
- **4 práticas recomendadas de gestão de memória**:
  1. *Usar stores focados*: em vez de um store geral grande, usar stores menores e propositais — um por usuário, um para conhecimento de domínio compartilhado, um para contexto de projeto. Cada store tem seu próprio limite de 2.000, então escopo reduzido reduz a chance de qualquer um encher.
  2. *Condensar/podar antes de encher*: deletar memórias obsoletas/redundantes com `memories.delete`, ou rodar uma **dreaming session** que consolida conteúdo fragmentado em um NOVO store de output separado (sem modificar o original) — depois trocar as sessões para esse store de output e arquivar/deletar o original.
  3. *Anexar um novo store quando fizer sentido*: se um store cresceu além de seu escopo útil, anexar um novo para conteúdo novo e manter o original com acesso `read_only` — o agente lê de ambos mas só escreve no novo.
  4. *Limitar acesso de escrita apropriadamente*: sessões que só leem material de referência compartilhado não precisam de `read_write` — manter acesso de escrita restrito a sessões que de fato adicionam memórias novas facilita rastrear de onde vem o crescimento.

## Key insights

- A frase definidora — **"memory stores let the agent carry information across sessions: user preferences, project conventions, prior mistakes, and domain context"** — é a especificação mais limpa já vista no vault de QUAIS categorias de informação memória de agente deve cobrir: não é "tudo", é especificamente preferências, convenções, ERROS PASSADOS, e contexto de domínio. Isso mapeia quase 1:1 com `04-SYSTEM/wiki/errors.md` do vault (registro de erros passados) e `hot.md` (contexto/convenções).
- O modelo "**memória = mais um diretório no filesystem**" é arquiteturalmente elegante: ao montar o store como `/mnt/memory/` e usar as MESMAS ferramentas de arquivo, a Anthropic elimina a necessidade de uma API de memória especial — o agente não precisa "saber que está usando memória", ele só navega um diretório a mais. Isso é o oposto de sistemas de memória que exigem chamadas de função dedicadas (`remember()`, `recall()`).
- O **risco de "memória envenenada via prompt injection"** é o insight de segurança mais importante da fonte: memória persistente não é apenas um recurso de continuidade — é uma SUPERFÍCIE DE ATAQUE com efeito retardado. Um ataque bem-sucedido hoje pode ser lido como "verdade confiável" em sessões futuras, potencialmente meses depois. A recomendação de `read_only` para material de referência é, na prática, uma aplicação direta do princípio de menor privilégio aplicado especificamente ao eixo temporal da memória.
- **"Structure memory as many small focused files, not a few large ones"** ecoa quase literalmente o princípio já documentado em [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] sobre a estrutura `.agent/memory/` (working/episodic/semantic/personal) — confirma que granularidade fina não é estilo, é requisito estrutural imposto pelos próprios limites da plataforma (100kB/memória, 2.000/store).
- A ausência de endpoint de "restore" — sendo necessário ler uma versão antiga e reescrevê-la via `update`/`create` — é um detalhe de design que prioriza auditabilidade sobre conveniência: cada "rollback" gera uma NOVA versão (preservando a trilha completa), em vez de apagar o histórico entre o erro e a correção. Isso é coerente com o princípio "receipts beat vibes" já presente em fontes Hermes do vault.
- O paralelo "**dreaming session consolida em store NOVO, sem modificar o original**" conecta diretamente com [[03-RESOURCES/sources/dreams]] (já ingerida na mesma leva) — confirma que o padrão "nunca mutar o input, sempre produzir output separado" é consistente em toda a arquitetura de memória da Anthropic, não um detalhe isolado de uma feature.
- O modelo de 4 "razões para múltiplos stores" (referência compartilhada / mapeamento de produto / ciclos de vida diferentes) é, na prática, uma taxonomia de **escopo de memória** que generaliza além da API da Anthropic — é aplicável ao desenho de qualquer sistema multi-agente que precise decidir "o que cada agente deve lembrar, e de onde".

## Exemplos e evidências

- Comando completo de criação de store:
  ```bash
  store_id=$(ant beta:memory-stores create \
    --name "User Preferences" \
    --description "Per-user preferences and project context." \
    --transform id --raw-output)
  ```
- Comando de seed pré-execução:
  ```bash
  ant beta:memory-stores:memories create \
    --memory-store-id "$store_id" \
    --path "/formatting_standards.md" \
    --content "All reports use GAAP formatting. Dates are ISO-8601..." \
    > /dev/null
  ```
- Exemplo de anexação de store na criação da sessão (YAML), incluindo `access: read_write` e `instructions`:
  ```yaml
  ant beta:sessions create <<YAML
  agent: $agent_id
  environment_id: $environment_id
  resources:
    - type: memory_store
      memory_store_id: $store_id
      access: read_write
      instructions: User preferences and project context. Check before starting any task.
  YAML
  ```
- Exemplo de "safe content edit" com optimistic concurrency:
  ```bash
  ant beta:memory-stores:memories update \
    --memory-store-id "$store_id" \
    --memory-id "$mem_id" \
    --content "CORRECTED: Always use 2-space indentation." \
    --precondition "{type: content_sha256, content_sha256: $mem_sha}" \
    > /dev/null
  ```
- Exemplo de listagem de versões com extração via `jq`:
  ```bash
  versions=$(ant beta:memory-stores:memory-versions list \
    --memory-store-id "$store_id" --memory-id "$mem_id" --format json)
  jq -r '.data[] | "\(.id): \(.operation)"' <<< "$versions"
  ```
- Números concretos de limite: 100 kB (~25k tokens) por memória, 2.000 memórias por store, 8 stores por sessão, 4.096 caracteres para `instructions`, 30 dias de retenção de versões (com exceção para versões recentes/raramente alteradas).
- Todos os requests da Managed Agents API exigem o header beta `managed-agents-2026-04-01` — o SDK seta automaticamente, mas é um detalhe técnico que pode quebrar integrações manuais/curl direto.

## Implicações para o vault

- Esta fonte é o **complemento operacional direto** de [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] — aquele concept page documenta a TEORIA (4 camadas, tipos de memória episódica/semântica/procedural, framework de Lilian Weng, estrutura `.agent/memory/`); esta fonte documenta a IMPLEMENTAÇÃO oficial da Anthropic via Managed Agents API (memory stores, versionamento, controle de acesso, limites de escala). Vale enriquecer o concept page com a seção de "memory stores como produto" se ainda não estiver lá.
- O alerta de **"memória envenenada via prompt injection"** é uma lacuna de segurança que vale revisar contra `04-SYSTEM/wiki/hot.md` e `MEMORY.md` do vault: ambos são "memória persistente lida como confiável em sessões futuras" — ainda que o vetor de ataque (input de usuário não-confiável processado por agente) seja diferente do contexto de uso pessoal do Michel, o PRINCÍPIO de "memória escrita uma vez é lida como verdade depois" se aplica, e merece um lembrete de revisão periódica de `hot.md`/`errors.md` para evitar que erros de leitura única se tornem "fatos" permanentes.
- A regra **"structure memory as many small focused files"** confirma — com a autoridade de um limite de plataforma real (100kB/2000 memórias) — uma prática que o vault já segue intuitivamente (arquivos atômicos em `03-RESOURCES/`, `wiki/hot.md` enxuto). É evidência a favor de continuar resistindo à tentação de "um grande arquivo de memória" em qualquer expansão futura do sistema de memória do vault.
- Conecta-se diretamente com [[03-RESOURCES/sources/dreams]] (mesma leva de ingestão) — ambas descrevem o MESMO padrão arquitetural ("nunca mutar memória original, sempre produzir versão/store nova") em duas camadas diferentes (versão individual vs. store completo). Juntas formam o quadro mais completo já documentado no vault sobre como a Anthropic trata persistência + auditabilidade + consolidação de memória de agente.
- Relaciona-se com a "camada Memory" descrita em [[03-RESOURCES/sources/hermes-kanban-mission-control-for-your-agents]] (framework de 4 camadas: SOUL.md = identidade / Skills = job training / Memory = conhecimento de ambiente / Kanban = coordenação) — esta fonte é a versão "oficial Anthropic / managed agents" do mesmo conceito de "Memory" que o Hermes implementa à sua maneira. Vale comparar os dois modelos: Hermes parece usar memória mais simples/local, enquanto a Anthropic formaliza versionamento, auditoria e controle de acesso granular como produto de API.
- Nenhuma contradição direta encontrada — esta fonte confirma e detalha tecnicamente padrões já mapeados em [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]] e reforça o princípio "receipts beat vibes" (trilha de auditoria imutável) já presente em fontes Hermes do vault.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/hermes-agent-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-observability]]
- [[03-RESOURCES/sources/dreams]]
- [[03-RESOURCES/sources/ai-agent-memory]]
- [[03-RESOURCES/sources/state-of-memory-in-agent-harness]]
- [[03-RESOURCES/sources/hermes-kanban-mission-control-for-your-agents]]

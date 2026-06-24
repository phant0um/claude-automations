---
title: "Using Agent Skills with the API (Full Guide)"
type: source
source: "Clippings/Using Agent Skills with the API.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, skills, messages-api, code-execution, files-api, api-reference]
---

## Tese central

Guia técnico completo de Agent Skills via **Messages API direta** (`platform.claude.com/docs/.../skills-guide`) — a referência canônica para a superfície que [[03-RESOURCES/sources/get-started-with-agent-skills-in-the-api]] introduz com um tutorial. Cobre integração via `container`, gestão de skills customizadas (CRUD + versionamento), padrões multi-turno, casos de uso, limites/constraints, e considerações de cache e retenção de dados. Skills aqui **sempre** rodam dentro do [code execution tool](https://platform.claude.com/docs/en/agents-and-tools/tool-use/code-execution-tool) — não há caminho de uso sem ele.

## Argumentos principais

- **Não elegível para Zero Data Retention (ZDR):** dados retidos conforme política padrão da feature — esta restrição é repetida ao final ("Data retention").
- **Integração idêntica para Anthropic e custom skills** — mesmo `container` shape, mesma forma de especificação (`type`, `skill_id`, `version` opcional), mesmo ambiente de execução. Tabela comparativa:
  | Aspecto | Anthropic Skills | Custom Skills |
  |---|---|---|
  | Type value | `anthropic` | `custom` |
  | Skill IDs | nomes curtos: `pptx`, `xlsx`, `docx`, `pdf` | gerados: `skill_01AbCdEfGhIjKlMnOpQrStUv` |
  | Formato de versão | data: `20251013` ou `latest` | epoch timestamp: `1759178010641129` ou `latest` |
  | Gestão | pré-construídas e mantidas pela Anthropic | upload e gestão via Skills API |
  | Disponibilidade | todos os usuários | privadas ao workspace |
- **Pré-requisitos:** API key, três beta headers (`code-execution-2025-08-25`, `skills-2025-10-02`, `files-api-2025-04-14` para upload/download), e o code execution tool habilitado.
- **Parâmetro `container`:** até **8 skills por requisição**; estrutura idêntica para Anthropic/custom (`type`, `skill_id`, `version` opcional).
- **Fluxo de geração e download de arquivo (4 passos):** (1) skill cria arquivos durante execução de código → (2) resposta inclui `file_id` por arquivo → (3) Files API baixa o conteúdo → (4) salva localmente ou processa.
- **Conversas multi-turno:** reutilizar o mesmo container especificando `container.id = response1.container.id`, repassando o histórico de mensagens incluindo `response1.content` como turno do assistant.
- **Operações longas e `pause_turn`:** o `stop_reason` pode vir como `pause_turn`, indicando que a API pausou uma operação de skill longa. Pode-se reenviar a resposta como está para continuar, ou modificar o conteúdo para interromper/redirecionar. Loop de retry recomendado: até `max_retries = 10`, reenviando com `container.id` da resposta anterior.
- **Múltiplas skills em uma requisição** — combinam-se para workflows complexos (ex: `xlsx` + `pptx` + custom skill).

### Gestão de Custom Skills (CRUD completo)

- **Criar:** bundle = diretório com `SKILL.md` no topo (`name`+`description` em frontmatter YAML) + scripts/recursos. Upload via arquivos individuais (`--file` por arquivo) ou zip; SDK Python tem helper `files_from_dir`.
  - **Requisitos:** `SKILL.md` no topo; todos os arquivos com diretório-raiz comum; **upload total < 30 MB**; `name` ≤ 64 caracteres (minúsculas/números/hífens, sem tags XML, sem palavras reservadas "anthropic"/"claude"); `description` ≤ 1024 caracteres, não-vazia, sem tags XML.
- **Listar:** `ant beta:skills list` (todas) ou `--source custom` (filtra).
- **Recuperar:** `ant beta:skills retrieve --skill-id <id>`.
- **Deletar:** requer deletar **todas as versões primeiro** (loop sobre `versions list` → `versions delete`), depois `skills delete`. Tentar deletar com versões existentes retorna **erro 400**.
- **Versionamento:**
  - Anthropic skills: formato data (`20251013`); novas versões liberadas conforme atualizações; recomenda-se fixar versões exatas para estabilidade.
  - Custom skills: epoch timestamps auto-gerados (`1759178010641129`); usar `"latest"` para sempre obter a mais recente; criar nova versão ao atualizar arquivos.

### Como Skills são carregadas (4 etapas)

1. **Metadata Discovery** — Claude vê metadata (nome, descrição) de cada skill no system prompt
2. **File Loading** — arquivos da skill são copiados para o container em `/skills/{directory}/`
3. **Automatic Use** — Claude carrega e usa skills automaticamente quando relevante
4. **Composition** — múltiplas skills compõem para workflows complexos

A arquitetura de progressive disclosure garante uso eficiente de contexto: instruções completas só carregam quando necessárias.

### Limites e constraints

- **Máximo de skills por requisição:** 8
- **Tamanho máximo de upload:** 30 MB (todos os arquivos combinados)
- **Frontmatter:** `name` ≤ 64 chars / `description` ≤ 1024 chars (regras detalhadas acima)
- **Ambiente de execução:** sem acesso à rede (não pode chamar APIs externas), sem instalação de pacotes em runtime (só pacotes pré-instalados), ambiente isolado (container fresco a menos que se especifique ID existente)

### Best practices

- **Quando combinar múltiplas skills:** bons casos = análise de dados (Excel) + apresentação (PowerPoint); geração de relatório (Word) + export PDF; lógica de domínio customizada + geração de documento. Evitar incluir skills não usadas (impacta performance).
- **Estratégia de versionamento:** produção → fixar versão específica (`"1759178010641129"`); desenvolvimento → usar `"latest"`.
- **Prompt caching quebra ao mudar a lista de skills:** adicionar/remover skills no `container` invalida o cache. Para melhor performance de cache, manter a lista de skills consistente entre requisições.
- **Tratamento de erros:** capturar `anthropic.BadRequestError` e checar se `"skill"` está na mensagem para tratamento específico de erros de skill.

## Key insights

- **A combinação de betas é um "contrato implícito" de três partes** — `code-execution-2025-08-25` + `skills-2025-10-02` + (quando há arquivo) `files-api-2025-04-14`. Faltar qualquer uma quebra o fluxo. Esse é o detalhe mais facilmente esquecido ao reproduzir os exemplos.
- **`pause_turn` é um mecanismo de controle de operações longas que generaliza além de Skills** — a doc nota que dá para "fornecer a resposta de volta como está" ou "modificar o conteúdo para interromper a conversa e fornecer orientação adicional", ou seja, é um ponto de intervenção humana em loops agenticos longos, não apenas um sinalizador técnico.
- **A invalidação de cache por mudança na lista de skills** é uma issue de design que cria tensão direta com "combine múltiplas skills para workflows complexos" — adicionar uma skill a mais para um caso de uso específico custa cache miss em todas as requisições subsequentes. Isso sugere que produtos devem **fixar conjuntos de skills por tipo de tarefa**, não montar dinamicamente.
- **O link para o blog post de engenharia** ("Equipping agents for the real world with Agent Skills") é citado como a fonte de "deep dive" sobre arquitetura — sinaliza que esta doc de referência é deliberadamente operacional, não conceitual, delegando o "porquê" ao material de engenharia.
- **Skills não são ZDR-eligible** — repetido nesta doc e em [[03-RESOURCES/sources/mcp-connector]], formando um padrão: features que envolvem execução/ferramentas externas tendem a sair do escopo de Zero Data Retention na Anthropic.

## Exemplos e evidências

Multi-turno reutilizando container:
```python
response2 = client.beta.messages.create(
    ...,
    container={
        "id": response1.container.id,
        "skills": [{"type": "anthropic", "skill_id": "xlsx", "version": "latest"}],
    },
    messages=messages,  # inclui response1.content como assistant turn
    ...
)
```

Loop de `pause_turn`:
```python
for i in range(max_retries):
    if response.stop_reason != "pause_turn":
        break
    messages.append({"role": "assistant", "content": response.content})
    response = client.beta.messages.create(..., container={"id": response.container.id, ...}, messages=messages, ...)
```

Criação de custom skill via CLI:
```bash
ant beta:skills create \
  --display-title "Financial Analysis" \
  --file financial_skill/SKILL.md \
  --file financial_skill/analyze.py \
  --beta skills-2025-10-02
```

Exemplo de domínio combinado (Excel + custom DCF skill):
```python
dcf_skill = client.beta.skills.create(display_title="DCF Analysis", files=files_from_dir("/path/to/dcf_skill"))
response = client.beta.messages.create(
    ...,
    container={"skills": [
        {"type": "anthropic", "skill_id": "xlsx", "version": "latest"},
        {"type": "custom", "skill_id": dcf_skill.id, "version": "latest"},
    ]},
    messages=[{"role": "user", "content": "Build a DCF valuation model for a SaaS company with the attached financials"}],
    ...
)
```

Casos de uso organizacionais documentados: Brand & Communications (formatação de marca, templates), Project Management (OKRs, decision logs, recaps), Business Operations (relatórios, propostas, modelos financeiros); e pessoais: Content Creation, Data Analysis, Development & Automation.

Limites concretos confirmados: **8 skills/requisição**, **30 MB upload**, `name` ≤ **64 chars**, `description` ≤ **1024 chars**, `max_retries = 10` no exemplo de `pause_turn`.

## Implicações para o vault

- É a **referência mais completa do sub-cluster de skills** para a superfície Messages API — qualquer integração futura do vault com geração de documentos via API deveria partir daqui, não do quickstart.
- Cross-referencia diretamente [[03-RESOURCES/sources/get-started-with-agent-skills-in-the-api]] (mesma superfície, nível introdutório) e [[03-RESOURCES/sources/skills]] (Managed Agents — mesmo conceito, mecanismo de anexação totalmente diferente).
- O insight sobre **invalidação de cache ao mudar skills** conecta com qualquer trabalho futuro do vault sobre [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]] — skills "fixas" vs "dinâmicas" tem trade-off direto de custo/performance que aquele conceito de otimização não cobre (foco em qualidade do conteúdo, não custo de cache).
- Detalha exatamente os "6 componentes de produção" de [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]] no nível de constraint de API: `name`/`description` = Frontmatter+Trigger; requisitos de tamanho e proibição de XML/palavras reservadas são regras de validação que aquele conceito não documenta.
- Sugestão (não criada): conceito `skill-authoring` cobriria as regras YAML de frontmatter (`name` ≤ 64, `description` ≤ 1024, sem XML/reservadas) que aparecem aqui de forma idêntica às regras do Claude Code descritas em [[03-RESOURCES/sources/extend-claude-with-skills]] — forte candidato a consolidação cross-superfície.

## Links

- [[03-RESOURCES/sources/get-started-with-agent-skills-in-the-api]]
- [[03-RESOURCES/sources/skills]]
- [[03-RESOURCES/sources/extend-claude-with-skills]]
- [[03-RESOURCES/sources/mcp-connector]]
- [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]]
- [[03-RESOURCES/entities/anthropic]]

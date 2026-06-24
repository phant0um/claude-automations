---
title: "Get Started with Agent Skills in the API (Quickstart)"
type: source
source: "Clippings/Get started with Agent Skills in the API.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, skills, messages-api, quickstart, code-execution]
---

## Tese central

Tutorial prático ("under 10 minutes") de como usar Agent Skills pré-construídas via **Messages API direta** (`platform.claude.com/docs/.../agent-skills/quickstart`) para gerar documentos (PowerPoint, Excel, Word, PDF). Cobre o fluxo mínimo: listar skills → fazer requisição com `container.skills` → extrair e baixar o arquivo gerado via Files API. É o "hello world" da superfície que [[03-RESOURCES/sources/using-agent-skills-with-the-api]] documenta em profundidade.

## Argumentos principais

- **As 4 pre-built Agent Skills da Anthropic disponíveis na API:**
  - **PowerPoint (`pptx`)** — criar e editar apresentações
  - **Excel (`xlsx`)** — criar e analisar planilhas
  - **Word (`docx`)** — criar e editar documentos
  - **PDF (`pdf`)** — gerar documentos PDF
- **Passo 1 — listar skills disponíveis:** `ant beta:skills list --source anthropic` retorna metadata (nome + descrição) de cada skill. Esse é o **primeiro nível de progressive disclosure**: Claude descobre skills sem ainda carregar suas instruções completas.
- **Passo 2 — criar um documento:** especifica-se a skill via parâmetro `container` na Messages API. Componentes da requisição:
  - `container.skills`: quais skills Claude pode usar (`type: "anthropic"`, `skill_id: "pptx"`, `version: "latest"`)
  - `tools`: habilita `code_execution` (**obrigatório** para Skills)
  - `betas`: `code-execution-2025-08-25` e `skills-2025-10-02`
  - Quando a requisição é feita, Claude casa a tarefa com a skill relevante e carrega suas instruções completas — **segundo nível de progressive disclosure** — e então executa o código da skill para criar o documento.
- **Recuperação de arquivo gerado:** o arquivo é criado dentro do container de execução de código e retornado como `file_id`. É preciso checar **dois tipos de result block** porque a skill pode rodar via Python ou bash code-execution tool: `code_execution_tool_result` (com `code_execution_result`) ou `bash_code_execution_tool_result` (com `bash_code_execution_result`). Depois, `client.beta.files.download(file_id=file_id)` baixa o conteúdo.
- **Variações demonstradas** — os mesmos parâmetros (`betas`, `tools`, `container.skills`) trocando apenas `skill_id`: `xlsx` (planilha de vendas trimestrais), `docx` (relatório de 2 páginas), `pdf` (template de fatura).
- **Próximos passos sugeridos pela doc:** API Guide completo, criar Skills customizadas, guia de autoria, usar Skills no Claude Code, Cookbook de exemplos.

## Key insights

- **Progressive disclosure tem dois níveis explicitamente nomeados** nesta doc: (1) descoberta de metadata via `list` (nome+descrição, sem carregar instruções), e (2) carregamento de instruções completas quando Claude decide que a skill é relevante para a tarefa. Esse é o mecanismo central que torna skills "baratas" em contexto até serem necessárias — eco direto do argumento central de [[03-RESOURCES/sources/extend-claude-with-skills]] sobre custo de token.
- A seleção da skill é **automática e implícita** — o usuário não especifica "use a skill pptx para isso"; ao pedir "create a presentation", Claude decide que `pptx` é relevante e a carrega. Isso é consistente com "When Claude uses MCP tools" em [[03-RESOURCES/sources/mcp-connector]] — o padrão de "Claude decide com base na descrição/relevância" se repete em skills e MCP.
- Esta é a única das quatro fontes do sub-cluster que mostra o **fluxo ponta-a-ponta completo de extração de arquivo** (incluindo o detalhe não-óbvio de checar dois tipos de result block, pois a skill pode rodar em Python ou bash).

## Exemplos e evidências

Requisição mínima criando uma apresentação:
```python
response = client.beta.messages.create(
    model="claude-opus-4-8",
    max_tokens=16000,
    betas=["code-execution-2025-08-25", "skills-2025-10-02"],
    container={
        "skills": [{"type": "anthropic", "skill_id": "pptx", "version": "latest"}]
    },
    messages=[{"role": "user", "content": "Create a presentation about renewable energy with 5 slides"}],
    tools=[{"type": "code_execution_20250825", "name": "code_execution"}],
)
```

Extração robusta de `file_id` (cobrindo Python e bash result types):
```python
file_id = None
for block in response.content:
    if block.type == "code_execution_tool_result":
        if block.content.type == "code_execution_result":
            for output in block.content.content:
                file_id = output.file_id
    elif block.type == "bash_code_execution_tool_result":
        if block.content.type == "bash_code_execution_result":
            for output in block.content.content:
                file_id = output.file_id

if file_id:
    output_path = Path(tempfile.gettempdir()) / "renewable_energy.pptx"
    file_content = client.beta.files.download(file_id=file_id)
    file_content.write_to_file(output_path)
```

Comando de listagem: `ant beta:skills list --source anthropic` → retorna `pptx`, `xlsx`, `docx`, `pdf`.

Betas necessários (consistentes em todas as variações): `code-execution-2025-08-25`, `skills-2025-10-02`.

## Implicações para o vault

- Funciona como **porta de entrada prática** para [[03-RESOURCES/sources/using-agent-skills-with-the-api]] — ambos cobrem a mesma superfície (Messages API), mas este é o tutorial introdutório de 10 minutos enquanto o outro é a referência técnica completa (limites, versionamento, cache, ZDR, casos de uso organizacionais).
- O detalhe de **checar dois tipos de result block** (`code_execution_tool_result` vs `bash_code_execution_tool_result`) é informação operacional concreta que faltaria em um resumo superficial — relevante se o vault algum dia integrar geração de documentos via Skills na Messages API.
- Reforça a noção de **progressive disclosure** como mecanismo-chave compartilhado entre as três superfícies de Skills do lote (Managed Agents, Messages API, Claude Code), todas otimizando para "carregar conteúdo completo só quando necessário".
- Conecta-se à entidade Anthropic / Claude API e aos conceitos de execução de código e Files API já presentes no vault.

## Links

- [[03-RESOURCES/sources/using-agent-skills-with-the-api]]
- [[03-RESOURCES/sources/skills]]
- [[03-RESOURCES/sources/extend-claude-with-skills]]
- [[03-RESOURCES/sources/mcp-connector]]
- [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/entities/anthropic]]

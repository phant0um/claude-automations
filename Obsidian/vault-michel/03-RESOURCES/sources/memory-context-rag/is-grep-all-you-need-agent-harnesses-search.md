---
title: "Is Grep All You Need? How Agent Harnesses Reshape Agentic Search"
type: source
source: Clippings/Is Grep All You Need? How Agent Harnesses Reshape Agentic Search.md
created: 2026-05-17
ingested: 2026-05-17
tags: [ai-agents, research, harness, search, rag]
triagem_score: 10
---

## Tese central
Agent harnesses bem desenhados (grep + filesystem + iteração agêntica) superam RAG vetorial puro em agentic search — simplicidade vence sofisticação em cenários onde agente pode iterar. Paper demonstra empiricamente que ferramentas Unix clássicas com loop de raciocínio batem embeddings + vector store em benchmarks de retrieval agêntico.

## Key insights
- **PwC paper com evidência empírica:** não argumento filosófico — benchmarks concretos mostram harness com grep/find superando RAG vetorial em tarefas de retrieval agêntico (código relevante, documentação, bug localization)
- **Reabilita ferramentas Unix clássicas:** grep, find, wc, diff são primitivas que LLMs entendem bem (treinados em documentação Unix) e têm semântica exata — sem aproximação de embedding
- **Iteração agêntica é o diferencial:** RAG retorna top-k e para. Agente com grep pode refinar query, checar contexto de resultado, navegar para arquivo relacionado, iterar até encontrar — loop que RAG não tem
- **Confirma thin harness / fat skill:** harness mínimo (ferramentas Unix ao agente) + skill robusta (raciocínio do LLM) > stack complexo de embedding + vector DB + retrieval pipeline

## Por que RAG puro falha em agentic search

### RAG foi projetado para single-shot retrieval

RAG clássico: query → embedding → nearest neighbors → augment prompt → generate. Um ciclo.

Em busca agêntica, tarefa raramente resolve em um ciclo:
- "Encontre o bug que causa timeout na API de pagamento" — requer navegar múltiplos arquivos, entender fluxo de chamadas, eliminar hipóteses
- Single-shot RAG retorna arquivos semanticamente similares à query, mas pode perder arquivo crítico 3 níveis de chamada de distância

### Embedding tem limitações semânticas

- "O que a função `validate_token` faz?" — embedding encontra arquivo com boa precisão
- "Onde `validate_token` é chamada com token expirado?" — embedding não sabe o que é "token expirado" no contexto específico da codebase. Grep com pattern ou navegação do call graph é mais eficaz

## Arquitetura de harness com grep

### Ferramentas expostas ao agente

```python
tools = [
    grep(pattern, path, flags=["-r", "-n", "-i", "-l"]),  # busca por padrão
    find(path, name=None, type=None, mtime=None),          # localizar arquivos
    read_file(path, start_line=None, end_line=None),        # ler arquivo ou trecho
    list_directory(path),                                   # listar conteúdo
    diff(file_a, file_b),                                   # comparar arquivos
]
```

### Loop agêntico

```
[1] Agente recebe query de busca
[2] Decide primeira estratégia (grep broad, find por tipo, read index)
[3] Executa tool, analisa resultado
[4] Decide: encontrou? → retornar. Parcial? → refinar. Nada? → mudar estratégia
[5] Iterar até encontrar ou esgotar estratégias razoáveis
```

LLM raciocina sobre resultado de cada grep para determinar próxima ação — exatamente como desenvolvedor humano faria num terminal.

## Benchmarks do paper

Paper testa em três tipos de tarefas:

1. **Code search:** encontrar função específica em codebase de 50K+ linhas. Harness: 91% de sucesso. RAG: 76%.
2. **Bug localization:** identificar arquivo e linha de bug descrito em linguagem natural. Harness: 73%. RAG: 58%.
3. **Documentation retrieval:** encontrar documentação relevante para API específica. Harness: 88%. RAG: 85% — menor diferença, RAG melhor calibrado para texto puro.

Insight: quanto mais iterativo e contextual o task, maior a vantagem do harness.

## Quando RAG ainda ganha

- Corpora de texto puro sem estrutura de código/sistema (artigos, PDFs)
- Queries semânticas abertas onde padrão exato não é conhecível a priori
- Escala muito grande onde custo de iteração domina (milhões de documentos)
- Latência crítica onde múltiplos round-trips são inaceitáveis

## Implicação para vault-michel

Busca no vault usa MCP filesystem + grep para localizar páginas. Abordagem alinhada com conclusões do paper — melhor que ter vector store de embeddings de todas as notas. Hot.md serve como índice de primeiro nível antes de grep — reduz número de iterações necessárias.

## Custo de iteração vs custo de infraestrutura

RAG vetorial tem custo de setup alto (embeddings de todo corpus, vector DB, retrieval pipeline) mas custo de query baixo (single lookup). Harness agêntico tem custo de setup baixo (dar ferramentas ao LLM) mas custo de query variável (pode fazer 1 ou 10 greps por query).

Trade-off econômico:
- RAG é econômico quando volume de queries é alto e corpus é estável
- Harness agêntico é econômico quando corpus muda frequentemente (reembedding caro) ou quando queries são exploratórias (iteração natural)

Vault-michel: corpus muda diariamente (ingestão contínua), queries são exploratórias (pesquisa de conceitos). Harness agêntico + hot.md como índice é arquitetura economicamente correta.

## Por que o título funciona como pergunta retórica

"Is Grep All You Need?" referencia "Attention is All You Need" (paper do transformer). A referência é intencional: assim como o paper original argumentou que mecanismo de atenção era suficiente para substituir RNNs, este paper argumenta que ferramentas simples de busca são suficientes para substituir RAG complexo em contexto agêntico. Provocação deliberada que chama atenção de quem conhece a literatura.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]
- [[03-RESOURCES/concepts/agent-systems/agentic-harness-engineering]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-agent-harness-architecture]]
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]

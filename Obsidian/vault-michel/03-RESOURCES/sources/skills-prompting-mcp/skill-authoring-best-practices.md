---
title: "Skill authoring best practices"
type: source
source: "Clippings/Skill authoring best practices.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, skills, claude-skills-architecture, prompt-engineering, evaluation-driven-development]
---

## Tese central

Boas Skills são concisas, bem estruturadas e testadas com uso real — o documento oficial da Anthropic ("Skill authoring best practices") é o guia canônico de **decisões práticas de autoria** (não conceitual: para arquitetura conceitual, remete ao "Skills overview"). A tese central condensa em uma frase: **"Claude já é muito inteligente — só adicione contexto que ele não tem."** Toda a doc deriva dessa premissa: o context window é um bem público compartilhado entre system prompt, histórico de conversa, metadata de outras Skills e o pedido do usuário, então cada token de uma Skill compete por espaço e deve justificar seu custo.

## Argumentos principais

- **Concisão é o princípio raiz**: nem todo token de uma Skill tem custo imediato — no startup, só `name` e `description` (metadata) de todas as Skills são pré-carregados; o corpo do SKILL.md só é lido quando a Skill se torna relevante, e arquivos adicionais só quando necessários. Mas, uma vez carregado, cada token compete com o resto do contexto. Teste: "Claude realmente precisa dessa explicação? Esse parágrafo justifica seu custo em tokens?" Exemplo dado: versão concisa de "extrair texto de PDF" usa ~50 tokens vs. ~150 tokens da versão verbosa que explica o que é PDF (informação que Claude já tem).
- **Graus de liberdade devem casar com a fragilidade da tarefa** — framework de 3 níveis:
  - **Alta liberdade** (instruções em texto): quando múltiplas abordagens são válidas, decisões dependem de contexto, heurísticas guiam (ex.: processo de code review em 4 passos genéricos).
  - **Média liberdade** (pseudocódigo/scripts parametrizados): quando existe um padrão preferido mas alguma variação é aceitável (ex.: função `generate_report(data, format, include_charts)`).
  - **Baixa liberdade** (scripts específicos, poucos/nenhum parâmetro): quando operações são frágeis e propensas a erro, consistência é crítica, uma sequência específica deve ser seguida (ex.: "rode exatamente este script: `migrate.py --verify --backup`. Não modifique").
  - **Analogia central**: pensar em Claude como um robô explorando um caminho — "ponte estreita com penhascos dos dois lados" pede instruções exatas (baixa liberdade); "campo aberto sem perigos" pede direção geral e confiança na navegação de Claude (alta liberdade).
- **Teste com todos os modelos planejados**: Skills são adições aos modelos, então a eficácia depende do modelo subjacente. Haiku (rápido/econômico) — a Skill dá orientação suficiente? Sonnet (balanceado) — está clara e eficiente? Opus (raciocínio poderoso) — evita explicar demais? O que funciona perfeitamente para Opus pode precisar de mais detalhe para Haiku.
- **Estrutura YAML obrigatória**: `name` (máx. 64 caracteres, somente minúsculas/números/hífens, sem tags XML, **sem palavras reservadas "anthropic"/"claude"**) e `description` (não-vazio, máx. 1024 caracteres, sem tags XML, deve descrever o que a Skill faz E quando usá-la).
- **Convenção de nomenclatura — forma gerúndio (verbo + -ing)**: `processing-pdfs`, `analyzing-spreadsheets`, `managing-databases`. Alternativas aceitáveis: frases nominais (`pdf-processing`) ou orientadas a ação (`process-pdfs`). Evitar: nomes vagos (`helper`, `utils`, `tools`), genéricos demais (`documents`, `data`), palavras reservadas (`anthropic-helper`, `claude-tools`), padrões inconsistentes dentro da própria coleção.
- **Descriptions eficazes — sempre em terceira pessoa**: a description é injetada no system prompt, e ponto de vista inconsistente causa problemas de descoberta. Bom: "Processes Excel files and generates reports". Evitar: "I can help you..." / "You can use this to...". Deve ser específica, incluir termos-chave, e cobrir tanto o QUE faz quanto QUANDO usar — porque Claude usa a description para escolher a Skill certa entre potencialmente 100+ disponíveis. Exemplos vagos a evitar: "Helps with documents", "Processes data", "Does stuff with files".
- **SKILL.md como sumário/table-of-contents**: deve funcionar como visão geral que aponta para materiais detalhados sob demanda — manter o corpo abaixo de 500 linhas; dividir conteúdo em arquivos separados ao se aproximar do limite.
- **3 padrões de organização de conteúdo**:
  1. *Guia de alto nível com referências*: SKILL.md com quick start + ponteiros para FORMS.md/REFERENCE.md/EXAMPLES.md, carregados só quando necessário.
  2. *Organização por domínio*: para Skills multi-domínio, separar por área (`reference/finance.md`, `reference/sales.md` etc.) evita carregar contexto irrelevante — quando o usuário pergunta sobre vendas, Claude só lê o schema de vendas, mantendo uso de tokens baixo e foco alto.
  3. *Detalhes condicionais*: mostrar conteúdo básico inline, linkar para conteúdo avançado apenas quando necessário (ex.: "Para mudanças rastreadas, veja REDLINING.md").
- **Evitar referências profundamente aninhadas — manter um nível de profundidade**: Claude pode ler arquivos parcialmente quando referenciados a partir de outros arquivos referenciados (usando `head -100` em vez de ler o arquivo inteiro), resultando em informação incompleta. Todos os arquivos de referência devem linkar diretamente do SKILL.md. Para arquivos de referência com mais de 100 linhas, incluir uma table of contents no topo, garantindo que Claude veja o escopo completo mesmo em leituras parciais.
- **Workflows para tarefas complexas — checklists copiáveis**: quebrar operações complexas em passos sequenciais claros; para workflows particularmente complexos, fornecer um checklist que Claude pode copiar na resposta e marcar conforme avança (ex.: "Research Progress: - [ ] Step 1: Read all source documents..."). Padrão comum: **rodar validador → corrigir erros → repetir** — esse loop melhora muito a qualidade do output. Mostrado tanto para Skills sem código (revisão de estilo via STYLE_GUIDE.md como "validador" textual) quanto com código (validação via script Python a cada edição de XML).
- **Diretrizes de conteúdo**:
  - *Evitar informação sensível ao tempo*: não escrever "antes de agosto de 2025 use a API antiga..." (ficará desatualizado); em vez disso, usar uma seção "Old patterns" com `<details>` recolhível para contexto histórico sem poluir o conteúdo principal.
  - *Terminologia consistente*: escolher um termo e usá-lo sempre ("API endpoint", "field", "extract") em vez de alternar entre sinônimos ("URL"/"API route"/"path"), o que ajuda Claude a entender e seguir instruções.
- **Padrões comuns reutilizáveis**: Template pattern (estruturas de output rígidas vs. flexíveis, conforme o caso exigir rigor ou adaptação); Examples pattern (pares input/output concretos — exemplo dado para mensagens de commit nos moldes Conventional Commits); Conditional workflow pattern (guiar Claude por pontos de decisão explícitos: "Criando conteúdo novo? → siga workflow X. Editando? → siga workflow Y").
- **Avaliações ANTES da documentação extensa — evaluation-driven development em 5 passos**:
  1. Identificar lacunas (rodar Claude em tarefas representativas sem a Skill, documentar falhas específicas)
  2. Criar avaliações (3 cenários que testam essas lacunas)
  3. Estabelecer baseline (medir performance sem a Skill)
  4. Escrever instruções mínimas (apenas o suficiente para passar nas avaliações)
  5. Iterar (executar avaliações, comparar com baseline, refinar)

  Isso garante que você resolve problemas reais em vez de documentar problemas imaginados. Estrutura de avaliação dada como JSON com `skills`, `query`, `files`, `expected_behavior` — não existe um runner built-in; usuários constroem seu próprio sistema de avaliação.
- **Desenvolver Skills iterativamente COM Claude — o padrão "Claude A / Claude B"**: trabalhar com uma instância ("Claude A") para criar a Skill que outra instância ("Claude B") usa. Claude A ajuda a desenhar/refinar instruções; Claude B testa em tarefas reais. Funciona porque modelos Claude entendem tanto como escrever instruções de agente eficazes quanto o que agentes precisam saber. Fluxo de criação em 7 passos: (1) completar uma tarefa sem Skill notando o que você forneceu repetidamente, (2) identificar o padrão reutilizável, (3) pedir a Claude A para criar a Skill, (4) revisar concisão ("remova a explicação sobre o que é win rate — Claude já sabe"), (5) melhorar arquitetura de informação ("organize isso para que o schema da tabela fique em um arquivo de referência separado"), (6) testar com Claude B, (7) iterar com base na observação. Fluxo de iteração contínua alterna entre Claude A (especialista que refina), Claude B (agente que executa trabalho real) e observação trazida de volta — incluindo sugestões de linguagem mais forte tipo "MUST filter" em vez de "always filter" quando uma regra não está sendo seguida.
- **Sinais a observar ao iterar**: caminhos de exploração inesperados (Claude lê arquivos em ordem que você não previu — pode indicar estrutura pouco intuitiva), conexões perdidas (Claude não segue referências importantes — links podem precisar ser mais explícitos), dependência excessiva de certas seções (talvez devesse estar no SKILL.md principal), conteúdo ignorado (arquivo nunca acessado pode ser desnecessário ou mal sinalizado).
- **Anti-padrões**: caminhos estilo Windows (sempre usar barras `/`, mesmo no Windows — caminhos Unix funcionam em todas as plataformas); oferecer opções demais ("Você pode usar pypdf, ou pdfplumber, ou PyMuPDF..." é confuso — prefira um default com escape hatch: "Use pdfplumber... Para PDFs escaneados que precisam de OCR, use pdf2image com pytesseract").
- **Skills com código executável — seção avançada**:
  - *Resolver, não empurrar para Claude*: tratar condições de erro explicitamente em vez de deixar Claude lidar (exemplo dado: `process_file` que cria arquivo default em vez de falhar com `FileNotFoundError`/`PermissionError`).
  - *Evitar "voodoo constants" (Lei de Ousterhout)*: parâmetros de configuração devem ser justificados e documentados — `REQUEST_TIMEOUT = 30  # HTTP requests typically complete within 30 seconds` é melhor que `TIMEOUT = 47  # Why 47?`. "Se você não sabe o valor certo, como Claude vai determinar?"
  - *Fornecer scripts utilitários*: mesmo que Claude pudesse escrever o script, scripts pré-prontos são mais confiáveis, economizam tokens (não precisam estar no contexto), economizam tempo, garantem consistência. Distinção importante: deixar claro se Claude deve EXECUTAR o script ("Run analyze_form.py to extract fields") ou LER como referência ("See analyze_form.py for the field extraction algorithm") — para a maioria dos scripts utilitários, execução é preferível.
  - *Usar análise visual*: quando inputs podem ser renderizados como imagens, converter (ex.: PDF→imagens) e deixar Claude analisar visualmente layouts e estruturas usando capacidades de visão.
  - *Criar outputs intermediários verificáveis — padrão "plan-validate-execute"*: para tarefas complexas e abertas onde Claude pode errar, fazer Claude primeiro criar um plano em formato estruturado, validar esse plano com um script, e só então executar. Exemplo: atualizar 50 campos de formulário PDF a partir de planilha — sem validação, Claude pode referenciar campos inexistentes, criar valores conflitantes, perder campos obrigatórios. Solução: arquivo intermediário `changes.json` validado antes de aplicar mudanças (analyze → create plan → validate plan → execute → verify). Funciona porque pega erros cedo, é verificável por máquina, permite planejamento reversível, e dá debugging claro. Usar em: operações em lote, mudanças destrutivas, regras de validação complexas, operações de alto risco. Dica: tornar mensagens de erro de scripts de validação verbosas e específicas (ex.: "Field 'signature_date' not found. Available fields: customer_name, order_total, signature_date_signed").
  - *Dependências de pacotes*: claude.ai pode instalar pacotes do npm/PyPI e puxar de repositórios GitHub; a Claude API não tem acesso a rede nem instalação de runtime — listar pacotes necessários no SKILL.md e verificar disponibilidade na ferramenta de execução de código.
  - *Ambiente de runtime — modelo de acesso filesystem*: (1) metadata pré-carregada no startup; (2) arquivos lidos sob demanda via ferramentas Read/bash; (3) scripts executados eficientemente sem carregar conteúdo no contexto (só o output consome tokens); (4) sem penalidade de contexto para arquivos grandes até serem efetivamente lidos. Implicações práticas: caminhos importam (barras `/`), nomear arquivos descritivamente (`form_validation_rules.md`, não `doc2.md`), organizar para descoberta por domínio, empacotar recursos abrangentes sem medo de penalidade de contexto, preferir scripts para operações determinísticas, deixar claro intenção de execução vs. leitura, testar padrões de acesso a arquivo.
  - *Referências a ferramentas MCP*: sempre usar nomes totalmente qualificados no formato `ServerName:tool_name` (ex.: `BigQuery:bigquery_schema`, `GitHub:create_issue`) — sem o prefixo do servidor, Claude pode falhar em localizar a ferramenta, especialmente com múltiplos servidores MCP disponíveis.
  - *Não assumir que ferramentas estão instaladas*: ser explícito sobre dependências ("Install required package: `pip install pypdf`") em vez de assumir ("Use the pdf library...").

## Key insights

- A frase-chave que resume tudo: **"Claude is already very smart — only add context Claude doesn't already have."** Esse é o filtro de qualidade número um para qualquer Skill — e por extensão, para qualquer documento de instrução de agente (CLAUDE.md, SOUL.md, system prompts).
- O **"context window é um bem público"** é um enquadramento poderoso: SKILL.md não compete só consigo mesmo — compete com system prompt, histórico, metadata de OUTRAS Skills (potencialmente 100+) e o pedido do usuário. Isso eleva concisão de "boa prática de escrita" para "requisito de engenharia de sistema compartilhado".
- O framework de **graus de liberdade (alto/médio/baixo)** é uma ferramenta de design transferível: mapeia diretamente o eixo "fragilidade da tarefa × variabilidade aceitável" para "quanta especificidade colocar nas instruções" — útil não só para Skills, mas para qualquer documento de orientação a agentes (incluindo agentes do próprio vault).
- **Avaliação antes de documentação** inverte a ordem intuitiva (escrever primeiro, testar depois) — e essa inversão é o que evita o anti-padrão mais comum: Skills que documentam problemas imaginados em vez de resolver lacunas reais observadas.
- O padrão **"Claude A cria, Claude B testa, observação volta para Claude A"** é, na prática, um ciclo de **meta-agência**: usar IA para construir e refinar as instruções que outra instância de IA vai seguir — e ele só funciona porque "Claude models understand both how to write effective agent instructions and what information agents need." Esse é um argumento direto a favor de usar o próprio Claude Code para escrever/revisar skills do vault (e não escrevê-las manualmente).
- **"Avoid time-sensitive information"** é uma diretriz que o próprio guia segue de forma exemplar — a seção usa "antes/depois de agosto de 2025" como o exemplo do que NÃO fazer, e propõe a seção `<details><summary>Legacy...</summary>` recolhível como solução elegante para preservar contexto histórico sem ruído.
- **"Solve, don't punt"** + Lei de Ousterhout (voodoo constants) trazem rigor de engenharia de software clássica para o domínio novo de scripts dentro de Skills — reforça que Skills com código não são "scripts soltos", mas componentes de produção que merecem o mesmo cuidado de qualquer codebase.
- O padrão **plan-validate-execute** é a aplicação mais explícita já vista no vault do princípio "trust but verify" aplicado a fluxos agente-código: ao introduzir um artefato intermediário verificável (`changes.json`) entre planejamento e execução, o sistema cria um ponto de checagem que reduz drasticamente o blast radius de erros em operações em lote/destrutivas.

## Exemplos e evidências

- Comparação de tokens concreta: versão concisa de "extrair texto de PDF com pdfplumber" ≈ 50 tokens vs. versão verbosa explicando o que é PDF e por que usar pdfplumber ≈ 150 tokens — uma diferença de 3× só por assumir conhecimento prévio de Claude.
- Estrutura de diretório completa de exemplo de Skill em produção:
  ```
  pdf/
  ├── SKILL.md              # Main instructions (loaded when triggered)
  ├── FORMS.md              # Form-filling guide (loaded as needed)
  ├── reference.md          # API reference (loaded as needed)
  ├── examples.md           # Usage examples (loaded as needed)
  └── scripts/
      ├── analyze_form.py
      ├── fill_form.py
      └── validate.py
  ```
- Exemplo de organização por domínio para BigQuery: `reference/finance.md`, `reference/sales.md`, `reference/product.md`, `reference/marketing.md` — com comandos `grep -i "revenue" reference/finance.md` no SKILL.md para busca rápida.
- Exemplo completo de "old patterns" pattern com `<details><summary>Legacy v1 API (deprecated 2025-08)</summary>`.
- Três exemplos completos de mensagens de commit no formato `type(scope): brief description` seguidos de explicação detalhada — usados para ensinar o "examples pattern".
- Estrutura JSON de avaliação completa:
  ```json
  {
    "skills": ["pdf-processing"],
    "query": "Extract all text from this PDF file and save it to output.txt",
    "files": ["test-files/document.pdf"],
    "expected_behavior": [
      "Successfully reads the PDF file using an appropriate PDF processing library or command-line tool",
      "Extracts text content from all pages in the document without missing any pages",
      "Saves the extracted text to a file named output.txt in a clear, readable format"
    ]
  }
  ```
- Exemplo de função self-documenting vs. magic numbers: `REQUEST_TIMEOUT = 30  # HTTP requests typically complete within 30 seconds` / `MAX_RETRIES = 3  # Three retries balances reliability vs speed` vs. `TIMEOUT = 47  # Why 47?`.
- Checklist final completo de "Effective Skills" dividido em "Core quality" (10 itens, ex.: "Description is specific and includes key terms", "File references are one level deep") e "Code and scripts" (8 itens, ex.: "No voodoo constants", "Feedback loops included for quality-critical tasks") — funciona como rubrica de QA pronta para uso.

## Implicações para o vault

- Esta é a fonte **normativa primária** sobre como escrever Skills — complementa diretamente [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]] (que documenta os "6 componentes de produção": Frontmatter, Trigger, Role, Process, Format, Examples) com a camada de **decisões práticas de autoria** que faltava: graus de liberdade, convenções de nomenclatura (gerúndio), regras precisas de `name`/`description`, padrões de organização (1-nível-de-profundidade), e o checklist de QA completo. O concept page deveria ser atualizado para referenciar este checklist como ferramenta de auditoria.
- O checklist final de "Effective Skills" é diretamente acionável como rubrica de auditoria para os ~40 skills do vault em `04-SYSTEM/skills/` — possibilita uma auditoria sistemática (ex.: via `04-SYSTEM/agents/core/audit-agentes-mensal.md`) checando "description em terceira pessoa? gerúndio? referências em 1 nível? sem voodoo constants?".
- O ciclo **Claude A / Claude B** valida e formaliza exatamente o processo que o vault já usa informalmente ao pedir para Claude Code escrever/revisar suas próprias skills (`04-SYSTEM/skills/`) — é evidência de que esse não é um hack, é o workflow recomendado pela própria Anthropic para autoria de Skills.
- A regra "**sem palavras reservadas 'anthropic'/'claude' no campo `name`**" é um detalhe técnico fino que pode invalidar silenciosamente Skills mal nomeadas — vale checar se alguma skill do vault usa esses termos no `name` do frontmatter (não no título/descrição).
- O framework de **graus de liberdade (alto/médio/baixo)** generaliza além de Skills: é uma lente útil para qualquer documento de orientação de agente no vault (CLAUDE.md, agentes em `04-SYSTEM/agents/`, system prompts de subagentes) — quanto mais frágil/sequencial a operação, menor a liberdade que se deve dar.
- Conecta-se tematicamente com [[03-RESOURCES/sources/extend-claude-with-skills]] e [[03-RESOURCES/sources/skills]] (referências de estrutura/frontmatter de Skills ingeridas na mesma leva) e com [[03-RESOURCES/sources/using-agent-skills-with-the-api]] — juntas formam um conjunto coeso: "o que é uma Skill" + "como estruturar tecnicamente" + "como escrever uma boa" + "como usar via API".
- Nenhuma contradição encontrada com conhecimento existente do vault — esta fonte é a peça normativa que faltava, confirmando e detalhando o que [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]] já descrevia em alto nível.

## Links
- [[03-RESOURCES/concepts/agent-systems/claude-skills-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/agent-systems/skill-optimization-gradient-descent]]
- [[03-RESOURCES/sources/extend-claude-with-skills]]
- [[03-RESOURCES/sources/skills]]
- [[03-RESOURCES/sources/using-agent-skills-with-the-api]]
- [[03-RESOURCES/sources/hermes-kanban-mission-control-for-your-agents]]

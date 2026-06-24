---
title: "AI Agent Memory"
type: source
source: "Clippings/AI Agent Memory.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents]
---

## Tese central

Memória de agente de IA é o sistema construído em volta de um LLM estateless para fazê-lo agir como se lembrasse — o LLM em si não lembra, o agente lembra por ele. Compreender memória de agente exige entender quatro layers com lifespans diferentes, quatro operações fundamentais (write/read/update/forget) e o flow completo a cada turno de usuário.

## Argumentos principais

- **O LLM é estateless por design**: toda chamada é como falar com alguém que nunca nos encontrou. Sem memória, há quatro problemas estruturais: sem continuidade, sem personalização, sem aprendizado, sem tarefas longas.
- **A memória de agente é uma stack de quatro layers**:
  - **Layer 1 — Context Window**: texto que o LLM vê em uma única chamada. Mais rápido porque o LLM lê diretamente. Menor capacidade. Quando cheia, mensagens antigas são descartadas ou sumarizadas.
  - **Layer 2 — Short-Term Memory (sessão)**: scratchpad que o agente usa durante uma tarefa ou sessão. Segura o plano, step atual, resultados intermediários. Desaparece quando a sessão termina.
  - **Layer 3 — Long-Term Memory (persistente)**: memória que sobrevive entre conversas e sessões. Armazena fatos do usuário, preferências, resumos de conversas passadas, comportamentos aprendidos. Faz o agente "conhecer" o usuário.
  - **Layer 4 — External Knowledge (tools/RAG)**: tudo que o agente pode consultar mas não mantém — documentos, bancos de dados, APIs, web. O agente lê mas não escreve de volta como memória própria.
- **Analogia funcional**: context window = mesa do LLM; short-term memory = bloco de notas ao lado da mesa; long-term memory = diário pessoal na gaveta; external knowledge = biblioteca do outro lado da rua. Manter a mesa limpa, o bloco organizado, o diário confiável, e a biblioteca indexada.
- **Quatro operações fundamentais**:
  - **Write**: salvar nova informação ("preferred language: Go").
  - **Read**: puxar informação relevante para o momento — a parte mais difícil. Não se quer tudo, apenas o que importa agora.
  - **Update**: modificar memórias existentes quando nova informação as contradiz.
  - **Forget**: remover memórias stale, erradas, ou irrelevantes. Sem forget, o store cresce indefinidamente e o retrieval piora.
- **Se qualquer operação estiver quebrada, o sistema inteiro quebra**: agente que escreve mas nunca lê = desperdício de disco. Que lê mas nunca atualiza = age em fatos desatualizados. Que nunca esquece = afoga em sua própria história.
- **Flow a cada turno** (Read → Build prompt → LLM loop → Write → Response):
  1. Usuário envia mensagem.
  2. Busca em long-term memory por contexto relevante (punhado de fatos úteis).
  3. Lê short-term memory da sessão atual (plano, ações recentes, resultados intermediários).
  4. Constrói o prompt: system prompt + retrieved long-term memories + short-term scratchpad + user message → context window.
  5. LLM raciocina e responde, possivelmente chamando tools (external knowledge) múltiplas vezes num loop.
  6. Escreve nova informação na memória — short-term recebe o novo step; se algo importante foi aprendido, vai para long-term.
  7. Resposta enviada ao usuário.
- **Write de long-term é frequentemente assíncrono** em produção, após a resposta ser enviada — usuário não paga o custo de latência da escrita.
- **O que armazenar**: fatos estáveis do usuário (nome, papel, linguagem, timezone), preferências fortes, outcomes de tarefas passadas, decisões que moldam trabalho futuro. Regra: "store what will matter next week."
- **O que não armazenar**: cada mensagem individual (o context window já tem a conversa viva), chit-chat de baixo sinal, estado temporário que já está em short-term, dados sensíveis sem consentimento.

## Key insights

- **"The second turn feels personal even though it happened a week later. The LLM itself remembers nothing. The agent did all the remembering for it."** — a ilusão de memória é inteiramente construída pelo agente, não pelo modelo.
- **Read é a operação mais difícil**: não se quer tudo, apenas o que importa agora. A decisão de o que recuperar — não de o que armazenar — é onde a maioria dos sistemas de memória falha em produção.
- **Semantic search (embeddings) em vez de keyword match** para evitar o problema de "memória armazenada mas não encontrada". Recuperar mais candidatos do que necessário e deixar o LLM escolher.
- **Confundir short-term e long-term é erro comum e silencioso**: escrever estado efêmero em long-term (ruído) ou manter fatos estáveis apenas em short-term (perda na sessão seguinte). Quando em dúvida, prefira short-term — pode promover para long-term depois.
- **Erros de memória são silenciosos**: o agente não crasha — dá respostas subtilmente erradas. Logging, monitoring e audits regulares do memory store são obrigatórios. Sem isso, você descobre só quando um usuário reclama.
- **Privacy scope por user ID**: nunca misturar memórias entre usuários. Para dados sensíveis, encrypt em repouso e em trânsito, consentimento explícito antes de escrever. Isso é uma consequência direta da superfície de ataque de contaminação cross-user documentada em outros estudos.

## Exemplos e evidências

- **Exemplo running — Priya/Go**:
  - Turno 1: "My name is Priya and I code in Go." → long-term escreve: "User's name is Priya. Preferred language: Go."
  - Turno 2 (uma semana depois): "Help me write a function that reverses a string." → agent recupera "Priya, prefers Go" → LLM responde com função Go endereçada a Priya.
- **Pseudocode completo** do loop de execução de memória a cada turno (com search, build prompt, LLM loop com tools, write).
- **Diagrama ASCII** do flow (User Message → READ Memory → Build Prompt → LLM ↔ External Knowledge → WRITE Memory → Response).
- **Stack diagram ASCII** das quatro layers com lifespan de cada uma.
- **Seis problemas comuns com fixes específicos**:
  1. Context window overflow → sumarizar turns antigos, remover tool outputs não mais necessários.
  2. Retrieval miss → semantic search (embeddings), títulos e descrições boas, recuperar mais candidatos.
  3. Outdated memories → checar contradições em cada write, update ou replace.
  4. Memory bloat → forget policy (não usados por muito tempo ou supersedidos).
  5. Privacy leaks → scope por user ID, encrypt, consentimento.
  6. Confusão entre layers → deliberado sobre qual layer cada write vai.

## Implicações para o vault

- O vault-michel usa exatamente este padrão: MEMORY.md (long-term), hot.md (short-term/working cache), e o context window da sessão. Este source formaliza e confirma essa arquitetura como correta.
- A regra "store what will matter next week" é diretamente aplicável às decisões de o que entra no MEMORY.md vs. o que fica só no hot.md.
- O insight de "read é a operação mais difícil" explica por que hot.md + MEMORY.md indexado funcionam melhor do que um único arquivo grande.
- O aviso sobre erros silenciosos de memória — o agente não crasha, dá respostas sutilmente erradas — é relevante para o pipeline de ingestão.
- Complementa e é complementado por [[03-RESOURCES/sources/state-of-memory-in-agent-harness]], que analisa as implementações específicas de cada harness.

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-memory]]
- [[03-RESOURCES/concepts/ai-agents/context-engineering]]
- [[03-RESOURCES/sources/state-of-memory-in-agent-harness]]
- [[04-SYSTEM/wiki/hot.md]]

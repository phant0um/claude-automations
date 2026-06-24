---
title: Prompt Engineering Patterns
type: concept
status: developing
tags: [prompts, claude, produtividade, escrita, estrategia]
created: 2026-04-15
updated: 2026-05-19
---

# Prompt Engineering Patterns

Padrões recorrentes que fazem a diferença entre prompts genéricos e prompts que realmente funcionam, destilados de uso prático.

> [!key-insight] Princípio fundamental
> Restrições negativas e exemplos concretos superam descrições positivas. Um limite de 100 palavras diz mais ao modelo do que "seja conciso".

## Padrões de alta alavancagem

### 1. Restrições negativas
**O quê:** Dizer o que o output NÃO deve ser/incluir.
**Por quê funciona:** Elimina padrões aprendidos do treinamento (jargão corporativo, "in today's fast-paced world", LinkedIn guru tone).
**Exemplo:**
```
Does NOT sound like: generic AI, corporate jargon, LinkedIn influencer
Does NOT include: filler phrases, unnecessary caveats
```

### 2. Exemplo de voz própria
**O quê:** Colar uma amostra do próprio estilo de escrita.
**Por quê funciona:** Ensina o modelo sua voz melhor que qualquer descrição. Ver **Voice Cloner** (prompt #07).
**Aplicação:** Criar um "Voice Profile" uma vez, salvar como arquivo de contexto, referenciar em toda sessão de escrita.

### 3. "Do NOT hedge. Pick one and defend it."
**O quê:** Instrução explícita para dar recomendação, não análise balanceada.
**Por quê funciona:** Sem essa instrução, o modelo lista prós/contras de tudo sem concluir nada. Com ela, produz uma posição defensável.
**Uso:** Decision Matrix, qualquer análise estratégica.

### 4. Limites de comprimento como restrição de qualidade
**O quê:** Limite de palavras específico (100 palavras para cold email, 800 para proposta).
**Por quê funciona:** Força o modelo a cortar o supérfluo. O corte revela o essencial.
**Regra:** Quanto mais curto o limite, mais forçado é o foco.

### 5. Duas versões de output
**O quê:** Pedir o mesmo conteúdo em formato executivo (30s) e detalhado (5min).
**Por quê funciona:** Serve dois públicos diferentes sem dois prompts. O resumo também valida o entendimento.
**Uso:** Data Explainer, qualquer análise técnica.

### 6. Premissas ocultas
**O quê:** Após listar premissas explícitas, pedir que o modelo identifique premissas que o usuário NÃO listou.
**Por quê funciona:** As premissas mais perigosas são as que não reconhecemos como premissas.
**Uso:** Assumption Destroyer, Pre-Mortem, qualquer decisão estratégica.

### 7. "Sounds like X vs Does NOT sound like X"
**O quê:** Dar um contraste claro de persona de escrita.
**Por quê funciona:** Âncoras negativas são mais precisas que âncoras positivas para estilo.
**Exemplo:** "Sounds like: a smart person who noticed something relevant. Does NOT sound like: a sales pitch."

### 8. Inversão (Reverse Brainstorm)
**O quê:** Perguntar como garantir o fracasso antes de perguntar como alcançar o sucesso.
**Por quê funciona:** Brainstorming direto produz ideias previsíveis. Inverter modos de falha produz estratégias contraintuitivas genuínas.

### 9. Perspectivas múltiplas sem resolver tensões
**O quê:** Pedir análise de N perspectivas distintas e instrução explícita de NÃO resolver tensões artificialmente.
**Por quê funciona:** Decisões reais têm trade-offs reais. Suavizar a tensão esconde o custo real de cada opção.
**Uso:** Personal Board of Advisors, qualquer decisão com stakeholders em conflito.

### 10. Scope negativo explícito
**O quê:** Em propostas e delegações, listar o que NÃO está incluído.
**Por quê funciona:** O que não está escrito cria expectativas implícitas. Escrever o "não incluído" previne scope creep.

## Os 4 campos que eliminam back-and-forth na delegação

1. **Definição de done** — como parece o resultado finalizado, especificamente
2. **Decision authority** — o que a pessoa pode decidir sozinha vs o que precisa de aprovação
3. **Constraints** — orçamento, prazo, ferramentas, o que evitar
4. **Check-in points** — quando deve atualizar

## Aplicação no vault

O prompt **#24 Second Brain Synthesizer** ("I want emergence, not repetition") descreve exatamente o que este vault faz — transformar notas brutas em insight sintetizado com conexões não óbvias entre temas.

## Padrões adicionais (fonte: Anatoli Kopadze — 18 Steps)

### 17. Especificação de comprimento de output
**O quê:** Instrução de tamanho antes do output ("Answer in 3 sentences", "5 bullet points no explanations", "under 150 words").
**Por quê funciona:** Corta 40–60% do uso de tokens sem perda de valor. Força o modelo a cortar supérfluo antes de escrever.
**Diferença do padrão 4:** O padrão 4 usa limite numérico como restrição de qualidade. Este foca em recorte direto de tokens em qualquer resposta.
**Uso:** Qualquer tarefa onde velocidade e densidade de informação importam mais do que extensão.

### 18. Remoção de preâmbulo via Custom Instructions
**O quê:** Instrução permanente nas Project Instructions para nunca iniciar com afirmações, restatements ou disclaimers.
**Template:**
```
Never start responses with preamble, affirmations, or restatements of my question.
Go directly to the answer.
Do not add a summary at the end unless I specifically ask for one.
No disclaimers unless the topic genuinely requires one.
```
**Por quê funciona:** Elimina overhead estrutural por padrão sem precisar repetir o pedido em cada prompt.

### 19. Style cloning (análise de padrões de escrita)
**O quê:** Fornecer 3–5 amostras de escrita própria; pedir análise de padrões (comprimento de frase, ritmo, vocabulário, abertura/fechamento de parágrafo, o que se evita, formalidade); instrução para replicar estilo exatamente.
**Diferença do padrão 12 (Persona Training):** O padrão 12 usa o conteúdo para reverse-engineer voz. Este especifica *quais dimensões* analisar, tornando a replicação mais precisa.
**Por quê funciona:** Claude reverse-engenharia voz de forma mais fiel quando as dimensões de análise são explícitas.
**Uso:** Qualquer escrita que precisa soar como o usuário, não como um assistente corporativo.

### 20. Metaprompting ("Claude writes prompts for Claude")
**O quê:** Pedir ao Claude que escreva o melhor prompt possível para uma tarefa (incluindo role, contexto, formato, restrições) e depois use esse prompt imediatamente.
**Template:**
```
I need Claude to help me [describe task].
Write me the best possible prompt for this task.
Include role, context, format instructions, and any constraints that would improve the output.
Then use that prompt immediately.
```
**Por quê funciona:** Claude tem conhecimento interno sobre quais instruções produzem melhores resultados. Metaprompting externaliza esse conhecimento para o benefício do usuário.
**Uso:** Tarefas novas onde o usuário não sabe como estruturar o prompt ideal.

### 21. Feynman via analogias (explicação por domínios conhecidos)
**O quê:** Pedir explicação *somente* por analogias e exemplos cotidianos, sem jargão; após cada analogia Claude verifica compreensão com uma pergunta; continuar até o usuário conseguir explicar de volta sem termos técnicos.
**Por quê funciona:** Força compreensão real — não definição. Explicações que usam o mesmo vocabulário do conceito não constroem entendimento.
**Uso:** Qualquer conceito técnico novo — de investimentos a física quântica a APIs específicas.

### 22. Stress-test de ideia (análise adversarial de negócio)
**O quê:** Análise estruturada em 5 dimensões: (1) premissas erradas, (2) concorrentes existentes e por que o usuário perderia, (3) por que o cliente-alvo não pagaria, (4) o que precisaria ser verdade para funcionar, (5) o único maior problema. Depois: o que a ideia precisaria para realmente funcionar.
**Por quê funciona:** Combina ataque adversarial com reconstrução construtiva. Evita que o usuário se apaixone pela ideia antes de testá-la.
**Diferença do padrão 6 (Premissas ocultas):** Este vai além de premissas — inclui análise competitiva e viabilidade de demanda.
**Uso:** Qualquer ideia de negócio, produto, ou estratégia antes de investir tempo significativo.

### 23. Sparring partner mode (ataque + steelman + opinião real)
**O quê:** Pedir ao Claude para destruir um plano (encontrar toda premissa errada, argumentar o lado oposto com força máxima, sem qualificações), depois construir o steelman mais forte possível, e depois dar sua opinião real.
**Diferença do padrão 3 ("Do NOT hedge"):** O padrão 3 elimina análise balanceada para forçar recomendação. Este usa estrutura ataque/defesa/veredicto deliberadamente para stress-test.
**Por quê funciona:** Separar fase de ataque da fase de defesa da fase de opinião real elimina o viés de concordância do modelo e produz análise mais honesta.
**Uso:** Decisões importantes, planos de negócio, estratégias onde o custo de estar errado é alto.

## Padrões adicionais (fonte: CyrilXBT — 30 Days)

### 11. Role Assignment
**O quê:** Todo prompt começa com papel específico + anos de experiência + domínio.
**Por quê funciona:** Ativa heurísticas específicas do treinamento; melhora output em ~40%.
`"You are a senior content strategist with 10 years in crypto media."`

### 12. Persona Training
**O quê:** Colar conteúdo próprio e pedir replicação de estilo com análise explícita.
**Por quê funciona:** Claude reverse-engenharia voz melhor do que qualquer descrição verbal.

### 13. System Builder
**O quê:** Construir prompt template para tarefas recorrentes com input/output definidos.
**Por quê funciona:** Elimina inconsistência causada por re-prompt diferente a cada vez.

### 14. Failure Debug
**O quê:** Quando falhar, pedir explicação + informação faltante + reescrita + prompt revisado.
**Por quê funciona:** Transforma falha em aprendizado sistêmico; o prompt melhorado previne recorrência.

### 15. /goal Mega Prompt — 10 Operating Rules
**O quê:** Template estruturado para execução autônoma zero hand-holding: CONTEXT + SUCCESS CRITERIA (todos devem ser verdadeiros) + 10 regras não-negociáveis + QUALITY BAR + FINAL DELIVERABLE.
**10 regras core:** plan first, work autonomously, self-verify, debug yourself, use every tool, no placeholders, progress log, stay on goal, if blocked continue in parallel, check success before stopping.
**Por quê funciona:** Converte prompt em contrato explícito. Agente se auto-avalia antes de parar.

### 16. 8-Component Prompt Anatomy
**O quê:** Task → Context Files → Reference (+ blueprint Always/Never por reverse-engineering) → Success Brief (tipo, reação, o que NÃO soar, definição de sucesso) → Rules → Conversation (AskUserQuestion) → Plan (top 3 regras + max 5 passos) → Alignment.
**Por quê funciona:** Cada componente remove uma categoria de falha. Alinhamento antes = zero retrabalho.

## Fontes
- [[03-RESOURCES/sources/guides-courses-howtos/25-claude-prompts-15-hours-week]] — 25 prompts com "why it works" por prompt
- [[03-RESOURCES/sources/guides-courses-howtos/25-claude-prompts-15-hours-week]] — versão v2 do mesmo autor com variações e novos prompts
- [[03-RESOURCES/sources/guides-courses-howtos/claude-power-user-30-days]] — 5 prompts fundamentais; Role Assignment, Iteration, Persona Training, System Builder, Failure Debug
- [[03-RESOURCES/sources/guides-courses-howtos/clipping-8-prompts-senior-engineer-auroramartel]] — [[03-RESOURCES/entities/Aurora-Martel]]; Role Assignment aplicado a 8 domínios de engenharia (debug, system design, clean arch, multi-agent UI)
- [[03-RESOURCES/sources/guides-courses-howtos/goal-mega-prompt-template]] — template completo /goal; 10 Operating Rules; QUALITY BAR; zero hand-holding
- [[03-RESOURCES/sources/skills-prompting-mcp/anatomy-claude-prompt-eight-components]] — 8 componentes prompt Opus 4.6+; contrato explícito; Success Brief; Alignment gate
- [[03-RESOURCES/sources/guides-courses-howtos/how-to-actually-use-claude-18-steps]] — [[03-RESOURCES/entities/Anatoli-Kopadze]]; 18 passos; output length spec (40–60% tokens); preamble removal; style cloning; metaprompting; Feynman analogias; stress-test adversarial; sparring partner mode

## Evidências
- **[2026-06-19]** 6 mega prompts testados em produção por um ano (300+ testados) — life audit, daily brief, habit dashboard, content engine, proposal system, second brain — todos com regra explícita de "be honest, challenge me" contra validação acrítica — [[03-RESOURCES/sources/claude-prompts-life-changing]]
- **[2026-06-21]** A maioria dos usuários do Claude nunca configura nada além do prompt — reconstroem o mesmo contexto/instrução em cada chat. O artigo descreve camadas de setup progressivas (preferências de resposta, styles, Projects, Project Instructions... — [[claude-setup-the-ai-skill-most-users-still-ignore-in-2026]]
- **[2026-06-21]** Prompting aleatório com Claude ("explica X") não gera aprendizado retido — falta estrutura, teste, compressão e feedback loop. O artigo apresenta 6 prompts-template que transformam Claude em professor/examinador/curador, cada um suprindo... — [[how-to-learn-anything-10x-faster-using-claude]]
- **[2026-06-21]** Claude é fraco quando recebe só uma frase sem contexto. O ganho de capacidade real vem de uma sequência ordenada de 7 camadas de setup (Projects → working brief estruturado em XML → web search → connectors → subagentes → regras de aprova... — [[how-to-make-claude-100x-more-powerful-7-setup-layers]]

## Perspectivas

- **[2026-06-21]** A progressão 'Project → brief estruturado → search seletivo → connectors com least-privilege' nomeia formalmente uma arquitetura que este vault já implementa via CLAUDE.md + tiers de autonomia + skills — convergência entre prática emergente e desenho já adotado. — [[how-to-make-claude-100x-more-powerful-7-setup-layers]]

## Evolução

- **[2026-06-22]** 8 sources independentes convergem: "loop engineering" sucede prompt engineering — o leverage sobe de escrever melhor prompt para desenhar melhor loop. Ver [[03-RESOURCES/concepts/agent-systems/loop-engineering-patterns]] — conceito irmão que cataloga a camada de prática acima.

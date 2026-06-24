---
title: "Agentic coding and persistent returns to expertise"
type: source
source: "Clippings/CCEconReport-H.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [articles]
---

## Tese central
Relatório da Anthropic (Hitzig, Massenkoff, Lyubich, Heller, McCrory; junho 2026), baseado em análise privacy-preserving de ~400.000 sessões interativas do Claude Code (out/2025–abr/2026, ~235.000 pessoas): há uma divisão de trabalho clara em coding agêntico — pessoas decidem o quê construir, o agente decide como. Expertise de domínio (não proficiência em programação) amplifica o uso efetivo da ferramenta: quem entende melhor o problema tem mais sucesso e se recupera melhor de erros, mas o gap entre intermediário e expert é modesto — competência basta para captar a maior parte do ganho.

## Argumentos principais
- Em uma sessão típica, pessoas tomam ~70% das decisões de planejamento (o quê fazer) mas só ~20% das decisões de execução (como fazer) — Claude faz o resto. Quando o usuário mantém controle de execução (>80% das decisões), Claude toma menos ações por turno (~8); quando Claude controla o planejamento (>80%), toma o maior número de ações (~16).
- Expertise (escala de 5 pontos, novato a expert, medida por classificador a partir de precisão das instruções, o que o usuário pede para verificar, e quem corrige quem) é *task-specific*, não cargo: um engenheiro senior fazendo sua primeira pergunta em Rust é novato em Rust; um contador que nunca usou Python mas sabe exatamente quais regras de reconciliação aplicar é expert naquela tarefa.
- A composição do trabalho mudou substancialmente em 7 meses: sessões gastando tempo corrigindo código quebrado cairam de 33% para 19%; em seu lugar, cresceu "operar software" (14%→21%) e "escrever e analisar dados" (dobrou, ~10%→20%).
- O valor econômico estimado da sessão típica (comparado a postagens de freelancer) subiu ~25-27% entre outubro e abril; building, operating e fixing cresceram em valor por ~32-43%.
- A maior parte do ganho de sucesso vem de mover de novato para intermediário — o salto de intermediário para expert é menor.

## Key insights
- Nove "work modes" classificam as sessões: building, fixing, testing, orchestrating (4 modos de código direto); operar software (deploy, configurar, monitorar); entender sistema existente; planejar mudança; analisar dados; comunicar via prosa/apresentações. ~56% das sessões são escrever (25%) + corrigir (26%) + testar/orquestrar (5%); operar = 17%; planejar/explorar = 14%; análise/prosa = 13%.
- 48% das sessões modificam código existente, 17% exploram código, 14% criam código do zero; ~1/5 não toca codebase nenhum.
- Medidas de sucesso usam dois classificadores complementares: *judged success* (leu a transcrição inteira e decidiu se a pessoa conseguiu o que queria: succeeded/partially/failed/no clear goal) e *verified success* (exige judged success + ao menos um sinal forte verificável — commits/PRs correspondentes, testes passando, afirmação explícita do usuário).
- Sessão novata atinge verified success 15% das vezes e ao menos parcial 77%; sessão intermediária ou acima atinge verified success 28-33% e parcial 91-92%.
- Entre sessões que "encontram problema" (failure signal ≥3), a fração que ainda chega a verified success sobe de 4% (novato) para 15% (expert) — controlando por modo de trabalho, valor da tarefa, mês, assunto e tipo de usuário.
- Sessão é "abandonada" se julgada falha E zero linhas de código escritas: 19% das sessões de novato terminam abandonadas, contra 5-7% para todos os outros — "os usuários menos experientes desistem mais quando estão tendo dificuldade."
- Engenheiros de software atingem verified success em ~30% das sessões; outras profissões, ~26% — gap pequeno de 5 pontos, estável ao longo de 7 meses. Em sessões que produzem código, as dez maiores ocupações ficam todas dentro de sete pontos percentuais dos engenheiros de software. Ocupações de management são as mais altas em verified success, ligeiramente acima de engenharia de software.
- Novatos geram ~5 ações e ~600 palavras de output por prompt; experts geram cadeias de ação mais que o dobro (12 ações) carregando cinco vezes o output (3200 palavras) — esse gap aparece em todo tipo de trabalho e faixa de valor de tarefa.

## Exemplos e evidências
- Metodologia: classificador lê a transcrição da sessão e checa contra telemetria automática (ex: linhas de código adicionadas/removidas); >90% de acordo entre as duas fontes para sessões classificadas como criação/modificação de código.
- Ocupação inferida via mapeamento para 23 grupos da taxonomia SOC (Bureau of Labor Statistics) do Census americano, usando apenas sinais do contexto do projeto, nomes/estrutura de arquivos, artefatos referenciados (filings legais, dados clínicos, relatórios financeiros) e vocabulário — explicitamente instruído a não tratar "estar codando" como evidência de profissão de programador.
- Exemplo dado: sessão em que um advogado constrói um script para flagar cláusulas faltantes em contratos é mapeada para Legal Occupations, mesmo que o trabalho da sessão seja majoritariamente software.
- Ocupação foi inferível em ~70% das sessões; maiores grupos depois de "Computer and Mathematical": Business and Financial Operations, Arts/Design/Media, Management, Life/Physical/Social Sciences. Grupos não-software de crescimento mais rápido: management, vendas, legal.
- Limitações reconhecidas pelos autores: não observam resultados reais no mundo (se o código foi de fato usado ou descartado); excluem uso não-interativo (headless/`claude -p`), que é parcela substancial de uso; classificadores dependem da leitura de um modelo da transcrição e são difíceis de validar em escala.

## Implicações para o vault
Dado quantitativo de primeira mão (relatório oficial Anthropic, não opinião de terceiros) que valida empiricamente o padrão "researcher decide o quê, agente decide como" já discutido conceitualmente em fontes do cluster `ai-agents-harness/`. A descoberta de que expertise de domínio (não proficiência em código) é o que mais prediz sucesso reforça a tese de que o valor de agentes está em amplificar conhecimento de domínio existente, não substituí-lo — relevante para qualquer discussão sobre quem se beneficia mais de Claude Code dentro do contexto FIAP/concurso do usuário (ex: como aplicar agentes de estudo).

## Links
- [[03-RESOURCES/entities/anthropic]]
- [[03-RESOURCES/entities/Claude Code]]

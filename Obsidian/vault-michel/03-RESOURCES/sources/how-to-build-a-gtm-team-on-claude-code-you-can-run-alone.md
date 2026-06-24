---
title: How to Build a GTM Team on Claude Code You Can Run Alone
type: source
source: "Clippings/How to Build a GTM Team on Claude Code You Can Run Alone.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [articles]
---

## Tese central
O trabalho real de um time de GTM (go-to-market) nunca foi o envio de mensagens — foi o julgamento: qual empresa merece uma mensagem essa semana, o que dizer que prova que você notou, qual no-show perseguir. Esse julgamento, que antes exigia um time, agora pode ser executado de ponta a ponta por uma pessoa mais Claude Code, com cinco "seats" (agentes) rodando sobre uma memória compartilhada.

## Argumentos principais
- Reformulação central: pare de pensar em headcount, pense em jobs. Um time de GTM é uma lista de jobs, e a maioria tem a mesma forma: ler uma pilha de dados, tomar uma decisão, escrever algo, fazer follow-up, lembrar o que aconteceu. Cada job vira um agente, todos compartilham uma memória, e o time inteiro roda de uma única linha de cron às 8h da manhã.
- **Os cinco seats**:
  1. **Prospector** — decide quem merece uma mensagem. Observa quatro tipos de movimento: vaga aberta/republicada, empresa engajando concorrente ou postando sobre o problema que você resolve, empresa lançando/expandindo/mudando de stack, dinheiro se movendo (rodada/aquisição). Pontua cada sinal contra o ICP e o histórico completo da conta, depois redige a partir do próprio gatilho. Regra inviolável: citar a coisa que se moveu ("Saw you reposted the Head of RevOps role, second ops hire this quarter") — nunca "Hi {{firstName}}". Se a mensagem poderia ter saído sem mudança no mês passado, o gatilho foi ignorado e a conta espera.
  2. **Researcher** — escreve um briefing de uma página para cada call agendada, puxando da mesma memória do prospector: o que se moveu, o que já foi enviado e como reagiu, a melhor coisa para abrir a conversa. Toda linha fundamentada no histórico real, nunca inventada.
  3. **Sequencer** — faz a cobrança automática que humanos são piores em fazer (follow-up depende de lembrar de fazer follow-up; humanos esquecem, hesitam, fazem uma vez e param). O agente decide quem e escreve o primeiro toque; uma ferramenta de sequência (Overloop AI) carrega o resto num cronograma, por e-mail e LinkedIn.
  4. **Recoverer** — recupera no-shows com sequência de quatro toques ao longo de uma semana, dois canais, sem culpa em nenhum: 1h após o miss (link de reagendamento de dois cliques), dia seguinte (mesma oferta no LinkedIn), dia 3 (algo útil ligado à indústria, sem pedido), dia 7 (última chamada simples). Resultado declarado: recupera cerca de um terço dos no-shows que antes simplesmente desapareciam.
  5. **Reporter** — monta o relatório semanal toda sexta sem ser solicitado, a partir da mesma memória, e faz o que um relatório humano nunca faz: avalia as próprias jogadas, repesando os quatro buckets de sinal pela taxa de conversão (reunião pesa mais que resposta, com piso para nenhum bucket cair a zero) — o relatório deixa de ser registro da semana passada e passa a calibrar a próxima.
- A peça que torna cinco agentes um time, não cinco scripts isolados: **uma única memória compartilhada** — um registro por conta que todo seat lê e escreve. O prospector loga um toque na segunda; o sequencer lê na quinta, vê ausência de resposta, manda o próximo passo; o reporter conta na sexta e repesa os buckets. "Mesmo registro, uma fonte de verdade." Construir esse store primeiro e manter os nomes de método estáveis é o que permite cada seat se apoiar nele em vez de adivinhar.
- Operação humana: você não opera o sistema, você o edita — um trabalho menor e muito diferente. O time roda em cron antes de você acordar; ao sentar, o standup espera no Slack: quem contatar hoje e por quê, briefing para cada call do calendário, no-shows sendo perseguidos, números da semana passada repesados pelo que de fato converteu. Dois minutos: aprovar, editar ou matar.
- Custo operacional total declarado: ~$400/mês em tokens para rodar o "departamento" inteiro.
- Onde humanos ainda vencem: os agentes decidem quem contatar e escrevem a primeira linha — eles não fecham, e não constroem o relacionamento que faz um comprador escolher você um ano depois, quando o orçamento finalmente chega. Quando uma resposta volta com uma pergunta real, uma hesitação, um "não estamos certos se isso é pra nós" — isso é conversa humana e deve continuar sendo.

## Key insights
- Os dois prompts que rodam todo dia (não os scripts de build, que rodam uma vez) carregam o julgamento e a voz do sistema, em arquivos simples, não enterrados em código: o prompt de scoring do prospector (escala 0-100, com regra "se o sinal for fraco ou off-ICP, pontue baixo e pule — dizer não é parte do trabalho") e o prompt de redação (abrir a primeira frase no gatilho, nunca "Hi {{firstName}}", fechar com um pedido de baixa fricção).
- O autor é explícito sobre origem: "este é um build funcional, não a stack interna que rodamos na Sortlist. O seat do prospector é o gtm-brain do último drop. Isto é o time em torno dele" — reconhecendo que o artigo empacota e generaliza algo já testado internamente em produção.
- Repositório completo oferecido (`gtm-team/`) com estrutura: `team/` (prospector, researcher, sequencer, recoverer, reporter), `core/` (memory, models, adapters, llm), `prompts/` (judge, draft, brief, report), `config/` (icp, sequences, signals, team), `run.py` (o standup matinal).

## Exemplos e evidências
- Prompts de build literais fornecidos para cada um dos cinco seats (`team/prospector.py`, `team/researcher.py`, `team/sequencer.py`, `team/recoverer.py`, `team/reporter.py`), cada um especificando assinatura de função e comportamento esperado.
- Prompt completo do "judgment layer" do prospector com sistema de scoring de 4 faixas (80-100 / 50-79 / 20-49 / 0-19) e regra de "under 7 days since last touch, prefer nurture or skip, never first_touch".
- Prompt completo de redação da mensagem de abertura, com regras de tom (frases simples, comprimento variado, sem urgência falsa, sem em dashes, sem buzzwords).
- Produto comercial citado como alternativa "com as costuras escondidas": MAX (`yourmax.ai`), mesma ideia rodada como serviço gerenciado pela Sortlist.

## Implicações para o vault
Forma um par natural com "GTM Engineering, Chapter Two" (mesmo batch): ambos descrevem a mesma tese (Claude Code como superfície de controle para um "departamento" de GTM autônomo rodando sobre memória/grafo compartilhado), mas com fornecedores e granularidade diferentes — aqui cinco seats concretos com prompts publicados (Sortlist/MAX), lá um harness mais arquitetural com subagentes e MCP (Day AI). Reforça `[[03-RESOURCES/concepts/agent-systems/ai-agents-negocios]]` com um segundo exemplo de "agent ownership accountability" implícito (cada seat tem job e prompt próprios, mas a fonte de verdade é o registro compartilhado por conta, análogo ao "context graph" do artigo irmão). Também conecta com `[[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]` e `[[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]` (memória compartilhada como mecanismo de coordenação, mesmo padrão visto em outras sources deste batch).

## Links
- [[03-RESOURCES/concepts/agent-systems/ai-agents-negocios]]
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]]
- [[03-RESOURCES/concepts/agent-systems/handoff-file-pattern]]
- [[03-RESOURCES/entities/Claude Code]]

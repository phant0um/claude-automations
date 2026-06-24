---
title: GTM Engineering, Chapter Two
type: source
source: "Clippings/GTM Engineering, Chapter Two.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [articles]
---

## Tese central
O "Capítulo Um" do GTM Engineering (era Clay) foi enriquecimento de dados hands-on, projeto por projeto. O "Capítulo Dois" é automação que roda sem o operador estar no teclado, orquestrada a partir de um harness de Claude Code que vira a superfície de controle de todo o go-to-market — transformando o conhecimento tácito do melhor vendedor em configuração replicável para toda a equipe.

## Argumentos principais
- Clay criou a profissão "GTM Engineer" (GTME): antes não existia título nem trilha de carreira para quem sabia escrever script e cruzar datasets dentro do time de vendas.
- Markdown é um ótimo substrato para *intenção* (plano, estratégia) — é diffable, revisável, versionável em git — mas é um substrato terrível para o *registro do que realmente aconteceu* (CRM, histórico de conversas). Tentar manter o estado real do negócio em arquivos = manter um banco de dados à mão em prosa, que fica obsoleto no instante em que você para de digitar.
- O problema de fundo é de "shape": um CRM relacional (linhas, schema fixo) é a forma errada de entregar a um modelo de fronteira. O que o modelo quer é um grafo navegável — pessoa → empresa → deal → toda conversa — com **provenance** (por que esse campo tem esse valor, qual a fonte), **permissions** (o que o agente pode ver, em nome de quem) e **fontes primárias em linguagem natural** ao lado dos números estruturados.
- Esse grafo é chamado de "context graph" pela indústria — categoria genuinamente difícil (comparada a alunissagem por causa de privacidade/permissões reais), praticamente sem fornecedores que entregaram (autor cita apenas a Day AI, empresa do próprio autor).
- A arquitetura recomendada roda em três planos: (1) repo git privado = fonte de verdade autorada (plano, iniciativas); (2) Day AI Pages = espelho legível publicado para a empresa; (3) workspace Day AI = superfície de execução viva (membros, agentes, skills).
- Unidade de trabalho não é "mega-agente": é uma iniciativa (`initiatives/<slug>.md`) com dono, critério de sucesso verificável e ciclo de vida NEW → IN_PROGRESS → PAUSED → CANCELLED → SUCCEEDED.
- Três subagentes fazem o trabalho pesado: `gtm-strategist` (mantém camada de planejamento, entrevista o operador), `agent-implementor` (lê o plano, audita o workspace, cria/atualiza agentes via MCP), `data-analyst` (recomenda, nunca executa — analisa valor real dos agentes via histórico de execução, não config).
- Decisão de design central: **todo agente pertence a um humano específico**. Sem isso ninguém responde pelo output, ninguém é responsabilizado, e trabalho que não pertence a alguém não muda nada. Baseline: pelo menos dois agentes por vendedor ativo (um agente só é um chat; dois é começar a delegar função real).
- Os dois arquétipos de agente para vendedores: "CRM Data Nerd" (mantém oportunidades/notas/contexto correto e completo a partir do que realmente aconteceu nas conversas) e "Coach" (analisa padrões de deals, prepara antes de reuniões, redige follow-ups).
- Comandos do loop operacional: `/start`, `/plan`, `/agent-audit`, `/audit`, `/design-agent`, `/implement` (sempre faz preview antes de tocar workspace ao vivo).

## Key insights
- O conhecimento tácito de um top performer ("ela sabe o momento certo de mencionar o produto, com o framing certo") historicamente vivia só na cabeça da pessoa e saía da empresa quando ela saía. Em Chapter Two, isso se torna configuração: vira comportamento codificado que se propaga para a frota inteira de agentes, medido contra critérios de sucesso da iniciativa.
- Onde gastar tokens caros (modelos de raciocínio profundo): perguntas de nível de CEO — qual iniciativa está realmente funcionando, onde plano e realidade divergiram, o que o melhor vendedor sabe que a frota ainda não sabe. Tarefas triviais (redigir e-mail) são "problema resolvido" em modelos baratos — usar modelo caro nelas é como "contratar um grande mestre de xadrez para organizar sua estante por ordem alfabética".
- A categoria de CRM monolítico está se fragmentando em peças que um agente realmente precisa: orquestração de agentes (já existe, vários entrantes reais), context graph (a peça difícil, ainda quase ninguém entregou), e a "superfície de trabalho GTM" com qualidade Cursor onde o vendedor de fato passa o dia (ninguém construiu ainda).
- Accountability é o que torna o sistema real em vez de demo — sem ela, ninguém responde pelo output do agente.

## Exemplos e evidências
- Exemplo de uso concreto: empresa lança segundo produto, liderança quer attach rate. Em vez de esperar o próximo sales kickoff e torcer, o operador cria `initiatives/attach-rate-q3.md`, ajusta os agentes de todos os vendedores para trazer o novo produto na conversa no momento certo, fundamentado no context graph compartilhado. Três semanas depois, identifica-se que uma vendedora específica está "dobrando a curva" de attach rate; o padrão dela (perfil de cliente, momento da call, framing) é extraído e configurado para toda a frota.
- Foundation Capital chamou o context graph de "trillion-dollar opportunity" da IA; Satya Nadella circulou o artigo.
- Ferramenta concreta liberada: GTM Brain (template GitHub) em `github.com/day-ai/gtm-brain` — clique em "Use this template", torne privado, adicione operadores, abra no Claude Code, aprove o MCP server `day-ai`, digite `/start`.
- Day AI SDK público disponível em `github.com/day-ai/day-ai-sdk` para o skill `/build-app` (UI/automação externa).
- Autor trabalhou 10 anos na HubSpot construindo a resposta anterior para "onde vive o registro do cliente" — usa isso como credencial para a tese do context graph.

## Implicações para o vault
Confirma e estende `[[03-RESOURCES/concepts/pkm-obsidian/company-brain]]`: aqui aparece a articulação mais precisa do motivo pelo qual markdown/git resolve a camada de *intenção* mas não a camada de *registro factual em tempo real* — um argumento que pode refinar a distinção dentro desse concept entre "planning layer" (arquivos) e "context graph" (sistema vivo com provenance/permissions). Também adiciona um caso concreto de "agent ownership accountability" (todo agente pertence a um humano) que conecta com `[[03-RESOURCES/concepts/agent-systems/ai-agents-negocios]]` — útil para comparar com o framework de 5 agentes (seats) em "How to Build a GTM Team on Claude Code You Can Run Alone", do mesmo batch, que aplica a mesma lógica de "harness como superfície de controle" em outro fornecedor (Sortlist/MAX em vez de Day AI).

## Links
- [[03-RESOURCES/concepts/pkm-obsidian/company-brain]]
- [[03-RESOURCES/concepts/agent-systems/ai-agents-negocios]]
- [[03-RESOURCES/concepts/agent-systems/agentic-sdlc]]
- [[03-RESOURCES/entities/Claude Code]]

## Minha Síntese

**O que muda:** Reforça que arquivos markdown/git (a abordagem que uso no vault) são corretos para a camada de *intenção/plano*, mas insuficientes como registro vivo de eventos — uma distinção que vale aplicar ao desenhar qualquer sistema de "second brain operacional" e não só de conhecimento estático.

**Conexão pessoal:** O padrão "todo agente pertence a um humano específico, mínimo dois agentes por pessoa para virar delegação real" é diretamente análogo ao desenho dos meus próprios agentes em `04-SYSTEM/agents/` — cada agente do vault já tem dono/escopo definido, o que valida a arquitetura atual.

**Próximo passo:** Nenhum próximo passo imediato (não há contexto de GTM/vendas ativo no momento que justifique adotar o harness Day AI).

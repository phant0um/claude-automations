---
title: "How to Review AI-Generated Code Like a Senior Developer"
type: source
source: "Clippings/How to Review AI-Generated Code Like a Senior Developer.md"
created: 2026-06-19
ingested: 2026-06-21
tags: [ai-agents, claude-code-tooling]
---

## Tese central
Código gerado por IA pode rodar e parecer limpo enquanto não é seguro de fato — estudo 2026 achou apenas ~35% de código backend gerado por IA seguro E correto; teste da Veracode em 100+ modelos achou que quase metade do código gerado embarca vulnerabilidade de segurança conhecida, sem parecer quebrado. Revisar código de IA é skill distinta de escrevê-lo, com ordem própria de verificação.

## Argumentos principais
- 3 fatos sobre IA que explicam todos os hábitos de revisão recomendados: (1) o modelo é otimizado para dar resposta crível rapidamente — "crível" e "correto" coincidem na maior parte do tempo, o que torna o gap perigoso porque você deixa de esperar por ele; (2) quando o pedido deixa lacuna, o modelo não pergunta — preenche com o que era mais comum nos dados de treino (framework popular, estrutura padrão), independente de se aplicar à situação; (3) o modelo soa igualmente confiante errado ou certo — não há "tell", então não se pode confiar na confiança do modelo como sinal de correção.
- **Passo 1 — comece pelo problema, não pelo código**: IA pode resolver o problema errado perfeitamente (ex.: "endpoint para atualizar invoices" sem checar se quem chama tem permissão) — sem confirmar o requisito primeiro, você revisa e aprova código bem escrito que responde a pergunta errada.
- **Passo 2 — questione decisões de engenharia**: o modelo geralmente pula a comparação de opções e usa o default comum (ex.: Django) mesmo quando o formato da tarefa pede outra coisa (ex.: serviço assíncrono de alta concorrência pede algo async-first).

## Key insights
- "O modelo preenche lacunas com o padrão mais comum dos dados de treino, não com o que sua situação pede" é risco direto e generalizável para qualquer página deste vault gerada via prompt curto — reforça por que este próprio pipeline usa template estruturado (F2.3a) em vez de prompt livre, reduzindo a superfície de "lacuna preenchida com default genérico".
- "Comece pelo problema, não pelo código" é diretamente aplicável a qualquer revisão futura de specs de agente (`04-SYSTEM/agents/`): confirmar o requisito antes de avaliar se a implementação está bem escrita.

## Exemplos e evidências
- Estudo 2026 (~35% código backend seguro+correto); teste Veracode (100+ modelos, 80 tarefas, quase metade com vulnerabilidade conhecida); exemplo Django vs FastAPI para serviço de alta concorrência.

## Implicações para o vault
Reforça a prática já adotada neste pipeline de usar template estruturado e checar links/wikilinks antes de marcar uma página como concluída (Karpathy Principle 4, "verificar antes de concluir") — sem mudança de processo necessária.

## Links
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
- [[04-SYSTEM/agents/core/verify]]

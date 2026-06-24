---
title: "Revolut Built a Foundation Model for Money"
type: source
source: "Clippings/Revolut Built a Foundation Model for Money.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [ai-agents]
---

## Tese central

A indústria financeira entrou silenciosamente na era dos foundation models proprietários: nos últimos 12 meses, Revolut (PRAGMA), Nubank (nuFormer) e Mastercard (LTM) treinaram modelos de fundação sobre eventos transacionais em escala (24–100+ bilhões de eventos), substituindo baterias de modelos de ML customizados por um único modelo pré-treinado. O autor argumenta que isto é um "momento BERT" para fintech — útil mas ainda não generativo — e que o vencedor da próxima década será definido por quem converte dados + modelo em vantagem competitiva real (crédito, fraude, marketing), não por quem tem o maior balanço.

## Argumentos principais

- **Dois caminhos de adoção**: (1) treinar foundation model do zero sobre dados proprietários (Revolut/PRAGMA, Nubank/nuFormer, Mastercard/LTM) ou (2) fine-tuning de modelo open-weight existente (NPCI fine-tunou Mistral 24B para UPI Help com 400M+ usuários; PayPal fine-tunou Llama 3.1 Nemotron Nano 8B em duas semanas, ganhando 49% velocidade e 45% redução de custo).
- **PRAGMA não é um LLM** — não gera texto/imagem, não compete com Claude/ChatGPT. Opera sobre eventos de cliente (logins, taps, pagamentos) ao longo do tempo; tokenização de texto destruiria a estrutura numérica/temporal dos dados.
- **Metodologia de validação em 3 experimentos**: (1) usar embeddings pré-treinados sozinhos — mede quanta informação já existe sem nenhuma tarefa definida; (2) embeddings + features hand-crafted da equipe de data science — mede o que o foundation model captura que os features antigos não pegavam; (3) fine-tuning via LoRA sobre outcomes financeiros — testa se o modelo pré-treinado supera anos de trabalho da equipe "com um clique".
- **Resultado**: em geral, sim, o foundation model supera os modelos de ML especializados construídos ao longo de anos.
- **Falha publicada com transparência**: PRAGMA teve desempenho 47% pior que o sistema de produção em anti-lavagem de dinheiro (AML), porque AML é um problema de rede (quem transaciona com quem), e PRAGMA lê o histórico de cada usuário isoladamente, sem ver a cadeia. O autor nota que isso é uma limitação do dataset de treino, não do tipo de modelo.
- **Framework de 4 camadas de vantagem competitiva em IA** (do Fintech Brainfood): Talento (uma sala, uma arquitetura), Dados, Modelo, Workflow em torno do modelo. Cada camada compounda a anterior — e o workflow (orquestração, roteamento de ferramentas, harnesses de avaliação, guardrails, prompts que encodam a "opinião de produto") é o mais difícil de copiar.
- **Por que neobanks chegaram primeiro**: (1) capacidade de mover rápido + stack tecnológica moderna já pronta para experimentação (vs. bancos tradicionais que levariam meses só para localizar e limpar dados); (2) disponibilidade de modelos open-weight competentes e baratos (Qwen, Kimi, GLM) treináveis em GPUs alugadas em semanas.
- **Tese de "thin moat shift"**: bancos não estão sendo disruptados — os moats regulatórios, de crédito e de balanço continuam reais — mas quem ganha a próxima década é quem atualiza o IP dentro do moat. A IP de bancos (como precificar e gerenciar risco) estava em planilhas e nas cabeças de underwriters; Revolut moveu isso para um modelo.
- **3 caminhos estratégicos para bancos**: construir modelo próprio (exige dataset massivo + capacidade de treino), colaborar com outros players (core processor, consórcios, vendors como Sardine ou FICO que têm dados em escala), ou comprar modelo de um vendor com dataset grande.

## Key insights

- Treino é custo único; inferência é para sempre — por isso a NVIDIA ajuda bancos a treinar a baixo custo, porque o que ela realmente quer é o volume de inferência recorrente (fraude em cada transação, crédito em cada aplicação, personalização em cada sessão).
- Scaling laws aplicam-se a eventos bancários do mesmo jeito que a tokens de texto: mais parâmetros, melhor performance (modelo de 10M parâmetros é bom, o de 1B é melhor).
- A vantagem real de PayPal não foi só fine-tunar um modelo — foi construir um sistema multi-agente em torno dele (agentes para reasoning, checkout, fraude), tornando o modelo fine-tunado apenas um componente do produto.
- PRAGMA é descrito como equivalente ao "BERT de 2020" para banking: lê histórico e preenche lacunas (prediz risco de crédito, fraude, churn, lifetime value). A versão "GPT" — geração do próximo capítulo da vida financeira do cliente, permitindo simular decisões futuras e "rebobinar a fita" para engenharia de eventos — ainda não existe.

## Exemplos e evidências

- PRAGMA (Revolut + NVIDIA): 26M clientes, 24 bilhões de eventos, 207 bilhões de tokens gerados; treino do modelo de 1B parâmetros em ~32 H100s, ~2 semanas.
- Uplifts publicados vs. modelos de ML em produção: credit scoring +130% PR-AUC; fraud recall +65%; marketing engagement +79%; product recommendation +40%; AML −47% (falha admitida).
- Estimativa de impacto financeiro: aplicando apenas 10% do ganho de credit scoring ao book de cartões do JPMorgan Chase (custo de crédito ~US$10bi/ano, charge-offs anualizados ~US$8bi+) já resultaria em centenas de milhões de dólares/ano. Fraude: cada US$1 perdido em fraude gera mais US$5,75 em custo operacional, então mesmo ganhos modestos em recall escalam para dezenas de milhões.
- nuFormer (Nubank): 100+ bilhões de transações, 100M+ clientes — mais estreito por caso de uso, mais "GPT-like" como arquitetura.
- NVIDIA fornece duas pilhas: (1) construção de foundation model — silício (H100, Blackwell), bibliotecas de dados (cuDF), framework de treino (NeMo AutoModel); (2) fine-tuning — modelo base (Nemotron) + framework (NeMo) + runtime de inferência (TensorRT-LLM).

## Implicações para o vault

Confirma o padrão já registrado em [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]] e [[03-RESOURCES/concepts/ai-strategy-org/ai-organizational-moat]]: a vantagem competitiva sustentável em IA está deslocando-se do modelo (commoditizado) para o workflow/orquestração em torno dele — eco direto do argumento central de [[03-RESOURCES/concepts/ai-strategy-org/talent-density-as-strategy]] e da tese de moat organizacional. Relevante para o domínio finance-trading do vault como referência de como IA está reestruturando crédito/fraude/risco no setor bancário, fora do escopo de LLMs de texto.

## Links

- [[03-RESOURCES/concepts/ai-strategy-org/ai-organizational-moat]]
- [[03-RESOURCES/concepts/agent-systems/agent-tool-surface-hierarchy]]
- [[03-RESOURCES/concepts/finance-trading/_index]]

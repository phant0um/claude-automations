---
title: "Workflows are King"
type: source
source: "Clippings/Workflows are King.md"
created: 2026-06-19
ingested: 2026-06-19
tags: [articles]
---

## Tese central
A sabedoria convencional do SaaS dizia que o moat estava no "sistema de registro" (quem controla os dados); na verdade o moat sempre foi os centenas de workflows que extraíam dados desse sistema e faziam o trabalho. No mundo de agentes de IA, esse moat sobe uma camada: não é mais sobre onde os dados ficam, é sobre onde o trabalho é orquestrado.

## Argumentos principais
- No SaaS, trocar de "sistema de registro" era quase impossível não por causa dos dados em si, mas porque significava reconstruir/verificar/testar/proteger TODOS os workflows que tocavam aquele sistema — muitos no caminho crítico ou voltados ao cliente. O custo dessa mudança quase sempre superava o valor de trocar de plataforma.
- No mundo agentic, os workflows continuam existindo, mas se tornam dinâmicos em vez de estáticos (como eram no SaaS). Isso move o moat/ancoragem para uma camada acima: não é mais "onde os dados residem" (workflows tocando dados), é "onde o trabalho é orquestrado".
- A conclusão prática para fundadores **não** é tentar construir a camada de orquestração desde o início — essa não foi a jogada dos sistemas de registro também. Salesforce não nasceu como a plataforma que mil workflows tocavam; comeceu estreito/nichado, dominou um único caso de uso, ficou muito bom nisso, e expandiu lentamente.
- A jogada agentic equivalente: escolher um único workflow (idealmente algo que pareça "prestes a ser comoditizado" mas que vai se tornar mais importante no futuro — pegar a onda certa), fazer isso muito melhor que qualquer um, e ser subestimado por isso.
- Esse workflow único vira "real estate estratégico": constrói-se outros workflows adjacentes em torno dele, depois lentamente a camada de orquestração (o que gerencia, roteia e governa os agentes que fazem o trabalho) cresce ao redor de tudo.
- "Startups não são estáticas" — o que você faz hoje não é a única coisa que você fará. Você expande, vai mais a fundo em certas áreas. O que importa é que o ponto de partida seja real estate estratégico sobre o qual se pode construir, ganhando o direito de "gerenciar" (orquestrar) todos esses workflows/agentes depois.
- O estado final é um novo tipo de "sistema de registro": no SaaS, o banco de dados guardava dados e o moat se formava em torno dele via workflows; no mundo agentic, o "banco de dados" do mundo SaaS se torna os próprios workflows — e a empresa que possui onde esses workflows são orquestrados é quem possui o próximo moat.

## Key insights
- A intuição errada ao ler isso é pensar "então devo construir a camada de orquestração desde o dia 1" — o autor explicitamente refuta essa leitura, porque não foi assim que nenhum sistema de registro venceu historicamente.
- O paralelo com "se tornar o Clearinghouse" (artigo anterior do mesmo autor, citado mas não detalhado) reforça que o tema recorrente da tese é: quem coordena o fluxo de trabalho entre sistemas vence, não quem armazena os dados.

## Exemplos e evidências
- Caso histórico citado: Salesforce como exemplo de sistema de registro que começou nichado e expandiu via workflows ao redor de si.
- Artigo original publicado na newsletter "Clouded Judgement" (Jamin Ball), 19/06/2026.

## Implicações para o vault
- Conecta diretamente com `ai-organizational-moat` (já catalogado) — esta fonte é evidência concreta e argumentativa para esse conceito, reforçando a tese de que moat em IA = camada de orquestração, não dados brutos.
- Relaciona-se com `system-of-intelligence`: o artigo sugere que o "sistema de registro" tradicional está sendo substituído por um "sistema de orquestração de workflows" — vale conectar/comparar os dois conceitos no vault.
- Tem implicação estratégica direta para quem está construindo agentes/sistemas (como o próprio sistema Nexus do vault-michel): a lição é não tentar construir uma camada de orquestração genérica primeiro, e sim dominar um workflow específico e expandir a partir dele.

## Links
- [[03-RESOURCES/concepts/ai-strategy-org/ai-organizational-moat]]
- [[03-RESOURCES/concepts/ai-strategy-org/system-of-intelligence]]
- [[03-RESOURCES/concepts/agent-systems/agent-orchestration]]

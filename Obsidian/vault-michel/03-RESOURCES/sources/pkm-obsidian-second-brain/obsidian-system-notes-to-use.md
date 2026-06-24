---
title: "How to Build an Obsidian System That Turns Every Note You Take Into Something You Actually Use"
type: source
source: "Clippings/How to Build an Obsidian System That Turns Every Note You Take Into Something You Actually Use.md"
original_url: "https://x.com/cyrilXBT/status/2060163007783612502"
author: "@cyrilXBT"
published: 2026-05-28
created: 2026-05-29
ingested: 2026-05-29
tags: [articles, pkm, obsidian, note-taking, synthesis, output, claude-integration]
---

## Tese central

A maioria dos sistemas de note-taking otimiza para captura, ignorando completamente o uso. O gap entre capturar e usar é o gap entre coleção passiva e síntese ativa. Este guia propõe um sistema de três zonas (Capture → Active → Archive) com cinco workflows Claude orientados a output, medido pela única métrica que importa: quantas vezes uma nota contribuiu para algo.

## Argumentos principais

- **O problema não é a informação, é o design:** notas nunca são usadas não porque eram inúteis, mas porque o sistema foi construído para captura, não para produção. Capturar é fácil (sem stakes). Usar exige recuperação ativa + síntese + transformação em output.
- **Quatro tipos de uso legítimo de uma nota:** (1) suporte a decisão, (2) combustível para escrita, (3) material de conversa/apresentação, (4) gatilho de ação. Notas que não se encaixam em nenhuma das quatro não deveriam estar no vault.
- **Arquitetura de três zonas:**
  - **Zona 1 (Capture):** material bruto, candidatos para utilidade, ainda não processados.
  - **Zona 2 (Active):** notas permanentes em suas próprias palavras, conectadas a trabalho ativo e projetos correntes. Estas são úteis *agora*.
  - **Zona 3 (Archive):** projetos concluídos, decisões resolvidas, registros históricos. Potencialmente úteis no futuro, indexadas para recuperação mas não mantidas ativamente.
- **O Output folder como inovação crítica:** a maioria dos sistemas de notas não inclui. Ele cria conexão visível entre notas capturadas e trabalho produzido, revelando quais notas foram generativas e quais nunca foram usadas.
- **A única métrica que importa:** número de vezes que uma nota contribuiu para algo — não número total de notas. 500 notas que contribuíram cada uma > 5.000 notas nunca usadas.
- **O sistema aprende o que é útil para você:** em 6 meses, o Output folder mostra quais notas foram generativas, informando como capturar no futuro. Calibração emergente.

## Key insights

- **"Capturar e usar são duas atividades completamente diferentes"** — a maioria dos sistemas otimiza para a primeira, ignorando a segunda. Essa assimetria é a causa raiz de vaults que acumulam sem retorno.
- **CLAUDE.md como definição de utilidade:** o documento deve responder "o que útil significa *para você especificamente*" — projetos ativos, decisões em curso, tópicos de escrita. Claude lê isso antes de processar qualquer nota.
- **Nota em Zona 2 tem quatro pré-requisitos:** (1) escrita em suas próprias palavras, não copiada da fonte; (2) conectada a pelo menos uma outra nota na Zona 2; (3) pode contribuir para pelo menos um projeto ou decisão ativa; (4) título descreve a ideia, não a fonte.
- **Workflow 2 (Active Decision Feeder):** quando trabalhando em uma decisão, Claude varre toda a Zona 2 buscando notas relevantes — não apenas as explicitamente tagueadas, mas qualquer nota que uma pessoa cuidadosa consideraria. Não usa informação de fora do vault. Só sintetiza o que já está nas notas.
- **Workflow 4 (Connection Surface):** uma vez por semana, varre notas criadas nos últimos 7 dias buscando conexões com notas mais antigas. Foca em conexões genuinamente não-óbvias: mesmo princípio em domínios diferentes, claims contraditórias que merecem comparação, padrões que cruzam múltiplas notas que nenhuma nota individual nomeia. Esse workflow é o que faz o vault *compor*.
- **The Connection Capture (30 segundos extras):** ao capturar, registrar "CONNECTS TO: [o que isso lembra ou relaciona]" e "MIGHT USE FOR: [primeiro caso de uso que vem à mente]". Preserva o contexto de relevância presente no momento da captura — que é temporário e se perde.
- **The Question Capture:** quando uma nota levanta uma pergunta, capturar a pergunta explicitamente. Perguntas são frequentemente mais úteis que respostas num sistema de conhecimento.
- **The Application Capture:** "[A ideia] COULD APPLY TO: [situação específica no seu trabalho atual] | ACTION IF TRUE: [o que fazer se a ideia estiver certa]". Capturas de aplicação são as mais propensas a gerar uso real.
- **Weekly Note Audit:** notas na Zona 2 não acessadas em 14 dias recebem um check. Conectadas a algo ativo? Adicionar link. Não conectadas? Flag REVIEW. Após dois audits consecutivos sem conexão: arquivar. Isso força o princípio — notas desconectadas não são atualmente úteis.

## Exemplos e evidências

- Progressão temporal documentada:
  - Semana 1: vault estruturado com 5 workflows + CLAUDE.md. Outputs produzidos mas poucas conexões surpresa.
  - Mês 2: Connection Surface começa a gerar links genuinamente úteis entre tópicos não intencionalmente relacionados. Writing Activator produz briefs com material esquecido.
  - Mês 3: Decision Feeder se torna o workflow mais valioso. Claude encontra 8 notas de 3 meses de captura, de diferentes contextos e semanas, todas relevantes para uma decisão em curso.
  - Mês 6: Output folder com peças suficientes para ver quais notas foram generativas. Atualiza convenções de captura com base nos dados.

## Implicações para o vault

- **Zona/estrutura:** o vault-michel já implementa captura em `00-INBOX/`, ativo em `03-RESOURCES/` e arquivo em `08-ARCHIVE/`. A lógica de três zonas é equivalente — mas o critério de mover entre zonas (conectividade, contribuição ativa) pode ser formalizado melhor.
- **Output folder ausente:** o vault não tem um equivalente explícito de `03-OUTPUT/` que rastreie peças produzidas a partir de notas. Adicionar `06-GENERATED/` como output explícito (já existe) com link para fontes que contribuíram seria o equivalente.
- **Métrica de contribuição:** o vault não rastreia explicitamente quantas vezes uma nota foi referenciada/contribuiu. Seria um enhancement — mas Dataview poderia fazer `backlinks count` como proxy.
- **Weekly Note Audit:** a lógica do audit (notas desconectadas → archive) é compatível com o `drift-review` skill já no vault. Pode ser integrada.
- **Connection Capture convention:** os três campos (idea, connects to, might use for) poderiam ser adicionados ao template de captura do vault para preservar contexto de relevância.

## Links

- [[03-RESOURCES/concepts/pkm-obsidian/second-brain]]
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]
- [[03-RESOURCES/concepts/pkm-obsidian/self-writing-vault]]
- [[03-RESOURCES/concepts/pkm-obsidian/life-operating-system]]
- [[03-RESOURCES/entities/CyrilXBT]]

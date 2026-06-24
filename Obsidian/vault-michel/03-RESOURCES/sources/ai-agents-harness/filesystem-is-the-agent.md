---
title: "The file system is the agent"
type: source
source: "Clippings/The file system is the agent.md"
created: 2026-06-10
ingested: 2026-06-10
tags: [ai-agents, agent-systems, virtual-filesystem, archil]
---

## Tese central

O file system está deixando de ser uma camada de armazenamento passiva (pense XFS/ZFS) para se tornar o serviço central que o agente consome via APIs (getFile, writeFile, searchFiles, runContainer). Levado ao limite, o file system não é só onde o agente guarda contexto — ele **se torna o agente**: harness, histórico de conversa, conexões com sistemas de registro e o próprio código de execução viram apenas dados persistidos nele.

## Argumentos principais

### Sandboxes como anti-padrão emergente

- A previsão do autor (Hunter Leath, Archil): file systems passam de "bibliotecas de armazenamento" para "serviços oferecidos a agentes como tools".
- Se o file system já exporta `getFile`, `writeFile`, `searchFiles`, `runContainer` como tools consumíveis por qualquer framework de IA, ele **elimina a necessidade de sandboxes separados** — porque já contém os primitivos para rodar código não confiável e mostrar os mesmos dados de forma consistente (ex.: numa UI web).
- Problema de pensar em "sandbox provider" como peça separada do stack:
  1. Vira recurso a gerenciar explicitamente (quando subir/derrubar na conversa?)
  2. Vira uma "ilha de dados" nova — é preciso se preocupar em mover dados para dentro/fora dela.

### O problema remanescente: onde roda o invocador?

- Mesmo com "Serverless Execution" (rodar Bash nos servidores onde o storage vive), falta responder: **onde roda o sistema que invoca esses comandos?** O agente roda em Render? Exe.dev? Outro provider de sandbox?
- Para responder isso, o autor conversou com times construindo os melhores agentes (Clay, Browserbase, Wordware) sobre o que eles realmente fazem.

### Anatomia de um agente (visão tradicional)

1. **Contexto**: definir a que dados/fontes o agente tem acesso (S3, Salesforce, etc.) — agentes são o primeiro tipo de aplicação que precisa de acesso amplo a fontes heterogêneas para sintetizar insights entre elas.
2. **Sandbox**: primitivo que **manipula** esse contexto — executar comandos Linux para extrair informação (fatiar/processar antes de mostrar ao modelo) ou editar (ex.: rodar `sed` sobre arquivos visíveis).
3. **Agent loop**: o que dirige o sandbox e manipula o contexto — chama o LLM repetidamente perguntando qual manipulação fazer a seguir.
4. **Trigger**: algo precisa disparar o agent loop — mensagem em chat, iMessage, timer, webhook.

- Predição dos times entrevistados: eventos **disparados pelo sistema** (alarmes Datadog, e-mails recebidos, updates de LinkedIn, handoff entre agentes) vão superar em volume eventos disparados por usuário (ex.: mensagens Slack).
- Essa arquitetura completa exige: lugar para rodar o agent loop + sandbox provider + cópia do contexto para dentro do sandbox + sistema de trigger + desligar tudo quando ocioso (para não gerar custo). Complexidade tolerável hoje (startups de SV que gostam de montar infra), mas hostil para adoção corporativa em escala.

### O agente serverless ideal

- Solução proposta: arquitetura colapsada em torno do file system/contexto persistente.
- Contexto = "workspace" que o agente descobre iterativamente — papel que o file system **já cumpre hoje** com agentes.
- Serverless execution permite ao harness do agente subir múltiplos containers Linux concorrentes de forma isolada, sem afetar o harness.
- O harness em si não precisa de servidor long-running: pode ser função serverless (1 turno e sai) ou "fluid compute" (roda até ociosidade e desliga). Webhook de rede automático conecta o agente.
- Como o file system/contexto é persistente, ele guarda histórico de conversa e prompts — qualquer "restart" do harness retoma exatamente de onde o usuário parou, sem gerenciar estado separadamente.

## Key insights

- **O componente-chave** é uma camada de storage que: (1) acompanha o volume de interações de agentes, (2) roda código por conta própria sem serviço externo, (3) sincroniza de forma transparente com sistemas de registro.
- Insight central do autor: assim como "executáveis são apenas dados" foi o unlock para computação genérica, agora **o harness do agente é apenas dados** — pode ser armazenado no file system, junto com o contexto. Histórico de conversa = dado. Conexões com sistemas de registro = dado.
- Archil oferece hoje o "agent toolset" (conjunto mínimo de tools para manipular contexto no file system); a evolução prevista é indicar onde no file system está o código do harness e invocá-lo diretamente — via REST API (integrações) ou webhook (conectar a serviços upstream).
- Predição de mercado: a camada de infraestrutura está colapsando para essa arquitetura única. Times não vão comprar soluções pontuais de 10 providers diferentes para cada parte do stack de agentes — vão consolidar num único serviço que roda todas as partes, ancorado na camada de storage persistente.

## Exemplos e evidências

- Produto citado: [Serverless Execution](https://docs.archil.com/compute/serverless-execution) da Archil — já em uso por times de agentes "overwhelmed" pela complexidade de produção.
- Empresas referenciadas como fonte de pesquisa qualitativa: Clay, Browserbase, Wordware.
- Diagramas (não reproduzidos): (1) arquitetura tradicional com sandbox separado; (2) arquitetura colapsada com file system como contexto + execução + harness.

## Implicacoes para o vault

- Confirma e estende [[03-RESOURCES/concepts/agent-systems/agent-vfs-pattern]] — o VFS Pattern já documenta "unified path tree substitui N SDKs/MCPs"; este artigo vai além, propondo que o **harness inteiro** (não só dados/tools) vira parte do file system.
- Reforça [[03-RESOURCES/concepts/pkm-obsidian/virtual-filesystem-llm]] (justificativa teórica de por que semântica Unix é nativa para LLMs).
- [[03-RESOURCES/entities/Archil]] já estava documentada no vault (mesmo autor/fundador, Hunter Leath @jhleath) com foco em "serverless execution + egress"; este artigo adiciona a tese mais ampla de "file system = agente completo" (harness + contexto + histórico + triggers), útil para futura expansão da entidade.
- Para o vault-michel como "SO completo": a analogia é direta — o vault (file system Obsidian + `.raw/`/`.manifest.json` + agents/) já funciona como "contexto persistente + harness como dados". Esse artigo valida a arquitetura atual (`04-SYSTEM/agents/` como dados versionados no mesmo file system que o conteúdo).

## Links

- [[03-RESOURCES/concepts/agent-systems/agent-vfs-pattern]]
- [[03-RESOURCES/concepts/pkm-obsidian/virtual-filesystem-llm]]
- [[03-RESOURCES/entities/Archil]]

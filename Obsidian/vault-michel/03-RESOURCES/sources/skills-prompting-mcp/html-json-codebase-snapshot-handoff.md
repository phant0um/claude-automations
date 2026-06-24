---
title: Thread: HTML+JSON Codebase Snapshot for Handoff (@so_ainsight)
type: source
source: Clippings/Thread by @so_ainsight on Thread Reader App.md
created: 2026-05-15
ingested: 2026-05-15
tags: [ai-agents]
triagem_score: 7
---

## Tese central
Pedir a Claude para gerar HTML (humano-legível) + JSON (próximo agente) representando o sistema inteiro — handoff sem inferno.

## Key insights
- HTML = mapa visual de módulos e conexões; JSON = dados de design para próxima conversa importar contexto.
- Antes: abrir folder, passar arquivos, explicar do zero. Depois: "cole o JSON" — agente já tem todo contexto.
- Padrão: gerar uma vez, virar ativo compartilhado para discussões futuras de feature/fix.

## Links
- [[03-RESOURCES/concepts/agent-systems/agent-harness]]

---

## Mecanismo Detalhado

### O Problema que Resolve

O handoff entre sessões de agente ou entre agentes diferentes tem um custo de contexto altíssimo. Sem artefato de handoff, cada nova conversa começa do zero: o desenvolvedor precisa explicar a arquitetura, os módulos, as dependências, as decisões já tomadas. Isso desperdiça tokens e tempo humano, e frequentemente resulta em contexto incompleto que causa erros do agente.

O padrão HTML+JSON resolve isso criando um "artefato de conhecimento" do sistema que pode ser injetado diretamente na próxima conversa.

### Estrutura do Artefato HTML

O HTML gerado por este padrão não é documentação para leitura humana casual — é um mapa de módulos e conexões otimizado para compreensão rápida. Estrutura típica:

```
sistema.html
├── Header: nome do projeto, última atualização
├── Módulos (cards): nome, responsabilidade, interfaces exportadas
├── Grafo de dependências: quem depende de quem
├── Decisões de design: ADRs resumidos
└── Estado atual: o que está implementado vs pendente
```

O humano usa o HTML para navegar visualmente. O agente usa o JSON equivalente para importar o contexto programaticamente.

### Estrutura do JSON de Contexto

```json
{
  "project": "nome-do-projeto",
  "snapshot_date": "2026-05-15",
  "modules": [
    {
      "name": "auth",
      "responsibility": "JWT + session management",
      "exports": ["validateToken", "createSession"],
      "depends_on": ["db", "cache"],
      "status": "complete"
    }
  ],
  "design_decisions": [
    {
      "id": "ADR-001",
      "decision": "JWT stateless vs session DB",
      "chosen": "JWT stateless",
      "rationale": "escala horizontal sem sticky sessions"
    }
  ],
  "open_questions": [],
  "next_steps": ["implementar refresh token rotation"]
}
```

Quando o agente recebe este JSON, tem contexto suficiente para continuar de onde parou sem re-explorar o codebase inteiro.

---

## Workflow de Uso Prático

**Geração:** ao final de uma sessão de desenvolvimento significativa, peça ao agente:
> "Gere um snapshot HTML+JSON desta arquitetura cobrindo módulos, dependências, decisões tomadas, e próximos passos."

**Armazenamento:** salve como `docs/context/snapshot-YYYY-MM-DD.json` e `docs/context/snapshot.html`. O JSON é o que importa para automação; o HTML é para revisão humana.

**Uso na próxima sessão:** cole o JSON no início da nova conversa:
> "Contexto do projeto: [JSON]. Continue a partir dos próximos passos listados."

**Atualização incremental:** não precisa regenerar do zero. Peça ao agente para atualizar apenas os campos que mudaram desde o último snapshot.

---

## Comparação com Alternativas

| Abordagem | Custo de Handoff | Qualidade de Contexto | Manutenção |
|---|---|---|---|
| Explicação verbal | Alto (tempo humano) | Baixa (incompleto) | Nenhuma |
| README longo | Médio | Média (desatualiza) | Alta |
| Snapshot HTML+JSON | Baixo (cola JSON) | Alta (completo) | Automática via agente |
| CONTEXT.md (ADR) | Baixo | Alta | Média (manual) |

O snapshot HTML+JSON combina o melhor dos dois mundos: rico como um README bem mantido, mas gerado e atualizado pelo próprio agente. O CONTEXT.md é complementar — mais focado em terminologia de domínio, menos em estado atual.

---

## Aplicação no Vault-Michel

Este padrão é diretamente aplicável ao vault como "snapshot do sistema de agentes". Um arquivo `.raw/agents-snapshot.json` poderia conter:
- Lista de todos os agentes ativos com responsabilidades
- Dependências entre agentes (quem chama quem)
- Estado do workflow de ingest (último batch, pendências)
- Decisões de arquitetura do vault (por que kebab-case, por que `04-SYSTEM/`, etc.)

Ao iniciar uma sessão complexa de reestruturação, injetar esse JSON no contexto do agente elimina a fase de "descoberta" e permite começar diretamente na execução.

Relevância imediata: o `04-SYSTEM/AGENTS.md` atual cumpre parte dessa função, mas não tem estrutura JSON legível por agente. Um JSON parallel ao AGENTS.md seria o upgrade natural.

---

## Limitações

- O snapshot fica desatualizado se o agente não for chamado para atualizá-lo regularmente. Requer disciplina ou hook automatizado pós-sessão.
- JSON de contexto muito grande (>50KB) pode consumir tokens significativos na abertura da conversa — comprima ou pagine por módulo.
- Não substitui testes: o contexto diz o que o sistema deveria fazer, não comprova que faz. Um snapshot desatualizado com bugs não detectados é pior que nenhum snapshot.

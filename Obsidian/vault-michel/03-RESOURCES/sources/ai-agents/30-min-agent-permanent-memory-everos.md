---
title: "30 分钟给你的 Agent 搭好永久记忆：能 cat 能 git 能直接编辑"
type: source
source: "Clippings/30 分钟给你的 Agent 搭好永久记忆：能 cat 能 git 能直接编辑，保姆级教程零门槛上手.md"
created: 2026-06-23
updated: 2026-06-23
score: A
tags: [ai-agents, source-page, agent-memory, everos, persistent-memory, markdown-memory, local-first]
---

## Tese Central

Agents (OpenClaw, Hermes, Claude Code, Codex) não precisam de context windows maiores — precisam de melhor memória. O artigo apresenta um tutorial de 30 minutos para conectar memória persistente a um coding agent usando EverOS, um sistema operacional de memória open-source local-first. A chave: a memória é armazenada como Markdown que você pode abrir, ler, editar, e versionar com Git — transparente, não uma caixa preta de vetores.

## Por que EverOS e não um vector DB próprio

A maioria das soluções de memória é uma caixa preta: você alimenta texto, ele devolve vetores e scores de similaridade. Quando algo dá errado, você não sabe o que ele "lembrou" ou por quê.

**EverOS usa três componentes locais:**

| Componente | Função |
|---|---|
| Markdown | Única fonte de verdade — .md legível, grep-able, Git-versionable, Obsidian-openable |
| SQLite | Estado e fila de processamento |
| LanceDB | Vetores, BM25 full-text index, filtros escalares |

**Quer saber o que o agent lembrou? `cat` no arquivo. Quer corrigir uma memória errada? Abre no editor e edita.** Esta inspecionabilidade é impossível em vector DBs caixa preta.

Benchmarks oficiais: LoCoMo 93.05%, LongMemEval(-S) 83.00%, HaluMem ~90%+.

**O cérebro do seu Agent é um monte de arquivos que você pode abrir.**

## Setup Passo a Passo

### Passo 1: Ambiente (5 min)
- Python 3.10+ (recomendado 3.12+), `uv` como package manager
- Dois API keys: OpenRouter (LLM/multimodal) e DeepInfra (embedding/rerank)
- Compatível com qualquer endpoint OpenAI (OpenAI, vLLM, Ollama)

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

### Passo 2: Instalação (5 min)
```bash
# Source install
git clone https://github.com/EverMind-AI/EverOS.git
cd EverOS
uv sync
source .venv/bin/activate

# OU pip install
uv pip install everos

# Init
everos init
```

⚠️ **.env contém seus keys — adicione ao .gitignore antes de commitar.**

### Passo 3: Start service (3 min)
```bash
everos server start
# Health check em novo terminal:
curl http://127.0.0.1:8000/health
# {"status":"ok"}
```

### Passo 4: Core loop — escrever e buscar memória (8 min) ⭐
```bash
# Escrever fato
everos memory add --user-id alice "Alice prefere TypeScript, odeia any"

# Buscar (pode ser "outro dia", outra sessão)
everos memory search --user-id alice "Alice escreve código com quais preferências?"
```

Por trás: extração de memória estruturada → Markdown em disco → sync com SQLite e LanceDB. Busca híbrida: BM25 (keywords) + vector ANN (semântica) + scalar filter (user_id).

### Passo 5: Abrir a caixa preta (5 min) ⭐
```
~/.everos/
└── default_app/
    └── default_project/
        ├── users/alice/
        │   ├── user.md          # Perfil da Alice (visível)
        │   ├── episodes/        # Logs episódicos por dia (visível)
        │   ├── .atomic_facts/   # Fatos atômicos (hidden)
        │   └── .foresights/     # Memórias preditivas (hidden)
        └── agents/<agent_id>/
            ├── agent.md
            └── .cases/          # Casos do agent
```

Pode abrir com Obsidian e navegar a memória do agent como uma knowledge base visual.

**Dual-track memory:** users/ (perfil e preferências do usuário) e agents/ (casos e skills do agent) — extraídos separadamente, sem poluição cruzada.

## Capacidades Adicionais

- **Multimodal ingestion:** PDF, imagem, documento, tabela, URL em uma API call (Office docs precisa de LibreOffice)
- **Self-evolution:** tasks completadas viram Cases; padrões recorrentes viram Skills compartilhadas entre agentes
- **Roadmap:** Knowledge Wiki (memória fragmentada → wiki versionável) e Reflection (idle: conectar weak signals, comprimir histórico, melhorar perfil)

## Armadilhas Comuns

1. **Tutoriais desatualizados:** muitos "tutoriais EverOS" ensinam a versão pesada antiga (docker-compose com MongoDB, Elasticsearch, Redis). A versão 1.0.0 leve NÃO precisa disso. Comando certo: `everos init` / `everos server start`.
2. Office docs precisa de LibreOffice instalado
3. `.env` deve ir para `.gitignore`

## Key Insights

- Agents não precisam de context windows maiores — precisam de melhor memória
- Memória como Markdown = transparência total: cat, edit, grep, Git, Obsidian
- "Markdown as single source of truth" significa que a memória é sua, não de uma caixa preta
- Dual-track memory: usuário (perfil/preferências) vs agent (casos/skills) — separados, sem poluição
- Busca híbrida (BM25 + vector + scalar filter) permite mudar a pergunta e ainda recuperar
- EverOS 1.0.0 leve elimina a necessidade de MongoDB/Elasticsearch/Redis
- Self-evolution: Cases → Skills sem intervenção manual

## Links

- [[03-RESOURCES/concepts/ai-agents/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/context-management]]
- [[03-RESOURCES/concepts/llm-ml-foundations/context-engineering]]
- [[03-RESOURCES/concepts/pkm-obsidian/self-improving-vault]]
- [[03-RESOURCES/concepts/pkm-obsidian/pkm-obsidian]]

## Minha Síntese

**O que muda:** A ideia de que a memória do agent é um monte de Markdown que você pode abrir, editar e versionar muda completamente a relação com sistemas de memória. Em vez de confiar cegamente em scores de similaridade de vector DBs, você tem transparência total. O parallel com Obsidian é direto — a memória do agent é essencialmente um segundo cérebro para o agent.

**Conexão pessoal:** O vault-michel já opera como segundo cérebro em Markdown com Git. EverOS usa exatamente o mesmo princípio mas para memória de agent. A dual-track memory (users/ e agents/) é uma estrutura que poderia informar a organização do vault. A capacidade de abrir com Obsidian e visualizar é exatamente como o vault já funciona.

**Próximo passo:** Avaliar EverOS como camada de memória persistente para o Hermes Agent. A transparência via Markdown alinha com a filosofia do vault. Testar o core loop (write → search) em um projeto pequeno para validar se a busca híbrida funciona bem para o tipo de conhecimento do vault.
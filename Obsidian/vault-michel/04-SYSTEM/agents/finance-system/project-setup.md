# Finance System — Claude Project Setup

## Estratégia de Projects

Dois projetos recomendados:

| Project | System prompt | Uso |
|---------|--------------|-----|
| **Finance — Análise** | `Nexo.md` (roteia para especialista na conversa) | Análise de ativos, meta, cripto |
| **Finance — Portfólio** | `Fluxo.md` ou `Quant.md` | Acompanhamento da carteira atual |

> Alternativa: um único Project com `Nexo.md` como system prompt e os 5 agentes especialistas como docs — Nexo instrui a atuar como o especialista correto conforme o roteamento.

## System prompt principal
Copiar o conteúdo de `00-SYSTEM-PROMPTS/Nexo.md`.

Para sessões especializadas, substituir pelo agente específico:
- Fundamentalista: `Valor.md`
- ETF/FII: `Fluxo.md`
- Macro: `Macro.md`
- Quant: `Quant.md`
- Cripto: `Cripto.md`

## Documentos para upload

### Contexto pessoal (atualizar trimestralmente)
- Composição atual da carteira (% por ativo/classe)
- Watchlist de ativos em análise
- Histórico de aportes (se quiser análise de custo médio)

### Referência fixa
- `skills/tax-rules-br.md` — regras de IR por classe de ativo
- `skills/disclaimer.md` — aviso regulatório
- `docs/progress.md` — histórico de análises e decisões

### Dados externos (copiar/colar quando relevante)
- Extrato da corretora
- Relatórios trimestrais de empresas analisadas
- Dados macro do BCB/IBGE quando pedidos

## Fluxo de atualização
1. Editar agente no vault
2. Substituir system prompt no Project
3. Atualizar `docs/progress.md` após análises relevantes
4. Commit no vault

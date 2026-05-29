---
name: portfolio-state
type: skill
version: 1.0.0
used-by: [nexo]
---

# Portfolio State — Protocolo de Estado Visível de Sessão

Skill usada por Nexo para manter estado explícito da sessão financeira, evitando context rot em sessões longas.

## Quando ativar

A partir do 2º turno de qualquer sessão do Finance System.

## Bloco de Estado

Incluir no início de toda resposta de Nexo após o 1º turno:

```
> Sessão Finance:
> Ativos discutidos: [TICKER — veredicto 3 palavras | nenhum]
> Regime macro: [Expansão | Late-Cycle | Recessão | Recuperação | não classificado]
> Perfil inferido: [conservador | moderado | arrojado | não declarado]
> Horizonte declarado: [curto | médio | longo | não declarado]
> Objetivo declarado: [crescimento | renda | proteção | diversificação | não declarado]
> Especialistas acionados: [lista | nenhum]
```

## Protocolo de Compactação

Ativar quando: 8+ ativos discutidos OU 15+ turnos na sessão.

**Formato compactado:**
```
[COMPACTADO] TICKER — tese 5 palavras — veredicto
```

**Exemplo:**
```
[COMPACTADO] WEGE3 — crescimento energia renovável ROIC alto — bull moderado
[COMPACTADO] BOVA11 — exposição B3 diversificada barata — neutro
```

**Aviso ao usuário quando compactar:**
> "Contexto compactado para manter desempenho da sessão. Histórico completo disponível em docs/progress.md."

## Persistência

- Estado de sessão: memória ativa da conversa atual
- Estado persistente: `docs/progress.md` (escrito por todos os agentes ao finalizar)
- Ao reabrir sessão: usuário deve reintroduzir portfólio atual e objetivo — estado não persiste entre sessões automaticamente

## Regras

- Veredicto deve ser exatamente 3 palavras (ex: "bull longo prazo", "neutro risco elevado")
- Regime macro: atualizar sempre que Macro for acionado
- Perfil/horizonte/objetivo: inferir do comportamento do usuário, não apenas de declaração explícita
- Nunca omitir o bloco de estado a partir do 2º turno — é proteção contra context rot

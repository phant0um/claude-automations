# Marketing System — Claude Project Setup

## System prompt
Copiar `Signal.md` como system prompt padrão.

Signal roteia para o especialista correto. Para sessões dedicadas:

| Sessão | Arquivo |
|--------|---------|
| Estratégia de marca e calendário | `Anchor.md` |
| Posts, threads, roteiros (X, IG, YouTube) | `Vox.md` |
| Edição de foto / plano de filmagem | `Prism.md` |
| Planejamento e copy de site | `Canvas.md` |
| Prompts DALL-E 3 | `Lens.md` |
| Documentos HTML (one-pager, newsletter, landing) | `Folio.md` |

## Documentos para upload

### Fixos (upload uma vez)
- `docs/standards.md` — voz, paleta, tom da marca Michel
- `docs/progress.md` — campanhas ativas, último output, pendências

### Contexto de campanha (upload por ciclo)
- Brief da campanha em andamento
- Posts publicados recentemente (referência de tom)
- Métricas de engajamento (se quiser análise de Anchor)

### Para Folio
- Exemplos de documentos HTML já aprovados (referência de estilo)

### Para Prism
- Foto ou descrição da foto a editar (copiar no chat)
- Locação e condições de luz para plano de vídeo

## Uso típico
- **Vox** — descrever o tema no chat; Vox entrega thread/post pronto
- **Lens** — descrever uso (banner X, story IG, avatar); Lens entrega prompt DALL-E
- **Folio** — especificar modo (one-pager / newsletter / landing) + briefing no chat
- **Signal** — qualquer intenção de marketing; Signal decide o agente

## Fluxo de atualização
1. Editar agente no vault
2. Substituir system prompt no Project
3. Atualizar `docs/progress.md` após cada ciclo de campanha
4. Commit no vault

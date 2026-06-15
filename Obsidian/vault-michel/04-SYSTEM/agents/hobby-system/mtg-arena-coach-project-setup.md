# MTG Arena Coach — Claude Project Setup

## System prompt
Copiar o conteúdo de `standalone/mtg-arena-coach.md` integralmente.

## Documentos para upload

### Meta e sets (atualizar a cada novo set ~3 meses)
- Lista de sets legais no Standard atual (copiar de MTG Arena ou Wizards)
- Bans e suspensões recentes (copiar do anúncio oficial)
- Tier list do meta atual (copiar de fontes como MTGGoldfish, Untapped.gg)

### Coleção pessoal (atualizar conforme aquisições)
- Lista de wildcards disponíveis (R raras / M mythics por cor)
- Decks atuais em uso (listas completas)
- Wishlist de decks a montar

### Referência estável
- Regras de formatos: o que é legal em Historic vs. Standard vs. Brawl

## Uso típico
- **Antes de nova temporada:** atualizar docs com sets legais + bans + tier list
- **Montar deck:** colar wishlist de wildcards como contexto, pedir MODO 1
- **Refinamento:** colar lista atual no chat, pedir MODO 2
- **Matchup coaching:** descrever deck próprio + adversário, pedir MODO 4
- **Carta nova:** colar texto completo da carta (se pós-cutoff), pedir MODO 5

## Fluxo de atualização
1. A cada novo set: atualizar docs de meta no Project
2. Se agente for editado no vault: substituir system prompt no Project

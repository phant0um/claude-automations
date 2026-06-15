---
name: voice-guard
type: skill
version: 1.0.0
used-by:
  - pena
---

# Voice Guard

Skill de preservação de voz do autor. Aplicada automaticamente por Pena antes de qualquer edição de texto.

## Protocolo obrigatório antes de editar

Antes de alterar qualquer palavra, Pena executa:

**Passo 1 — Extração de marcadores de voz (3 obrigatórios)**

1. **Vocabulário preferido** — palavras específicas que o autor usa e que revelam seu estilo (ex: usa "bacana" em vez de "excelente", usa "cara" como vocativo, prefere termos técnicos de TI)
2. **Estrutura de frase** — como o autor constrói frases (curtas e diretas? longas e subordinadas? começa com verbo? usa muito ponto e vírgula?)
3. **Nível de formalidade** — onde cai no espectro: acadêmico / profissional / conversacional / informal / coloquial

**Passo 2 — Registro dos marcadores**

Antes de entregar a edição, Pena lista os marcadores identificados:
> Marcadores de voz identificados:
> - Vocabulário: usa "sacou?", "na real", termos de TI sem traduzir (deploy, stack, pipeline)
> - Estrutura: frases curtas. Ponto final frequente. Sem vírgula onde caberia.
> - Formalidade: conversacional — escreve como fala

## Regra principal

Palavra original > sinônimo mais elegante.

Se o autor escreveu "coisa" e o editor substituiria por "elemento" — mantém "coisa". A voz importa mais do que o polimento.

## Indicador de qualidade

80%+ das palavras originais devem estar presentes na versão editada.

Se uma edição resultar em menos de 80% de palavras originais, Pena alerta:
> "Esta edição modificou mais de 20% das palavras originais. Isso é uma reescrita, não uma edição. Confirma que quer reescrita completa?"

## Preservar mesmo quando "imperfeito"

Exemplos de elementos a preservar mesmo que "incorretos" gramaticalmente ou fora do padrão:
- Uso de primeira pessoa coloquial ("aí eu fui lá e...")
- Frases incompletas usadas intencionalmente para ritmo
- Palavras em inglês que o autor prefere ao termo em português
- Nível de formalidade consistentemente abaixo do acadêmico
- Uso de reticências, travessões ou outros marcadores de estilo pessoal

## Exceções

Erros ortográficos claros (não de estilo) podem ser corrigidos sem aviso.
Ambiguidades que tornam o texto incompreensível podem ser resolvidas, mas o autor é informado.

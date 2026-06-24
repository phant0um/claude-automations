---
title: "設定ファイル(CLAUDE.md)にこの8行を足すだけで、毎回の説明が消えた"
type: source
source: "Clippings/設定ファイル(CLAUDE.md)にこの8行を足すだけで、毎回の説明が消えた.md"
created: 2026-06-21
ingested: 2026-06-21
tags: [ai-agents, claude-code-tooling]
---

## Tese central
Guia (japonês) prático para não-engenheiros: adicionar ~8 linhas ao CLAUDE.md elimina a necessidade de re-explicar preferências (idioma, formato, tom) em toda nova conversa — CLAUDE.md é lido automaticamente como "primeira mensagem" no início de cada sessão; oficialmente recomenda-se manter abaixo de 200 linhas, e o guia demonstra que até 8 linhas já têm efeito significativo.

## Argumentos principais
- Catálogo de 8 categorias úteis para incluir: idioma de resposta; perfil do interlocutor (técnico vs não-técnico); tom/estilo; formato de saída (conclusão primeiro, listas, sem preâmbulo longo); proibições explícitas (não criar arquivo novo sem necessidade, sem emoji); contexto/background do projeto; instruções recorrentes específicas; preferência de comportamento quando em dúvida (oferecer 2 opções em vez de avançar sozinho).
- O que NÃO incluir: generalidades que todos já sabem ("escreva com cuidado"), informação que muda com frequência, explicações longas — desperdiçam espaço finito de atenção do arquivo.
- 3 falhas comuns citadas oficialmente pela documentação: **excesso** (CLAUDE.md inchado faz Claude ignorar até a instrução que realmente importa); **ambiguidade** ("seja natural" não é verificável; "listas, sem emoji" é); **contradição** (regras conflitantes em pontos diferentes do arquivo fazem Claude escolher arbitrariamente qual seguir).
- Critério de decisão para cada linha: "se eu apagar esta linha, Claude vai errar?" — se não, apagar. Mais curto funciona melhor que mais completo.
- `IMPORTANT:` no início de uma instrução aumenta taxa de conformidade (documentado oficialmente); CLAUDE.md global (`~/.claude/CLAUDE.md`) e de projeto (`./CLAUDE.md`) são lidos e somados, não um sobrescrevendo o outro.

## Key insights
- O critério "se eu apagar esta linha, Claude vai errar? Se não, apagar" é teste de auditoria direto e imediatamente aplicável ao próprio `CLAUDE.md` deste vault — relevante o suficiente para sinalizar como candidato de revisão futura (fora do escopo desta ingestão de fontes).
- A confirmação oficial de que CLAUDE.md inchado faz Claude ignorar a instrução mais importante é validação extra (terceira fonte teórica sobre o tema nesta leva, incluindo Intent Engineering e a fonte "coworker" anterior) de por que a feedback memória do usuário já registra limite de 200 linhas como princípio (`feedback_claudemd_limits.md`).
- Uso de `IMPORTANT:` como prefixo para elevar taxa de conformidade é prática já adotada implicitamente neste CLAUDE.md (seção `<!-- [INVARIANT] -->`); confirma que o padrão de marcação está alinhado com documentação oficial.

## Exemplos e evidências
- Exemplo copy-paste de 8 linhas; comparação literal Before/After de uma interação real (explicação de React state); estimativa de tempo economizado (~10min/dia, horas/mês).

## Implicações para o vault
Confirma os princípios já registrados na memória do usuário sobre tamanho de CLAUDE.md (`feedback_claudemd_limits.md`) — nenhuma mudança necessária agora; reforça valor do teste "apagar e ver se quebra" como ferramenta de auditoria futura do CLAUDE.md deste vault, fora do escopo desta ingestão.

## Links
- [[03-RESOURCES/sources/the-intent-engineering-framework-for-ai-agents]]
- [[03-RESOURCES/sources/most-people-use-claude-like-a-chatbox-7-features-make-it-a-coworker]]

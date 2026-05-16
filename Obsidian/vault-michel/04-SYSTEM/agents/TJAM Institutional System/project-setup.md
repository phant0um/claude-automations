# TJAM Institutional System — Claude Project Setup

## System prompt
Copiar o conteúdo do agente conforme o contexto de trabalho do dia:

| Sessão de trabalho | Arquivo para copiar |
|--------------------|-------------------|
| Pareceres e fundamentação jurídica | `juridico/assessor-juridico-administrativo.md` |
| PLS (Plano de Logística Sustentável) | `pls/assessor-pls.md` |
| PCA (Plano de Contratações Anuais) | `pca/assessor-pca.md` |
| Relatórios gerenciais e dados | `dados/analista-de-dados.md` |
| Documentos e comunicações da chefia | `chefia/assistente-de-chefia.md` |

> Um Project por agente, ou um Project único com o agente mais usado como system prompt e os demais como docs de referência.

## Documentos para upload no Project

### Normativos (upload uma vez, ficam disponíveis em todas as sessões)
- Resolução CNJ nº 400/2021 (PLS)
- Lei nº 14.133/2021 (PNCP / PCA)
- Manual de Redação da Presidência da República
- Regimento interno do TJAM (se disponível)
- Modelos de documentos institucionais em uso

### Contexto operacional (atualizar conforme necessário)
- PCA vigente (planilha ou PDF exportado)
- PLS vigente
- Modelos de memorandos, ofícios e portarias já aprovados
- Glossário de siglas internas do TJAM

## Fluxo de atualização
1. Editar o agente no vault (`04-SYSTEM/agents/TJAM Institutional System/`)
2. Abrir o Claude Project correspondente
3. Substituir o system prompt pelo conteúdo atualizado
4. Commit no vault com a alteração

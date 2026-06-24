---
title: "Claude Keeps Breaking Your Code Because You're Missing One File. Here Are the 12 Rules That Fix It."
type: source
source: "Clippings/Claude Keeps Breaking Your Code Because You're Missing One File. Here Are the 12 Rules That Fix It..md"
created: 2026-06-20
ingested: 2026-06-21
tags: [ai-agents, claude-code-tooling]
---

## Tese central
Os 4 princípios originais de Karpathy para CLAUDE.md (Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven Execution — janeiro 2026, popularizados por Forrest Chang) fecham ~40% das falhas de sessões Claude Code não supervisionadas, mas ficaram incompletos: o ecossistema de 2026 roda multi-agente, hooks e skill libraries que os 4 originais não endereçam. O artigo propõe 8 regras adicionais (total 12) para fechar gaps específicos: conflitos entre agentes, cascatas de hooks, conflito de carregamento de skills, e quebras de sessão multi-etapa.

## Argumentos principais
- CLAUDE.md não é prompt nem lista de preferências — é "sistema operacional" para o comportamento do Claude no repo, lido antes de cada sessão.
- Dado oficial da Anthropic citado: compliance ~80% sob 200 linhas; acima de 200 linhas, compliance cai fortemente — confirma o teto de tamanho já adotado neste vault.
- 3 erros comuns: (1) empilhar toda preferência até >4000 tokens (compliance cai a 30%), (2) pular o arquivo e reprompt toda sessão (5x mais tokens, zero consistência), (3) colar template uma vez e nunca atualizar (quebra silenciosamente conforme o codebase muda).
- 4 gaps que os 4 originais não cobrem: agent fights (dois agentes editando os mesmos arquivos sem regra de ownership), hook cascades (hooks disparando em toda tool call, transformando request de 200 tokens em 8000), skill loading conflicts (múltiplas skills com descrições parecidas confundem o dispatcher), multi-step session breaks (refactor de 6 passos falha no passo 4 mas 5 e 6 rodam sobre estado quebrado).
- Regra 5 (do conteúdo capturado): não usar o modelo para trabalho não-linguístico — decisões deterministas (retry logic, thresholds de roteamento, regras de escalonamento, branching por status) pertencem a código determinístico, não a julgamento de LLM.

## Key insights
- O teto de 200 linhas e o dado de compliance 80%→30% confirmam exatamente a prática já registrada em memória do usuário (CLAUDE.md Size Limits: 200 linhas, regras > exemplos, compliance cai além de 14 regras) — fonte externa que corrobora um padrão já em uso neste vault.
- A motivação dos 8 novos princípios (multi-agente, hooks, skills) é estruturalmente o mesmo problema que o `04-SYSTEM/agents/nexus-agent-system/` já resolve via ledger.md, ownership de arquivo por fase, e specs por agente.

## Exemplos e evidências
- Os 4 princípios originais de Karpathy/Forrest Chang citados verbatim (repo GitHub com 120k stars).
- Regra 5 (Do Not Use the Model for Non-Language Work) com exemplos concretos de decisões que devem ser código, não LLM.

## Implicações para o vault
Validação direta da seção `Principles (Karpathy)` já marcada `[INVARIANT]` no CLAUDE.md deste vault — os 4 princípios e o teto de linhas já estão implementados. As 8 regras novas (especialmente agent fights / hook cascades / skill loading conflicts) são candidatas a auditoria futura do `04-SYSTEM/agents/` e `04-SYSTEM/skills/`, caso o vault expanda multi-agente real (Nexus já mitiga parcialmente via ledger + ownership por fase).

## Links
- [[03-RESOURCES/concepts/learning-cognition/karpathy-four-principles]]
- [[03-RESOURCES/concepts/agent-systems/claude-code-agent]]
- [[03-RESOURCES/entities/Claude Code]]

**Nota**: arquivo duplicado byte-idêntico no Clippings (mesma source, dois nomes: com e sem sufixo " 1"). Ambos arquivados; uma única página de conhecimento criada.

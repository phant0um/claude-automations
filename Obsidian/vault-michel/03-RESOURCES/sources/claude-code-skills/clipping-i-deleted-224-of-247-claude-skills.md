---
title: "I Deleted 224 of 247 Claude Skills I Tested"
type: source
source_type: article
author: "Mnilax"
created: 2026-05-06
tags: [claude-code, skills, evaluation, curation]
triagem_score: 8
---

Systematic evaluation of 247 community Claude skills. 224 deleted, 23 kept. 12% of community skills contain malicious code per ECC AgentShield scan. Vetting criteria and taxonomy of skill quality.

## Source

Ingested from: `clippings/I deleted 224 of 247 Claude Skills I tested. Here are the 23 I kept..md`
Ingested: 2026-05-06 (daily scheduled task)

---

## Por que 91% das Skills Foram Deletadas

O artigo parte de uma premissa contraintuitiva: instalar mais skills raramente melhora o sistema. Skills de baixa qualidade degradam performance de duas formas: aumentam o espaço de decisão do agente (mais opções = mais confusão sobre qual usar) e inserem instruções ruins no contexto que competem com instruções boas.

### Problema de Segurança: 12% com Código Malicioso

O dado mais impactante do artigo: de 247 skills testadas, aproximadamente 30 (12%) continham código malicioso detectado pelo ECC AgentShield. Os vetores de ataque encontrados incluíam:

- **Exfiltração de contexto**: skills que, quando ativadas, faziam o agente enviar conteúdo do contexto (incluindo system prompt e conversas) para URLs externas via ferramenta de código
- **Prompt injection**: skills com instruções ocultas em comentários ou strings que redefiniam o comportamento do agente quando o arquivo era lido
- **Dependency poisoning**: skills que instalavam pacotes npm ou pip com nomes similares a pacotes legítimos (typosquatting)

Isso transforma a curadoria de skills de uma questão de qualidade para uma questão de segurança.

### Critérios de Avaliação

O autor desenvolveu uma rubrica de 5 dimensões para avaliar cada skill antes de manter:

**1. Clareza de trigger**: a skill define explicitamente quando deve ser ativada? Skills com triggers vagos ("when helpful") ativam aleatoriamente e corrompem comportamento padrão.

**2. Escopo cirúrgico**: a skill faz exatamente uma coisa? Skills que tentam cobrir múltiplos casos de uso divergem em qualidade conforme os casos se tornam mais específicos.

**3. Sem side effects implícitos**: a skill modifica comportamento fora do seu domínio declarado? (ex: uma skill de "formatação de código" que também altera como o agente responde a perguntas gerais)

**4. Compatibilidade com outras skills**: a skill entra em conflito com instruções do CLAUDE.md ou com outras skills instaladas? Conflitos criam comportamento não-determinístico.

**5. Sem instruções de override**: a skill tenta sobrescrever regras de segurança ou instruções do sistema? Red flag imediata.

### Taxonomia das Skills Deletadas

| Categoria | % do total | Razão principal de deleção |
|---|---|---|
| Qualidade baixa (vagas, sem trigger claro) | 45% | Não ativam corretamente ou ativam errado |
| Redundantes (cobrem o que o modelo já faz) | 28% | Adiciona contexto sem adicionar capacidade |
| Maliciosas / suspeitas | 12% | Detectadas pelo AgentShield ou análise manual |
| Scope excessivo | 10% | Interferem com comportamento padrão |
| Desatualizadas | 5% | Dependem de APIs ou features descontinuadas |

## As 23 Skills Mantidas: Padrões Comuns

O artigo não lista as 23 explicitamente (paywall/thread), mas descreve as características que as distinguem:

- **Trigger preciso e único**: cada skill define exatamente a frase ou condição que a ativa
- **Output formatado e previsível**: o resultado da skill é consistente entre execuções
- **Independente de estado externo**: não dependem de variáveis de ambiente, arquivos locais, ou APIs que podem falhar
- **Composível**: funcionam com outras skills sem conflito
- **Testada em múltiplos codebases**: não são one-trick ponies para um stack específico

## Metodologia de Vetting Recomendada

O autor propõe um processo de 3 etapas antes de instalar qualquer skill da comunidade:

```
1. Scan estático (ECC AgentShield ou equivalente)
   → Rejeita skills com payload malicioso óbvio

2. Revisão manual do SKILL.md
   → Verifica: trigger, escopo, side effects, conflitos

3. Teste em projeto isolado (sandbox)
   → Instala skill em repo de teste, verifica comportamento
   → Confirma que não modifica comportamento em tarefas fora do escopo
```

## Implicações para Design de Skills

A experiência de curadoria de 247 skills revela princípios de design que se aplicam à criação de skills próprias:

- **Menos é mais**: uma skill focada supera uma skill abrangente
- **Trigger é o design**: a maioria das falhas vem de trigger mal definido, não de instrução errada
- **Teste de não-ativação**: verificar que a skill NÃO ativa em casos fora do escopo é tão importante quanto verificar que ativa corretamente
- **Versionamento**: skills mudam com o modelo — uma skill que funcionava com Claude 3.5 pode se comportar diferente com Claude 3.7

## Relevância para o Vault

O vault-michel usa skills curadas (index.md + habilidades específicas). Este artigo fundamenta a política de curadoria: preferir skills internas criadas com critérios conhecidos a skills da comunidade; qualquer skill externa deve passar pelo processo de 3 etapas antes de integração.

## Relações

- [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]] — framework de skills
- [[03-RESOURCES/sources/claude-code-skills/clipping-i-tried-100-claude-code-skills-best-6]] — avaliação complementar (top 6)
- [[03-RESOURCES/concepts/agent-security]] — vetor de ataque via skills
- [[03-RESOURCES/entities/Claude Code]] — plataforma das skills

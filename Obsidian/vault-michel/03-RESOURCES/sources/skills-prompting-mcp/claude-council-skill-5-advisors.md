---
title: "Claude Council Skill — 5-Advisor Decision Framework"
type: source
grade: B
created: 2026-05-29
ingested: 2026-05-29
tags: [ai-agents, skills, decision-making, multi-agent, peer-review]
---

# Claude Council Skill — 5-Advisor Decision Framework

**Origem:** Imagem extraída de post em rede social (HJfzr7yaAAAP20H.jpeg), convertida via pdf2md em 2026-05-29.

## Tese Central

Um único Claude pode simular 5 advisors com perspectivas distintas, fazendo-os debater uma questão, revisar uns aos outros de forma cega, e entregar um veredito final estruturado — aumentando a qualidade de decisão sem exigir múltiplos modelos.

Trigger de ativação: dizer **"council this"** antes da pergunta.

## Argumentos Principais

### Estrutura do processo (4 fases)

1. **Pergunta + contexto** — usuário cola a questão com contexto completo e diz "council this"
2. **5 advisors pesam** — cada advisor responde a partir de uma perspectiva diferente:
   - O que pode falhar?
   - Qual problema estamos realmente resolvendo?
   - Qual upside estamos perdendo?
   - O que faz sentido para uma segunda-feira de manhã?
   - O que você realmente faria?
3. **Peer review cego** — as respostas são anonimizadas e embaralhadas; cada advisor avalia: qual resposta é mais forte? qual tem o maior blind spot? o que todos os 5 perderam?
4. **Veredito final de Claude** — síntese estruturada com: melhor recomendação, maior blind spot, o que todos perderam, próximo passo concreto

### Output

- Veredito principal (estruturado)
- Relatório HTML skimmable
- Transcript completo disponível sob demanda

## Key Insights

- **Anonimização + shuffle elimina viés de posição**: ao misturar as respostas antes da revisão cruzada, nenhum advisor recebe tratamento preferencial por ser "o primeiro a falar"
- **Perspectivas hard-wired**: as 5 perguntas de cada advisor forçam cobertura sistemática (risco, problema real, upside oculto, praticidade, ação concreta) — equivalente a um pré-mortem estruturado em uma única chamada
- **Prompt como harness**: o padrão substitui coordenação de múltiplos modelos por prompt engineering sofisticado em um único contexto — consistente com [[03-RESOURCES/concepts/agent-systems/agentic-skills]] e o padrão skill-as-harness
- **HTML como formato de entrega**: o relatório HTML skimmable é consistente com [[03-RESOURCES/sources/skills-prompting-mcp/claude-code-unreasonable-effectiveness-of-html]] — agents renderizando outputs navegáveis

## Relação com Conceitos Existentes

Este padrão é uma instância de **debate multi-agente internalizado em prompt** (ao contrário de IMAD que internaliza via post-training). Enquanto [[03-RESOURCES/concepts/agent-systems/internalized-multi-agent-debate]] usa SFT+RL para embutir perspectivas múltiplas nos pesos do modelo, o Claude Council Skill usa prompt engineering para obter efeito análogo em runtime — zero fine-tuning necessário.

Ver também:
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]] — skills como padrão de harness
- [[03-RESOURCES/concepts/agent-systems/internalized-multi-agent-debate]] — versão treinada do mesmo fenômeno
- [[03-RESOURCES/concepts/agent-systems/multi-agent-orchestration]] — contexto de múltiplos agentes
- [[03-RESOURCES/concepts/agent-systems/parallel-agent-code-review]] — padrão paralelo de revisão cruzada

## Implicações para o Vault

- Candidato a skill do vault: o trigger "council this" pode ser encapsulado em `04-SYSTEM/agents/skills/claude-council.md` para uso em decisões de arquitetura, priorização e troubleshooting complexo
- Útil para sessões de planejamento no 01-PROJECTS/ onde múltiplas perspectivas são relevantes (ex.: escolha de stack, estratégia de estudo para concurso)
- Contrasta com o padrão de advisor único: [[03-RESOURCES/sources/skills-prompting-mcp/clipping-8-prompts-senior-engineer-auroramartel]] usa roles sequenciais; Council usa paralelismo + revisão cruzada

## Links

- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/internalized-multi-agent-debate]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- Conceito relacionado: [[03-RESOURCES/concepts/agent-systems/parallel-agent-code-review]]
- Fonte relacionada: [[03-RESOURCES/sources/skills-prompting-mcp/clipping-8-prompts-senior-engineer-auroramartel]]

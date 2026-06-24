---
title: "Prompt Engineering"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, claude-code-tooling]
status: developing
---

# Prompt Engineering

A arte de formatar inputs para LLMs de forma a maximizar qualidade, consistência e controle da resposta — diferente de context engineering (Karpathy), que foca em o que está no contexto.

## O que é

Prompt engineering é o conjunto de técnicas para estruturar o texto enviado ao modelo. Foca em **como** instruir, não apenas o quê. Inclui: role prompting, formato de output, exemplos, chain-of-thought, XML tags.

## Como funciona

**Técnicas principais:**

| Técnica | Quando usar | Exemplo |
|---|---|---|
| Role/persona | Especializar comportamento | `Você é um revisor de código sênior` |
| XML tags | Separar seções claramente | `<instructions>`, `<examples>`, `<output>` |
| Few-shot | Definir formato de output | 2–5 exemplos do resultado desejado |
| CoT (chain-of-thought) | Raciocínio passo-a-passo | `Pense passo a passo antes de responder` |
| Directional prompting | Guiar estilo/tom | `Responda em PT-BR, conciso, sem emojis` |

**Erros comuns:**
- Ambiguidade de escopo ("melhore este código" — o quê exatamente?)
- Ausência de formato esperado (o modelo adivinha)
- Instrução sem contexto suficiente (o modelo preenche com suposições)
- Over-specification (tanta restrição que o modelo não tem espaço para raciocinar)

**vs Context Engineering (Karpathy):** prompt engineering = estrutura do input; context engineering = o que vai no contexto (arquivos, memória, exemplos, ferramentas). Context engineering é o nível superior — prompt engineering é uma de suas camadas.

## Por que importa

Todo skill do vault-michel é prompt engineering aplicado: o bloco de instruções de um skill define role, formato, restrições e exemplos. Entender as técnicas permite escrever skills mais eficazes e diagnosticar quando um agente não está se comportando como esperado.

## Related
- [[03-RESOURCES/concepts/claude-code-tooling/_index]]
- [[03-RESOURCES/concepts/claude-code-tooling/skills-system]]
- [[03-RESOURCES/concepts/claude-md-behavioral-contract]]

## Evidências
- **[2026-06-24]** Gerenciar AI de diferentes níveis de capacidade requer o mesmo skill que gerenciar pessoas de diferentes níveis —... — [[ai-management-like-managing-people]]
- **[2026-06-24]** Claude é uma workbench de longo prazo, não search box. 10 passos: Project → identity → Instructions → Memory →... — [[claude-zero-base-workbench-guide]]
- **[2026-06-24]** Instructions são system prompt always-on (identidade permanente), vs skills (on-demand). Eve prepende instructions a... — [[instructions-eve-docs]]
- **[2026-06-24]** Tutorial eve: scaffold → set model → analyst persona → run. npx eve init cria agente com dev server, agent.ts define... — [[your-first-agent-eve]]
- **[2026-06-24]** Wireframe prompt como skill registrada no Claude: layout+design+writing rules em 1 prompt → zip → save → reusável com 1... — [[wireframe-prompt-claude-skill]]
- **[2026-06-24]** AI é difícil porque você não começou. 4 levels: deixe AI perguntar → use voz → gere arquivos → conecte ferramentas (com... — [[ai-survival-guide-normal-people]]
- **[2026-06-24]** 10 usos não-óbvios de AI que valem mais que 100 prompts: AI pergunta primeiro, preferences em memory, workspace por... — [[ai-10-hidden-uses-for-efficiency]]

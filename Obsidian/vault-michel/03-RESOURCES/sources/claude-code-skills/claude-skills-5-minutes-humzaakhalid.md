---
title: "How to Build Claude Skills under 5 minutes"
type: source
category: claude-code
author: "@humzaakhalid"
source: "https://x.com/humzaakhalid/status/2056253557892841918"
published: 2026-05-18
ingested: 2026-05-18
tags: [claude-skills, skill-md, claude-code, claude-ai, workflow]
triagem_score: 8
---

# How to Build Claude Skills under 5 minutes — @humzaakhalid

## Tese central

Claude Skills são arquivos Markdown simples em `/skills/` que o Claude lê antes de executar tarefas — o método correto elimina o loop "prompt → output ruim → correção manual" e substitui por "skill → prompt → output utilizável → pronto".

## Key Insights

### O que é uma Skill

- Arquivo `.md` em pasta `/skills/` do projeto ou ambiente computer-use
- Claude varre a pasta antes de escrever código, criar arquivos ou rodar comandos
- Quando task bate com skill, Claude lê o arquivo primeiro e só então age
- Analogia: briefing que o novo contratado lê antes do primeiro dia

### Formato mínimo

```
name: docx
description: [quando disparar essa skill]

# O que fazer
# O que não fazer
# Restrições do ambiente
# Exemplos
```

### 3 tipos de Skills

| Tipo | Propósito | Exemplos |
|---|---|---|
| Output Skills | Tipos específicos de arquivo (constraints de ambiente/exportação) | docx, pdf, pptx, xlsx |
| Workflow Skills | Tarefas recorrentes com padrões pessoais | newsletter writing, code review, client proposal |
| Context Skills | Fatos que Claude não pode saber via training | brand-voice, product-knowledge, team-structure |

- Regra: uma skill = um job. Não misturar os 3 tipos num arquivo só.

### Processo de criação (UI claude.ai)

1. Novo chat → "+" → "Skills" → "Manage Skills"
2. "+" → "Create Skill" → "Create with Claude"
3. Claude faz perguntas → responder → upload de arquivos de exemplo
4. Mais arquivos de análise = skill mais forte e acurada
5. Salvar e testar

### Por que importa

- Problema original: outputs "quase certos" em Word/PDF/slides por Claude ignorar constraints de ambiente
- Solução: SKILL.md lido antes de qualquer ação → output pronto para envio na primeira run
- A diferença não é inteligência do Claude; é contexto certo antes de começar

## Links

- Conceito: [[03-RESOURCES/concepts/claude-code-tooling/claude-skills]]
- Conceito: [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- Ver: [[03-RESOURCES/sources/agentic-skills-claude-chatgpt-gemini]]
- Ver: [[03-RESOURCES/sources/skills-prompting-mcp/anatomy-claude-folder-akshay-pachaar]]

## Como Skills Funcionam Mecanicamente

Quando Claude recebe uma tarefa, o harness (Claude Code ou claude.ai) verifica as skills disponíveis antes de qualquer processamento da tarefa. O campo `description` do SKILL.md é o vetor de matching: o harness compara a descrição da tarefa com as descrições das skills usando correspondência semântica. Se houver match, o SKILL.md é injetado no contexto antes do prompt do usuário.

Este carregamento acontece na fase de context-building — antes que Claude leia o prompt principal. O efeito prático: as restrições da skill estão no contexto antes de qualquer raciocínio sobre a tarefa. Claude não "consulta" a skill durante a execução; ele age com a skill já incorporada ao seu contexto operacional.

**Implicação de design:** escreva a `description` como uma condição de ativação, não como um nome ou objetivo. "Crie documentos Word .docx usando a biblioteca python-docx com formatação corporativa padrão" é uma condição de ativação eficaz. "Word documents" é um nome — vago demais para matching confiável.

## Progressive Disclosure: Por Que Funciona

Skills pesadas (com muitas instruções, referências e exemplos) têm um problema: carregar tudo na primeira menção é caro. O padrão de progressive disclosure resolve isso com uma hierarquia de dois níveis:

1. **SKILL.md (sempre carregado ao fazer match):** apenas metadados, regras de ouro e ponteiros para arquivos de referência
2. **Arquivos de referência (carregados sob demanda):** exemplos detalhados, edge cases, padrões por categoria

O SKILL.md fica em < 200 linhas. Os detalhes ficam em `references/`. Claude lê o SKILL.md e decide quais arquivos de referência são relevantes para a tarefa específica — carrega apenas esses.

Resultado: uma skill de 10.000 tokens totais custa 300 tokens na maioria das ativações e 2.000 tokens nas ativações que precisam de referências completas.

## Os Três Tipos de Skills em Detalhe

### Output Skills

Resolvem o problema de restrições de ambiente que Claude não pode inferir do prompt. Quando alguém pede "crie um relatório em Word", Claude sabe sobre formato Word mas não sabe:
- Qual biblioteca Python está disponível no ambiente (python-docx? docx2pdf?)
- Qual template corporativo deve ser usado
- Quais margens, fontes e estilos são esperados
- Se a exportação deve ser .docx ou .doc

Uma Output Skill encapsula todas essas restrições. O output na primeira tentativa fica pronto para uso — sem ciclos de correção.

### Workflow Skills

Capturam padrões pessoais que não podem ser aprendidos de exemplos públicos. A maneira específica de estruturar uma newsletter, o tom de voz em propostas de cliente, a ordem de seções em uma code review — esses são padrões que emergem da experiência individual e não existem em nenhum dataset de treinamento.

Workflow Skills são a versão estruturada de "o jeito certo de fazer X neste contexto específico". Criam consistência entre sessões sem precisar re-explicar o padrão em cada prompt.

### Context Skills

Resolvem o problema de knowledge privada que o modelo genuinamente não tem. Brand voice, estrutura da equipe, nomes de produtos internos, histórico de decisões arquiteturais — tudo isso existe fora do contexto de treinamento do modelo.

Context Skills são especialmente valiosas em ambientes corporativos onde o conhecimento organizacional é o principal diferencial. Em vez de colar contexto em cada prompt, uma Context Skill injeta esse conhecimento automaticamente quando relevante.

## Erros Comuns de Design de Skill

**Misturar os três tipos em uma skill:** uma skill que define output format AND workflow AND brand context ativa para quase tudo e raramente ativa quando deveria. Resultado: ruído no contexto, não sinal.

**Description como nome em vez de condição:** `description: "para quando precisar escrever emails"` é fraco. `description: "ativa quando o usuário pede para redigir, responder ou revisar emails profissionais, especialmente para clientes externos"` é forte.

**Skill sem exemplos negativos:** o `## O que não fazer` é tão importante quanto o `## O que fazer`. Sem exemplos negativos, o modelo aplica o padrão genérico onde deveria aplicar o padrão da skill.

**Skill que nunca é testada:** o fluxo correto de criação inclui testes reais com 5+ prompts representativos. Uma skill nunca testada pode ter uma description que nunca faz match, tornando-a invisível.

## Relevância para o Vault

O vault-michel usa o mesmo padrão de skills para seus agentes em `04-SYSTEM/agents/`. A diferença: as skills do vault são `.md` files lidos por Claude Code via MCP, não SKILL.md files no formato formal. O mecanismo de match é manual (o AGENTS.md descreve qual agente usar para qual tarefa) em vez de automático.

A evolução natural seria formalizar os agentes do vault como skills com `description` fields, permitindo que o sistema de matching automático do Claude Code selecione o agente correto sem intervenção manual.

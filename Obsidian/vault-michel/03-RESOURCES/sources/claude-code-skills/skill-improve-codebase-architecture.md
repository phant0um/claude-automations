---
title: "Skill: improve-codebase-architecture"
type: source
source_type: clipping
source_path: clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741 9.md
created: 2026-05-09
ingested: 2026-05-09
tags: [ai-agents, clipping]
triagem_score: 7
---

## Resumo

| name | improve-codebase-architecture |
| --- | --- |
| description | Find deepening opportunities in a codebase, informed by the domain language in CONTEXT.md and the decisions in docs/adr/. Use when the user wants to improve architecture, find refactoring opportunities, consolidate tightly-coupled modules, or make a codebase more testable and AI-navigable. |

## Improve Codebase Architecture

Surface architectural friction and propose **deepening opportunities** — refactors that turn shallow modules into deep ones. The aim is testability and AI-navigability.

## Glossary

Use these terms consistently when discussing the codebase:
- **Deep module**: módulo com interface simples e implementação rica — esconde complexidade
- **Shallow module**: módulo com interface quase tão complexa quanto a implementação — pouco valor de abstração
- **Coupling**: grau em que módulos dependem de detalhes internos uns dos outros
- **AI-navigable**: código que um agente LLM consegue entender e modificar com contexto mínimo

## O Problema que esta Skill Resolve

Codebases crescem organicamente — o que começou com boa arquitetura acumula:
- Módulos que "sabem demais" sobre outros módulos (high coupling)
- Funções de 300 linhas que misturam lógica de domínio com infraestrutura
- Interfaces com 15 parâmetros que refletem a implementação interna
- Testes que quebram quando detalhes de implementação mudam

A skill `improve-codebase-architecture` endereça isso sistematicamente, usando a linguagem do domínio (CONTEXT.md) e as decisões arquiteturais documentadas (ADRs) como âncora — não propõe refatorações que contradizem decisões já tomadas.

## Protocolo de Execução

### Fase 1: Leitura de Contexto

```
1. Ler CONTEXT.md — glossário do domínio, bounded contexts, invariantes
2. Ler docs/adr/*.md — decisões tomadas e seus rationales
3. Listar todos os módulos/pastas com descrição de 1 linha
```

### Fase 2: Mapeamento de Fricção

Para cada módulo, avaliar:

| Dimensão | Pergunta | Sinal de Problema |
|----------|----------|-------------------|
| Profundidade | A interface esconde a implementação? | Não → módulo raso |
| Coesão | Tudo neste módulo pertence ao mesmo conceito? | Não → responsabilidade múltipla |
| Acoplamento | Quantos outros módulos este importa? | >5 → alto acoplamento |
| Testabilidade | Posso testar sem mocks de infraestrutura? | Não → dependências ocultas |
| Navegabilidade | Um LLM consegue entender com <2 arquivos de contexto? | Não → contexto implícito demais |

### Fase 3: Identificação de Oportunidades

Categorias de deepening opportunities:

1. **Extração de interface**: criar abstração que esconde detalhes de implementação
2. **Inversão de dependência**: módulo de domínio não deve depender de módulo de infraestrutura
3. **Decomposição**: módulo com responsabilidades múltiplas → módulos menores e focados
4. **Consolidação**: múltiplos módulos que implementam a mesma abstração → um módulo deep
5. **Naming por domínio**: renomear para refletir linguagem do CONTEXT.md

### Fase 4: Priorização

Priorizar por impacto:
- **Alta prioridade**: oportunidades que desbloqueiam testabilidade
- **Média prioridade**: oportunidades que reduzem contexto necessário para navegação
- **Baixa prioridade**: melhorias estéticas de naming e organização

### Fase 5: Output

Um relatório com:
1. Mapa de fricção atual (o que está errado e por quê)
2. Lista priorizada de deepening opportunities
3. Para cada oportunidade: esforço estimado, risco, benefício esperado
4. ADR draft para as mudanças de maior impacto

## Exemplo: Antes e Depois

**Antes (módulo raso):**
```python
class PaymentProcessor:
    def process(self, user_id, amount, currency, card_number, 
                card_expiry, card_cvv, billing_address, 
                save_card=False, retry_count=3):
        # 150 linhas misturando validação + HTTP + DB
```

**Depois (módulo deep):**
```python
class PaymentProcessor:
    def process(self, payment: Payment) -> PaymentResult:
        # Esconde: validação, HTTP, retry, persistência
        # Interface: 1 input tipado, 1 output tipado
```

A interface ficou mais simples; a implementação ficou igualmente complexa — mas agora é complexidade **encapsulada**, não vazada.

## AI-Navigability: Por que isso Importa em 2026

Com agentes LLM cada vez mais usados para modificar código, a "AI-navigability" tornou-se critério arquitetural de primeira classe. Um módulo AI-navigable:

- Pode ser entendido com 1-2 arquivos de contexto (sem precisar ler 10 arquivos para entender uma mudança)
- Tem nomes que mapeiam diretamente para o CONTEXT.md do domínio
- Tem testes que documentam o comportamento esperado (agente pode ler os testes para entender o contrato)
- Não tem "conhecimento tribal" — tudo relevante está no código, não na cabeça de um desenvolvedor

A skill `improve-codebase-architecture` usa AI-navigability como critério porque foi construída para ser usada por agentes — ela própria avalia se um agente conseguiria navegar o código após a refatoração.

## Integração com Outras Skills

- **`diagnose`**: usa depois de `improve-codebase-architecture` para investigar bugs em módulos identificados como problemáticos
- **`grill-with-docs`**: usa antes para garantir que as mudanças propostas são consistentes com o modelo de domínio
- **`design-an-interface`**: usa para gerar múltiplas opções de interface deep antes de escolher uma

## Limitações

- Requer CONTEXT.md e ADRs existentes — sem eles, a skill opera sem âncora de domínio
- Não executa refatorações — apenas as identifica e prioriza
- Propostas podem conflitar com decisões de negócio não documentadas (débito técnico intencional)
- Não substitui o conhecimento do desenvolvedor sobre o sistema — complementa

## Origem

- Path: `clippings/skillsskillsin-progresshandoffSKILL.md at 733d312884b3878a9a9cff693c5886943753a741 9.md`
- Categoria: ai-agents
- Ingerido: 2026-05-09

## Cross-links

- [[03-RESOURCES/sources/claude-code-skills/skill-diagnose]]
- [[03-RESOURCES/sources/claude-code-skills/skill-grill-with-docs]]
- [[03-RESOURCES/sources/claude-code-skills/skill-design-an-interface]]
- [[03-RESOURCES/concepts/agent-systems/agentic-skills]]
- [[03-RESOURCES/concepts/claude-code-tooling/claude-code-workflow]]

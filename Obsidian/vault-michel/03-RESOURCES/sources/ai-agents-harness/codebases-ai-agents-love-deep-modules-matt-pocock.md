---
title: "How To Make Codebases AI Agents Love — Deep Modules"
type: source
created: 2026-05-18
updated: 2026-05-18
tags: [ai-agents, codebase-design, deep-modules, software-architecture, ai-coding]
triagem_score: 8
source_url: "https://www.aihero.dev/how-to-make-codebases-ai-agents-love"
author: "[[03-RESOURCES/entities/Matt-Pocock]]"
published: 2026-02-26
category: ai-agents
---

## Tese central

A maior variável na qualidade do output de agentes de código não é o prompt nem o AGENTS.md — é a arquitetura do codebase. Deep modules com interfaces simples e testes fortes são o design que maximiza a eficácia de agentes IA.

## Key insights

1. **AI = novo estagiário sem memória.** Cada vez que um agente é gerado, ele é como o protagonista de Memento: sem contexto acumulado, vendo o codebase pela primeira vez.
2. **3 custos de codebase ruim para AI:**
   - Feedback loops fracos: agente não sabe se a mudança funcionou
   - Navegabilidade baixa: agente não acha arquivos, não entende estrutura
   - Cognitive burnout: engenheiro acaba remendando manualmente o que AI errou
3. **Deep modules** (de "A Philosophy of Software Design"): muita implementação controlada por interface simples. Ao invés de dezenas de módulos rasos interconectados, poucos módulos grandes com interfaces claras.
4. **Grey box modules:** você detém a interface; AI detém a implementação; testes garantem o contrato. Você não precisa olhar para dentro enquanto os testes passam.
5. **Progressive disclosure of complexity:** a interface fica no topo e explica o que o módulo faz. AI lê tipos e entende o serviço sem entrar na implementação.
6. **Carga cognitiva reduzida:** de centenas de módulos interrelacionados para 7–8 chunks. AI gerencia o interior; você projeta as interfaces.
7. **Isso não é novo:** boas práticas de design de software de 20 anos atrás. O que é bom para humanos é bom para AI.
8. **TypeScript + Effect** mencionado como facilitador de modularização com enforcement de fronteiras.

## Deep modules em detalhe

### A definição de John Ousterhout

Matt Pocock cita "A Philosophy of Software Design" de John Ousterhout, onde "deep module" é definido como um módulo com interface simples e implementação complexa. O módulo é "profundo" no sentido de que esconde muito por trás de uma interface pequena — a proporção implementação/interface é alta.

Exemplos clássicos de deep modules:
- Sistema de arquivos Unix: `open`, `read`, `write`, `close` — interface de 4 funções escondendo décadas de complexidade de I/O
- `dict` em Python: uma linha para criar, mas implementação de hash table complexa
- `async/await` em JavaScript: 2 palavras escondendo toda a maquinaria de event loop

O oposto — shallow modules — têm interface quase tão complexa quanto a implementação. Cada detalhe interno vaza para a interface: getters e setters para cada campo, métodos `validate`, `transform`, `prepare` expostos separadamente.

### Por que AI é o "novo estagiário sem memória"

A metáfora do Memento é precisa: o agente de código não tem acumulação de contexto sobre o projeto ao longo do tempo. Cada sessão, ele vê o codebase pela primeira vez. Um desenvolvedor humano desenvolve intuições ao longo de meses — "esse módulo geralmente tem problemas X", "quando Y falha, geralmente é por causa de Z". O agente não tem essas intuições.

Deep modules compensam isso: quando a interface é simples e os tipos são expressivos, o agente pode entender o contrato de um módulo em segundos, sem precisar ler a implementação. Shallow modules forçam o agente a explorar profundamente para entender o que está acontecendo — e cada exploração adicional é mais context e mais tokens gastos.

### Progressive disclosure na prática

Matt Pocock descreve "progressive disclosure of complexity" como uma técnica de design onde a interface fica no topo do arquivo e explica o que o módulo faz. Estrutura concreta:

```typescript
// payments.ts
// Interface (topo do arquivo — visível sem scroll)
export interface PaymentService {
  process(amount: Money, method: PaymentMethod): Promise<PaymentResult>
  refund(transactionId: string, amount?: Money): Promise<RefundResult>
  getStatus(transactionId: string): Promise<PaymentStatus>
}

// Implementação (abaixo — o agente só lê se precisar)
class StripePaymentService implements PaymentService {
  // ... 400 linhas de implementação
}
```

O agente lê os tipos e entende o módulo sem entrar na implementação. Se precisar modificar o comportamento de `process`, sabe exatamente onde olhar.

## Os 3 custos de codebase ruim para AI em detalhe

### Feedback loops fracos

Um agente de código que modifica algo precisa saber se a modificação funcionou. Em codebases com boa cobertura de testes, o feedback é imediato: roda os testes, vê o resultado. Em codebases sem testes ou com testes lentos/frágeis, o agente modifica, não sabe se funcionou, e tende a fazer mais modificações para "garantir" — o que frequentemente piora a situação.

A relação com deep modules: módulos com interfaces claras são mais fáceis de testar (você testa o contrato, não a implementação). Mais testes → feedback loops mais fortes → agente mais eficaz.

### Navegabilidade baixa

Um agente que não consegue encontrar onde algo está implementado tende a recriar. Recriar é pior do que modificar: cria duplicação, inconsistência, e tende a perder tratamento de edge cases que existia na implementação original.

Sinais de navegabilidade baixa:
- Nomes inconsistentes entre módulos
- Lógica de negócio espalhada por camadas sem padrão claro
- Ausência de entry points óbvios
- Muito código "utility" sem localização clara

### Cognitive burnout do engenheiro

Quando o agente erra por causa do codebase (não por falta de capacidade), o engenheiro precisa intervir e corrigir manualmente. Cada intervenção manual é custo cognitivo — o engenheiro precisa entender o erro, entender o que o agente tentou, e corrigir. Em codebases ruins, isso acontece com frequência alta, e o resultado é que usar o agente acaba sendo mais trabalhoso do que fazer sem.

## Grey box como modelo operacional

Matt Pocock introduz o conceito de "grey box module": o engenheiro detém a interface (define o contrato), o agente detém a implementação (decide como cumprir o contrato), e testes garantem o contrato. "Você não precisa olhar para dentro enquanto os testes passam."

Isso define uma divisão de trabalho concreta:
- Engenheiro: design de interface, definição de tipos, escrita de testes de contrato
- Agente: implementação que satisfaz a interface e passa os testes
- Testes: árbitro objetivo de se o contrato foi cumprido

O engenheiro opera em nível de abstração; o agente opera em nível de implementação. O engenheiro não precisa revisar o código gerado linha por linha — apenas verificar que os testes passam e que a interface continua limpa.

## TypeScript + Effect como facilitador

Effect é uma biblioteca TypeScript que adiciona primitivas funcionais (efeitos gerenciados, tratamento de erros explícito, rastreamento de dependências) que tornam as interfaces de módulo mais expressivas. Quando uma função declara explicitamente quais efeitos colaterais pode ter e quais erros pode lançar, a interface já documenta comportamento não-feliz — que é exatamente o que o agente precisa para implementar corretamente.

## Limitações e trade-offs

- Deep modules requerem mais design upfront — certo para produtos maduros, potencialmente overkill para protótipos
- "AI detém a implementação" funciona melhor com linguagens tipadas onde o contrato pode ser verificado em compile-time
- Refatorar um codebase existente de shallow para deep modules é trabalho significativo — o retorno é gradual
- Grey box funciona quando os testes cobrem os casos que importam — coverage baixo invalida o modelo

## Links

- Artigo: https://www.aihero.dev/how-to-make-codebases-ai-agents-love
- Relacionado: [[03-RESOURCES/concepts/dev-foundations/ai-legible-backend]], [[03-RESOURCES/concepts/agent-systems/agent-harness]], [[03-RESOURCES/entities/Matt-Pocock]]

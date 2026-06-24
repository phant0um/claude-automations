---
title: "Gestão de Projetos"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, dev-foundations]
status: developing
---

# Gestão de Projetos

Entregar o produto certo, no prazo certo, dentro do orçamento — equilibrando o triângulo que nunca tem todos os lados perfeitos ao mesmo tempo.

## O que é

Gestão de projetos é a disciplina de planejar, executar e controlar esforços temporários para criar um produto, serviço ou resultado único. Todo projeto tem três restrições clássicas formando o **triângulo de ferro** (ou triângulo escopo-tempo-custo): você pode otimizar dois, mas o terceiro é afetado. Quer mais escopo no mesmo prazo? Aumente o custo (mais pessoas) ou sacrifique qualidade.

O **PMBOK** (Project Management Body of Knowledge) do PMI é o guia de referência para gerência de projetos tradicional — cobre 10 áreas de conhecimento (integração, escopo, cronograma, custos, qualidade, recursos, comunicações, riscos, aquisições, partes interessadas) em 5 grupos de processos (iniciação, planejamento, execução, monitoramento/controle, encerramento).

**Waterfall** (cascata) executa fases sequencialmente — adequado para projetos com escopo fixo e bem definido. **Agile** (Scrum, Kanban) adapta-se a mudanças com entregas iterativas — adequado para produtos de software onde os requisitos evoluem.

**Stakeholders** são todas as partes interessadas no projeto: cliente, usuário final, patrocinador, equipe, fornecedores. Mapear stakeholders cedo previne conflitos tardios.

## Como funciona

Artefatos essenciais de gestão:
- **Termo de Abertura:** autoriza formalmente o projeto, define escopo inicial e nomeia o gerente
- **EAP (Estrutura Analítica do Projeto / WBS):** decompõe o escopo em pacotes de trabalho menores e gerenciáveis — árvore hierárquica de entregas
- **Cronograma:** sequência e duração das atividades, com dependências (gráfico de Gantt)
- **Matriz de Riscos:** probabilidade × impacto de cada risco, com plano de resposta (evitar, mitigar, aceitar, transferir)
- **Relatório de Status:** comunicação periódica com stakeholders — % concluído, riscos, bloqueios

```
EAP exemplo — e-commerce:
  E-commerce
  ├── 1. Frontend
  │   ├── 1.1 Telas de catálogo
  │   ├── 1.2 Carrinho
  │   └── 1.3 Checkout
  ├── 2. Backend
  │   ├── 2.1 API de produtos
  │   └── 2.2 Processamento de pagamento
  └── 3. Infraestrutura
      ├── 3.1 Banco de dados
      └── 3.2 Deploy
```

## Por que importa

Para concursos públicos de Administração e TI, Gestão de Projetos (PMBOK, Agile, EAP, cronograma, riscos) é área com peso significativo — especialmente em editais de Analista e Especialista. Na FIAP, projetos em grupo exigem planejamento formal com EAP e cronograma. No mercado, desenvolvedores que entendem gestão de projetos se comunicam melhor com PMs e avançam para tech lead mais rapidamente.

## Exemplo

Triângulo na prática: cliente quer entregar em 2 semanas (prazo fixo) o escopo completo (escopo fixo). Solução: aumentar equipe (custo) ou reduzir escopo (MVP primeiro). Não existe "rápido, completo e barato" ao mesmo tempo.

## Related
- [[03-RESOURCES/concepts/dev-foundations/_index]]
- [[03-RESOURCES/concepts/engenharia-de-software]]
- [[03-RESOURCES/concepts/user-stories]]
- [[03-RESOURCES/concepts/roi]]

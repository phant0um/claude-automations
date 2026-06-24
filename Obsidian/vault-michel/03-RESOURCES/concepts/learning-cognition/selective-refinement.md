---
title: "Selective Refinement"
type: concept
created: 2026-05-31
updated: 2026-06-01
tags: [concept, agent-systems]
status: developing
---

# Selective Refinement

Melhorar iterativamente apenas as partes que precisam — em vez de regenerar tudo do zero — aplicando edits cirúrgicos seguidos de verificação.

## O que é

Selective refinement é o princípio de identificar onde um output está abaixo do limiar de qualidade e aplicar mudanças mínimas para corrigi-lo, preservando o que já está correto. É a antítese do "regenerate from scratch" e se alinha diretamente com o princípio Karpathy de **mudanças cirúrgicas**.

## Como funciona / Detalhes

**Loop básico:**
```
output_v0
  → avaliar: quais partes estão abaixo do threshold?
    → identificar diff mínimo necessário
      → aplicar edit cirúrgico
        → verificar (rodar testes, checar critérios)
          → se ok: done | se não: próxima iteração
```

**Quando refinar vs. reiniciar:**
- **Refinar**: erros localizados, estrutura correta, ≤ 30% do output incorreto
- **Reiniciar**: problema estrutural, premissa errada, > 50% incorreto, refinamento acumula dívida técnica

**LLM diff-apply pattern:**
- Em vez de pedir ao LLM para reescrever o arquivo inteiro, enviar o arquivo atual + instruções de patch
- Resultado: tokens economizados + histórico preservado + menor chance de regressão
- Ferramentas: `Edit` tool (Claude Code), `patch`, `git apply`

**Edit-then-verify loop (no vault):**
1. Editar arquivo (`Edit` tool)
2. Verificar wikilinks, frontmatter, consistência
3. Só marcar completo após verificação — ver CLAUDE.md checklist

**Conexão com agent-systems:**
- Agentes de auto-improvement (hill, extend) devem aplicar selective refinement
- Evitar reescritas massivas que introduzem regressões invisíveis

## Por que importa

Para Michel: este princípio reduz custo de tokens em sessões longas e produz edits mais confiáveis. Aplicável em code review (FIAP projetos) e no design de pipelines de agentes que melhoram conteúdo do vault.

## Related
- [[03-RESOURCES/concepts/agent-systems/_index]]
- [[03-RESOURCES/concepts/context-rotation]]
- [[03-RESOURCES/concepts/experience-compression-spectrum]]

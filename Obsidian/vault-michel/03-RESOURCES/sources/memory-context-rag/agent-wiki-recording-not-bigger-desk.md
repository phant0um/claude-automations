---
title: "Your Agent Needs a Wiki and a Recording, Not a Bigger Desk"
type: source
source: Clippings/Your Agent Needs a Wiki and a Recording, Not a Bigger Desk.md
created: 2026-05-17
ingested: 2026-05-17
tags: [ai-agents, memory, wiki, llm-wiki-pattern]
triagem_score: 8
---

## Tese central
Memória de agente eficaz = wiki (knowledge consolidado) + recording (trajetória recente), não context window maior. Aumentar "desk size" é antipadrão — gestão ativa de memória supera escala bruta de contexto.

## Key insights
- **GBrain (wiki):** knowledge crystalizado, atualizado de forma assíncrona após sessões, contém verdades persistentes sobre o domínio. Análogo a memória semântica humana — fatos e conceitos, não episódios específicos
- **Lossless (recording):** trajetória recente completa, captura causal de ações → resultados → aprendizados de curto prazo. Análogo a memória episódica — permite replay de raciocínio
- **Antipadrão "bigger desk":** aumentar context window não resolve o problema de saber o que importa. Contexto ilimitado ainda requer atenção ilimitada — LLM com 1M tokens ainda degrada ao processar tudo igualmente
- **Confirma llm-wiki-pattern:** wiki mantida pelo próprio LLM é primitive de memória mais eficiente que RAG vetorial para knowledge estável, porque incorpora estrutura semântica e wikilinks contextuais

## Por que não basta context window maior

Context window maior cria ilusão de memória sem resolver o problema de recuperação seletiva. Problemas concretos:
1. **Custo quadrático de atenção:** processar 1M tokens por turno é economicamente inviável em produção mesmo com Flash
2. **Degradação de atenção:** LLMs têm viés por posição — conteúdo no meio do contexto longo recebe menos atenção que início/fim (Lost in the Middle, 2023)
3. **Ausência de compressão:** histórico bruto não é conhecimento. 100 turnos de debugging contêm 3 insights úteis — wiki extrai os 3, recording mantém os 100 para auditoria

## Arquitetura prática: Wiki + Recording

### Wiki (GBrain)
- Arquivo Markdown estruturado com seções por domínio
- Atualizado após sessões ou quando novo conhecimento estável emerge
- Injetado no início do contexto como "memória de longo prazo" estática
- Exemplo: `hot.md` do vault-michel é implementação direta deste padrão

### Recording (Lossless)
- Log estruturado das últimas N ações/decisões com outcomes
- Formato comprimido — não transcript bruto, mas tuplas (ação, resultado, lição)
- Sliding window: manter últimas 20-50 entradas mais relevantes
- Permite agente perguntar "já tentei isso antes?" sem consultar memória externa

## Fluxo de memória saudável

```
sessão termina
    → extrair insights → atualizar wiki
    → comprimir trajetória → appender recording
    
próxima sessão começa
    → injetar wiki (longo prazo)
    → injetar recording recente (curto prazo)
    → contexto disponível para novo trabalho
```

## Diferença de pattern vs context stuffing

Context stuffing = jogar tudo no prompt e torcer. Wiki+Recording = arquitetura deliberada onde cada camada tem propósito e TTL explícito.

Resultado prático: agente com wiki de 5KB + recording de 2KB supera agente com 500KB de histórico bruto — menos tokens, mais sinal, menos ruído.

## Relevância para vault-michel

Vault implementa este padrão nativamente:
- `04-SYSTEM/wiki/hot.md` = GBrain (wiki de alta frequência)
- `03-RESOURCES/` = knowledge base estável (wiki de longo prazo)
- Logs de sessão = recording comprimido

Manutenção contínua do hot.md é o que mantém qualidade de memória — não tamanho do contexto.

## Erros comuns ao ignorar este padrão

**Erro 1: Depender de contexto longo como substituto de wiki**
Resultado: funciona bem nas primeiras sessões, degrada conforme histórico cresce, colapsa completamente quando contexto é limpo (nova sessão).

**Erro 2: Manter recording ilimitado sem compressão**
Recording cresce indefinidamente. Tokens aumentam. Custo aumenta. Signal-to-noise decresce. Solução: comprimir periodicamente — extrair insights, descartar detalhes desnecessários.

**Erro 3: Wiki atualizada raramente (só quando "parece errada")**
Wiki desatualizada é pior que sem wiki — injeta informação incorreta como se fosse correta. Política: atualizar no final de cada sessão que produziu novo conhecimento, sem exceção.

**Erro 4: Recording sem estrutura**
Recording como transcript bruto = low density. Recording como tuplas estruturadas (ação, resultado, lição) = high density. Mesmos tokens, 5× mais informação útil.

## Métricas de saúde de memória

Para saber se o sistema de memória está funcionando:
- **Cache hit rate:** proporção de sessões onde wiki/recording forneceu informação diretamente usada — deve ser > 70%
- **Freshness:** última atualização da wiki — deve ser < 7 dias para domínio ativo
- **Compressão do recording:** tamanho do recording / número de sessões cobertas — deve diminuir com compressões periódicas

## Por que "bigger desk" é antipadrão

A analogia do "desk" (mesa de trabalho) é central no argumento. Desk maior = mais papéis espalhados na frente = mais acesso imediato mas também mais ruído, mais tempo procurando, mais carga cognitiva.

Wiki + Recording é o equivalente de sistema de arquivos organizado — menos coisas na mesa (contexto ativo), mas acesso rápido ao que precisa via índice (wiki) e histórico recente comprimido (recording).

Para agentes: context window é o "desk". Injetar tudo na context window é bigger desk — escala até um ponto, depois colapsa por ruído. Arquitetura wiki + recording mantém desk pequeno, organizado, e relevante.

## Conexão com o princípio de simplicidade

Argumento do paper alinha com Karpathy e com CLAUDE.md do vault: gestão ativa e deliberada supera escala bruta. Um modelo menor com memória bem arquitetada supera modelo maior com memória desorganizada. Princípio de design universal: estrutura beats scale.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm-wiki-pattern]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-architecture]]
- [[03-RESOURCES/concepts/agent-systems/agent-memory-four-layers]]
- [[03-RESOURCES/concepts/pkm-obsidian/knowledge-compounding]]

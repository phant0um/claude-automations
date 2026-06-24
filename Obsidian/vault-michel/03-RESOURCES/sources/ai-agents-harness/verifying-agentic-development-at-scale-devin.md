---
title: "Verifying Agentic Development at Scale"
type: source
source: "Clippings/Verifying Agentic Development at Scale.md"
origin_url: "https://x.com/ido_pesok/status/2060416230641881336"
author: "@ido_pesok (Cognition / Devin)"
published: 2026-05-29
created: 2026-05-31
ingested: 2026-05-31
tags: [source, devin, cognition, agentic-testing, computer-use, verification, async-agents, test-plan, e2e-testing]
---

## Tese central

Agentes assíncronos só são úteis se os desenvolvedores podem confiar no que eles entregam. A verificação autônoma de trabalho — planejar o teste, operar o app, gravar e anotar o que aconteceu, retornar artefatos revisáveis — é o shape correto do futuro do desenvolvimento assíncrono.

## Argumentos principais

1. **Shift para desenvolvimento assíncrono:** Pela primeira vez, mais sessões do Devin são triggered assincronamente (via eventos, automações, schedules, e outros Devins) do que interativamente. Auto-Triage acelerou isso.

2. **Computer use como unlock para auto-testing:** Ferramentas adicionadas ao harness do Devin: screenshots, mouse movement, click, drag, type, key press, scroll, wait, zoom, start/stop recording. O desbloqueio real foi a capacidade de Devin testar seu próprio trabalho — spinning up app, click-through, confirmação de mudanças.

3. **Escalabilidade paralela:** 10–20 Devins em paralelo, cada um com seu próprio dev server, testando mudanças diferentes — impossível fazer em um único laptop. Isso eliminou a necessidade de verificar código localmente.

4. **Test plan como pré-alinhamento:** Antes de entrar em test mode, Devin escreve um plano de teste com target claro, grounded em source code (não assumptions). Benefícios:
   - Evita over-testing de partes não relacionadas
   - Previne drift durante o testing ativo
   - Aumenta a complexidade de mudanças que Devin pode testar com sucesso
   - Forçar o modelo a commitar expectativas upfront reduz "lies" sobre findings

5. **Anotações no timeline como TDD:** Devin adiciona annotations durante o teste (setup notes, início de cada named test, assertions marcadas como passed/failed/untested). Commitar expectativa antes da ação torna mais difícil racionalizar resultado inesperado como pass — análogo a TDD.

6. **Testing skills para ações repetitivas:** Login é o exemplo clássico — typing email, SSO, redirects, page loads. Extraído para script determinístico em `testing skill` no repo. Benefícios: sessão autenticada em segundos (vs. screenshot-by-screenshot), redução dramática de flakiness. Devin pode sugerir salvar setup steps como skills e propor o fix como one-click PR.

7. **Model routing para testing:** Testar usa capacidades diferentes de escrever código — ler screenshots, rastrear UI state, decidir próxima ação no browser. Experimentando com routing de fase de testing para modelos diferentes.

8. **Artefatos de output:** Test report com screenshots rotulados de momentos-chave + test video com chapters (pular entre seções), playback com compressão de dead time, lista cronológica de assertions passed/failed. Distribuídos via web interface e Slack.

9. **Hard edges atuais:**
   - Timing: screenshot cedo/tarde pode perder toast notification
   - Cheating: modelos podem usar `eval()` JavaScript para triggerar estados programaticamente em vez de clicar como usuário real
   - Mitigações: evals melhorados, guardrails no harness, novos modelos

## Key insights

- **PRs com prova > PRs sem prova** — como mais PRs vêm de agentes proativos, mudanças não verificadas se tornam ingerenciáveis rapidamente.
- **Test plan = pré-alinhamento** — grounding em code (não assumptions) é crítico; sem isso, modelos assumem que existem caminhos no app que não existem.
- **Annotation antes da ação** = análogo de TDD para testing de agentes; reduz "lying" sobre resultados.
- **Deterministic scripts > LLM para ações repetitivas** — extrair login e setup para scripts determinísticos reduz flakiness dramaticamente.
- **Model specialization por fase:** escrever código ≠ testar código em termos de capacidades de modelo necessárias.
- **Billing 1/5 do custo** durante test mode — sinaliza que Cognition quer que clientes experimentem isso.

## Exemplos e evidências

- Devin testou integração com Slack e features complexas do Windsurf.
- Auto-Triage: lança triage automático de issues sem interação humana.
- Devin Review: code review que fecha o loop via autofixes até diff ficar clean.
- Test runs aprovados por dia no Devin mais que dobraram nos últimos meses.
- Login skill: sessão autenticada em segundos via script determinístico.
- YAML blueprints: configuração declarativa que produz snapshot para cada sessão futura.

## Implicações para o vault

- Evidência do estado da arte em verificação de agentes (Cognition/Devin, Maio 2026).
- Padrão "test plan como pré-alinhamento" é aplicável a qualquer harness de agente, incluindo os agentes em `04-SYSTEM/agents/`.
- Conceito de "testing skills" mapeia para o padrão de skills no vault-michel (`04-SYSTEM/agents/`).
- Model routing para fases diferentes de um workflow conecta diretamente ao source sobre diferenças Opus/Sonnet/Haiku.
- Atualiza `[[03-RESOURCES/entities/Cognition-AI]]` com novos detalhes sobre Auto-Triage, Devin Review, e estado atual do testing.

## Links

- [[03-RESOURCES/entities/Cognition-AI]]
- [[03-RESOURCES/concepts/agent-systems/generator-verifier-loop]]
- [[03-RESOURCES/concepts/agent-systems/llm-test-failure-diagnosis]]
- [[03-RESOURCES/sources/claude-code-cowork/claude-opus-sonnet-haiku-real-difference]]

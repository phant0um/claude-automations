---
title: "Transformar Claude Code em Equipe de 6 Desenvolvedores"
type: source
source_file: Clippings/Post by @exploraX_ on X.md
origin: post no X (@exploraX_)
ingested: 2026-05-14
tags: [claude-code, open-source, agent-skills, gstack, superpowers, security-review]
---
# Transformar Claude Code em Equipe de 6 Desenvolvedores

> [!key-insight] Core point
> Seis ferramentas open-source transformam o Claude Code num time completo de desenvolvimento — cada uma impõe um tipo de disciplina que separa prototipagem de código que vai para produção.

## Conteúdo

### 1. superpowers (184k+ estrelas)
- Claude para de pular direto para o código e planeja primeiro
- Escreve spec, divide em tarefas, executa como subagente, revisa antes de prosseguir
- TDD vermelho/verde imposto por padrão
- GitHub: `github.com/obra/superpowers`

### 2. frontend-design (Anthropic, ~131k estrelas no repo pai)
- Elimina visual genérico de IA (Inter + gradientes roxos + cards dentro de cards)
- Força compromisso estético real antes de escrever CSS
- GitHub: `github.com/anthropics/skills`

### 3. code-review
- Cinco subagentes em paralelo, cada um revisando de ângulo diferente: bugs, regras do projeto, regressões via histórico git, testes, qualidade de código
- GitHub: `github.com/anthropics/claude-code`

### 4. security-review
- Escaneia vulnerabilidades antes do push: SQL injection, XSS, segredos expostos, desserialização insegura, auth ausente
- GitHub: `github.com/anthropics/claude-code-security-review`

### 5. claude-mem
- Memória persistente entre sessões
- GitHub: `github.com/thedotmack/claude-mem`

### 6. gstack (Garry Tan, CEO da YC, 23 skills em um plugin)
- `/office-hours`: consultor de descoberta antes de código
- `/design-review`: audita e corrige UIs
- `/ship`: execução test-first
- `/review`: feedback como engenheiro staff
- GitHub: `github.com/garrytan/gstack`

## Conexões

- [[03-RESOURCES/entities/Garry-Tan]]
- [[03-RESOURCES/entities/exploraX]]
- [[03-RESOURCES/concepts/parallel-agent-code-review]]
- [[03-RESOURCES/concepts/claude-skills]]
- [[03-RESOURCES/concepts/agentic-skills]]

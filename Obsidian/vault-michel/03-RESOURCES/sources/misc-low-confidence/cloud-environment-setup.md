---
title: Cloud environment setup
type: source
source: "Clippings/Cloud environment setup.md"
created: 2026-06-06
ingested: 2026-06-06
tags: [ai-agents, managed-agents, sandboxes, infrastructure]
---

## Tese central
Documentação de referência oficial da Anthropic (`managed-agents-2026-04-01` beta) sobre **environments** — a configuração reutilizável que define como um sandbox de agente é provisionado (pacotes, rede). Cobre especificamente `type: cloud` (sandboxes hospedados pela Anthropic); environments self-hosted são tratados em outra página. Esta é a camada de "blueprint" que antecede a criação de sessões — você cria um environment uma vez e referencia seu ID em múltiplas sessões.

## Argumentos principais
- **Modelo environment → session → sandbox:** um environment é criado uma vez (tem `name` único na org/workspace) e referenciado por ID ao iniciar sessões. Múltiplas sessões podem compartilhar o mesmo environment, mas **cada sessão recebe seu próprio sandbox isolado** (container Linux fresco) — sessões não compartilham estado de filesystem.
- **Criação via CLI:** `ant beta:environments create --name "python-dev" --config '{type: cloud, networking: {type: unrestricted}}'`. O campo `config.type` define se é `cloud` ou self-hosted.
- **Uso na sessão:** o `environment_id` é passado como string no payload de criação de sessão (`POST /v1/sessions`), junto com `agent` (o agent_id). Header obrigatório: `anthropic-beta: managed-agents-2026-04-01`.
- **Pré-instalação de pacotes (`packages`):** instala pacotes no sandbox antes do agente iniciar, via gerenciadores nativos. Pacotes são **cacheados entre sessões que compartilham o mesmo environment**. Quando múltiplos gerenciadores são especificados, rodam em **ordem alfabética** (apt, cargo, gem, go, npm, pip). Versões são opcionais (default: latest) e podem ser pinadas (ex: `pandas==2.2.0`, `ripgrep@14.0.0`).
- **Gerenciadores suportados:** `apt` (sistema, ex. ffmpeg), `cargo` (Rust, ex. ripgrep@14.0.0), `gem` (Ruby, ex. rails:7.1.0), `go` (módulos Go), `npm` (Node, ex. express@4.18.0), `pip` (Python, ex. pandas==2.2.0).
- **Controle de rede (`networking`):** dois modos —
  - `unrestricted` (default): acesso total de saída, exceto blocklist geral de segurança.
  - `limited`: restringe a `allowed_hosts`; acesso adicional via `allow_package_managers` e `allow_mcp_servers` (booleanos, default `false`).
- **Networking não afeta tools:** o campo `networking` controla apenas o acesso de **saída do sandbox**; não impacta os domínios permitidos das tools `web_search`/`web_fetch` (essas têm suas próprias allowlists).
- **Recomendação de produção:** usar `limited` com `allowed_hosts` explícito, seguindo princípio do menor privilégio, com auditoria periódica dos domínios permitidos.
- **Detalhes de `allowed_hosts`:** aceita hostnames simples ou wildcards (`*.example.com`); **não inclui esquema de URL** (sem `https://`).
- **Ciclo de vida do environment:** persiste até ser arquivado/deletado explicitamente; não é versionado (recomenda-se logar mudanças no lado do cliente para mapear estado do environment ↔ sessões).
- **Operações de gerenciamento:** `list`, `retrieve --environment-id`, `archive` (torna read-only; sessões existentes continuam), `delete` (só permitido se nenhuma sessão referenciar o environment).

## Key insights
- A separação **environment (blueprint reutilizável) vs. sandbox (instância isolada por sessão)** é o ponto-chave de design: permite reuso de configuração/cache de pacotes sem comprometer isolamento entre execuções concorrentes.
- O cache de pacotes entre sessões do mesmo environment é uma otimização de performance importante — sessões subsequentes não pagam o custo de instalação novamente.
- A ausência de versionamento de environments é uma lacuna operacional reconhecida pela própria doc — força o usuário a manter seu próprio log de mudanças se quiser auditar qual configuração rodou em qual sessão.
- O modo `limited` com `allow_mcp_servers`/`allow_package_managers` é um padrão de "least privilege com escapes nomeados": em vez de abrir tudo ou nada, permite liberar categorias inteiras (registries públicos, servidores MCP do agente) sem listar cada host individualmente.
- A regra de ordenação alfabética de instalação de pacotes (`apt, cargo, gem, go, npm, pip`) é um detalhe operacional sutil que pode importar para dependências cruzadas entre gerenciadores (ex. um pacote `apt` que um `pip install` depende).

## Exemplos e evidências
- Comando de criação básico:
```
ant beta:environments create \
  --name "python-dev" \
  --config '{type: cloud, networking: {type: unrestricted}}'
```
- Exemplo completo com pacotes (YAML heredoc):
```yaml
name: data-analysis
config:
  type: cloud
  packages:
    pip:
      - pandas
      - numpy
      - scikit-learn
    npm:
      - express
  networking:
    type: unrestricted
```
- Exemplo de networking restrito:
```json
{
  "type": "cloud",
  "networking": {
    "type": "limited",
    "allowed_hosts": ["api.example.com"],
    "allow_mcp_servers": true,
    "allow_package_managers": true
  }
}
```
- Payload de criação de sessão referenciando o environment:
```bash
session=$(curl -fsS https://api.anthropic.com/v1/sessions \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "anthropic-beta: managed-agents-2026-04-01" \
  -H "content-type: application/json" \
  --data @- <<EOF
{"agent": "$agent_id", "environment_id": "$environment_id"}
EOF
)
```
- Comandos de gerenciamento: `ant beta:environments list | retrieve | archive | delete --environment-id "$ENVIRONMENT_ID"`.

## Implicações para o vault
Esta página é o "blueprint" de configuração que precede a runtime descrita em [[03-RESOURCES/sources/cloud-sandbox-reference]] (que documenta o que já vem pré-instalado no container resultante). Juntas formam a camada de infraestrutura sandbox do sistema **Claude Managed Agents**. O parâmetro `networking` aqui se conecta à camada de execução de código descrita em [[03-RESOURCES/sources/claude-platform-on-aws]] (que menciona "code execution in Anthropic's managed sandbox" como recurso disponível via AWS). O fluxo de provisionar conteúdo dentro do sandbox criado aqui — repositórios GitHub, arquivos, credenciais — é coberto por [[03-RESOURCES/sources/accessing-github]], [[03-RESOURCES/sources/adding-files]] e [[03-RESOURCES/sources/authenticate-with-vaults]]. Reforça o conceito [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]] (environment como camada de abstração entre agent definition e sessão executável) e [[03-RESOURCES/concepts/agent-systems/harness-adaptation]] (a configuração de rede/pacotes é exatamente o tipo de adaptação de harness que muda por ambiente de deployment). Sugiro considerar o novo conceito `managed-agents-harness` (ver relatório).

## Links
- [[03-RESOURCES/sources/cloud-sandbox-reference]]
- [[03-RESOURCES/sources/claude-platform-on-aws]]
- [[03-RESOURCES/sources/accessing-github]]
- [[03-RESOURCES/sources/adding-files]]
- [[03-RESOURCES/sources/authenticate-with-vaults]]
- [[03-RESOURCES/sources/files-api]]
- [[03-RESOURCES/concepts/agent-systems/agent-abstraction-layers]]
- [[03-RESOURCES/concepts/agent-systems/harness-adaptation]]
- [[03-RESOURCES/sources/ai-agents-harness/claude-managed-agents-beginners-guide]]

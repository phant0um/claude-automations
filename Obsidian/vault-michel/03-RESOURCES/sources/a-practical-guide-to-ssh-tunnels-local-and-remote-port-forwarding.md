---
title: "A Practical Guide to SSH Tunnels: Local and Remote Port Forwarding"
type: source
source: "Clippings/A Practical Guide to SSH Tunnels Local and Remote Port Forwarding.md"
created: 2026-06-22
ingested: 2026-06-22
tags: [articles]
---

## Tese central
SSH Tunnels (port forwarding local, remoto e dinâmico) são uma tecnologia "antiga" mas ainda extremamente útil — o autor argumenta que aprender bem alguns truques de SSH pode ser mais rentável a longo prazo do que dominar uma dúzia de ferramentas Cloud Native ou frameworks de agentes de IA destinados a ficar obsoletos no próximo trimestre. O artigo apresenta um guia visual e mnemônicos para memorizar os comandos corretos de cada modo de tunelamento.

## Argumentos principais
- **Local Port Forwarding** (`ssh -L [local_addr:]local_port:remote_addr:remote_port [user@]sshd_addr`): o cliente SSH local escuta em `local_port`; qualquer tráfego para essa porta é encaminhado para `remote_addr:remote_port`, alcançado a partir da máquina remota. Casos de uso: acessar banco de dados remoto privado (MySQL/Postgres/Redis), acessar app web exposta só em rede privada, acessar porta de container sem publicá-la na interface pública do servidor.
- **Local Port Forwarding com bastion/jump host**: `remote_addr` e `sshd_addr` podem ser máquinas diferentes — o servidor SSH usado para alcançar destinos privados (bastion host) não precisa ser o destino final. Útil para chamar endpoints acessíveis a partir do bastion mas não do laptop local (ex: EC2 com interfaces pública/privada acessando cluster OpenSearch dentro de uma VPC).
- **Remote Port Forwarding** (`ssh -R [remote_addr:]remote_port:local_addr:local_port [user@]gateway_addr`): inverso do local — expõe momentaneamente um serviço local para o mundo externo via um gateway público. Por padrão, só o localhost do gateway pode acessar a porta exposta; para tornar acessível publicamente é necessário `GatewayPorts yes` no `sshd_config`. Casos de uso: expor serviço de dev do laptop para internet pública (demo rápida), expor homelab.
- **Remote Port Forwarding para rede doméstica/privada**: o cliente SSH (ex: laptop) age como jump host, expondo portas de uma rede doméstica/privada (alcançável pelo laptop) para o mundo externo através de um servidor SSH gateway — útil quando um servidor de dev reside numa rede doméstica sem acesso à internet (isolamento extra).
- **Dynamic Local Port Forwarding** (`ssh -D [local_addr:]local_port [user@]sshd_addr`): transforma o cliente SSH local num proxy SOCKS. Qualquer app que fale SOCKS pode escolher destino por conexão, sem precisar de um túnel fixo por serviço. Casos de uso: chamar APIs numa rede privada através de um bastion sem um túnel por serviço; navegar apps web internos via um único jump host; alcançar uma frota de endpoints VPC a partir do laptop via uma única instância EC2.
- **Dynamic Remote Port Forwarding** (`ssh -R [bind_address:]port [user@]gateway_addr`, sem destino fixo): espelho do `-D` — o *servidor* SSH se torna o proxy SOCKS, e cada conexão feita através dele é tunelada de volta ao cliente SSH e resolvida do ponto de vista do cliente. Expõe toda uma rede (ex: doméstica) alcançável pelo cliente.
- **Mnemônicos para memorizar**: `-L` = local:remote (o lado esquerdo abre a nova porta = a máquina cliente SSH); `-R` = remote:local (o lado esquerdo abre a nova porta = o servidor sshd). "Local" pode significar a máquina cliente SSH ou um host interno acessível a partir dela; "remote" pode significar a máquina servidor SSH ou qualquer host acessível a partir dela.

## Key insights
- O ponto central que gera confusão recorrente (mesmo para usuário diário de SSH tunnels, segundo o autor) não é a sintaxe em si, mas a ambiguidade semântica das palavras "local" e "remote" — cada uma pode se referir à máquina SSH ou a um host alcançável a partir dela.
- A flag `GatewayPorts yes` no `sshd_config` é o ponto de configuração que decide se o tunnel remoto fica restrito ao localhost do gateway ou se vira acessível pela interface pública — detalhe frequentemente esquecido que causa "funciona mas não está exposto" na prática.
- O uso de SSH tunnels para "tunnel local browser debugging port para um agente de coding sandboxed/remoto" é citado duas vezes no artigo (local e remote forwarding) — caso de uso direto e atual para quem trabalha com agentes de coding remotos/sandboxed.

## Exemplos e evidências
- Diagramas visuais (cheat sheet) para cada um dos 4 modos de tunelamento, incluindo a variante bastion/jump host de cada modo.
- Tutorial completo com exercícios hands-on disponível em iximiuz Labs (`labs.iximiuz.com/tutorials/ssh-tunnels`).

## Implicações para o vault
Conteúdo técnico de infraestrutura puro, sem concept existente direto no vault — não há nota dedicada a SSH/networking em `dev-foundations`. Cria-se concept novo `ssh-port-forwarding` para capturar esse conhecimento reutilizável, já que o caso de uso "tunelar porta de debug do navegador para agente de coding remoto/sandboxed" conecta diretamente com workflows de agentes de coding documentados em [[03-RESOURCES/concepts/agent-systems/coding-agents]].

## Links
- [[03-RESOURCES/concepts/dev-foundations/ssh-port-forwarding]]
- [[03-RESOURCES/concepts/agent-systems/coding-agents]]

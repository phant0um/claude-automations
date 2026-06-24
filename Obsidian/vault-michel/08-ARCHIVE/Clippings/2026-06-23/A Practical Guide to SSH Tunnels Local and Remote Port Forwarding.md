---
title: "A Practical Guide to SSH Tunnels: Local and Remote Port Forwarding"
source: "https://x.com/iximiuz/status/2069036148077293614"
author:
  - "[[@iximiuz]]"
published: 2026-06-22
created: 2026-06-22
description: "SSH port forwarding explained in a clean and visual way. How to use local and remote port forwarding. What sshd settings may need to be adju..."
tags:
  - "clippings"
---
![Imagem](https://pbs.twimg.com/media/HLavTUaW4AApqZp?format=jpg&name=large)

SSH port forwarding explained in a clean and visual way. How to use local and remote port forwarding. What sshd settings may need to be adjusted. How to memorize the right flags.

SSH is [yet another example](https://iximiuz.com/en/posts/linux-pty-what-powers-docker-attach-functionality/) of an ancient technology that is still in wide use today. It may very well be that learning a couple of SSH tricks is more profitable in the long run than mastering a dozen Cloud Native tools or AI agent frameworks destined to become deprecated next quarter.

One of my favorite parts of this technology is SSH Tunnels. With nothing but standard tools and often using just a single command, you can achieve the following:

- Access internal VPC endpoints through a public-facing EC2 instance.
- Open a localhost port of a remote development VM in the local browser.
- Expose any local server from a home/private network to the outside world.
- [Tunnel your browser's debugging port to a remote sandboxed coding agent](https://labs.iximiuz.com/docs/playground-recipes/coding-agent-with-browser-access).

And more 😍

But despite the fact that I use SSH Tunnels daily, it always takes me a while to recall the right command. Should it be a Local or a Remote tunnel? What are the flags? Is it a local\_port:remote\_port or the other way around? So, I decided to finally wrap my head around it, and it resulted in a series of labs and a visual cheat sheet.

![Imagem](https://pbs.twimg.com/media/HLavi8oWsAALOOf?format=png&name=large)

SSH Tunnels Cheat Sheet

## Local Port Forwarding

Starting from the one that I use the most. Oftentimes, there might be a service listening on localhost or a private interface of a remote machine that I can only SSH to via its public IP. And I desperately need to access this port from my local machine. A few typical examples:

- Accessing a private remote database (MySQL, Postgres, Redis, etc) from your laptop using your favorite UI tool.
- Using your browser to access a web application exposed only to a private network.
- Accessing a container's port from your laptop without publishing it on the server's public interface.

All of the above use cases can be solved with a single ssh command:

```bash
ssh -L [local_addr:]local_port:remote_addr:remote_port [user@]sshd_addr
```

The -L flag indicates we're starting a local port forwarding. What it actually means is:

- On your local machine, the SSH client will start listening on local\_port (likely, on localhost, but it depends - [check the GatewayPorts setting](https://linux.die.net/man/5/sshd_config#GatewayPorts)).
- Any traffic to this port will be forwarded to remote\_addr:remote\_port, reached from the remote machine you SSH-ed to.

Here is what it looks like on a diagram:

![Imagem](https://pbs.twimg.com/media/HLav0EzXsAAnAIa?format=jpg&name=large)

## Local Port Forwarding with a Bastion Host

It might not be obvious at first, but the ssh -L command allows forwarding a local port to a remote port on any machine, not only on the SSH server itself. Notice how the remote\_addr and sshd\_addr may or may not have the same value:

```bash
ssh -L [local_addr:]local_port:remote_addr:remote_port [user@]sshd_addr
```

A remote SSH server used to access private destinations is usually called a [bastion or jump host](https://en.wikipedia.org/wiki/Bastion_host). This is how I visualize this scenario in my head:

![Imagem](https://pbs.twimg.com/media/HLawI0FXkAAw3IE?format=jpg&name=large)

I often use the above trick to call endpoints that are accessible from the bastion host but not from my laptop (e.g., using an EC2 instance with private and public interfaces to connect to an OpenSearch cluster or any other service deployed fully within a VPC).

## Remote Port Forwarding

Another popular (but rather inverse) scenario is when you want to momentarily expose a local service to the outside world. Of course, for that, you'll need a public-facing ingress gateway server. And the good news is that any public-facing server with an SSH daemon on it can be used as such a gateway:

```bash
ssh -R [remote_addr:]remote_port:local_addr:local_port [user@]gateway_addr
```

The above command looks no more complicated than its ssh -L counterpart. But there is a pitfall...

**By default, the above SSH tunnel will allow using only the gateway's localhost as the remote address.** In other words, your local port will become accessible only from inside the gateway server itself, which is most likely not what you actually need. For instance, I typically want to use the gateway's public address as the remote address to expose my local services to the public Internet. For that, the SSH server needs to be configured with the [GatewayPorts yes](https://linux.die.net/man/5/sshd_config#GatewayPorts) setting.

Here is what remote port forwarding can be used for:

- Exposing a dev service from your laptop to the public Internet for a quick demo.
- Exposing your homelab to the public Internet (for arbitrary purposes).
- [Tunneling your local browser's debugging port to a remote and/or sandboxed coding agent](https://labs.iximiuz.com/docs/playground-recipes/coding-agent-with-browser-access).

Here is how the remote port forwarding can be visualized:

![Imagem](https://pbs.twimg.com/media/HLawSzyXMAAd930?format=jpg&name=large)

## Remote Port Forwarding to a Home or Private Network

Similar to local port forwarding, remote port forwarding has its own bastion or jump host mode. But this time, the machine with the SSH client (e.g., your dev laptop) plays the role of the jump host. In particular, it allows exposing ports of a home (or private) network reachable from your laptop to the outside world through a remote SSH server acting as an ingress gateway:

```text
ssh -R [remote_addr:]remote_port:local_addr:local_port [user@]gateway_addr
```

Looks almost identical to the simple remote SSH tunnel, but the local\_addr:local\_port pair becomes the address of a device in the home network. Here is how it can be depicted on a diagram:

![Imagem](https://pbs.twimg.com/media/HLawaEXX0AAtoY7?format=jpg&name=large)

I typically use my laptop as a thin client, and the actual development happens on a remote server. Sometimes, such a remote server can reside in my home network and have no or restricted Internet access (for extra isolation). This is when I may want to rely on remote port forwarding to expose a service from a home server to the public Internet, using my laptop that can access both the internal dev server and the remote SSH server (ingress gateway) as a jump host.

## Dynamic Local Port Forwarding

This forwarding mode is less transparent for the clients, but it is also significantly more flexible than regular local port forwarding. Instead of wiring a local port to a single remote destination (like ssh -L does), **dynamic (local) port forwarding** turns the SSH client into a local [SOCKS proxy](https://en.wikipedia.org/wiki/SOCKS). Any application that can speak SOCKS can then send traffic through it, choosing the actual destination host and port per connection - they will be sent over to the SSH server, which will resolve the destination and establish the connection:

```text
ssh -D [local_addr:]local_port [user@]sshd_addr
```

When the -D flag is used, the SSH client on your machine starts a SOCKS proxy listening on local\_port (on localhost by default). Each connection made through the proxy is forwarded to whatever address the SOCKS client asks for, reached from the sshd\_addr machine.

In other words, it's like ssh -L, but you don't have to specify a single remote\_addr:remote\_port upfront, because the SOCKS protocol allows specifying the destination at the beginning of each connection (via a few extra bytes sent right before the payload). One (local) proxied port gives you access to every host and port reachable from the (remote) SSH server.

![Imagem](https://pbs.twimg.com/media/HLawjaJWQAA4J8-?format=jpg&name=large)

Here is what dynamic port forwarding can be used for:

- Calling APIs in a private network through a bastion, without a separate tunnel per service.
- Browsing internal web apps in a remote network via a single jump host.
- Reaching a fleet of VPC endpoints from your laptop through one EC2 instance.

## Dynamic Remote Port Forwarding

Just like ssh -L has a dynamic sibling in ssh -D, the ssh -R command has its own dynamic mode. If you drop the fixed destination from -R and pass only a port, OpenSSH turns the **SSH server** itself into a SOCKS proxy. It's the exact mirror of -D: this time the proxy lives on the gateway, and every connection made through it is tunneled back to the ssh client and resolved from its point of view:

```text
ssh -R [bind_address:]port [user@]gateway_addr
```

The -R flag **with no destination means**:

- On the remote gateway, the SSH server starts a SOCKS proxy listening on port (on the gateway's localhost by default, or on all interfaces with GatewayPorts yes).
- Each connection made through the proxy is tunneled back to the ssh client and forwarded to whatever address the SOCKS client asks for, reached from the client's side.

It's like a regular ssh -R, but you don't have to choose a single local\_addr:local\_port upfront. One proxy on the gateway exposes every host and port reachable from the ssh client - for example, an entire home network.

![Imagem](https://pbs.twimg.com/media/HLawsvsXAAA3Uke?format=jpg&name=large)

## Summarizing

Here is a quick recap and a couple of mnemonics to help you memorize the SSH tunneling commands:

- **Local port forwarding** (ssh -L) makes a remote service available on a local port.
- **Remote port forwarding** (ssh -R) makes a local service available on a remote port.
- **Dynamic local port forwarding** (ssh -D) turns the local ssh client into a SOCKS proxy.
- **Dynamic remote port forwarding** (ssh -R with no destination) turns the sshd server into a SOCKS proxy.
- Local port forwarding (ssh -L) implies it's the ssh client that starts listening on a new port.
- Remote port forwarding (ssh -R) implies it's the sshd server that starts listening on an extra port.
- The word **local** can mean either the **SSH client machine** or an internal host accessible from it.
- The word **remote** can mean either the **SSH server machine (sshd)** or any host accessible from it.
- The mnemonics are ssh **\-L** **l**ocal:remote and ssh **\-R** **r**emote:local and it's always the left-hand side that opens a new port.

Hope the above materials helped you a bit with becoming a master of SSH Tunnels 🧙

Find the full version of the tutorial, including the hands-on exercises, at iximiuz Labs: [https://labs.iximiuz.com/tutorials/ssh-tunnels](https://labs.iximiuz.com/tutorials/ssh-tunnels)
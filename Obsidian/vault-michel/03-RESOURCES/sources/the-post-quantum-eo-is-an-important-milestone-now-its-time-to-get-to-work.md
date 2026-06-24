---
title: "The post-quantum EO is an important milestone. Now it’s time to get to work"
type: source
source: "Clippings/The post-quantum EO is an important milestone. Now it’s time to get to work.md"
created: 2026-06-23
ingested: 2026-06-23
score: D
tags: [articles, source-page]
---

## Tese central
---
title: "The post-quantum EO is an important milestone. Now it’s time to get to work"
source: "
author:
published: 2026-06-23
created: 2026-06-23
description: "The new post-quantum executive order sets a 2030 migration deadline and establishes a powerful foundation for post-quantum resilience. We look at what it gets right, where it can go further, and our migration playbook for government and industry."
tags:
  - "clippings"
---


On June 22, 2026, President Trump signed [Executive Order 144

## Argumentos principais
### The EO’s requirements for federal systems
The bulk of the EO's binding requirements are aimed at two categories of federal systems: High Value Assets (HVAs) and high impact systems. HVAs are federal information or systems [designated by OMB]() as the government's crown jewels: systems whose compromise would significantly affect national security, foreign relations, or public confidence. These include databases that hold millions of federal employee records, systems that process classified intelligence, or platforms that manage federal financial transactions. Meanwhile, high impact systems are those where confidentiality, integrity, or availability is rated "high" under [FIPS 199](), meaning a breach could cause severe harm including loss of life, major financial damage, or significant degradation of an agency's ability to carry out its mission.
The EO has the power to bind federal agencies, but not other organizations (i.e., critical infrastructure, state, local, tribal and territorial governments, academia, civil society). That’s why the EO only gives these deadlines to federal agencies:
| **Date** | **Requirement** |

### Two migrations: encryption and authentication. Both should begin now.
The EO splits the PQC migration into two phases: post-quantum key establishment (encryption) by 2030, and post-quantum digital signatures and certificates (authentication) by 2031. This accurately reflects the availability of post-quantum encryption across the Internet today. Our own [deadline]() for full post-quantum readiness (including authentication) is 2029, but we are amongst the earliest adopters in the industry.
We are also happy to see the EO focusing on [NIST-standardized post-quantum cryptographic algorithms]() and not Quantum Key Distribution (QKD), since QKD [does not operate at Internet scale]() due to its need for specialized hardware and dedicated physical links between sender and receiver.
Now let’s have a deeper look at the two migrations called for and required in the EO: post-quantum encryption and post-quantum authentication.

### Supply chain pressure that helps everyone
The EO includes requirements for federal contractors, which may turn out to be the most impactful part of the EO.
Namely, the [FAR Council]() must publish proposed rules requiring "covered contractors" to comply with NIST FIPS incorporating PQC algorithms by December 31, 2030 ([Sec. 6(c)]()). The FAR Council must also publish proposed rules requiring contractors to implement vulnerability disclosure programs that cover cryptographic vulnerabilities ([Sec. 6(d)]()). These proposed rules need to go through notice-and-comment rulemaking, but the EO has a December 31, 2030 target which is still important. This deadline is one year earlier than federal agencies are required to complete their post-quantum authentication migration, so that federal contractors will be ready before agencies hit their own deadlines.
Federal agencies can only migrate to PQC if the products they buy support PQC. To put this into practice, CISA [released]() its *Product Categories for Technologies That Use Post-Quantum Cryptography Standards*, drawing a clear line between technologies where PQC is already "widely available" versus those still "transitioning." The "widely available" list includes cloud platforms (IaaS, PaaS), web browsers and servers, chat and messaging software, and endpoint security products like full disk encryption. For these categories, CISA's guidance is clear: organizations should procure only PQC-capable products. The "transitioning" list, where PQC is not yet widely available, includes networking hardware (routers, firewalls, switches), identity and access management systems (HSMs, certificate authorities, identity providers), email servers and clients, and database systems.

### Critical infrastructure and PQ for everyone
The EO also speaks to [critical infrastructure](): energy, financial services, water, transportation, telecommunications, healthcare, and other systems whose failure would have a serious or significant impact on the country. While the EO has no hard migration deadline for critical infrastructure owners and operators, the EO directs certain federal agencies to "assist" critical infrastructure owners and operators with their PQC migration plans ([Sec. 5(a)]()).
While the EO focuses mostly on federal agencies and critical infrastructure in the U.S., post-quantum cryptography is important to every Internet-connected individual and organization. Harvest-now-decrypt-later attacks are a risk today. And after Q-Day, the risk of unauthorized access by an adversary armed with a quantum computer will impact any organization, big or small. When we [launched free universal SSL in 2014](), our CEO Matthew Prince wrote:
> Having cutting-edge encryption may not seem important to a small blog, but it is critical to advancing the encrypted-by-default future of the Internet. Every byte, however seemingly mundane, that flows encrypted across the Internet makes it more difficult for those who wish to intercept, throttle, or censor the web.

### Opportunities for OMB’s implementation guidance
The EO sets the direction, and now OMB has 90 days to provide important clarifications and operational guidance to achieve the most effective PQC migration across federal agencies ([Sec. 4(b)]()). Based on what we've learned from our own PQC migration, here are a few elements that we suggest that guidance should include:
**Define what it means to “transition.”** The EO requires agencies to "transition" their systems to PQC, but it never defines what "transition" means. Does it mean the system supports PQC algorithms? That it prefers them? Or that classical cryptography has been disabled entirely?
These are very different security postures. A system that supports ML-KEM but still allows a classical-only TLS handshake is vulnerable to [downgrade attacks](). An adversary capable of intercepting traffic could force the connection back to classical key exchange. The system would have "transitioned" to PQC in name, but still be vulnerable to the same quantum attacks the order is trying to prevent.

### What to do now: don't wait for 2030
You do not have to wait for 2030 or an exhaustive cryptographic inventory to start your migration. History has shown that updating cryptography is [hard]() and can take a [long]() [time](); other organizations should start sorting out their migrations as well. So as we wait for OMB guidance for federal agencies, here’s what we recommend for all organizations:
**Protect your Internet traffic now.** Start with traffic that crosses the public Internet, because that is the easiest for adversaries to harvest now and the most immediately at risk. If your web traffic flows through Cloudflare, your connections are largely protected with post-quantum encryption. If your enterprise network uses [Cloudflare One](), your private network traffic is also protected. If your provider doesn't support post-quantum encryption, switch to one that does. Even if the individual applications running inside your network haven't been upgraded yet, start [tunneling your traffic]() through post-quantum encrypted infrastructure to protect it in bulk, even if individual systems are not yet inventoried and upgraded.
**Update procurement.** Make "post-quantum encryption by default, at no additional cost, with a clear roadmap for post-quantum authentication and crypto agility" a requirement in every technology procurement. If your vendor charges extra for post-quantum security or doesn't have a roadmap or plan, ask why or find another vendor.

### Aligning policy and international standards
At the same time, work should also start now on aligning global government policy with international standards. We were glad to see that Section 5(b) directs the State Department to engage foreign governments and industry groups to encourage adoption of NIST-standardized PQC algorithms.
Here’s why this matters. Cryptography migrations cannot be run in a vacuum, with each country operating within its own borders. A TLS connection between a U.S. person and a server abroad only works if both ends negotiate the same cryptography. NIST has been running open international cryptographic competitions for decades. The [AES competition]() (1997-2001) produced the encryption standard used across the Internet today, selecting a cipher designed by Belgian cryptographers. The [SHA-3 competition]() (2007-2012) produced the latest hash standard, selecting an algorithm designed by a Belgian-Italian team. The [PQC competition]() (2016-2024) followed the same open model: anyone could submit, anyone could analyze, and the winning algorithms were designed by international teams. ML-KEM, the key agreement standard now being deployed across the Internet, was created largely by European cryptographers. These are open, internationally vetted algorithms. NIST organized the competitions, but the results belong to the global cryptographic community.
The risk ahead is fragmentation. If different jurisdictions mandate different algorithms, the result is cipher bloat and increased attack surface: more code to write, test, and audit, more surface for [downgrade attacks](), and slower deployment for everyone. We've [seen this happen]() firsthand in IPsec, where the lack of an interoperable standard led vendors to ship proprietary PQ key agreement algorithms that couldn’t interoperate, delaying the migration by years. The TLS community went the opposite way, converging on a single hybrid key agreement ([X25519MLKEM768]()), and deployment followed quickly.

### Speeding up CMVP
As a final note, the EO directs NIST to revise the processes used by the [Cryptographic Module Validation Program (CMVP)]() to accelerate validations of cryptographic modules ([Sec. 6(b)]()). Having bumped up against the CMVP program for years, we are extremely happy to see this in the order.
CMVP exists for a good reason. Federal agencies and their contractors need a way to verify that the cryptography inside a product actually does what it claims: that AES is implemented correctly or that random number generators have enough entropy. CMVP has been tuned for a steady state where cryptography doesn’t change much.
Going forward, CMVP needs to be adjusted to accept the realities of the impending migration. We welcome the *FedRAMP update stream* that allows updated modules to be used immediately before final validation. This allows faster adoption of post-quantum cryptography, and correction of implementation errors that were missed in validation. Similar allowances for CMVP are essential.

### Go forth and PQ all the things
This post-quantum EO is a meaningful step. It sets real deadlines and creates supply chain pressure that will accelerate adoption across the industry.
For organizations starting their own migration, we suggest you start by protecting your public Internet traffic along with updates to your procurement requirements, followed by a quantum impact inventory to figure out where to focus next. Do not let cryptography inventory slow you down from deploying post-quantum encryption across your most sensitive systems immediately.
Cryptographic deployment across the Internet depends on standards developed by the [IETF](). The TLS community [is]() [further along](), but there is lots more work to do across other protocol communities, and we look forward to supporting those efforts.


## Key insights
- The dependency chain for post-quantum authentication is longer, requiring coordinated upgrades across clients, servers, [certificate authorities](), [certificate transparency logs](), root stores, and browsers.
- There is only limited ecosystem deployment of post-quantum authentication so far, as compared to the [much broader deployment]() of post-quantum encryption.
- BLOG-3360 3

## Opportunities for OMB’s implementation guidance

The EO sets the direction, and now OMB has 90 days to provide important clarifications and operational guidance to achieve the most effective PQC migration across federal agencies ([Sec.
- The [PQC competition]() (2016-2024) followed the same open model: anyone could submit, anyone could analyze, and the winning algorithms were designed by international teams.
- If different jurisdictions mandate different algorithms, the result is cipher bloat and increased attack surface: more code to write, test, and audit, more surface for [downgrade attacks](), and slower deployment for everyone.

## Exemplos e evidências
See original source at `Clippings/The post-quantum EO is an important milestone. Now it’s time to get to work.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/security]]
- [[03-RESOURCES/entities/Cloudflare]]
- [[03-RESOURCES/entities/Rust]]

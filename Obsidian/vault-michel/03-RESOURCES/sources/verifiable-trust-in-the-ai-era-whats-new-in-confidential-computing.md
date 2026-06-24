---
title: "Verifiable trust in the AI era: What’s new in Confidential Computing"
type: source
source: "Clippings/Verifiable trust in the AI era What’s new in Confidential Computing.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [articles, source-page]
---

## Tese central
---
title: "Verifiable trust in the AI era: What’s new in Confidential Computing"
source: "
author:
  - "[[Sam Lugani]]"
  - "[[Ranjit Narjala]]"
published: 2026-06-23
created: 2026-06-23
description: "To help further strengthen verifiable privacy in cloud AI deployments, here’s our latest Confidential Computing innovations."
tags:
  - "clippings"
---
Security & Identity

## Verifiable, private AI: Google Cloud expands Confidential Computing frontiers

##### Sam Lugani

Product Lead, Confidentia

## Argumentos principais
### Verifiable, private AI: Google Cloud expands Confidential Computing frontiers
##### Sam Lugani
Product Lead, Confidential Computing, Google Cloud
##### Ranjit Narjala

### Confidential AI at global scale
By scaling our Confidential AI capabilities globally, we help ensure that AI inference and fine-tuning workloads can run with enforceable privacy guarantees.
**Democratizing Confidential AI: Confidential G4 VMs with NVIDIA RTX PRO 6000 Blackwell GPUs in preview**
We are excited to announce a landmark moment for accessible Confidential AI at global scale: [Confidential VMs]() and [Confidential GKE]() Nodes on the accelerator-optimized [G4 machine series](), featuring [NVIDIA RTX PRO 6000 Blackwell Server Edition GPUs]().

### Enabling Apple Private Cloud Compute on Google Cloud
Our commitment to privacy is deeply exemplified by our [collaboration with Apple]() to expand Private Cloud Compute (PCC) on Google Cloud.
We are proud to collaborate with Apple to extend Apple’s privacy and security commitments to PCC on Google Cloud. Our platform supports Apple’s PCC privacy commitments with a layered security approach built upon Google Cloud’s infrastructure. This includes leveraging Google Cloud Confidential Computing with [Intel TDX](), [NVIDIA Confidential Computing]() with NVIDIA Blackwell GPUs, our [Titanium security architecture]() with the Titan chip, and a co-engineered open-source host stack to ensure verifiable transparency.
Together, these technologies help Apple PCC on Google Cloud meet stringent requirements for data protection and user privacy. To dive deeper into this collaboration, read our blog post: [Powering the next era of Confidential AI]().

### Advancing confidential foundations
Google Cloud is committed to making Confidential Computing capabilities broadly available across our infrastructure. Our goal is to integrate hardware-based security features deeply into our foundational compute offerings, allowing customers to enhance data protection without compromising performance or operational flexibility.
**Bringing Intel Trusted Domain Extensions (TDX) to the C4 machine series**
Confidential VMs with Intel TDX on the C4 machine series will be available in preview soon.

### Next steps
Confidential Computing is becoming an essential layer of cloud computing in the AI era. Explore our expanding portfolio of Confidential VMs, accelerated hardware, and open-source tools to see how you can enable secure collaboration and private AI innovation within your organization.
To learn more, join us at the [Confidential Computing Summit]() on June 23 and 24, 2026.


## Key insights
- **Enabling end-to-end private inference: Open-source Prompt Encryption SDKs**

Even as we make Confidential AI accessible, we understand that protecting sensitive data in AI workloads goes beyond securing the model execution environment.
- This toolkit helps you establish an end-to-end secure channel for your AI inference workloads, ensuring that prompts are cryptographically protected from the moment they leave the client until they are processed in the TEE; model responses are similarly protected all the way back to the client.
- By decoupling attestation verification from the cloud service provider, customers benefit from enhanced transparency, stronger assurance, and a more robust trust model.

## Exemplos e evidências
See original source at `Clippings/Verifiable trust in the AI era What’s new in Confidential Computing.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/software-engineering/verification]]
- [[03-RESOURCES/concepts/llm-ml-foundations/inference]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/Gemini]]
- [[03-RESOURCES/entities/Apple]]
- [[03-RESOURCES/entities/Rust]]

## Minha Síntese
**O que muda:** Este estudo reforça que security & identity — impacta diretamente como projetar e avaliar agentes.

**Conexão pessoal:** Conecto isso ao meu trabalho com Hermes Agent e o vault-michel: preciso aplicar este padrão nos meus fluxos de ingestão e consolidação.

**Próximo passo:** Implementar um experimento prático com este conceito nos próximos ciclos de desenvolvimento do vault.
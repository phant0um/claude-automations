---
title: "Inside NVIDIA Halos for Robotics: A Full-Stack Functional Safety System for Physical AI"
type: source
source: "Clippings/Inside NVIDIA Halos for Robotics A Full-Stack Functional Safety System for Physical AI.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [articles, source-page]
---

## Tese central
---
title: "Inside NVIDIA Halos for Robotics: A Full-Stack Functional Safety System for Physical AI"
source: "
author:
  - "[[Suhas Hariharapura Sheshadri]]"
published: 2026-06-22
created: 2026-06-23
description: "Physical AI—robots working autonomously alongside people in factories, warehouses, hospitals, and homes—is arriving faster than most expected."
tags:
  - "clippings"
---
[Physical AI]() —robots working autonomously alongside people in factories, warehouses, hospitals, and homes—is arri

## Argumentos principais
### How is NVIDIA extending a proven safety stack from AVs to robotics?
NVIDIA has a deep and long-standing investment in functional safety. The company has accumulated over 18,000 engineering years on vehicle safety, assessed more than 21 billion safety transistors, and produced over 7 million lines of safety-assessed code. More than 22,000 platform safety monitors have been developed, 330+ research papers on AV safety published, and 30+ certificates and assessment reports issued.
This body of work was built for AVs, one of the most demanding safety domains in engineering. The key insight behind Halos OS is that this proven foundation doesn’t need to be rebuilt for robotics. It can be extended.
The same safety development processes (software product lifecycle, hardware development process), the same development tools with proven confidence in use, and the same foundational functional safety standards (ISO 26262 → IEC 61508, ISO 13849) are shared across the AV and robotics stacks. Third-party assessments by TÜV SÜD and TÜV Rheinland confirm compliance across both domains.

### What is NVIDIA Halos for Robotics?
NVIDIA Halos for Robotics is organized into the same full-stack comprehensive safety system that unifies safety elements from platform hardware and software across three layers similar to [NVIDIA Halos]() for AVs.
At the foundation of the Halos stack is hardware platform safety: for robotics, that is provided by the [NVIDIA IGX Thor]() platform and [NVIDIA Holoscan Sensor Bridge (HSB)]().
Building on that foundation, Halos OS is a safety software stack running on IGX Thor for robots and AMRs. Think of it as the same proven stack that keeps AVs safe on DRIVE AGX, now extended to robotics.

### NVIDIA IGX Thor provides platform safety
NVIDIA IGX Thor is an industrial-grade AI compute module that combines AI perception performance with built-in functional safety hardware—all in a single platform. Up to 2,070 FP4 TFLOPs of AI performance, 14x Neoverse ARM CPU cores, and 128 GB of memory at 273 GB/s bandwidth. This gives IGX the headroom to run demanding real-time robotics workloads alongside safety monitoring functions.
<table><tbody><tr><td></td><td><strong>Autonomous vehicles</strong></td><td><strong>Robotics</strong></td></tr><tr><td><strong>Platform safety</strong></td><td>NVIDIA DRIVE AGX, NVIDIA DRIVE Hyperion</td><td>NVIDIA IGX Thor and NVIDIA Holoscan Sensor Bridge</td></tr><tr><td><strong>Halos OS</strong></td><td colspan="2">Halos Core and Halos applications and blueprints</td></tr><tr><td><strong>Ecosystem safety</strong></td><td colspan="2"><a href=">Halos AI Systems Inspection Lab</a> – 43 members: 16 AV, 23 Robotics, 4 spanning both</td></tr></tbody></table>
*Table 1. Platform safety and ecosystem across Halos AVs and robotics*

### NVIDIA Holoscan Sensor Bridge extends functional safety capabilities
[HSB]() connects sensors and actuators to IGX over Ethernet, extending the safety chain all the way to the sensor edge. Key capabilities include:
- **Low latency:** ConnectX RDMA and RTX GPU Direct enable real-time sensor streaming
- **Scalable:** Easily scales to hundreds of sensors and hundreds of Gbit/s

### Ecosystem support for platform safety
The platform safety is supported by a growing ecosystem of partners including IGX ODM partners including Advantech, [Nexcobot](), Inventec, and [Connect Tech](). Safety MCU and sensor partners include Infineon, [NXP Semiconductors](), and Texas Instruments. HSB chip partners include Texas Instruments, [STMicroelectronics](), NXP Semiconductors, and Lattice Semiconductor.

### The Halos OS for robotics software safety environment
NVIDIA Halos OS sits between the hardware and your application, giving robotics teams the certified building blocks they need — currently Halos Core (the safety OS) and Halos Applications (safety blueprints like Outside-In Safety). Robotics middleware and Halos Infra tools are available but not yet for safety applications.
Figure 3. NVIDIA Halos OS for robotics stack on NVIDIA IGX

### The safety operating system: Halos Core
At the foundation of NVIDIA Halos OS is Halos Core, which is the next generation of NVIDIA DriveOS and certified to automotive safety standards. The software layer runs on IGX Thor. Two configurations are currently available: Halos Core Linux and Halos Core Linux plus QNX (Figure 3).
Figure 4. Halos Core configurations include Linux-only (left) and Linux plus QNX with NV Hypervisor (right)
Halos Core Linux provides a complete safe software foundation: a Linux runtime for application and compute workloads, the SEP for hardware error collection and dispatch, the Edge Safety Link safety communication protocol, FSI RTOS, and Safety MCU RTOS firmware.

### Ecosystem support for Halos OS
Halos OS ecosystem partners at this layer include [Blackberry on QNX](), [Acontis]() on EtherCAT/FSOE solution, FreeRTOS (AWS is the steward of FreeRTOS and will offer a Safety Certification Bundle as part of Halos OS), and others.
Both configurations are [available now for early access](). To learn more, see the [NVIDIA IGX Safety Product Brief]() with detailed architecture documentation available for registered developers through the NVIDIA developer portal.

### Developing functional safety agents with NVIDIA Halos OS
As part of the NVIDIA Halos OS application layer, NVIDIA has reference blueprints for developers building functional safety agents.

### Outside-in safety
[NVIDIA Halos Outside-In Safety Blueprint]() extends robot perception beyond onboard sensors. It uses external infrastructure cameras, AI perception, and safety logic to accelerate development of real-time, functional safety solutions that also maximize operational throughput.
Running on NVIDIA IGX and available as open source, it enables robots to safely operate alongside workers at higher efficiency while dynamically adapting to complex environments. It also provides documentation support for AI functional safety standards such as ISO/IEC TR 5469 and the upcoming ISO/IEC TS 22440.
Figure 5. Halos Outside-In Safety Blueprint spans industrial facility, AI safety pipeline, and digital twin validation

### Automated trailer loading reference use case
The automated trailer loading (ATL) example is a safety concept inspected by TÜV Rheinland built using NVIDIA Halos Outside-In Safety Blueprint to tackle one of the most common pain points in warehouse automation: getting autonomous forklifts to load trailers efficiently without constant safety stops.
Current inside-out systems often can’t operate freely inside trailers due to space limitations and onboard sensor detection mistakes such as misunderstanding cargo and trailer walls as obstacles. This can limit the forklift’s movement to a crawl or stopping entirely. Muting onboard safety can bring back operation efficiency inside the trailer, but doing so safely and intelligently becomes critical. That’s where outside-in safety comes in.
In the ATL example, the SIPP is implemented using the [NVIDIA VSS Blueprint]() for warehouse operations which takes in multiple camera streams, detects and tracks objects, and maps them to events against a configured region of interest around the loading area and a tripwire at the entrance of the trailer. The SDM always knows whether people are present in the loading area and whether the forklift is inside or outside the trailer.

### Ecosystem safety: The NVIDIA Halos AI Systems Inspection Lab
Safety certification is not something any single company can do alone. The [NVIDIA Halos AI Systems Inspection Lab]() is an [ANAB-accredited ISO/IEC 17020 Inspection Body](), the first worldwide program accredited for AI and functional safety in both autonomous vehicles and robotics, providing a structured pathway from design to certificate.
This process works as follows: a Partner/ODM asks the Lab to inspect the correct integration of Halos safety, AI safety and cybersecurity requirements in their product. The NVIDIA pool of safety and regulatory experts assesses the system against preassessed Halos stack elements (IGX SoM, Halos Core, and Halos Applications) and issues an Inspection Certificate and Inspection Report. The partner then takes this NVIDIA Inspection Certificate to a third-party Certification Agency—TÜV Rheinland, TÜV SÜD, SGS, exida, CERTX, or UL Solutions—to obtain final system certification.
Because the Halos elements and their integration with the end product are preassessed, partners don’t need to reevaluate the platform from scratch. They can focus their certification effort on their own application logic, dramatically reducing time and cost to certification.

### Get started with NVIDIA Halos for Robotics
To get started developing safety applications for robotics on NVIDIA IGX, [register for NVIDIA Halos Core early access]().
To start building outside-in safety agents, visit [NVIDIA/halos-outside-in-safety]() on GitHub. Developers can now use two agent skills— [warehouse-deploy]() and [halos-deploy]() —to build and run outside-in safety agents with a single prompt. These skills handle prerequisites, NGC downloads, configuration, and the NVIDIA VSS Blueprint for warehouse operations plus Halos SIL deployment automatically. This means your team can skip manual setup and start adapting [NVIDIA Halos Outside-In Safety Blueprint]() to your use case.


## Key insights
- "[[Suhas Hariharapura Sheshadri]]"
- IEC 61508 SIL 3 capable Safety Island (FSI)**: A dedicated functional safety island with up to 12K DMIPs, its own I/O, power, and clocks—physically isolated from the main compute domain
- High diagnostic coverage**: Over 22,000 safety mechanisms provide diagnostic coverage across the SoC
- IEC 61508 SC 3 systematics**: All IPs supported for safety usage are developed with SC 3 capability per IEC 61508
- Diversity and redundancy**: Multiple engines and interfaces can be paired for ASIL and SIL decomposition (GPU/CPU, GPU/PVA, CCPLEX CPU/FSI CPU)
- In-System Test (IST)**: Logic and Memory BIST across the whole SoC for latent fault coverage
- Freedom from Interference (FFI) and Dependent Failure Initiator (DFI) support**: Rich features including SMMU in CCPLEX and GPU, GFX execution watchdog, hardware Context Switch in GPU, NOC firewalls, and clock/voltage/thermal monitors
- Low latency:** ConnectX RDMA and RTX GPU Direct enable real-time sensor streaming
- Scalable:** Easily scales to hundreds of sensors and hundreds of Gbit/s
- Multimodal:** Domain-agnostic protocol supports any sensor or actuator type

## Exemplos e evidências
See original source at `Clippings/Inside NVIDIA Halos for Robotics A Full-Stack Functional Safety System for Physical AI.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/concepts/llm-ml-foundations/gpu]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/AWS]]

## Minha Síntese
**O que muda:** A ser analisado em revisão manual.

**Conexão pessoal:** A ser conectado com projetos/estudo atuais.

**Próximo passo:** Nenhum próximo passo imediato.

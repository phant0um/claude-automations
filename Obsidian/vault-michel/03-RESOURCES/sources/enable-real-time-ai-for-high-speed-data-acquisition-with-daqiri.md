---
title: "Enable Real-Time AI for High-Speed Data Acquisition with DAQIRI"
type: source
source: "Clippings/Enable Real-Time AI for High-Speed Data Acquisition with DAQIRI.md"
created: 2026-06-23
ingested: 2026-06-23
score: C
tags: [articles, source-page]
---

## Tese central
---
title: "Enable Real-Time AI for High-Speed Data Acquisition with DAQIRI"
source: "
author:
  - "[[Cara Laasch]]"
published: 2026-06-22
created: 2026-06-23
description: "When AlphaFold2 revolutionized drug discovery in 2020, its success relied entirely on the roughly 170,000 protein structures collected by scientists since 1971…"
tags:
  - "clippings"
---
When AlphaFold2 revolutionized drug discovery in 2020, its success relied entirely on the roughly 170,000 protein structures collected by s

## Argumentos principais
### A-GHOST: Making unsavable data searchable
The [High-Luminosity Large Hadron Collider]() (HL-LHC) upgrade at the European Organization for Nuclear Research (CERN) will increase the luminosity by a factor of 10 compared to the original design. To process the much higher data rates, the ATLAS detector will upgrade its current selection system. The new design will still use a two-stage selection system, however now with a bandwidth of selected events of 1 MHz (up from 100 kHz) after the first stage, and up to 10 kHz (up from 1 kHz) after the second stage going to storage. Even at this increased rate, this still implies rejecting more than 99% of all collisions in the online system.
The A-GHOST project uses DAQIRI to apply more powerful AI-driven searches to the stream that is discarded by the nominal selection path by employing efficient networking to bring the GPUs closer to the raw detector data.
The R&D effort focuses on exploring the utilization of a streaming link between the custom Field-Programmable Gate Array (FPGA)-based hardware boards planned to be used during HL-LHC, and a high performance GPU enabled processing farm. With this architecture, the R&D effort led by CERN Openlab, University of Chicago and UCL scientists will allow the real-time analysis of the full data stream by deploying powerful models like Convolutional Auto-Encoders (CAEs), temporal Convolutional Neural Networks (TCCN) and transformer-based models, which are planned to be tested with the prototype hardware.

### How DAQIRI works under the hood
DAQIRI is designed to handle high-bandwidth Ethernet data, including UDP and RoCE v2 traffic, at line rate of 100s of Gbps and higher. To achieve this, the architecture completely bypasses the Linux kernel.
By leveraging the Data Plane Development Kit (DPDK), DAQIRI provides zero-copy access, routing data directly from the NIC to the GPU’s Direct Memory Access (DMA) buffers. This kernel-bypass mechanism reduces the latency and CPU overhead typically associated with traditional network stacks, ensuring that massive instrument data streams arrive at the GPU ready for immediate processing.
NVIDIA DAQIRI Key Features:

### DAQIRI walkthrough
Start with the top-level DAQIRI settings. This establishes the raw streaming path, assigns a CPU core to manage DAQIRI, and keeps logs concise enough for deployment.
```bash
%YAML 1.2

### Bring DAQIRI to your sensor or detector
By shifting to a software-defined, AI-enabled architecture from an inflexible, hardware-centric collection paradigm, DAQIRI removes the traditional bottlenecks of scientific data acquisition. Developers can now process data in stream, run real-time AI inference at the edge, and ensure that only high-quality, AI-ready data is sent to HPC facilities for deeper analysis.
Start integrating real-time processing into your real time streaming workflows with DAQIRI today!
[Explore the DAQIRI GitHub repository]()


## Key insights
- High Throughput, Low Latency
- Achieve line rate on any interface with proper hardware and CPU/NUMA tuning
- Customized Receive Processing
- Automated packet reordering, data type conversion, and hardware-based flow steering
- Zero Memory Copy to GPU
- Direct NIC ring-buffer access (Batched and Header Data Split) to GPU tensor keeps latency at PCIe transit time
- YAML-Driven Configuration
- Optimized and customizable boilerplate network configurations for ease of deployment
- Flexible Data Movement Backends
- Linux Sockets, DPDK, and RoCEv2 support for varying application and hardware demands

## Exemplos e evidências
See original source at `Clippings/Enable Real-Time AI for High-Speed Data Acquisition with DAQIRI.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/orchestrat]]
- [[03-RESOURCES/concepts/llm-ml-foundations/transformer]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/Python]]
- [[03-RESOURCES/entities/CUDA]]

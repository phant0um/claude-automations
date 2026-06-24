---
title: "ANEForge: Python for direct computation on the Apple Neural Engine"
type: source
source: "Clippings/ANEForge Python for direct computation on the Apple Neural Engine.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [ai-agents, source-page]
---

## Tese central
ANEForge is a Python package that programs the Apple Neural Engine (ANE), the fixed-function neural accelerator on every recent Apple device, directly and without CoreML. In production the engine is reachable only through CoreML, which treats it as a scheduling option: no configuration requires the ANE, and a model can silently run on the CPU or GPU instead. ANEForge compiles a lazy tensor graph, built from 58 fused operators and 19 native bridge operators, into a single ANE program.

## Argumentos principais
### 1 Motivation and significance
The Apple Neural Engine is a fixed-function neural accelerator that ships on every recent iPhone, iPad, and Apple Silicon Mac [^1] [^2]. On the M-series Mac it draws the least power of the system-on-chip’s three programmable compute blocks for the workloads it accepts. The only sanctioned route to it is CoreML, which compiles a model and selects a compute unit at runtime [^3]. CoreML treats the engine as a scheduling option rather than a target. A caller can exclude the GPU and can inspect placement offline, per layer in Xcode’s performance reports or as the estimate it returns. But no configuration requires the ANE, the CPU remains a permitted fallback, and no runtime interface reports which unit executed a given call [^3] [^1]. A workload that the engine accepts and runs efficiently can therefore be served on a slower, less efficient unit with no diagnostic at the call site.
The ANE hardware is reached through a stack of private, undocumented Apple frameworks that CoreML, MPSGraph, and Espresso call internally (fig.˜1). That stack is the true programming surface of the engine, and it is not exposed to application code. A study of what the ANE can compute, and a frontend that targets it directly, require working at this level rather than CoreML.
Figure 1: Where ANEForge enters the system. CoreML schedules a compiled model across the CPU, the GPU, and the engine, and may serve any call on a fallback unit (dashed); ANEForge enters the same private stack at the e5rt interface and dispatches to the engine only (solid). Either way, every program is compiled and signed by Apple’s aned.

### 2.1 Software architecture
The package is organized around one path: a lazy operator graph is lowered to a single ANE program and dispatched to the hardware. The caller constructs a graph of Tensor nodes from the operator surface. The compiler lowers the whole graph to the Model Intermediate Language (MIL) that the ANE compiler consumes, packs the weights into one binary blob, and produces a callable program handle. Dispatch goes through a lower-latency C interface, e5rt, exported by Apple’s private Espresso framework, the runtime inside CoreML, into the same aned system daemon and ANE kernel driver that Apple’s own frameworks use. The program handle is reused across calls, so a model compiles once and runs many times. A small Objective-C++ shim, compiled on the user’s machine because it links private Apple frameworks, carries the dispatch; the Python package loads it lazily on the first call. Access is unentitled: the shim resolves public symbols of private frameworks at run time, holds no Apple entitlement, leaves code signing and system-integrity protection in place, and every program binary is produced and signed by Apple’s own aned.
Operator routes are constructed to feed this path. A fused MIL route spans 58 operators (54 primitives and 4 attention composites), covering convolution and transposed convolution, matrix multiplication and linear layers, the common activations and reductions, softmax, the normalization family, pooling, and attention, and lowers a whole graph into one program. A bridge route adds 19 native operators that the public toolchain does not emit, including fused attention, argmax, topk, sort, and several geometry and point-cloud layers, run as sub-programs through a graph cut. The bridge operators are drawn from a pool of 26 native hardware layer types reached by authoring the compiler’s internal network description directly, recorded in a machine-checked capability registry; a conformance test verifies that every registry entry still compiles and runs on the hardware. Table˜2 lists the operator surface.
Table 2: The operator surface a caller builds graphs from, by category. The fused route lowers these into one ANE program; the native bridge operators run as sub-programs through a graph cut. Three operators (sdpa, flatten, and local\_response\_norm, named lrn on the bridge) are route-selectable and appear on both routes; af.tune can rewrite such a bridge into the fused program. Arithmetic and comparison operators are also reached through the usual Python operators on tensors.

### 2.2 Software functionalities
The package provides the following capabilities, each validated on Apple Silicon against a NumPy or framework reference.
Graph compilation and dispatch. af.compile lowers a graph to one ANE program and returns a callable; af.input and af.image\_input declare float and uint8 input ports, the latter emitting an on-engine dequantization so raw camera or decoded-video bytes feed the model directly.
Weight compression. af.compile(…, compress=) streams int8, int4 lookup-table, or unstructured-sparse weights from the engine’s own dequantization path rather than folding them to half precision at compile time; the weight footprint drops by about 4 times for int4 and 2 for int8 (a 4096-square matmul’s weight blob shrinks from 33.6 to 8.4). Compression is off by default, and the default path’s program is byte-identical to plain half precision.

### 3 Illustrative examples
The build-then-compile-then-call pattern of LABEL:lst:pipeline runs unchanged on real models, from a small convolutional graph to the pretrained networks of table˜3. A pretrained vision model runs in two lines, and one keyword switches its weights to a streamed, on-engine-dequantized encoding (LABEL:lst:pretrained). The compress argument selects int8, int4 lookup-table, or sparse weights, accuracy-gated against a tolerance and falling back to a coarser encoding or to half precision when a layer does not meet it (section˜2.2).
[⬇]()
import aneforge as af

### 4 Impact
ANEForge provides capabilities the sanctioned route does not: a dispatch unit fixed programmatically (Xcode’s placement reports and MLComputePlan are offline developer estimates, not a runtime guarantee), native layer types the public compiler never emits, and an operator census automated at the scale of the full vocabulary. These capabilities support two kinds of study the sanctioned route cannot: a machine-checked census of which operators the engine accepts, built on the package’s conformance gate and dispatch paths, and a characterization of the engine’s speed and energy across workload regimes, which requires placing a workload on the engine and holding it there, so a measurement attributes to known silicon and not to whichever unit a runtime heuristic selected.
The package also opens work beyond measurement. On-engine training keeps the data, the gradients, and the optimizer state on the device, a substrate for research on private, on-device personalization using the lowest-power programmable compute block of the system-on-chip. The package targets research and local development, since software linking private frameworks cannot ship through the App Store. The operator surface spans inference, on-device training, and dense numerical linear algebra and spectral methods, demonstrating that fixed-iteration, static-dataflow numerical kernels compile to the engine and opening mixed-precision research on it, though the half-precision dataplane keeps the package short of a general scientific-computing backend. Weight streaming for int8, int4, and sparse encodings reduces the weight footprint by up to about 4 times on the same path.
The package is built for reuse. It depends only on NumPy at its core, a correctness corpus runs every shipped operator on the hardware as the release gate, and the frontend, optimizer, autograd module, and pretrained loaders are organized so that a user can compile and run a model, extend the operator surface against the conformance gate, or build measurement tooling on the dispatch paths, each from documented Python.

### 5 Limitations
The package calls private, undocumented Apple symbols that carry no API contract and can change between operating-system releases. A release therefore records the macOS and ANE-compiler versions it was verified against; the current release is verified on an Apple M5 Pro and an M1 Max under macOS 26.5 with ANECompiler 3520.4.1, and the operator corpus is the gate that detects a regression on a new release.
The route is interoperability research on hardware the user owns rather than a circumvention: the package holds no Apple entitlement, leaves code signing and system-integrity protection in place, and redistributes no Apple material, with the dispatch shim compiled on the user’s machine. An archived source capsule accordingly preserves the source, the corpus, and its expected outputs. Executability requires an Apple Silicon machine within the verified range, because the shim links the operating system’s resident private frameworks and the program binary comes from its ANE compiler; hosted continuous-integration runners virtualize macOS without exposing the engine, so the corpus gate runs on physical hardware.
The compute path is half precision; accumulation error stays acceptable for the validated models, but half precision sets the dataplane’s numerical reach. A full classifier-free-guidance diffusion sampling loop, for example, does not close in half precision: the guided difference it amplifies is a fraction of a percent of the signal, below the half-precision step error.

### 6 Conclusions
ANEForge gives Python direct, CoreML-free access to the Apple Neural Engine: a lazy operator graph compiles to a single ANE program and dispatches through the private framework stack that CoreML uses internally, with the compute unit fixed. The same path carries pretrained inference, native fused attention, streamed weight compression, resident decoder and optimizer state, on-engine training, and fixed-iteration numerical kernels, each validated against a reference. Call overhead sits near the engine’s dispatch floor, and ResNet-18, a sentence encoder, a Vision Transformer, and the forward pass of a Stable Diffusion U-Net run end-to-end on the hardware. The private symbols carry no API contract, so each release is verified against a recorded macOS and ANE-compiler version, with the operator set as the regression gate.
[^1]: M. Hollemans, The Neural Engine — what do we know about it?, [), 2020.
[^2]: Apple Machine Learning Research, Deploying transformers on the Apple Neural Engine, [), 2022.


## Key insights
- In production the engine is reachable only through CoreML, which treats it as a scheduling option: no configuration requires the ANE, and a model can silently run on the CPU or GPU instead.
- The only sanctioned route to it is CoreML, which compiles a model and selects a compute unit at runtime [^3].
- CoreML schedules a compiled model across the CPU, the GPU, and the engine, and may serve any call on a fallback unit (dashed); ANEForge enters the same private stack at the e5rt interface and dispatches to the engine only (solid).
- A reverse-engineering series and its training repository program the M4 engine through the private ANEClient surface [^6], and Orion reports a graph-level intermediate representation over the same private client APIs, with on-engine LLM training [^7].
- The compiler lowers the whole graph to the Model Intermediate Language (MIL) that the ANE compiler consumes, packs the weights into one binary blob, and produces a callable program handle.
- The program handle is reused across calls, so a model compiles once and runs many times.
- af.compile lowers a graph to one ANE program and returns a callable; af.input and af.image\_input declare float and uint8 input ports, the latter emitting an on-engine dequantization so raw camera or decoded-video bytes feed the model directly.
- CoreML reaches key-value-cache residency through its sanctioned stateful-model interface (MLState, macOS 15 and later) [^9]; the buffer aliasing here is lower-level and carries optimizer state over the same mechanism.
- A pretrained vision model runs in two lines, and one keyword switches its weights to a streamed, on-engine-dequantized encoding (LABEL:lst:pretrained).
- | Model | Ops $\to$ program | Agreement vs.

## Exemplos e evidências
See original source at `Clippings/ANEForge Python for direct computation on the Apple Neural Engine.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/llm-ml-foundations/llm]]
- [[03-RESOURCES/concepts/software-engineering/compiler]]
- [[03-RESOURCES/concepts/ai-agents/tool]]
- [[03-RESOURCES/entities/Apple]]
- [[03-RESOURCES/entities/AWS]]
- [[03-RESOURCES/entities/Python]]

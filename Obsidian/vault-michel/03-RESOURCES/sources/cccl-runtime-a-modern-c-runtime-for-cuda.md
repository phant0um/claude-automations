---
title: "CCCL Runtime: A Modern C++ Runtime for CUDA"
type: source
source: "Clippings/CCCL Runtime A Modern C++ Runtime for CUDA.md"
created: 2026-06-23
ingested: 2026-06-23
score: B
tags: [articles, source-page]
---

## Tese central
---
title: "CCCL Runtime: A Modern C++ Runtime for CUDA"
source: "
author:
  - "[[Piotr Ciolkosz]]"
published: 2026-06-22
created: 2026-06-23
description: "The NVIDIA CUDA Core Compute Libraries (CCCL) provides delightful and efficient abstractions for CUDA developers in C++ and Python. It features: This post…"
tags:
  - "clippings"
---
The [NVIDIA CUDA Core Compute Libraries (CCCL)]() provides delightful and efficient abstractions for CUDA developers in C++ and Python. It features:

1.

## Argumentos principais
### What is CCCL runtime?
NVIDIA CCCL runtime is a new set of idiomatic C++ APIs available starting in CUDA 13.2 that implement core CUDA functionality: stream management, memory allocation, kernel launches, and more.
The familiar NVIDIA CUDA runtime was originally developed as a convenience layer on top of the CUDA driver API. The new CCCL runtime aims to be an alternative with the same goal, but with an updated design aligned with modern C++. Figure 1, below, shows the relationship between the three CUDA API surfaces mentioned above:
Figure 1. Stack diagram of different CUDA API surfaces

### The code
Here is the classic `vectorAdd` example implemented with the new CCCL runtime APIs. If you’ve written CUDA before, the overall structure will be familiar: Focus on what’s different. Don’t try to understand everything at once, the rest of this post will walk through this example to explain the semantics and design choices behind CCCL runtime.
```cpp
#include <cuda/buffer>

### 1.) Devices and streams
Consider the creation of a stream using the CUDA Runtime API as the following code snippet shows.
```cpp
cudaStream_t stream;

### Resource ownership: Owning types and refs
Following the example of `std::string` and `std::string_view`, many CUDA objects have two types in CCCL runtime: an owning type and a non-owning type with a `_ref` suffix; `cuda::stream` owns the underlying `cudaStream_t` handle and destroys it in its destructor. The `cuda::stream_ref` holds the handle without managing its lifetime and is trivially copyable.
The `_ref` types are essential for composability with existing code. If a stream handle’s lifetime is managed elsewhere, `cudaStream_t` implicitly converts to `cuda::stream_ref`, and the raw handle can be retrieved with `.get()`. To transfer ownership, `cuda::stream::from_native_handle` wraps a raw handle into the owning type, and `.release()` relinquishes ownership back.
```cpp

### 2.) Memory allocation
```cpp
autopool = cuda::device_default_memory_pool(device);
autoA = cuda::make_buffer<int>(stream, pool, num_elements, 1);

### Buffer lifetime and deallocation
The stream passed to `make_buffer` is stored inside the buffer and used for deallocation when the buffer is destroyed. This means the buffer should generally hold the stream that corresponds to its usage, so that computation is properly ordered with deallocation. It is possible to change the stream later with `.set_stream()` or manually trigger destruction on a specific stream with `.destroy()`, but the default behavior is designed to do the right thing in the common case.
```cpp
{

### 3.) Kernel launch
```cpp
structkernel {
template<typenameConfig>

### Compile-time configuration flow
The most novel aspect of `cuda::launch` is how it moves compile-time information from the host launch site into device code through the type system. For example, notice how the block size is provided as a template argument to `cuda::distribute`, which means it is encoded in the configuration object’s type.
When the kernel accepts that configuration as its first argument, `cuda::launch` passes it through automatically. Inside the kernel, this static information is available when we compute the rank of the calling thread inside the grid:
```cpp

### Kernel functors
You may have noticed the kernel is a struct with a ` __device__ operator()` rather than a `  __global__  ` function. While `cuda::launch` supports existing `  __global__  ` functions, we also introduced kernel functors: types with a `__device__-` annotated call operator. The practical advantage is that template arguments are deduced automatically, whereas `__global__` functions used with `cuda::launch` require explicit instantiation.
```cpp
template<typenameT>

### Automatic argument transformation
`cuda::buffer ` owns its underlying allocation, but CUDA kernels can only accept trivially copyable arguments. When a buffer is passed to `cuda::launch`, it is automatically transformed to `cuda::std::span`. There is no need to manually construct the span or extract a raw pointer. The kernel signature reflects how the data is actually used on the device side.

### What’s next
This post covered the core ideas behind CCCL runtime: explicit dependencies, strong typing, asynchronous-by-default APIs, and clean interoperability with existing CUDA code. But a walkthrough of one example can only show so much.
The CCCL documentation has more detailed coverage of each API, including [additional buffer initialization modes](), [event management](), [data movement](), and advanced kernel launch features like [dynamic shared memory]() and [other launch attributes](). The CCCL runtime APIs are available in CCCL 3.2 and newer, which ships with CUDA Toolkit 13.2 and newer. See the CCCL documentation for detailed per-API availability. We’d love to hear your feedback as you try it out.


## Key insights
- They also improve composability: When multiple libraries are used, none of them need to save and restore implicit state across calls to avoid interfering with each other.
- Memory pooling and less frequent synchronization points are in most cases essential to reach maximum performance, and stream-ordered memory management composes naturally with the rest of the asynchronous programming model.
- But a walkthrough of one example can only show so much.

## Exemplos e evidências
See original source at `Clippings/CCCL Runtime A Modern C++ Runtime for CUDA.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/software-engineering/runtime]]
- [[03-RESOURCES/concepts/ai-agents/memory]]
- [[03-RESOURCES/concepts/llm-ml-foundations/kernel]]
- [[03-RESOURCES/entities/NVIDIA]]
- [[03-RESOURCES/entities/Python]]
- [[03-RESOURCES/entities/CUDA]]

---
title: "Copilot 在 JetBrains IDE：功能更新与 Claude 作为 Agent 提供方预览"
type: source
source: "Clippings/Copilot 在 JetBrains IDE：功能更新与 Claude 作为 Agent 提供方预览.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "Copilot 在 JetBrains IDE：功能更新与 Claude 作为 Agent 提供方预览"
source: "
author:
  - "[[Jialuo Gan]]"
published: 2026-06-21
created: 2026-06-23
description: "本次更新为 GitHub Copilot for JetBrains IDEs 带来了对来自 GitHub 的组织和企业级 agent 的支持，让你可以在 Copilot CLI 会话中排队和引导消息，引入了全新的 agent 调试日志摘要视图，并将 Claude 作为 agent 提供方带入公开预览。"
tags:
  - "clippings"
---
本次更新为 GitHub Copilot for JetBrains IDEs 带来了对来自 GitHub 的组织和企业级 agent 的支持，让你可以在 Copilot CLI 会话中排队和引导消息，引入了全新的 agent 调试日志摘要视图，并将 Claude 作为 agent 提供方带入公开预览。

此外，本次更

## Argumentos principais
### 支持来自 GitHub 的组织和企业级 agent Copy link
现在你可以直接在 JetBrains IDE 中使用在 GitHub 组织和企业级别定义的自定义 agent。管理员可以发布一组精选的 agent，并自动提供给组织或企业中的每个人。这让在团队中共享、标准化和治理 agent 工作流变得更加容易。
使用方法：
1. **管理员在 GitHub 中定义 agent：** 组织或企业管理员创建自定义 agent 并发布，使其对成员可用。发布后，这些 agent 会自动分发给所有符合条件的用户。

### 在请求运行时发送消息（CLI） Copy link
在 Copilot CLI 会话中处理较长的任务时，以前你必须等待响应完成或取消它。现在，你可以在请求仍在运行时发送后续消息。
当请求正在进行时，发送按钮会变为一个带有三个选项的下拉菜单：
- **添加到队列（Add to Queue）** ：将消息排队，在当前响应完成后处理。

### Agent 调试日志摘要视图 Copy link
我们增强了 Agent Debug 面板，新增了日志摘要视图，为你提供 agent 活动的整合概览，让审查和调试会话行为变得更加容易。
你可以从会话列表中选择会话名称，导航到摘要视图。它会显示该会话的聚合统计信息。
[]()

### Claude 作为 Agent 提供方进入公开预览 Copy link
Claude 作为 Agent 提供方现已进入公开预览，让你能够更灵活地选择最适合任务的 agent，而无需离开你的 JetBrains IDE。
要使用它，首先在你的机器上安装 Claude Code CLI。然后前往 **Settings > Tools > GitHub Copilot > Chat** ，设置 Claude Code CLI 路径。配置完成后，在 Copilot Chat 面板的 agent 选择器中选择 **Claude** 以启动会话。
> 注意事项：

### 模型选择器增强 Copy link
我们对模型选择器进行了多项改进：
- **`/models` 斜杠命令** ：直接打开模型选择器，同时支持 Copilot CLI 和 Claude agent。
- **更大上下文窗口选择** ：直接从模型选择器中选择更大的上下文窗口，为上下文密集型任务提供更多空间。

### 按轮次显示的 AI Credits 指示器 Copy link
本地、CLI 和 Claude agent 会话现在会显示按轮次的 AI Credits 指示器，让你在工作时更清楚地了解每一轮消耗了多少 AI Credits。
要了解更多关于 GitHub AI Credits 如何运作的信息，请参阅 [面向个人的基于用量的计费]() 和 [面向组织和企业的基于用量的计费]() 。
[]()

### 用户体验 Copy link
我们进行了多项优化，以改善 JetBrains IDE 中的日常工作流程和响应能力：
- 改进了聊天输入布局，提升可靠性
- 改进了内联聊天体验，确保在响应期间关闭时状态会重置

### 错误修复 Copy link
本次发布还包含了重要的可靠性和稳定性修复：
- 修复了每次 agent 编辑都会打开 diff 视图的问题
- 修复了可能导致设置中不显示任何补全模型的问题

### 可用性更新 Copy link
Cloud agent 现已正式可用（不再处于 `Editor Preview` 功能标志之后）。

### 立即体验 Copy link
我们鼓励你试用 [最新版本的 GitHub Copilot 插件]() 并分享你的反馈。你的意见对于我们改进和完善产品非常宝贵。

### 分享你的反馈 Copy link
你的反馈推动着我们的改进。我们很想通过以下渠道了解你的体验：
- **产品内反馈：** 使用 IDE 内的反馈选项。
- **社区反馈：** 在 [GitHub Copilot for JetBrains IDEs issues]() 中分享你的想法，或参与我们的简短 [调查问卷]() 。


## Key insights
- 添加到队列（Add to Queue）** ：将消息排队，在当前响应完成后处理。
- 用消息引导（Steer with Message）** ：让当前请求在活动工具执行完成后让步，然后立即处理你的新消息。当 agent 走错方向时，可以用它来重新引导。
- 停止并发送（Stop and Send）** ：停止当前轮次并立即发送你的新消息。
- `/models` 斜杠命令** ：直接打开模型选择器，同时支持 Copilot CLI 和 Claude agent。
- 更大上下文窗口选择** ：直接从模型选择器中选择更大的上下文窗口，为上下文密集型任务提供更多空间。
- 最近使用的模型** ：本地 agent 模型选择器现在包含一个最近使用的模型部分，让你可以快速选择最常用的模型。
- 改进了内联聊天体验，确保在响应期间关闭时状态会重置
- 通过添加更丰富的代码诊断信息改进了下一步编辑建议，以提供更好的建议
- 修复了每次 agent 编辑都会打开 diff 视图的问题
- 修复了可能导致设置中不显示任何补全模型的问题

## Exemplos e evidências
See original source at `Clippings/Copilot 在 JetBrains IDE：功能更新与 Claude 作为 Agent 提供方预览.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/GitHub-Copilot]]

## Minha Síntese
**O que muda:** Este estudo reforça que 本次更新为 github copilot for jetbrains ides 带来了对来自 github 的组织和企业级 agent 的支持，让你可以在 copilot cli 会话中排队和引导消息，引入了全新的 agent 调试日志摘要 — impacta diretamente como projetar e avaliar agentes.

**Conexão pessoal:** Conecto isso ao meu trabalho com Hermes Agent e o vault-michel: preciso aplicar este padrão nos meus fluxos de ingestão e consolidação.

**Próximo passo:** Implementar um experimento prático com este conceito nos próximos ciclos de desenvolvimento do vault.
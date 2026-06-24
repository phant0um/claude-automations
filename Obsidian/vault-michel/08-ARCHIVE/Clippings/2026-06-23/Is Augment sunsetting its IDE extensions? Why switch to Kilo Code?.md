---
title: "Is Augment sunsetting its IDE extensions? Why switch to Kilo Code?"
source: "https://blog.kilo.ai/p/is-augment-sunsetting-its-ide-extensions"
author:
  - "[[Darko]]"
published: 2026-06-22
created: 2026-06-23
description: "Augment users say they got a one-month sunset notice for the extensions. If you code in PyCharm or IntelliJ and you want autocomplete plus a capable agent without “downgrading” to a CLI, our JetBrains"
tags:
  - "clippings"
---
### Augment users say they got a one-month sunset notice for the extensions. If you code in PyCharm or IntelliJ and you want autocomplete plus a capable agent without “downgrading” to a CLI, our JetBrains

If you write code in a JetBrains IDE and you use the Augment Code extension, check your email. Extension users report they have received emails telling them Augment is [sunsetting its IDE extensions](https://www.reddit.com/r/IntelliJIDEA/comments/1tqupq4/is_anyone_else_upset_that_augment_is_sunsetting/), with about a month of notice.

## What happened

This is a different change from the one from March, when Augment [removed Next Edit and Completions](https://www.augmentcode.com/changelog/planned-march-31-sunset-for-next-edit-and-completions) in its IDE extension on non-enterprise plans. Now Augment seems to be taking a more extreme approach, shutting down its IDE extension.

**The reaction in the JetBrains community** has been pretty strong: People have been disappointed in general, and some [paid for extra credits through July 1](https://www.reddit.com/r/IntelliJIDEA/comments/1tqupq4/is_anyone_else_upset_that_augment_is_sunsetting/) just to keep the VS Code extension running until the lights go out. Another [PyCharm user](https://www.reddit.com/r/IntelliJIDEA/comments/1tu10xz/augment_code_replacament_for_pycharm/) tried Claude Code and found that the experience was not the same; they wanted to go back to having autocomplete in the editor and a chat window directly in the IDE.

**Augment’s alternative for JetBrains is the Augie CLI and Cosmos**, two tools with very different workflows. You can technically wire the CLI with a JetBrains IDE, but people are not sold on it. The recurring complaint is that the CLI is clunky and lacks the GUI they actually liked, and more than one person said they like to work directly in the IDE and review changes there.

The pricing moved at the same time. Augment’s [current Business plan](https://www.augmentcode.com/pricing) is $100 a month for up to 50 seats. The free Community plan is gone, you now have to be on a $100 plan to use the product at all. Augment also [restricted its subreddit](https://www.reddit.com/r/vibecoding/comments/1tuicvf/augment_code_decided_to_close_its_reddit_and_free/), and users say it closed its Discord too, so the places people used to discuss are mostly read-only now.

**Why is Augment doing this?** I think we should be fair about what this is. Augment is not going bankrupt or shutting down, it is moving upmarket to enterprise teams and its Cosmos agent platform, and as one commenter put it, that just makes you a different kind of customer than the one they want now. If you are an individual developer or a small team in PyCharm or IntelliJ, Augment has told you, impolitely or not, that you are not who they are building for.

## Kilo Code already has what Augment users are asking for

When we analyzed what Augment users are looking for across community threads, we saw the same short wish list coming up: People want autocomplete in the editor, an agent panel inside the IDE, a way to see and review what the agent changed, and a context engine that understands the codebase.

**Our JetBrains plugin is built around that list.** Inline Tab autocomplete runs as you type, and Kilo’s autocomplete also has a Next Edit mode that predicts multi-line edits ahead of your cursor and lets you Tab to jump and apply them. Kilo’s agent lives in a panel inside IntelliJ, PyCharm, GoLand, and the rest, and a checkpoint tracker sits at the top of the chat so you can see what changed and roll back to any point. You never have to move to a terminal to get work done.

We shipped our first [JetBrains plugin in September 2025](https://blog.kilo.ai/p/ai-coding-assistant-jetbrains-ide), and back then it was a port of our VS Code extension running through a Node.js layer.

A lot has improved since then, and the [stable plugin on the Marketplace](https://plugins.jetbrains.com/plugin/28350-kilo-code) supports every JetBrains IDE on both Community and Ultimate editions.

**Version 7:** The early reviews for our JetBrains extension have been mixed. Version 7 is the answer to most of those complaints. We rebuilt the plugin from the ground up as a [native JetBrains plugin](https://github.com/Kilo-Org/kilocode/releases) with a real Kilo tool window instead of a WebView. The plugin bundles its own Kilo CLI runtime for macOS, Linux, and Windows, which removes the Node detection that breaks the current plugin for so many people, and it handles sign-in, model selection, and permissions natively.

We have some of the world’s best engineers working on this plugin, including Kiril, who spent close to 10 years at JetBrains and knows the entire ecosystem from the inside out.

## Open source, open pricing, open models

A few months ago, we published an article [comparing](https://blog.kilo.ai/p/testing-augment-codes-new-credit) Kilo’s pricing to Augment’s pricing and found it to be several times cheaper.

Back then, people were mad at Augment constantly switching their pricing. If you do some research, you’ll see you have almost no complaints about our pricing because, well, it’s open. You know what you’re paying for. Kilo connects to more than 500 models through one gateway, and we add no markup on the provider rate when you bring your own key. You see the exact model on each request, the context window size, and the full prompt. There is no $100 floor and no expiring credit pool.

The whole plugin is also open source under Apache-2.0.

## How to switch

Install Kilo Code from the JetBrains Marketplace and you are running on the stable build in a couple of minutes. If you want the native version 7 experience, follow the [JetBrains setup guide](https://kilo.ai/docs/code-with-ai/platforms/jetbrains) to add our early access repository, and the IDE will handle updates from there. Either way you can start with free models or plug in your own API key and pay the provider directly.

Augment told its IDE users to move to a CLI or pay for an agent platform built for a totally different audience. You do not have to do either, and you do not have to leave PyCharm or IntelliJ to get back what you had. You just install a different plugin.
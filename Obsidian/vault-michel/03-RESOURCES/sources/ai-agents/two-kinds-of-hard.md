---
title: "Two Kinds of Hard"
type: source
created: 2026-06-23
updated: 2026-06-23
tags:
  - source
  - trading
  - market-making
  - strategy
  - edge
  - quantitative-finance
---

author: [[@imotw2]]
source: https://x.com/imotw2/status/2069373248974819565
published: 2026-06-23

## Central Thesis

There are two fundamentally different kinds of "hard" in trading, and they map inversely to the two ends of the speed spectrum. Fast trading (HFT, market making) is **implementation-hard** — the first-order idea is easy to state, but the wall is the thousand implementation details very few people know. Slow trading (multi-day holds, once-per-session rebalancing) is **discovery-hard** — the execution stack is much easier, but finding the edge in the first place is the real challenge, because anything obvious has already been traded away. The difficulty has to go somewhere; it just goes to different places depending on frequency.

## Key Arguments

### The Fast End: Implementation-Hard

The visibly sophisticated end of the business — HFT shops with microwave towers, colocation racks, hardware where microseconds and nanoseconds matter. People assume the real secrets must be there because the technology is hardest and the firms are most secretive.

**But the high-level concept is easy to state:** post bids and offers, earn the net spread, manage inventory, try not to be the liquidity provider when the other side knows more than you. Not difficult to follow.

What you can't do from that is build the thing. The speed, connectivity, risk system, the thousand implementation details very few people know, and essentially no one knows them all. **The first-order idea is obviously not the secret — the wall is a rough combination of the implementation and exactly what to implement.**

### The Slow End: Discovery-Hard

A strategy that rebalances once a session and holds for days has a much easier execution stack. The infra/implementation doesn't disappear, but it becomes way easier to do and usually much easier to specify. At small size, many slow signals in liquid instruments are forgiving enough that simple execution gets surprisingly close to the intended exposure.

**But the difficulty has to go somewhere else — finding the thing at all.** And that's hard in a way that often has very little to do with engineering.

What makes it hard: by the time something is worth any money, it isn't particularly visible. The obvious reasons a price moves have already been traded. You're left trying to understand something about why it moves that other people haven't worked out yet — a small and rapidly shrinking set.

### The Nature of Slow-Strategy Edges

The typical worry about slow strategies is that a high Sharpe you can't explain is probably overfit. On most candidates that's correct. But a lack of a neat explanation is not evidence by itself, neither is it disqualifying.

At this frequency there's usually much less to outrun, and something much different (and more straightforward and documented) to build. The material of an edge is usually:
- Something other people don't see
- A risk others are unwilling to warehouse
- A flow others cannot absorb
- A way of combining and sizing known effects better than the marginal competitor

An edge that survives for years is unlikely to be both obvious and easy. It may be hard to see, hard to validate, hard to size, or hard to hold through pain.

### The Liquid Middle

Strip out the tiny capacity trades and the obvious risk premia, and what remains is the liquid middle that looks and often is easy to execute at small size but is very difficult to discover.

## Key Insights

- **Difficulty is conserved; it just relocates.** Fast strategies are implementation-hard; slow strategies are discovery-hard. The total difficulty doesn't decrease — it moves from engineering to research.
- **The first-order idea is never the secret.** In market making, the concept is easy to state. The wall is implementation. In slow strategies, the execution is easy. The wall is finding the edge.
- **Obvious edges are already traded.** By the time a reason for a price move is visible, it's been captured. What remains is what other people haven't worked out yet.
- **Overfit is the correct default suspicion for unexplained high Sharpe.** But a lack of explanation alone is neither evidence nor disqualification.
- **Edges come in four flavors:** unseen, unwarehoused risk, unabsorbed flow, better combination/sizing of known effects.
- **Durability requires difficulty.** An edge that survives for years is unlikely to be both obvious and easy. It may be hard to see, hard to validate, hard to size, or hard to hold through pain.
- **The liquid middle is the hardest to discover.** Easy to execute at small size, but very difficult to find — because the obvious has been picked clean.

## Related Concepts

- [[03-RESOURCES/concepts/finance-trading/algorithmic-trading]]
- [[03-RESOURCES/concepts/finance/trading-systems]]
- [[03-RESOURCES/concepts/finance/pairs-trading]]
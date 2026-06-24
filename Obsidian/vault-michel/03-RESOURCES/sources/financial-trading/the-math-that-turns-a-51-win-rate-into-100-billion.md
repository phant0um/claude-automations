---
title: "The Math That Turns a 51% Win Rate Into $100 Billion"
type: source
category: financial-trading
source: "https://x.com/thedelost/status/2065849372592537803"
created: 2026-06-16
ingested: 2026-06-16
tags: [quant, renaissance-technologies, medallion-fund, edge]
---

# The Math That Turns a 51% Win Rate Into $100 Billion

## Tese Central

Renaissance Technologies' Medallion Fund averaged 66% annual returns with only 50.75% trade accuracy: the math of edge compounding turns a marginal win rate into astronomical returns through volume and decorrelation.

---

## Conteudo Original

![Image](https://pbs.twimg.com/media/HKtc3nNWsAA8Hkp?format=jpg&name=large)

Renaissance Technologies was right on 50.75 percent of its trades. Barely more than a coin flip.

And yet the Medallion Fund averaged 66 percent gross annual returns from 1988 to 2018, producing over a hundred billion dollars in total profit. Thirty years. Not a single losing year. The best track record in the history of financial markets.

Most people hear that win rate and assume the returns come from massive leverage or inside information. Neither explains it. What explains it is three formulas that have been publicly available for decades, that connect into a single system, and that almost nobody in retail has ever been taught to use together.

**Expected Value. Kelly Criterion. Law of Large Numbers.**

The first is from 1654. The second from 1956. The third has been proven since 1713. Nothing here is new. Nothing is hidden. This article walks through each one, shows how they connect, and why that connection is the difference between a coin flip and a hundred billion dollars.

## Part 1: Expected Value

Every trade you will ever take has a number attached to it. Not a gut feeling, not a thesis, not a chart pattern. A number.

**EV = (P\_win × W) - (P\_loss × L)**

P\_win is your probability of winning. W is how much you make when you win. P\_loss is your probability of losing. L is how much you lose when you lose. If your expected value is negative, nothing else matters. Not your risk management, not your psychology, not your discipline. A negative EV system will grind your account to zero given enough trades. Math does not negotiate.

This is the part most traders never internalize. They evaluate each trade in isolation. "Will this one work?" That question is meaningless in a quantitative framework. The only question that matters is: across the next ten thousand times I take this exact setup, does the math produce a positive number?

A quant desk running fifty thousand trades per day at fifteen cents of expected value per trade generates seven hundred fifty thousand dollars daily. Not from one brilliant call. From a tiny edge, measured precisely, applied at scale.

The concept is older than modern finance. Pascal and Fermat developed it in 1654 in letters about gambling problems. Three hundred seventy two years later it remains the foundation of every quant operation on earth. Renaissance, Jane Street, Two Sigma, Citadel, AQR. Every single one.

![Image](https://pbs.twimg.com/media/HKsqoxRXEAANLt5?format=png&name=large)

**Retail asks:** will this trade make money?

**The quant asks:** does this trade have positive expected value across a statistically significant sample?

That change in the question is the entire difference between gambling and a business.

## Part 2: Kelly Criterion

Finding positive expected value is half the problem. The other half is sizing, and this is where most traders with a real edge go broke.

Bet too small and your edge compounds so slowly that fees eat it alive. Bet too large and a perfectly normal drawdown wipes you out before the edge has time to express itself. This is not theoretical. It is the most common way traders with genuine edges blow up. They find something real, size up aggressively, hit a losing streak within normal variance, and lose everything. The edge was real. The sizing killed it.

In 1956, John Kelly at Bell Labs solved this with one formula:

**f\* = (p × b - q) / b**

f\* is the optimal fraction of your capital to risk. p is your win probability. q is your loss probability. b is your win-to-loss ratio. Kelly produces the exact position size that maximizes long-term geometric growth. Bet this fraction and you compound at the fastest possible rate. Bet more and your growth rate actually decreases. Go far enough above Kelly and you are mathematically guaranteed to go broke, even with a positive edge.

The curve peaks at Kelly optimal and drops to ruin on the right side.

Most retail traders live on the right side of that curve without knowing it exists.

![Image](https://pbs.twimg.com/media/HKsq4TzWcAAHI78?format=png&name=large)

This is why every major fund runs small positions across many instruments rather than large concentrated bets. A 51 percent edge with Kelly sizing across five hundred independent positions compounds into something no single bet could produce.

Edward Thorp used Kelly to size every trade at Princeton-Newport Partners. Nineteen years without a single losing year. When asked what he considers the most important formula in his toolkit, Thorp does not name his models or signals. He names Kelly. Because without correct sizing, even a perfect signal produces ruin.

AQR, PDT Partners, Two Sigma, Bridgewater all run variations. Most use half-Kelly for safety, accepting slower compounding for a smoother equity curve. The core math is identical across all of them and has been public since 1956.

## Part 3: Law of Large Numbers

This is the part that breaks intuition and explains why quant trading works at all.

Take a system with 51 percent win rate and one-to-one risk-reward. After a hundred trades, your result is indistinguishable from noise. You could be at 45 wins or 57. The variance is so large relative to the edge that you cannot tell whether your system works or you got lucky. After a thousand trades, the curve starts separating from zero. The edge is emerging but still fragile.

After ten thousand trades, it is over. The positive EV line has pulled away permanently. Variance has been overwhelmed by the mean. The Law of Large Numbers has done what it always does: as independent trials increase, the observed average converges to the true expected value. Not approximately. Mathematically.

![Image](https://pbs.twimg.com/media/HKsrNwnXIAAk3KC?format=png&name=large)

This is why Renaissance makes millions of trades. Why Jane Street runs fifty thousand executions daily. Why Two Sigma automates everything. They are not trying to be right on any individual trade. They are trying to be right on average across a sample large enough that the average becomes destiny.

This is also why retail fails even with real edges. Three to five trades per week is roughly two hundred per year. At that frequency, a 51 percent edge needs years to separate from noise. Most traders abandon real edges because the math has not had time to converge, and they have no framework to understand why.

## Part 4: The Machine

The three formulas are not separate tools. They are one system.

Expected Value tells you whether a trade is worth taking. Kelly tells you how much to risk. Law of Large Numbers tells you how many repetitions before the edge becomes inevitable. EV is the engine. Kelly is the transmission. Frequency is the fuel. Remove any one and nothing works.

Renaissance measured EV precisely, sized with Kelly, and repeated the process millions of times across thousands of instruments. That combination over thirty years produced more wealth than almost any other operation in financial history.

Jim Simons has spoken about this publicly. Thorp wrote books about it. Kelly published in an open journal in 1956. The Law of Large Numbers is in every introductory stats textbook ever printed. The information has been available for decades.

The gap was never access to the math. The gap was that nobody told retail to connect the three pieces and apply them with the frequency required for convergence.

**Three formulas. All public. All old. All free. The edge was never hidden. It was sitting in a textbook the entire time.**

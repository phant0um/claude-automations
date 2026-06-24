---
title: "Quant Mentality: How to Use Neural Networks to Outplay Hedge Funds"
source: "https://x.com/Skynet_insights/status/2068694425799196902"
author:
  - "[[@Skynet_insights]]"
published: 2026-06-21
created: 2026-06-22
description: "I've spent the last few months going deep on how the best quant funds actually use machine learningRenaissance returned 66% annually for 30 ..."
tags:
  - "clippings"
---
![Image](https://pbs.twimg.com/media/HLV6k0IXgAAqfQb?format=jpg&name=large)

I've spent the last few months going deep on how the best quant funds actually use machine learning

Renaissance returned 66% annually for 30 years

Two Sigma runs 10,000+ live signals through ML models simultaneously. The entry-level researcher building these systems earns $650,000 a year

In this article I'm breaking down how neural networks extract edge before the trade even happens and the complete framework you can build today

Every formula, every line of code

Let's get into it

## PART 1 - WHAT A NEURAL NETWORK ACTUALLY COMPUTES

Most people think a neural network predicts the future.

It doesn't. And understanding why changes everything.

A neural network learns the expectation function hidden inside historical data. The mathematical relationship between what you can observe right now and what the market is statistically most likely to do next.

![Image](https://pbs.twimg.com/media/HJwqTOLWMAIUikA?format=jpg&name=large)

The formal structure

$$
y^=fL(σ(fL−1(σ(⋯f1(x)))))\hat{y} = f_L(\sigma(f_{L-1}(\sigma(\cdots f_1(x)))))
$$

In plain English: you feed the network a vector of inputs - price returns, volume, volatility ratios. The network applies a sequence of transformations to those inputs, each one extracting a more abstract pattern than the last. The final output is a single number: the model's estimate of what comes next.

The W\_i matrices and b\_i vectors are the learnable parameters. The σ is a non-linear function - typically ReLU or sigmoid - applied after each layer. Without non-linearity, stacking layers does nothing. The network would still be a linear model. Non-linearity is what allows it to approximate complex, curved relationships in data.

Training is the process of minimizing a loss function. For regression:

$$
L(θ)=1n∑i=1n(yi−y^i(θ))2L(\theta) = \frac{1}{n} \sum_{i=1}^{n} (y_i - \hat{y}_i(\theta))^2
$$

This measures how wrong the model is on average across all training examples. y\_i is what actually happened. ŷ\_i is what the model predicted. The squared difference penalizes large errors more than small ones. θ represents every learnable parameter in the network - all the weights and biases across all layers.

To reduce this loss, the model computes the gradient - the direction in parameter space that increases the loss - and takes a step in the opposite direction:

$$
θ←θ−α⋅∇θL(θ)\theta \leftarrow \theta - \alpha \cdot \nabla_\theta L(\theta)
$$

α is the learning rate. Too large and the model overshoots. Too small and training takes forever. This step repeats millions of times. Each iteration, the model gets slightly better at predicting the training data.

Here's the insight that changes how you interpret everything a neural network produces:

When you minimize squared error against a target variable, the function you learn is exactly:

$$
f∗(X)=E[Y∣X]f^*(X) = \mathbb{E}[Y|X]
$$

The conditional expectation. Not a prediction of the next specific outcome. The weighted average outcome across all scenarios consistent with the observed inputs.

Train on 10,000 dice rolls and the model predicts 3.5. Can a die land on 3.5? No. But 3.5 is the value that minimizes expected squared error. The network is computing the expectation, not the next realization.

The model is right. Most traders are asking it the wrong question.

Prediction markets are the cleanest laboratory for testing this framework. Every contract resolves at exactly $1 or $0. Every price is a probability estimate. Every resolved market is a ground truth data point.

$28 billion traded. 9,000+ active markets across crypto, politics, sports, and macro.

## PART 2 - WHY EVERYONE FAILS AT PRICE PREDICTION

The failure: take 500 days of closing prices, feed them into a model, ask it to predict day 501.

In-sample: smooth predictions close to actual prices.

Out-of-sample: model predicts something roughly constant while prices go anywhere.

This is not a model failure. It is a data distribution failure.

Recall from Part 1: the network learns E\[Y|X\], the conditional expectation of Y given the inputs X. This is only meaningful if the relationship between X and Y is stable over time. If that relationship shifts - if the same inputs now produce different outputs than they did historically - the model is fitting a moving target.

Financial price series are non-stationary. The distribution governing returns in 2008 is structurally different from 2021. Mean, variance, autocorrelation, and tail behavior all shift across regimes. A model trained on 2015-2019 data learns the conditional expectation structure of that period. When the regime shifts in 2020, it's wrong in a systematic way.

The solution is feature engineering to produce near-stationary inputs.

Log returns over multiple windows:

$$
rt=ln⁡(Pt/Pt−k)k∈{1,5,20}r_t = \ln(P_t / P_{t-k}) \quad k \in \{1, 5, 20\}
$$

Instead of using raw price - which drifts upward over time and has no stable mean - you use the log return. This is the percentage change in price expressed as a natural log. It's mean-reverting, roughly symmetric, and stationary across most market conditions. Computing it over multiple windows (1 day, 5 days, 20 days) captures short, medium, and long-term momentum simultaneously.

Volatility ratio:

$$
vol_ratio=σshort/σlong)\text{vol\_ratio} = \sigma_{\text{short}} / \sigma_{\text{long}})
$$

This is short-term realized volatility divided by long-term realized volatility. When the ratio is above 1, the market is more volatile now than its recent average - a regime signal. When below 1, conditions are calm relative to history. This ratio is more stable than either volatility measure alone because it's relative, not absolute.

Volatility-normalized momentum:

$$
momentum=rt/σt\text{momentum} = r_t / \sigma_t
$$

A 2% return means something very different in a 0.5% daily volatility regime versus a 3% daily volatility regime. Dividing return by volatility produces a signal that is comparable across regimes - essentially a z-score of return relative to current market conditions.

Volume z-score:

$$
zV=(Vt−μV)/σVz_V = (V_t - \mu_V) / \sigma_V
$$

Raw volume is non-stationary - it trends upward as markets grow. The z-score normalizes volume against its recent rolling mean and standard deviation, producing a signal that measures whether today's volume is unusually high or low relative to recent history.

![Image](https://pbs.twimg.com/media/HJwq4lqWMAATSup?format=jpg&name=large)

## PART 3 - THE LSTM ARCHITECTURE

Market data is sequential. What happened in the last five minutes is connected to what happens next through autocorrelation, momentum, mean reversion, and microstructure dynamics.

![Image](https://pbs.twimg.com/media/HJwq9y3WIAA1c7v?format=png&name=large)

A standard feedforward network treats every input independently. When you present it with today's feature vector, it has no knowledge of what the last 50 days looked like. For time series data, this throws away the most important information in your datase

The Long Short-Term Memory network solves this with a gated memory architecture. Rather than a single hidden state, the LSTM maintains both a hidden state h\_t (working memory) and a cell state c\_t (long-term memory). Three learned gates control what information flows through.

Forget gate:

$$
ft=σ(Wf⋅[ht−1,xt]+bf)f_t = \sigma(W_f \cdot [h_{t-1}, x_t] + b_f)
$$

This gate decides what fraction of the previous cell state to keep. The output is between 0 and 1 for every element. 0 means completely forget this, 1 means keep everything. When a market transitions from one regime to another, the forget gate allows the model to release outdated patterns and reset its understanding. It learns when to let go of history.

Cell state update:

$$
ct=ft⊙ct−1+it⊙gtc_t = f_t \odot c_{t-1} + i_t \odot g_t
$$

The cell state is updated by forgetting part of the old state (first term) and adding new information (second term). The ⊙ symbol means element-wise multiplication. This is the core of LSTM's long-term memory - the cell state can carry information across hundreds of time steps without it being lost to the vanishing gradient problem that breaks basic RNNs.

Output:

$$
ht=ot⊙tanh⁡(ct)h_t = o_t \odot \tanh(c_t)
$$

![Image](https://pbs.twimg.com/media/HJwrMNIX0AAl-4l?format=jpg&name=large)

The hidden state - what the model exposes as its current working memory - is a filtered version of the cell state. The output gate decides what part of the long-term memory is relevant right now.

The practical result: the model can learn that a volatility compression pattern three weeks ago predicts a specific breakout behavior today. No indicator-based system captures relationships at that complexity or that timescale.

```text
import torch
import torch.nn as nn

class TradingLSTM(nn.Module):
def __init__(self, input_size, hidden_size=64,
num_layers=2, dropout=0.2):
super().__init__()
self.hidden_size = hidden_size
self.num_layers = num_layers
self.lstm = nn.LSTM(
input_size=input_size,
hidden_size=hidden_size,
num_layers=num_layers,
dropout=dropout,
batch_first=True
)
self.dropout = nn.Dropout(dropout)
self.fc = nn.Linear(hidden_size, 1)
self.sigmoid = nn.Sigmoid()

def forward(self, x):
h0 = torch.zeros(self.num_layers, x.size(0), self.hidden_size)
c0 = torch.zeros(self.num_layers, x.size(0), self.hidden_size)
out, _ = self.lstm(x, (h0, c0))
return self.sigmoid(self.fc(self.dropout(out[:, -1, :])))
```

The lookback window - how many time steps you feed into the model at once - is a critical hyperparameter. For daily strategies, start with 10 to 20 trading days. For intraday strategies on 5-minute bars, 24 periods covers two hours of context. Determine the optimal window empirically through validation performance.

## PART 4 - TRAINING WITHOUT DECEIVING YOURSELF

Building the model is easy. Evaluating honestly whether it learned something real is where almost everyone fails.

Overfitting is the central failure mode. An overfit model found patterns in its training data that don't generalize to new data. On training data it performs perfectly. On new data it performs at chance or worse. The problem: overfit in-sample performance looks identical to genuine edge. You cannot distinguish them by looking at training metrics alone.

![Image](https://pbs.twimg.com/media/HJwrXGwXYAIn7bY?format=jpg&name=large)

The solution is a strict three-way sequential data split.

Training set is where gradient descent runs. The model sees this data repeatedly and adjusts parameters based on it. Never evaluate generalization on this set.

Validation set is data the model never trains on. Monitor validation loss after every epoch. The moment validation loss stops improving and begins increasing while training loss continues falling - you've found the overfitting threshold. Stop training immediately. Save the weights from the epoch with the lowest validation loss. This is early stopping.

Test set is data the model has never influenced in any form. Use it exactly once - after all architecture decisions, feature engineering decisions, and hyperparameter choices are finalized using the training and validation sets. The test set result is your honest estimate of live performance. Using it to make additional design decisions invalidates it permanently.

These splits must be sequential in time. The training period comes first. The validation period follows. The test period is most recent. Randomizing the split would allow future information to contaminate training - a form of lookahead bias that guarantees your backtest looks better than live performance.

```text
def train_model(model, train_loader, val_loader, patience=10):
optimizer = torch.optim.Adam(model.parameters(), lr=0.001)
criterion = nn.BCELoss()
best_val_loss = float('inf')
best_weights = None
patience_counter = 0

for epoch in range(100):
model.train()
for X_batch, y_batch in train_loader:
optimizer.zero_grad()
loss = criterion(model(X_batch).squeeze(), y_batch)
loss.backward()
torch.nn.utils.clip_grad_norm_(model.parameters(), 1.0)
optimizer.step()

model.eval()
val_loss = sum(
criterion(model(X).squeeze(), y).item()
for X, y in val_loader
) / len(val_loader)

if val_loss < best_val_loss:
best_val_loss = val_loss
best_weights = model.state_dict().copy()
patience_counter = 0
else:
patience_counter += 1
if patience_counter >= patience:
print(f"Early stopping at epoch {epoch}")
break

model.load_state_dict(best_weights)
return model
```

Gradient clipping (clip\_grad\_norm\_ with max\_norm=1.0) is included for a specific reason. LSTM gradients can explode during training when learned sequences are long. Clipping the gradient norm prevents this without significantly affecting convergence.

Expected directional accuracy for a well-built model: 52 to 57 percent.

That sounds unremarkable. It isn't. A 54% directional signal with Sharpe ratio above 1.0, applied consistently across hundreds of trades with Kelly-derived position sizing, compounds into returns that outperform most discretionary traders over a multi-year horizon. The edge is in consistency and scale, not individual trade magnitude.

## PART 5 - FROM SIGNAL TO LIVE POSITION

A neural network signal alone is not a trading strategy. You need position sizing.

The Kelly criterion gives you the mathematically optimal fraction of capital to bet on any given trade for maximum long-run growth:

$$
f∗=p⋅b−qbf^* = \frac{p \cdot b - q}{b}
$$

Where p is your estimated win probability, q is 1 - p (probability of losing), and b is the net odds - how much you win relative to how much you risk. On a Polymarket contract priced at 30¢, b = 0.70/0.30 = 2.33. You win $2.33 for every $1 risked.

If your model says 40% win probability on that contract:

f\* = (2.33 × 0.40 - 0.60) / 2.33 = (0.932 - 0.60) / 2.33 = 14.2% of bankroll.

In practice, use half Kelly:

$$
flive=0.5×f∗f_{\text{live}} = 0.5 \times f^*
$$

The reason: your probability estimate p carries uncertainty. Standard Kelly treats it as ground truth and systematically overbets. Half Kelly gives up roughly 25% of long-run growth rate but cuts maximum drawdowns by more than half. That tradeoff is always worth making.

![Image](https://pbs.twimg.com/media/HJwrqVcWIAArnF4?format=jpg&name=large)

Never risk more than 2% of capital per signal regardless of what Kelly recommends

Before you automate any of this - spend time developing intuition for how correlated markets behave together in real time. The patterns you notice manually become the most valuable features in your model.

The fastest way to build that intuition is combining multiple Polymarket markets into single positions and watching how they move together. PolyParlay is the first Telegram bot that lets you do exactly this - parlay any Polymarket markets across politics, sports, crypto, and macro into one position.

Every time you notice a correlation in a parlay - Iran ceasefire and oil price, Fed decision and Bitcoin, UCL result and sentiment - that's a potential stationary feature worth testing in your model. Manual intuition feeds the machine.

Monitor the KS statistic comparing live predictions to historical validation. When it exceeds 0.1 - retrain on the most recent 90-day window. For prediction markets specifically, retrain every 30 days minimum. Regime shifts here are more frequent and more violent than in equity markets.

## SUMMARY

Neural networks don't give you a crystal ball.

They give you a systematic, mathematically rigorous framework for extracting the conditional expectation of market behavior from historical data.

When features are stationary, architecture matches sequential data, training is disciplined with proper validation, and signals are sized with Kelly - the result is edge that is consistent, scalable, and reproducible.

Renaissance built the highest-returning fund in history on this framework.

Two Sigma runs 10,000 simultaneous signals through it.

The quant researcher building it earns $650,000 a year.

The mathematics is learnable.

The code is buildable in a weekend.

The only separator is knowing the correct framework and following it without cutting corners.

Now you know the framework.
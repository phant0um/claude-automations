---
title: "MCP連携は不要！Obsidian×AIをフォルダ指定のみでバリバリに使い倒す方法"
type: source
source: "Clippings/MCP連携は不要！Obsidian×AIをフォルダ指定のみでバリバリに使い倒す方法.md"
created: 2026-06-23
ingested: 2026-06-23
score: A
tags: [ai-agents, source-page]
---

## Tese central
---
title: "MCP連携は不要！Obsidian×AIをフォルダ指定のみでバリバリに使い倒す方法"
source: "
author:
  - "[[@minami_freeup]]"
published: 2026-06-23
created: 2026-06-23
description: "Obsidian×AIで調べたら、MCP連携の記事しか出てこなかった人。「設定が複雑そうだし、プラグインも要るのか、、、」って止まってる人。わかります。わかりすぎます、、、調べれば調べるほど「ちゃんと設定しないと使えないのかな」って思いますよね。でも結論から言うと、私はMCP連携..."
tags:
  - "clippings"
---


Obsidian×AIで調べたら、MCP連携の記事しか出てこなかった人。

「設定が複雑そうだし、プラグインも要るのか、、、」って止まってる人。

わかります。わかりすぎます、、、

調べれば調べるほど「ちゃんと設定しないと使えないのかな」って思いますよね。

でも結論から言うと、私はMCP連携してません。 3ヶ月ちょい、フォルダ指定だけでOb

## Argumentos principais
### そもそもMCP連携って何
MCP（Model Context Protocol）は、AIとObsidianの間に専用の橋を架ける仕組み。 Obsidian側にプラグインを入れて、AIがObsidianの内部機能を直接叩けるようにします。
**MCP連携でできること：**
- Obsidianの検索インデックスをAIから直接使える（タグ検索・全文検索がObsidianの精度で動く）

### フォルダ指定だけで3ヶ月やってること
一方でフォルダ指定は、VaultのフォルダパスをAIに教えるだけ。 設定もプラグインも要らない。
Codexの画面ですが、Claude CodeもCoworkもCursorも同じです！
MCP連携なしで私がやってること：

### フォルダ指定で使い倒す方法
ここから具体的な「やること」を出します。 フォルダを開くだけだと、AIは何していいかわからない。 「ここで何をどう動くか」を伝える仕組みが要ります。
やることは3つだけ。
やること1：Vaultのフォルダをそのまま開く

### 毎朝のX記事はこうやって作ってる
フォルダ指定＋3ファイルで、実際にどう動くか。 朝のX記事を例に見せます。
**私が言うこと：** 「明日のX記事作って」
**AIが勝手にやること：**

### じゃあMCP連携はいつ要るのか
ここは正直に出します。
**MCP連携じゃないとできないこと：**
- Obsidianのグラフビュー（ノート同士のつながり）をAIに解析してもらう

### さいごに
「Obsidian×AI」で調べると、MCP連携の記事がほんっとに多いんですよね。
設定も複雑で、「ここまでやらないと使えないのか」って思うかもしれない。
でもフォルダ指定＋3つのファイルだけで、3ヶ月毎日回せてます。


## Key insights
- Obsidianの検索インデックスをAIから直接使える（タグ検索・全文検索がObsidianの精度で動く）
- Dataviewクエリの結果をそのままAIに渡せる
- バックリンクやグラフのつながりをAIが読める
- Canvas・テンプレート展開などプラグイン機能をAIから操作できる
- 毎日のX記事作成（ルール・スキル・過去記事を参照して書いてもらう）
- 発信振り返り（Xアナリティクスと過去記事を照合）
- スキル（AIへの作業手順書）の新規作成・修正
- Claude Code**：ターミナルでVaultフォルダに移動してClaude Codeを起動する。Vaultが作業フォルダになる
- Codex**：設定ファイル（codex.json）にVaultのパスを書く。Codexがそこを読み書きする
- Cursor**：VaultフォルダをCursorで「フォルダを開く」から開く。ワークスペースになる

## Exemplos e evidências
See original source at `Clippings/MCP連携は不要！Obsidian×AIをフォルダ指定のみでバリバリに使い倒す方法.md` for detailed examples, data, and benchmarks.

## Implicações para o vault
Links to existing concepts in vault.

## Links
- [[03-RESOURCES/concepts/ai-agents/agent]]
- [[03-RESOURCES/entities/Claude]]
- [[03-RESOURCES/entities/Obsidian]]
- [[03-RESOURCES/entities/Codex]]

## Minha Síntese
**O que muda:** Para usar Obsidian com AI, MCP não é necessário — folder path + 3 files (rules, skills, past output) é suficiente para 3 meses de operação diária, desde que o agente saiba o que fazer na pasta.

**Conexão pessoal:** Valida que a abordagem do vault (folder-first, MCP como camada opcional) é pragmática — Claude Code apontado para o diretório do vault já funciona sem plugins complexos.

**Próximo passo:** Manter MCP como opcional no vault e focar em melhorar os 3 arquivos de contexto (regras, skills, output template) que o agente usa.

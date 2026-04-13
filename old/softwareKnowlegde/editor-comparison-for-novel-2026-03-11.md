# 小説用エディタ比較メモ

更新日: 2026-03-11

前提:
- このワークスペースは Markdown ベースで管理している
- 目的は「小説を見やすく書く・読む」「関連メモをつなぐ」「できれば draw.io も開く」
- 主に Windows デスクトップ利用を想定

## 先に結論

一番バランスがいいのは **Obsidian** です。  
理由は、Markdown フォルダをそのまま使えて、ノート間リンク・全文検索・Canvas が強く、小説の設定資料やプロット整理と相性がいいからです。

ただし、**draw.io まで安定して同じアプリ内で完結したいなら VS Code の方が強い** です。  
VS Code には `Draw.io Integration` 拡張があり、`.drawio` / `.drawio.svg` / `.drawio.png` を直接開いて編集できます。

なのでおすすめは次の2択です。

1. **小説中心なら Obsidian**
2. **draw.io も同じ場所で強く扱いたいなら VS Code**

## 候補ごとの評価

| ツール | 小説閲覧のしやすさ | 長編管理 | Markdown相性 | draw.io | 向いている使い方 |
| --- | --- | --- | --- | --- | --- |
| Obsidian | 高い | 高い | 非常に高い | 条件付き | 設定資料、プロット、章管理を1つの Vault で回す |
| VS Code | 中 | 中 | 高い | 強い | Markdown と図を同じワークスペースで管理 |
| Typora | 非常に高い | 低〜中 | 高い | 弱い | 「読む」「整える」に特化 |
| Zettlr | 高い | 中〜高 | 高い | 弱い | 学術寄りだが長文管理はしやすい |
| Scrivener | 高い | 非常に高い | 低め | 弱い | 小説専用機として使う |

## 各候補の短評

### 1. Obsidian

一番おすすめです。

良い点:
- ローカル Markdown フォルダをそのまま使える
- ノートリンク、バックリンク、タグ、全文検索が強い
- **Canvas** が標準であり、プロットや人物相関の整理に向く
- PDF なども Vault にまとめやすい

弱い点:
- 文章そのものの「読みやすい紙面感」は Typora に一歩譲る
- draw.io は標準機能ではない

draw.io について:
- Obsidian 公式には **Canvas** がある
- draw.io 統合プラグインは存在するが、確認できた範囲では **2026-02-02 時点でも公式 Community Plugins には通っていない** という開発者投稿がある
- つまり、使えはするが **VS Code ほど標準的・安定的な選択肢とは言いにくい**

判断:
- **小説・設定・メモ・構成をまとめる主アプリ** に向いている

### 2. VS Code

draw.io 条件があるならかなり有力です。

良い点:
- Markdown 周りがかなり強い
- 見出し参照、リンク補完、画像プレビュー、リネーム時のリンク更新などがある
- **Draw.io Integration** 拡張で draw.io ファイルを直接扱いやすい
- ワークスペース全体のファイル管理は非常に強い

弱い点:
- 小説を「読む」「没入して推敲する」感覚は専用ライター系より弱い
- UI が執筆向けというより開発向け

判断:
- **図もテキストも1つの作業場で扱いたい人向け**
- 「小説専用」ではないが、実務的にはかなり便利

### 3. Typora

**読む体験だけならかなり強い** です。

良い点:
- ライブプレビューが自然で、Markdown 記法のノイズが少ない
- 長文を通して読むときに見やすい
- テーマ変更で読み味を調整しやすい

弱い点:
- プロジェクト管理、ノートリンク、資料整理は弱い
- draw.io 統合は期待しにくい
- モバイル展開も弱い

判断:
- **執筆・推敲用の読みやすいエディタ** としては良い
- ただし主力管理ツールにはなりにくい

### 4. Zettlr

Obsidian と Typora の中間です。

良い点:
- 長文・プロジェクト単位の文章管理がしやすい
- 日本語ドキュメントもあり、Markdown ベースで扱いやすい
- 論文寄り機能が強いが、長編原稿にも流用しやすい

弱い点:
- 小説向けの視覚整理やエコシステムは Obsidian ほど強くない
- draw.io 連携は弱い

判断:
- **落ち着いた長文執筆環境** が欲しいなら候補
- ただしこのワークスペース用途なら Obsidian の方が合いやすい

### 5. Scrivener

「小説を書く」だけを考えると今でも強いです。

良い点:
- 章・シーン分割、アウトライン、コルクボード、メタデータ管理が強い
- 長編小説向け機能がよく揃っている

弱い点:
- Markdown ワークスペースとの相性は弱め
- draw.io を一緒に扱う用途には向かない
- 今の `novel` ワークスペースの運用とは少しズレる

判断:
- **別世界で小説を書き切る専用アプリ** としては良い
- 既存の Markdown 資産を活かす前提なら優先度は落ちる

## あなた向けのおすすめ

今回の条件だと、優先順位はこうです。

### 第一候補: Obsidian

向いている理由:
- 小説本文だけでなく、設定、メモ、人物、世界観、断片アイデアをまとめやすい
- Vault 単位で作品管理しやすい
- Canvas で構造整理もできる

向かないケース:
- draw.io を日常的に強く編集したい

### 第二候補: VS Code

向いている理由:
- Markdown 管理が堅い
- draw.io を直接開きやすい
- ファイル構造が見やすい

向かないケース:
- 「読む気持ちよさ」「小説専用感」を重視したい

### 補助用途として良い: Typora

主アプリというより、
- Obsidian で管理
- Typora で長文を読む・整える

という併用はかなり相性がいいです。

## 現実的な選び方

迷うなら次のどちらかで十分です。

1. **Obsidian を主力にする**
   - 小説・設定・メモ整理を重視する場合
2. **VS Code を主力にする**
   - draw.io と Markdown を同じ場所で扱うことを重視する場合

個人的なおすすめは、

**Obsidian を主力、draw.io が必要なときだけ VS Code を併用**

です。  
この構成がいちばん無理が少ないです。

## 参考ソース

- Obsidian Canvas: https://obsidian.md/canvas
- Obsidian JSON Canvas 発表: https://obsidian.md/blog/json-canvas/
- Obsidian 用 draw.io プラグイン GitHub: https://github.com/somesanity/draw-io-obsidian
- Obsidian Forum の開発者投稿（2025-06-04）: https://forum.obsidian.md/t/draw-io-i-integrated-draw-io-into-obsidian-fully-offline/101518
- VS Code Draw.io Integration: https://marketplace.visualstudio.com/items?itemName=hediet.vscode-drawio
- VS Code Markdown 関連更新:
  - https://code.visualstudio.com/updates/v1_64
  - https://code.visualstudio.com/updates/v1_67
  - https://code.visualstudio.com/updates/v1_86
  - https://code.visualstudio.com/updates/v1_89
- VS Code Markdown Language Server: https://code.visualstudio.com/blogs/2022/08/16/markdown-language-server
- Typora 公式: https://typora.io/
- Typora Auto Save: https://support.typora.io/Auto-Save/
- Typora Sync / Mobile: https://support.typora.io/Sync/
- Zettlr 公式: https://www.zettlr.com/
- Zettlr Features: https://www.zettlr.com/features
- Zettlr 日本語ドキュメント: https://docs.zettlr.com/ja/core/editor/
- Scrivener 公式: https://www.literatureandlatte.com/scrivener
- Scrivener overview: https://www.literatureandlatte.com/scrivener/overview

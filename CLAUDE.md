# novel リポジトリ — Claude Code 用コンテキスト

## プロジェクト構成

このリポジトリには2つの独立したプロジェクトが共存している。

| フォルダ | 内容 |
|----------|------|
| `constrain/` | 小説「Constrain（制約）」の本文・設定・ブレインストーミング |
| `story-compiler/` | Robert McKee理論ベースの物語構造検証システム |

## Antigravity (AG) スキル・ワークフロー

`.agent/` フォルダにAntigravity用のスキルとワークフローが定義されている。
Claude Codeからも同じ操作を行う際は、これらの定義を参照すること。

| パス | 内容 |
|------|------|
| `.agent/skills/constrain-plot-sync/SKILL.md` | プロット更新時の同期手順・配色規約 |
| `.agent/skills/story-compiler/SKILL.md` | story-compiler操作・モジュール追加手順 |
| `.agent/skills/prompt-refinement/SKILL.md` | 雑な依頼を実行可能な形へ正規化する共通テンプレート |
| `.agent/workflows/chatgpt-to-project.md` | ChatGPT → プロジェクト反映ワークフロー |

## 絶対ルール

- `constrain/brainstorm/current_plot.md` は **ユーザーのみ編集**。AIは絶対に変更しない
- HTMLファイル（`value_map.html`等）は使用しない。可視化はすべて `.drawio` で行う
- コミットメッセージは `feat:`, `fix:`, `sync:`, `style:` 等のprefixをつける
- **全応答は日本語**で行う

## 言語設定

このプロジェクトに関する応答はすべて **日本語** で行うこと。

## Prompt Normalization Rule

ユーザーの依頼が雑・短文・断片的な場合、作業前に `.agent/skills/prompt-refinement/SKILL.md` を参照し、内部的にタスクを正規化すること。

- 目的、対象、制約、成果物を抽出してから着手する
- 不足情報が致命的な場合のみ、短く質問する
- 致命的でなければ、仮定を明示してそのまま進める
- `constrain` では候補出しと確定更新を混同しない

## サブプロジェクト詳細

- `constrain/CLAUDE.md` — 小説プロジェクトの詳細コンテキスト
- `story-compiler/CLAUDE.md` — story-compilerの詳細コンテキスト

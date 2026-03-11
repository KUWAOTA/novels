# Story Compiler — コンテキスト

## 概要

Robert McKee『Story』『Character』に基づく**物語構造検証システム**。
プログラミングコンパイラのように小説の構造的欠陥を検出する。

## 使い方

1. `system-prompt.md` をAIのシステムプロンプトとして設定
2. `modules/` の全YAMLを参照資料として渡す
3. 「診断モード」で小説アイデアを投げる

## 検証の3レベル

| レベル | 意味 |
|--------|------|
| `compile_error` | 必須要素の欠如・構造破綻（先に進めない） |
| `warning` | ベストプラクティスからの逸脱 |
| `info` | 推奨事項・深みの追加ヒント |

## モジュール一覧 (`modules/`)

| ファイル | 内容 |
|----------|------|
| `01_core-structure.yaml` | 構造単位の定義 |
| `02_global-settings.yaml` | 世界設定ゲート・心性・ドリフト検出 |
| `03_climax-rules.yaml` | クライマックス制約 |
| `04_story-triangle.yaml` | 物語三角形（Arc/Mini/Anti） |
| `05_controlling-concept.yaml` | 統制概念と価値軸 |
| `06_protagonist.yaml` | 主人公モデル・4層圧力構造・8素質 |
| `07_action-definition.yaml` | アクション定義・リスク段階増大 |
| `08_inciting-incident.yaml` | 契機事件 |
| `09_subplot.yaml` | サブプロット |
| `10_meaning.yaml` | 意味の生成条件 |
| `11_surprise.yaml` | 驚き検証（安い驚き vs 構造的驚き） |
| `12_exposition.yaml` | 情報提示制約・好奇心駆動 |
| `13_scene-transition.yaml` | シーン遷移・バックストーリー |
| `14_causal-chain.yaml` | 因果関係の鎖 |
| `15_genre-constraints.yaml` | ジャンル制約 |
| `16_choice-and-expression.yaml` | キャラクターの選択の真正性 |
| `17_symbolism-and-image.yaml` | 象徴・イメージの仕組み |
| `18_tension-dynamics.yaml` | テンション・リズム |
| `19_scene-mastery.yaml` | シーン構造最適化 |
| `20_interpretation-layer.yaml` | 読者の解釈層 |
| `21_character-dimension.yaml` | キャラクターの次元・矛盾 |
| `22_cast-design.yaml` | アンサンブル設計 |
| `23_character-components.yaml` | 性格描写コンポーネント |
| `_EXTENSION_TEMPLATE.yaml` | 新モジュール追加用テンプレート |

## 新しいモジュールを追加する手順

1. `modules/_EXTENSION_TEMPLATE.yaml` をコピー
2. 連番をつけてリネーム（例: `24_dialogue.yaml`）
3. テンプレートに従って原則を記述
4. `system-prompt.md` の `active_modules` リストに追加
5. バージョン番号をインクリメント

## 関連ファイル

| ファイル | 内容 |
|----------|------|
| `system-prompt.md` | メインシステムプロンプト |
| `DEV_HANDOVER.md` | 開発引き継ぎノート |
| `templates/story-blueprint.yaml` | 全体設計テンプレート |
| `templates/scene.yaml` | シーン単位テンプレート |
| `templates/act.yaml` | ACT単位テンプレート |
| `templates/character-sheet.yaml` | キャラクター定義テンプレート |
| `workflows/novel-writing.md` | 執筆モードワークフロー |
| `system-map.html` | システム全体の可視化（ブラウザで閲覧） |

## 関連プロジェクト

- `../constrain/brainstorm/` — 小説「Constrain」のブレインストーミング
- `../novel_construct.yaml` — 小説全体構造（概要レベル）

## AGスキル参照

`.agent/skills/story-compiler/SKILL.md` — Antigravity用操作ガイド

## Prompt Normalization Rule

依頼が曖昧な場合は、先に `../.agent/skills/prompt-refinement/SKILL.md` を参照し、内部的に以下を確定してから作業する。

- 今回が構造診断か、モジュール編集か、テンプレート改善か
- 対象ファイルはどこか
- 出力が診断結果なのか、差分なのか、草案なのか

これらが既存文脈から判断できない場合のみ、短く確認質問を行う。

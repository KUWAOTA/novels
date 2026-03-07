---
name: story-compiler
description: Robert McKee理論に基づく物語構造コンパイラ。小説の構造検証と設計支援を行うstory-compilerの操作スキル。
---

# Story Compiler スキル

## 概要

story-compilerは、Robert McKeeの書籍（『Story』『Character』）に基づく物語構造検証システムです。
プログラミング言語のコンパイラのように、小説の構造を検証します。

## プロジェクト内の位置

```
c:\Users\ukowu\Desktop\novel\story-compiler\
├── system-prompt.md          # メインシステムプロンプト
├── modules/                  # 原則モジュール（独立して追加・編集可能）
│   ├── 01_core-structure.yaml      # 構造単位の定義
│   ├── 02_global-settings.yaml     # 世界設定ゲート + 心性 + ドリフト検出
│   ├── 03_climax-rules.yaml        # クライマックス制約
│   ├── 04_story-triangle.yaml      # 物語三角形（Arc/Mini/Anti）
│   ├── 05_controlling-concept.yaml # 統制概念と価値軸
│   ├── 06_protagonist.yaml         # 主人公モデル + 4層圧力構造 + 8素質 + 信憑性
│   ├── 07_action-definition.yaml   # アクション定義 + リスク段階増大
│   ├── 08_inciting-incident.yaml   # 契機事件
│   ├── 09_subplot.yaml             # サブプロット
│   ├── 10_meaning.yaml             # 意味の生成条件
│   ├── 11_surprise.yaml            # 驚き検証
│   ├── 12_exposition.yaml          # 情報提示制約 + 好奇心駆動
│   ├── 13_scene-transition.yaml    # シーン遷移 + バックストーリー
│   ├── 14_causal-chain.yaml        # 因果関係の鎖
│   ├── 15_genre-constraints.yaml   # ジャンル制約
│   ├── 16_choice-and-expression.yaml
│   ├── 17_symbolism-and-image.yaml
│   ├── 18_tension-dynamics.yaml
│   ├── 19_scene-mastery.yaml
│   ├── 20_interpretation-layer.yaml
│   └── _EXTENSION_TEMPLATE.yaml
├── templates/                # 執筆用テンプレート
└── workflows/
```

## 操作方法

### 新しいモジュールを追加する
1. `modules/_EXTENSION_TEMPLATE.yaml` をコピー
2. 連番をつけてリネーム（例: `21_dialogue.yaml`）
3. テンプレートに従って原則を記述
4. `system-prompt.md` の `active_modules` リストに追加

### 既存モジュールを更新する
各モジュールは独立しているため、そのファイルだけを編集すればOK。
バージョン番号のインクリメントを忘れずに。

### 検証の3レベル
- `compile_error` — 必須要素の欠如・構造破綻（先に進めない）
- `warning` — ベストプラクティスからの逸脱（注意が必要）
- `info` — 推奨事項（知っておくと良い）

## McKee「Character」から追加した要素（v0.3）

`06_protagonist.yaml` に以下を追加:

### 自己の4層構造（圧力モデル）
- 社会的自己 → 個人的自己 → 中核の自己 → 隠れた自己
- 通常時は内層が外層を決定、危機（圧力）下では外層から順に剥がれる
- `pressure_sequence` で「どの圧力でどの層が破れるか」を設計

### 主人公の8つの素質（未定義チェック）
- エラーではなく「設計の抜け漏れ検出」
- A級（warning）: 意志の力
- B級（info）: 複雑さ、多面性、感情移入
- C級（info）: 好奇心、豊かな内面、適応力、真実を見抜く力

### 性格描写の3つの役割
- 信頼性（Credibility）— 行動と内面の整合
- 個性（Uniqueness）— 他キャラと交換不能
- 好奇心（Curiosity）— 未開示の層

### 信憑性制約
- 信憑性 = 「連続性」ではなく「潜在可能性」
- `latent_potential` が未定義のまま決定的啓示を設計すると compile_error

### 象徴化過剰チェック
- × 象徴を作ってから人間を貼る → ○ 人間を描いたら結果的に象徴に見える
- 「思想の装置」ではなく「思想に振り回される人間」

### サブプロット主人公チェック
- B主人公のベター要素の未定義をINFOで通知
- 主との関係タイプ、独立した欲望、交差点、信憑性の根 等

## 関連プロジェクト

- `constrain/brainstorm/` — 小説「Constrain」のブレインストーミングYAML群
- `novel_construct.yaml` — 小説全体構造（概要レベル）

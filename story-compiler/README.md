# 📖 Story Compiler — 物語構造コンパイラ

> Robert McKee『Story』の原則に基づく、AI支援小説執筆のための構造検証システム

## 概要

このコンパイラは、プログラミング言語の型チェッカーのように、
小説の構造的要素が正しく設計されているかを検証します。

- **compile_error** = 必須要素が欠けている → 先に進めない
- **warning** = ベストプラクティスから逸脱 → 進めるが注意が必要
- **info** = 推奨事項 → 知っておくと良い

## モジュール構成

```
story-compiler/
├── system-prompt.md          # メインシステムプロンプト（統合エントリポイント）
├── README.md                 # このファイル
│
├── modules/                  # 原則モジュール（独立して追加・編集可能）
│   ├── 01_core-structure.yaml      # 構造単位の定義
│   ├── 02_global-settings.yaml     # 世界設定ゲート
│   ├── 03_climax-rules.yaml        # クライマックス制約
│   ├── 04_story-triangle.yaml      # 物語三角形（Arc/Mini/Anti）
│   ├── 05_controlling-concept.yaml # 統制概念と価値軸
│   ├── 06_protagonist.yaml         # 主人公モデル
│   ├── 07_action-definition.yaml   # アクション定義（ハードロック）
│   ├── 08_inciting-incident.yaml   # 契機事件
│   ├── 09_subplot.yaml             # サブプロット
│   ├── 10_meaning.yaml             # 意味の生成条件
│   ├── 11_surprise.yaml            # 驚き検証
│   └── _EXTENSION_TEMPLATE.yaml    # 新モジュール追加用テンプレート
│
├── templates/                # 執筆用テンプレート
│   ├── story-blueprint.yaml        # ストーリー全体設計図
│   ├── scene.yaml                  # シーン設計テンプレート
│   ├── act.yaml                    # 幕設計テンプレート
│   └── character-sheet.yaml        # キャラクターシート
│
└── workflows/                # ワークフロー定義
    └── novel-writing.md            # 小説執筆モードのワークフロー
```

## 拡張方法

### 新しい原則モジュールを追加する

1. `modules/_EXTENSION_TEMPLATE.yaml` をコピー
2. 連番をつけてリネーム（例: `12_dialogue.yaml`）
3. テンプレートに従って原則を記述
4. `system-prompt.md` の `active_modules` リストに追加

### 既存モジュールを更新する

各モジュールは独立しているため、そのファイルだけを編集すればOKです。
全文を見渡す必要はありません。

## ソース

- Robert McKee『Story』
- Robert McKee『Character』（予定）
- Robert McKee『Dialogue』（予定）

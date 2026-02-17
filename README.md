# 📖 novels — 小説管理リポジトリ

## Story Compiler とは？

**物語構造コンパイラ** — プログラミング言語のコンパイラのように、小説の構造的欠陥を自動検出するシステムプロンプトです。

> Robert McKee『Story』の原則をYAMLで形式化し、AIに読ませることで  
> 「厳密だが創作を殺さない」構造チェッカーとして機能します。

---

## 🚀 クイックスタート

### アイデアを投げて診断してもらう

1. AIに [`story-compiler/system-prompt.md`](story-compiler/system-prompt.md) をシステムプロンプトとして設定
2. [`story-compiler/modules/`](story-compiler/modules/) の全YAMLファイルを参照資料として渡す
3. 「**診断モード**」で小説のアイデアを自由に投げる

```
あなた: 「主人公が記憶を失った探偵で、自分が犯人だと気づく話」
AI:
📋 アイデア診断結果
━━━━━━━━━━━━━━━━━━━━
✅ 定義済み: 主人公の概要, 中心のどんでん返し
❌ 未定義 (compile_error):
  [E001] 世界設定: 時代・舞台が未定義
  [E002] 統制概念: テーマ命題が未定義
  [E003] 主人公: 意識的欲望(desire)が未定義
  [E004] 契機事件: 均衡を破る出来事が未定義
⚠️ 注意 (warning):
  [W001] 驚き: 「自分が犯人」は情報隠蔽型 → 安い驚きにならないよう因果設計が必要
  [W002] 価値軸: 何の価値が動くか未定義
━━━━━━━━━━━━━━━━━━━━
次のステップ: 世界設定から埋めていきましょう
```

---

## 📐 検証の仕組み

### 3段階の厳密さ

| レベル | 意味 | 例 |
|--------|------|-----|
| ❌ `compile_error` | 必須要素の欠如。先に進めない | クライマックスなし、主人公の欲望なし |
| ⚠️ `warning` | ベストプラクティスからの逸脱 | リスク停滞、安い驚きの兆候 |
| ℹ️ `info` | 推奨事項・深みの追加ヒント | アイロニーの機会 |

```
Phase 0: Gate Check     → 世界設定が揃っているか？
Phase 1: Blueprint      → 主人公・テーマ・幕数が定義されているか？
Phase 2: Structure      → 各シーンに価値変化があるか？契機事件は適切か？
Phase 3: Meaning        → クライマックスは意味に満ちているか？
Phase 4: Balance        → テーマが説教臭くないか？サブプロットのバランスは？
Phase 5: Quality        → 選択真正性・象徴・緊張リズム・行動影響・敵対力
```

---

## 🧩 モジュール一覧

すべて [`story-compiler/modules/`](story-compiler/modules/) に格納。各モジュールは**独立して編集可能**です。

| # | モジュール | 検証内容 | 主なルール |
|---|-----------|---------|-----------|
| 01 | [構造単位](story-compiler/modules/01_core-structure.yaml) | Event→Beat→Scene→Sequence→Act→Story | 全単位に価値変化が必須 |
| 02 | [世界設定](story-compiler/modules/02_global-settings.yaml) | 時代・舞台・ジャンル・心性・ドリフト検出 | 未定義なら構築に進めない |
| 03 | [クライマックス](story-compiler/modules/03_climax-rules.yaml) | 不可逆性・意味強度 | MeaningIntensity算出 |
| 04 | [物語三角形](story-compiler/modules/04_story-triangle.yaml) | Arc/Mini/Anti + 幕数 | 最低3幕、6幕超えで警告 |
| 05 | [統制概念](story-compiler/modules/05_controlling-concept.yaml) | テーマ + 対立概念 | 教条主義チェック |
| 06 | [主人公](story-compiler/modules/06_protagonist.yaml) | 意志・欲望・心性・表裏・敵対力 | 消極的主人公には強い圧力が必要 |
| 07 | [アクション](story-compiler/modules/07_action-definition.yaml) | 行動→期待→結果→ギャップ・影響検証 | personal/social影響必須 |
| 08 | [契機事件](story-compiler/modules/08_inciting-incident.yaml) | 伏線・配置・準備 | 25%以内に発生必須 |
| 09 | [サブプロット](story-compiler/modules/09_subplot.yaml) | 意図宣言・ドリフト検出 | メインとの関連性スコア |
| 10 | [意味と結末](story-compiler/modules/10_meaning.yaml) | 意味の生成条件 | 曖昧さの品質チェック |
| 11 | [驚き](story-compiler/modules/11_surprise.yaml) | 安い驚き vs 構造的驚き | 遡及的必然性の確認 |
| 12 | [情報提示](story-compiler/modules/12_exposition.yaml) | 説明検出・好奇心駆動・情報ペーシング | 重要度カーブがクライマックスに向け上昇 |
| 13 | [シーン遷移](story-compiler/modules/13_scene-transition.yaml) | 遷移トリガー・バックストーリー・フラッシュバック | 遷移はaction/backstoryのみ |
| 14 | [因果関係](story-compiler/modules/14_causal-chain.yaml) | 因果の穴検出・契機→クライマックス整合 | 因果整合スコア ≥ 0.65 |
| 15 | [ジャンル制約](story-compiler/modules/15_genre-constraints.yaml) | ジャンルの約束事 | 違反はエラー、差し替え可能 |
| 16 | [選択・表現](story-compiler/modules/16_choice-and-expression.yaml) | 選択の真正性・テキスト過剰説明・サブテキスト | 偶ジレンマ検出、説明よりサブテキストが先 |
| 17 | [象徴・イメージ](story-compiler/modules/17_symbolism-and-image.yaml) | 象徴検出・中核イメージ検証 | 自然発生は加点、強制はエラー |
| 18 | [緊張リズム](story-compiler/modules/18_tension-dynamics.yaml) | 緊張/緩和宣言・リズム加速・休憩検出 | クライマックス前に緩和必須 |
| 19 | [シーン習熟](story-compiler/modules/19_scene-mastery.yaml) | before/after対比・シーン配置最適化 | 構造的変化のないシーンは警告 |
| 20 | [解釈生成](story-compiler/modules/20_interpretation-layer.yaml) | Insight（洞察）の直接記述禁止 | InsightはTextではなく読者の脳内で再生 |

---

## 📝 テンプレート

[`story-compiler/templates/`](story-compiler/templates/) に用意されたテンプレートを埋めて物語を組み立てます。

| テンプレート | 用途 |
|-------------|------|
| [story-blueprint.yaml](story-compiler/templates/story-blueprint.yaml) | ストーリー全体設計図（最初にこれを埋める） |
| [scene.yaml](story-compiler/templates/scene.yaml) | 個別シーンの設計 |
| [act.yaml](story-compiler/templates/act.yaml) | 幕の設計 |
| [character-sheet.yaml](story-compiler/templates/character-sheet.yaml) | キャラクター定義 |

---

## 🔄 対話モード

| モード | いつ使う | 何をするか |
|--------|---------|-----------|
| 🩺 **診断モード** | アイデアを投げた時 | 欠けている要素を一覧で表示 |
| 🏗️ **構築モード** | 構造を設計する時 | 質問で情報を引き出し構造を埋める |
| 🔍 **検証モード** | 構造を検証する時 | コンパイルを実行して結果を報告 |
| ✍️ **執筆モード** | 本文を書く時 | 構造に沿って執筆を支援 |

---

## 🔧 拡張方法

### 新しい原則モジュールを追加する

1. [`_EXTENSION_TEMPLATE.yaml`](story-compiler/modules/_EXTENSION_TEMPLATE.yaml) をコピー
2. 連番をつけてリネーム（例: `12_dialogue.yaml`）
3. テンプレートに従って原則を記述
4. `system-prompt.md` の `active_modules` に追加

### 拡張予定

| ソース | 追加予定のモジュール |
|--------|-------------------|
| McKee『Character』 | キャラクターアーク、次元の深さ、キャラクター関係性 |
| McKee『Dialogue』 | 対話の原則 |
| 独自拡張 | ムード・トーン制御 |

---

## 📁 リポジトリ構成

```
novels/
├── README.md                          ← このファイル
├── story-compiler/                    ← 物語構造コンパイラ本体
│   ├── system-prompt.md                  AIに渡すシステムプロンプト
│   ├── modules/                          原則モジュール (20本)
│   ├── templates/                        執筆用テンプレート
│   └── workflows/                        ワークフロー手順
└── old/                               ← 過去の小説メモ・断片
```

---

## 💡 設計思想

> **「コンパイラは正しさを裁かない。構造の整合性のみを検証する」**

- 美しさ・独創性・詩性は保証しない（できない）
- 保証するのは：**価値が動いている、因果がある、テーマが体験として成立、不可逆**
- 制約は創作を殺さない — エラーは構造破綻のみ
- 意図ドリブン — 作者の意図を問い、意図に基づいて検証する

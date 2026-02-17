# 🏗️ Story Compiler 開発引き継ぎドキュメント

このドキュメントは、ロバート・マッキー『ストーリー』の読解を進め、その内容を **Story Compiler (物語構造検証システム)** に反映させるエージェントのためのガイドラインです。

## 🎯 プロジェクトの目的

**「物語の構造的欠陥を自動検出するコンパイラを作る」**

ロバート・マッキー『ストーリー』の原則を **YAMLモジュール** として形式化し、AI（システムプロンプト）に読み込ませることで、小説のプロットにおける構造的破綻（`compile_error`）や品質不足（`warning`）を指摘できるようにします。

---

## 📂 ディレクトリ構成

```
/Users/takumauno/novels/story-compiler/
├── system-prompt.md        # コンパイラ本体（システムプロンプト）
├── modules/                # 原則モジュール群 (現在 20個)
├── templates/              # 執筆用テンプレート
└── README.md               # ユーザー向けマニュアル
```

---

## ✅ 現在の実装状況 (Status)

過去のメモ (`gpt.html`) にあった概念はすべて統合済みです。
現在は **23個** のモジュールが稼働しています。

### 既存モジュール一覧（重複実装を避けるため確認必須）

| ID | モジュール名 | キーワード |
|---|---|---|
| 01 | **構造単位** | Event, Beat, Scene, Sequence, Act, Story |
| 02 | **世界設定** | Setting, Era, Mood, Mentality |
| 03 | **クライマックス** | Irreversibility, Meaning Intensity |
| 04 | **物語三角形** | Arcplot, Miniplot, Antiplot, Acts (3+) |
| 05 | **統制概念** | Controlling Idea, Value Values, Didacticism |
| 06 | **主人公** | Will, Desire, Empathy, Antagonistic Force, Good Center |
| 07 | **アクション** | Expectation vs Result (Gap), Risk, Impact (Personal/Social) |
| 08 | **契機事件** | Inciting Incident (Wait < 25%) |
| 09 | **サブプロット** | Theme resonance, Drift check |
| 10 | **意味と結末** | Esthetic Emotion, Ending Quality |
| 11 | **驚き** | Cheap vs Structural Surprise |
| 12 | **情報提示** | Exposition, Curiosity, Information Pacing |
| 13 | **シーン遷移** | Transition triggers, Backstory rules |
| 14 | **因果関係** | Causal Chain, Logic Holes, Coherence |
| 15 | **ジャンル制約** | Genre Conventions |
| 16 | **選択・表現** | Choice Integrity (Dilemma), Textual Expression (Subtext) |
| 17 | **象徴** | Symbolism, Core Image |
| 18 | **緊張リズム** | Tension/Release Dynamics, Acceleration |
| 19 | **シーン習熟** | Before/After Contrast, Arrangement Optimization |
| 20 | **解釈生成** | Insight Engine (No direct preaching) |
| 21 | **次元と矛盾** | Character Dimension, Contradiction (Trait A vs B) |
| 22 | **キャスト設計** | Cast Design, Polarity, Action/Reaction Necessity |
| 23 | **性格と実像** | Characterization vs True Character, Gap, Pressure |

---

## 🛠️ 作業ワークフロー

『ストーリー』を読み進め、新しい原則や概念が見つかったら以下の手順で反映してください。

### 1. 既存モジュールへの追記か、新規作成か判定する

- **既存概念の拡張** (例: 主人公の新しいルール) → 該当する既存YAML (`modules/06_protagonist.yaml` など) に追記。
- **全く新しい概念** → 新規YAMLを作成。

### 2. 新規YAMLのマナー

- パス: `modules/21_new-module-name.yaml` (連番を振る)
- 形式: `modules/_EXTENSION_TEMPLATE.yaml` をコピーして使うのがベスト。
- 必須フィールド:
  - `module_id`
  - `module_name`
  - `source` (McKee 'Story' p.XXX)

### 3. ドキュメントの更新（必須）

モジュールを追加・変更したら、必ず以下も更新してください：
1. **`system-prompt.md`**
   - `active_modules` リストに追加
   - 必要なら `Phase 1~5` のチェックリストに追加
2. **`README.md`**
   - モジュール一覧表に追加

---

## 💡 次のアクション

新しいスレッドでは、まずこのファイルを読み込み (`view_file`), **「どの章を読んでいるか」** を伝えて作業を開始してください。

例:
> 「マッキーの『構成』の章を読みました。XXXという概念を実装したいです」

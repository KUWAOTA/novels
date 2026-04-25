# レビュー知見 → story-compiler 統合作業ログ

実施日：2026-04-25  
対象レビュー：黒田（2026-04-22）、takaya（2026-04-23）

---

## 作業概要

黒田・takaya からのレビュー知見を story-compiler モジュールおよび Constrain 設定ファイルに統合した。

---

## 変更ファイル一覧

### 1. `story-compiler/modules/28_pov.yaml` — 視点管理

追加セクション：`third_person_single_pov_rationale`

- **why_third_over_first**: 一人称 vs 三人称の選択根拠（作者が主人公を完全に把握できていない場合の対処）
- **length_and_pov_stability**: 長編での一視点維持の原則と例外（重要シーンへの相手目線差し込み）
- **compile_time_checks_extension**: 
  - `first_person_with_incomplete_understanding`（warning）
  - `pov_shift_without_reason_in_long_form`（warning）

### 2. `story-compiler/modules/26_opening.yaml` — 書き出し検証

追加セクション：`prologue_epilogue_circularity`

- **design_principles**: 循環構造の設計原則（表面反復・意味差異・行為を超えたフック・遡及的伏線）
- **compile_time_checks**:
  - `prologue_without_epilogue_echo`（warning）
  - `circularity_without_meaning_differential`（warning）

### 3. `story-compiler/modules/30_style-discipline.yaml` — 文体の統制

追加セクション2つ：

**`temporal_pacing`（時間の緩急制御）**
- 静かで地味なシーンの文学的価値
- テンポ自体が意味の層を作るという原則
- 初稿での膨らませ→削ぎ落としの手順
- compile_time_checks: `all_scenes_same_tempo`（info）、`quiet_scene_removed_for_visual_reason`（warning）

**`character_revelation_design`（キャラクター伝達の設計）**
- べたなエピソード × 性格の組み合わせ原則
- 読者の類比認識によるキャラクター立体化
- 台詞（セリフ）の場面具体化機能
- compile_time_checks: `trait_declared_without_episode`（warning）、`no_dialogue_in_character_scenes`（info）

### 4. `constrain/settings/v5/review_insights.md` — 新規作成

Constrain プロジェクト固有の確定設定まとめ：
- POV 確定設定（三人称一視点 / subject_native）
- プロローグ・エピローグの循環構造と具体的フック設計案
- 初稿の方針（ゴール・もりもり記述・バージョン管理）
- キャラクター設計の方針
- 時間の緩急制御と静かなシーンの価値
- 次に書くべきシーンの優先順位
- その他の方針（プロット・原稿のバージョン管理）

---

## 統合の判断基準

- story-compiler への追加は**汎用原則**として記述（Constrain 固有の情報は含めない）
- `constrain/settings/v5/review_insights.md` は Constrain 固有の確定設定として記述
- 既存の構造を壊さず、各 YAML の末尾または既存セクションの後に追記

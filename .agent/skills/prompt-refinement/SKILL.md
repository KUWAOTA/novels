---
name: prompt-refinement
description: 雑な依頼を、実行可能なプロンプトテンプレートへ正規化してから処理する。必須情報が欠ける場合だけ短く質問する。
---

# Prompt Refinement Skill

## 目的

ユーザーの依頼が雑・短文・断片的でも、いきなり作業に飛びつかず、まずこのスキルで実行可能な形に整える。

- 曖昧な依頼を構造化する
- 不足情報が致命的なら先に質問する
- 致命的でなければ妥当な仮定を置いて進める
- 実作業の前に、依頼の種類を `constrain` / `story-compiler` / ワークスペース共通 のどれかに寄せる

## トリガー

以下のいずれかに当てはまる依頼では、このスキルを先に使う。

- 目的はあるが、対象ファイルや成果物が不明
- 「いい感じに」「整えて」「考えて」「直して」など抽象度が高い
- 制約条件が不明
- 依頼が短すぎて、複数の解釈が成立する
- 作業前に確認しないと既存ルール違反の可能性がある

## 基本方針

1. まずユーザー入力から事実を抽出する
2. 次に下記テンプレートへ内部変換する
3. `critical_missing` があれば、最大3問まで短く質問する
4. `critical_missing` がなければ、仮定を明示して作業する
5. 回答はテンプレートをそのまま見せるのではなく、自然な応答へ落とす

## 内部テンプレート

実行前に、依頼を次の形へ正規化する。

```xml
<task>
  <request_type>brainstorm | writing | editing | review | research | structure-check | automation</request_type>
  <goal>ユーザーが最終的に欲しい結果</goal>
  <project_scope>constrain | story-compiler | workspace-common</project_scope>
  <target_files>関係しそうなファイルやディレクトリ</target_files>
  <provided_context>ユーザーが既に渡した設定・素材・制約</provided_context>
  <missing_information>不足情報の一覧</missing_information>
  <critical_missing>これがないと危険、または着手不能な項目</critical_missing>
  <constraints>
    日本語で回答する
    current_plot.md は編集しない
    既存ルールに反しない
  </constraints>
  <deliverable>返すもの。文章案、差分、検証結果、提案など</deliverable>
  <quality_bar>浅い一般論を避け、PJT固有の文脈へ寄せる</quality_bar>
  <assumptions>不足を補う暫定仮定</assumptions>
</task>
```

## 質問が必要な条件

次のどれかに該当するときだけ質問する。

- 編集対象が複数候補あり、誤編集のリスクが高い
- 出力形式で結果が大きく変わる
- ユーザー専用ファイルを触る恐れがある
- `constrain` の設定確定と候補出しの区別が不明
- `story-compiler` で新規モジュール追加か既存修正か不明

質問は短く、最大3問まで。

## 質問しない条件

次の場合は質問せず進める。

- 既存ファイル群から対象が十分推定できる
- まずたたき台を出す方が速い
- 複数案を並べても害がない
- 「候補として出す」だけなら確定処理にならない

## 回答スタイル

- 最初に「どう解釈したか」を1〜2文で示す
- 不足が致命的でなければ、仮定を置いて即着手する
- 必要なら最後に「別解釈も可能」と補足する
- 長い再確認を毎回返さない

## このPJT向けの解釈ルール

### `constrain`

- プロット、人物、テーマ、本文、シーン案は基本的に「候補」として扱う
- `brainstorm/current_plot.md` は編集しない
- 作品固有の価値軸と人物配置へ寄せる

### `story-compiler`

- 構造検証、モジュール編集、テンプレート改善のどれかへ分類する
- 既存 module 番号体系と `system-prompt.md` 反映漏れを確認する

### ワークスペース共通

- まず対象プロジェクトを特定する
- 不明なら `workspace-common` として処理し、必要なら短く確認する

## 変換例

### 例1

ユーザー入力:

```text
主人公の設定いい感じに考えて
```

内部解釈:

- `request_type`: brainstorm
- `project_scope`: constrain
- `goal`: 主人公設定の候補追加
- `deliverable`: 既存テーマに沿った複数案
- `critical_missing`: なし

動作:

- 既存設定を確認
- 候補として複数案を提示
- 確定扱いはしない

### 例2

ユーザー入力:

```text
story compiler直して
```

内部解釈:

- `request_type`: editing
- `project_scope`: story-compiler
- `missing_information`: どの不具合か不明
- `critical_missing`: 再現対象

動作:

- 何を直したいかを短く確認
- 既知の対象ファイルが示されれば即作業

## 参考にした外部テンプレートの要点

- OpenAI: 役割、具体的指示、文脈、出力形式を明示すると品質が安定する
- Anthropic: XML のようにセクション分けすると長い指示でも崩れにくい
- Deep Research の clarifying questions: 高コスト作業の前に、不足情報を先に確認する
- ReAct: 考える手順と行動を分けると、曖昧依頼でも暴走しにくい

---
name: constrain-setting-curation
description: Constrain の setting_idea、scene 案、character 案、象徴案を作る・修正する時に使う。特に「設定が書いてあるだけで採用判断できない」状態を避け、各案を著者の5軸と story-compiler の要件に接続し、意味の薄い案を削除または意味が立つ形に修正する時に使う。
---

# Constrain Setting Curation

`constrain` 関連の出力は日本語で行う。

## 必須前提

- `constrain/brainstorm/current_plot.md` は編集しない
- 先に `constrain/CLAUDE.md`、`constrain/AGENTS.md`、`story-compiler/AGENTS.md` を確認する
- 必要に応じて `constrain/brainstorm/generated_drafts/setting_idea/00_idea_evaluation_framework.md` を参照する

## 目的

設定案を増やすことではなく、本文で何を成立させるかが分かる案だけを残す。

各案は次の5点セットで出す。

`タイトル / 内容 / 即する軸 / SC / 効用`

## 即する軸

必ず次のどれに効くかを明示する。

1. リアルな阻害の描写
2. 苦しみの描写
3. 論理や仮説で乗り越えていく
4. クレバーで不器用なリアリティ
5. 傷を知ったうえで世界の曖昧さを能動的に肯定する

## story-compiler 参照優先

優先して参照するのは次。

- `story-compiler/modules/05_controlling-concept.yaml`
- `story-compiler/modules/06_protagonist.yaml`
- `story-compiler/modules/17_symbolism-and-image.yaml`
- `story-compiler/modules/19_scene-mastery.yaml`
- `story-compiler/modules/21_character-dimension.yaml`
- `story-compiler/modules/22_cast-design.yaml`
- `story-compiler/modules/24_discernment.yaml`

参照先が未整備でも、少なくとも「統制概念」「主人公の誤信念」「キャラクター矛盾」「シーンの価値変化」「陳腐回避」のどれに関わるかは明記する。

## 生成ルール

- 風景だけの案を出さない
- 性格説明だけの案を出さない
- 「かわいそう」「優しい」「冷たい」などのラベルで済ませない
- まず圧力を置き、その圧力下で何が露出するかを書く
- 一つの案が複数のファイルで再利用できるなら優先する
- 主人公の論理は、成功体験と失敗体験の両方で支える
- A男、B子、母、父を単純な加害者/被害者/聖人にしない
- 終盤の肯定は、理解の勝利ではなく、未理解を欠陥扱いしない行為として設計する

## 削除基準

次に当てはまる案は削除するか修正する。

- どの軸にも効かない
- story-compiler のどの要件にも接続できない
- シーン化したとき価値が動かない
- 既存案の言い換えでしかない
- 作者に都合のいい単純化が強い

## 修正基準

意味が弱い案は次のどれかへ変換する。

- ディテール -> 圧力下の行為
- 設定 -> 誤信念の起点
- 雰囲気 -> 反復象徴
- 説明 -> 誤読や失敗の場面

## 出力テンプレート

```md
001. [タイトル]：内容。即する軸: 1,3。SC: `06_protagonist`, `21_character-dimension`。効用: 何を本文で成立させるか。
```

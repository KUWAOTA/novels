# Story Compiler Guide

`CLAUDE.md` と `DEV_HANDOVER.md` の内容を、Codex 向けに短く整理した入口です。

## Purpose

- Robert McKee ベースの物語構造ルールを `modules/` の YAML 群として保持する
- `constrain` を含む小説案の構造検証や着想補助に使う

## Key Files

- `CLAUDE.md`: システム全体の概要
- `DEV_HANDOVER.md`: 拡張時の運用手順
- `system-prompt.md`: AI に渡す中核プロンプト
- `modules/`: 構造ルール本体
- `templates/`: blueprint / act / scene / character のテンプレート
- `workflows/novel-writing.md`: 執筆支援の流れ

## Relevant Modules For Constrain

- `modules/05_controlling-concept.yaml`: テーマ・価値変化
- `modules/06_protagonist.yaml`: 主人公の欲求・圧力
- `modules/17_symbolism-and-image.yaml`: 象徴設計
- `modules/21_character-dimension.yaml`: 矛盾した人格設計
- `modules/22_cast-design.yaml`: キャストの対立配置
- `modules/24_discernment.yaml`: 判断・見抜きに関する補助ルール

## Change Rule

- 新規モジュールや更新を行う場合は、`system-prompt.md` と `README.md` への反映漏れを確認する

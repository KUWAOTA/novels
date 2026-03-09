# Constrain Guide

`CLAUDE.md` と `.agent/instructions.md` の内容を、Codex 向けに短く整理した入口です。

## Primary Rules

- このプロジェクトに関する応答と生成物は日本語で扱います。
- `brainstorm/current_plot.md` はユーザーのみ編集します。更新提案は別ファイルで行います。
- 設定やプロット案は「候補」として増やしてよく、確定扱いしません。

## Key Files

- `CLAUDE.md`: 作品テーマ、主要人物、ACT 構造、重要ファイル一覧
- `.agent/instructions.md`: ブレインストーミング運用上の追加ルール
- `brainstorm/setting_idea/HANDOVER_TO_CODEX.md`: 現在の大量アイデア生成タスクの引き継ぎ
- `brainstorm/setting_idea/01_protagonist_settings.md`: 既存の主人公設定アイデア集
- `brainstorm/writing_issues.md`: 未解決課題
- `../story-compiler/AGENTS.md`: 構造検証ルール参照先

## Recommended Workflow

1. `CLAUDE.md` で作品の核を確認する
2. 必要なら `../story-compiler/modules/` を参照して構造面の抜けを点検する
3. 新しい案は `brainstorm/setting_idea/` など派生ファイルに追記し、`current_plot.md` は触らない

# Novels Workspace Guide

このワークスペースでは、作業対象ごとの案内を優先してください。

## Project Entrypoints

- `constrain/AGENTS.md`: 小説「Constrain」の執筆・設定生成・ブレスト時の案内
- `story-compiler/AGENTS.md`: Story Compiler の構造検証ルール参照時の案内
- `.agent/skills/prompt-refinement/SKILL.md`: 雑な依頼を実行前に構造化する共通テンプレート

## Working Rule

- `constrain/brainstorm/current_plot.md` はユーザーのみ編集します。Codex は変更しません。
- `constrain` 関連の出力は日本語で行います。

## Prompt Normalization Rule

- 依頼が短い、曖昧、対象不明な場合は、先に `.agent/skills/prompt-refinement/SKILL.md` のテンプレートへ内部変換してから作業します。
- 変換後に `critical_missing` があるときだけ、短い質問をして確認します。
- `critical_missing` がなければ、仮定を明示してそのまま作業を進めます。

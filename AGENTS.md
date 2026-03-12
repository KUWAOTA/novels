# Novels Workspace Guide

このワークスペースでは、作業対象ごとの案内を優先してください。

## Project Entrypoints

- `constrain/AGENTS.md`: 小説「Constrain」の執筆・設定生成・ブレスト時の案内
- `story-compiler/AGENTS.md`: Story Compiler の構造検証ルール参照時の案内
- `taskManegement/AGENTS.md`: ワークスペース全体のタスク抽出・優先度付け・週次整理の案内
- `.agent/skills/prompt-refinement/SKILL.md`: 雑な依頼を実行前に構造化する共通テンプレート

## Workspace Skills

- `.agent/skills/task-management/SKILL.md`: Markdown 群からタスクを抽出し、`taskManegement/outputs/` を再生成する

## Working Rule

- `constrain/brainstorm/current_plot.md` はユーザーのみ編集します。Codex は変更しません。
- `constrain` 関連の出力は日本語で行います。

## Prompt Normalization Rule

- 依頼が短い、曖昧、対象不明な場合は、先に `.agent/skills/prompt-refinement/SKILL.md` のテンプレートへ内部変換してから作業します。
- 変換後に `critical_missing` があるときだけ、短い質問をして確認します。
- `critical_missing` がなければ、仮定を明示してそのまま作業を進めます。

## Editor And Knowledge DB Rule

- Obsidian はメインエディタとして扱いません。閲覧・整理・リンク参照を行うナレッジデータベースとして使います。
- 主な編集作業は VS Code または Antigravity を優先します。
- Codex がこのリポジトリに新しいファイルを作成したとき、またはユーザーがこのリポジトリへ新しいファイルを追加したことが作業中に判明したときは、その内容を Obsidian の知識ベースへ反映する必要があるかを確認します。
- 反映が必要な場合は、Obsidian 上の導線、関連メモ、参照リンク、比較シート、マップ類を更新する前提で扱います。
- ただし、Obsidian 用の反映は「メインエディタを Obsidian に戻す」意味ではなく、知識ベースの鮮度維持として行います。

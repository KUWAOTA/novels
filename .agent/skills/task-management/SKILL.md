---
name: task-management
description: workspace 内の Markdown からタスクを抽出し、taskManegement 配下の board と schedule を更新する。
---

# Task Management Skill

## 目的

`novels` ワークスペースの散在した準備メモ、執筆課題、継続タスクを `taskManegement` に集約し、次にやることを明確にする。

## トリガー

- 「今日やることを出して」
- 「タスクを更新して」
- 「今週の予定を組んで」
- 「school や constrain を見て整理して」

## 最小手順

1. `taskManegement/config/task_sources.json` の参照元を確認する
2. 必要なら `taskManegement/inbox/manual_tasks.md` に追加タスクを書く
3. `python3 taskManegement/scripts/rebuild_task_board.py` を実行する
4. `taskManegement/outputs/daily_brief.md` と `taskManegement/outputs/weekly_schedule.md` を提示する
5. 作業実績を残すなら `python3 taskManegement/scripts/log_work_session.py ...` で `logs/session_log.csv` に追記する

## 運用原則

- 現実の締切を先に置く
- 帰宅前の「会社で1時間」を継続の最低ラインとして扱う
- ただし `constrain` の執筆系タスクをゼロにしない
- 読書は入力枠として維持する
- 週末は任意枠扱いとし、必須タスクを詰め込みすぎない

## 禁止事項

- `constrain/brainstorm/current_plot.md` を編集しない
- `outputs/` を手で書き換えない

## 拡張方針

- カレンダー連携が必要になったら、生成済み schedule を元に別スクリプトを足す
- 新しい参照元は parser と一緒に追加する

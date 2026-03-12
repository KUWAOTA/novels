# Task Management Guide

このディレクトリでは、以下を優先してください。

- `outputs/` は生成物なので直接編集しない
- タスク源を増やすときは `config/task_sources.json` を更新する
- 手作業タスクは `inbox/manual_tasks.md` に追加する
- 変更後は `python3 taskManegement/scripts/rebuild_task_board.py` を実行して出力を更新する

## スケジューリング原則

- 締切が近い現実タスクを先に置く
- 平日は最初に「会社で続ける1時間」を確保する
- `constrain` は完全放置しない。平日に最低 2 ブロックは確保する
- 読書は「入力」として週 2〜3 回の軽中量ブロックを維持する
- 週末は予定不確定なので、必須タスクを詰め込みすぎない

## 継続ログ

- `taskManegement/logs/session_log.csv` を継続の事実として扱う
- 会社 Mac か desktop のどちらからも当日ログがない平日は、`会社で1時間だけ続ける` を優先度 high で出す
- ログ追加は `python3 taskManegement/scripts/log_work_session.py ...` を使う

## 編集時の注意

- `school/prepare.md` など参照元は基本的に読み取り用
- `constrain/brainstorm/current_plot.md` は編集しない
- 日付は `2026-03-11` 基準ではなく、実行日のローカル日付で再計算する
- 日付単位のメモや宿題フォルダは `taskManegement/` 直下に置かず、`dialy/task_snapshots/YYYY-MM-DD/` に集約する

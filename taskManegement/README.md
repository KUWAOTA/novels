# Task Management

このディレクトリは、`novels` ワークスペース全体のタスク整理と簡易スケジューリングの基盤です。

- 参照元 Markdown からタスク候補を抽出する
- 平日夜中心の可処分時間に合わせて並べる
- エージェントに「今日やることを出して」「更新して」と頼める状態を作る

## 構成

```text
taskManegement/
├── AGENTS.md
├── README.md
├── config/
│   ├── schedule_profile.json
│   └── task_sources.json
├── inbox/
│   └── manual_tasks.md
├── outputs/
│   ├── board.md
│   ├── daily_brief.md
│   └── weekly_schedule.md
└── scripts/
    └── rebuild_task_board.py
```

## 基本運用

1. 参照元ファイルを更新する
2. 必要なら `inbox/manual_tasks.md` に手作業タスクを追加する
3. `python3 taskManegement/scripts/rebuild_task_board.py` を実行する
4. `outputs/` を見れば、優先順と今週の割当が分かる

## 現在の設計前提

- 労働時間は平日 17:00 まで
- 帰宅は通常 18:00 ごろ
- 就寝は 0:00
- 退勤後はまず 17:15-18:15 を「会社で続ける1時間」に置く
- 平日の主作業帯は 20:00-23:15
- 土日は埋まりやすいので、週末枠は「任意の予備枠」として扱う
- `constrain` は継続プロジェクトとして、執筆・設定決め・読書入力を維持する

## 継続の考え方

- 帰宅してから失速しやすい前提で、最初の1時間は会社で使う
- その1時間は重い成果より「流れを切らさない」ことを優先する
- その日、会社 Mac か自宅デスクトップのどちらからも作業ログがなければ、`会社で1時間だけ続ける` が最優先で出る
- ログは `taskManegement/logs/session_log.csv` に追記する

### ログ記録

```bash
python3 taskManegement/scripts/log_work_session.py --minutes 60 --location office --kind motivation --note "学校準備を進めた"
```

引数を省略した場合、device は現在のホスト名を使います。

## カレンダー連携

まだ外部カレンダーには書き込みません。まずはローカル Markdown で回し、必要になったら Apple Calendar などに同期するスクリプトを追加します。

## 注意

- `outputs/` 配下は生成物です。手修正せず、スクリプトで再生成してください。
- `constrain/brainstorm/current_plot.md` はこの仕組みからも編集対象外です。

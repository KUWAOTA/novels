# ファイル配置アーキテクチャ — たたき台

## 現状の問題

| 問題 | 詳細 |
|------|------|
| `diary/` を汚染 | Claudeの回答を誤って書き込んだ（`diary/`はユーザーの日記フォルダ） |
| `kuroda-training/` が無秩序に肥大化 | 草案・成果物・素材が混在 |
| ファイル名が統一されていない | `draft_for_kuroda.drawio` vs `needs_overview.drawio` 等 |

---

## 観察：既存の構造

### `diary/`（ユーザーの日記フォルダ — AIは書かない）
```
diary/
  YYYY-MM-DD/
    today.md          ← ユーザーが書く日次ログ
    today_overview.drawio
    ...
```

### `kuroda-training/`（既存の構造）
```
kuroda-training/
  prompt/             ← 入力素材（指示文・参考画像）
    p1.txt, p2.txt, p3.md
    準備.png, 運用.png
  muramasa/           ← 村正案件の作業
    needs_scan.md, mail.txt, ...
  needs_*.drawio      ← プロジェクトレベルの分析図（成果物）
  needs_*.png         ← PNG書き出し
```

---

## 提案：ポリシー設計

### `daily/YYYY-MM-DD/`（Claudeの作業ログ）
- **置くもの：** 草案・分析・たたき台・Claudeの中間成果物
- **置かないもの：** 最終的に黒田へ送るもの
- **命名：** `claude_HH-MM-SS_topic.md`

### `kuroda-training/`（プロジェクト成果物）
```
kuroda-training/
  prompt/             ← 素材・指示文（入力のみ、変更しない）
  muramasa/           ← 村正案件（案件単位でサブフォルダ）
  YYYY-MM-DD/         ← 日付ごとの成果物（送付物・確定図）
    status.drawio
    reply.md
    ...
```

**ポイント：**
- `kuroda-training/` 直下には**確定済みの成果物のみ**（草案はdailyに置く）
- 案件・日付でサブフォルダを切る

---

## 今の混乱ファイル（削除しない・移動候補）

| ファイル | 現在地 | 本来の置き場 |
|---------|--------|------------|
| `status_for_kuroda.drawio` | `kuroda-training/` | `daily/2026-03-28/` か削除 |
| `draft_for_kuroda.drawio` | `kuroda-training/` | `kuroda-training/2026-03-28/` （確定後） |
| `claude_00-00-00_kuroda_reply_strategy.md` | `diary/2026-03-28/` | `daily/2026-03-28/` |

---

## 確認事項

1. `kuroda-training/` 直下の既存 `needs_*.drawio` はどう扱う？（今のままでOK？）
2. 日付サブフォルダ案（`kuroda-training/YYYY-MM-DD/`）でOK？
3. `.agent/skills/` に `kuroda-training` スキルを新設する？既存スキルに追記する？

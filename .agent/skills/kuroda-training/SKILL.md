---
name: kuroda-training
description: 黒田（執筆メンター）との連携作業 — 状況整理・成果物作成・準備フェーズ管理
---

# Kuroda Training Skill

## ファイルポリシー

| フォルダ | 用途 | ルール |
|---------|------|--------|
| `kuroda-training/` | 確定成果物のみ | 草案はここに置かない |
| `kuroda-training/prompt/` | 素材・指示文（入力） | 変更しない |
| `kuroda-training/muramasa/` | 村正案件 | 案件単位で完結 |
| `daily/YYYY-MM-DD/` | 草案・分析・たたき台 | Claudeの作業はここ |
| `daily/` | 草案・日記（個人メモ含む） | claude_prefixのファイルのみ作成可 |

## draw.io 作成ルール

- **必ず `mcp__drawio__open_drawio_xml` を使う**（mermaidラッパーは文字化けする）
- 草案は `daily/YYYY-MM-DD/` に置く
- 確定したら `kuroda-training/YYYY-MM-DD/` または直下に移す

## 準備フェーズ（準備.png より）

### おさかな側
1. レジュメ作成（テーマ一文・プロット概要・キャラリスト）
2. 一日の区切りまで書き進める

### 黒田側
1. 原稿を読む
2. 課題洗い出し（テーマ・プロット・キャラ・場面バランス等）
3. 改善案提示・目標設定

## コミュニケーション原則

- 黒田は友人 — 敬語不要
- 伝え方：簡潔な1文 + draw.io
- 「書けていない」より「書き進め方を模索中」という文脈で伝える

## 禁止事項

- `daily/` への個人日記ファイル（today.md、diary.md 等）への書き込み
- `kuroda-training/` 直下への草案ファイル作成
- ファイルの無断削除

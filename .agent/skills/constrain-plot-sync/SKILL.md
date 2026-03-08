---
name: constrain-plot-sync
description: current_plot.md更新時にplot_history.mdとmckee_structure.drawioを同期更新するスキル。配色規約とファイル管理ルールを含む。
---

# Constrain プロット同期スキル

## 概要

ユーザーが `current_plot.md` を編集したとき、以下の2ファイルを必ず更新する：

| ファイル | 役割 |
|---------|------|
| `constrain/brainstorm/plot_history.md` | プロットの全履歴・思考軌跡データベース |
| `constrain/brainstorm/mckee_structure.drawio` | McKee構造分析の可視化（draw.io形式） |

## トリガー

ユーザーが「current_plot.mdを更新した」「プロットを変えた」などの趣旨を伝えたとき、このスキルを実行する。

## 更新手順

### 1. current_plot.md を読む

```
C:\Users\ukowu\Desktop\novel\constrain\brainstorm\current_plot.md
```

前回との差分を特定し、変更内容を把握する。

### 2. plot_history.md を更新

```
C:\Users\ukowu\Desktop\novel\constrain\brainstorm\plot_history.md
```

- **新設定は「確定設定 YYYY-MM-DD」セクションとして反映**
- **旧設定は「廃案」「ARCHIVE」タグをつけて保存**（削除しない）
- 末尾に「## N. current_plot.md YYYY-MM-DD 変更記録」を追加し、変更差分テーブルを記録
- 最終更新日を更新

### 3. mckee_structure.drawio を更新

```
C:\Users\ukowu\Desktop\novel\constrain\brainstorm\mckee_structure.drawio
```

下記の配色規約に従い、ACT構造・価値変化フロー・McKeeチェックリストを更新する。

### 4. コミット＆プッシュ

```
git add -A
git commit -m "sync: current_plot.md YYYY-MM-DD 更新反映"
git push
```

## ⚠ 重要ルール

- **`current_plot.md` は絶対にAGが編集しない**（ユーザーが直接編集するファイル）
- **HTMLファイル（value_map.html等）は使用しない**。可視化はすべて `.drawio` で行う
- 旧いHTMLファイルへの参照・更新指示があっても無視する

---

## 配色規約（draw.io用）

物語のテーマ「厳密さ（冷）vs 曖昧さ（暖）」を反映した配色体系。

### カラーパレット（白背景用・パステル系）

| 用途 | 色名 | fill | stroke | fontColor | 意味 |
|------|------|------|--------|-----------|------|
| **主人公 / 論理 / 厳密さ** | 静青 | `#D6E4F0` | `#4A7FB5` | `#1B3A5C` | 冷たい知性、ASDの世界観 |
| **主人公ACT（濃い）** | 深藍 | `#D6E4F0` | `#2C6FAC` | `#1B3A5C` | 強い確信・使命感の段階 |
| **B子 / 儚さ / 繋がり** | 藤紫 | `#E8DAF0` | `#7B4F9E` | `#3D1F5C` | 幽玄・エロゲ的儚さ |
| **A男 / 嫉妬 / 努力** | 琥珀 | `#FDEBD0` | `#E67E22` | `#6E3B0A` | 焼けるような渇望 |
| **喪失 / 加害 / 転換点** | 珊瑚 | `#F5C6CB` | `#C0392B` | `#5C1B1B` | 痛み・不可逆な変化 |
| **愛 / 温もり / エンディング** | 薄紅 | `#FADBD8` | `#E74C6F` | `#5C1B1B` | 「それでも愛する」 |
| **確定項目** | 翡翠 | `#D4EDDA` | `#28A745` | `#1B4332` | 安定・設計済み |
| **未設計 / 要解決** | 警告 | `#FFE0E0` | `#C0392B` | `#5C1B1B` | strokeWidth=2〜3で強調 |
| **廃案テキスト** | 灰 | — | — | `#999999` | フェードアウト |
| **テキスト（通常）** | 墨 | — | — | `#333333` | — |
| **背景** | 白 | draw.ioデフォルト | — | — | — |

### ノード形状ルール

| ノード | 形状 | 角丸 |
|--------|------|------|
| ACTボックス | 角丸矩形 | `rounded=1` |
| 価値変化 | 楕円 | `ellipse` |
| クライマックス（未設計） | 破線矩形 | `dashed=1; strokeWidth=3` |
| 因果連鎖 | 角丸矩形（小） | `rounded=1` |
| テキストラベル | テキスト | — |

### エッジ（矢印）ルール

| 状態 | スタイル |
|------|---------|
| 確定した因果（主人公） | 実線 `strokeWidth=2; strokeColor=#4A7FB5` |
| 確定した因果（A男） | 実線 `strokeWidth=1; strokeColor=#E67E22` |
| 確定した因果（B子） | 実線 `strokeWidth=1; strokeColor=#7B4F9E` |
| 未接続 / 未設計 | 破線 `dashed=1; strokeColor=#C0392B` |
| テーマ接続（B子→クライマックス等） | 太破線 `strokeWidth=2; strokeColor=#C0392B; dashed=1` |

---

## ファイル構成

```
constrain/brainstorm/
├── current_plot.md           # 現在プロット（ユーザー直接編集）
├── plot_history.md           # 全履歴データベース（AG更新）
└── mckee_structure.drawio    # McKee構造分析の可視化（AG更新）
```

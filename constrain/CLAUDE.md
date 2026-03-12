# Constrain — 小説プロジェクト コンテキスト

## 概要

**タイトル:** Constrain（制約）
**ジャンル:** 純文学・心理ドラマ
**主人公:** ASD傾向を持つエンジニア（名前なし）

**統制概念（テーマ命題）:**
> 「精密さで世界を守ろうとした人間が、誤解と傷で成り立つ社会を、完全な理解なしに愛せるようになる」

**価値軸:**
```
理解すれば救える → 理解しても救えない → 理解できなくても寄り添える
```

## キャラクター

| 記号 | 役割 | 機能 |
|------|------|------|
| 主人公 | 論理主義者 | 「精密な言語 = 救済」という誤信を持つ |
| B（彼女・鏡） | 中学時代の友人/恋人 | 自死 → 主人公の信念を強化する鏡 |
| A（いじめっ子・逆鏡） | Google同僚 | 主人公の精密教育に壊れていく → 精密さが暴力になる証明 |

## ACT構造

| ACT | 時代 | 状態 | 執筆状況 |
|-----|------|------|----------|
| ACT1 | 小学生 | 父から論理を学ぶ / いじめ始まる | 5シーン完成 |
| ACT2 | 中学時代 | Bと出会う / 教師のいじめ / Bの自死 | 5シーン完成 |
| ACT3 | 灘高校〜東大 | 学業成功 / 「精密 = 救済」確信 | 未執筆 |
| ACT4 | 社会人 | Google Japan / Aへの無意識のハラスメント | 未執筆 |
| ACT5 | クライマックス | Aの自殺未遂 / 主人公の気づき | 未執筆 |

## 重要ファイル

| ファイル | 役割 | 編集者 |
|----------|------|--------|
| `brainstorm/current_plot.md` | 現在のプロット（マスター） | **ユーザーのみ** |
| `brainstorm/plot_history.md` | 全プロット履歴データベース | AG / Claude Code |
| `brainstorm/mckee_structure.drawio` | McKee構造分析の可視化 | AG / Claude Code |
| `brainstorm/writing_issues.md` | 未解決の設定問題リスト | AG / Claude Code |
| `agents_story/ACT1/` | ACT1本文（5シーン）⚠️ AI生成草稿・参考のみ | AG / Claude Code |
| `agents_story/ACT2/` | ACT2本文（5シーン）⚠️ AI生成草稿・参考のみ | AG / Claude Code |

## agents_story の扱いについて

`agents_story/ACT1/` および `ACT2/` のシーンファイルは**AIが生成した草稿**であり、ユーザーが承認した正式原稿ではない。
設定・描写・台詞を「確定した事実」として前提にしないこと。詳細は `agents_story/README.md` を参照。

## 執筆フォーマット規約

- **スマホ閲覧用**: 1〜2文ごとに改行（Web小説スタイル）
- 1シーンあたり約1000字
- ファイル名: `01_シーンタイトル.txt` 形式

## プロット更新時の手順

`current_plot.md` が更新されたら（`.agent/skills/constrain-plot-sync/SKILL.md` 参照）:
1. `plot_history.md` に変更記録を追記
2. `mckee_structure.drawio` を配色規約に従って更新
3. `git commit -m "sync: current_plot.md YYYY-MM-DD 更新反映"`

## draw.io 配色規約（主要のみ）

| 用途 | fill | stroke |
|------|------|--------|
| 主人公 / 論理 | `#D6E4F0` | `#4A7FB5` |
| B子 / 儚さ | `#E8DAF0` | `#7B4F9E` |
| A男 / 嫉妬 | `#FDEBD0` | `#E67E22` |
| 喪失 / 転換点 | `#F5C6CB` | `#C0392B` |
| 確定項目 | `#D4EDDA` | `#28A745` |

詳細は `.agent/skills/constrain-plot-sync/SKILL.md` を参照。

## Antigravity スキル

- `.agent/instructions.md` — プロジェクトレベルのエージェント指示（日本語）
- `../.agent/skills/prompt-refinement/SKILL.md` — 雑な依頼を実行前に構造化する共通テンプレート

## Prompt Normalization Rule

依頼が短文、抽象的、または断片的な場合は、`../.agent/skills/prompt-refinement/SKILL.md` を先に適用する。

- まず候補出しか確定更新かを判定する
- `current_plot.md` に触れる恐れがある場合だけ確認する
- 致命的な不足がなければ、既存テーマに沿う候補として進める

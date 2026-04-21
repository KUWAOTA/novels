# Constrain ブレインストーミング・アイデアツリー

このディレクトリには、小説「Constrain」のブレインストーミングで出た
全アイデアを構造化したファイル群が格納されています。

## ⚠️ 重要な前提

- これらは **確定的なアイデアではありません**
- マッキー本を読む **前** に出したアイデアです
- **あらゆる可能性を詰め込んだ** ものです
- 最終的な取捨選択はマッキー理論の学習後に行います

## ファイル構成

| ファイル | 内容 |
|----------|------|
| `00_core-theme.yaml` | 核心テーマ・統制概念候補 |
| `01_protagonist.yaml` | 主人公の設定・信念体系 |
| `02_characters.yaml` | キャラクター A, B 等の設定候補 |
| `03_plot-branches.yaml` | ストーリー分岐ツリー（git風） |
| `04_world-settings.yaml` | 舞台設定・職業等の候補 |
| `05_references.yaml` | 参考作品・影響元 |
| `06_meta-notes.yaml` | 創作方針・著者のスタンス |
| `07_logline-candidates.yaml` | ログライン候補 |

## 分岐（branch）の読み方

`03_plot-branches.yaml` では、git のブランチのように
アイデアの分岐を表現しています：

```
main → 基本プロット（最も合意度の高い流れ）
  ├── branch/faith-collapse → 再現性の信仰が崩壊するルート
  ├── branch/travel-awakening → 旅を通じた気づきルート  
  ├── branch/romance-crisis → 恋愛をクライシスにするルート
  └── branch/single-focus → 厳密さ獲得パートのみに絞るルート
```

各ブランチは `status: candidate | preferred | rejected | deferred` で
状態を管理しています。

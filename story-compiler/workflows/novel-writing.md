---
description: 小説執筆モードのワークフロー — Story Compilerを使った構造的小説設計
---

# 🖊️ 小説執筆ワークフロー

このワークフローは Story Compiler を使って小説を構造的に設計・執筆するための手順です。

---

## 📋 事前準備

1. `story-compiler/system-prompt.md` をAIのシステムプロンプトとして設定
2. `story-compiler/modules/` フォルダの内容を参照資料として追加
3. AIに「構築モードで始めてください」と伝える

---

## Phase 0: 世界設定ゲート 🌍

**使用テンプレート:** `templates/story-blueprint.yaml` の `global_settings` セクション

1. 以下の必須項目をすべて埋める:
   - 時代設定（era）
   - 時間幅（duration）
   - 舞台（setting）
   - 葛藤レベル（conflict_level）
   - 生計手段（livelihood）
   - 権力構造（power_structure）
   - ジャンル（genre）
   - 前史（backstory）
   - キャラクター出自（character_origins）
   - キャスト定義（cast_definition）

2. AIに「Phase 0 コンパイルして」と依頼
3. compile_error が0件になるまで修正

---

## Phase 1: 設計図 🏗️

1. **主人公定義** — `templates/character-sheet.yaml` を使用
   - will, desire, object_of_desire, disposition を定義
   
2. **統制概念の宣言**
   - controlling_concept（テーマ命題）
   - opposing_concept（対立命題）
   
3. **ストーリータイプ宣言** — Arc or Mini

4. AIに「Phase 1 コンパイルして」と依頼

---

## Phase 2: 構造構築 📐

1. **契機事件 (Inciting Incident) の設計**
   - 伏線（foreshadowing）と回収（payoff）を定義
   - 均衡の破壊を確認
   - 配置が全体の25%以内か確認

2. **幕構造の設計** — `templates/act.yaml` を使用
   - 最低3幕
   - 各幕のクライマックスと価値変化を定義
   - 不可逆性の確認

3. **シーン設計** — `templates/scene.yaml` を使用
   - 各シーンの価値変化を定義
   - action → expectation → result → gap の記入
   - リスクと葛藤タイプの記入

4. AIに「Phase 2 コンパイルして」と依頼

---

## Phase 3: 意味検証 🔍

1. **クライマックス検証**
   - MeaningIntensity スコアの算出
   - 因果連鎖の完結性
   - 統制概念の体現度

2. **驚きの品質チェック**
   - 安い驚きの排除
   - 遡及的必然性の確認

3. AIに「Phase 3 コンパイルして」と依頼

---

## Phase 4: バランス検証 ⚖️

1. **教条主義チェック** — 統制概念/対立概念のバランス
2. **サブプロット検証** — フォーカスドリフト
3. **全体MeaningIntensity** — 0.75以上を目指す

4. AIに「フルコンパイルして」と依頼（全Phase実行）

---

## Phase 5: 執筆 ✍️

1. AIに「執筆モードに移行してください」と伝える
2. シーンごとに本文を執筆
3. 書き進めながら、構造との整合性を随時チェック
4. 1幕分書いたら「中間コンパイル」を依頼

---

## 💡 便利なコマンド一覧

| コマンド | 動作 |
|----------|------|
| `コンパイルして` | 全Phaseの検証を実行 |
| `Phase N コンパイルして` | 特定Phaseの検証を実行 |
| `構築モード` | 対話で構造を設計 |
| `執筆モード` | 本文の執筆に入る |
| `検証モード` | 構造検証に集中 |
| `このシーンをコンパイル` | 現在のシーンのみ検証 |
| `差分だけ出して` | 変更箇所のYAML差分のみ出力 |
| `YAML全体を出して` | 現在の物語構造の全体YAMLを出力 |

---

## ⚡ クイックスタート

最速で始めたい場合:

1. `story-blueprint.yaml` を開く
2. `global_settings` を埋める
3. AIに渡して「これをベースに構築モードで始めて」と言う
4. AIの質問に答えていくと構造が自動的に組み上がる

---

## 📌 注意事項

- compile_error は必ず修正してから次のPhaseに進む
- warning は無視しても進めるが、品質に影響する
- 各モジュールは独立編集可能 — 部分的な更新もOK
- 将来 McKee "Character" / "Dialogue" のモジュールを追加すると検証が拡張される

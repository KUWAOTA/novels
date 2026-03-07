# Claude.ai Projects セットアップ手順

## あなたが操作する箇所（全部で4ステップ）

---

### Step 1 — Claude.ai Pro に登録する（クレカ必要）

1. ブラウザで [https://claude.ai](https://claude.ai) を開く
2. アカウント作成（メールアドレス）
3. 左下のアップグレードボタン → **Pro プラン** を選択（$20/月）
4. クレジットカードを入力して完了

---

### Step 2 — Project を作成する

1. claude.ai にログイン後、左サイドバーの **「＋ New project」** をクリック
2. プロジェクト名を設定（例：`constrain - girlfriend`）

---

### Step 3 — システムプロンプトを設定する

1. Project 設定画面で **「Project instructions」** セクションを開く
2. 以下のファイルの内容を**まるごとコピーして貼り付ける**：

   ```
   C:\Users\ukowu\Desktop\novel\other\claude-project-system-prompt.md
   ```

---

### Step 4 — プロット・参考ファイルをアップロードする

Project の **「Knowledge」** セクションで以下のファイルをアップロードする：

| ファイル | 用途 |
|---|---|
| `constrain\prompt\girlfriend.md` | 現在のプロット（主要参照ファイル） |

> ※ girlfriend.md は大きい（約100KB）のでそのまま丸ごとアップロードでOK

---

## 完了後の使い方

スマホのブラウザで `claude.ai` を開き、作成したProjectを選ぶだけ。

```
例：
あなた: 「第2幕の主人公の欲求と条件が混在してる気がするので整理したい」

Claude(story-compiler搭載):
「06_protagonistモジュールの condition_vs_desire を確認します。
 現在の記述を見ると...
 ⚠️ W003: 欲求が条件説明になっています（例：〜な環境だったからこうなった）」
```

---

## プロットを更新したい場合

1. スマホで Claude.ai と会話してプロットを決める
2. Claude に「girlfriend.md の該当部分の差分を出して」と頼む
3. 差分（diff形式）が出てくるので、PCに戻ってから貼り付け
4. git push

---

## 注意事項

- Claude.ai Proの **tokensは月ごとにリセット**される（使いすぎても翌月に回復）
- girlfriend.md が更新されたら **Knowledge を更新**（差し替えアップロード）が必要
- システムプロンプトは変更不要（モジュールは全統合済み）

---

## iOS / Android アプリ

Claude.ai はアプリもある。スマホから快適に使うならアプリがおすすめ。

- iOS: App Store で「Claude」
- Android: Google Play で「Claude」

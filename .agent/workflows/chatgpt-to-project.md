---
description: ChatGPTの会話スレッドからプロジェクトファイルにデータを反映するワークフロー
---

# ChatGPT → Project 反映ワークフロー

ユーザーが「プロジェクト名」と「スレッド名」を指定するだけで、ChatGPTの会話内容をプロジェクトのstory-compilerやconstrainに反映する。

## 前提条件

- ユーザーがChatGPTにブラウザでログイン済みであること
- ChatGPTのスレッドがブラウザで開かれている（またはスレッド名を知っている）こと

## ステップ

### 1. ChatGPTへのアクセス

ブラウザでChatGPTが開かれていない場合:
1. `https://chatgpt.com/` に移動する
2. ログインが必要な場合はユーザーに認証を依頼する

### 2. 対象スレッドを開く

1. サイドバーから対象プロジェクト（例: "小説"）を探す
2. 対象プロジェクト内でスレッド名を探してクリック
3. スレッドが見つからない場合は、検索機能（🔍）で日本語名をJavaScriptで入力して検索

```javascript
// 日本語テキストを検索欄に入力する方法（Playwright日本語キー非対応のため）
(function() {
  var input = document.querySelector('input[type="text"]');
  if (input) {
    var nativeInputValueSetter = Object.getOwnPropertyDescriptor(
      window.HTMLInputElement.prototype, 'value').set;
    nativeInputValueSetter.call(input, 'スレッド名ここ');
    input.dispatchEvent(new Event('input', { bubbles: true }));
  }
})();
```

### 3. スレッドの全文テキストを抽出

// turbo
スレッドを開いたら、以下のJavaScriptで全文を抽出する:

```javascript
// Step 1: トップにスクロール
window.scrollTo(0, 0);

// Step 2: テキストをチャンクで取得（mainタグから）
(function() {
  var main = document.querySelector('main');
  return main ? main.innerText.substring(0, 5000) : 'MAIN NOT FOUND';
})();
```

5000文字ずつチャンクを取得し、空文字が返るまで続ける:
```javascript
(function() {
  var main = document.querySelector('main');
  return main ? main.innerText.substring(N, N+5000) : '';
})();
// N = 5000, 10000, 15000, ... と増やす
```

**重要**: 抽出したテキストは必ずスクラッチパッドファイルに保存すること。

### 4. 反映先を判定

スレッドの内容を読み、以下のどちらに反映するか判定:

| 内容の種類 | 反映先 |
|---|---|
| 物語構造の理論・原則（マッキー等） | `story-compiler/modules/` の該当モジュールYAML |
| 創作上のアイデア・ブレインストーミング | `constrain/brainstorm/` の該当YAML |
| 実体験の素材・ネタ | `constrain/brainstorm/01_protagonist.yaml` の `raw_material` セクション |
| 世界設定に関する議論 | `constrain/brainstorm/04_world-settings.yaml` |
| キャラクターに関する議論 | `constrain/brainstorm/02_characters.yaml` |

### 5. 反映作業

#### story-compiler への反映（理論・原則系）

1. 対象モジュールの現在の内容を確認
2. 新しい理論要素を既存構造に統合:
   - 新しいセクション追加（例: `self_layers`, `protagonist_traits`）
   - 既存セクションの拡張
   - `compile_time_checks` の追加
3. バージョン番号をインクリメント
4. `source` フィールドに新しいソースを追加
5. `system-prompt.md` のモジュール説明も更新

#### constrain/brainstorm への反映（アイデア・素材系）

1. 対象YAMLの現在の内容を確認
2. 新しいエントリを適切なセクションに追加:
   - `raw_material` にはID付きで追加（例: `RM-001`, `RM-002`）
   - `source_thread`, `date`, `thematic_value`, `connection_to_core_theme` を必ず含める
3. `mckee_structure.drawio` や `plot_history.md` への反映が必要かも判断

### 6. 完了報告

以下をまとめて報告:
- 読み取ったスレッド名
- 反映先ファイル名と追加/変更内容の要約
- 構造的な影響（他のモジュールやファイルとの関連）

## ディレクトリ構造リファレンス

```
novel/
├── story-compiler/          # 物語構造コンパイラ（理論ベース）
│   ├── modules/             # 原則モジュール（YAML）
│   ├── templates/           # 執筆用テンプレート
│   ├── system-prompt.md     # メインシステムプロンプト
│   └── workflows/           # ワークフロー定義
│
├── constrain/               # 小説「Constrain」のブレインストーミング
│   ├── brainstorm/          # アイデア・設定YAML群
│   │   ├── 00_core-theme.yaml
│   │   ├── 01_protagonist.yaml
│   │   ├── 02_characters.yaml
│   │   ├── 03_plot-branches.yaml
│   │   ├── 04_world-settings.yaml
│   │   ├── 05_references.yaml
│   │   ├── 06_meta-notes.yaml
│   │   └── 07_logline-candidates.yaml
│   ├── mckee_structure.drawio  # McKee構造分析の可視化（draw.io）
│   └── current_plot.md      # 現在プロット（ユーザー直接編集）
│
└── novel_construct.yaml     # 小説全体構造
```

## 注意事項

- ChatGPTのDOM構造は頻繁に変わるため、テキスト抽出のセレクタが動作しない場合は `main` タグの `innerText` で代替する
- 日本語入力はPlaywrightのキー入力では不可能。JavaScriptで値を直接設定すること
- 長いスレッドは5000文字チャンクで分割取得すること
- 反映時は既存の構造を壊さず、追加・拡張する方針で行う

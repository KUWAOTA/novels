# Claude Remote Control 修正引継ぎ

更新日時: 2026-03-12 00:27 JST

## 依頼内容

`.workspace/ops/keep_claude_alive.ps1` と `.workspace/ops/auto_claude.bat` がうまく動かないため修正した。

## 実施した修正

### 1. `C:\Users\ukowu\Desktop\novel\.workspace\ops\auto_claude.bat`

- 文字化けしていた日本語 `echo` を削除
- 壊れて 1 行につながっていた `echo` 行を除去
- 実処理を PowerShell 側へ寄せ、`keep_claude_alive.ps1` を呼ぶだけの薄いランチャーへ整理
- `keep_claude_alive.ps1` が見つからない場合は即終了するよう変更

現在の内容は「PowerShell watchdog を起動するだけ」の単純な bat になっている。

### 2. `C:\Users\ukowu\Desktop\novel\.workspace\ops\keep_claude_alive.ps1`

- `while ($true)` の再起動ループは維持
- `claude` が PATH にあるか先に確認するよう変更
- PowerShell から `claude.ps1` を踏んで Execution Policy で落ちる可能性があるため、まず `claude.cmd` を優先して実行するよう変更
- `claude remote-control -y` となっていたが、現在の CLI では `-y` は無効だったため削除
- 終了コードと再起動待機秒数を表示するよう変更

## 修正後に確認できたこと

- bat / ps1 ともに起動自体は通る
- 構文エラー、文字化け起因のバッチ破損、`-y` オプション不正は解消済み
- `claude remote-control --help` の確認結果では、`-y` はサポートされていない

## 現在残っているエラー

実行すると以下で停止ではなく再試行ループになる。

```text
Error: Registration: Authentication failed (401): OAuth token has expired. Please obtain a new token or refresh your existing token.. Remote Control is only available with claude.ai subscriptions. Please use `/login` to sign in with your claude.ai account.
```

## つまり何が原因か

スクリプト不具合は直ったが、今止まっている本当の原因は Claude Code 側の認証切れ。
`remote-control` 自体は起動されているが、OAuth token expired により登録できていない。

## Claude Code 側で確認してほしいこと

1. この端末の `claude` ログイン状態を確認
2. 必要なら `claude.cmd auth login` で再ログイン
3. `remote-control` が claude.ai subscription 前提のため、対象アカウントで使える状態か確認
4. 再ログイン後に `claude remote-control` 単体で成功するか確認
5. 成功後に `.workspace/ops/auto_claude.bat` の常駐ループ運用へ戻す

## 補足

`claude remote-control --help` の主なオプションは以下だった。

- `--name <name>`
- `--permission-mode <mode>`
- `--debug-file <path>`
- `-v, --verbose`

少なくとも現行 CLI では `-y` は存在しない。

## 2026-03-12 追記

- PowerShell では `claude` が `claude.ps1` を踏み、Execution Policy で止まることがある。その場合は `claude.cmd` を使う
- 現行 CLI で正しい再ログイン手順は `claude.cmd auth login`
- `claude login` は現行 CLI の正式サブコマンドではないため、対話 UI が崩れて `Interrupted` と `What should Claude do instead?` が出ることがある
- `.workspace/ops/keep_claude_alive.ps1` は認証切れを検出したら無限再試行せず、再ログイン手順を表示して停止するよう修正済み

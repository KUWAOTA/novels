# Mobile SSH Remote Guide

このフォルダは、`C:\Users\ukowu\Desktop\novel` をスマホから安全に触るための Windows 向け運用セットです。

今回の推奨構成は、会話ログの意図どおり `スマホ -> SSH -> このPC -> codex / claude / git` を最短で作れるように、`Windows OpenSSH Server + Tailscale` を第一候補にしています。

## 推奨アーキテクチャ

```text
iPhone / Android
  -> Blink Shell / ShellFish / Termius
  -> Tailscale
  -> Windows OpenSSH Server
  -> PowerShell
  -> C:\Users\ukowu\Desktop\novel
  -> codex / claude / git / rg
```

この構成を先に勧める理由:

- いまのPCをそのまま使える
- WSL や tmux を必須にしなくてよい
- `codex` と `claude` を Windows 側の既存環境でそのまま呼べる
- 接続が切れても再接続後にすぐ作業へ戻しやすい

## まずやること

管理者 PowerShell で次を実行します。

```powershell
powershell -ExecutionPolicy Bypass -File C:\Users\ukowu\Desktop\novel\remote\setup-openssh.ps1
```

このスクリプトが行うこと:

- OpenSSH Server のインストール
- `sshd` の自動起動設定
- `sshd` サービスの開始
- TCP 22 番の Windows Firewall 許可
- `authorized_keys` 配置先の案内

Windows 起動時にも自動で SSH 用サービスを確認したい場合は、`startup-ensure-remote.ps1` をタスクスケジューラで登録します。

そのあと PC とスマホの両方に Tailscale を入れて、同じ tailnet にログインしてください。

## 接続前チェック

通常ユーザーの PowerShell で次を実行します。

```powershell
powershell -ExecutionPolicy Bypass -File C:\Users\ukowu\Desktop\novel\remote\check-mobile-access.ps1
```

接続先だけすぐ見たい場合:

```powershell
powershell -ExecutionPolicy Bypass -File C:\Users\ukowu\Desktop\novel\remote\show-connection-info.ps1
```

確認する内容:

- `sshd` の有無と起動状態
- `git` / `rg` / `codex` / `claude` / `ssh` / `tailscale` の有無
- リポジトリの存在
- `.ssh\authorized_keys` の有無
- IPv4 アドレス
- Git ワークツリー状態

## スマホから接続した後の入り口

SSH ログイン後、最初の作業ディレクトリを `novel` にそろえるために次を実行します。

```powershell
powershell -ExecutionPolicy Bypass -File C:\Users\ukowu\Desktop\novel\remote\start-mobile-session.ps1
```

Codex をすぐ開きたい場合:

```powershell
powershell -ExecutionPolicy Bypass -File C:\Users\ukowu\Desktop\novel\remote\start-mobile-session.ps1 -Tool codex
```

Claude Code をすぐ開きたい場合:

```powershell
powershell -ExecutionPolicy Bypass -File C:\Users\ukowu\Desktop\novel\remote\start-mobile-session.ps1 -Tool claude
```

## スマホ側アプリのおすすめ

- `Blink Shell`
  - ターミナル操作重視
  - 長時間の SSH 作業向き
- `ShellFish`
  - ファイル閲覧もしたい時に便利
  - SFTP 連携が強い
- `Termius`
  - 複数ホスト管理向き
  - UI がわかりやすい

スマホSSHで向いている作業:

- ログ確認
- 軽い修正
- Git 状態確認
- Codex / Claude への指示出し

スマホSSHで向いていない作業:

- 長文を大量に直接打つ執筆
- 大規模な画面分割前提のレビュー

## 接続先の考え方

おすすめ順:

1. Tailscale の `100.x.y.z` か MagicDNS 名で接続
2. それが無理なら家庭内LANでローカルIP接続
3. ルーターの 22 番公開は最後の手段

公開ポートを使う場合は最低でも次を守ってください。

- パスワードログインを無効化
- 公開鍵ログインのみ許可
- `authorized_keys` を使用
- Tailscale を使えるなら公開ポートは開けない

## `authorized_keys` の配置

公開鍵は通常、次のどちらかに置きます。

```text
C:\Users\ukowu\.ssh\authorized_keys
%PROGRAMDATA%\ssh\administrators_authorized_keys
```

どちらを使うかは、接続ユーザー権限と OpenSSH の設定次第です。まずはユーザー側の `.ssh\authorized_keys` を第一候補にしてください。

公開鍵を追記する補助スクリプト:

```powershell
powershell -ExecutionPolicy Bypass -File C:\Users\ukowu\Desktop\novel\remote\add-authorized-key.ps1 -PublicKey "ssh-ed25519 AAAA... your-phone"
```

## 次の拡張候補

Windows だけで不便を感じたら、次の順で強化するのが安全です。

1. Tailscale 導入
2. SSH 公開鍵ログイン化
3. `codex` / `claude` の起動エイリアス整理
4. 必要になったら WSL + tmux に移行

現時点では、まず `Windows SSH + Tailscale` だけで十分に実用的です。

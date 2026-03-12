# novel スマホSSH構成メモ

更新日: 2026-03-12

## 目標

スマホからこのPCへ SSH で入り、ログイン直後に `C:\Users\ukowu\Desktop\novel` で作業を始められる構成を作る。

## このPCで確認できた現状

- `ssh.exe` は導入済み
- `claude.cmd` と `codex.cmd` は導入済み
- `sshd.exe` は未導入
- `sshd` サービスも未作成
- 現在の LAN 側 IPv4 は `192.168.11.2`

つまり、残る大仕事は `OpenSSH Server` の導入だけ。

## おすすめ構成

1. スマホの SSH アプリからこのPCへ接続する
2. Windows OpenSSH Server を受け口にする
3. 認証は公開鍵のみ
4. ログイン後は PowerShell で `novel` フォルダに自動移動
5. 作業は `codex.cmd` または `claude.cmd` をそのまま起動

外出先から使うなら、ポート開放より `Tailscale + SSH` を優先するのがおすすめ。

## 追加したファイル

- [install_windows_ssh_server.ps1](/C:/Users/ukowu/Desktop/novel/.workspace/ops/install_windows_ssh_server.ps1)
- [install_ssh_login_profile.ps1](/C:/Users/ukowu/Desktop/novel/.workspace/ops/install_ssh_login_profile.ps1)
- [add_authorized_key.ps1](/C:/Users/ukowu/Desktop/novel/.workspace/ops/add_authorized_key.ps1)
- [start_novel_remote.ps1](/C:/Users/ukowu/Desktop/novel/.workspace/ops/start_novel_remote.ps1)
- [show_remote_status.ps1](/C:/Users/ukowu/Desktop/novel/.workspace/ops/show_remote_status.ps1)

## 実行順

### 1. 管理者 PowerShell で SSH サーバーを入れる

```powershell
Set-Location C:\Users\ukowu\Desktop\novel
.\.workspace\ops\install_windows_ssh_server.ps1
```

このスクリプトがやること:

- OpenSSH Server をインストール
- `sshd` を自動起動に設定
- Firewall で 22/TCP を許可
- 公開鍵認証を有効化
- パスワード認証を無効化
- 既定シェルを PowerShell に設定

### 2. 通常ユーザーで SSH ログイン時の着地点を入れる

```powershell
Set-Location C:\Users\ukowu\Desktop\novel
.\.workspace\ops\install_ssh_login_profile.ps1
```

これで SSH ログイン直後に `novel` へ移動し、よく使うコマンドの案内が出る。

### 3. スマホ側で鍵を作る

SSH アプリ側で `ed25519` 鍵を作る。

### 4. スマホの公開鍵をこのPCへ登録する

公開鍵文字列を直接渡す場合:

```powershell
.\.workspace\ops\add_authorized_key.ps1 -PublicKey "ssh-ed25519 AAAA... your-phone"
```

ファイルから入れる場合:

```powershell
.\.workspace\ops\add_authorized_key.ps1 -PublicKeyFile C:\path\to\id_ed25519.pub
```

### 5. 接続確認

同一Wi-Fiなら:

```text
ssh ukowu@192.168.11.2
```

Tailscale を使うなら、`100.x.x.x` か `*.ts.net` 側のアドレスで接続。

## ログイン後の使い方

```powershell
codex.cmd
claude.cmd
.\.workspace\ops\auto_claude.bat
git status
```

必要なら手動で着地:

```powershell
.\.workspace\ops\start_novel_remote.ps1
```

## 状態確認

```powershell
.\.workspace\ops\show_remote_status.ps1
```

## セキュリティ方針

- 公開鍵認証のみ
- パスワード認証は無効
- まずは同一LANまたは Tailscale を推奨
- ルーターの 22 番ポート開放は最後の手段

## スマホ側アプリの選び方

- 手堅さ重視: ShellFish
- バランス型: Termius
- ターミナル重視: Blink Shell

## 補足

`tmux` は Windows ネイティブでは前提にしづらいので、まずは Windows OpenSSH + PowerShell で構成している。
将来的に長時間の常駐セッションをもっと安定させたくなったら、WSL か Linux ミニPC 側へ寄せて `tmux` を使う構成に広げるとよい。

---
tags:
  - software
  - ssh
  - mobile
  - codex
  - claude
---

# スマホ SSH 運用構成 2026-03-12

## 結論

この `novel` 環境をスマホから触るなら、まずは次の構成が一番現実的です。

`iPhone -> Tailscale -> Windows OpenSSH -> PowerShell -> Codex / Claude`

理由は単純で、今のこの PC は Windows で常時起動前提、`codex.cmd` と `claude.cmd` はすでに入っている一方、WSL は実行ファイルだけあり Linux ディストリビューションはまだ未導入だからです。

## この PC の現状

2026-03-12 時点で確認できたこと:

- `codex.cmd` は利用可能
- `claude.cmd` は利用可能
- `wsl.exe` はある
- Linux ディストリビューションは未導入
- `C:\ProgramData\ssh\sshd_config` は未作成
- OpenSSH Server は少なくとも現状の標準構成では未セットアップ
- `tailscale` コマンドは未検出

つまり、今すぐ実用化する最短ルートは「Windows に SSH を生やして、そのまま PowerShell で `novel` を開く」です。

## 推奨アーキテクチャ

### まず作る構成

`iPhone -> Blink Shell or Termius -> Tailscale -> Windows OpenSSH -> C:\Users\ukowu\Desktop\novel`

この形なら:

- スマホは表示と簡単な入力だけ担当
- repo 操作、AI 実行、ファイル探索は全部 PC 側
- `codex` と `claude` の両方を同じ作業ディレクトリで使える

### 後で強化する構成

`iPhone -> SSH -> Windows -> WSL Ubuntu -> tmux -> Codex / Claude`

長時間運用や切断耐性まで重視するならこちらが本命です。ただし WSL の初期導入がまだなので、最初からここを目指すより二段階で入れた方が楽です。

## 今回追加した運用入口

この repo に次のスクリプトを追加しました。

- `.workspace/ops/mobile_entry.ps1`

用途:

- SSH 接続後に `novel` ディレクトリへ移動する
- 必要ならそのまま `codex` または `claude` を起動する

使い方:

```powershell
powershell -NoLogo -ExecutionPolicy Bypass -File C:\Users\ukowu\Desktop\novel\.workspace\ops\mobile_entry.ps1
```

そのまま Codex を起動:

```powershell
powershell -NoLogo -ExecutionPolicy Bypass -File C:\Users\ukowu\Desktop\novel\.workspace\ops\mobile_entry.ps1 -Tool codex
```

そのまま Claude を起動:

```powershell
powershell -NoLogo -ExecutionPolicy Bypass -File C:\Users\ukowu\Desktop\novel\.workspace\ops\mobile_entry.ps1 -Tool claude
```

## セットアップ手順

### 1. Tailscale を入れる

PC と iPhone の両方に Tailscale を入れる。

狙い:

- 自宅外からでも安全に接続できる
- ルーターのポート開放を避けられる
- 接続先が固定しやすい

### 2. Windows OpenSSH Server を有効化する

管理者 PowerShell で実施:

```powershell
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType Automatic
```

確認:

```powershell
Get-Service sshd
```

### 3. 鍵認証を設定する

PC 側:

- `C:\Users\ukowu\.ssh\authorized_keys` を作る
- iPhone 側 SSH アプリで作成した公開鍵を追記する

権限が厳しい場合は、まず自分のホーム配下だけで運用する。

### 4. スマホから接続する

接続先の考え方:

- ユーザー: `ukowu`
- ホスト: Tailscale のマシン名または Tailscale IP
- 接続後の起点: PowerShell

接続できたら:

```powershell
powershell -NoLogo -ExecutionPolicy Bypass -File C:\Users\ukowu\Desktop\novel\.workspace\ops\mobile_entry.ps1 -Tool codex
```

## スマホ側アプリのおすすめ

優先順位は次の通りです。

1. Blink Shell
2. Termius
3. ShellFish

この用途では Blink Shell が一番相性が良いです。理由は、長時間のターミナル操作がしやすく、後で WSL + tmux へ移行したときもそのまま活きるからです。

## Codex と Claude の使い分け

この `novel` 環境では次の分担が噛み合います。

- `codex`: 反復修正、CLI 中心の作業、長時間運用
- `claude`: 設計相談、長文の整理、重めの判断

スマホ SSH 運用だけを見ると、先に回すべき主役は `codex` です。

## まず最初にやること

順番はこれで十分です。

1. Tailscale を PC と iPhone に入れる
2. Windows OpenSSH Server を有効化する
3. 公開鍵認証を通す
4. スマホから SSH 接続する
5. `mobile_entry.ps1 -Tool codex` で入る

## 次の拡張候補

余裕が出たら次を足すとかなり快適になります。

### WSL Ubuntu 導入

目的:

- `tmux`
- `rg`
- `git`
- Linux 系ツール

を素直に使えるようにすること。

### tmux 常駐

これを入れると:

- 回線切断に強い
- 長い AI 実行を保持できる
- スマホ再接続が楽になる

### Claude watchdog の再活用

既存ファイル:

- `.workspace/ops/auto_claude.bat`
- `.workspace/ops/keep_claude_alive.ps1`

Claude Remote Control を再度使う場合は、認証を更新したうえでこのラインを戻せばよいです。

## 判断メモ

この環境では、いきなり「スマホだけで IDE 完全再現」を狙うより、

- まず SSH で安定接続
- `codex` を素早く起動
- 必要時だけ `claude`

の順で固める方が失敗しにくいです。

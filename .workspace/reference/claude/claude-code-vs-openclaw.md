# Claude Code と OpenClaw の比較メモ

更新日: 2026-03-11

## 結論

この `novel` ワークスペースでは、**主力は Claude Code のほうが向いています**。  
理由は単純で、すでに運用が Claude Code 前提でかなり組まれているからです。

- ルートに `CLAUDE.md` がある
- `constrain/CLAUDE.md` がある
- `.workspace/ops/auto_claude.bat` と `.workspace/ops/keep_claude_alive.ps1` がある
- `.workspace/handover/claude_mobile/` や `.workspace/reference/claude/claude-project-setup.md` も Claude 運用を前提にしている

つまり、この project では Claude Code を使うほうが**移行コストが低く、既存資産をそのまま活かしやすい**です。

一方で OpenClaw は、**常駐型の個人AIアシスタント**として使いたい場合に魅力があります。  
コード編集専用というより、Slack / Discord / Telegram / メール / カレンダー / GitHub などをまたいで、日常の作業全体を一つの AI に寄せたいなら候補になります。

## この project で Claude Code が良い点

### メリット

- **既存ドキュメントとの整合性が高い**
  - この repo はすでに Claude 向けの handover と運用メモが揃っている
- **導入済みフローをそのまま使える**
  - リモート運用やスマホ経由の想定まで既存ファイルに含まれている
- **コードベース作業に強い**
  - Anthropic 公式として、ターミナル・編集・GitHub Actions・subagents などの開発フローが整理されている
- **この workspace の用途と噛み合う**
  - `story-compiler` の構造確認
  - `constrain` の設定整理
  - handover ファイルを読みながらの継続作業

### デメリット

- **Claude 中心の設計に寄る**
  - 他モデルや他チャネルを主役にしたい場合は自由度が下がる
- **日常オペレーションの統合は OpenClaw ほど広くない**
  - メール、カレンダー、メッセージングを一体運用する発想は OpenClaw のほうが強い
- **この repo の外まで含めた常駐秘書用途にはやや寄せ直しが必要**
  - あくまで「開発・編集エージェント」として使うほうが自然

## この project で OpenClaw が良い点

### メリット

- **個人用 AI OS 的に使いやすい**
  - 公式情報では、ローカル中心で常駐し、Slack / Discord / Telegram / メール / GitHub / Google Calendar などと連携できる
- **メモリ・スキル・プラグイン前提で拡張しやすい**
  - 小説執筆だけでなく、日報、連絡、情報収集までまとめたい人には相性がある
- **モデル非依存の柔軟性がある**
  - Claude に固定せず、用途ごとに裏側を差し替えたい場合は魅力
- **私用・業務・創作を横断する AI ハブにしやすい**
  - 「小説 repo の編集」以外の仕事も同じ土台に載せやすい

### デメリット

- **この repo には OpenClaw 前提の運用資産がない**
  - handover、セットアップメモ、補助スクリプトが Claude 側に寄っている
- **導入と保守の設計コストが増える**
  - 何を OpenClaw に任せ、何を repo ローカルのルールに閉じるかを決め直す必要がある
- **Windows では WSL2 前提の案内が中心**
  - 現在の環境ですぐ軽く使う、という意味では Claude Code より一段重い
- **権限管理の面で慎重さが必要**
  - 多チャネル統合が強みであるぶん、メールやメッセージ連携を広げると管理対象も増える
- **この project の主目的には少しオーバースペック**
  - 今の `novel` は「執筆・設定・構造検証」が中心で、個人オペレーション統合まで必須ではない

## 判断基準

### Claude Code を選ぶべき場合

- この repo の既存資産をそのまま使いたい
- `CLAUDE.md` / handover / batch / PowerShell スクリプトを活かしたい
- 小説制作と story-compiler 検証を、repo 内で堅く回したい
- まずは摩擦なく運用したい

### OpenClaw を選ぶべき場合

- この repo だけでなく、日常作業全体を AI 一つに統合したい
- Slack / Discord / メール / カレンダー連携を本格的に使いたい
- モデルやプラグインを柔軟に差し替えたい
- 導入設計の手間を払ってでも、長期的に自分専用の AI 基盤を作りたい

## この project 向けの実務的なおすすめ

現時点では、**Claude Code を主運用にするのが妥当**です。  
理由は、すでにこの workspace が Claude 中心に整備されており、OpenClaw に切り替えて得られる利点より、移行の手間のほうが大きいからです。

OpenClaw を試すなら、置き換えではなく**補助レイヤー**として始めるのが良いです。

- 小説 repo の編集・構造確認: Claude Code
- 日報、通知、外部サービス連携、常駐秘書的な用途: OpenClaw

この分け方なら、既存資産を壊さずに OpenClaw の強みだけ試せます。

## 参考

ローカル根拠:

- `CLAUDE.md`
- `constrain/CLAUDE.md`
- `.workspace/ops/auto_claude.bat`
- `.workspace/ops/keep_claude_alive.ps1`
- `.workspace/reference/claude/claude-project-setup.md`

外部ソース:

- Anthropic Claude Code docs: https://docs.anthropic.com/
- OpenClaw docs: https://docs.openclaw.ai/
- OpenClaw GitHub: https://github.com/clawbotic/openclaw

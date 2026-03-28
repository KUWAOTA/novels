# Discordで文字起こしする方法

## 方法1: Discordの公式ボイスメッセージ（テキスト変換なし）
Discordネイティブには通話の自動文字起こし機能はない（2026年3月時点）。

---

## 方法2: Botを使う（おすすめ）

### Craig Bot
- 通話を録音して後でダウンロード可能
- 録音ファイルをWhisper等で文字起こしする運用が一般的
- https://craig.chat/

### Whisper Bot / SpeechBot 系
- 音声をリアルタイムでテキストに変換してチャンネルに投稿するBotがある
- 検索: "Discord transcription bot" で最新のものを探す
- 品質はOpenAI Whisperベースのものが高い

---

## 方法3: ローカルで文字起こし（精度高い）

1. Discordの通話をCraig BotやAudio Hijack（Mac）等で録音
2. 録音ファイルをOpenAI Whisperで文字起こし

```bash
# Whisperをローカルで使う場合
pip install openai-whisper
whisper audio.mp3 --language Japanese
```

または [Whisper Web](https://huggingface.co/spaces/openai/whisper) でブラウザから無料実行も可。

---

## 方法4: Discordを画面収録してCloudで処理
- OBS等で通話画面ごと録画
- 動画からYouTube自動字幕 or Whisperで文字起こし

---

## まとめ

| 用途 | おすすめ手段 |
|------|-------------|
| 手軽にリアルタイム | SpeechBot系のBot |
| 高精度・後処理OK | Craig録音 → Whisper |
| ローカルで完結したい | Whisperをローカルインストール |

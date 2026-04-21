# McKee『Dialogue』P1–P64 反映レポート

- 作成日: 2026-04-20
- 反映元メモ: `story-compiler/input/dialogue1.txt`
- 反映先: `story-compiler/modules/31_dialogue.yaml`（新規作成）、`story-compiler/system-prompt.md`、`story-compiler/CLAUDE.md`

---

## 1. 抽出した原則一覧（メモ行番号 = 概ねP番号相当）

メモは P64 までの読書ノートなので、同一ファイル内の行範囲を原則の出典アンカーとして併記する。

### 1-1. 台詞の定義（メモ L3–18 / `dialogue_definition`）
- 台詞は「欲求（desire）」「必要（need）」を原因として発生する。
- 台詞は「欲求」「意図（intention）」「活力（vitality）」で彩られる。これらがない台詞はエラー（compile_error）。
- 台詞は発話（speech）を通じて、(a) 話者の性格を露呈し、(b) 対象に力（power）を及ぼす。

### 1-2. 宛先3タイプ（メモ L20–23 / `addressee_types`）
- `to_other` / `to_self` / `to_audience` の3タイプ。

### 1-3. 形態2タイプ（メモ L25–28 / `form_types`）
- `drama`（シーン内の劇台詞）／ `narration`（シーン外の語り）。
- いずれも観客/読者を感情的に動かす（同様に、自己への語りも）。

### 1-4. メディアと台詞の制約（メモ L30–32 / `media_constraints`）
- 演劇は sound media、映画は visual media、小説は mind media。
- 小説はすべての台詞タイプを自由に使える。

### 1-5. 一人称（メモ L34–48 / `pov_dialogue_rules.first_person`）
- スコープ: 出来事／対話中の劇的語り／自己への語り。
- 一人称は「不十分な観測者」であり、強い自己関心にフォーカスし、他者の内面は語り手の推察を通じて間接的に読者へ届く。
- 全知一人称は原則アンチパターン（compile_error、特別事情のみ例外）。

### 1-6. 三人称（メモ L50–77 / `pov_dialogue_rules.third_person`）
- 語り手属性: 無知〜全知／中立〜批判／信頼不可〜可。
- 社会倫理観や意見を持ちうる。
- **重要**: 三人称の語り ≠ ダイアローグ（キャラクター由来でないため）。
- アンチパターン: 「作者の声」として語る（warning）。共感・好奇心が損なわれる。
- 客観的三人称: 見せる > 語る、解釈しない。
- 主観的三人称: 見透かす、感情・思考を描く。

### 1-7. 二人称（メモ L79–84 / `pov_dialogue_rules.second_person`）
- 二人称は一人称または三人称の変種。「きみ」を「わたし」や「彼」に置換すると化けの皮が剥がれる。
- 採用時は info 通知。

### 1-8. 台詞の3機能（メモ L87–91 / `dialogue_functions`）
- `exposition`（明瞭化）、`characterization`（性格描写）、`action`（アクション）。
- いずれにも分類されない台詞は warning。

### 1-9. 明瞭化（exposition）の最小化（メモ L93–101 / `exposition_minimization`）
- 少なすぎれば理解不能、多すぎれば興醒め。最小化せよ。
- **原則**: 明瞭化する前に必要な情報を価値順に並べ、読者に伝わる最小閾値で切る。
- 反復して明瞭化してよいのは重要事実のみ。

### 1-10. 語らず見せろ（メモ L102–118 / `exposition_minimization.show_dont_tell`, `tell_definition`, `show_definition`, `necessity_vs_exposition`）
- ドラマ形態では語らず見せろ。
- 「語り」定義: (1) キャラクターの探求を止める → (2) 過剰情報を流し込む（warning）。
- 「見せる」定義: 願望を満たそうともがくキャラクターのリアルな発話。
- 必然性の強弱で show/tell が決まる。語り（tell）はサブテキストを破壊する。

### 1-11. 重要事実の配置（メモ L119–126 / `critical_facts_placement`）
- 重要事実は必然的ストーリーの中で効果的タイミングに置く。
- 手段は「語りの疾走感（narrative velocity）」と「弾薬としての明瞭化（exposition as ammunition）」。

### 1-12. 語りの疾走感（メモ L127–141 / `narrative_velocity`）
- 受け手の心と物語の良コミュニケーションが生む副作用。
- 明瞭化がスパイスとして疑問を生み、読者が答えを探すことで疾走感が高まる。

### 1-13. 弾薬としての明瞭化（メモ L142–159 / `exposition_as_ammunition`）
- 共感で動機付けられた好奇心の状態で、決定的タイミングに明瞭化を放つ。
- 実装は「秘密の暴露」。通常キャラは秘密を隠し、ジレンマ/転機で暴露する。

### 1-14. バックストーリーと秘密（メモ L161–172 / `backstory_and_secrets`）
- 秘密はバックストーリーから生まれる。
- バックストーリー ≠ 過去のすべて。大きな転機で使う「衝撃」の素材。

### 1-15. ナレーションによる直接語り（メモ L173–194 / `narration_direct_exposition`）
- ナレーションでの直接的明瞭化は OK。強みは「スピード」「対比による焦点化」。
- アンチパターン: 「それから…それから…」の羅列（warning、シーン化や語り手挿入で対処）。
- 高速明瞭化には必然性が必須（必然性なければ info dump と区別できない）。

### 1-16. アクションとしての台詞（メモ L197–207 / `dialogue_as_action`）
- アクションは `mind` / `physical` / `word` の3種。
- 各アクションは真の人格（True Character, 23_character-components と連動）から humanity／its lack を露呈する。

---

## 2. 反映先ファイルと変更内容

### 2-1. 新規作成 `story-compiler/modules/31_dialogue.yaml`
McKee『Dialogue』P1–P64 を 13 のPartで構造化。主要セクション:

| セクション | 内容 |
|-----------|------|
| Part 1 | 台詞の定義（cause: desire/need、coloring: desire/intention/vitality） |
| Part 2 | 宛先3タイプ（to_other/to_self/to_audience） |
| Part 3 | 形態2タイプ（drama/narration） |
| Part 4 | メディア別制約（theater/film/novel） |
| Part 5 | POV別台詞原則（first/third/second） |
| Part 6 | 台詞の3機能 |
| Part 7 | 明瞭化最小化 + show/tell + 必然性 |
| Part 8 | 重要事実配置（疾走感・弾薬） |
| Part 9 | バックストーリーと秘密 |
| Part 10 | ナレーション直接語り（それから連鎖対策・必然性） |
| Part 11 | アクションとしての台詞（True Character連動） |
| Part 12 | コンパイル検証ルール統合（compile_error 3件、warning 多数） |
| Part 13 | 推奨アノテーション（台詞ブロックに付与すべきメタ情報） |

**主要な検証ルール**:
- `dialogue_without_desire_or_need` → compile_error
- `dialogue_without_coloring` → compile_error
- `omniscient_first_person_detected` → compile_error
- `drama_dialogue_tells_instead_of_shows` → warning
- `subtext_killed_by_telling` → warning
- `secret_revelation_without_turning_point` → warning
- `and_then_chaining_narration` → warning
- `speed_exposition_without_necessity` → warning
- `author_voice_in_third_person` → warning

関連モジュールとの連動:
- `12_exposition.yaml`（情報提示を台詞側から補強）
- `13_scene-transition.yaml`（バックストーリー放出）
- `23_character-components.yaml`（真の人格）
- `27_show-vs-tell.yaml`（描写/語りの判断軸）
- `28_pov.yaml`（視点タイプ）

### 2-2. `story-compiler/system-prompt.md`
- `active_modules` に `31_dialogue` 追加。
- Phase 5（Quality Check）に 8 項目のダイアローグ検証チェックリストを追加。
- `future_modules` セクションで `dialogue_rules` を「済み（P65以降で拡張予定）」に変更。

### 2-3. `story-compiler/CLAUDE.md`
- モジュール一覧表に `31_dialogue.yaml` 行を追加。

---

## 3. P65以降を読み進める際に拡張すべきポイント（示唆）

P1–P64 は「台詞とは何か・機能・マクロレベルのPOV/明瞭化/必然性」に集中していた。以降の章で扱われると推測される領域と、本モジュールに追加予定のフィールドを整理する。

### 3-1. 具体技法層（Micro-craft Layer）— Part 14〜として追加候補
- **サブテキスト具体論**: いま `tell_definition` が「subtext を破壊する」と宣言しているだけで、subtext の**定義**と検出ルールが未整備。P65以降にサブテキストの具体例があれば `subtext_integrity_check` を新設。
- **台詞の構文/リズム**: 文の長さ、中断、反復、沈黙。行レベルの韻律的検証が追加可能。
- **省略・間・ト書き**: 小説における沈黙や行間の機能。
- **方言・イディオム・語彙選択**: キャラクター固有の声（voice）の差異。`30_style-discipline.yaml` と境界調整が必要。

### 3-2. 台詞の病理 / 欠陥パターン
- **過剰台詞（overwriting）**、**平板化**、**説明的な答弁**、**メロドラマ化**。
- 既存 `24_discernment.yaml` の鑑識眼と連携して「陳腐な台詞」の検出ルールを拡張可能。

### 3-3. キャラクター声の差異化（Voice Differentiation）
- 複数キャラの台詞が入れ替え可能になっていないか検出するチェック。
- 現状は定性的に `23_character-components` で扱っているが、「台詞の voice_signature」を定義して検出できる。

### 3-4. 沈黙・不在としての台詞
- 話さないこと、答えないこと、遅延すること自体が台詞になる構造。
- P65以降でこの論が展開されていれば `silence_as_dialogue` セクションを新設。

### 3-5. ジャンル別台詞（Genre Voice）
- コメディ・悲劇・リアリズム・スタイライズドなどジャンルごとの台詞作法。
- `15_genre-constraints.yaml` と連動する `dialogue_genre_rules` を追加可能。

### 3-6. 台詞の転機（Turn in Dialogue）
- `19_scene-mastery` の value change を台詞レベルまで下ろす。
- 「1つの台詞の前後で価値が反転する最小単位」を `dialogue_micro_beat` として規定。

### 3-7. Part 13 の `recommended_annotation` 拡張
- P65以降で新たなメタ属性（トーン、テンポ、サブテキスト強度、ターゲット心理など）が出るなら随時追加。

### 3-8. 英語/日本語での差異
- 敬語体系・主語省略・語尾変化など日本語特有の台詞作法は、本モジュールでは未反映。
- 英語原著ベースのため、日本語拡張は別途 `31_dialogue_ja_addendum.yaml` として検討。

---

## 4. 既知の未対応事項

- P1–P64 のメモにあった「drama_dialogue の tell 条件」を検証するには、各 Dialogue ノードに `form_type` と `show_or_tell` が annotation されている必要がある。現状のテンプレート（`templates/scene.yaml` 等）にはこのフィールドが存在しない可能性があるため、次の作業で `templates/scene.yaml` にダイアローグブロック用のサブスキーマを追加することを推奨（今回は範囲外のため保留）。
- `dialogue_without_desire_or_need` を compile_error にしたが、既存作品（ACT1/ACT2）の台詞に一括で適用するとエラーが大量発生する可能性が高い。初期導入段階では **Phase 5 の「任意チェック」** として扱うのが実務的。必要に応じて severity を warning にダウングレードする運用オプションを検討。

---

## 5. 変更ファイルのパス一覧

- `c:\Users\ukowu\Desktop\novel\story-compiler\modules\31_dialogue.yaml`（新規）
- `c:\Users\ukowu\Desktop\novel\story-compiler\system-prompt.md`（変更）
- `c:\Users\ukowu\Desktop\novel\story-compiler\CLAUDE.md`（変更：モジュール表に1行追加）

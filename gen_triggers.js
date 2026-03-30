const fs = require('fs');

const apos = "&apos;";

function esc(s) {
  return s.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;');
}

function beatBlock(id, headerText, hFill, hStroke, starter, yBase) {
  const lines = [];
  lines.push(`<mxCell id="${id}_hdr" value="&lt;b&gt;${esc(headerText)}&lt;/b&gt;" style="text;html=1;strokeColor=${hStroke};fillColor=${hFill};align=left;verticalAlign=middle;whiteSpace=wrap;rounded=4;fontSize=12;fontStyle=1;spacingLeft=8;" vertex="1" parent="1"><mxGeometry x="10" y="${yBase}" width="2380" height="26" as="geometry" /></mxCell>`);
  lines.push(`<mxCell id="${id}_r1l" value="&lt;font color=${apos}#1565C0${apos}&gt;&lt;b&gt;① 価値変化 Before&lt;/b&gt;&lt;/font&gt; — 開始時のキャラの気持ちは？" style="text;html=1;strokeColor=#90CAF9;fillColor=#E8F0FE;align=left;verticalAlign=top;whiteSpace=wrap;rounded=4;fontSize=11;spacingLeft=8;spacingTop=6;" vertex="1" parent="1"><mxGeometry x="10" y="${yBase+30}" width="1185" height="50" as="geometry" /></mxCell>`);
  lines.push(`<mxCell id="${id}_r1r" value="&lt;font color=${apos}#1565C0${apos}&gt;&lt;b&gt;① 価値変化 After&lt;/b&gt;&lt;/font&gt; — 終了時の気持ちは？" style="text;html=1;strokeColor=#90CAF9;fillColor=#E8F0FE;align=left;verticalAlign=top;whiteSpace=wrap;rounded=4;fontSize=11;spacingLeft=8;spacingTop=6;" vertex="1" parent="1"><mxGeometry x="1205" y="${yBase+30}" width="1185" height="50" as="geometry" /></mxCell>`);
  lines.push(`<mxCell id="${id}_r2l" value="&lt;font color=${apos}#2E7D32${apos}&gt;&lt;b&gt;② 欲求&lt;/b&gt;&lt;/font&gt; — このキャラが一番欲しいものは？" style="text;html=1;strokeColor=#A5D6A7;fillColor=#E8F5E9;align=left;verticalAlign=top;whiteSpace=wrap;rounded=4;fontSize=11;spacingLeft=8;spacingTop=6;" vertex="1" parent="1"><mxGeometry x="10" y="${yBase+84}" width="1185" height="50" as="geometry" /></mxCell>`);
  lines.push(`<mxCell id="${id}_r2r" value="&lt;font color=${apos}#C62828${apos}&gt;&lt;b&gt;③ 敵対力&lt;/b&gt;&lt;/font&gt; — 何がそれを阻んでいる？" style="text;html=1;strokeColor=#EF9A9A;fillColor=#FFEBEE;align=left;verticalAlign=top;whiteSpace=wrap;rounded=4;fontSize=11;spacingLeft=8;spacingTop=6;" vertex="1" parent="1"><mxGeometry x="1205" y="${yBase+84}" width="1185" height="50" as="geometry" /></mxCell>`);
  lines.push(`<mxCell id="${id}_r3l" value="&lt;font color=${apos}#E65100${apos}&gt;&lt;b&gt;④ ギャップ 期待&lt;/b&gt;&lt;/font&gt; — 何を期待して行動した？" style="text;html=1;strokeColor=#FFCC80;fillColor=#FFF3E0;align=left;verticalAlign=top;whiteSpace=wrap;rounded=4;fontSize=11;spacingLeft=8;spacingTop=6;" vertex="1" parent="1"><mxGeometry x="10" y="${yBase+138}" width="1185" height="50" as="geometry" /></mxCell>`);
  lines.push(`<mxCell id="${id}_r3r" value="&lt;font color=${apos}#E65100${apos}&gt;&lt;b&gt;④ ギャップ 現実&lt;/b&gt;&lt;/font&gt; — 実際に何が起きた？" style="text;html=1;strokeColor=#FFCC80;fillColor=#FFF3E0;align=left;verticalAlign=top;whiteSpace=wrap;rounded=4;fontSize=11;spacingLeft=8;spacingTop=6;" vertex="1" parent="1"><mxGeometry x="1205" y="${yBase+138}" width="1185" height="50" as="geometry" /></mxCell>`);
  lines.push(`<mxCell id="${id}_r4" value="&lt;font color=${apos}#6A1B9A${apos}&gt;&lt;b&gt;⑤ 選択&lt;/b&gt;&lt;/font&gt; — キャラはどう行動する？ ｜ たたき台:「${esc(starter)}」書き直すだけでOK" style="text;html=1;strokeColor=#CE93D8;fillColor=#F3E5F5;align=left;verticalAlign=top;whiteSpace=wrap;rounded=4;fontSize=11;spacingLeft=8;spacingTop=6;" vertex="1" parent="1"><mxGeometry x="10" y="${yBase+192}" width="2380" height="65" as="geometry" /></mxCell>`);
  return lines.join('\n');
}

function actHeader(id, text, fill, stroke, y) {
  return `<mxCell id="${id}" value="&lt;b&gt;${esc(text)}&lt;/b&gt;" style="text;html=1;strokeColor=${stroke};fillColor=${fill};align=center;verticalAlign=middle;whiteSpace=wrap;rounded=4;fontSize=14;fontStyle=1;" vertex="1" parent="1"><mxGeometry x="10" y="${y}" width="2380" height="28" as="geometry" /></mxCell>`;
}

const acts = [
  { id:'act1', text:'ACT 1 — 小学生', fill:'#D6E4F0', stroke:'#4A7FB5', beats:[
    {id:'b11', text:'1-1: ASD傾向で浮いている', fill:'#D6E4F0', stroke:'#4A7FB5', starter:'休み時間、教室のざわめきの中で、主人公だけが自分の席に座っている。隣の子が話しかけてきたが、何と返せばいいかわからない。'},
    {id:'b12', text:'1-2: 父に仮説・論理・数式を教わる — 父の鮮やかな導き', fill:'#D6E4F0', stroke:'#4A7FB5', starter:'父がノートに数式を書き始める。車椅子から少し身を乗り出して。なあ、これが何に見える？'},
    {id:'b13', text:'1-3: いじめっ子が嫉妬 — 鈍くさいのに父に愛されている', fill:'#FDEBD0', stroke:'#E67E22', starter:'参観日。車椅子の父が教室に入る。A男はその光景を、握りしめた拳の向こうに見ている。'},
    {id:'b14', text:'1-4: 中学入学直後、父の死 — 唯一の理解者を失う', fill:'#F5C6CB', stroke:'#C0392B', starter:'電話が鳴った。母の声がいつもと違う。主人公はまだ制服に慣れていない体で病院へ走った。'},
  ]},
  { id:'act2', text:'ACT 2 — 中学時代', fill:'#E8DAF0', stroke:'#7B4F9E', beats:[
    {id:'b21', text:'2-1: 保健室登校でB子と知り合う', fill:'#E8DAF0', stroke:'#7B4F9E', starter:'保健室のドアを開けると、窓際のベッドの端に見たことのない女の子が座っていた。こちらを見て、少し笑った。'},
    {id:'b22', text:'2-2: A男への教育虐待が加速 / いじめ過激化', fill:'#FDEBD0', stroke:'#E67E22', starter:'A男の腕に、また新しい痣があった。でもA男は笑っている。クラスメイトの前では、いつも笑っている。'},
    {id:'b23', text:'2-3: B子が心のよりどころに / 主人公が論理で防御', fill:'#E8DAF0', stroke:'#7B4F9E', starter:'B子が保健室で泣いている。主人公はどうすればいいかわからないが、隣に座った。'},
    {id:'b24', text:'2-4: B子とのデート — 幸せの絶頂', fill:'#E8DAF0', stroke:'#7B4F9E', starter:'帰り道、B子の手が自分の手に触れた。たぶん偶然じゃない。主人公は握り返すことができた。'},
    {id:'b25', text:'2-5: B子の自殺 — 幸せの絶頂で死を選ぶ（主人公は苦しみの末と誤解）', fill:'#F5C6CB', stroke:'#C0392B', starter:'朝、学校に着くと教室が騒がしかった。主人公はまだ知らない。昨日あんなに笑っていた彼女がもういないことを。'},
  ]},
  { id:'act3', text:'ACT 3 — 灘〜東大', fill:'#D6E4F0', stroke:'#4A7FB5', beats:[
    {id:'b31', text:'3-1: 灘に合格（Aは落ちる）', fill:'#D6E4F0', stroke:'#4A7FB5', starter:'合格発表のボードの前。自分の番号はある。喜びより先に、B子のことを思い出した。'},
    {id:'b32', text:'3-2: エリート環境で打ち解ける — 初めて通じる体験', fill:'#D6E4F0', stroke:'#4A7FB5', starter:'灘の教室で、初めて自分の話が最後まで聞かれた。それだけで涙が出そうになった。'},
    {id:'b33', text:'3-3: B子をここに連れてこれれば — 後悔', fill:'#E8DAF0', stroke:'#7B4F9E', starter:'友人たちと数学の話をしている。ふと思う。彼女がここにいたら笑う人はいなかったかもしれない。'},
    {id:'b34', text:'3-4: 厳密＝救済の確信を深める', fill:'#D6E4F0', stroke:'#4A7FB5', starter:'数式を解くように人間関係も解けるはずだ。灘の仲間との成功体験がその確信を裏付けている。'},
    {id:'b35', text:'3-5: 東大合格（Aは後期東工大）', fill:'#FDEBD0', stroke:'#E67E22', starter:'東大の合格通知を手にして思う。父が教えてくれた方法で来れた。あとはこの力で世界を正しくするだけだ。'},
  ]},
  { id:'act4', text:'ACT 4 — Google Japan', fill:'#FDEBD0', stroke:'#E67E22', beats:[
    {id:'b41', text:'4-1: Google就職 — 主人公は実力、A男はコミュ力', fill:'#FDEBD0', stroke:'#E67E22', starter:'Google Japanのオフィスに初めて足を踏み入れた日、受付の向こうに見覚えのある横顔があった。'},
    {id:'b42', text:'4-2: 過去トラウマの想起 / 清算への葛藤', fill:'#FDEBD0', stroke:'#E67E22', starter:'ふとした瞬間に教室の光景がフラッシュバックする。A男の顔。B子の笑顔。過去を清算しなければと思う。'},
    {id:'b43', text:'4-3: Aのストーキング — 負けたくなくて同じ職場に', fill:'#FDEBD0', stroke:'#E67E22', starter:'社内ですれ違ったときA男は笑顔で挨拶してきた。主人公はその笑顔の奥にある何かに気づけなかった。'},
    {id:'b44', text:'4-4: 主人公が先に昇進 → A男が部下になる', fill:'#FDEBD0', stroke:'#E67E22', starter:'昇進の辞令を受け取った翌日、A男がおめでとうございますと言った。その声には何の感情もなかった。'},
    {id:'b45', text:'4-5: 善意の教育 → 無自覚な加害 — いじめの再現構造', fill:'#F5C6CB', stroke:'#C0392B', starter:'もう一回説明するよ。主人公はホワイトボードに向き直る。A男は黙って座っている。この沈黙の意味を主人公は理解できない。'},
    {id:'b46', text:'4-6: A男崩壊・出社拒否', fill:'#F5C6CB', stroke:'#C0392B', starter:'A男のデスクに今日も誰も座っていない。PCの電源ランプが消えたまま一週間になる。'},
    {id:'b47', text:'4-7: 過去のA男と同じことをしていたと気づく', fill:'#F5C6CB', stroke:'#C0392B', starter:'ふと気づく。自分がA男に向けていた言葉はあの時A男が自分に向けていた暴力と同じ構造をしている。'},
  ]},
  { id:'act5', text:'ACT 5 — クライマックス', fill:'#F5C6CB', stroke:'#C0392B', beats:[
    {id:'b51', text:'5-1: A男の自殺企図 — B子のトラウマが再燃', fill:'#FFF3CD', stroke:'#FFC107', starter:'深夜、スマホが震えた。画面にA男の名前。出ると声が聞こえない。あの時と同じだ。B子の時と同じだ。'},
    {id:'b52', text:'5-2: クライマックス — 理解できなくても傍にいる', fill:'#D6E4F0', stroke:'#4A7FB5', starter:'主人公は立ち尽くしている。正しい言葉が見つからない。でも足が動いた。言葉ではなくただ隣に座った。'},
    {id:'b53', text:'5-3: エピローグ — 新しい平衡', fill:'#D4EDDA', stroke:'#28A745', starter:'朝の光が部屋に差し込む。主人公は窓を開ける。何も解決していない。でも今日も生きている。'},
  ]},
];

let y = 260;
const parts = [];

for (const act of acts) {
  parts.push(actHeader(act.id, act.text, act.fill, act.stroke, y));
  y += 36;
  for (const b of act.beats) {
    parts.push(beatBlock(b.id, b.text, b.fill, b.stroke, b.starter, y));
    y += 265;
  }
}

const header = `<mxfile host="app.diagrams.net" modified="2026-03-28T00:00:00.000Z" agent="Claude" version="21.0.0">
  <diagram name="scene_triggers" id="scene_triggers_001">
    <mxGraphModel dx="1422" dy="762" grid="0" gridSize="10" guides="1" tooltips="1" connect="0" arrows="0" fold="0" page="0" pageScale="1" pageWidth="2400" pageHeight="7200" math="0" shadow="0">
      <root>
        <mxCell id="0" />
        <mxCell id="1" parent="0" />
        <mxCell id="title" value="Constrain — McKee理論から逆算したシーン書き出しトリガー" style="text;html=1;strokeColor=none;fillColor=none;align=center;verticalAlign=middle;whiteSpace=wrap;rounded=0;fontSize=18;fontStyle=1;" vertex="1" parent="1">
          <mxGeometry x="10" y="10" width="2380" height="40" as="geometry" />
        </mxCell>
        <mxCell id="legend" value="&lt;b&gt;McKee理論からの逆算 — なぜこの問いか？&lt;/b&gt;&lt;br&gt;&lt;br&gt;シーンが機能するための5条件（McKee準拠）:&lt;br&gt;&lt;br&gt;&lt;font color=${apos}#1565C0${apos}&gt;&lt;b&gt;① 価値変化&lt;/b&gt;&lt;/font&gt;　シーン前後で感情/状態が変わらなければそのシーンは存在意義がない → Before/Afterを問う&lt;br&gt;&lt;font color=${apos}#2E7D32${apos}&gt;&lt;b&gt;② 欲求&lt;/b&gt;&lt;/font&gt;　キャラが何かを欲しがっていなければ行動が生まれない → 一番欲しいものを問う&lt;br&gt;&lt;font color=${apos}#C62828${apos}&gt;&lt;b&gt;③ 敵対力&lt;/b&gt;&lt;/font&gt;　欲求を阻む力がなければドラマにならない → 阻むものを問う&lt;br&gt;&lt;font color=${apos}#E65100${apos}&gt;&lt;b&gt;④ ギャップ&lt;/b&gt;&lt;/font&gt;　行動の期待と結果の落差こそが物語の推進力 → 期待/現実を問う&lt;br&gt;&lt;font color=${apos}#6A1B9A${apos}&gt;&lt;b&gt;⑤ 選択&lt;/b&gt;&lt;/font&gt;　キャラが選び行動しなければ物語は進まない → どう行動するかを問う&lt;br&gt;&lt;br&gt;各欄は色分けでMcKee概念と対応。+たたき台の一文つき（書き直すだけでOK）" style="text;html=1;strokeColor=#FFC107;fillColor=#FFFDE7;align=left;verticalAlign=middle;whiteSpace=wrap;rounded=4;fontSize=12;spacingLeft=10;spacingRight=10;" vertex="1" parent="1">
          <mxGeometry x="10" y="55" width="2380" height="195" as="geometry" />
        </mxCell>`;

const footer = `
      </root>
    </mxGraphModel>
  </diagram>
</mxfile>`;

const content = header + '\n' + parts.join('\n') + footer;

const outPath = 'C:/Users/ukowu/Desktop/novel/constrain/brainstorm/scene_triggers.drawio';
fs.writeFileSync(outPath, content, 'utf8');
console.log('Written:', content.length, 'bytes, final y:', y);

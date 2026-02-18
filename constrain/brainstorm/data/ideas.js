window.STORY_NODES = [
    // ══════════════════════════════════════════════════════════════
    // MAIN TRUCK
    // ══════════════════════════════════════════════════════════════
    { id: 'root', label: 'Start', description: '物語の開始', x: 50, y: 300, type: 'start' },

    // ACT 1
    { id: 'act1', label: 'ACT 1\n原点: 再現性の獲得', description: 'ASD的傾向といじめ。\nルールなき感情の世界から、\n再現性のある科学の世界への逃避と適応。', x: 250, y: 300, type: 'act', status: 'preferred', value_change: '孤立 → 適応' },

    { id: 'M-1-1', parent: 'act1', label: 'いじめと孤立', description: '空気が読めず地雷を踏む。\n再現性のない「努力しろ」という言葉への絶望。', x: 380, y: 300, type: 'beat', status: 'preferred', value_change: '安全 → 危険' },
    { id: 'M-1-2', parent: 'M-1-1', label: '法則の発見', description: 'カフェで集中できる法則を発見。\n自分でルールを見つける喜び。', x: 510, y: 300, type: 'beat', status: 'preferred', value_change: '無力 → 手段' },
    { id: 'M-1-3', parent: 'M-1-2', label: '師との出会い', description: '物理教師との出会い。\n「言葉で分かり合える」体験。', x: 640, y: 300, type: 'beat', status: 'preferred' },
    { id: 'M-1-4', parent: 'M-1-3', label: '過剰適応', description: '他者の行動モデルを作成。\n本能で生きる他者より他者を理解する。', x: 770, y: 300, type: 'beat', status: 'preferred' },
    { id: 'M-1-5', parent: 'M-1-4', label: '統計的思考への萌芽', description: '全てを演繹(公式)で解くのは無理だと悟る。\n「だいたいこうなる」という統計的・曖昧な予測\nを許容し始める（ゴールへの端緒）。', x: 900, y: 300, type: 'beat', status: 'candidate' },

    // ACT 2
    { id: 'act2', parent: 'M-1-5', label: 'ACT 2\n上昇と歪み', description: '社会人編。\n曖昧さを悪とし、厳密さを強制する\n「Constrain」の開発と成功。', x: 1080, y: 300, type: 'act', status: 'preferred', value_change: '適応 → 支配' },

    { id: 'M-2-1', parent: 'act2', label: '厳密さの拒絶者', description: '「言葉に厳しいと怒る人」に遭遇。\n適応するため、表面上は厳密さを隠し、\n愚かなふりをしてやり過ごす処世術を身につける。\nしかし内心のストレスは限界に達する。', x: 1210, y: 300, type: 'beat', status: 'preferred', value_change: '忍耐 → 爆発' },
    { id: 'M-2-2', parent: 'M-2-1', label: 'Constrain開発', description: 'Haskell製。\n隠していた厳密さを解放する場所。\n自分だけの「正しい世界」を作る。', x: 1340, y: 300, type: 'beat', status: 'preferred' },
    { id: 'M-2-3', parent: 'M-2-2', label: '成功と再会', description: 'ビジネスで大成功。\nかつてのいじめっ子Aが下請けとして現れる。', x: 1470, y: 300, type: 'beat', status: 'preferred', value_change: '劣等 → 優位' },
    { id: 'branch_point', parent: 'M-2-3', label: '分岐点', description: 'ここから物語が大きく分かれる', x: 1600, y: 300, type: 'point' },

    // ══════════════════════════════════════════════════════════════
    // BRANCH: Tragedy & Synthesis (NEW PREFERRED)
    // ══════════════════════════════════════════════════════════════
    { id: 'Tragedy-Start', parent: 'branch_point', label: '悲劇と統合\n(自殺・崩壊編)', description: '厳密さを武器にした結果、悲劇が起きる。\n一度全てを否定し、そこから統合へ向かう。', x: 1730, y: 100, type: 'act', status: 'preferred' },

    { id: 'Tragedy-1', parent: 'Tragedy-Start', label: 'Aへの尋問', description: 'ミスをしたAを「何故？」と詰め続ける。\n正義の執行のつもりだが、実は復讐。', x: 1880, y: 100, type: 'beat', status: 'preferred', value_change: '正義 → 暴力' },

    // TRAGEDY BRANCH A: Suicide Route
    { id: 'Tragedy-2A', parent: 'Tragedy-1', label: 'Aの自殺', description: 'Aが自殺（または未遂）。\n「完璧な言葉」が人を殺した事実。', x: 2030, y: 50, type: 'beat', status: 'preferred', value_change: '勝利 → 喪失' },

    // TRAGEDY BRANCH B: Realization Route
    { id: 'Tragedy-2B', parent: 'Tragedy-1', label: '復讐欲の自覚', description: '正義だと思っていた行動の裏に、\n「Aを傷つけたい」という昏い欲望があったと気づく。', x: 2030, y: 200, type: 'beat', status: 'preferred', value_change: '保身 → 自己嫌悪' },

    // MERGE
    { id: 'Tragedy-Merge', parent: ['Tragedy-2A', 'Tragedy-2B'], label: '全否定', description: '「自分は間違っていた」\n自信の喪失により、Constrainを即座に停止。\n全ルール撤廃。', x: 2280, y: 100, type: 'beat', status: 'preferred', value_change: '確信 → 拒絶' },

    { id: 'Tragedy-5', parent: 'Tragedy-Merge', label: '組織の崩壊', description: 'ルールがなくなり、現場は大混乱。\n社員「ガイドラインを戻してくれ！」', x: 2430, y: 100, type: 'beat', status: 'preferred', value_change: '自由 → 混沌' },
    { id: 'Tragedy-6', parent: 'Tragedy-5', label: 'ジンテーゼ', description: '厳密さ（構造）は必要だが、\nそれを罰（武器）に使ってはいけない。\n「優しい厳密さ」への統合。', x: 2580, y: 100, type: 'climax', status: 'preferred', value_change: '否定 → 統合' },

    // ══════════════════════════════════════════════════════════════
    // BRANCH: Rigorous Triumph (OLD PREFERRED -> CANDIDATE)
    // ══════════════════════════════════════════════════════════════
    { id: 'RT-Start', parent: 'branch_point', label: '厳密化の勝利\n(単一責任編)', description: '曖昧さに逃げず、厳密化を突き詰める。\nしかし勝利の代償として痛みが残る。', x: 1730, y: 300, type: 'act', status: 'candidate' },

    { id: 'RT-1', parent: 'RT-Start', label: 'Bとの論理的和解', description: 'Bの感覚的な悩みを、徹底的な言語化で解決。\n「言葉にすれば救える」と証明する。', x: 1880, y: 300, type: 'beat', status: 'candidate', value_change: '断絶 → 理解' },
    { id: 'RT-2', parent: 'RT-1', label: '世界のデバッグ', description: '世界の「曖昧さ（バグ）」を修正しまくる。\n世界がクリアになり、自信を深める。', x: 2030, y: 300, type: 'beat', status: 'candidate', value_change: '混沌 → 秩序' },
    { id: 'RT-3', parent: 'RT-2', label: 'Aへの断罪', description: 'Aの感情的な苦しみを「定義不足」と一刀両断。\n論理で圧倒し、勝利する。', x: 2180, y: 300, type: 'beat', status: 'candidate', value_change: '対立 → 圧倒' },
    { id: 'RT-4', parent: 'RT-3', label: '問い (Ending)', description: 'Aは論破され傷ついて去る。\n残されたのは完璧な論理と、胸の痛み。\n「バグは取れた。これでよかったのか？」', x: 2330, y: 300, type: 'beat', status: 'candidate', value_change: '勝利 → 実存的敗北' },

    // ══════════════════════════════════════════════════════════════
    // BRANCH: Faith Collapse (REJECTED)
    // ══════════════════════════════════════════════════════════════
    { id: 'FC-Start', parent: 'branch_point', label: '信仰崩壊\n(旅に出る編)', description: '厳密さが瓦解し、旅に出る。\n曖昧さの価値に気づく（未完成）。', x: 1730, y: 500, type: 'act', status: 'rejected' },

    { id: 'FC-1', parent: 'FC-Start', label: 'Bとの出会い', description: 'めちゃくちゃなBに惹かれる', x: 1880, y: 500, type: 'beat', status: 'rejected' },
    { id: 'FC-2', parent: 'FC-1', label: 'Constrainの亀裂', description: 'Bが色を失う', x: 2030, y: 500, type: 'beat', status: 'rejected' },
    { id: 'FC-4', parent: 'FC-2', label: '瓦解・旅へ', description: '生きる意味を問われ答えられず。\n全て捨てて旅に出る。', x: 2180, y: 500, type: 'beat', status: 'rejected' },

    // ══════════════════════════════════════════════════════════════
    // OTHER BRANCHES
    // ══════════════════════════════════════════════════════════════
    { id: 'RC-Start', parent: 'branch_point', label: '恋愛クライシス', description: '恋愛トラブルが主軸。\nテーマに対して軽いため保留。', x: 1730, y: 700, type: 'act', status: 'deferred' }
];

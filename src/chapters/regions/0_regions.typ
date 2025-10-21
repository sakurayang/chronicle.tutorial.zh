#import "/src/book.typ": book-page
#import "@preview/shiroa:0.2.3":cross-link
#import "../../mods.typ":tips, info, warn, error, success
#show: book-page.with(title: "")

#let links = (
  village: cross-link("/chapters/regions/1_village.typ")[#text(fill:black, "村庄")]
)

= 区域总览

//#box(height: 5em)
//#warn([注意],[以下内容涉及剧透，请酌情观看])
//#box(height: 30em)

*点击区域名称可前往对应页面*

#show table.cell.where(x: 0): strong
#show table.cell.where(y: 0): it => strong(align(center, it))
#set table(
  fill: (x, y) =>
    if x == 0 and y == 0 {white.transparentize(100%)}
    else if x == 0 {white}
    else if y == 0 {color.gray.lighten(50%)}
    else if x !=0 and y.bit-and(1) == 1 {color.blue.lighten(60%)}
    else {white}
)
#{
  set text(fill: black)
  // show link: underline
  table(
  columns: (auto, auto, 1fr, 1fr),
  inset: 0.5em,
  // stroke: 0em,
  table.header([], [区域名称], [简述], [解锁方式]),
  table.cell(rowspan: 7, align: horizon, [主\ 要]),
  links.village, [又回到最初的起点\ 呆呆地站在镜子前], [初始解锁],
  [森林], [没有另一个光头强], [完成 “一起离开” \ 或 “独自离开”(不和她玩)],
  [学院都市], [我爱学习，天天向上], [完成 “穿过森林”],
  [沿海城镇], [海里除了鱼，还有什么呢], [完成 “前往公会 1” 流程 \ 或 与纳维尔对话(ed 7)],
  [精灵之泉], [没有蓝色的精灵], [完成 “前往公会 2” 流程],
  [古代遗迹], [有很多有用的东西], [完成 “前往公会 3” 流程],
  [魔帝国], [♥魔♥王♥大♥人♥], [毕业后起飞前往],
  table.cell(rowspan: 3, align: horizon, [特\ 殊]),
  [铁匠之村], [回收 旧脸盆 旧铁剑 废铁], [盗贼山洞内获得铁匠地图],
  [湖畔废墟], [闪闪发光的宝石], [ed 5 流程触发],
  [希登岛], [花钱的地方], [击败海怪克拉肯解锁],
  table.cell(rowspan: 7, align: horizon, [支\ 线]),
  [沙漠小镇], [🎶我要穿越这片沙漠🎶\ 🎶找寻真的自我🎶], [完成 “前往公会 4” 流程],
  [峡谷村落], [迷信害人呐], [完成 “前往公会 5” 流程],
  [圣都], [雕像，好多雕像], [完成 “前往公会 6” 流程],
  [罪恶都市], [哥谭市(然而并不是)], [完成 “前往公会 7” 流程],
  [龙之村], [多拉贡！嘎嗷！], [完成 “前往公会 8” 流程],
  [魔法都市], [-], [完成 “前往公会 9” 流程],
  [美食城], [-], [完成 “前往公会 10” 流程],
  table.cell(rowspan: 2, align: horizon, [其\ 它]), 
  [精神世界], [深呼吸\~ 冥想\~], [阅读母亲的魔导书],
  [灵魂档案], [抛瓦！], [完成一次转生],
)}


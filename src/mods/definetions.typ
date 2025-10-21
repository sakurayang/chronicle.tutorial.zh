// 好吃
#let _color = (
  // 淡豆沙
  red: rgb("#873d24"),
  // 醉瓜黄
  yellow: rgb("#db8540"),
  // 羽扇豆蓝
  blue: rgb("#619ac3"),
  // 葱绿
  green: rgb("#40a070"),
  // 鱼尾灰
  gray: rgb("5e616d"),
);

/// ref: #link("https://realm-grinder.fandom.com/wiki/Notation")[wiki]
/// 
/// raw: int or string for convert.
/// 
/// int for Scientific Notation to Short Scale Suffixes,
/// string for Short Scale Suffixes to Scientific Notation
///
/// Examples:
/// ```typ
/// #sn_convert("qa") // => 15
/// #sn_convert("15") // => Qa
/// #sn_convert("14") // => Qa
/// #sn_convert("13") // => Qa
/// #sn_convert("12") // => T
/// ```
#let sn_convert(raw) = {
  let nummap = (("k", "M", "B", "T", "Qa", "Qi", "Sx", "Sp", "Oc", "No") + for i in (
  "d", "vg", "tg", "qag", "qig", "sxg", "spg", "ocg", "nog", "c") {
    for j in ("", "u", "d", "t", "qa", "qi", "sx", "sp", "oc", "no") {
      let combine = if j + i == "d" { "Dc" } else { j + i }
      let first_cap = upper(combine.first());
      (combine.replace(combine.first(),first_cap, count: 1),)
    }
} + ("Dcc",));
  if type(raw) == int {
    return nummap.at(calc.quo(raw, 3) - 1);
  } else if type(raw) == str {
    let pos = nummap.position(item => upper(item) == upper(raw));
    if type(pos) == int {
      return (pos + 1) * 3
    } else {
      return "type error"
    }
  } else {
    return "please input int or suffix"
  }
}

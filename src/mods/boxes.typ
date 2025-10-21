#import "definetions.typ": *
#import "../templates/page.typ": sans-family, serif-family
#import "@preview/gentle-clues:1.2.0": idea, info as _info, warning, memo, success as _success

#let _icon-text = codepoint => text(size:1em, font:"Symbols Nerd Font Mono", codepoint)
#let _icon = (
  // nf-md-lightbulb
  tips: _icon-text[\u{f04cf}],
  // nf-fa-circle_info
  info: _icon-text[\u{f05a}],
  // nf-fa-warning
  warn: _icon-text[\u{f071}],
  // nf-fa-remove_sign
  error: _icon-text[\u{f057}],
  // nf-fa-check_circle
  success: _icon-text[\u{f058}],
)

#let _type_n_color_map = (
  tips: _color.blue,
  info: _color.gray,
  warn: _color.yellow,
  error: _color.red,
  success: _color.green,
)

#let _args = (
  title-font: serif-family,
  title-weight-delta: 600,
  stroke-width: 0.5em,
  body-color: white,
)

#let tips(content, title: "小贴士") = idea(.._args, text(font: sans-family, content, fill: black),  accent-color: _type_n_color_map.at("tips"), title: text(fill:black, title))
#let warn(content, title: "注意") = warning(.._args, text(font: sans-family, content, fill: black), accent-color: _type_n_color_map.at("warn"), title: text(fill:black, title))
#let error(content, title: "别！！！") = memo(.._args, text(font: sans-family, content, fill: black), accent-color: _type_n_color_map.at("error"), title: text(fill:black, title))
#let success(content, title: "好耶") = _success(.._args, text(font: sans-family, content, fill: black), accent-color: _type_n_color_map.at("success"), title: text(fill:black, title))
#let info(content, title: "提示") = _info(.._args, text(font: sans-family, content, fill: black), accent-color: _type_n_color_map.at("info"), title: text(fill:black, title))


// test below
// #import "@preview/zh-kit:0.1.0":zhlorem
// #tips(zhlorem(100))
// #warn(zhlorem(100))
// #error(zhlorem(100))
// #success(zhlorem(100))
// #info(zhlorem(100),title:zhlorem(10))

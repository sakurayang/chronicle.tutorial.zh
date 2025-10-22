#import "/src/book.typ": book-page
#import "../../mods.typ":tips, info, warn, error, success
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import fletcher.shapes: diamond, rect, pill, brace


// #import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#show: book-page.with(title: "")

= 村庄

== 区域流程

#diagram(
  debug: 3,
  spacing: 2em,
  {
    let a = (1, 2, 3, 4, 5, 6);
    for i in range(a.len()) {
        node((0, i), [#(i+1)], name: str(i))
        if i < a.len() - 1 { edge((0, i), "d", "->") }
    }
  },
  node(enclose: ("1","2","3"), shape: brace.with(sep: 0.5em,dir: right, label: [222]))
)

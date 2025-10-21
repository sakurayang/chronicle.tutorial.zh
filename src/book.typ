
#import "@preview/shiroa:0.2.3": *

#show: book

#book-meta(
  title: "shiroa",
  summary: [
    #prefix-chapter("sample-page.typ")[Hello, typst]
  ]
)

#build-meta(
  dest-dir: "../dist",
)

// re-export page template
#import "/src/templates/page.typ": project
#let book-page = project

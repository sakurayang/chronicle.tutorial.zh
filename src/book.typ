#import "@preview/shiroa:0.2.3": *

#show: book;

#book-meta(
  title: "Chronicle 教程",
  authors: ("G","a"),
  summary: [
    #prefix-chapter("introduction.typ")[简介]

    #prefix-chapter("chapters/regions/0_regions.typ")[——区域介绍——]
    - #chapter("chapters/regions/1_village.typ")[村庄]
  ],
  language: "zh"
)

#build-meta(
  dest-dir: "../dist",
)

// re-export page template
#import "/src/templates/page.typ": project
#let book-page = project

// This is important for shiroa to produce a responsive layout
// and multiple targets.
#import "@preview/shiroa:0.2.3": (
  get-page-width, is-html-target, is-pdf-target, is-web-target, plain-text, shiroa-sys-target, templates,
)
#import templates: *
#import "@preview/zh-kit:0.1.0": zhnumber-lower

#let serif-family = ("煮豆黑體","寒蟬錦書宋",)
#let sans-family = ("煮豆黑體","Sarasa Gothic SC")
#let mono-family = ("Maple Mono",)

/// The site theme to use. If we renders to static HTML, it is suggested to use `starlight`.
/// otherwise, since `starlight` with dynamic SVG HTML is not supported, `mdbook` is used.
/// The `is-html-target(exclude-wrapper: true)` is currently a bit internal so you shouldn't use it other place.
#let web-theme = if is-html-target(exclude-wrapper: true) { "starlight" } else { "mdbook" }
#let is-starlight-theme = web-theme == "starlight"

// Metadata
#let page-width = get-page-width()
#let is-html-target = is-html-target()
#let is-pdf-target = is-pdf-target()
#let is-web-target = is-web-target()
#let sys-is-html-target = ("target" in dictionary(std))

// Theme (Colors)
#let themes = theme-box-styles-from(toml("theme-style.toml"), read: it => read(it))
#let (
  default-theme: (
    style: theme-style,
    is-dark: is-dark-theme,
    is-light: is-light-theme,
    main-color: main-color,
    dash-color: dash-color,
    code-extra-colors: code-extra-colors,
  ),
) = themes;
#let (
  default-theme: default-theme,
) = themes;
#let theme-box = theme-box.with(themes: themes)

// Fonts
#let main-font = sans-family /* + (
  "Charter",
  "Source Han Serif SC",
  // "Source Han Serif TC",
  // shiroa's embedded font
  "Libertinus Serif",
)*/
#let code-font = mono-family /*+ (
  "Maple Mono NF",
  "BlexMono Nerd Font Mono",
  // shiroa's embedded font
  "DejaVu Sans Mono",
)*/

// Sizes
#let main-size = if is-web-target {
  20pt
} else {
  14.5pt
}
#let heading-sizes = if is-web-target {
  (2, 1.5, 1.17, 1, 0.83).map(it => it * main-size)
} else {
  (28pt, 22pt, 14pt, 12pt, main-size)
}
#let list-indent = 0.5em

// Put your custom CSS here.
#let extra-css = ```css
.site-title {
  font-size: 1.2rem;
  font-weight: 600;
  font-style: italic;
}
.active {
  font-size: large;
}
```

/// The project show rule that is used by all pages.
///
/// Example:
/// ```typ
/// #show: project
/// ```
///
/// - title (str): The title of the page.
/// - description (auto): The description of the page.
///   - If description is `auto`, it will be generated from the plain body.
///   - If description is `none`, an error is raised to force migration. In future, `none` will mean the description is not generated.
///   - Hint: use `""` to generate an empty description.
/// - authors (array | str): The author(s) of the page.
/// - kind (str): The kind of the page.
/// - plain-body (content): The plain body of the page.
#let project(title: "Typst Book", description: auto, authors: (), kind: "page", plain-body) = {
  // set basic document metadata
  set document(
    author: authors,
    title: title,
  ) if not is-pdf-target

  // set web/pdf page properties
  set page(
    numbering: none,
    number-align: center,
    width: page-width,
  ) if not (sys-is-html-target or is-html-target)

  // remove margins for web target
  set page(
    margin: (
      // reserved beautiful top margin
      top: 20pt,
      // reserved for our heading style.
      // If you apply a different heading style, you may remove it.
      left: 20pt,
      // Typst is setting the page's bottom to the baseline of the last line of text. So bad :(.
      bottom: 0.5em,
      // remove rest margins.
      rest: 0pt,
    ),
    height: auto,
  ) if is-web-target and not is-html-target

  let common = (
    web-theme: web-theme,
  )

  show: template-rules.with(
    book-meta: include "/src/book.typ",
    title: title,
    description: description,
    plain-body: plain-body,
    extra-assets: (extra-css,),
    ..common,
  )

  // Set main text
  set text(
    font: main-font,
    size: main-size,
    fill: main-color,
    lang: "zh",
    features: (
      // https://font.subf.dev/zh-cn/playground/
      cv06: 1,
      ss09: 1,
      // https://github.com/Buernia/Zhudou-Sans
      ccmp: 1,
      dlig: 1,
      kern: 1,
      vkrn: 1,
      zero: 1,
      ss01: 0,
      ss02: 0,
      vs01: 1,
      pwid: 1,
      vert: 0
    ),
  )


// copy from shiroa's templayes.typ in line 21 to 105
// self def for remove "#" before heading
  let x-markup-rules(
    body,
    web-theme: "starlight",
    themes: none,
    main-size: main-size,
    heading-sizes: heading-sizes,
    list-indent: list-indent,
    starlight: "@preview/shiroa-starlight:0.2.3",
  ) = {
    assert(themes != none, message: "themes must be set")
    let (
      default-theme: (
        dash-color: dash-color,
      ),
    ) = themes


    let is-starlight-theme = web-theme == "starlight"
    let in-heading = state("shiroa:in-heading", false)

    let mdbook-heading-rule(it) = {
      let it = {
        set text(size: heading-sizes.at(it.level))

        in-heading.update(true)
        it
        in-heading.update(false)
      }

      block(
        spacing: 0.7em * 1.5 * 1.2,
        below: 0.7em * 1.2,
        it,
      )
    }

    let starlight-heading-rule(it) = context if shiroa-sys-target() == "html" {
      import starlight: builtin-icon

      in-heading.update(true)
      html.elem("div", attrs: (class: "sl-heading-wrapper level-h" + str(it.level + 1)))[
        #it
        #html.elem(
          "h" + str(it.level + 1),
          attrs: (class: "sl-heading-anchor not-content", role: "presentation"),
          static-heading-link(it, body: builtin-icon("anchor"), canonical: true),
        )
      ]
      in-heading.update(false)
    } else {
      mdbook-heading-rule(it)
    }


    // Set main spacing
    set enum(
      indent: list-indent * 0.618,
      body-indent: list-indent,
    )
    set list(
      indent: list-indent * 0.618,
      body-indent: list-indent,
    )
    set par(leading: 0.7em)
    set block(spacing: 0.7em * 1.5)

    // Set text, spacing for headings
    // Render a dash to hint headings instead of bolding it as well if it's for web.
    show heading: set text(weight: "regular") if is-web-target
    // todo: add me back in mdbook theme!!!
    show heading: if is-starlight-theme {
      starlight-heading-rule
    } else {
      mdbook-heading-rule
    }

    // link setting
    show link: set text(fill: dash-color)

    body
  }

  // markup setting
  show: x-markup-rules.with(
    ..common,
    themes: themes,
    heading-sizes: heading-sizes,
    list-indent: list-indent,
    main-size: main-size,
  )
  // math setting
  show: equation-rules.with(..common, theme-box: theme-box)
  // code block setting
  show: code-block-rules.with(
    ..common, 
    themes: themes,
    code-font: code-font,
  )
  // Main body.
  set par(justify: true)
  
  //set heading(numbering: zhnumber-lower(1) + "·1·1", supplement: [节点])

  let set-color(it, color) = [
    #set text(fill: color)
    #it
  ]

  // num.pos.len() > 1 is equal to .where(depth: >1)
  set heading(numbering: (..num)=> if num.pos().len()>1 {sym.section} else {""})
  // show heading: text(size: main-size.)

  show heading: it => [
    #set text(font: serif-family, weight: "black")
    #it
  ]
  
  show heading.where(depth: 1): it => set-color(it, rgb("#2376b7"))
  show heading.where(depth: 2): it => set-color(it, rgb("#54a2e7"))
  show heading.where(depth: 3): it => set-color(it, rgb("#72c1ff"))
  
  show heading.where(depth: 1): it =>[
    #set align(center)
    #it
  ]

  show link: it => set-color(it, rgb("#126e82"))

  plain-body
}

#let part-style = heading

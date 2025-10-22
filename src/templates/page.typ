// This is important for shiroa to produce a responsive layout
// and multiple targets.
#import "@preview/shiroa:0.2.3": (
  get-page-width,
  target,
  is-web-target,
  is-pdf-target,
  is-html-target,
  plain-text,
  shiroa-sys-target,
  templates,
)
#import templates: *

#let serif-family = ("煮豆黑體","寒蟬錦書宋",)
#let sans-family = ("煮豆黑體","Sarasa Gothic SC")
#let mono-family = ("Maple Mono",)

#let use-theme = "starlight"
#let is-starlight-theme = use-theme == "starlight"
// Metadata
#let page-width = get-page-width()
#let is-html-target = is-html-target()
#let is-pdf-target = is-pdf-target()
#let is-web-target = is-web-target()
#let sys-is-html-target = ("target" in dictionary(std))


/// Creates an embedded block typst frame.
#let div-frame(content, attrs: (:), tag: "div") = html.elem(tag, html.frame(content), attrs: attrs)
#let span-frame = div-frame.with(tag: "span")
#let p-frame = div-frame.with(tag: "p")

// Theme (Colors)
#let themes = theme-box-styles-from(toml("theme-style.toml"), xml: it => xml(it))
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
#let in-heading = state("shiroa:in-heading", false)

#let mdbook-heading-rule(it) = {
  let it = {
    set text(size: heading-sizes.at(it.level))
    if is-web-target {
      heading-hash(it, hash-color: dash-color)
    }

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

#let starlight-heading-rule(it) = context if shiroa-sys-target() == "html" {
  // // Render a dash to hint headings instead of bolding it as well.
  // show link: static-heading-link(it)
  // // Render the heading hash
  // heading-hash(it, hash-color: dash-color)

  import "@preview/shiroa-starlight:0.2.3": builtin-icon

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

#let equation-rules(body) = {
  let get-main-color(theme) = {
    if is-starlight-theme and theme.is-dark and in-heading.get() {
      white
    } else {
      theme.main-color
    }
  }

  show math.equation: set text(weight: 400)
  show math.equation.where(block: true): it => context if shiroa-sys-target() == "html" {
    theme-box(
      tag: "div",
      theme => {
        set text(fill: get-main-color(theme))
        p-frame(attrs: ("class": "block-equation", "role": "math"), it)
      },
    )
  } else {
    it
  }
  show math.equation.where(block: false): it => context if shiroa-sys-target() == "html" {
    theme-box(
      tag: "span",
      theme => {
        set text(fill: get-main-color(theme))
        span-frame(attrs: (class: "inline-equation", "role": "math"), it)
      },
    )
  } else {
    it
  }
  body
}

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

  show: if is-html-target {
    import "@preview/shiroa-starlight:0.2.3": starlight

    let description = if description != none { description } else {
      let desc = plain-text(body, limit: 512).trim()
      if desc.len() > 512 {
        desc = desc.slice(0, 512) + "..."
      }
      desc
    }

    starlight.with(
      include "/github-pages/docs/book.typ",
      title: title,
      site-title: [Shiroa],
      description: description,
      github-link: "https://github.com/Myriad-Dreamin/shiroa",
    )
  } else {
    it => it
  }

  // let common = (
  //   web-theme: web-theme,
  // )

  // show: template-rules.with(
  //   book-meta: include "/src/book.typ",
  //   title: title,
  //   description: description,
  //   plain-body: plain-body,
  //   extra-assets: (extra-css,),
  //   ..common,
  // )

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
    
    themes: themes,
    heading-sizes: heading-sizes,
    list-indent: list-indent,
    main-size: main-size,
  )
  // math setting
  show: equation-rules
  // code block setting
  show: code-block-rules.with(
     
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
  
  context if shiroa-sys-target() == "html" {
    html.elem(
      "style",
      ```css
      .inline-equation {
        display: inline-block;
        width: fit-content;
      }
      .block-equation {
        display: grid;
        place-items: center;
        overflow-x: auto;
      }
      .site-title {
        font-size: 1.2rem;
        font-weight: 600;
        font-style: italic;
      }
      ```.text,
    )
  }
}

#let part-style = heading

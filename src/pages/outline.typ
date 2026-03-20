// Outline Components

// Table of Contents
#let toc = {
  set outline.entry(fill: grid(
    columns: 2,
    gutter: 0pt,
    repeat[~.], h(11pt),
  ))

  show outline.entry.where(level: 1): set outline.entry(fill: none)
  show outline.entry.where(level: 1): set text(weight: "bold")
  show outline.entry.where(level: 1): set block(above: 16pt)

  outline(
    indent: auto,
    depth: 3,
  )

  pagebreak(weak: true)
}

#let in_outline = state("in-outline", false)

#let custom_caption(long, short) = context {
  if in_outline.get() { short } else { long }
}

// List of x
#let list_of(title, target) = {
  context {
    if query(figure.where(kind: target)).len() > 0 {
      heading(title, numbering: none)

      set outline.entry(fill: grid(
        columns: 2,
        gutter: 0pt,
        repeat[~.], h(11pt),
      ))

      show outline.entry: it => link(
        it.element.location(),
        it.indented(strong(it.prefix() + h(4pt)), it.inner()),
      )

      in_outline.update(true)
      outline(
        title: none,
        target: figure.where(kind: target),
      )
      in_outline.update(false)

      pagebreak(weak: true)
    }
  }
}

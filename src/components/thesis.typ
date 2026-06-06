#import "../dependencies.typ": zebraw, zebraw-themes, make-glossary, print-glossary, register-glossary, hydra, alexandria, bibliographyx
#import "../pages/cover.typ": cover
#import "../pages/abstract.typ": abstract
#import "../pages/acknowledgements.typ": acknowledgements
#import "../pages/outline.typ": toc, list_of
#import "../pages/eigen.typ": declaration_of_honesty
#import "../abbreviations.typ": abbreviation_list

#let thesis(
  font_size: 11pt,
  margin_y: 3cm,
  margin_x: 2cm,
  par_spacing: 1.6em,
  list_spacing: 1em,
  list_indent: 1em,
  headings: (
    acknowledgements: "Acknowledgements",
    figures: "List of Figures",
    tables: "List of Tables",
    listings: "List of Listings",
    abbreviations: "Abbreviations",
    references: "References",
    appendix: "Appendix",
  ),
  title,
  title_de,
  keywords,
  course,
  university,
  company,
  author,
  centuria,
  matnr,
  supervisors,
  location,
  date,
  acknowledgements_content: none,
  appendix_content: none,
  bibliography_path: "../res/literature.bib",
  citation_style: "ieee",
  body,
) = {
  show: make-glossary // Make glossary work
  show: alexandria(prefix: "x:", read: path => read(path)) // setup second bibliography

  set document(title: title)

  set page(
    margin: (y: margin_y, x: margin_x),
    header-ascent: 24pt,
    header: context {
      set text(size: 11.5pt)
      if (hydra(1) != none) {
        grid(
          rows: 2,
          gutter: 5pt,
          if calc.odd(here().page()) {
            align(right, emph(hydra(1)))
          } else {
            let candidate = hydra(2, skip-starting: false)
            if candidate == none {
              candidate = hydra(1)
            }
            align(left, emph(candidate))
          },
          line(length: 100%)
        )
      }
    },
    numbering: "I",
    footer: context {
      let number = counter(page).display()
      if calc.odd(here().page()) {
        align(right, number)
      } else {
        align(left, number)
      }
    },
  )

  // Hide header and footer for blank pages
  show selector.or(
    pagebreak.where(to: "odd"),
    pagebreak.where(to: "even"),
  ): set page(header: none, footer: none)

  set text(
    size: font_size,
    font: "New Computer Modern",
  )
  set par(spacing: par_spacing, leading: 9pt)
  set list(spacing: list_spacing, indent: list_indent, marker: ([•], [--]))
  set enum(spacing: list_spacing, indent: list_indent)

  show heading.where(level: 1): set block(above: 30pt, below: 25pt)
  show heading.where(level: 1): set text(size: 21pt, weight: 600)

  show heading.where(level: 2): set block(above: 30pt, below: 25pt)
  show heading.where(level: 2): set text(size: 14pt)

  show heading.where(level: 3): set block(above: 20pt, below: 15pt)
  show heading.where(level: 3): set text(size: 11pt)

  show figure.caption: it => {
    text(
      size: 10pt,
      [
        #strong(delta: 200, [#it.supplement #it.counter.display(it.numbering)#it.separator])
        #it.body
      ]
    )
  }

  // Front cover
  cover(
    course,
    university,
    company,
    author,
    centuria,
    matnr,
    supervisors,
    date
  )

  show heading.where(level: 1): it => {
    pagebreak(weak: true)
    it
  }

  // Abstract
  abstract(
    title,
    title_de,
    keywords,
  )

  // Acknowledgements
  if (acknowledgements_content != none) {
    acknowledgements(headings.acknowledgements, acknowledgements_content)
  }

  // Table of Contents
  toc

  // List of Figures
  list_of(headings.figures, image)

  // List of Tables
  list_of(headings.tables, table)

  // List of Listings
  list_of(headings.listings, raw)

  // Abbreviations
  register-glossary(abbreviation_list)
  heading(headings.abbreviations)
  print-glossary(
    abbreviation_list,
    disable-back-references: true,
  )
  pagebreak(weak: true)
  [#[] <end-of-roman-numbering>]

  // Main content
  set page(numbering: "1")
  counter(page).update(1)
  set heading(numbering: "1.1")
  set par(justify: true)
  //show figure: none
  body

  // References
  set page(numbering: "I")
  set par(justify: false)
  context {
    let old_page_number = counter(page).at(<end-of-roman-numbering>).first()
    counter(page).update(old_page_number)
  }
  set heading(numbering: none)
  {
    set par(spacing: 1.2em)
    set text(size: 11pt)
    bibliography(
      bibliography_path,
      title: headings.references,
      style: citation_style,
    )
    bibliographyx(
      "../res/online.bib",
      title: "Online References",
    )
  }

  // Appendix
  if (appendix_content != none) {
    set heading(numbering: "A.1 ")
    counter(heading).update(0)
    heading(headings.appendix)

    set text(size: 9pt)
    set par(leading: 6pt)
    set list(spacing: 8pt)
    set enum(spacing: 8pt)
    appendix_content
  }

  //set heading(numbering: none)
  //declaration_of_honesty(author, location, date)
  //pagebreak(to: "odd")
}
#import "../dependencies.typ": zebraw, zebraw-themes
//show figure: set block(breakable: true)

#let code_snippet(source, lang) = {
  set text(size: 10pt)
  let file_name = source.split("/").last()
  zebraw(
    raw(read(source), block: true, lang: lang),
    highlight-lines: (
      (header: strong(file_name)),
    ),
    ..zebraw-themes.zebra
  )
}
#import "../dependencies.typ": orchid

#let cover(
  course,
  university,
  company,
  author,
  centuria,
  matnr,
  supervisors,
  date,
) = {
  set page(footer: none, margin: (x: 3cm, y: 4cm))
  place(
    top + center,
    {
      show title: set text(size: 31pt, weight: 500)
      
      stack(
        spacing: 3cm,
        title(),
        stack(
          spacing: 10pt,
          [#text(size: 18pt)[#emph([#author ])] #orchid.generate-link("0009-0009-0589-3112")],
          h(1cm),
          [leon.heuer.a22b\@nordakademie.org],
          [#university],
          [Elmshorn, Germany],
        )
      )
    }
  )

  place(
    bottom + center,
    {
      set par(spacing: .6cm)
      set strong(delta: 200)
      stack(
        spacing: 10pt,
        [Submitted on #date.display("[month repr:long] [day], [year]")],
      )
      line(stroke: .5pt + black, length: 2cm)
      stack(
        spacing: 10pt,
        [Bachelor's Thesis],
        [at #university],
        [in cooperation with #company],
      )
      line(stroke: .5pt + black, length: 2cm)
      stack(
        spacing: 10pt,
        [Supervising Examiner: #strong(supervisors.at(0))],
        [Secondary Examiner: #strong(supervisors.at(1))],
        [Advisor: #strong(supervisors.at(2))],
      )
    }
  )
  pagebreak(weak: true)
}

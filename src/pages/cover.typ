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
      set text(size: 18pt)
      
      stack(
        spacing: 3cm,
        grid(
          columns: (1fr, 1fr),
          grid.cell(align: left, image("../res/cover/nordakademie_logo.png", height: .9cm)),
          grid.cell(align: right, image("../res/cover/otto_logo.png", height: .9cm)),
        ),
        title(),
        emph([By #author]),
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
        [Bachelor's Thesis submitted for examination in Bachelor's degree],
        v(18pt),
        [in the study course #emph(course)],
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
      line(stroke: .5pt + black, length: 2cm)
      stack(
        spacing: 10pt,
        [Submitted on #date.display("[month repr:long] [day], [year]")],
        [by #author, centuria #centuria, matriculation number #matnr],
      )
    }
  )
  pagebreak(weak: true, to: "odd")
}

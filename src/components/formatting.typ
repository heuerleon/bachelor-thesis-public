//#let needsCite = strong(text(red, "needsCite"))
//#let todo(content) = block(strong(text(blue, "TODO: " + content)))
//#let draft = strong(text(green, "DRAFT:"))

#let dotted_line = line(length: 100%, stroke: (paint: black, thickness: .5pt, dash: "dashed"))

#let email(
  last: false,
  date,
  subject,
  from,
  to,
  content
) = {
  par([
    *Date*: #date.display("[year]/[month]/[day], [hour]:[minute]") CET\
    *From*: #from\
    *To*: #to\
    *Subject*: #subject
  ])

  content

  if not last {
    dotted_line
  }
}
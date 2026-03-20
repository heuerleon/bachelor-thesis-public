#let image_rotated(source) = context {
  if calc.odd(here().page()) {
    rotate(-90deg, reflow: true, image(source))
  } else {
    rotate(90deg, reflow: true, image(source))
  }
}

#let declaration_of_honesty(
  name,
  location,
  date
) = {
  {
    show heading: none
    heading("Documentation of AI usage", level: 1, numbering: none, outlined: false)
  }
  image_rotated("../res/kidoku/kidoku1.png")
  image_rotated("../res/kidoku/kidoku2.png")
  image_rotated("../res/kidoku/kidoku3.png")
  image_rotated("../res/kidoku/kidoku4.png")
  heading("Eigenständigkeitserklärung", outlined: false)
  [
    Mit meiner Unterschrift versichere ich, dass ich die hier vorliegende Arbeit selbständig, ohne fremde Hilfe und nur mit den angegebenen Hilfsmitteln verfasst habe und meine Angaben zu den verwendeten Quellen der Wahrheit entsprechen und vollständig sind. Alle Quellen, aus denen ich wörtlich oder sinngemäß übernommen habe, habe ich als solche gekennzeichnet.
    
    Darüber hinaus versichere ich, dass ich sämtliche Teile der vorliegenden Arbeit, die unter Zuhilfenahme künstlicher Intelligenz (KI) generiert wurden, als solche gekennzeichnet habe und deren Entstehung in einer beigefügten Prozessdokumentation nachgewiesen habe. Ich habe zur Kenntnis genommen, dass zuwiderlaufendes Verhalten als Täuschungsversuch gewertet wird und zu den in der geltenden Prüfungsverfahrensordnung genannten Konsequenzen führen wird.
  ]
  v(3em)
  stack(
    spacing: 8pt,
    line(length: 33%, stroke: .5pt + black),
    name,
    [#location, den #date.display("[day].[month].[year]")]
  )
}

/*
heading("Declaration of academic honesty for the preparation of Bachelor's Thesis at NORDAKADEMIE", outlined: false)

I hereby declare that I have written this presented thesis independently and have not used any other means than those indicated. All literally or corresponding passages abstracted from other writings I have made full indication with the sources. This also applies to all attachments as well as attached drawings, sketches, pictorial representations, etc.

I am aware that in the event of an unintentional, negligent or intentional disregard of the correct handling of sources, I can be liable to prosecution and the present thesis is assessed as "failed".
*/
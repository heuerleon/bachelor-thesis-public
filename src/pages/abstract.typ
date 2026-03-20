#let bold_upper(content) = text(weight: 700, upper(content))

#let abstract_text = [
  Software design patterns' effects on code quality have mostly been studied in the context of object-oriented languages. In the programming language Rust, which comes with novel language concepts, compile-time safety guarantees and a distinct type system, there has been little research on design patterns. This work investigates how patterns affect software quality and compile-time enforcement of invariants through a case study on three representative components of production backend applications. An evaluation framework based on criteria derived from the SQuaRE quality model, incorporating benchmarking, static code analysis and expert interviews, is developed to assess the refactored code. The patterns typestate and newtype are applied to address existing code smells in the selected use cases. While the typestate pattern improves faultlessness and testability significantly, it comes at the cost of more structural code that can degrade readability. Code with extensive branching logic and a high number of invariants is likely to benefit most from the pattern. The newtype pattern combined with the "Parse, don't validate" principle offers high returns in software quality at a low cost and prevents invalid states during runtime. Overall, this work provides an initial empirical assessment of design patterns in Rust and establishes a foundation for further studies involving additional use cases and patterns.
]

#let abstract_text_de = [
  Die Auswirkungen von Software Design Patterns auf die Codequalität wurden bislang überwiegend im Kontext objektorientierter Programmiersprachen untersucht. Für die Programmiersprache Rust, die neuartige Sprachkonzepte, Sicherheitsgarantien zur Compilezeit und ein eigenständiges Typsystem mitbringt, existiert bisher nur wenig Forschung zu Design Patterns. Diese Arbeit untersucht anhand einer Fallstudie mit drei repräsentativen Komponenten aus laufenden Backend-Anwendungen, wie sich Design Patterns auf die Softwarequalität und die Sicherstellung von Invarianten zur Compilezeit auswirken. Zur Bewertung des modifizierten Codes wird eine Methodik entwickelt, die auf abgeleiteten Kriterien aus dem SQuaRE-Qualitätsmodell basiert und Benchmarking, statische Codeanalyse sowie Experteninterviews kombiniert. Zur Behebung bestehender Probleme im Code der ausgewählten Use Cases werden die Patterns Typestate und Newtype eingesetzt. Während das Typestate-Pattern die Fehlerfreiheit und Testbarkeit deutlich verbessert, geht dies mit einem erhöhten Volumen von strukturellem Code einher, der die Lesbarkeit beeinträchtigen kann. Insbesondere Code mit umfangreicher Verzweigungslogik und einer hohen Anzahl an Invarianten profitiert am meisten von diesem Pattern. Das Newtype-Pattern in Kombination mit dem Prinzip „Parse, don't validate“ erzielt hingegen bei geringem Aufwand deutliche Verbesserungen der Softwarequalität und verhindert invalide Zustände zur Laufzeit. Insgesamt liefert diese Arbeit eine erste empirische Bewertung von Design Patterns in Rust und schafft eine Grundlage für weiterführende Untersuchungen mit zusätzlichen Anwendungsfällen und Patterns.
]

#let abstract(
  title,
  title_de,
  keywords,
) = {
  stack(
    spacing: 35pt,
    {
      bold_upper([Title of Thesis])
      par(title)
    },
    {
      bold_upper([Abstract])
      par(abstract_text)
    },
    {
      bold_upper([Keywords])
      par(keywords)
    },
  )

  pagebreak(to: "odd")

  stack(
    spacing: 35pt,
    {
      bold_upper([Titel der Arbeit])
      par(title_de)
    },
    {
      bold_upper([Kurzzusammenfassung])
      par(abstract_text_de)
    },
  )
}

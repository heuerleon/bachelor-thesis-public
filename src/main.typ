// Imports
#import "components/thesis.typ": thesis

#show: thesis.with(
	"Benefits of Applying Software Design Patterns to Backend Rust Applications",
	"Vorteile des Anwendens von Software Design Patterns in Backend Rust Anwendungen",
	"Rust, Design Patterns, Refactoring, Code Quality, Typestate Pattern, Newtype Pattern, Static Code Analysis, Type System",
	"Bachelor of Science Angewandte Informatik",
	"NORDAKADEMIE Hochschule der Wirtschaft",
	"Otto GmbH & Co. KGaA",
	"Leon Heuer",
	"A22b",
	"12489",
	("Prof. Dr. habil. Jan Haase", "Prof. Dr. rer. nat. Joachim Sauer", "B.Sc. Falk Woldmann Lu"),
	"Lübeck",
	datetime.today(),
	citation_style: "../res/din-1505-2-alphanumeric.csl",
	//acknowledgements_content: include "chapters/00_acknowledgements.typ",
	appendix_content: include "chapters/99_appendix.typ",
)

// Main content
#include "chapters/01_introduction.typ"
#include "chapters/02_related.typ"
#include "chapters/03_method.typ"
#include "chapters/04_case_study.typ"
#include "chapters/05_implementation.typ"
#include "chapters/06_results.typ"
#include "chapters/07_conclusion.typ"

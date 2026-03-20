The expert interview guide was originally sent to the interviewees in German. This is a translated version.

#line(length: 100%, stroke: .5pt + black)

The following questions will be asked to the expert during the interview. The expert is asked to think about the questions in advance and, if necessary, prepare notes to ensure a smooth interview process.

*Please review the code only after answering these questions.*

*1 - Introduction*

+ How long have you been working with Rust, and in which domain or on which types of products?
+ In your opinion, what distinguishes Rust from other established languages at OTTO, such as Java or Kotlin, with respect to maintainability and fault prevention?
+ From your perspective, what are the main causes of technical debt in large Rust codebases?

*2 - Current Problems in the Code*

+ What are the biggest pain points in the current codebase? What bothers you when maintaining the code or implementing new changes?  
  _(e.g., redundancies, complexity, insufficient use of the type system or language features, poor readability, missing documentation)_
+ How easy or difficult do you think it is for new developers to understand how the domain is modeled in the code, and why?
+ When you think about poorly maintainable code, do concrete code examples come to mind?
+ The following criteria will later be used in the expert interview to evaluate the refactored code:
	+ Modularity
	+ Reusability
	+ Analysability
	+ Modifiability
	+ Testability
	+ Faultlessness  
	Which methods do you know to quantify these properties, and how do you assess their practical relevance in everyday development as well as their explanatory power?

Now the focus shifts to the concrete use cases that were selected and refactored:

+ *FT9 Detailview Service*
	- GitHub repository: `otto-ec/ft9_benefit`
	- File: `services/tag/src/domain/detailview/detailview_service.rs`, entire file except tests
	- Applied pattern: *Typestate*
	- New version on branch `bachelor-project-leon-heuer`

+ *FT9 Tag Component Handler*
	- GitHub repository: `otto-ec/ft9_benefit`
	- File: `services/tag/src/api/tag_component_handler.rs`, lines 112-207
	- Applied pattern: *Newtype*
	- New version on branch `bachelor-project-leon-heuer`

+ *Boxfish Return Status REST API Handler*
	- GitHub repository: `otto-ec/boxfish_return_status`
	- File: `lambdas/rest_apis/src/update_return_status_to_announced/function_handler.rs`, entire file, as well as the related modules  
	  `incoming_request.rs`, `validation.rs`, `api_error_response_builder.rs`, lines 66-81
	- Applied pattern: *Typestate*
	- New version in the fork `leonheuer/boxfish_return_status`

*The following sections are evaluated separately for each use case.*

*3 - Status Quo*

Please review the current code of the use case. Which code smells do you notice? Are there parts that make the code hard to maintain or error-prone? Which of the criteria mentioned in Section 2 are negatively affected as a result?

*4 - Refactoring*

Now review the new, refactored code. Evaluate the following criteria, which were selected from the ISO 25010 SQuaRE model for software quality:

+ *Modularity*
	- *Definition:* “Capability of a product to limit changes to one component from affecting other components.”
	- To what extent has the modularity of the code worsened or improved due to the refactoring?

+ *Reusability*
	- *Definition:* “Capability of a product to be used as assets in more than one system, or in building other assets.”
	- To what extent has the reusability of the code worsened or improved due to the refactoring?

+ *Analysability*
	- *Definition:* “Capability of a product to be effectively and efficiently assessed regarding the impact of an intended change to one or more of its parts, to diagnose it for deficiencies or causes of failures, or to identify parts to be modified.”
	- This criterion can also be understood as readability. Has the code become easier or harder to read, analyze, and understand as a result of the refactoring?
	- How has the cognitive effort required to understand the examined code changed?

+ *Modifiability*
	- *Definition:* “Capability of a product to be effectively and efficiently modified without introducing defects or degrading existing product quality.”
	- Has it become easier or harder to modify the code without introducing new defects as a result of the refactoring?

+ *Testability*
	- *Definition:* “Capability of a product to enable an objective and feasible test to be designed and performed to determine whether a requirement is met.”
	- To what extent has the testability of the code worsened or improved due to the refactoring?
	- Are individual components now easier or harder to test, for example due to changes in the number of required mocks or reduced side effects?

+ *Faultlessness*
	- *Definition:* “Capability of a product to perform specified functions without fault under normal operation.”
	- This criterion was selected with regard to Rust's compile-time guarantees. For example, faultlessness is already improved by enforced memory safety through the borrow checker at compile time, thereby reducing runtime errors. Another way to make code more “correct” at compile time is to use Rust's type system to encode rules at compile time, for example through the applied Typestate and Newtype patterns.
	- Has the faultlessness of the code actually improved? Does the refactoring prevent invalid application states, and has the risk of bugs or incorrect function calls been reduced?

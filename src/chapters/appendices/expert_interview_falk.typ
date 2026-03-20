#import "../../components/formatting.typ": dotted_line

#stack(
  spacing: 6pt,
  [*Expert*: B.Sc. Falk Woldmann Lu],
  [*Date*: January 8, 2026, 1:30 pm],
  [*Location*: Online meeting],
  [*Background*: Senior Software Developer, Otto GmbH & Co. KGaA, 3 years Rust experience],
)

The following is a summary of the expert interview, which was created with the support of large language models. The summary has been confirmed to be correct in its content by the expert.

*1 - Introduction*

*Q1*: How long have you worked with Rust and in what area or on what products?

*A1*:
- I have been dealing with Rust since winter 2022, totaling about three years, and have worked with it professionally since mid-2023
- I build web applications for Otto that handle significant load and therefore have strict requirements for performance and efficiency
- Parallel to this I maintain a relatively well-known HTTP mocking library for Rust

*Q2*: What distinguishes Rust from languages like Java or Kotlin regarding maintainability and faultlessness?

*A2*:
- Rust has a much more powerful type system compared to Java which allows embedding more logic that the compiler can formally validate
- Expressing logic formally improves maintainability because the code requires less manual maintenance over time
- Faultlessness is a negative correlation to maintenance work where using the compiler is much more powerful than using runtime if-conditions or logical operations
- This is very effective for our use cases because processes like filtering, sorting, and aggregating can be expressed well as state machines

*Q3*: What are the primary reasons for technical debt in large Rust codebases?

*A3*:
- A major issue is the lack of uniform standards and the fact that different approaches were tried during an evolution phase without consistently cleaning them up
- Many people I work with are not yet completely in a Rust-based way of thinking and still have a mindset influenced by Java or Kotlin
- This leads to attempts to encapsulate the application flow in class-like structures even where it makes no sense or using traits for abstraction when enums would be a better idea

#dotted_line

*2 - Problems in the current code*

*Q4*: What are the biggest pain points in the current codebase and what bothers you when maintaining the code or making new changes?

*A4*:
- The primary issue is the attempt to map object-oriented thinking onto Rust at any cost, which leads to an immense amount of boilerplate code and unnecessary layers of indirection where services call other services and repositories
- This approach creates significant redundancies and forces the use of excessive mocking, resulting in a situation where a developer must read a lot of code to find a very small amount of actual logic
- There is a tendency to use traits for shared logic when enums would be a much better fit, and the use of static dispatch can result in bloated trait bounds that negatively impact the readability of the code

*Q5*: How difficult is it for new developers to understand how the domain is modeled in the code and why?

*A5*:
- It is very difficult because we lack a formal logical definition of the domain from the business side and have not yet developed one ourselves
- The codebase consists of approximately 120,000 lines of Rust code where logic is distributed across many locations and obscured by boilerplate and indirection
- While the current state is not a regression compared to previous Java or Kotlin implementations it is difficult for developers to maintain a large enough mental context to fully grasp the domain
- Since Rust provides more powerful tools for modeling we know that a better implementation is possible but limited time and resources often prevent us from achieving it

*Q6*: Can you specify what you mean by saying that Rust is more powerful, and how this helps developers understand code better?

*A6*:
- Rust allows developers to express large parts of the domain logic directly in the type system, using fewer constructs while making these aspects part of the overall design
- When the domain logic is modeled correctly, understanding the code becomes easier because state transitions and valid states are visible in the types
- This approach requires effort to design initially, but once established it simplifies reasoning about the system
- In Kotlin or Java, similar modeling is much harder and usually requires many additional classes and boilerplate code
- Developers often continue to use Java-style modeling patterns, which leads to flat type hierarchies and does not fully use Rust's type system

*Q7*: When you think about poorly designed code, can you think of concrete examples?

*A7*:
- Poorly designed code is often found in service layers where domain logic is mixed with imperative flow, async handling, database access, and technical concerns
- Additional structs are introduced mainly to enable mocking, even when they are not required by the domain itself
- Validation is done repeatedly on primitive types like strings instead of encoding invariants in the type system
- The actual business logic is scattered and hidden between boilerplate and infrastructure code
- This makes the code hard to maintain because developers must work through a large amount of irrelevant detail to find the important logic

*Q8*: You have the guideline with six criteria that will later be used to evaluate the refactored code. You do not need to address every single criterion, but can you describe methods you know to quantify such properties, for example maintainability or code smells, and how relevant and meaningful you consider them in everyday development?

*A8*:
- For modularity and reusability, there are metrics based on dependency graphs, cohesion, and coupling, which are known from Java and academic contexts, but their concrete definitions and usefulness are often unclear in practice
- For analyzability, tools like SonarCloud provide metrics such as cognitive complexity, but the expert is unsure how reliable or helpful these scores actually are
- For modifiability, the expert cannot name concrete metrics
- For testability, code coverage exists but is seen as limited and not a strong indicator of real testability or code quality
- A more meaningful view of testability is how much logic is implemented as pure functions following a functional core, imperative shell approach, enabling side-effect-free unit and property testing
- Beyond tests, encoding logic and invariants in the type system is seen as the strongest approach, as it shifts correctness towards formal verification at compile time

*Q9*: What is your view on metrics such as the Maintainability Index, cyclomatic complexity, or similar code metrics, and how meaningful do you consider them in practice?

*A9*:
- Cyclomatic complexity seems reasonable as a metric because it reflects control flow and helps avoid fragmented logic that is hard to follow
- Lines of code are not meaningful as a quality metric, especially in Rust, because more code can simply mean explicit modeling of states or data structures
- A large number of structs is not problematic, while many conditional branches in a single function are
- Lines of code can at best give a rough sense of project scale, such as distinguishing between small and very large codebases

#dotted_line

*Use Case 1 - Status Quo*

*Q10*: Let us move to the use cases. We start with the first one, the Detail View Service, and first look at the status quo. What code smells do you notice, where is the code hard to maintain or error-prone, and which of the criteria from section 2 do you think are negatively affected?

*A10*:
- It is unclear why Detail View Service is a struct at all, and why related parts like Variation Service are also separate structs, since this seems mainly done for mocking rather than for domain reasons
- Mocking is seen as an anti-pattern here; if anything, only external edges like databases or HTTP services should be mocked, and even databases can often be tested with local instances instead of mocks
- The file contains a lot of boilerplate early on, where large parts could be removed without losing real logic, which makes the code unnecessarily long and harder to work with
- I/O and business logic are mixed, and the implementation is strongly imperative with large conditional blocks and many boolean operations, which is unpleasant to read and likely increases error-proneness
- The domain logic looks like it could be modeled more cleanly, possibly like a simple state machine, but instead it is tangled with indirection, side effects, and Spring-like structuring, rather than embedding transitions and constraints more clearly

*Q11*: Are there specific criteria that stand out to you, for example analyzability or faultlessness, that are negatively affected by this code?

*A11*:
- Analyzability can be treated as readability here, and the readability is reduced because I/O, non-I/O logic, domain concerns, and additional technical elements are mixed, forcing constant context switching and leaving a lot of technical slop between the actual domain reasoning
- This mixing also harms modifiability, because changes require navigating intertwined concerns and understanding many scattered steps instead of a clear, isolated domain flow
- Testability is weakened because testing relies on mocking and heavy setup, even though much of the behavior could be tested as pure logic with simple parameterized tests and ideally property tests
- Reusability is limited because the code mainly describes state transitions like filtering and iterating, but these transitions are tied to I/O; if the domain logic were separated from I/O, it could be reused without copying or extracting a large function
- Faultlessness is negatively affected because many runtime checks and many if-conditions make it easy to break invariants by changing lines or order, and the invariants are hard to keep in mind since the logic is spread across the file

#dotted_line

*Use Case 1 - Refactoring*

*Q12*: Let us move to the refactoring. We will look at the new code and go through the selected ISO criteria, starting with modularity. To what extent did the refactoring worsen or improve the code's modularity?

*A12*:
- The refactoring encodes the state transitions of the flow in the type system in a more direct way, with cleaner and relatively pure, type-state-like code, which also makes it easier to reuse the flow elsewhere and move it into a library
- After clarifying the ISO definition of modularity as limiting the impact of changes between components, the expert does not see major changes at the file/component level, since the number of files stayed the same and the code remains encapsulated in the same place
- Still, the internal structure is seen as more coherent and more formalized, so invalid internal changes are more likely to be caught as compile errors or become unrepresentable, which the expert interprets as better protected inherent modularity, even if it also relates to faultlessness

*Q13*: On reusability, you already touched on it. Can you explain more how the refactoring affects reusability?

*A13*:
- By defining the individual state transitions more explicitly and using more pure functions, the logic becomes easier to extract, move elsewhere, and reuse in other places
- Parts of the logic might be reused even if the concrete cases differ, because the general flow could still be comparable and suitable for abstraction
- The refactoring also makes it easier to understand what the business logic actually does, and this clarity helps identify which parts can realistically be reused and which cannot

*Q14*: Could the applied type-state pattern also have negative effects on reusability, for example because you can only reuse an extracted state transition elsewhere if you already have the required state, which you might not be able to construct without going through other valid transitions?

*A14*:
- The expert does not see this as a drawback but as an intended feature, because using a transition without having the correct prior state should not be possible
- If some logic should be reused in a different context that does not fit the same type-state flow, it should be extracted further into a smaller function and then called from both places
- Being able to jump into the middle of a flow is considered undesirable, and if that is needed it suggests the business logic is modeled incorrectly

*Q15*: Regarding analyzability or readability, is the refactored code easier or harder to read, analyze, and understand?

*A15*:
- The refactored code is unconventional for the team because they are used to imperative code, but it is still considered clearly easier to understand
- Although the refactoring introduces more code, such as additional structs and explicit transitions, this code is simple and descriptive rather than complex
- The added code represents high-level structure and can be quickly grasped or mentally collapsed, unlike deeply nested logic and many if-conditions
- Understanding the overall business logic becomes easier because the flow is explicit and less cluttered with low-level control flow
- There is an initial learning curve because the style differs from Java or Kotlin, but once familiar, the code is much more understandable
- Improving analyzability in practice is especially important because most work is done in existing codebases where reading and modifying code dominates

*Q16*: Do you think that naming the states correctly becomes a bigger challenge because the pattern forces you to name every single state and transition, even when it doesn't always make sense?

*A16*:
- The expert sees this not as a drawback but as a feature, because if a state or transition cannot be named meaningfully, this indicates a problem in the domain model
- In a well-understood domain, every step should be describable, similar to modeling a process in BPMN
- Difficulties in naming suggest that the domain is not fully understood or is being modeled incorrectly
- This situation encourages closer interaction with business stakeholders to clarify the domain
- The pattern helps make implicit uncertainty explicit, whereas previously such issues were hidden in tangled code
- Making such problems explicit is seen as a general strength of Rust and of this modeling approach

*Q17*: Just to summarize, you said that the added boilerplate, which almost doubles the code size, does not have a negative effect on analyzability for you. Is that correct?

*A17*:
- The additional boilerplate is irrelevant for analyzability because it can be collapsed, navigated easily, or moved into separate files
- Metrics like lines of code are therefore meaningless, because the refactored code is better in most non-functional aspects despite being larger

*Q18*: Regarding modifiability, has it become easier or harder after the refactoring to change the code without introducing new errors?

*A18*:
- Modifying the code is much easier because invalid flows and wrong ordering of steps are prevented by the type system at compile time rather than by runtime checks
- Since the refactored code is also easier to read and analyze, changes can be made with more confidence and a lower risk of introducing new errors

*Q19*: Imagine you want to add a new feature, such as an additional filter, an aggregation, or another service call. Previously you could insert a line somewhere in the flow, but now you need to decide which state it belongs to, possibly introduce a new state, and adapt surrounding transitions. Do you see disadvantages in this, such as increased effort, frustration, or developers putting logic into the wrong state?

*A19*:
- The additional effort is intentional and beneficial because it forces developers to think about the correct placement of logic
- The approach follows the idea of catching errors as early as possible in the development process, ideally at compile time and not in production
- If logic does not fit into the existing state flow, this suggests a problem in how the domain is modeled; in such cases, the model should be revised, ideally together with business stakeholders
- The Rust compiler helps in this process by providing feedback when the code does not compile
- Like any guideline, the pattern can be bypassed, but if the team agrees on its benefits, it is likely to be applied consistently

*Q20*: Regarding testability, how did it change through the refactoring, and can you also comment on the number of required mocks and the freedom from side effects?

*A20*:
- Testability improves overall, but some parts still mix business logic with side effects, so the refactoring does not fully eliminate the original issues
- Using type-state without fully separating side effects adds some overhead and limits the potential benefits
- Type-state fits well with a functional core, imperative shell approach, because state transitions can be implemented as pure functions
- When logic and invariants are moved into the type system, fewer tests are needed and test setup becomes simpler

*Q21*: Finally, regarding faultlessness: has the error-freedom of the code improved through the refactoring, are invalid application states prevented, and has the risk of bugs or incorrect behavior been reduced?

*A21*:
- The expert explicitly calls this a suggestive question, because the prevention of invalid states is an inherent goal of the refactoring
- By formally modeling states, invalid states become unrepresentable and are checked by the compiler
- This shifts correctness guarantees to compile time and clearly reduces the risk of bugs and incorrect behavior
- The correctness of these guarantees could, in principle, also be argued formally with pen and paper

*Q22*: Do you think the question is too suggestive?

*A22*:
- Preventing invalid states is a core promise of the type-state pattern, so the question is easy to answer rather than misleading
- Faultlessness is a valid criterion from the standard, so the question is appropriate and justified

*Q23*: Do you want to add anything else about the refactoring, and do you also see concrete disadvantages of the type-state pattern in this use case?

*A23*:
- The type-state pattern works best when consistently combined with pure functions, and applying this more strictly could further increase its benefits
- The added boilerplate could be reduced with macros or existing libraries, and the main challenge is teaching the pattern and making the state flow explicit, for example with diagrams
- Initial unfamiliarity can make the pattern harder to grasp at first, but this improves with practice, while unrelated issues like indirection-heavy mocking should be questioned separately

#dotted_line

*Use Case 2 - Status Quo*

*Q24*: Let us move to the second use case, the Tag Component handler. We again look at the status quo: what code smells do you notice, where is the code hard to maintain or error-prone, and which criteria do you think are negatively affected?

*A24*:
- The code uses plain strings (and option strings) for Dreson even though Dreson is a specific, important domain data type, which is especially inconsistent because the struct is called Validated Params but the type system does not reflect that the value is actually a valid Dreson
- Because Dreson stays a string, validation knowledge is not preserved, so the value may be revalidated later unnecessarily, or validation may be forgotten entirely, which makes the code error-prone and encourages operating on raw strings instead of constrained domain types
- Introducing a dedicated Dreson type with central parsing would improve faultlessness and modifiability, and could reduce test effort by testing parsing once and reusing it, for example by extracting it into a library
- In the status quo, reusability is low because validation and parsing are not encapsulated in a reusable domain type, and validated logic can be inconsistently applied across the codebase
- There is recurring indirection through services and caches that the expert finds unnecessary, suggesting the logic could be kept more directly in the handler or organized without excessive layering
- The code has awkward option mapping and multiple nested options and sums with additional if-conditions, leading to deeper nesting and increasing complexity and readability problems

#dotted_line

*Use Case 2 - Refactoring*

*Q25*: If you have nothing else to add on the status quo, we move to the refactoring and the ISO criteria. Starting with modularity: to what extent did the refactoring worsen or improve the code's modularity?

*A25*:
- Modeling Dreson as a dedicated domain type is considered a clear improvement, because invariants are maintained through validated construction rather than leaving the value as a raw string
- The expert notes minor improvement potential by converting from string to the validated type as early as possible, but treats this mainly as a small refinement
- The naming Validated Dreson is criticized, because a proper domain type should only represent valid values and therefore should simply be called Dreson, ideally extracted into a library
- In terms of modularity, expressing such a domain concept as its own type is seen as the strongest form of isolation, so the change is viewed as essentially perfect for this aspect

*Q26*: Can you also comment on analyzability, not only for the newtype, but also for the code where it's integrated?

*A26*:
- Analyzability improves because the types act as code hints: when reading the code you immediately see that a value is a valid Dreson, rather than an unconstrained string
- When this typed value is passed down into deeper layers of the business logic, it becomes faster to understand what you are working with, because you no longer need to check again whether the string is valid before continuing

*Q27*: Do you think the call with transposed and map-error is good in this handler, or does it reduce readability?

*A27*:
- The expert finds it somewhat fiddly and would prefer implementing `TryFrom` and mapping into that conversion
- With `TryFrom`, error handling becomes straightforward: if conversion fails, you get the error back, and optional map-error logic can stay inside the conversion if needed

*Q28*: Regarding modifiability, did the refactoring make it easier or harder to make changes without introducing new errors?

*A28*:
- Modifiability improves because the typed parameters make it clear what each value represents, instead of passing multiple plain strings that can be accidentally swapped
- With distinct domain types, it becomes much harder to introduce such mistakes, because errors are prevented by the type system rather than only being caught in tests or in production

*Q29*: If you relate this to other functions that use this Dreson type: do you see it as negative or positive that you are now forced to operate with the new type, for example when adding a new function or integrating an existing function that expects a string?

*A29*:
- Being forced to use the domain type is considered a feature because it makes the code more explicit and more readable, even if adapting interfaces is initially annoying
- The compiler helps with the one-time migration work, and afterward it is easier to understand functions because the parameter type directly shows it is a valid Dreson and does not need revalidation
- If a string is required, the type can be made ergonomic via `deref` to string/slice and simple conversions like `Into`, so using the new type does not block practical integration
- Needing a raw string should mostly occur at boundaries such as database access, and even there using a string slice via `deref` is typically sufficient

*Q30*: Regarding testability, how did the refactoring affect the testability of the code?

*A30*:
- Testability improves because validation and parsing only need to be tested once at the boundary
- After that, the validated type can be reused throughout the codebase without duplicating parsing or validation tests

*Q31*: Did anything change here regarding the number of required mocks or side effects?

*A31*:
- Nothing changed regarding mocks or side effects, because no mocking is needed and a valid domain value can be constructed directly
- Constructors like `new_unchecked` are considered a code smell and should only exist, if at all, for a single test that verifies invalid values are rejected, but tests could instead rely on the `Default` trait

*Q32*: Finally, regarding faultlessness: how did the refactoring improve error-freedom, especially with respect to invalid states?

*A32*:
- Invalid states cannot occur anymore because invalid Dreson values can never enter the system if validation happens at the earliest possible point
- Removing validation later in the code cannot introduce invalid values, because the type system already enforces correctness
- Rust doesn't allow passing parameters in the wrong order, which would otherwise only be caught at runtime

*Q33*: Do you have any further general comments on the refactoring, including possible disadvantages or additional remarks?

*A33*:
- Newtypes are already used in our codebase, and using newtypes is appropriate for this use case
- Constructors like `new_unvalidated` should be avoided; conversions should be handled via `TryFrom` / `TryInto`, with ergonomic access through `Deref` to string slices, which removes the need for patterns like `transpose`
- The already existing "PSR" newtype is very similar to the Dreson and could be reused or unified to reduce duplication and improve extensibility in the future

#dotted_line

*Use Case 3 - Status Quo*

*Q34*: For the last use case, the Boxfish API handler: what code smells do you notice, where is the code hard to maintain or error-prone, and which criteria from section 2 are negatively affected?

*A34*:
- The code has many nested constructs, including loops inside multiple if-conditions, which makes it hard to read and understand
- I/O is mixed with non-I/O logic, so technical concerns and business logic are intertwined
- There is a lot of slop code that is not immediately understandable or clearly necessary
- The `build_final_response` part is described as especially messy due to several nested if-conditions

*Q35*: Do you have an opinion on the mutable vectors for results and API errors that live in the handler function and are passed into other functions, and on the design where those functions do not return values but instead mutate these shared structures?

*A35*:
- This is criticized strongly as unidiomatic in Rust, since Rust is immutable by default and extensive mutability is seen as bad practice
- Passing mutable vectors around and mutating them across functions is expected to create problems, especially if concurrency is introduced, for example when moving work to other threads
- The expert does not see why this is necessary, because the logic looks like it mainly performs filtering and looping, which could be expressed without shared mutable accumulation
- The overall style is described as Java-like, and the pattern of looping and pushing into mutable lists is seen as harming correctness and faultlessness

#dotted_line

*Use Case 3 - Refactoring*

*Q36*: Regarding modularity, did the refactoring worsen or improve the code's modularity?

*A36*:
- The original code was largely in one large handler function, so modularity was not strongly present to begin with and is not the main focus of this change
- The refactoring defines the business flow more formally, which the expert associates with slightly improved modularity
- The improvement is described as small compared to the earlier Dreson case, but it is clearly not worse and overall slightly better

*Q37*: Given the definition of modularity as limiting how changes in one component affect others, how do you assess that the refactoring removes mutable state that was previously modified across different functions? Does this affect modularity?

*A37*:
- Removing shared mutable state improves modularity because functions or state transitions are less able to affect each other indirectly
- Without `mut` and mutable references being passed around, changes in one part are less likely to unintentionally influence other parts of the flow

*Q38*: Regarding reusability, how did the refactoring worsen or improve the reusability of the code?

*A38*:
- The use case itself is fairly self-contained, so there is limited direct potential for reuse
- However, by expressing the logic and flow more explicitly, it would now be easier to reuse or adapt similar logic elsewhere if needed
- The refactored structure makes the logic more visible and explicit compared to the previous version with shared mutable state

*Q39*: Regarding analyzability, is the refactored code easier or harder to read, analyze, and understand?

*A39*:
- The refactored code is much easier to understand because removing shared mutable vectors eliminates uncertainty about what has already happened in the flow
- By expressing the flow explicitly through states, it becomes clear where the code is conceptually, which makes reasoning and re-entry much simpler

*Q40*: Regarding modifiability, did the refactoring make it easier or harder to change the code without introducing new errors?

*A40*:
- It is harder to introduce new errors, because the structure now prevents many classes of mistakes by construction
- The type-based flow forces changes to be made in the correct place instead of accidentally modifying shared state
- Removing shared mutable state eliminates a major source of accidental breakage
- As a result, developers can rely more on the existing logic and make changes with higher confidence

*Q41*: Can you say something about the testability of the code? Did it improve or worsen, and how does this affect the need for mocks or handling side effects?

*A41*:
- The expert cannot make a concrete assessment because there are no tests for this function and they are not sufficiently familiar with the codebase
- Despite that, the refactored version would be preferred for testing because it is easier to understand
- Improved analyzability helps identify what should be tested and what a sensible test setup looks like
- Since tests also serve as documentation, clearer code leads to clearer and more useful tests

*Q42*: If you look at the processor dependencies struct: previously the whole bundle of services was passed into the function, but now only the specific services needed are passed. Do you think this affects testability?

*A42*:
- Passing the whole dependency bundle is annoying because it forces setting up and mocking services that are not needed
- If the refactoring now passes only the required dependencies, this is clearly better and more convenient for tests
- Needing less setup and fewer mocks is generally a direct improvement for testability

*Q43*: Regarding the last criterion, faultlessness, do you want to add anything beyond what you already mentioned?

*A43*:
- There is nothing additional to add, since the same aspects discussed before apply here as well, because the same pattern leads to the same benefits

*Q44*: Do you have any general remarks on the refactoring?

*A44*:
- The coding style is very different from what the team is used to, which can feel overwhelming at first
- Some naming choices are criticized, for example using the term “Result,” which has a specific meaning in Rust but is used differently here
- These issues are considered minor nitpicks rather than fundamental problems
- Other aspects, such as existing API error handling, were already present before and are not caused by the refactoring

*General Remarks*

*Q45*: Do you have any final general remarks on the patterns, or anything you would like to add in conclusion?

*A45*:
- The expert evaluates the patterns very positively and sees strong value in them
- It would be interesting to involve business stakeholders and let them model one of the modules themselves to compare their understanding with the code
- The approach is seen as both more formal and closer to the business domain, but it requires learning and practice within the team

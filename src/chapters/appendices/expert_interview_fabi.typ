#import "../../components/formatting.typ": dotted_line

#stack(
  spacing: 6pt,
  [*Expert*: B.Sc. Fabian Diez],
  [*Date*: January 9, 2026, 1:00 pm],
  [*Location*: Online meeting],
  [*Background*: Senior Software Developer, Otto GmbH & Co. KGaA, 3.5 years Rust experience],
)

The following is a summary of the expert interview, which was created with the support of large language models. The summary has been confirmed to be correct in its content by the expert.

*1 - Introduction*

*Q1*: How long have you been working with Rust and in what field or on what products?

*A1*:
- Private experience for about 3.5 years and professional experience for 1.5 to 2 years
- Works in the Boxfish team at Otto Marketplace, specifically on generating return labels
- Replaced an old Java service with a new Rust service that uses Typst as a library for PDF rendering
- Chose Rust and Typst to meet the requirement for high-efficiency, real-time label generation for the frontend
- Implemented the service using AWS Lambda and the official AWS toolstack for Rust

*Q2*: What distinguishes Rust from Java or Kotlin regarding maintainability and faultlessness?

*A2*:
- Faultlessness is the biggest advantage of Rust compared to other languages
- While Kotlin improves on Java through nullability and its val/var distinction for mutability, Rust goes further with its sensible defaults
- In Rust, variables are immutable by default unless explicitly marked, whereas Java requires the extra effort of adding "final" to achieve safety
- Most real-world bugs the expert encountered over five years resulted from missing data or lack of verification, issues that strict type systems prevent
- Rust forces developers to explicitly acknowledge when they are bypassing safety features like using unwrap, making dangerous code sections easy to spot
- Unlike Java, which suffers from unchecked exceptions that can unexpectedly break control flow, Rust makes the control flow explicit and prevents hidden crashes

*Q3*: What do you consider the primary causes of technical debt in large Rust codebases, particularly when looking at the potential disadvantages of the language?

*A3*:
- The language is extremely feature-rich and complex, often offering too many different ways to achieve the same result
- Onboarding new team members is difficult because it takes a long time to master the patterns and specific syntax, which is a major disadvantage during team rotations
- In the domain of business software, the mandatory focus on memory management often feels like unnecessary overhead since they aren't writing low-level software
- While Go might be a simpler fit for business logic due to its garbage collection, it lacks the unique safety features that still make Rust attractive
- Experienced developers from languages like Java cannot easily transfer their intuition for code structure and must essentially start fresh to learn idiomatic Rust, such as using the From trait or specific control flow macros

#dotted_line

*2 - Problems in the current code*

*Q4*: What are the biggest pain points in the current codebase, and what bothers you about maintenance and making new changes?

*A4*:
- Advantages of the type system are not used consistently, such as passing raw strings instead of using Enums for defined cases
- This neglect of the type system leads to a direct loss of faultlessness
- There are many impure functions with side effects that mutate lists internally and take unnecessary dependencies
- The application flow is difficult to follow and requires deep diving through multiple functions to understand the extent of side effects
- The code is unwieldy and lacks modularity, making it nearly impossible to test parts in isolation or reuse existing logic

*Q5*: To summarize, everything is tightly coupled, making it hard to extract or reuse logic for other use cases. Let's move on to the next question: How difficult is it for new developers to understand how the domain is modeled in the code and why?

*A5*:
- It is extremely difficult because the domain logic is not self-documenting; instead, functions often perform 20 tasks in a row
- Knowledge about the different states and cases is implicit in the control flow rather than being explicitly defined in the type system
- The code appears to be a direct 1:1 translation from old Java to Rust without any attempt to rethink or remodel the architecture for a new language
- Developers porting code from Java often lack the necessary patterns or "handicraft" to find a fresh approach, leading them to simply replicate procedural functions

*Q6*: The same issue occurred during the migration of the Detailview Service from Kotlin. We followed the existing structure too closely instead of remodeling the business case from scratch.

*A6*:
- Agrees that failing to remodel during a rewrite is a common reality in the industry
- Finds it interesting that both the complex Detailview Service and the simpler Tag Handler suffered from the same root cause

*Q7*: Do you have specific examples of poorly maintainable code?

*A7*:
- The expert views functions with heavy side effects and mutable references as the primary drivers of unmaintainable code
- Deep nesting and high indirection levels make it difficult to follow the logic, often requiring developers to jump multiple layers deep to find trivial operations
- Use of helper functions that merely wrap simple tasks like logging or pushing to a list are bad, as they hide behavior without providing meaningful abstraction
- This lack of locality makes it dangerous to change code because the impact on the overall flow is hard to predict and isolate

*Q8*: We have similar problems where many services call further services and so on. This probably comes a bit from the Java mindset, but it is very interesting.

*A8*:
- In Java, this problem is rare because Dependency Injection makes almost everything indirect, which simplifies mocking
- Rust does not provide this by default unless you explicitly create Trait objects or Traits for every service struct
- The team is considering using Traits for database repositories to make them easier to mock, applying the Dependency Inversion Principle from SOLID
- It is much cleaner when a service depends on a Trait so you can replace the concrete implementation, like MongoDB, with something else

*Q9*: It is interesting that traditional software engineering principles don't really help once you are in Rust, right?

*A9*:
- These principles can be mapped to Rust, but they don't work out of the box like they do in Spring where Dependency Injection and Inversion are built-in
- Developers often try to transfer their gut feeling from Java 1:1 to Rust, which fails unless they take the extra step of building interfaces or extracting logic
- A better approach in Rust is to encapsulate the core domain logic in pure functions without side effects, making them easy to test without mocks
- While mocking is easy in Java, it can reduce the value of tests because they drift further away from the actual runtime behavior

*Q10*: We use six criteria for evaluation. What methods do you know to quantify these, and how relevant are they in your daily work?

*A10*:
- Code coverage is the only metric consistently used in their professional practice, particularly in the Java context
- Modularity metrics exist in academia and some tools, but the expert has not encountered or used them in a Rust professional environment
- Reusability can be measured by the amount of duplicated code; highly coupled functions with technical dependencies (e.g., MongoDB) are significantly less reusable in different contexts
- Analyzability is often associated with the Cognitive Complexity score, a concept known from tools like SonarQube in the Java world, though not currently used by his team in Rust
- Modifiability is best measured by the time required for a change and the total lines of code that need to be adjusted; high nesting and side effects make atomic changes much harder

*Q11*: Those would be more like Ops metrics, looking at how many commits change how many lines of code over time—process-based rather than static code analysis. Do you know the DORA metrics?

*A11*:
- The expert is not familiar with the DORA Software Delivery Performance Metrics
- These metrics play no role in the team's daily business or regular discussions
- It sounds like something from university that hasn't translated into their current work routine

*Q12*: I understand. That is already a good insight. Please continue with Testability.

*A12*:
- Test coverage is the primary metric used for this category
- It has been used extensively in past projects to measure how much of the codebase is exercised by tests

*Q13*: Do you think test coverage actually says something about testability? Coverage only shows how much you cover, not how testable the code is. For example, coverage could be low simply because someone was too lazy to write tests.

*A13*:
- There is an indirect connection because the team often skips testing certain parts of the code specifically because they are extremely annoying to test in Rust
- Unit tests are limited to isolated areas that are easy to test, while the rest is handled by integration tests
- This is a significant gap compared to Java, where basically every line and class is tested and everything untestable is simply mocked
- Rust's lack of reflection makes testing frameworks less powerful, and tools like Mockall require the extra overhead of writing Traits
- Testability depends heavily on code quality; the more isolated and separate the logic, the easier it is to test
- In reality, the team achieves about 60% coverage through unit tests and 20% through integration tests, leaving a 10% gap that is difficult to identify and close

*Q14*: Have you ever heard of cyclomatic complexity? It's defined via the control flow graph. Basically, you look at how many independent execution paths a function has. It's often called McCabe Complexity and was originally developed to determine how many paths you need to cover with tests, so it's actually a testability metric, though today it's often used for analyzability.

*A14*:
- Confirms that it sounds very similar to Cognitive Complexity since both factor in control flow and branching
- Admits he hadn't specifically considered it as a metric for testability before

*Q15*: That is quite interesting. Now, moving to the last criterion, Faultlessness: can you think of any quantifiable metrics or KPIs for that?

*A15*:
- You could count the number of unsafe operations, such as `unwrap` or `unsafe` code blocks in Rust, or the `!!` operator in Kotlin
- Mutation testing is a valuable method for verifying robustness; the expert mentions using tools like "Cargo Mutants" manually
- Mutation testing helps see how robust the code is by intentionally breaking parts of the logic to see if tests fail or if the code even compiles
- Ideally, the code should be structured so that invalid states or "broken pieces" are caught by the compiler itself
- Combining compiler safety with strong test coverage ensures a high degree of faultlessness

#dotted_line

*Use Case 1 - Status Quo*

*Q16*: Let's move on to the actual use cases, starting with the Detailview Service. Which code smells did you notice in its current state, and are there areas that are particularly difficult to maintain or prone to errors?

*A16*:
- The primary issue is a massive, sequential function called `create_detailview_view_model` that handles too much logic at once
- Making changes is risky because an adjustment early in the function affects everything downstream, increasing the chance of unintended side effects
- Testing is difficult and requires an excessive number of mocks because the logic is not modular enough to be tested in isolation
- Analyzability suffers because you have to read through the entire sequence to understand what the function actually achieves
- Faultlessness is compromised because the code doesn't strictly enforce the correct order of operations; it relies on implicit flow rather than compiler-enforced states
- There's a risk of passing incorrect data (like swapping a Variation ID with a Benefit ID) to the wrong call; the code would still compile but the logic would be broken

#dotted_line

*Use Case 1 - Refactoring*

*Q17*: Let's move on to the refactoring. To what extent has the modularity of the code worsened or improved through the refactoring?

*A17*:
- Modularity has significantly improved
- Previously, everything was trapped in one massive function; now, the logic is distributed across many small structs
- Changes are now contained within specific functions defined on those structs, preventing global side effects
- The refactoring established clear boundaries between the individual processing steps
- By breaking the sequential flow into distinct modules, the code is much more flexible and structured

*Q18*: To what extent has the reusability of the code worsened or improved through the refactoring?

*A18*:
- Reusability has improved because logic is now encapsulated in individual blocks that can be reused more easily than logic buried in a massive function
- It is now very clear what responsibility each step has, making it simpler to extract specific logic for new use cases
- However, the Type State Pattern introduces a significant amount of boilerplate code that is highly specific to this particular workflow
- While the business logic is now modular, the structural glue of the pattern itself is not easily transferable or reusable elsewhere because it is so tightly tailored to this flow
- Compared to the original giant function, where extracting even a small piece of logic was exhausting, this is still a step forward

*Q19*: Exactly. And since this refactoring only targeted this one specific spot, the states we extracted are very specialized. To make them truly reusable, you'd probably need to apply this pattern across multiple similar code areas. Otherwise, you're always tied to the specific struct or state as a starting point, which might contain fields you don't even need in another use case. This is just my opinion, please elaborate on whether you agree or disagree with this.

*A19*:
- It's difficult to decide where to draw the line for a state machine in a real-world application
- In practice, a hybrid approach might be best: keeping technical interactions, like DB calls, as standard services while modeling complex logic, validation, and processing sequences as state machines
- A major challenge is that many workflows overlap significantly but require slightly different data at different stages
- If a new flow is 90% identical but needs one extra piece of data passed through, the rigid nature of the Type State Pattern might force you to copy and adjust almost all the structs and transitions
- This high specificity can become a hurdle for reusability if the domain logic isn't perfectly aligned across different use cases

*Q20*: Is the code easier or harder to read and understand after the refactoring?

*A20*:
- The method names (e.g., `get_benefit_ids`, `get_valid_benefits`) are very tangible and describe the business process clearly
- Piping the calls sequentially looks clean and helps someone looking at the code for the first time understand the high-level flow in seconds
- Error handling is improved because errors occur within specific `impl` blocks, making it much easier to pinpoint exactly where something went wrong compared to a massive function
- The data flow is more transparent because each Type strictly defines which data is available and required for that specific step
- A minor disadvantage is jumping between structs; unlike the old version where you just scrolled down, you now have to navigate different parts of the code to see the full implementation
- Overall, this is well-balanced: you get a high-level overview quickly and can choose to dive into specific details only when needed

*Q21*: Other experts have noted that the line count doubled and it's mostly boilerplate. One argued that while it's more code, it's simple code, mostly structs, that isn't hard to understand. How do you position yourself on this? Does the boilerplate make it harder to understand, or is it negligible?

*A21*:
- Every line of code technically adds maintenance cost, but the argument that boilerplate is a burden is largely invalid here because the structs contain no complex logic
- The main trade-off isn't the boilerplate itself, but rather that the behavior is no longer local, it's split up, which can make the code feel stretched out while reading
- Since code is read much more often than it is written, the effort to write the boilerplate is a small price to pay for the clarity it provides
- Forcing the developer to sit down and explicitly define what data a method needs and what its possible outcomes are is actually a beneficial exercise
- The increase in line count is real, but as far as the structs are concerned, the expert sees them as a positive addition rather than a problem

*Q22*: Let's move on to Modifiability. Has the refactoring made it easier or more difficult to make changes without introducing new bugs?

*A22*:
- Modifiability is much better because changes are now isolated within specific modules, whereas changing the old super-function almost guaranteed breaking side effects
- The Type State Pattern forces the compiler to act as a safety net; if you change a data requirement, the code turns red everywhere that needs an update
- Clear definitions of inputs and outputs for each step prevent the accidental swapping of similar variables, like different IDs, which was a major risk in the procedural version

*Q23*: On one hand, adding a simple filter or aggregation takes longer because you might have to create a new state or adjust existing structs. On the other hand, it forces you to think deeply about where the logic truly belongs. Do you agree that this overhead is a disadvantage, or is the forced intentionality a benefit?

*A23*:
- Simple one-liners like mapping or filtering shouldn't necessarily require a whole new state or helper function; you could ideally just chain a `.map()` or `.filter()` within the pipeline to keep minor changes local
- For more complex logic, the overhead of adjusting the next step's requirements like expecting a filtered list instead of a raw one is a price worth paying for the structure it provides
- The perceived disadvantage of extra work is outweighed by the benefits, especially since the original code was an extreme example of an unmanageable super-function
- If the original code had already been split into small, isolated functions, the leap to the Type State Pattern might feel more burdensome, but in this context, the improvement in modifiability is clear.

*Q24*: To what extent has the testability of the code worsened or improved through the refactoring?

*A24*:
- Testability has significantly improved because you can now write unit tests for actual individual steps rather than having to test the entire massive function at once
- Each step only carries the specific dependencies it needs, which greatly reduces the number of mocks required per test compared to the original procedural flow

*Q25*: Has the code's faultlessness improved? Does the refactoring prevent invalid application states, and has the risk of bugs or incorrect function calls been minimized?

*A25*:
- This is the greatest advantage of the refactoring because the explicit nature of the pattern makes it very difficult to accidentally introduce bugs
- You have a guaranteed execution order and strict definitions of which data must be available at each step, making it nearly impossible to bypass the intended logic
- You could still technically put the wrong ID into a struct field
- Because each state transition consumes `self`, it is ensured that steps cannot be called twice or used out of sequence

#dotted_line

*Use Case 2 - Status Quo*

*Q26*: Let's move on to the Tag Component Handler and look at the status quo. Which code smells did you notice? Are there parts that make the code hard to maintain or error-prone, and which criteria are negatively affected?

*A26*:
- The validation logic is written inline, which significantly reduces both modularity and reusability because the logic cannot be used elsewhere
- The presence of deeply nested control flow with statements like `let`, `match`, `if` and `else` makes it difficult for someone not deeply involved in the code to follow the logic
- The code includes workaround comments and scattered test-related snippets, which clutter the implementation and make it harder to understand what is actually happening
- A major faultlessness issue is the reliance on untyped strings; even if the data is validated once, the rest of the system has no type-level guarantee that it remains valid
- Because there is no type-level enforcement, future developers writing new handlers could bypass the validation entirely, as the rest of the system cannot make safe assumptions about the data's state

#dotted_line

*Use Case 2 - Refactoring*

*Q27*: Let's move to the refactoring and start with Modularity. To what extent has the code's modularity worsened or improved?

*A27*:
- The modularity has improved because the validation logic has been moved into its own dedicated function or module, rather than being tangled inline
- While it is a improvement, the change feels less significant than the previous use case because the original starting point wasn't quite as monolithic as the first service

*Q28*: To what extent has the reusability of the code worsened or improved through the refactoring?

*A28*:
- Reusability went from straight-up impossible to completely reusable because the logic is no longer hardcoded inline
- If you were to create a second handler that needs to validate the same Dreson data, you can now simply call the existing validation module instead of having to copy-paste or refactor the original code

*Q29*: Has the refactoring made the code easier or harder to read, analyze, and understand?

*A29*:
- Removing the deeply nested `let` statements and replacing them with a functional chain using `.map()`, `.transpose()`, etc. makes the code much cleaner and easier for any experienced Rust developer to follow
- One point of confusion is the `ValidatedDreson.from_string` function; it takes a list of exceptions, which is confusing at first
- While the previous nested version was annoying, the special case logic was very visible, whereas here you might need IDE type hints to realize that a list of strings is being passed as an exception list rather than being the source for the Dreson itself

*Q30*: Do you have a suggestion for handling these exceptions better when using the Newtype pattern? Usually, you'd use `From` or `TryFrom` for a string, but those traits don't allow passing additional parameters like an exception list.

*A30*:
- One option is to implement `TryFrom` for a tuple, containing both the raw string and the exception list, though this isn't always the cleanest look
- A more explicit approach would be creating a specific `ValidationRequest` struct with two fields: the raw Dreson and the exceptions.
- While a dedicated struct is very clear and removes any guesswork, it introduces more boilerplate, which is a common trade-off between "ideal" pattern application and practical convenience

*Q31*: Has the refactoring made it easier or more difficult to make changes without introducing new errors?

*A31*:
- Modifiability has improved because the validation logic is now isolated in a single method; if the validation rules change, you only have to update that one specific spot
- In the original version, there was a risk of having to update multiple locations, which creates error potential where you might forget to sync a change across different parts of the code

*Q32*: Is the code easier or harder to test, and is there a change in the number of required mocks or freedom from side effects?

*A32*:
- Testability is significantly better because the validation logic is now isolated and can be verified independently without needing to call the entire handler
- Previously, you had to provide all of the handler's dependencies, like the Cache, Tag Service, and Variation Service, just to test a simple string validation, which is no longer necessary
- The special `new_unvalidated` helper method, restricted to test code only via the `#[cfg(test)]` macro, allows for a simple test setup
- This approach makes it easy to intentionally create invalid states for testing purposes without compromising type safety in the production code

*Q33*: Then we come to the final criterion: Faultlessness - has it improved or worsened?

*A33*:
- Faultlessness is significantly higher because validating once at the entry point guarantees a valid state for the entire rest of the system
- Catching errors as early as possible prevents them from leaking deep into the control flow, which is a common problem in languages like Java where a failure might only surface 20 functions deep during a repository call
- By mapping to a specific Newtype immediately, you either get a valid instance or the process stops right there, ensuring that no further logic or side effects are triggered unnecessarily
- This pattern provides a level of certainty that makes the system much more robust, as subsequent functions no longer need to worry about the validity of the data they receive

#dotted_line

*Use Case 3 - Status Quo*

*Q34*: Then we move to the third use case: the Boxfish Lambda Handler. Looking at the status quo code, which code smells did you notice? Which parts are hard to maintain or error-prone, and which criteria are negatively affected?

*A34*:
- Analyzability is a major issue because the code suffers from deeply nested functions and a convoluted call stack that is hard to follow
- Testability is poor due to excessive side effects in almost every function, making it nearly impossible to verify logic in isolation
- Reusability is almost non-existent; even when building similar flows, the current structure forces you to start from scratch because the logic is so tightly coupled
- Faultlessness is compromised by the use of string data and mutable lists for errors, which provide no compiler-level guarantees that data has been validated
- When migrating the lambda from Java to Rust, there was a requirement to match the old Java implementation quirks from years ago to avoid breaking changes for consumers of the endpoint, so some legacy problems were carried over into the new system
- The control flow is extremely difficult to trace, and the system relies entirely on manual tests rather than the compiler to enforce correctness

#dotted_line

*Use Case 3 - Refactoring*

*Q35*: Then let's move to the refactoring. To what extent has the modularity of the code worsened or improved?

*A35*:
- Modularity has significantly improved because you no longer have a single, long control flow where everything happens at once
- The structure is now broken down into individual structs that can be handled in isolation, which means you don't have to understand the entire system just to look at one specific part
- It is interesting to note that the benefits here are very similar to those seen in the Detailview Service, showing a consistent pattern of improvement across different use cases

*Q36*: And what about Reusability? Has it worsened or improved through the refactoring?

*A36*:
- The logic is much better contained and easier to reuse or adapt because it isn't buried in a monolithic block of code
- Since the new types are highly specialized for this specific use case, they carry a bit of boilerplate that can make them harder to reuse directly in a generic way

*Q37*: Has the refactoring made the code easier or harder to read, analyze, and understand?

*A37*:
- Making state transitions explicit through types is a major benefit because it provides a clear overview of the various edge cases that the system actually handles
- Specifically, the "Final Result" type with multiple distinct states is incredibly helpful for instantly understanding all the possible outcomes that can occur in a flow
- Even though these edge cases existed implicitly before, making them visible all at once makes them feel much more manageable and less daunting than when they were buried in logic

*Q38*: Could you summarize it by saying that the Type State Pattern essentially forces you to give an explicit name to states that were previously only implicit?

*A38*:
- Exactly. You are forced to name each state, write it down, and ensure the compiler enforces that you actually handle it
- Because Rust requires matches to be exhaustive, if a function can potentially produce a certain state, you are strictly required to deal with it, making it impossible to accidentally ignore an outcome

*Q39*: I feel that while Type State can be used in other languages, Rust features like ownership (consuming `self`) and exhaustive matching make it feel much more natural. It's almost "married" to the language.

*A39*:
- A notable downside is that this pattern in this case replaces traditional `Result` types, making error handling less ergonomic since you can't easily use the question mark operator (`?`) to bubble up errors or add context
- Team feedback suggests the code becomes "less typical Rust" because developers are used to scanning for the `?` to identify failure points; without it, the possibility of failure becomes more implicit
- There is a lack of distinction between "Technical Exceptions" (e.g., Database down) and "Business Exceptions" (e.g., Request has no items), where technical failures should probably still use `Result` for quick termination
- Combining all outcomes into a single state enum can make the logic clunky because you lose the automatic conversion and ergonomics provided by Rust's standard error-handling traits

*Q40*: That's an interesting point. It's likely due to how I personally applied the Type State Pattern rather than an inherent rule of the pattern itself. There's no requirement that every error must be an enum variant. Using `Result` types alongside it is definitely possible, and I should probably include that as a recommendation in my bachelor thesis.

*A40*:
- Using `Result` for unexpected errors (Technical Exceptions) allows you to use the question mark operator to bubble them up to the top level immediately
- If an unexpected error occurs, you simply exit the state machine since it represents undefined behavior, which keeps the rest of the application from having to manually handle resource failures like a database being down
- At the top level, you could simply map these technical errors to a 500 Internal Server Error, while the specific enum variants handle expected business outcomes like "Not Found" or success states
- While having an enum inside a `Result` might seem slightly complex at first, it would likely be cleaner in practice because it separates the unrecoverable failures from the expected flow transitions

*Q41*: I actually modeled all the use cases using @bpmn. It felt like a good fit to capture exactly what the code does and define the various states.

*A41*:
- @bpmn is a great common ground that matches how business partners already think on boards like Miro, making transitions, and conditions explicit
- Incorporating state machine logic during the planning phase of a story would be a great recommendation for your thesis; it clarifies exactly which state is being modified or added
- Long-term, it would be ideal to have a visual flow for handlers where changes aren't just defined in text, but as visual updates to a diagram that developers can map directly to the code
- This approach makes technical logic much more accessible to non-technical stakeholders and helps developer pairs know exactly where to start their implementation
- An idea for a tool would be a library similar to Swagger that automatically generates a @bpmn diagram directly from Rust Type State code

*Q42*: I've actually already thought of that. My Future Research section already mentions the idea of automatically detecting the Type State pattern to generate a model that can be synchronized with business stakeholders.

*A42*:
- I'm on the same page, that would be a fantastic idea

*Q43*: In @bpmn, you have these "Intermediate Error Events" that can be attached to any activity. If business stakeholders model the logic with XOR gateways for business decisions but use Intermediate Error Events for unexpected technical failures (like a database being down), it translates directly to the code. Seeing an Intermediate Error Event in the model tells the developer: "I need a Result type here."

*A43*:
- That would be great

*Q44*: Let's move through the remaining criteria. We have Modifiability left: has the refactoring made it easier or more difficult to make changes without introducing new errors?

*A44*:
- It is definitely easier because the code is now split into individual steps and blocks that can be modified without causing unintended ripple effects
- In the original version, some functions were used so deeply that changing one would almost certainly break five others; that risk is now largely eliminated

*Q45*: And what about Testability? How has it changed through the refactoring, specifically regarding the number of required mocks or freedom from side effects?

*A45*:
- Testability has improved because you can write tests for individual components like validation logic without any mock setup at all
- Previously, you had to inject a massive amount of dependencies just to test small details, which is a problem we've seen across all the examples today
- While passing a single `ProcessorDependencies` object is somewhat simpler than passing 20 individual variables, it becomes problematic when that object is dragged deep into the control flow alongside multiple mutable lists
- Having those dependencies at the top level is fine, but forcing them deep into every function creates a mess that offers only disadvantages for testing and maintenance

*Q46*: Then we come to the final criterion: Faultlessness. To what extent has the error-free nature of the code improved, especially regarding invalid states, the risk of bugs, and so on?

*A46*:
- This is one of the biggest advantages of the pattern: you essentially prevent invalid states from existing in the first place
- If errors do occur, they are caught immediately at the point of origin, which is a major benefit for system reliability
- The pattern also prevents calling functions in the wrong order, which was a significant risk before; overall, faultlessness has definitely increased

#dotted_line

*General Remarks*

*Q47*: Do you have any general comments about the refactoring that you'd like to add?

*A47*:
- I noticed you used an `Either` type in this part of the code and I was wondering if there was a specific reason for that
- It made me wonder if it wouldn't have been better to use a custom enum where the two variants are named explicitly, rather than a generic Left/Right structure

*Q48*: Exactly. I based that on a research paper explaining the Type State pattern and wanted to try it out. But you're right, there are different ways to do it. `Either` is essentially similar to a `Result`, with a value on the left and a value on the right.

*A48*:
- Using `Either` actually hurts readability because it isn't immediately obvious what "Left" or "Right" represents without looking back at the context
- It contradicts the rest of the logic where everything else is an explicit struct or enum with clearly named variants
- While it might seem like a convenient shortcut to avoid boilerplate when you only have two cases, the benefit is lost because you lose that self-documenting quality
- I found myself jumping back and forth in the code to figure out what was happening, which was much more difficult than just having a named enum

*Q49*: I think the idea is that when you have a larger state machine where different paths eventually merge back together, `Either` helps because it's generic. You can construct it with any type without needing a specific enum, especially if you don't know yet how the flow might split.

*A49*:
- Even in that case, you could just define an input enum with variants A and B to keep it explicit
- The `Either` approach feels very Haskell-like or functional on automata theory, but it's less practical for the reader
- Since it was only used in one place, it wouldn't have hurt to just use an enum

*Q50*: That's a fantastic insight! It serves as a practical evaluation of what that research paper suggested. It's a very interesting finding that this generic approach is actually harder to read in a Rust context.

*A50*:
- Unless you use `Either` everywhere and get used to it, it's better to leave it out entirely
- Being able to see exactly what is happening at a single glance is one of the primary advantages of this entire pattern, so generic types tend to undermine that strength

*Q51*: I'm looking through the Rust Design Patterns documentation to see if there is a convention like "prefer enums over generics"... I can't find the specific quote, but it feels like that would be a solid idiom for business code. Since Rust has @adt:pl where enum variants can hold different data, you can replace generic structures entirely as long as you know your states.

*A51*:
- I just realized this might be a crucial point for maintainability. If the business requirements change and you need a third entry point instead of two, a generic `Either` type scales very poorly
- Generic structures like `Either` or binary trees are great for abstract data structures or parsers where you truly only have two mathematical directions (0 or 1)
- In business logic, requirements are always flexible and likely to expand; using explicit enums makes the code much more adaptable to these changes

*Q52*: If you're writing a library where you don't know the end-user's specific use cases, generics are essential. But in business logic, the context is known. It's a very interesting distinction to make based on the type of software you are developing.

*A52*:
- Mhm. (agreement)

*Q53*: Do you have any other comments on the refactoring? Also, to follow up on my earlier question: when you showed this to the team, did they have any specific feedback? I imagine they might have said it looks unfamiliar since the pattern is new to them.

*A53*:
- The feedback was actually very positive; the main critique (from our Tech Lead) was the point about technical exceptions and the lack of `Result`, which we've already agreed is a valid point that can be integrated
- The team was already somewhat dissatisfied with the current implementation, viewing it as a "messy rewrite," so they were looking for a cleaner skeleton or template to use with Cargo Lambda
- There is a concern about consistency: if the pattern isn't followed strictly, for example, if a team member is away and comes back without fully grasping the logic, the value of the pattern disappears quickly as the implementation starts to tilt
- We might look for a middle ground where we take the best learnings, like the simple rule of using more explicit enums; they are essentially free and clarify exactly what states or results a method can return even without a full state machine

*Q54*: I definitely pushed the pattern to its academic limit for this project, but in practice, you can pick the best parts. What really helped me was shifting my mindset regarding enums. In Java, enums are just a fixed list of constants. In Rust, they are Sum Types, part of @adt:pl. While Structs are Product Types (all fields must exist), Enums allow for "one of these" cases where each variant can hold different data. Thinking in terms of Sum Types might help the team grasp how to model these "either-or" states.

*A54*:
- Exactly; it's very similar to Sealed Interfaces in Kotlin or the newer Sealed Classes/Interfaces in Java
- This represents a specific level of abstraction where, in traditional Java, you would have immediately reached for Object-Orientation and inheritance to solve the problem
- Shifting to this functional Sum Type approach provides a cleaner way to handle state without the overhead of complex class hierarchies

_The expert describes an alternative implementation of the Type State pattern using generic Typestates on a single struct, which differs from using Enums and separate Structs:_

- Instead of having 20 separate structs or one large enum, you define a single struct (e.g., `KafkaVault<Mode>`) that has a generic type parameter representing its current state
- The states themselves (like `Encryption`, `Decryption`, or `Uninitialized`) can be implemented as simple, empty marker structs without any data, or regular stucts that carry additional data
- You can use `impl<Mode> KafkaVault<Mode>` to write functions that are available regardless of the state (e.g., accessing shared IDs or configurations)
- You use `impl KafkaVault<Encryption>` to define functions that are only valid when the vault is in the encryption state
- This approach prevents the user from calling a function in the wrong state (like trying to `decrypt` an `Uninitialized` vault) because the compiler will literally not find that method on the current type
- In the Enum-based Type State pattern, if every state needs a specific `ID`, you have to pass it through or duplicate it in every enum variant. With the generic struct, common fields live in the parent struct and don't need to be moved during transitions
- Like the other pattern, state transitions are handled by functions that consume `self` (claim ownership) and return a new version of the struct with a different generic type (e.g., `KafkaVault<Uninitialized>` -> `KafkaVault<Initialized>`).
- This keeps the state machine "contained" within one logical unit (the struct) rather than scattering it across many independent types, making it feel more like a cohesive class while remaining functionally pure
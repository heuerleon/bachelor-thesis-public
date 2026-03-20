#import "../../components/formatting.typ": dotted_line

#stack(
  spacing: 6pt,
  [*Expert*: M.Sc. Dirk Rusche],
  [*Date*: January 6, 2026, 1:00 pm],
  [*Location*: Online meeting],
  [*Background*: Senior Software Developer, Freelancer under contract at Otto GmbH & Co. KGaA, 2.5 years Rust experience],
)

The following is a summary of the expert interview, which was created with the support of large language models. The summary has been confirmed to be correct in its content by the expert.

*1 - Introduction*

*Q1*: How long have you been working with Rust and in which fields or products?

*A1*:
- Started using Rust in mid-2023 which totals about two and a half years of experience
- Developed functions for Shopify shops that compile to WebAssembly and run on servers
- Worked on backend development at FT9 and various private projects
- Developed full-stack applications involving HTML rendering with Rust

*Q2*: What distinguishes Rust from established languages like Java or Kotlin regarding maintainability and correctness?

*A2*:
- From most to least important, and under the assumption that no unsafe code is used within the Rust implementation:
- Higher number of compile-time checks including the ability to validate SQL queries against live database instances
- Absence of runtime reflection ensures static code execution and prevents runtime failures caused by dynamic method calls
- Integrated Option type eliminates the possibility of null pointer exceptions
- Powerful pattern matching with enums that allow variants to hold different data types and structures
- Exhaustive match blocks require explicit handling of all possible cases which prevents errors during refactoring
- Integrated Result type replaces exceptions and enforces explicit error handling for every case
- Default immutability and explicit mutable references provide clarity on side effects without needing to inspect function bodies
- Generic implementations for types satisfying specific traits allow for reduced code duplication
- Type system utilizes Send and Sync traits to prevent various concurrency bugs at compile time

*Q3*: What are the primary causes of technical debt in large Rust codebases?

*A3*:
- The primary causes of technical debt are often independent of the specific programming language
- Implementation of flawed or leaky abstractions that increase unnecessary complexity
- Failure to write idiomatic Rust code which affects long-term maintainability
- Neglecting the use of specific types or the Newtype pattern in favor of primitive types like strings or UUIDs
- Lack of defensive programming such as using catch-all patterns in match blocks instead of listing cases explicitly
- Missing compile-time enforcements that would otherwise guide developers when extending the codebase

#dotted_line

*2 - Problems in the current code*

*Q4*: What are the main pain points in the current FT9 codebase regarding maintenance and new changes?

*A4*:
- Poor testability of individual functions necessitates extensive mocking of dependencies and complex initialization of various objects
- Test methods become excessively long and disorganized, making it difficult to identify the actual logic being verified at a glance
- Understanding a single test case requires as much time and effort as understanding the actual function being tested
- High barriers to testing lead to weak validation logic or the complete absence of test cases for critical code sections

*Q5*: Do you think these testing difficulties are due to the test setup or because unit testing in Rust is less effective than in other languages?

*A5*:
- Issues are not inherently caused by the Rust language but by the specific way functions are currently structured in the codebase
- Heavy reliance on asynchronous functions implies the presence of external dependencies that require complex mocking
- Adoption of a functional core architectural pattern would significantly improve testability by separating logic from side effects
- Proper application of functional programming principles would lead to more isolated and easily verifiable code units

*Q6*: Are there any other pain points in the code?

*A6*:
- Long functions and methods that perform too many distinct tasks and are often defined as asynchronous by default
- Difficulty in testing arises from these large asynchronous blocks, which should instead be decomposed into smaller, testable units
- Tight coupling between core business logic and non-functional requirements such as database access, metrics, logging, and tracing
- Cluttered function bodies due to the mixing of infrastructure concerns with the actual application logic
- Infrequent use of defensive programming patterns, leading to situations where new enum variants are overlooked during codebase extensions

*Q7*: Does defensive programming refer only to the example with enums or does it apply generally to other areas?

*A7*:
- Application of defensive programming principles is relevant across various parts of the codebase beyond enums
- Mapping between different data structures presents a risk when new attributes are added to a source struct
- Use of explicit destructuring during the mapping process ensures the compiler flags missing attributes immediately
- Failure to use destructuring can lead to silent errors where new data fields are ignored during transformation
- Manual mapping without compiler-enforced checks makes it difficult to locate all code sections that require updates

*Q8*: How easy or difficult is it for new developers to understand how the domain is modeled in the code and why?

*A8*:
- Basic domain logic is relatively simple as it involves managing benefits, user selections, and activations without complex transaction requirements
- Significant complexity arises from the fragmented system landscape and the specific way components like the Importer and Model Creator interact
- Unclear boundaries exist regarding where data mapping occurs, leading to confusion about whether logic belongs in the Model Creator or the Service
- Fragmented responsibilities make it difficult for newcomers to predict the location of specific business rules or data transformations
- Ambiguity surrounds the classification of different benefit types and why they are handled by different services or touchpoints
- Frequent local code changes without global refactoring lead to multiple redundant implementations for similar use cases
- Lack of a holistic architectural view prevents the unification of similar processes and complicates the onboarding process

*Q9*: When you think about poorly maintainable code, do any specific code examples come to mind?

*A9*:
- The activation service serves as a concrete instance of code that is difficult to maintain
- The use of generics to handle both Customer ID and Visitor ID is a specific point of concern
- Spontaneous recall of other examples is currently difficult without reviewing the codebase again
- A detailed list of further examples can be provided later after a more thorough review if required

*Q10*: Which methods do you know for quantifying these properties and how do you evaluate their relevance and validity in daily development?

*A10*:
- Quantification of code properties is difficult, whereas qualitative assessment is much easier
- Tools like Sonar and other code quality metrics have been used, but their value is questionable
- Metric comparisons are often problematic because it is unclear if they are absolute or in relation to lines of code
- Counting logic structures lacks consistency, such as whether an "if" condition or a "when" case carries the same weight
- Previous experience with metrics shows that it is rarely possible to derive actual improvements from the data
- Relevance in daily development is considered very low because the metrics lack sufficient validity and meaning

#dotted_line

*Use Case 1 - Status Quo*

*Q11*: Which code smells do you notice in the status quo of the first use case (DetailView Service), and which criteria are negatively affected?

*A11*:
- Mixing of business logic with infrastructure concerns like tracing, logging, and metrics occurs within the DetailView Service
- The main method is overly long, making it difficult to grasp the sequence of operations at first glance
- Modularity is limited because the entry function depends heavily on specific helper functions like Get Valid Benefits
- Reusability of the outer method is low because it acts as an imperative shell tied to specific side effects
- Analyzability is negatively impacted by the length and complexity of the method, requiring significant effort to understand the flow
- Modifiability and Testability are hindered by the large function size, as smaller units would be easier to verify and change in isolation
- Dependencies like the DetailView Cache within helper functions make unit testing more difficult than necessary
- Faultlessness is already relatively high as the code already makes appropriate use of NewType patterns for domain safety

#dotted_line

*Use Case 1 - Refactoring*

*Q12*: Regarding the refactoring of the DetailView Service, would you say the code still produces the same results in terms of functional correctness?

*A12*:
- Verifying the functional correctness is more difficult now because the code volume has nearly doubled from 170 to over 330 lines
- Increased line count makes it harder to trace whether the logic remains exactly the same as before
- A definitive statement on correctness would require a full review of all components and running the test suite
- Assumption is made that the code remains correct as long as the existing tests continue to pass
- Uncertainty remains regarding whether edge cases that were poorly tested before are still handled correctly in the new version

*Q13*: In what way has the modularity of the code worsened or improved through the refactoring?

*A13*:
- Initial impression of the refactoring points toward high coupling and low cohesion, suggesting a decrease in modularity
- The new structs created by the type-state pattern are not truly modular because they are strictly dependent on one another
- Changes made to one method require checking all subsequent methods in the chain to ensure the data flow still fits
- Modularity has not improved because the original code consisted of a single large function rather than distinct modules
- The overall assessment of modularity remains neutral or "the same" because the logic was simply split into smaller pieces
- The presence of significantly more boilerplate code is noted, though it does not directly change the modularity of the underlying logic

*Q14*: In what way has the reusability of the code worsened or improved through the refactoring?

*A14*:
- Reusability is viewed similarly to modularity, as the logic cannot necessarily be used directly elsewhere without overhead
- Reusing specific parts requires the creation of intermediate types, which adds complexity to any potential integration
- Presence of infrastructure-specific code, such as spans that are created and immediately dropped, complicates the reuse of business logic
- Splitting a method into individual steps technically makes parts accessible, but their actual utility remains questionable without a concrete need
- Evaluation of reusability should consider whether a better abstraction could cover multiple similar use cases rather than just splitting existing code
- Doubt exists regarding whether the current decomposition actually serves other existing or future use cases effectively

*Q15*: So you would say that if you tackle such a refactoring, you would need to include many more code locations and refactor them as well to make the code reusable?

*A15*:
- Approach to refactoring depends heavily on the specific goal of the changes
- Improving general service architecture or reducing duplication requires looking beyond a single service or handler
- Local refactoring of a single method is appropriate if the primary goal is to improve readability and testability within that specific area
- Enhancing maintainability can be achieved through isolated changes if the focus is strictly on making that one method easier to understand

*Q16*: Would you say the effects on modularity and reusability result from the nature of the pattern itself or from how the pattern was applied?

*A16*:
- Linked to the nature of the pattern and how transitions between different types are defined

*Q17*: Regarding Analyzability, is the code easier or harder to analyze and understand following the refactoring?

*A17*:
- Readability has decreased significantly because the total number of lines has doubled, requiring much more effort to scan
- The high-level entry method initially appears interesting because it outlines a clear sequence of operations like fetching IDs and determining benefits
- Complexity arises unexpectedly when a functional call spawns an "up contract task" and returns a join handle
- Duplicate naming conventions cause confusion, such as a method called "Get Valid Benefits" calling a separate function with the exact same name
- Detailed analysis is hampered by wrappers that exist solely to record a single field in a span before returning a new type

*Q18*: The context for that specific function is that it's used elsewhere; making it a state transition would break its reusability for other areas unless those were also refactored. Do you see this as weakness of the pattern or of the existing code structure?

*A18*:
- The observed issues are likely inherent to the pattern itself rather than just the implementation
- Initial feeling suggests that this specific pattern might not be the right fit for the problem being solved
- Readability and testability are perceived as worse than they were in the original code
- Analyzability is negatively impacted by methods like "Create Adjust Link," which performs significant overhead and validation despite its name
- High coupling and low cohesion are evident where methods handle multiple responsibilities like checking headermaps before calling the actual service
- The pattern leads to situations where business logic is buried under boilerplate that primarily serves to pass parameters along

*Q19*: Regarding Modifiability, has the refactoring made it easier or harder to make changes without introducing new errors?

*A19*:
- Modifiability has improved because the functions and methods are now smaller and more manageable
- Clearly defined inputs, type-specific data, and explicit return values provide a better overview for each step
- Isolated units reduce the cognitive load compared to the original long method, where the entire context had to be kept in mind to make a change
- Testability is enhanced alongside modifiability, as the smaller units can be placed under test more effectively
- Shifting certain functions away from being asynchronous significantly simplifies the testing and modification process

*Q20*: To touch on Testability again, would you say it has improved because we have these state transitions? What would you say regarding the number of required mocks or freedom from side effects?

*A20*:
- Freedom from side effects is a direct consequence of shifting away from asynchronous functions
- Absence of mutable references or global data in the new structure effectively rules out side effects
- Smaller methods and the lack of async calls naturally reduce the need for complex mocking in tests
- State transitions create naturally isolated units that are significantly easier to bring under a test suite

*Q21*: Could the testability be negatively affected because you have to construct the state (the struct) for every test instead of just passing input parameters? Or does that not matter?

*A21*:
- Assessment of testability depends on whether it is being viewed in absolute terms or relative to the status quo
- Relative to the original code, construction effort is reduced because you no longer need to satisfy all dependencies for one giant function
- Smaller, refactored units require only the specific data relevant to that transition rather than the entire context
- While constructing state structs adds some overhead, it is still an improvement over the previous monolithic structure
- Absolute testability is likely not at its peak, but the refactoring represents a step forward compared to the starting point

*Q22*: Regarding Faultlessness, meaning domain safety and the ability of the Rust compiler to catch errors at compile time, has the refactoring improved the representation of business logic in the type system?

*A22*:
- Domain safety has neither significantly improved nor worsened in this specific code example
- The refactoring mainly involved splitting functions rather than introducing new type-level constraints that restrict invalid states
- The Type State pattern is most effective when used for branching logic, such as a Builder pattern that yields different subtypes (e.g., HTTP vs. gRPC) based on previous choices
- In the current use case, there aren't distinct execution paths that provide different methods based on the current state
- Greater benefits for faultlessness would be realized in scenarios with complex state flows where only specific transitions are legally allowed by the compiler
- While the structure is different, the lack of conditional state transitions means the type system isn't doing significantly more work to prevent logic errors than before

#dotted_line

*Use Case 2 - Status Quo*

*Q23*: Looking at the status quo of the second use case, which code smells do you notice, and which criteria are negatively affected?

*A23*:
- Validation logic is fragmented between the type system and manual checks for the target and current context traits
- Redundant validation occurs in multiple places, making the flow less efficient and harder to follow
- String concatenation is used to construct the sheet URL, which is highly error-prone and lacks type safety
- The manual assembly of URLs without a proper builder or type-driven approach increases the risk of runtime failures
- Logic within the handler function remains relatively simple, but the lack of structured URL handling is a notable weakness
- Analyzability and faultlessness are negatively impacted by the manual string manipulation and split validation logic
- Modifiability is hindered by the manual URL construction, as adding or changing parameters requires manual string manipulation rather than simple builder methods
- Analyzability is hindered by returning a generic `IntoResponse` trait, forcing the developer to scan the entire function to determine that it consistently returns a `Tag` in the success case

#dotted_line

*Use Case 2 - Refactoring*

*Q24*: Regarding the refactoring of the second use case: does the function still do what it's supposed to, or were new bugs introduced?

*A24*:
- Functional correctness is maintained; the logic appears to perform the same actions as before
- The changes are manageable and straightforward, specifically regarding taking a string and creating a `ValidatedDreson`

*Q25*: How has the code's modularity changed following the refactoring, particularly considering the new `ValidatedDreson` struct?

*A25*:
- Modularity has improved because the validation logic is now decoupled from the specific handler and encapsulated within the `ValidatedDreson` struct
- The `FromStr` implementation serves as a clean interface, allowing the handler to remain indifferent to the underlying validation details
- The internal logic of the validation can now be modified or extended independently without affecting the handler's structure
- Implementing `Deref` was suggested to further enhance the design by providing "syntactic sugar" that allows the compiler to treat the struct like a string slice where needed, though its categorization (Modularity vs. Reusability vs. Analyzability) remains debatable

*Q26*: How has the code's reusability changed following the refactoring?

*A26*:
- Reusability has improved because validation logic is now centralized rather than scattered
- The new `ValidatedDreson` type can theoretically be utilized across various other handler functions, facilitating code sharing

*Q27*: How has the cognitive effort required to understand the code changed following the refactoring?

*A27*:
- Analyzability has generally increased; the respondent describes the new code as more concise and clearer
- While the use of `transpose` and specific mapping functions slightly "veils" the logic compared to imperative code, this is viewed as a characteristic of the coding style rather than a flaw in the pattern itself
- Readability is improved by the more compact structure, though questions remain regarding why validation occurs separately from the initial parameter deserialization
- A suggestion was made that implementing the `Deref` trait would further reduce cognitive load by removing the need for explicit `.inner()` calls, allowing the compiler to handle the conversion to a string slice automatically

*Q28*: Regarding Modifiability, is it easier to make changes without introducing errors?

*A28*:
- Modifiability for the handler remains largely unchanged; while the code is shorter, the use of `map`, `transpose`, and `map_err` makes the flow slightly less obvious at first glance than the previous `match` and `if/else` structure
- For the `ValidatedDreson` portion, modifiability has improved significantly because the methods are smaller, more focused, and easier to oversee
- Testability for the handler function itself has not changed, but it has improved "considerably" for the validation logic
- The refactoring allows for isolated testing of the validation logic, which was previously impossible when it was embedded within the larger handler
- The respondent notes a strong correlation between Modifiability and Testability, as both benefit from the same underlying structural improvements

*Q29*: One could argue that testability for the handler has also improved because you no longer need to test the validation logic within that specific context, as it has been moved to external unit tests.

*A29*:
- The argument is considered highly debatable; while offloading validation to unit tests simplifies the handler, it raises questions about how much integration testing is still necessary
- There is a risk that someone (e.g., a junior developer) could bypass the `ValidatedDreson` struct and pass a raw string slice instead, potentially re-introducing bugs if the handler doesn't enforce the type strictly
- If the type-safety isn't strictly enforced across all internal function calls, the enclosing function might still require its own tests to ensure nothing was broken during refactoring
- The trade-off between trusting isolated unit tests versus maintaining redundant coverage in the handler is a complex issue without a one-size-fits-all answer

*Q30*: Finally, regarding Faultlessness: Has the refactoring changed anything in terms of compile-time checks, correctness, or the prevention of runtime errors?

*A30*:
- Faultlessness has improved because functions like `get_benefit` now require the `ValidatedDreson` type as an input parameter
- Since instances of this type can only be created through the validation logic, the compiler guarantees that any data reaching the function is already valid
- This prevents runtime errors by moving the validation boundary to the type-system level, ensuring the function logic always operates on a valid state

#dotted_line

*Use Case 3 - Status Quo*

*Q31*: Regarding the status quo of the third use case: Which code smells and issues affect maintainability or error-proneness?

*A31*:
- Heavy reliance on mutable references passed between functions creates side effects that make the logic hard to track
- Functions take the entire `Request` or `ProcessorDependencies` as arguments when they only need a small part (e.g., just the body or the Mongo client), obscuring actual dependencies
- The design uses an output parameter pattern (passing a mutable result vector) instead of returning a value, which is less idiomatic and harder to follow
- Analyzability is terrible because the interconnected side effects make it difficult to understand the state of the data at any given point
- Modularity is poor due to the tangled nature of the functions; changes in one place risk breaking hidden assumptions elsewhere
- Individual unit testing of small methods is possible, but testing the big picture is difficult because unit tests cannot easily guarantee the correct interaction of all mutable side effects
- The respondent questions the overall functional correctness because the high number of side effects makes it difficult to verify the exact behavior of the methods

#dotted_line

*Use Case 3 - Refactoring*

*Q32*: Regarding the refactoring of the third use case: does the code still produce the same results, and is it still correct?

*A32*:
- Functional correctness appears maintained on first glance, though the respondent had not looked at this specific part in detail prior to the interview

*Q33*: How has the modularity of the code changed through the refactoring?

*A33*:
- Modularity has neither improved nor worsened; the respondent notes it remains similar to the previous state
- The implementation uses the Type State Pattern, which helps structure the flow, but adding a new step between existing ones still requires modifying multiple modules
- Because the individual steps are interdependent, they cannot be considered in complete isolation, a limitation that was also present in the original version

*Q34*: You mentioned that the Type State Pattern might actually make the code less modular and less reusable. Could you elaborate on that?

*A34*:
- Reusability is limited in the current implementation because the code defines a fixed sequence of steps
- Since each step is tightly coupled to a specific preceding and succeeding type, the individual parts cannot easily be reused in different contexts
- While the pattern theoretically allows for branching (e.g., transitioning from type A to type B instead of type C), the current linear fixed sequence doesn't take advantage of this
- One could potentially unpack the return value of a step to do something else with it, but the respondent finds it unlikely that a developer would actually use the code that way

*Q35*: How do you assess the Analyzability? Is the code readable, and how high is the cognitive effort required to understand it?

*A35*:
- Readability and comprehensibility have improved because the workflow is now clearly split into distinct phases: validation, fetching from MongoDB, processing, and the final response
- The removal of mutable side effects makes the code significantly more understandable, even if the total line count has increased
- While it might take more time to read through the entire file due to the increased volume of code, the individual sections are self-contained and free from global or shared mutable state
- The overall flow is much clearer and more manageable than the original tangled version

*Q36*: Would you say, and this is something I noticed, that the Type State Pattern forces you to introduce a name for every state and every transition, which might automatically help with comprehensibility if the naming is done correctly?

*A36*:
- If the naming is done correctly, then yes
- In the first use case, some names felt somewhat unfitting; for instance, a state might be named "A" but it was actually performing actions A, B, and C
- Correct naming is essential for the pattern to actually improve clarity

*Q37*: Naming strategy can be a problem with new patterns. I wondered whether to name a state after the result (e.g., "ItemsFetchedResult") or the next logical step. Depending on the reader's expectations, this affects readability. Would you say it improved for the third use case?

*A37*:
- Mhm (agreement)

*Q38*: Has the refactoring made it easier or harder to make changes without introducing new bugs?

*A38*:
- Modifiability has improved because final responses are now represented as an Enum, which encapsulates how they are composed and created
- Making changes is significantly easier because mutable references have been eliminated in favor of small, self-contained methods
- Functional purity contributes to better modifiability
- Separating the logic into distinct phases, like validation versus the actual processing of the validated request, allows for simpler and safer modifications

*Q39*: Has testability improved or worsened through the refactoring?

*A39*:
- Testability improved because input and output parameters are clearly defined and the elimination of mutable references prevents unforeseen side effects
- The shift to clear return values makes it significantly easier to write tests and ensures the functions are more predictable

*Q40*: I tried to use Enums for results. In the status quo, error states were often implicit, like an empty array or a None value. Does this use of Enums help with testability or other criteria, and how do you feel about the number of mocks or functional purity?

*A40*:
- The use of Enums has a positive effect on functional correctness and faultlessness because it makes success and error states explicit rather than implicit
- Analyzability is improved because it is easier to trace whether the logic is correct, though the expert is skeptical if it significantly changes testability compared to testing for empty arrays
- Testability and functional purity are linked; the reduced need for mocks in specific methods makes testing easier because functions no longer depend on complex global state or mutable references

*Q41*: Is there anything else you would like to add regarding this use case, or did you notice anything we haven't discussed yet?

*A41*:
- While the code is more readable and looks cleaner, the respondent believes the Type State Pattern is not the ideal choice for this specific scenario
- Because the implementation is just a linear flow from A to B to C without complex state transitions, the pattern doesn't offer unique benefits that couldn't be achieved with simpler architecture
- The respondent questions whether the benefits outweigh the overhead of the extra lines of code and the mapping complexity introduced by the pattern
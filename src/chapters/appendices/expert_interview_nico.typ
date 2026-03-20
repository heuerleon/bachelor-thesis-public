#import "../../components/formatting.typ": dotted_line

#stack(
  spacing: 6pt,
  [*Expert*: B.Sc. Nico Schmidt],
  [*Date*: January 5, 2026, 1:00 pm],
  [*Location*: Online meeting],
  [*Background*: Software Developer, Otto GmbH & Co. KGaA, 2 years Rust experience],
)

The following is a summary of the expert interview, which was created with the support of large language models. The summary has been confirmed to be correct in its content by the expert.

*1 - Introduction*

*Q1*: How long have you been working with Rust, and in what area or on what kind of products?

*A1*:
- Working with Rust at FT9 for approximately 2 years
- Replaced Spring Boot microservices (previously Kotlin) and Lambdas (previously Python, TypeScript, etc.) with Rust
- The team aims to use a single language for all production code; they are currently at 98-99%
- Only one batch task remains in Python, which is also planned to be migrated to Rust

*Q2*: And what, in your opinion, distinguishes Rust from other languages at Otto, such as Java or Kotlin, in terms of maintainability and faultlessness?

*A2*:
- Very little in principle, but the forced redevelopment allowed for reducing dependencies on other teams
- This drastically improved maintainability, development speed, and technical debt
- Owning the crates locally enables changes without waiting for or informing other teams
- For example, the self-written toggles crate is much simpler and easier to maintain than the previous feature-heavy Spring Boot implementation
- Developers are forced to adhere to certain patterns, such as the absence of null values, which leads to higher faultlessness when applied correctly
- Features like out-of-the-box linting and the integrated dependency management via Cargo are significant advantages
- The necessity of rewriting everything built up internal team expertise and reduced overall system complexity

*Q3*: Would you say that these specific language features of Rust, which ensure faultless development, also bring difficulties, especially when coming from a Java or Kotlin context?

*A3*: 
- At the start of the migration from Spring Boot to Rust, many developers had little Rust experience
- While team members had read the Rust Book or done personal projects, none had written productive Rust applications before
- This led to the development of varying code styles among developers
- As is common in software development, there are many ways to achieve a goal, which allows individual experience to play a significant role
- Deadlines and the pressure to finish tasks often resulted in a lack of refactoring to make the code more homogeneous
- There was a lack of clarity regarding what constitutes "correct" code
- Despite having some guidelines, they were insufficient, leading to different development approaches
- Individual opinions further contributed to the resulting mess

*Q4*: What do you think are the main causes of technical debt in large Rust codebases?

*A4*: 
- The business context is very complex, requiring a deep understanding of extensive functional logic before it can be translated into high-quality software
- Achieving this translation is not a simple task
- The team consists of people from different generations who have learned different approaches during their studies and professional practice
- It is difficult to align developers on a consistent code style, especially since many come from a Kotlin and Java background

#dotted_line

*2 - Problems in the current code*

*Q5*: What are the biggest pain points in the current codebase you work with daily at FT9? What bothers you regarding code maintenance and implementing new changes?

*A5*: 
- Different states of customer benefits, such as valid, cancelled, or aborted, are not well-represented, especially the transitions between them
- Functions are heavily nested, calling one another in a chain that follows an object-oriented approach
- This structure is reminiscent of writing code in Spring Boot, where services call other services, which does not result in clean code in a Rust environment
- Rust development should ideally lean more toward a functional style
- A major pain point is the adoption of code styles from Spring Boot, Kotlin, and similar backgrounds

*Q6*: In your estimation, how easy or difficult is it for new developers to understand how the domain is modeled in the code, and why?

*A6*: 
- Understanding the domain is difficult, especially for those who lack full business context
- Developers must first grasp the complex business cases before they can comprehend the corresponding code
- The team includes a mix of experience levels, including junior developers who are just starting their careers after university or vocational training
- Documentation is often unreliable as it is frequently outdated, which is a general industry problem rather than a Rust-specific one
- Challenges are mitigated through pair programming for new team members and structured quality assurance processes with regular feedback
- Despite these measures, the learning process remains demanding

*Q7*: You mentioned several general factors, such as pair programming and the difficulty of understanding business logic due to its complexity. Regarding the code itself, are there other factors besides the adopted Java and Kotlin styles that make it difficult for new developers to understand?

*A7*: 
- The code contains extensive branching with numerous if-statements and special cases derived from the business logic
- These edge cases significantly increase complexity as each must be explicitly represented in the code
- It is common to write 200 additional lines of code to handle a single edge case that rarely occurs and has minimal impact on the user

*Q8*: Can you think of specific examples when you consider code that is difficult to maintain?

*A8*: 
- Input validation is a frequent issue, as security guidelines require validating all data entering services and lambdas, such as URL parameters and request bodies
- A problematic pattern has emerged where controllers or handlers start with numerous lines of code dedicated solely to validation
- The handler for the "Sheet" service accepts an excessive number of parameters, approximately 15 to 20
- This high parameter count makes maintenance difficult, as changing one parameter requires updating it across many functions
- The "Cinema" service uses various types with inconsistent filtering, sorting, and flattening logic
- These components utilize different data sources and fields for their operations, which increases complexity and reduces the maintainability of the code

*Q9*: Which methods do you know for quantifying the seven criteria, and how do you assess their relevance and validity in daily development?

*A9*: 
- Regarding correctness, testing across all levels of the test pyramid up to functional acceptance is essential, with regular reviews of unit, integration, and end-to-end tests
- For modularization, there are no specific key performance indicators, while for reusability, IDEs can help identify duplicated code or test setups like mocks and fixtures
- Analysability depends on how quickly a developer understands the code, which is influenced by their familiarity with language-specific features like the question mark operator or complex if-let conditions in Rust
- The McCabe metric provides an initial indication of code complexity at the function or class level, though it is not without its critics
- Modifiability could be assessed by measuring the time required to implement a change while ensuring that test results and values remains consistent
- Testability can be evaluated through several metrics, including test coverage, the distribution of tests according to the test pyramid, and the duration of test execution
- Further indicators for testability include the number of mocks, the number of parameters in method signatures, and the degree of coupling to other classes
- Functional purity is important, as side effects or writing to global error lists are signs of poor design
- For faultlessness, the primary requirement is some form of formal acceptance or sign-off process

*Q10*: You mentioned McCabe Complexity, or cyclomatic complexity. Do you also know it in the context of testability, to determine how many different test paths need to be covered?

*A10*: 
- I have never applied it in that specific context before

*Q11*: How relevant are such metrics - for example, cyclomatic complexity, lines of code, or the maintainability index - in the daily life of a developer? How often are they actually measured, and how meaningful are they?

*A11*: 
- I have never measured lines of code and do not consider it a particularly good metric
- However, an excessively long class is generally seen as a negative indicator
- I have McCabe complexity metrics running permanently; when the value exceeds a certain threshold and turns red, I usually take action
- IDE warnings regarding an excessive number of function parameters are also very helpful
- Rust offers several high-quality linting tools that are effectively used in this regard

#dotted_line

*Use Case 1 - Status Quo*

*Q12*: Which code smells did you notice in the Detailview Service, and which criteria are negatively affected by them?

*A12*: 
- The first issue is the high number of parameters, with eight different values being passed in, which increases complexity
- Passing these parameters through various functions and sub-functions is problematic, especially regarding the ownership model in Rust
- This negatively impacts criteria such as maintainability and modularization
- Although the function name `createDetailviewViewModel` is appropriate, the internal logic lacks proper separation of concerns
- The process should be split into distinct steps: fetching a DTO from the database, filtering it in a separate function, and finally converting it into a view model
- The current implementation performs too many tasks simultaneously: database queries, filtering, triggering activations, writing metrics, and building the final view model
- Additionally, some functions are used outside of the Detailview Service similar to static functions in Java, which suggests poor architectural design

*Q13*: Can you name specific criteria that are negatively affected by the code smells you mentioned?

*A13*: 
- Most of the criteria are affected; while the code is functionally correct, it suffers from poor testability
- The high number of parameters and conditions requires an excessive amount of tests to cover the entire function
- Readability is significantly reduced because developers must keep too much context in mind while trying to focus on sub-functions
- There is very little reusability, as the function is tailored to exactly one specific use case, making it a poor module
- Regarding modifiability, personal bias plays a role; while the code feels easy to change for someone who wrote it, it is likely difficult for others to read and maintain

#dotted_line

*Use Case 1 - Refactoring*

*Q14*: Regarding functional correctness, does the refactored code still produce the same results without affecting the original logic?

*A14*: 
- I assume so, although I have not deployed or tested it myself
- Based on my understanding of the code, it should produce the same results

*Q15*: To what extent has the modularity of the code deteriorated or improved as a result of the refactoring?

*A15*: 
- In my opinion, it has improved
- Many functions were added that return named structs, and I am a proponent of function pipelining
- Individual functions and their return values could be moved to separate classes to reduce file length and further enhance readability

*Q16*: To what extent has the reusability of the code improved or deteriorated through the refactoring?

*A16*: 
- Reusability is only slightly better, as the functions serve a very specific use case that is unlikely to be used in other projects
- Certain components, such as the `get_benefits` function, are well-written and could potentially be reused
- Other parts remain too specialized for broader application

*Q17*: Do you agree that the Typestate pattern makes reusability difficult because the specific structs required to call a function might contain fields that are not needed elsewhere?

*A17*: 
- Agreement that this approach likely necessitates the introduction of generic types
- One would have to consider using traits or inheritance, which can increase complexity and reduce readability
- Naming the various structs is a significant challenge in this context
- While a name like `UpContractTaskSpawned` fits the specific use case, it may not be easily understood by others
- Clear naming requires careful consideration to ensure the code remains comprehensible for other developers

*Q18*: Regarding analysability and readability, is the code easier or more difficult to read, analyse, and understand after the refactoring?

*A18*: 
- Has a personal bias because the original code is familiar, making it naturally easier to read
- A developer unfamiliar with the codebase might find the new structure more advantageous
- Understanding often depends on the individual's prior knowledge of the specific implementation

*Q19*: Do you notice differences in readability because the Typestate pattern forces you to name individual states and transitions?

*A19*: 
- The response is mixed; while the code sequence is logical, certain implementations like the activation status and "Up Contract" do not necessarily belong together from a business logic perspective
- These logical discrepancies can negatively impact readability for developers who understand the domain
- Minor adjustments to these connections could lead to overall positive effects on the code's readability

*Q20*: How do you view fields in structs that aren't necessary for a specific step but are passed through anyway?

*A20*: 
- Metadata, such as the responsible team or the request origin, is often included in structs because it is needed by a specific function further down the line
- I do not necessarily believe that including this information in the main structs is the correct approach

*Q21*: Is this inherent to the Typestate pattern, or its specific application here? Could it be applied more effectively?

*A21*: 
- I assume it could be improved
- Theoretically, the pattern does not need to be applied quite so strictly

*Q22*: Has the refactoring made it easier or more difficult to modify the code without introducing new bugs?

*A22*: 
- It has become more complicated in some respects; adding or changing a parameter now requires updating all return values across the Typestate pattern
- Refactoring tasks, such as renaming or introducing newtypes, are more complex than before
- However, specific logic changes, such as modifying the sorting of benefits, may have become easier to implement

*Q23*: Do you see it as an advantage that the pattern forces you to think more deeply about changes? For instance, when adding a state, you are required to explicitly define the structs and transitions. Is this a benefit or a drawback?

*A23*: 
- I would characterize that as an advantage
- While adding new logic becomes more time-intensive, it can have positive effects if the developer is committed to doing it correctly
- However, you must ensure the implementation is handled properly, as a developer could still simply add code to an existing state without following the intended design, which would be counterproductive

*Q24*: To what extent has the testability of the code improved or deteriorated through the refactoring?

*A24*: 
- Testability has improved dramatically because the functions are simpler and adhere to the Single Responsibility Principle (SRP)
- I expect that writing tests for individual states requires fewer test cases per function
- This leads to significantly better test coverage and smaller, more manageable tests with less setup and fewer conditions to verify

*Q25*: Has there been a change in the number of required mocks or the functional purity (freedom from side effects)?

*A25*: 
- Yes, both have improved positively

*Q26*: Finally, let's look at faultlessness. This differs from functional correctness by focusing on runtime behavior and how many errors the compiler can catch before execution. Has the faultlessness of the code improved?

*A26*: 
- I believe it has changed very little because the Rust compiler is already excellent at catching errors
- Tools like Clippy and Cargo were already detecting issues in the original code
- Without diving deep into the specific algorithms, I don't think the code changes have a significant impact here

*Q27*: If a developer tries to change the order of functions, is the code now safer from incorrect modifications? Does the compiler protect the developer by ensuring that certain filtering can only be called at a specific point?

*A27*: 
- Theoretically, yes, because the developer must make active decisions
- While the previous version might have allowed reordering list calls, your changes likely prevent that
- However, there is no guarantee that a developer won't simply modify the structs to make it fit
- If the compiler flags a change as "red," the developer will have an active thought behind the adjustment and may just adapt the structs accordingly, which offers little additional safety

#dotted_line

*Use Case 2 - Status Quo*

*Q28*: Moving on to the next use case: the FT9 Tag Component Handler, where the Newtype pattern was applied. Which code smells do you notice, and which criteria are negatively affected by them?

*A28*: 
- The primary issue is input validation; numerous parameters must be validated both technically and functionally to ensure data integrity
- The first lines of the function immediately show two very similar structures: `Target Context Dreson` and `Current Context Dreson`
- Both must be either valid or unset, which is currently poorly implemented and lacks reusability
- Overall, the code suffers from poor readability

*Q29*: Which specific criteria are negatively impacted?

*A29*: 
- Reusability, modularity, and readability are all negatively affected
- Testability is somewhat compromised; while the code is testable, it requires a high volume of tests to cover all possible execution paths

*Q30*: You already mentioned validation. Would you say this affects faultlessness? For instance, because a validated string currently remains a plain string, providing no verification that it actually represents a valid "Dreson"?

*A30*: 
- Yes, that is also a direct consequence.

#dotted_line

*Use Case 2 - Refactoring*

*Q31*: Regarding functional correctness: has the original functionality changed, or does the code still produce the same results?

*A31*: 
- It works exactly as before; the results remain identical

*Q32*: To what extent has the modularity of the code improved or deteriorated through the refactoring?

*A32*: 
- I don't think it has changed significantly, as it only involved a few lines of code
- I wouldn't say there is a major improvement

*Q33*: But it hasn't significantly deteriorated either?

*A33*: 
- Correct, it hasn't deteriorated either

*Q34*: To what extent has reusability improved or deteriorated through the refactoring?

*A34*: 
- Reusability has improved, as evidenced by the new `ValidatedDreson` Newtype
- You used the `ValidatedDreson` for both input values, replacing what was previously duplicated code—a clear sign of increased reusability

*Q35*: Do you agree that the Newtype pattern requires more changes during refactoring? If we wanted to use this validated type throughout the entire project, it would involve a high volume of modifications.

*A35*: 
- Yes, absolutely; that is the consequence, but it offers the advantage of immediately highlighting where changes are necessary
- Consider a Customer ID: if you need to adjust it, you want that change reflected everywhere
- You are forced to update all instances and verify the implementation accordingly, which actively prevents errors

*Q36*: How has the analysability changed? Is the code easier or more difficult to read and understand?

*A36*: 
- Readability improves if you trust the individual Newtypes; you can mentally "filter out" the validation logic and focus on the fact that a value is valid, rather than how it became valid
- This allows you to ignore complex helper cases and branching paths during analysis, which is a clear positive
- However, the refactoring introduced more advanced functional programming patterns that could be a barrier
- Specifically, functions like `transpose`, `map_err`, and the use of the underscore operator (`_`) in closures might be confusing for developers less familiar with these idioms
- While the overall structure is better, the reliance on these specific Rust patterns means a developer must be familiar with them to truly understand the function's execution

*Q37*: Has the refactoring made it easier or more difficult to make changes without introducing new errors?

*A37*: 
- It depends on the type of change being made
- Adjusting the `Dreson` (or similar core types) is relatively complex because it is used in multiple places throughout the code, requiring an understanding of all affected areas
- Conversely, other modifications like updating error handling, adding logging, or implementing metrics are now relatively simple to execute

*Q38*: Regarding testability, even if it's not the primary focus of the Newtype pattern, do you think it has improved or deteriorated?

*A38*: 
- It improves because testing is split into two distinct areas: specific tests for the Newtype validation (e.g., `ValidatedDreson`) and separate tests for the actual business functions
- The business function tests become significantly smaller and reduce "mental overload" since they no longer need to handle complex validation logic
- With fewer required mocks and smaller test fixtures, the overall testability is enhanced

*Q39*: In other words, we no longer need to test the "Dreson" logic everywhere it is used, but only where it is actually validated.

*A39*: 
- Exactly.

*Q40*: Apart from that, is there a change in the number of required mocks or the freedom from side effects?

*A40*: 
- There is more freedom from side effects in a sense, because the main handler tests no longer need to guarantee that all input values are correct
- Theoretically, you could even mock the Newtype if necessary, though the impact of that is likely relatively minor

*Q41*: We've reached the final criterion: faultlessness. Has the code's reliability actually improved? Does the refactoring prevent invalid application states or minimize the risk of bugs and incorrect function calls?

*A41*: 
- I don't believe so, for the same reasons mentioned previously
- Rust is already very effective at error detection; the original code used `match` statements to cover all cases that are now handled by the Newtype
- You are still required to perform error handling, such as using `map_err`, so the overall safety hasn't improved significantly

*Q42*: Would you say that other functions using the Newtype benefit from increased safety? Specifically, the fact that a function can now be certain the "Dreson" is validated rather than just dealing with a primitive string?

*A42*: 
- Theoretically, yes; practically, we already assume that inputs are validated and have the correct type
- In this specific use case, we do very little with the "Dreson" itself other than passing it to a client for another system
- At that exit point, it is converted back into a string anyway, and responsibility shifts to the next team
- Therefore, I don't see a major impact in this specific instance, though I can imagine it being beneficial in other use cases

#dotted_line

*Use Case 3 - Status Quo*

*Q43*: Now for the final use case: the Boxfish Return Status REST API Handler. Since this isn't part of your daily development work, what code smells did you notice in the current status quo? Which parts make the code hard to maintain or error-prone, and which criteria are negatively affected?

*A43*: 
- I skimmed it briefly, and the first thing that stands out are the highly complex return types
- For example, you have a `Result` containing an `announced position item request`, which then contains another `Result` with a `Response` in the body
- These nested `Result<Result<...>>` structures make readability difficult; you have to think three times just to understand what is actually happening
- Like in our previous examples, there is too much logic in a single class—the original had around 290 lines of code
- Interestingly, your refactored version grew to over 400 lines, which isn't necessarily an improvement in terms of volume
- I also immediately noticed that the test coverage is not very good

*Q44*: Could you comment on the mutable state regarding API errors and results?

*A44*: 
- You're referring to the API errors and value position items at the top of the handler. Yes, that is quite "unclean"
- We actually have similar patterns in our own code, like in the Kafka Importer, where we handle batch processing
- When you receive 500 events and a few fail, you need a way to track them for retries; using mutable lists passed into functions is one way to handle that
- Personally, I don't find it unreadable because I'm familiar with the pattern and use it myself, but it is a point of contention
- It could be solved differently, perhaps by using global lists or, as you likely did, by using structs to manage the state more effectively

*Q45*: How do you think this affects testability?

*A45*: 
- I don't think the impact is very negative, though it does change the testing process
- You have to pass empty lists into your functions and, at the end, verify more than just the return type
- Because mutable references are passed in, you are forced to check the state of the input objects after the function executes to ensure they were updated correctly
- It is manageable, but whether it is truly intuitive is another question
- If the parameters are well-named, for example `api_errors` or `valid_items`, then I believe it remains understandable for a developer

*Q46*: What do you think regarding the freedom from side effects?

*A46*:
- The code is not truly free from side effects
- Error handling is often a special case that runs alongside the main logic
- The function does not just perform one task but must also manage failures
- One could solve this by using return values for successful and failed items
- Retries could be implemented within the function but the errors still need handling
- This approach is a simple solution even if it is not the most elegant one

*Q47*: Are there any other specific criteria you notice that are particularly affected, such as analyzability?

*A47*:
- Understanding the code took some time initially because it is heavily split up
- The handle function serves as the entry point and makes many calls to other functions
- The functions are well-named, allowing a developer to understand the process by looking only at the handle function
- Detailed analysis is easy by using IDE features to jump into specific functions for deeper tracking
- The code is quite understandable after some initial thought
- While improvements are always possible, the current state has reached an acceptable level

#dotted_line

*Use Case 3 - Refactoring*

*Q48*: Has the functional correctness been affected by the refactoring, or does the code still produce the same results?

*A48*:
- I cannot give a definitive answer because there are no tests for me to run and I am not familiar with the code
- Naively, I would assume it is correct, but I cannot confirm it 100 percent

*Q49*: To what extent has the modularity of the code deteriorated or improved through the refactoring?

*A49*:
- Modularity has improved, similar to the first case discussed today
- The original code had a single handle function that performed every task
- Now the handle function handles initialization while a separate handle request function processes the core logic
- This structure ensures that input parameters are validated and errors are caught before the main processing starts
- The code is much more modular because different handlers could theoretically reuse the handle valid request function

*Q50*: I would argue that using these specific structs as inputs and outputs makes them very tailored to this use case, which might negatively affect reusability.

*A50*:
- I was going to mention that, but reusability was not any better before the refactoring
- The original functions were already very specifically tailored to this single use case
- The refactoring has not made the situation worse than it already was

*Q51*: So regarding reusability, would you say it has neither significantly deteriorated nor improved?

*A51*:
- Yes

*Q52*: Regarding analyzability, since you were not familiar with this code, can you judge if the refactoring made it easier or harder to read and understand?

*A52*:
- This is the main point: you do not have to look at everything anymore
- You can follow only the paths that interest you because you can trust that certain results are returned correctly
- Good naming of functions and types significantly helps in making the logic traceable

*Q53*: How has the cognitive effort required to understand the code changed?

*A53*:
- The effort has increased because the lines of code have grown, which requires more scrolling
- This could be improved by moving logic into different classes or files with descriptive names
- Including tests in those files would also help readability
- Despite the increased volume, it is a step in the right direction

*Q54*: Alright, then let's move on to modifiability. Has the refactoring made it easier or harder to make changes to the code without introducing new bugs?

*A54*:
- I cannot say much because I have never made changes to either the status quo or the new version
- I can imagine that certain changes might actually become more complicated depending on what you want to do
- For instance, adding additional parameters or states is not very simple in this structure
- However, this complexity forces the developer to invest the necessary time rather than just making a quick, potentially messy fix as might happen in the original version

*Q55*: This is probably the same point as with the first use case, the detailview service, where you have to think more carefully about the structures and state transitions, right?

*A55*:
- You really have to give it thought because if you do not, the code quality will suffer
- That risk exists here, but it was exactly the same in the status quo version

*Q56*: So would you say overall that modifiability has slightly deteriorated?

*A56*:
- I would say it has slightly improved
- This assumes the developer is motivated to invest the time and is given the necessary resources for the project to write high-quality code
- Under those conditions, the developer is forced to create a better solution

*Q57*: To what extent has the testability of the code deteriorated or improved through the refactoring?

*A57*:
- Testability has improved because tests can be divided more easily
- Individual tests become smaller with fewer parameters to manage and fewer assertions to verify
- Since the functions now have a single responsibility, you usually only have one value to compare at the end to see if it works
- If these functions and their corresponding tests are well-encapsulated in separate files, it has a very positive effect on testability

*Q58*: How has the number of required mocks and the freedom from side effects changed?

*A58*:
- Smaller tests are created which are hopefully more free of mocks

*Q59*: I forgot one point regarding readability: the refactoring used enums for return types to represent various error states that were previously handled implicitly, such as leaving API errors empty. Do you think this improved readability?

*A59*:
- This is a core feature of Rust enums often used to cover success and error cases
- You also used the Either pattern in some places
- These patterns bring both advantages and disadvantages
- They can make the code harder to read for a new developer who might not understand why an Either type is used
- These specific Rust language features are powerful but require a certain level of experience to be fully understood by team members

*Q60*: To summarize, would you say that the Type State Pattern and the concepts associated with it require more prior experience or familiarity with the pattern?

*A60*:
- Yes, as is often the case with design patterns
- Just like the Builder pattern in Kotlin or Java, you have to understand the general concept first
- I would not say it is overly complicated, but you must know the pattern to apply it
- Learning it does not take long, but it naturally requires more effort than simply writing code sequentially
- However, it brings corresponding advantages to the codebase

*Q61*: Finally, let's look at faultlessness. Has the reliability of the code improved? Does the refactoring prevent invalid application states and has the risk of bugs or incorrect function calls been minimized?

*A61*:
- Reliability has improved because using enums for return types covers specific successful cases
- However, the Fetch Return Status Result enum includes both success and error cases like NotSent and Success
- I believe this could be modeled better, for example by using a Result type where only the success cases are in an enum
- Such a structure would allow the IDE, Clippy, and the compiler to better verify that every case is handled correctly
- If implemented consistently, this approach has a positive impact on faultlessness

*Q62*: Is there anything else you would like to add regarding the refactoring?

*A62*:
- I noticed that in Incoming Requests, a TryFrom implementation was added instead of a manual validate function
- The implementation checks specific conditions, such as whether a list is empty
- This is a good design choice because conversion and validation are often linked
- Implementing standard Rust traits like TryFrom is beneficial because every Rust developer understands their purpose
- This approach provides better IDE support and is more idiomatic than custom validation functions

*Q63*: This could perhaps be described as the "parse don't validate" principle, which we often use. Would you say this principle works well in combination with the Type State Pattern?

*A63*:
- It works well with Type State, but also with other patterns like New Type
- For example, a string that must follow a specific regex format can be validated and converted into a new type simultaneously
- While it is not a requirement for Type State or New Type, it complements both patterns very effectively
- This principle is generally versatile and fits many different architectural approaches

*Q64*: I just remembered one more thing: initially, there was a function that validated the request and had a complex return type consisting of a Result with the validated request and a body response. In the refactored version, the function now returns an enum instead of the response body. I did this to follow the Single Responsibility Principle, so the validation function only returns semantic errors instead of handling HTTP errors. Would you say this improved modularity?

*A64*:
- Not necessarily, as there is usually a reason for using a Result type with an explicit error value
- As mentioned before, I personally do not find it ideal to include error cases within the same enum as success cases
- Error handling is essentially an exception to the Single Responsibility Principle because a function must always be able to handle failures
- In Rust, using a Result is the standard syntax for this instead of throwing exceptions

*Q65*: Alright, thank you for your assessment. I have no further questions. Do you have any general remarks?

*A65*:
- No, but I find some of the changes really good and we should see what we can adopt in the future
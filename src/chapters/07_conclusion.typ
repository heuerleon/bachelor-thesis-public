= Conclusion

This chapter displays the most relevant findings of this study, and discusses their implications and limitations. Possible areas of future research in the field of design patterns in Rust are suggested.

== Summary

// remind the readers where I started (re-state the goal)
// highlighting the "so what" - why is my argument important in the first place
This study identified that for the programming language Rust, there is little empirical evidence on which design patterns are beneficial. Most design patterns known and used in modern software engineering originate in @oop, and their effects have mostly been studied for the language Java. Novel design patterns exist @crichton_typed_2023, but haven't been evaluated in terms of their benefits on code quality. Consequently, this study formulated the goal of identifying design patterns that improve code quality, while making use of Rust's specific language features like its powerful type system.

To address the goal, a case study on three use cases selected from the company OTTO's backend applications has been conducted. Each use case was refactored by applying a selected design pattern. Criteria were selected from the @square quality model, and the refactored code has been evaluated for each criterion using benchmarking, static code analysis and expert interviews. A mixed-method approach was necessary to mitigate the known shortcomings of static code analysis on its own and to capture human-centric quality attributes such as readability and perceived complexity, which can be captured more realistically by qualitative expert interviews.

// Summarize the results of implementation
All patterns were found to have no additional runtime cost. The typestate pattern was found to significantly improve faultlessness and testability, while different perceptions of readability exist, especially regarding the additional boilerplate code, which can cause cognitive overhead. Although the typestate pattern effectively shifts error detection to compile time, the additional boilerplate prevents it from being universally beneficial, especially when the application flow is linear, or when no complex invariants or domain rules exist. The newtype pattern, combined with the principle "Parse, don't validate", was found to introduce minimal downsides and code changes, while offering improvements in almost all quality dimensions. It is broadly applicable and enforces compile-time invariants wherever it is used. Specific implementation recommendations for the patterns have been formulated.

// leave the reader with some final thoughts (final verdict)
This study yields a better understanding of the benefits of the two design patterns typestate and newtype in the context of real-world backend Rust applications. It became evident how the application of patterns alters different aspects of software quality, aiding decisions on future refactorings where similar challenges as in the presented use cases exist. Furthermore, this study developed a reusable methodology for evaluating design patterns' benefits on software quality, which can be used for other languages, design patterns and use cases. Yet, the findings suggest that much knowledge on how to use Rust's unique language design to enhance quality and compile-time correctness remains to be discovered and encoded in novel design patterns.

== Future work

// Empirical scope
In this study, only three use cases and two design patterns have been studied, and future research into other use cases and a broader range of patterns is necessary. Use cases from a variety of domains should be investigated, such as embedded systems or CLI tools, to improve the generalizability of the identified benefits. To decrease the results' subjectivity and bias, future studies should also recruit a high number of participants instead of a handful of experts. Participants with varying backgrounds and experience levels could lead to better insights on how different seniorities and developers unfamiliar with the code view the changes.

// Measurement improvements
Furthermore, the metrics used for evaluation have known limitations. As soon as more human-centric metrics based on correlation with real cognitive effects are available, more rigorous assessments will become possible. DevOps metrics like the Four Key Metrics, often also referred to as DORA metrics, which originated in large-scale empirical studies on software delivery performance @forsgren_accelerate_2018[p.51], could be measured over an extended period of time. This would not only allow researchers to capture more aspects of software quality, but also how it affects developers and a whole team, without having to interview them.

In addition, performance measurements, such as benchmarking, should be executed on hardware with fewer external factors and higher stability. A CPU with a stable clock rate and a system free of other background processes and operating system overhead would decrease the interference with benchmarks. These measures would further enhance the benchmark's validity and reproducibility.

// Conceptual extensions
Another possible direction of future research could be the interaction of business requirements with source code, as with the typestate pattern, it is possible to encode some of the requirements in the type system. Not only the transfer of business requirements to source code, but also the extraction of the currently encoded business requirements in the source code should be investigated, for example through diagrams generated from the encoded state machine, that can be discussed with stakeholders.

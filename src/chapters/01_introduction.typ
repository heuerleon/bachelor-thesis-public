#import "../pages/outline.typ": custom_caption

= Introduction <introduction>

// Rust's guarantees and appeal
The programming language Rust, consistently ranking as "most loved" among developers surveyed in the StackOverflow developer survey @x:noauthor_stack_nodate, brings programming concepts like @adt:pl and functional programming to the mainstream, while offering performance levels comparable to low-level programming languages like C. The unique ownership concept makes it memory safe without the cost of a runtime garbage collector @matsakis_rust_2014. Combining the ownership concept and its strong type system, Rust detects many errors at compile time, such as data races and access to deallocated memory @matsakis_rust_2014, that are often only noticed during runtime when using other languages. Additional features like developer-friendly error messages and the `cargo` toolchain make it a practicable general purpose language.

// Rust's adoption in critical and business systems
Rust's increasing adoption in critical systems that require memory safety and low-level control @pinho_towards_2019, efficient implementation of security and reliability mechanisms @balasubramanian_system_2017, tools and software in academics @perkel_why_2020 and in the Android platform @x:stoep_rust_2021 is evident of its influence on modern-day programming. According to the StackOverflow developer survey, Rust has seen a steady increase in popularity from 3.2\% to 14.8\% since it was first included in the ranking in 2019 @x:noauthor_stack_nodate. The US government has commited to using memory safe languages like Rust as a countermeasure to increasing cyberattacks @x:noauthor_press_2024. For the Android platform, it was reported that by switching to Rust, memory safety vulnerabilities were reduced by 1000x in comparison to C and C++, the rollback rate of code changes was 4x lower and code review took 25% less time @x:stoep_rust_2025.

// Limits of language-level guarantees
While Rust is often mentioned as a low-level systems programming language, it has particularly become a popular choice for developing web applications. According to the 2024 State of Rust Survey, 53.4% of developers use Rust for backend applications @x:noauthor_state_2025, the highest among all categories. At the German online retailer OTTO, developers have begun migrating various services to Rust, with one team running fully on Rust since 2025. Developers are investigating how services can be designed to be more cost-efficient, performant, scalable and fail-safe through compile-time guarantees @x:expert-c, @x:expert-d, and more productive through the `cargo` toolchain .

// Design patterns as a response
Although Rust's language design enforces memory safety and compile-time guarantees through its type system, it doesn't inherently guarantee maintainable software or good architecture. As Rust adoption and code complexity grow, developers need structural guidance and must look beyond pure syntax. A common way to transfer knowledge about software design and architecture are design patterns. Design patterns are an abstraction of solutions to common problems that have already been solved in existing systems, thereby allowing the transfer of this knowledge to new systems @gamma_design_1995[pp. 2-3]. For example, the book by the @gof introduced many design patterns still popular today, like the Builder @gamma_design_1995[p.97] or Factory Method @gamma_design_1995[p.107] pattern. Their patterns have been among the most widely studied.

// Mismatch between GoF patterns and Rust
Most of the design patterns known as of now originate in @oop @gamma_design_1995[p. 4]. However, Baumgartner et al. state that a design pattern can become obsolete when transferred to another programming language, if the problem it solves can already be expressed through an existing language construct in the target language @baumgartner_interaction_1996[p.2]. Some patterns often make up for missing language constructs in certain languages and are called "paradigmatic idioms" @baumgartner_interaction_1996[p.3]. Moreover, a design pattern might not be supported by a language when the language lacks the constructs or features required to implement the pattern.

Rust is a multi-paradigm language and cannot be categorized as strictly object-oriented or functional. According to the official book "The Rust Programming Language", the language incorporates both functional @klabnik_rust_2023[pp. 273-294] and object-oriented features @klabnik_rust_2023[pp. 375-396]. In combination with the restrictions mentioned earlier, and due to many of the well studied design patterns being grounded in @oop, this means that many of them are not directly transferrable to Rust. According to senior software developers interviewed at OTTO, team members often have experience in designing object-oriented applications, but this doesn't directly translate to Rust's language features @x:expert-c, @x:expert-d, creating a need for principles and patterns that make use of Rust's type system and enforce idiomatic language use.

// Resulting research goal and method
Therefore, this thesis will perform a study on selected use cases from teams at OTTO. Three use cases will be analyzed and refactored using well-suited design patterns. The goal is to identify design patterns that improve Rust code quality while leveraging its type system, a field that currently lacks research. To evaluate whether a pattern influences code quality positively, the criteria listed in @criteria-table will be used. Their selection process and evaluation methods will be explained in detail in @method[Chapter]. As a result of this study, a set of recommendations regarding when and how to use the selected design patterns in Rust will be formulated.

#figure(
  {
    show table.cell.where(y: 0): it => strong(delta: 200, it)
    show table.cell: it => if (it.x == 0 and it.y > 0) {
      align(horizon, [C#it.y])
    } else {
      it
    }
    table(
      columns: 2,
      stroke: .5pt + black,
      [ID], [Name],
      [], [Time Behaviour],
      [], [Modularity],
      [], [Reusability],
      [], [Analysability],
      [], [Modifiability],
      [], [Testability],
      [], [Faultlessness],
    )
  },
  caption: custom_caption([Criteria the refactored code needs to meet. These criteria will be referenced throughout the study, and will be used to evaluate the refactored code and the effect of the applied design pattern.],
  [Overview of criteria for the refactored code])
) <criteria-table>

#import "../pages/outline.typ": custom_caption

= Method <method>

In this chapter, the requirements for the refactored code will be derived through a requirement analysis. Then, the methods used for evaluating the refactored code in regards to the requirements will be explained. Quantitative methods will be assigned a threshold, if possible, that indicates whether the criterion is passed or not.

== Requirement analysis

For investigating the benefit design patterns have on Rust in the context of backend applications, this thesis refactored use cases from real-world applications by applying design patterns. According to the definition from Martin Fowler, a refactoring is the modification of existing code that improves its design and internal structure without altering external behaviour @fowler_refactoring_2012. This implies that refactoring is concerned with reaching a certain quality of code design.

To determine whether the design patterns involved in the refactoring are beneficial, quality requirements were derived from the @square model, defined in the ISO/IEC 25010 standard @noauthor_isoiec_2023. The standard defines 9 main criteria and 40 subcriteria, listed in @iso-table in @selected-criteria[Appendix] for reference.


#figure(
  pad(y: .5cm, x: 2cm, image("../res/iso_criteria.png")),
  caption: custom_caption(
    [Selected criteria from the SQuaRE model. For Performance Efficiency and Reliability, only one subcriterion has been selected. Maintainability will be evaluated as a whole, thus all subcriteria were selected. This picture omits other criteria that were not selected.],
    [Overview of selected criteria from the SQuaRE model],
  ),
) <iso-picture>

However, not all criteria are equally relevant or addressed by design patterns. Consequently, relevant criteria were narrowed down to _Time Behaviour_, _Faultlessness_, _Modularity_, _Reusability_, _Analysability_,  _Modifiability_ and _Testability_, which are marked in *bold* in @iso-picture. The definition and reasoning for eliminating or including specific criteria are explained in the following.

- _Functional Suitability_: Whether the software provides functions that fulfill its specified requirements, when used according to specified conditions. Refactorings shouldn't alter this external behaviour @fowler_refactoring_2012. Therefore, evaluating this criterion would not yield meaningful results, as functional requirements stay consistent before and after. Passing the existing unit and integration tests and compiling successfully are preconditions to make sure the code's external behaviour wasn't altered. However, verifying the subcriterion _Functional Correctness_ would require a formal proof of correctness, which is out of scope for this thesis. Overall, the criterion _Functional Suitability_ is excluded.
- _Performance Efficiency_: Whether the software performs within given time and throughput thresholds, and uses hardware resources like CPU and memory efficiently. Design patterns most commonly focus on improving maintainability and readability of code, not its performance. However, it is a critical aspect relevant to business. For instance, if a critical component is refactored and much more readable as a result, but consumes significantly more resources, the refactored version might not be a viable choice for the business. Thereby, performance aspects should be measured to judge whether the design pattern is a viable choice. _Time Behaviour_ can be assessed in the scope of a function and is therefore included in the criteria. _Resource Utilization_, however, is usually measured for the running system as a whole under realistic conditions or load test simulations. In this study, the use cases are a minor part of a bigger system, thus the performance impact is assumed to be minimal, and therefore this subcriterion is excluded. The same argument applies for _Capacity_, which describes whether a system's maximum limits are high enough so that other requirements can be met, and is excluded as well.
- _Compatibility_: Whether a software can communicate with other software appropriately, and run correctly when sharing the same environment and resources. The interface of the refactored software and its running environment are not discussed in this thesis, because a refactoring, as defined previously, doesn't alter external behaviour. Thereby, this criterion is excluded.
- _Interaction Capability_: Whether intended users of the software are able to exchange information with the user interface and complete specific tasks. Because this criterion focuses on the user interface, while this study only refactored source code of backend applications, this criterion is excluded.
- _Reliability_: Describes the ability of software to run as intended under the specified conditions for a specific period of time. The assessment of software's maintainability and readability will only be from a source code and developer perspective, and runtime behaviour will not be analyzed. Moreover, it is out of scope of this thesis to assess _Reliability_ under realistic conditions for an extended period of time due to time and resource constraints. However, specific design patterns can improve reliability of the code by eliminating the possibility of invalid states, as in Crichton's State Machine and Witness patterns @crichton_typed_2023. Thus, _Faultlessness_ can be judged through logical reasoning about the states possible in an application, and is included in the criteria.
- _Security_: The ability of software to be accessible to intended users within their authorization level, while protecting itself and its data against attacks by malicious actors. Whereas design patterns that focus specifically on security aspects exist, for instance the Proxy pattern @gamma_design_1995[p.207], those patterns will not be part of this study, and thereby the criterion _Security_ is excluded.
- _Maintainability_: How effectively and efficiently software can be modified, corrected or adapted to new requirements and environments. This criterion is the main aspect of code quality that design patterns and refactorings address, as it is related to how developers perceive and interact with the code. All subcriteria are included for evaluation.
- _Flexibility_: How adaptable software is to changes in external requirements and system environment. This criterion focuses on the interaction between the software and the hardware, like efficient scaling, adaptability to new hardware and how easy it is to install the software. As these are mostly runtime factors or factors that lie outside of the source code itself, and are not affected by design patterns, _Flexibility_ is excluded.
- _Safety_: Describes whether the software avoids states that can be dangerous for human life, health or the environment. The chosen use cases will be parts of an online application that has no real-world criticality. Moreover, this is an aspect of software's behaviour during execution as well, and therefore _Safety_ is excluded.

== Time behaviour <method-time-behaviour>

The first criterion time behaviour identified in the requirement analysis will be evaluated by measuring execution time. As only selected parts of applications will be modified, the most straightforward way of measuring time behaviour is therefore measuring time on a function level. For this measurement, benchmarks will be created using the microbenchmarking tool "criterion-rs", available on GitHub @x:noauthor_criterion-rscriterionrs_2026. This way, the refactored functions can be tested in an isolated manner by running the entry function, and small deviations in execution time can be identified. Concrete test setup, hardware specifications and configuration will be explained in detail in @results[Chapter]. The tool automatically performs the benchmark through a warmup phase, followed by a measurement phase where multiple samples are taken. For each subsequent sample, the amount of iterations is incremented by the sample size configured. Criterion then classifies outliers and reports them. This is followed by a linear regression and the calculation of statistical estimates and confidence intervals through a resampling process. Finally, the outcomes are then compared by performing another resampling and T-test.

For passing the criterion time behaviour, the code must be *within Criterion's noise threshold*, which is $plus.minus 2%$ by default @x:noauthor_command-line_nodate. A benchmarking result that is statistically significant but within the noise threshold cannot be used as interpretation for either an improvement or degradation, as other background processes, CPU scheduling or other external effects of the system environment can cause irregularities.

== Source code metrics <metrics_chapter>

Static code analysis tools enable data-driven assessment and automated quality evaluations on a source code level by analyzing the code without executing it. That way, reliability and maintainability can be estimated based on structural and complexity metrics without needing to collect operational data @fenton_software_2014[p.20]. Those metrics enable the creation of rules and thresholds that indicate when the code doesn't meet certain quality standards. In the following, appropriate metrics will be chosen and mapped to the criteria in @criteria-table.

/*=== measuring quality
A systematic literature review from 2014 conducted research on the correlation between object oriented measures and quality @jabangwe_empirical_2015. The study found out that "measures for complexity, cohesion, coupling and size" correlate with reliability and maintainability. On the other hand, "measures that quantify inheritance properties" show poor correlation with reliability and maintainability. However, it focuses only on object oriented measures.*/

// qmood
/*There are several studies that use the QMOOD model for evaluating object oriented software with a given set of metrics. QMOOD was first introduced in 2002 and evaluates high-level quality attributes such as reusability and flexibility by assessing properties of the code, such as coupling, cohesion and encapsulation @bansiya_hierarchical_2002. The relationships between the code properties and quality attributes have weights, indicating their impact on each attribute.*/

//@hsueh_quantitative_2008 evaluates @gof design patterns

=== Lines of code

@loc describes the count of lines in a specific scope, such as a function or source code file. Even though it is a trivial metric, it is still widely used due to its ease and understandability. Alpernas et al. found that while paper authors often try to back qualitative claims about source code with empirical data, @loc is no better support for those claims @alpernas_wonderful_2020. It has limited expressiveness and is often used simply to adhere to the standard of measuring @loc. Although there are cases where @loc can be a meaningful metric, the aim of design patterns is not to write shorter, but more maintainable code. Moreover, two interviewed experts stated that they don't consider @loc a particularly good metric @x:expert-a, @x:expert-c. Especially in Rust, more code often means more explicit types and data structures, which is not seen as problematic, while other features such as a large number of conditional branches are seen as more impactful @x:expert-c. Therefore, this study will not measure @loc.

=== Cyclomatic complexity

@cyc was introduced to identify modules that will be difficult to test or maintain and is one of the most widely used source code metrics @mccabe_complexity_1976. It is a single numeric value based on the cyclomatic number of the @cfg of the program. In a strongly connected graph, achieved by connecting the exit node back to the entry node, it can be calculated as:

$ v(G) = e - n + 2p $

where $G$ is the graph, $n$ the number of nodes, $e$ the number of edges, and $p$ the number of connected components. It represents the maximum number of linearly independent paths in the graph, indicating how many test cases might be necessary to test the module under observation. In practice, when a single component like a function is assessed, @cyc can be simplified to:

$ v(G) = pi + 1 $

where $pi$ is the number of conditions in a program, for example `if`, `while` and the cases of a `switch` statement.

The metric is often used for measuring source code complexity. However, a limit of @cyc is that it focuses only on control flow and not on other aspects of complexity, such as data flow or depth of nesting. The theoretical model of the metric makes it unsuitable for the general measurement of complexity, according to Fenton and Bieman @fenton_software_2014[p.392]. Still, they state that it is a useful metric for identifying how difficult a program or module will be to test and maintain, following McCabe's original statement that his metric closely relates to the amount of work necessary for testing a program @mccabe_complexity_1976. According to McCabe, if the amount of tests is less than the cyclomatic number, there are either tests missing, or the program can be reduced in complexity. As an upper limit based on empirical evidence, he suggested the number *10*, which will be used in this study to assess the criterion *C6 Testability*.

=== Cognitive complexity
@coc is a metric developed at Sonar, a company that builds software for code quality and security. The metric was first introduced in a conference paper by Campbell @campbell_cognitive_2018, who selected open source projects and evaluated whether their maintainers accept the metric. The overall acceptance rate of @coc was 77\%, forming the basis of the metric's validity. The metric was created to address the shortcomings of @cyc in predicting the mental effort required to understand a program, and is limited to the control flow as well. However, it is based on qualitative argumentation and a set of rules for specific language structures rather than a mathematical model. According to the official @coc white paper from Sonar @x:campbell_cognitive_2023, it is calculated as follows:

+ _Control flow_: Expressions that change control flow of a program increase the number by 1, with some additional rules. This includes:
  - Conditional statements, including `if`-conditions and ternary operators
  - Loop structures, including `for` and `while`
  - `catch` clauses, but any `try` or `finally` clauses are ignored
  - Simple `switch` conditions that match primitive data like integers, booleans and strings cause a single increase, but no additional increase for the cases
  - Each sequence with the same logical operator in a predicate (for example a sequence with a logical `AND`, then with a logical `OR` and then with an `AND` again has $"CoCo = 3"$)
  - Recursion
  - Jumps, such as `goto`, and `break` or `continue` statements to a specific label
+ _Nesting_: When an expression falls under the category _Control flow_ and thus already incremented the number, the current level of nesting is added to it. There are structures such as lambdas that increase the level of nesting, but don't cause any increment on their own.
+ _Ignore shorthands_: There is no increase for shorthands, which are language features or constructs that express the original semantic meaning in a shorter form. For instance, extracting code to another method and invoking it, or using the null-coalescing operator (like `?` in Kotlin) instead of a null-check using an `if`-condition, doesn't increase the @coc number.

In summary, the main difference from @cyc is the consideration of nesting levels, recursion and special rules when to ignore control flow structures. Due to its presence in the static code analysis tool Sonarqube and novelty in comparison to the other measures, it will be used for evaluation of *C4 Analysability*. While Campbell doesn't define a specific threshold in the current white paper for @coc @x:campbell_cognitive_2023, they answered in a post on StackOverflow that the value *15* is the recommended maximum for single functions @x:campbell_answer_2017.

However, the metric should be evaluated with caution, as there are exceptions for certain programming languages listed in the @coc white paper @x:campbell_cognitive_2023. An email correspondence with Campbell, the author of the white paper and community manager at Sonar, shows that Rust hasn't been assessed yet in terms of caveats when measuring @coc. The email conversation can be found in @email_campbell[Appendix].

=== Halstead's measures

Halstead was the first to propose software metrics based on a mathematical model in his book _Software Science_ @halstead_elements_1977. The model is based on the following fundamental measures, which can be derived directly from the source code:

- $eta_1$: Number of unique operators
- $eta_2$: Number of unique operands
- $eta = eta_1 + eta_2$: Vocabulary of the program
- $N_1$: Total number of operators
- $N_2$: Total number of operands
- $N = N_1 + N_2$: Length of the program

On the basis of these measures, Halstead invented multiple composite metrics that can be used to judge certain aspects of the program, such as _Program Volume_, _Effort_ and _Difficulty_. The latter is defined as the inverse of Halstead's _Program Level_ metric @abran_software_2010[p.157-158]:

$ D = frac(eta_1, 2) times frac(N_2, eta_2) $

@hdiff is proportional to the number of unique operators and usage of operands and represents the ease of reading. Therefore, it can be mapped to the criterion *C4 Analysability*. Despite being one of the earliest mathematical source code metrics and receiving criticism for being based on a poor cognitive model @curtis_psychological_1984, a recent study found Halstead's Effort and Difficulty to have higher correlations with cognitive load than @cyc and @coc @hao_complementarity_2026, making it a relevant complementary metric. However, there is no normative prescription on what the size of @hdiff means in practice, or how high or low it should be. It is unclear whether Halstead's metrics are measurement or prediction systems, and what the relationship between the mathematical model and real-world consequences is @fenton_software_2014[p.345]. Therefore, @hdiff will only be analyzed in terms of relative difference in this study.

=== Maintainability index

The initially proposed polynomial regression formula to calculate the @mi is based on four metrics and was created in 1994 @oman_construction_1994. It is based on an earlier study that identified the smallest set of metrics useful for predicting software maintainability @oman_metrics_1992. In their paper from 1994, Oman and Hagemeister create different regression models from a minimal set of metrics that can be easily calculated, based on test data from software systems at Hewlett-Peckard @oman_construction_1994. For evaluation, they correlate the models' results with the subjective assessment of maintainability found through surveying software engineers. Although more complex polynomials involving more metrics were found to be more accurate, they kept the final proposal simple in order to make it "quick, easy and reasonably accurate" for engineers to measure @oman_construction_1994. The model that was found most suitable was then refined and automatically assessed by Coleman et al. for 11 industrial software systems @coleman_using_1994. According to them, the resulting data corresponds to the engineers' subjective assessment of the components. The following formula was used:

$
  "MI" = 171 - 5.2 times ln("aveVol") - 0.23 times "ave" V(g') - 16.2 times ln("aveLOC") \
  + (50 times sin(sqrt(2.46 times "perCM")))
$

where $"aveVol"$ is the average Halstead Volume, $"ave" V(g')$ the average cyclomatic complexity, $"aveLOC"$ the average lines of code and $"perCM"$ the percentage of comments. The average is calculated within the scope that is analyzed, for example a function, a class or a whole program. Furthermore, the article proposes thresholds that indicate when a software is:

- _highly maintainable_: $"MI" >= 85$
- _moderately maintainable_: $65 < "MI" < 85$
- _difficult to maintain_: $"MI" <= "65"$

It was later identified that measuring comments in code is inaccurate, resulting in an updated model @welker_development_1997. Comments can contain commented out code, standard headers or other content that has no additional use, and therefore should only be measured if adequate for the use case. The following @mi formula doesn't assess comments, and will be used for evaluation in this study:

$ "MI" = 171 - 5.2 times ln("aveVol") - 0.23 times "ave" V(g') - 16.2 times ln("aveLOC") $

Despite early studies verifying the correlation of the @mi with actual maintainability @coleman_using_1994, it should be questioned whether it is still a relevant indicator for maintainability. The programming languages used today have changed and software engineering practices have evolved since the introduction of @mi. A more recent case study found that it is not a good predictor for maintainability and that simple size metrics had a higher correlation with maintainability @sjoberg_questioning_2012. Another study that evaluated @mi from an object-oriented perspective found a correlation of @mi, but only due to its size component @counsell_re-visiting_2015. Therefore, @mi will be applied only as a supporting metric for claims of qualitative analysis.

Due to its name, @mi might intuitively need to be mapped to the main criterion Maintainability from the @square model. However, because Maintainability is a main criterion, and main criteria are made up of various subcriteria, @mi should be mapped to a subcriterion instead. The creators of the @mi metric @welker_development_1997 based it on the definition of maintainability from the IEEE Standard Computer Dictionary, which defines it as "The ease with which a software system or component can be modified to correct faults, improve performance or other attributes, or adapt to a changed environment" @noauthor_ieee_1991. Therefore, @mi will be mapped to the criterion *C5 Modifiability*, which has a similar definition: "capability of a product to be effectively and efficiently modified without introducing defects or degrading existing product quality" @noauthor_isoiec_2023.

=== Limits of static code metrics <metric_limits>

// understandability / comprehension
Metrics that quantify code understandability and comprehension, such as @coc and Halstead's Difficulty, are insufficient in some regards according to numerous studies. For example, a systematic review from 2009 showed that there is not enough evidence on whether the available prediction models and metrics are effective @riaz_systematic_2009. A more recent study from 2023 concludes that it is not possible to predict code's understandability based on these metrics only @lavazza_empirical_2023. While all metrics correlate with understandability, their prediction error was at around 30\%, making them unreliable. Particularly, the @coc metric, which was introduced to mitigate some of @cyc's shortcomings @campbell_cognitive_2018, wasn't found to outperform metrics established earlier @lavazza_empirical_2023-1. Supporting this, an earlier study from 2020 found that @coc correlates with comprehension time and subjective understandability, but less with comprehension correctness and physiological measures @munoz_baron_empirical_2020.

// brain activity / cognitive load
Additionally, there are studies that measure brain activity in participants during code comprehension tasks. Peitek et al. found that @cyc shows no correlation with an increased demand in any brain area, while @loc and Halstead show a medium correlation with cognitive load @peitek_program_2021. The @coc metric only shows a small improvement over @cyc, supporting the claims of other studies mentioned in the former paragraph. While some metrics were found to be suitable to predict cognitive load in specific areas of the brain, none of them predict overall cognitive effort @peitek_program_2021. Another study that also measured brain activity yielded similar results @hao_accuracy_2023. For example, the study's results indicate that understanding complex algorithms requires higher mental effort, even though they consist of simple code constructs, which kept classical metrics low in the experiment. The authors further observed that participants' perceived complexity saturates at a certain point, which is not reflected in the metrics. Nested structures, which are captured by some metrics such as @coc, were not found to strictly make comprehension more difficult.

Additionally, a recent study found that structural metrics like @cyc and @coc alone fail at measuring complexity @hao_complementarity_2026. The authors suggest to combine structural metrics with metrics that quantify data flow, such as Halstead's Difficulty and Effort. The authors moreover propose to create composite metrics based on a combination of metrics that assess control flow, data complexity and cognitive factors. Further supporting evidence for this recommendation can be found in a study from Scalabrino et al., who found models that combine multiple metrics to correlate slightly higher with code understandability @scalabrino_automatically_2021. They were however reported far from being usable in practice.

To conclude, evidence suggests that there is a lack of reliable methods for quantifying code comprehension. Therefore Crichton, the author of the conference paper "Typed Design Patterns for the Functional Era" @crichton_typed_2023, has been asked via email. The questions and answers can be found in @email_crichton[Appendix] in full length. According to Crichton, there are currently no good ways of measuring code understandability, and suggests it is best to conduct a qualitative analysis through case studies. He further states in a blog post, that quantitative criteria are easy to measure, but often create the "illusion of rigor" and don't have much value for evaluating actual code understandability @x:crichton_evaluating_2024.

== Qualitative analysis

Due to the limits of static code analysis alone that were explained in @metric_limits[Chapter], this thesis will employ a mixed-method approach to supplement the quantitative with a qualitative evaluation. For the latter, expert interviews will be used to cover the criteria C2 - C7. A _semi-structured_ interview as defined by Wohlin et al. will be conducted @wohlin_experimentation_2024, which features concrete questions for evaluation, but allows room for open questions, follow up questions or discussion. As a result, the expert's opinions can be captured holistically while retrieving the relevant data for evaluation.

The guideline that will be used for expert interviews can be found in @expert_questions[Appendix], and was structured into the following sections:

+ *Introduction*: In this section, the background of the interviewee and their personal opinion about development in Rust will be determined.
+ *Current problems in the code*: This section has the goal of identifying general patterns and examples of poorly maintainable Rust code and finding out difficulties junior developers might have in understanding the code. Furthermore, this section identifies the interviewee's opinion on code metrics like the ones mentioned in @metrics_chapter[Chapter], and whether they find them useful for quantifying problematic code. At the same time, the criteria used later for assessment will be introduced to the interviewee.
+ *Status quo*: The purpose of this section is to determine what interviewees dislike about the use case's former code and which criteria are affected negatively by that. The status quo will be evaluated for each use case.
+ *Refactoring*: In this section, each criterion and the refactored code's impact on them will be discussed. This will be the basis for evaluating the success of each refactoring and design pattern later. Similar to evaluating the status quo, the impact will be discussed for each use case.

Four Rust developers that currently work at OTTO will be chosen and must meet the following criteria:
- At least six years of software development experience
- At least two years of experience with Rust
- Implementation language used at their team is mainly Rust

Each interviewee will be given at least one day of preparation. They are allowed to take notes prior to the interview. Interviews will be conducted in 90-minute meetings, one-on-one. The interviewer and interviewee might ask additional questions or discuss further topics than the ones mentioned in the interview guideline, adhering to the semi-structured interview type. For capturing the interviewees' opinions unfiltered, all interviews will be conducted in their native language German. All questions asked and a summary of the corresponding answers will be attached in English in @expert_summaries[Appendix]. The summary will be double-checked by the interviewee to confirm its correctness. An audio recording of each interview will be attached for reference.

== Method overview

Following the quantitative and qualitative evaluation methods developed in the previous chapters, @criteria-table-final gives an overview of each criterion and the corresponding evaluation methods that will be used. Each criterion has been assigned at least one evaluation method. C2-C7 will be evaluated through expert interviews, and some of them through the additional quantitative metrics identified.

#figure(
  {
    show table.cell.where(y: 0): it => strong(delta: 200, it)
    show table.cell: it => if (it.x == 0 and it.y > 0) {
      align(horizon, [C#it.y])
    } else {
      it
    }
    table(
      columns: 3,
      stroke: .5pt + black,
      align: horizon,
      [ID], [Name], [Method(s)],
      [], [Time Behaviour], [Benchmarking:\ Time diff $<= plus.minus 2%$],
      [], [Modularity], [Expert Interview],
      [], [Reusability], [Expert Interview],
      [], [Analysability], [Expert Interview\ @coc $<= 15$\ @hdiff (relative)],
      [], [Modifiability], [Expert Interview\ @mi $>= 85$],
      [], [Testability], [Expert Interview\ @cyc $<= 10$],
      [], [Faultlessness], [Expert Interview],
    )
  },
  caption: custom_caption(
    [Criteria selected through the requirement analysis. Each row lists a criterion, its ID and corresponding method(s).],
    [Selected criteria with assigned methods],
  ),
) <criteria-table-final>

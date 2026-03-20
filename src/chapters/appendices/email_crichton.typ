#import "../../components/formatting.typ": email

#email(
  datetime(year: 2025, month: 11, day: 21, hour: 18, minute: 5, second: 0),
  "Questions Regarding Your \"Typed Design Patterns for the Functional Era\" Paper",
  "Leon Heuer",
  "Will Crichton",
  [
    Dear Will Crichton,

    I am a computer science student from the German university Nordakademie, currently working on my bachelor's thesis on the benefits of applying software design patterns to backend Rust applications. My thesis is being supervised by professor Jan Haase and advised by my company supervisor Falk Woldmann.

    Your workshop paper Typed Design Patterns for the Functional Era inspired us to explore how design patterns could improve our Rust codebase. We work at OTTO, a major German online retailer with 12.2 million active customers. In our department, we develop part of the online shop's backend in Rust and optimize it for low cost and latency. For our business domain, Rust is still a niche choice compared to Java, or Node or Python. But we believe that due to Rust's rapid adoption, good software engineering practices must be established early on.

    As you already pointed out in your paper, there is a lack of design patterns for functional programming. As far as I know, there is also a lack of research specifically on design patterns for Rust. In my thesis, I apply design patterns to selected examples from our Rust code and assess their impact on code quality. There are two questions that I would like to ask you as an expert in functional design patterns:

    + We started using the FC-IS ("Functional Core, Imperative Shell") approach and found improvements in readability and testability of the code, among others. I plan to verify the observed benefits in my bachelor's thesis. Is FC-IS a design pattern in the traditional sense, or would you consider it an architecture approach? Furthermore, I didn't find any literature on FC-IS yet. Do you know of any prior work that discusses it, maybe under a different name?
    + For assessing the benefits of design patterns in my thesis, I would prefer to use quantitative code quality metrics. But when asking experienced developers in our department about this, almost none knew any beyond Cyclomatic Complexity. While measures like the Maintainability Index or Halstead measures exist, developers don't seem convinced by them. Are there quantitative metrics you consider meaningful and commonly used for evaluating the impact of design patterns?

    We would greatly appreciate your opinion on these questions.

    Kind regards,
    Leon Heuer
  ]
)

#email(
  last: true,
  datetime(year: 2025, month: 11, day: 21, hour: 23, minute: 52, second: 0),
  "Re: Questions Regarding Your \"Typed Design Patterns for the Functional Era\" Paper",
  "Will Crichton",
  "Leon Heuer",
  [
    Hi Leon et al., thanks for reaching out, I'm glad you found inspiration in the paper. To your questions:

    > Is FC-IS a design pattern in the traditional sense, or would you consider it an architecture approach? 

    I don't think there's an authoritative distinction between patterns and architectures, but I'll give you my personal views. The difference between patterns and architectures is principally a matter of scale. Both are about describing patterns of computation that can't be neatly encapsulated into a particular reusable code component or library. Patterns are about a smaller scale, like on the type of code in the GoF book or my FUNARCH paper. Architectures are about a larger scale, such the "virtual DOM architecture for reactive web apps" or "single-page-application architecture for full-stack web apps". From this perspective, FC-IS is more of an architecture since it tends to be an orienting principle for an entire codebase. Another great example of FC-IS is the Codemirror 6 API design [1].

    > Do you know of any prior work that discusses it, maybe under a different name?

    I don't know of any academic work on FC-IS. I think it's primarily circulated in industry circles since Gary Bernhardt first put a name to it.

    > Are there quantitative metrics you consider meaningful and commonly used for evaluating the impact of design patterns?

    Sadly, I would also agree that we lack good metrics for evaluating design patterns. Halsteads / cyclomatic / etc. are not much better than just measuring lines of code [2]. I even wrote about this on the SIGPLAN blog [3]. For example, if you use a pattern to make your code more extensible (e.g. a visitor), how do you measure extensibility? If you use a pattern to make your code more correct (e.g. the typed design patterns in my paper), how do you measure bugginess?

    The lack of good metrics is a serious problem in our community, one I hope to address in due time through my research. But for now, I don't have much useful advice beyond "don't leave too heavily on metrics". I would focus on qualitative analysis through case studies.

    [1] https://codemirror.net/docs/guide/\
    [2] https://ieeexplore.ieee.org/document/9402005\
    [3] https://blog.sigplan.org/2024/11/21/evaluating-human-factors-beyond-lines-of-code/
  ]
)
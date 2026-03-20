#import "../../components/formatting.typ": email

#email(
  datetime(year: 2025, month: 11, day: 25, hour: 13, minute: 45, second: 0),
  "Questions regarding your white paper on Cognitive Complexity",
  "Leon Heuer",
  "G. Ann Campbell",
  [
    Dear Ann Campbell,

    I am a computer science student from the German university Nordakademie, currently working on my bachelor's thesis on the benefits of applying software design patterns to backend Rust applications. My thesis is being supervised by professor Jan Haase and advised by my company supervisor Falk Woldmann.

    During my research on measurements for code quality, I came across the Cognitive Complexity measure from Sonar defined in your white paper [1]. I believe it is an interesting measure to complement other mathematical quality models, since it was derived from practical experience and is based on assumptions on which code structures increase perceived complexity for developers.

    In the white paper, you listed a few exceptions for language specific differences. Do you consider CC applicable for Rust code without further exceptions? There are static code analysis tools that can calculate Cognitive Complexity for Rust [2]. However, Rust comes with a few language structures that can make code easier or harder to understand, such as Algebraic Data Types, newtypes, and the Ownership concept. Have you already taken these language specifics into account in the current version of your white paper?

    We would appreciate hearing back from you on this question.

    Kind regards,\
    Leon Heuer

    [1] https://www.sonarsource.com/resources/cognitive-complexity/\
    [2] https://mozilla.github.io/rust-code-analysis/metrics.html
  ]
)

#email(
  datetime(year: 2025, month: 11, day: 25, hour: 18, minute: 05, second: 0),
  "Re: Questions regarding your white paper on Cognitive Complexity",
  "G. Ann Campbell",
  "Leon Heuer",
  [
    Hi,

    I'm not familiar enough with Rust to give you a definitive answer, only the principles of one. Are these language-specific structures related to control flow? Based on the names, I would guess not, and thus say the answer is likely 'no.'

    In formulating Cognitive Complexity we made a conscious decision to look only at control flow. Why? Every language has "hard" features. Some people thought Java generics were hard. People new to C think pointer indirection is hard, but seasoned C programmers are well used to one level of pointer indirection, and two is still routine. So then when does it get "hard"? At 3 levels of indirection? 4? When you're pointing to a function? At that point, you're reduced to arguing personal opinion, rather than measuring. So we simply don't in Cognitive Complexity. 

    Does that help? Do you have any other questions?

    Ann
  ]
)

#email(
  datetime(year: 2025, month: 11, day: 25, hour: 23, minute: 34, second: 0),
  "Re: Questions regarding your white paper on Cognitive Complexity",
  "Leon Heuer",
  "G. Ann Campbell",
  [
    Dear Ann,

    thanks for your response. The language-specific structures I listed are indeed not directly related to control flow. Right now, I can think of two other additional language features that affect control flow:

    + The "?" operator, which propagates an error to the caller of a function [1]. The closest equivalent in Java, for instance, would be adding a "throws" to the method signature for a checked exception that is not handled by a try/catch statement. Rust has neither try/catch, nor exceptions and relies on a wrapper type for returning and handling errors [2]. But in analogue to how your white paper argues that a return doesn't increase complexity, one could argue that a "?" operator makes the program easier as well, even though being a possible exit point of a function. How would you argue in this situation?
    + Rust has "match" statements that are essentially a switch with more abilities like pattern matching and match guards [3]. Pattern matching supports tuples as well. For example, one could match on a tuple consisting of three booleans, where the cases cover different combinations of true and false values. Clearly, the statement "a switch - which compares a single variable to an explicitly named set of literal values" from the CC white paper is not true for Rust. How would you calculate complexity for Rust's match statements?

    I am curious to hear your stance on these language specifics.

    Kind regards,\
    Leon

    [1] https://doc.rust-lang.org/book/ch09-02-recoverable-errors-with-result.html#a-shortcut-for-propagating-errors-the--operator\
    [2] https://doc.rust-lang.org/book/ch09-00-error-handling.html\
    [3] https://doc.rust-lang.org/reference/expressions/match-expr.html
  ]
)

#email(
  last: true,
  datetime(year: 2025, month: 12, day: 1, hour: 14, minute: 14, second: 0),
  "Re: Questions regarding your white paper on Cognitive Complexity",
  "G. Ann Campbell",
  "Leon Heuer",
  [
    Hi,

    Regarding `?`, if you look at it as an early return-analog, then I would certainly argue to ignore it. 

    Regarding `match` and other enhanced `switch` statements... I've kinda been waiting for someone to ask me that ever since `switch`es started getting more sophisticated. You're right that the expanded capabilities of modern `switch`es and `match` don't correlate to the "single variable to an explicitly named set of literal values" premise, and thus I think they should probably be treated as `if`-trees.

    Ann
  ]
)
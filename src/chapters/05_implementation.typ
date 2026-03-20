#import "../components/code.typ": code_snippet
#import "../pages/outline.typ": custom_caption

= Implementation <implementation>

This section will explain how the proposed solutions from @casestudy[Chapter] have been realized in the code. Design decisions made in the refactoring process will be justified, and any tradeoffs or drawbacks will be documented. Selected code snippets will be used to point out some of these aspects. The refactored code can be found in @refactored-digi[Appendix] in full length.

== Use case 1

// High level overview of the changes
The logical steps from the status quo code, like getting benefits, filtering valid benefits, determining the Detailview benefit and checking the UP membership were extracted into separate state transitions. Each activity documented in the @bpmn model in @bpmn1 was encoded as state transition. Each transition results in a new struct, for example `DetailviewDetermined`, which then defines the next allowed operation, like `check_for_up_contracts`. This way, the logical order is enforced, so that it becomes impossible to swap operations like checking the UP membership and determining the activation status, or to leave out the activation of auto-activate benefits, for instance.

// How the pattern was applied
#figure(
  code_snippet("../res/usecase1/new/start_state.rs", "Rust"),
  caption: custom_caption([First function that marks the entry point of the state machine. The function returns the first state of the state machine, which is a struct on which the next state transition is defined.],
  [Use Case 1 - First function that starts the state machine]),
  kind: raw
) <code-start>

// concept mapping to code
As the state machine needs an entry point, the `get_benefit_ids` function shown in @code-start is taken to return the first state `BenefitIdsFetched`. The resulting state contains immutable data, and the external dependency `variation_service` is passed into the function once, but not carried over to the next state. This clearly separates dependencies for each step and indicates which data is needed for the next step, as seen in ll.7-11 in @code-start. The next state transition `get_valid_benefits` is then implemented on the struct `BenefitIdsFetched` and consumes `self` in l.13, which means that the old data cannot be used again, and the developer is forced to operate on the new resulting struct `ValidBenefitsFiltered`.

// tradeoff / drawback
One drawback is that simple steps require a disproportionately high amount of boilerplate, as show in @code-start. The original operation is only three lines long (ll.2-4), but now requires 11 lines due to the function signature and the new struct. However, for more complex processing steps, the amount of additional lines becomes marginal in relation to the logic itself, and the definition of the structs is purely declarative, which could possibly reduce the mental effort for understanding them.

#figure(
  code_snippet("../res/usecase1/new/example_state.rs", "Rust"),
  caption: custom_caption([An example state transition that not only returns the next state, but also a handle on the asynchronous background task as well. This shows how state transitions can produce outputs besides the next state itself.],
  [Use Case 1 - State transition that returns a handle for background task]),
  kind: raw
) <code-upmember>

// implementation choice
@code-upmember shows a design choice that was made when applying the typestate pattern. The transition produces a `JoinHandle`, which encapsulates the eventual result of a background operation. In the status quo code, this allows the application to maintain non-blocking execution, performing other tasks while running the database access for the UP membership in the background. An `await` can be called on the `JoinHandle` later to retrieve the result, and wait longer in case the task is still running. This state transition doesn't produce new data directly, but it is a type-level guarantee that the background task has been started, and the following states can safely assume that the `JoinHandle` exists without knowing about it. A later state transition that requires the result of the `JoinHandle` can then require it as function argument.

// tradeoff
All data required for constructing the `DetailviewViewModel` at the end is accumulated in the structs representing the states. On one side, each struct grows larger and more boilerplate code is needed for structs and function signatures. On the other side, no temporary variables for each transition's produced data are necessary at the invocation point, which makes invoking the state machine less complex.

// drawback
The function `get_valid_benefits` couldn't be fully integrated into the state machine because it's used by another handler that has different states. While handlers generally shouldn't depend on other handlers, and the function should best be extracted into another common module, this also indicates a potential limit of the pattern. State transitions in the typestate pattern are tightly tied to their states, so reusing them in other state machines becomes difficult. As a result, some domain logic must remain outside of the state machine and be invoked from within state transitions, which preserves type safety, but limits full integration of shared functionality.

// tradeoff
Changing the order of states or introducing a new state requires refactoring previous and subsequent states, as the data passed between consecutive states has to remain compatible. The consequences of this will be evaluated in @results[Chapter].

== Use case 2

// High level overview of the changes
Except for the Dreson validation logic, the code remains mostly unmodified. As the changes focus solely on the newtype pattern, the newtype `ValidatedDreson` has been created and used in the beginning of the handler method. The two displayed validation activities in the @bpmn model in @bpmn2, including their surrounding `XOR`-gates, have been replaced by the newtype.

#figure(
  code_snippet("../res/usecase2/new/newtype.rs", "Rust"),
  caption: custom_caption([Newtype introduced for the data type Dreson. The newtype directly validates the input and constructing the newtype will fail if validation fails.],
  [Use Case 2 - Dreson newtype with from_string method]),
  kind: raw
) <code-newtype>

// How the pattern was applied
The first line of @code-newtype shows the newtype `ValidatedDreson`, which wraps a string and provides the `from_string` method in the implementation block in l.4, which allows constructing the newtype from a raw string, and accepts a list of exceptions as a second parameter. It was necessary to allow certain exceptions, as some consumers of the endpoint use special `Dreson` values for testing purposes. However, the need for these exceptions could also be eliminated in the future if consumers use formally valid values. Every string in the `exceptions` list will be treated as always-pass. Because the newtype exists within a separate `mod` (Rust module) and is not made public, the struct can only be created through the `from_string` method, making it impossible to otherwise construct a `ValidatedDreson`.

// drawback / implementation choice
An alternative to allowing exceptions through an additional parameter in the current `from_string` method would be implementing the `TryFrom` trait. Through implementing the `TryFrom` trait, the code could potentially become slightly more idiomatic and practical. Since the trait doesn't allow a second input parameter, a static vector for the exceptions could be defined, for instance. On the other hand, this could be less reusable in case more exceptions are added later, which is why the `TryFrom` variant was not chosen.

// design choice
For compatibility with subsequent processing steps, the wrapped string can be accessed through the `inner` method. This allows other dependencies or libraries that don't accept the `ValidatedDreson` newtype to be provided with the original string. However, the type safety gained through the newtype pattern will be lost once operating on the inner string. Another possible way to achieve this is by adding the derive macro `#[derive(Deref)]` to the newtype, which instructs the compiler to automatically deconstruct the type when a string is needed. However, compilation won't fail when the newtype is passed into a function that accepts the wrapped type, thereby places that require refactoring might be overlooked. For that reason, an explicit `inner` method was chosen.

// design choice
To ensure compatibility with code that used a raw string previously, it is possible to implement corresponding traits, such as `PartialEq<str>`, on the newtype. For this use case, the method `contains` was additionally implemented. As a consequence, migrating to the newtype does not require access to the wrapped string.

// design choice
A common practice in tests is the usage of dummy values to test edge cases of a system. To support dummy values, the method `new_unvalidated` has been introduced and scoped with the macro `#[cfg(test)]` to make it available to test code only. This method skips the validation and directly constructs a newtype.

#figure(
  code_snippet("../res/usecase2/new/handler_call.rs", "Rust"),
  caption: custom_caption([Usage of the newtype ValidatedDreson in the handler. The construction happens through a map call on the option value, and the error is extracted through transposing and mapping the error to a bad request response code.],
  [Use Case 2 - How the newtype is used]),
  kind: raw
) <code-handler-call>

// how the pattern was applied
Finally, the newtype's usage is displayed in @code-handler-call. The construction is done via a mapping in l.3 and l.8, respectively. In l.8, it can be seen how an exception is passed inside the construction method. For extracting the error from the `Result` type, which is wrapped in an `Option`, the method `transpose` is called to make `Result` wrap `Option` instead, allowing to handle the error through subsequent map calls and the `?` operator.

== Use case 3

// High level overview of the changes
A main issue that has been identified in @casestudy[Chapter] to influence multiple criteria negatively, are the mutable vectors `results` and `api_errors`, which were eliminated in the refactoring. Instead of passing a shared mutable reference to all functions, which caused side effects in the status quo code, the results and errors are now accumulated in the states of the typestate pattern.  All of the processing steps from @bpmn3 that access the shared data storage are now encoded as states, which are each represented through structs with fields for result and error cases. Similar to the first use case, the typestate pattern was applied with structs containing data instead of a zero-sized type marker, so that the accumulation is possible without a shared mutable state.

#figure(
  code_snippet("../res/usecase3/new/invocation.rs", "Rust"),
  caption: custom_caption([Generic type `Either` that can represent an outcome of two possible states, or a state that accepts two possible preceding states. The displayed function shows how the state machine is invoked, with functional pipelining in ll.4-5 and making use of the `Either` type.],
  [Use Case 3 - Invocation of state machine and Either generic type]),
  kind: raw
) <usecase3-code-invocation>

// How the pattern was applied
As starting point, the code snippet in @usecase3-code-invocation shows how the state machine is invoked by the handler. The function only accepts a `ValidAnnouncedPositionItemsRequest`, indicating that the state machine can only be entered once a valid request was received. On the valid request, subsequent operations are called in a functional pipeline in ll.4-5.

// Either type (design choice)
Furthermore, @usecase3-code-invocation shows how the generic type `Either`, which can contain either one data type or another, is introduced. This design choice was inspired by the state machine pattern from Crichton's typed functional design patterns @crichton_typed_2023. In this example, either an early returned items array gets passed as left state (l.9), or the processed items as right state (l.12), both of which are accepted by the `FinalResponse` state. Nevertheless, it is also possible to represent two converging states as an enum sum type. An enum encodes the joining of two states more explicitly and is potentially more extensible for future changes, whereas the `Either` type is reusable for cases where other branches are joined, which an enum tied to the specific use case is not. Therefore, the `Either` type was chosen for minimal overhead and reusability.

// design choice
Another issue of the status quo code were complex return types, like a `Result` wrapped by another `Result`, and implicit states like empty arrays instead of explicit encodings. Because enums can be used to return multiple resulting states of the state machine, it was decided to encode these implicit states and complicated return types in enums instead. While it is typical to represent errors through `Result` types in Rust, it was chosen to represent all variants in enums instead, so that different kinds of errors or success cases become more clear for the developer. Rust's exhaustive `match` requires all variants to be handled by default (except when using the `_` operator), so states that were implicit before now need to be handled explicitly.

#figure(
  code_snippet("../res/usecase3/new/enum_variants.rs", "Rust"),
  caption: custom_caption([An enum type that encodes various possible return states. Return states can contain different data, namely `ItemsWithReturnStatuses` and `ItemsWithoutReturnStatuses`. This serves as an example of how implicit application states can be made explicit and possibly handled separately later.],
  [Use Case 3 - Example of explicitly encoded error states]),
  kind: raw
) <usecase3-code-enum>

// how the pattern maps to the code
An example of this can be seen in @usecase3-code-enum, where the `FetchReturnStatusResult` can have multiple resulting states, which can hold different kinds of data, namely items with a return status and items without a return status. These states can then be accepted by different subsequent states to ensure every operation leads from a valid state to the next valid state. For example, @bpmn3 showed that a "Failed to fetch" error, represented as intermediate error event in the middle of the diagram, directly leads to building the response. In the refactored code, the type-level encoding guarantees that no further transition from that error state can be made, and that only the final error building function accepts this state. This has been achieved through accepting an `Either` type with the states `ItemsWithoutReturnStatuses` or `ProcessItemsResult`. They are passed into the construction method of `FinalResponse`, which encodes the identified error case based on the accumulated `results` and `api_errors` vectors.

// current drawback
In the status quo code, there was no distinction made between new items that were created during processing and old valid items. With the application of the typestate pattern, these two types have been separated to encode this semantic difference of the items in the type system. However, when integrating this with the final response logic from the status quo, the types must be converted back to match the existing logic. This issue could be addressed in the future, but would also involve changing the shape of the returned response.

// implementation choice
During the application of the typestate pattern, the "Parse, don't validate" principle has been applied as well to the `AnnouncedPositionItemRequest` struct. The logic of the separate validation method has been included in the construction method `try_from`, making the separate validation step obsolete. Additionally, the `validate_announced_items_request` function violated the @srp in the status quo, since it constructed http responses, which are the responsibility of the handler, and not of validation steps. The function now returns an enum that encodes the error state, which the handler can match on accordingly.

#import "../../pages/outline.typ": custom_caption
#import "../../components/code.typ": code_snippet

#[
  #show figure: set block(breakable: true)

  #figure(
    code_snippet("../res/criterion/ft9.rs", "Rust"),
    caption: custom_caption(
      [This code snippet displays the configuration used for running criterion benchmarks for the use cases 1 and 2 selected from team FT9.],
      [Criterion configuration for FT9 (Use Case 1 & 2)],
    ),
    kind: raw,
  ) <ft9-setup>

  #figure(
    code_snippet("../res/criterion/ft9.rs", "Rust"),
    caption: custom_caption(
      [This code snippet displays the configuration used for running criterion benchmarks for the use case 3 selected from team Boxfish.],
      [Criterion configuration for Boxfish (Use Case 3)],
    ),
    kind: raw,
  ) <boxfish-setup>

  === Use case 1

  #figure(
    code_snippet("../res/criterion/usecase1.rs", "Rust"),
    caption: custom_caption(
      [This code snippet displays the experiment setup used for benchmarking use case 1, which was taken from an existing integration test and adapted for the benchmark.],
      [Benchmarking experiment setup for use case 1],
    ),
    kind: raw,
  ) <exper1>

  === Use case 2

  #figure(
    code_snippet("../res/criterion/usecase2.rs", "Rust"),
    caption: custom_caption(
      [This code snippet displays the experiment setup used for benchmarking use case 2, which was taken from an existing integration test and adapted for the benchmark.],
      [Benchmarking experiment setup for use case 2],
    ),
    kind: raw,
  ) <exper2>

  === Use case 3

  #figure(
    code_snippet("../res/criterion/usecase3.rs", "Rust"),
    caption: custom_caption(
      [This code snippet displays the experiment setup used for benchmarking use case 3, which was taken from an existing integration test and adapted for the benchmark.],
      [Benchmarking experiment setup for use case 3],
    ),
    kind: raw,
  ) <exper3>
]
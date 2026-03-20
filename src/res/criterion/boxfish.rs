fn criterion_benchmark(c: &mut Criterion) {
    let runtime = Runtime::new().unwrap();
    let test_env= runtime.block_on(usecase3_setup());

    c.bench_function("usecase3", |b| {
        b.to_async(&runtime).iter(|| {
            usecase3_foo(&test_env)
        });
    });

    runtime.block_on(async {
        drop(test_env);
    });
}

fn criterion_config() -> Criterion {
    Criterion::default()
        .sample_size(10)
        .warm_up_time(Duration::from_secs(30))
        .measurement_time(Duration::from_secs(120))
}

criterion_group!(
    name = benches;
    config = criterion_config();
    targets = criterion_benchmark
);
criterion_main!(benches);
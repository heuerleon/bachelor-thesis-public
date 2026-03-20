fn criterion_benchmark_1(c: &mut Criterion) {
    let runtime = Runtime::new().unwrap();
    let (
        variation_id,
        product_id,
        activation_benefit_id,
        visitor_id,
        detailview_service,
    ) = runtime.block_on(usecase1_setup());

    c.bench_function("usecase1", |b| {
        b.to_async(&runtime).iter(|| {
            usecase1_foo(
                variation_id.clone(),
                product_id.clone(),
                activation_benefit_id.clone(),
                visitor_id.clone(),
                &detailview_service,
            )
        })
    });

    runtime.block_on(async {
        drop(variation_id);
        drop(product_id);
        drop(activation_benefit_id);
        drop(visitor_id);
        drop(detailview_service);
    });
}

fn criterion_benchmark_2(c: &mut Criterion) {
    let runtime = Runtime::new().unwrap();
    let router = runtime.block_on(usecase2_setup());

    c.bench_function("usecase2", |b| {
        b.to_async(&runtime).iter(|| {
            usecase2_foo(router.clone())
        })
    });

    runtime.block_on(async {
        drop(router);
    });
}

fn criterion_config() -> Criterion {
    Criterion::default()
        .sample_size(100)
        .warm_up_time(Duration::from_secs(30))
        .measurement_time(Duration::from_secs(240))
}

criterion_group!(
    name = benches;
    config = criterion_config();
    targets = criterion_benchmark_1, criterion_benchmark_2
);
criterion_main!(benches);
pub async fn usecase3_foo(test_env: &TestEnvironment) {
    let test_case = TestCase::new();

    test_case
        .create_return_status(&test_env, None)
        .await
        .unwrap();
    let request = test_case
        .create_request("tests/resources/announced_position_items.json")
        .unwrap();

    let foo = handle(
        request,
        &test_env.mongo_client,
        &test_env._sns_client,
        &test_env._sns_config,
        &test_env._vault_kafka_encryption,
    ).await.unwrap();
}

pub async fn usecase3_setup() -> TestEnvironment {
    init_test_environment().await
}
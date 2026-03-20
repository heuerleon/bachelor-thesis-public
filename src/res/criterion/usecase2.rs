pub async fn usecase2_foo(router: Router) {
    let _response = router
        .oneshot(
            Request::builder()
                .uri("/benefit-tag/tag?elementId&xx&team=ft9&originFeature=pdp&benefitId=095c54eb-b454-4d8e-8bc3-454f7c21497b&sendTracking=true")
                .body(Body::empty())
                .unwrap(),
        )
        .await
        .unwrap();
}

pub async fn usecase2_setup() -> Router {
    before_all();

    let test_setup = TestSetup::new().await;

    // setup data
    benefit_tag_stub_data(&test_setup.aws_s3_client, test_setup.names.model_bucket_name).await;

    // setup app
    let application_state = test_setup.get_application_state("", None).await;

    wait_until(10, &application_state.benefits_cache.read().await.clone(), |arg| !arg.is_empty()).await;

    let router = application_state.create_router();
    router
}
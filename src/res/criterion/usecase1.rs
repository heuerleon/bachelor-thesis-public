pub async fn usecase1_foo(
    variation_id: VariationId,
    product_id: ProductId,
    visitor_id: VisitorId,
    activation_benefit_id: BenefitId,
    detailview_service: &DetailviewService
) {
    let _view_model = detailview_service.create_detailview_view_model(
        variation_id,
        &product_id,
        Some(activation_benefit_id),
        UserInformation {
            visitor_id,
            customer_id: Some(CustomerId::new_random()),
            account_type: None,
            is_app_user: false,
        },
        "ft5",
        "pdpDetailview",
        &ToggleContext::default(),
        &HeaderMap::default(),
    ).await.unwrap();
}

pub async fn usecase1_setup() -> (VariationId, ProductId, VisitorId, BenefitId, &'static DetailviewService) {
    before_all();
    let test_setup = TestSetup::new().await;

    // given
    let variation_id = "S06B50ADS60T";
    let product_id = "012345678";
    let benefit_id = "ee6bd35e-da34-49c3-b97c-c9d5c63f99c7";
    let activation_benefit_id = "03076704-ee7e-4baf-b48c-bf081ce8f3ca";
    let visitor_id = "1c89f9bf-f6de-440b-87b7-94ed608f78af.v1";
    let customer_id = "20124051-2491-4876-a4cd-fc4d59cad6ec";

    // setup data
    detailview_stub_data(&test_setup.aws_s3_client, test_setup.names.model_bucket_name).await;

    let variation_hash_map = HashMap::from([
        (String::from("variationId"), AttributeValue::S(String::from(variation_id))),
        (String::from("benefits"), AttributeValue::L(vec![AttributeValue::S(String::from(benefit_id))])),
    ]);
    put_one(&test_setup.aws_dynamodb_client, String::from(test_setup.names.variations_table_name), variation_hash_map)
        .await
        .expect("should be able to insert into dynamodb");

    let up_contract_hash_map = HashMap::from([
        (String::from("customerId"), AttributeValue::S(String::from(customer_id))),
        (String::from("upPackageType"), AttributeValue::S(String::from("PLUS"))),
        (String::from("signDate"), AttributeValue::S(String::from("2024-05-10T12:31:19.031279+00:00"))),
        (String::from("eventTimestamp"), AttributeValue::S(String::from("2024-05-10T12:31:19.031279+00:00"))),
    ]);
    put_one(&test_setup.aws_dynamodb_client, String::from(test_setup.names.up_contract_table_name), up_contract_hash_map)
        .await
        .expect("should be able to insert into dynamodb");

    // setup mongo
    let _unused = setup_mongodb(&test_setup.mongo_client, test_setup.names.activation_database_name).await;

    let collection_name = "visitorid_activations";
    let collection = test_setup.mongo_client.database(test_setup.names.activation_database_name).collection(collection_name);

    collection.insert_one(get_activation(activation_benefit_id, visitor_id)).await.expect("Should insert");
    collection.insert_one(get_activation_recently_expired("foo", visitor_id)).await.expect("Should insert");

    // setup app
    let application_state = test_setup.get_application_state("", None).await;

    wait_until(10, &application_state.detailviews_cache.read().await.clone(), |arg| !arg.is_empty()).await;

    let detailview_service = application_state.detailview_service;
    (
        VariationId::new_no_validation(variation_id),
        ProductId::new_no_validation(product_id),
        VisitorId::new_no_validation(visitor_id),
        BenefitId::new_no_validation(activation_benefit_id),
        detailview_service
    )
}
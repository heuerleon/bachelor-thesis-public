let target_context_dreson = request_params
    .target_context_dreson
    .map(|dreson| ValidatedDreson::from_string(dreson, &[]))
    .transpose()
    .map_err(|_| StatusCode::BAD_REQUEST)?;
let current_context_dreson = request_params
    .current_context_dreson
    .map(|dreson| ValidatedDreson::from_string(dreson, &[String::from("(test.articlelist)")]))
    .transpose()
    .map_err(|_| StatusCode::BAD_REQUEST)?;
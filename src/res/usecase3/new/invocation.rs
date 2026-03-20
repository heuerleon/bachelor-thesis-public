enum Either<L, R> { Left(L), Right(R) }
async fn handle_valid_request(valid_request: ValidAnnouncedPositionItemsRequest, ...) -> FinalResponse {
    let fetch_return_statuses_result = valid_request
        .validate_announced_items()
        .fetch_return_statuses(...).await;
    let items_with_return_statuses = match fetch_return_statuses_result {
        /* omitted cases */ => items,
        FetchReturnStatusResult::NothingToFetch(items) =>
            return FinalResponse::from(Either::Left(items), ...),
    };
    let process_items_result = items_with_return_statuses.process(...).await;
    FinalResponse::from(Either::Right(process_items_result), ...)
}
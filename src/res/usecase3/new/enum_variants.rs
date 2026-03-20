struct ItemsWithReturnStatuses {
    valid_position_items: Vec<ValidAnnouncedPositionItem>,
    api_errors: Vec<ApiError>,
    return_statuses: Vec<ItemReturnStatus>
}
struct ItemsWithoutReturnStatuses {
    valid_position_items: Vec<ValidAnnouncedPositionItem>,
    api_errors: Vec<ApiError>,
}
enum FetchReturnStatusResult {
    NothingToFetch(ItemsWithoutReturnStatuses),
    Success(ItemsWithReturnStatuses),
    Failure(ItemsWithoutReturnStatuses),
}
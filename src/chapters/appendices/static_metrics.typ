#import "../../pages/outline.typ" : custom_caption

#show table.cell.where(y: 0): it => strong(delta: 200, it)
#show table.cell: it => if (it.x == 0 and it.y > 0) { align(left, it) } else { it }
#show table.cell.where(y: 0): set align(horizon)

#set table(stroke: .5pt + black)

=== Use case 1 <usecase1-static-appendix>

#figure(
  table(
    columns: 5,
    [Function], [@cyc], [@coc], [Halstead\ Difficulty], [@mi],

    [`create_detailview_view_model`], [17], [8], [32.22], [50.20],
    [`get_valid_benefits`], [3], [0], [14.67], [108.83],
    [`get_detailview_auto_activated`], [6], [4], [25.48], [77.83],
  ),
  caption: custom_caption(
    [Static code metrics collected for the status quo of use case 1. The table shows the collected metrics for each major function that was included in the refactoring.],
    [Use Case 1 - Static code metrics for status quo]
  )
) <usecase1-metric-before>

#figure(
  table(
    columns: 5,
    [Function], [@cyc], [@coc], [Halstead\ Difficulty], [@mi],

    [`create_detailview_view_model`], [3], [0], [15.11], [83.67],
    [`get_benefit_ids`], [1], [0], [10.67], [111.87],
    [`get_valid_benefits` (top-level)], [3], [0], [14.86], [106.03],
    [`BenefitIdsFetched::get_valid_benefits`], [2], [0], [15.94], [98.65],
    [`ValidBenefitsFiltered::determine_detailview_benefit`], [8], [3], [24.76], [78.44],
    [`DetailviewDetermined::check_for_up_contracts`], [3], [1], [17.14], [89.49],
    [`UpContractTaskSpawned::determine_activation_status`], [4], [4], [22.50], [80.06],
    [`ActivationStatusDetermined::create_adjust_link`], [4], [1], [16.00], [88.40],
    [`AdjustLinkCreated::determine_up_membership`], [3], [1], [17.18], [92.68],
    [`UpMembershipDetermined::build`], [1], [0], [12.83], [107.82],
    [`get_detailview_auto_activated`], [6], [4], [25.48], [77.83],
  ),
  caption: custom_caption(
    [Static code metrics collected for the refactoring of use case 1. The table shows the collected metrics for each major function that was refactored.],
    [Use Case 1 - Static code metrics for refactoring]
  )
) <usecase1-metric-after>

=== Use case 2 <usecase2-static-appendix>

#figure(
  table(
    columns: 5,
    [Function], [@cyc], [@coc], [Halstead\ Difficulty], [@mi],

    [`handle_request`], [16], [17], [31.07], [52.61],
  ),
  caption: custom_caption(
    [Static code metrics collected for the status quo of use case 2. The table shows the collected metrics for each major function that was included in the refactoring.],
    [Use Case 2 - Static code metrics for status quo]
  )
) <usecase2-metric-before>

#figure(
  table(
    columns: 5,
    [Function], [@cyc], [@coc], [Halstead\ Difficulty], [@mi],

    [`handle_request`], [16], [8], [27.93], [54.89],
    [`ValidatedDreson::from_string`], [3], [3], [10.83], [112.10],
    [`ValidatedDreson::new_unvalidated`], [1], [0], [2.67], [136.18],
    [`ValidatedDreson::inner`], [1], [0], [4.67], [133.39],
    [`ValidatedDreson::contains`], [1], [0], [6.00], [131.30],
    [`ValidatedDreson::eq`], [1], [0], [6.75], [131.44],
  ),
  caption: custom_caption(
    [Static code metrics collected for the refactoring of use case 2. The table shows the collected metrics for each major function that was refactored.],
    [Use Case 2 - Static code metrics for refactoring]
  )
) <usecase2-metric-after>

=== Use case 3 <usecase3-static-appendix>

#figure(
  table(
    columns: 5,
    [Function], [@cyc], [@coc], [Halstead\ Difficulty], [@mi],

    [`handle`], [5], [2], [19.38], [70.16],
    [`fetch_item_return_status_for_valid_items`], [4], [2], [19.45], [79.24],
    [`fetch_item_return_status_list`], [2], [0], [12.28], [86.47],
    [`build_internal_server_errors`], [2], [1], [8.25], [105.74],
    [`add_missing_position_item_errors`], [3], [1], [12.50], [85.61],
    [`extract_position_item_ids_from_request`], [2], [0], [10.83], [111.62],
    [`process_position_items`], [5], [6], [18.64], [80.39],
    [`add_internal_server_error`], [1], [0], [6.88], [110.14],
    [`build_final_response`], [8], [8], [19.83], [78.13],
    [`build_unprocessable_entity_error_response`], [2], [0], [10.23], [97.54],
    [`AnnouncedPositionItemsRequest::validate`], [1], [0], [6.29], [114.88],
    [`AnnouncedPositionItems::new`], [1], [0], [5.83], [120.77],
    [`AnnouncedPositionItems::validate`], [1], [0], [10.50], [100.10],
    [`AnnouncedPositionItemsRequest::try_from`], [6], [1], [8.80], [109.86],
    [`validate_announced_items_request`], [5], [3], [20.06], [82.57],
    [`validate_return_item`], [4], [3], [16.00], [85.31],
    [`validate_announced_position_items`], [3], [4], [14.50], [84.17],
  ),
  caption: custom_caption(
    [Static code metrics collected for the status quo of use case 3. The table shows the collected metrics for each major function that was included in the refactoring.],
    [Use Case 3 - Static code metrics for status quo]
  )
) <usecase3-metric-before>

#figure(
  table(
    columns: 5,
    [Function], [@cyc], [@coc], [Halstead\ Difficulty], [@mi],

    [`handle`], [4], [1], [14.17], [88.59],
    [`handle_valid_request`], [3], [1], [18.00], [86.22],
    [`AfterValidationResult::fetch_return_statuses`], [4], [2], [24.00], [70.20],
    [`fetch_item_return_status_list`], [2], [0], [12.50], [86.64],
    [`build_internal_server_errors`], [2], [0], [7.70], [109.25],
    [`build_missing_position_item_errors`], [4], [1], [14.50], [81.86],
    [`ItemsWithReturnStatuses::process`], [6], [5], [23.43], [79.73],
    [`ValidItemReturnStatus::process`], [3], [1], [20.77], [87.85],
    [`internal_server_error`], [1], [0], [6.14], [114.95],
    [`AnnouncedPositionItem::from` (impl @ \~303)], [1], [0], [6.00], [122.69],
    [`AnnouncedPositionItem::from` (impl @ \~312)], [1], [0], [6.00], [122.69],
    [`FinalResponse::from`], [9], [7], [23.40], [72.97],
    [`FinalResponse::build_response`], [8], [1], [17.00], [77.10],
    [`AnnouncedPositionItemsRequest::try_from`], [6], [1], [11.90], [99.08],
    [`AnnouncedPositionItem::validate`], [1], [0], [10.50], [100.10],
    [`validate_announced_items_request`], [4], [2], [14.73], [91.09],
    [`ValidAnnouncedPositionItemsRequest::validate_announced_items`], [4], [3], [15.00], [95.91],
    [`validate_announced_position_item`], [2], [2], [13.93], [88.55],
    [`validate_item_return_status`], [4], [3], [16.73], [89.16],
  ),
  caption: custom_caption(
    [Static code metrics collected for the refactoring of use case 3. The table shows the collected metrics for each major function that was refactored.],
    [Use Case 3 - Static code metrics for refactoring]
  )
) <usecase3-metric-after>

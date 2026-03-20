struct DetailviewDetermined {
    variation_id: VariationId,
    detailview: DetailviewBenefit,
    ...
}
impl DetailviewDetermined {
    fn check_for_up_contracts(self, ...) -> (UpContractTaskSpawned, JoinHandle<bool>) {
        let is_up_member_join_handle = /* omitted */;
        (UpContractTaskSpawned { /* omitted */ }, is_up_member_join_handle)
    }
}
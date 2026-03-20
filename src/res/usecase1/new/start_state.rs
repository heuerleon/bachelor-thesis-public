async fn get_benefit_ids(variation_service: &VariationService, variation_id: VariationId) -> BenefitIdsFetched {
    let benefit_ids = variation_service.get_benefit_ids_by_variation(&variation_id).await;
    let span = Span::current();
    span.record("benefit_ids_on_variation", debug(&benefit_ids));
    BenefitIdsFetched { variation_id, benefit_ids, span }
}
struct BenefitIdsFetched {
    variation_id: VariationId,
    benefit_ids: Vec<BenefitId>,
    span: Span,
}
impl BenefitIdsFetched {
    async fn get_valid_benefits(self, detailview_cache: &'static DetailviewCache) -> ValidBenefitsFiltered { /* omitted */ }
}
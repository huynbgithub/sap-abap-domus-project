@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Quotation Version'
define root view entity ZI_03_S24_999_QUOTAVAR
  as select from y03s24999_quover
  composition [0..*] of ZI_03_S24_999_QVSPRVChild  as _ProductVariants
  composition [0..*] of ZI_03_S24_999_QVSERChild  as _ServiceVariants

{
  key id            as Id,
      quotation_id  as QuotationId,
      version_order as Version,
      _ProductVariants,
      _ServiceVariants
}
where
  is_deleted <> 'X';

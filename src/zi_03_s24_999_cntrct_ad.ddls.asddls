@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_03_S24_999_CNTRCT_AD'
define root view entity ZI_03_S24_999_CNTRCT_AD
  as select from y03s24999_cntrct
  association [1..1] to ZI_03_S24_999_QUOTAVAR as _QuotationVersion on $projection.QuotationVersionId = _QuotationVersion.Id
{
  key id                        as Id,
      quotation_version_id      as QuotationVersionId,
      customer                  as Customer,
      staff                     as Staff,
      _QuotationVersion.Id      as QuotationVersion_Id,
      _QuotationVersion.Version as QuotationVersionName,
      status                    as Status,
      @Semantics.imageUrl: true
      signature                 as Signature,
      created_by                as CreatedBy,
      created_at                as CreatedAt,
      created_on                as CreatedOn,
      updated_by                as UpdatedBy,
      updated_at                as UpdatedAt,
      updated_on                as UpdatedOn,
      description               as Description,
      contract_code             as ContractCode,
      signed_on                 as SignedOn,
      signed_at                 as SignedAt,
      _QuotationVersion._ProductVariants,
      _QuotationVersion._ServiceVariants
}
where
  is_deleted <> 'X';

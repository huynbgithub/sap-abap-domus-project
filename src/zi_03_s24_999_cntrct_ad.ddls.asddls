@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_03_S24_999_CNTRCT_AD'
define root view entity ZI_03_S24_999_CNTRCT_AD
  as select from y03s24999_cntrct
  association [1..1] to y03s24999_quover    as _QuotationVersion on $projection.QuotationVersionId = _QuotationVersion.id
  association        to ZI_03_S24_999_QVSPV as _ProductVariant   on $projection.QuotationVersionId = _ProductVariant.QuotationVersionId
  association        to ZI_03_S24_999_QVSER as _ServiceVariant   on $projection.QuotationVersionId = _ServiceVariant.QuotationVersionId
{
  key id                                     as Id,
      customer                               as Customer,
      staff                                  as Staff,
      quotation_version_id                   as QuotationVersionId,
      _QuotationVersion.version_order        as QuotationVersionName,
      status                                 as Status,
      @Semantics.imageUrl: true
      signature                              as Signature,
      created_by                             as CreatedBy,
      created_at                             as CreatedAt,
      created_on                             as CreatedOn,
      updated_by                             as UpdatedBy,
      updated_at                             as UpdatedAt,
      updated_on                             as UpdatedOn,
      description                            as Description,
      contract_code                          as ContractCode,
      signed_on                              as SignedOn,
      signed_at                              as SignedAt,

      _ProductVariant.ProductName            as ProductName,
      _ProductVariant.ProductVariantQuantity as Quantity,
    _ServiceVariant.ServiceName        as ServiceName,
      _ServiceVariant.ServiceDescription     as ServiceDescription
}
where
  is_deleted <> 'X';

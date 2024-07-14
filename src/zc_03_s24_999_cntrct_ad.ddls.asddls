@EndUserText.label: 'ZC_03_S24_999_CNTRCT_AD'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_03_S24_999_CNTRCT_AD as projection on ZI_03_S24_999_CNTRCT_AD
{
    key Id,
    Customer,
    Staff,
    QuotationVersionName,
    Status,
     @Semantics.imageUrl: true
    Signature,
    CreatedBy,
    CreatedAt,
    CreatedOn,
    UpdatedBy,
    UpdatedAt,
    UpdatedOn,
    Description,
    ContractCode,
    SignedOn,
    SignedAt
}

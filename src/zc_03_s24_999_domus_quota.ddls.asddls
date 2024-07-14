@EndUserText.label: 'View for Quotation of admin'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define root view entity ZC_03_S24_999_DOMUS_QUOTA as projection on ZI03_S24_999_DOMUS_QUOTA
{
    key Id,
    QuotationCode,
    Customer,
    Staff,
    Status,
    PackageName, 
    ExpiredOn,
    ExpiredAt,
    CreatedBy,
    CreatedAt,
    CreatedOn,
    UpdatedBy,
    UpdatedAt,
    UpdatedOn
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Category Header'
define root view entity ZI_03_S24_999_PROCAT as select from y03s24999_procat
composition of ZI_03_S24_999_PRODUCT_ASSN as _product
{
    key id as Id,
    name as Name,
    created_by as CreatedBy,
    created_at as CreatedAt,
    created_on as CreatedOn,
    updated_by as UpdatedBy,
    updated_at as UpdatedAt,
    updated_on as UpdatedOn,
    _product
}
where is_deleted <> 'X'

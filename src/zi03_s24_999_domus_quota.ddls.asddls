@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Domus Quotation'
define root view entity ZI03_S24_999_DOMUS_QUOTA as select from y03s24999_quota
//composition of target_data_source_name as _association_name
{
    key id as Id,
    customer as Customer,
    staff as Staff,
    status as Status,
    package_id as PackageId,
    expired_on as ExpiredOn,
    expired_at as ExpiredAt,
    is_deleted as IsDeleted,
    created_by as CreatedBy,
    created_at as CreatedAt,
    created_on as CreatedOn,
    updated_by as UpdatedBy,
    updated_at as UpdatedAt,
    updated_on as UpdatedOn,
    quotation_code as QuotationCode
  //  _association_name 
}

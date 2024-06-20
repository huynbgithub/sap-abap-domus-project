@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Currency Header'
define root view entity ZI_03_S24_999_CURRENCY
  as select from y03s24999_curr
  //composition of target_data_source_name as _association_name
{
  key id         as Id,
      currency   as Currency,
      created_by as CreatedBy,
      created_at as CreatedAt,
      created_on as CreatedOn,
      updated_by as UpdatedBy,
      updated_at as UpdatedAt,
      updated_on as UpdatedOn
      //    _association_name // Make association public
}
where
  is_deleted <> 'X';

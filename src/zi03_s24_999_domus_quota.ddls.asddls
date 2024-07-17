@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Domus Quotation'
@Metadata.allowExtensions: true
define root view entity ZI03_S24_999_DOMUS_QUOTA
  as select from y03s24999_quota 
  association [1..1] to y03s24999_packge as _Package on $projection.PackageId = _Package.id
  association [1..1] to y03s24999_user   as _User    on $projection.Staff = _User.username
{
  key id             as Id,
      customer       as Customer,
      status         as Status,
      package_id     as PackageId,
      expired_on     as ExpiredOn,
      expired_at     as ExpiredAt,
      created_by     as CreatedBy,
      created_at     as CreatedAt,
      created_on     as CreatedOn,
      updated_by     as UpdatedBy,
      updated_at     as UpdatedAt,
      updated_on     as UpdatedOn,
      quotation_code as QuotationCode,
      _Package.name  as PackageName,
      @Consumption.valueHelpDefinition: [{
         entity: {
             name: 'ZI_03_S24_999_USER',
           element: 'Username'
        },
        label: 'User'
      }]
      staff          as Staff
}
where
  is_deleted <> 'X'
  and status = 'Requested'  ;

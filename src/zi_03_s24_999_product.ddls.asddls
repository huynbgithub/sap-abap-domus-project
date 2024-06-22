@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Header'
define root view entity ZI_03_S24_999_PRODUCT
  as select from y03s24999_prodct
{
  key id               as Id,
  key procat_id        as ProcatId,
      product_code     as ProductCode,
      product_name     as ProductName,
      brand            as Brand,
      created_by       as CreatedBy,
      created_at       as CreatedAt,
      created_on       as CreatedOn,
      updated_by       as UpdatedBy,
      updated_at       as UpdatedAt,
      updated_on       as UpdatedOn,
      description      as Description
}
where
  is_deleted <> 'X';

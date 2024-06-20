@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Header'
define root view entity ZI_03_S24_999_PRODUCT
  as select from y03s24999_prodct
  association [1..1] to ZI_03_S24_999_PRODUCT_VARIANT as _variants on $projection.Id = _variants.ProductId
{
  key id               as Id,
  key procat_id        as ProcatId,
      product_name     as ProductName,
      brand            as Brand,
      created_by       as CreatedBy,
      created_at       as CreatedAt,
      created_on       as CreatedOn,
      updated_by       as UpdatedBy,
      updated_at       as UpdatedAt,
      updated_on       as UpdatedOn,
      description      as Description,

      _variants        as Variants
//      _variants.Id     as VariantIDs,
//      _variants.Images as VariantImages
}
where
  is_deleted <> 'X';

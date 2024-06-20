@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Variant Image Header'
define root view entity ZI_03_S24_999_PRV_IMAGE
  as select from y03s24999_prvimg 
{
  key id                 as Id,
  key product_variant_id as ProductVariantId,
      @Semantics.imageUrl: true
      image_url          as ImageUrl,
      created_by         as CreatedBy,
      created_at         as CreatedAt,
      created_on         as CreatedOn,
      updated_by         as UpdatedBy,
      updated_at         as UpdatedAt,
      updated_on         as UpdatedOn
}
where
  is_deleted <> 'X';

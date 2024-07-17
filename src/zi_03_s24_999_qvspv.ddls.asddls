@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Variant for Quotation Version'
define view entity ZI_03_S24_999_QVSPV
  as select from y03s24999_qvsprv
  association to ZI_03_S24_999_ProductVar as _ProductVariant on $projection.ProductVariantId = _ProductVariant.Id
{
  key  id                          as Id,
  key  product_variant_id          as ProductVariantId,
  key  quotation_version_id        as QuotationVersionId,
       quantity                    as ProductVariantQuantity,
       _ProductVariant.ProductName as ProductName,
       _ProductVariant.Brand       as Brand,
       _ProductVariant.Description as Decription
}
where
  is_deleted <> 'X';

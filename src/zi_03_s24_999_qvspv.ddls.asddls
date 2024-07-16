@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Variant for Quotation Version'
define root view entity ZI_03_S24_999_QVSPV as select from y03s24999_qvsprv
association  to ZI_03_S24_999_PRODUCT_VARIANT as _ProductVariant
    on $projection.ProductVariantId = _ProductVariant.Id
{
    key id as Id,
    product_variant_id as ProductVariantId,
    quotation_version_id as QuotationVersionId,
    quantity as ProductVariantQuantity,
    _ProductVariant.ProductName as ProductName
}
where is_deleted <> 'X';

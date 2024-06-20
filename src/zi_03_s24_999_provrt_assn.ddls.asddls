@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Variant Association Header'
define root view entity ZI_03_S24_999_PROVRT_ASSN as select from ZI_03_S24_999_PRODUCT_VARIANT
association[0..1] to ZI_03_S24_999_PRV_FIRST_IMAGE as _image on $projection.Id = _image.ProductVariantId
{
    key Id,
    key ProductId,
    DisplayPrice,
    CreatedBy,
    CreatedAt,
    CreatedOn,
    UpdatedBy,
    UpdatedAt,
    UpdatedOn,
    CurrencyCode,
    _image.ImageUrl as ImageUrl
}

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Variant First Image Header'
define root view entity ZI_03_S24_999_PRV_FIRST_IMAGE as select from ZI_03_S24_999_PRV_IMAGE
{
    key ProductVariantId,
    @Semantics.imageUrl: true
    min(ImageUrl) as ImageUrl
}
group by ProductVariantId

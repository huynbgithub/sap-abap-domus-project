@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product First Variant Image Header'
define root view entity ZI_03_S24_999_PRO_1ST_VRT_IMG as select from ZI_03_S24_999_PROVRT_ASSN
{
    key ProductId,
    @Semantics.imageUrl: true
    min(ImageUrl) as ImageUrl
}
group by ProductId

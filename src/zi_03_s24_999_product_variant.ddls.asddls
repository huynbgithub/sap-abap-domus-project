@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Variant Header'
define root view entity ZI_03_S24_999_PRODUCT_VARIANT
  as select from y03s24999_provrt
  association [1..1] to ZI_03_S24_999_CURRENCY  as _currency on $projection.CurrencyCode = _currency.Currency
  association [1..1] to ZI_03_S24_999_PRV_IMAGE as _images   on $projection.Id = _images.ProductVariantId
{
  key id                 as Id,
  key product_id         as ProductId,

      @Semantics.amount.currencyCode: 'CurrencyCode'
      display_price      as DisplayPrice,

      created_by         as CreatedBy,
      created_at         as CreatedAt,
      created_on         as CreatedOn,
      updated_by         as UpdatedBy,
      updated_at         as UpdatedAt,
      updated_on         as UpdatedOn,

      _currency.Currency as CurrencyCode,
      _images            as Images
}
where
  is_deleted <> 'X';

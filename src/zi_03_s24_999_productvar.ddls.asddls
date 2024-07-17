@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Variant for Product Version'
define root view entity ZI_03_S24_999_ProductVar
  as select from y03s24999_provrt
  association [1..1] to y03s24999_prodct as _Product on $projection.ProductId = _Product.id

{
  key id                    as Id,
  key product_id            as ProductId,

      _Product.product_name as ProductName,
      _Product.brand        as Brand,
      _Product.description  as Description
}
where
  is_deleted <> 'X';

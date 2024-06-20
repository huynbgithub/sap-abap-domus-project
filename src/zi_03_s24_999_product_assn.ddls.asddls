@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Association Header'
define view entity ZI_03_S24_999_PRODUCT_ASSN 
as select from ZI_03_S24_999_PRODUCT as P
association[0..1] to ZI_03_S24_999_PRO_1ST_VRT_IMG as _variant on $projection.Id = _variant.ProductId
association to parent ZI_03_S24_999_PROCAT as _procat on $projection.ProcatId = _procat.Id
{
    key P.Id as Id,
    P.ProcatId as ProcatId,
    P.ProductName as Name,
    P.Brand as Brand,
    P.Description as Description,
    _variant.ImageUrl as ImageUrl,
    _procat.Name as Category,
    _procat
}

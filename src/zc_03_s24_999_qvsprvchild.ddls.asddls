@EndUserText.label: 'ZC_03_S24_999_QVSPRVCHILD'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_03_S24_999_QVSPRVCHILD as projection on ZI_03_S24_999_QVSPRVChild
{
    key Id,
    key ProductVariantId,
    key QuotationVersionId,
    @UI.facet: [{ 
        id: 'tab1',
        type: #IDENTIFICATION_REFERENCE,
        label: 'General'
  }]

  @UI.lineItem: [{ position: 10 }]
  @UI.identification: [{ position: 10 }]
  @EndUserText.label: 'Quantity'
    ProductVariantQuantity,
    @UI.lineItem: [{ position: 20 }]
  @UI.identification: [{ position: 20 }]
  @EndUserText.label: 'Product name'
    ProductName,
    @UI.lineItem: [{ position: 30 }]
  @UI.identification: [{ position: 30 }]
  @EndUserText.label: 'Brand'
    Brand,
    @UI.lineItem: [{ position: 40 }]
  @UI.identification: [{ position: 50 }]
  @EndUserText.label: 'Description'
    Decription,
    /* Associations */
    _Quotation: redirected to parent  ZC_03_S24_999_QUOTAVAR
}

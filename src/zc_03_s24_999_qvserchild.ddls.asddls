@EndUserText.label: 'ZC_03_S24_999_QVSERCHILD'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_03_S24_999_QVSERCHILD as projection on ZI_03_S24_999_QVSERChild
{
    key ServiceVariantId,
    key ServiceId,
    key QuotationVersionId,
     @UI.facet: [{ 
        id: 'tab1',
        type: #IDENTIFICATION_REFERENCE,
        label: 'General'
  }]

  @UI.lineItem: [{ position: 10 }]
  @UI.identification: [{ position: 10 }]
  @EndUserText.label: 'Service Name'
    ServiceName,
    @UI.lineItem: [{ position: 20 }]
  @UI.identification: [{ position: 20 }]
  @EndUserText.label: 'Service Description'
    ServiceDescription,
   
    _Quotation: redirected to parent  ZC_03_S24_999_QUOTAVAR
}

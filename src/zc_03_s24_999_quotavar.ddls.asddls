@EndUserText.label: 'ZC_03_S24_999_QUOTAVAR'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@UI.headerInfo: { 
    typeName: 'Quotation Version Detail', // Title of Detail Screen
    typeNamePlural: 'Quotation Versions',  // Title of the List Table
    typeImageUrl: 'sap-icon://document-text',
    title: {
        value: 'QuotationId'
    },
    description: {
        value: 'Version'
    }
}
define root view entity ZC_03_S24_999_QUOTAVAR as projection on ZI_03_S24_999_QUOTAVAR
{
  @UI.facet: [{ 
        id: 'tab1',
        type: #IDENTIFICATION_REFERENCE,
        label: 'General'
    }, {
        id: 'tab2',
        type: #FIELDGROUP_REFERENCE,
        targetQualifier: 'productFG',
        label: 'Product Variants'
    }, {
        id: 'tab3',
        type: #FIELDGROUP_REFERENCE,
        targetQualifier: 'serviceFG',
        label: 'Service Variants'
    }]

    @UI.hidden: true 
    key Id,
    @UI.identification: [{ position: 10 }]
    @UI.selectionField: [{ position: 10 }]
    @EndUserText.label: 'Quotation ID'
    QuotationId,
     @UI.identification: [{ position: 20 }]
    @UI.selectionField: [{ position: 20 }]
    @EndUserText.label: 'Version'
    Version,
    /* Associations */
    _ProductVariants :  redirected to composition child ZC_03_S24_999_QVSPRVCHILD,
    _ServiceVariants : redirected to composition child ZC_03_S24_999_QVSERCHILD
}

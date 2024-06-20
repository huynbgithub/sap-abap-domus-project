@EndUserText.label: 'View for Product App'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo: {
    title: {
        value: 'Name'
    },
    description: {
        value: 'Category'
    }
}
define view entity ZC_03_S24_999_ProductApp
  as projection on ZI_03_S24_999_PRODUCT_ASSN
{
      @EndUserText.label: 'Product'
//      @UI.selectionField: [{ position: 1 }]
//      @UI.identification: [{ position: 1 }]
//      @UI.lineItem: [{ position: 1, label: 'Name' }]
      @UI.facet: [{
          type: #IDENTIFICATION_REFERENCE,
          label: 'Product',
          id: 'idFacet'
      }]
  key Id,

      @EndUserText.label: 'Name'
      @UI.identification: [{ position: 2 }]
      @UI.selectionField: [{ position: 2 }]
      @UI.lineItem: [{ position: 2, label: 'Name' }]
      Name,

      @EndUserText.label: 'Image'
      @UI.identification: [{ position: 3 }]
      @UI.selectionField: [{ position: 3 }]
      @UI.lineItem: [{ position: 3, label: 'Image' }]
      ImageUrl,

      @EndUserText.label: 'Category'
      @UI.identification: [{ position: 4 }]
      @UI.selectionField: [{ position: 4 }]
      @UI.lineItem: [{ position: 4, label: 'Category' }]
      Category,

      @EndUserText.label: 'Brand'
      @UI.identification: [{ position: 5 }]
      @UI.selectionField: [{ position: 5 }]
      @UI.lineItem: [{ position: 5, label: 'Brand' }]
      Brand,

      @EndUserText.label: 'Description'
      @UI.identification: [{ position: 6 }]
      @UI.selectionField: [{ position: 6 }]
      @UI.lineItem: [{ position: 6, label: 'Description' }]
      Description

}

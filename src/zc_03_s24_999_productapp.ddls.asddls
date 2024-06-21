@EndUserText.label: 'View for Product App'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo: {
    title: {
        value: 'Category'
    },
    description: {
        value: 'Name'
    }
}
define view entity ZC_03_S24_999_ProductApp
  as projection on ZI_03_S24_999_PRODUCT_ASSN
{
      @UI.facet: [{
          id: 'idFacetParent',
          type: #COLLECTION,
          label: 'Detail',
          position: 10
      },
      {
          id: 'idFacet',
          type: #IDENTIFICATION_REFERENCE,
          parentId: 'idFacetParent',
          label: 'Product Information',
          position: 10
      }
      ]
      
      @EndUserText.label: 'ID'
      @UI.lineItem: [{ position: 1, label: 'ID' }]
      @UI.selectionField: [{ position: 1 }]
      key Id,
      
      @EndUserText.label: 'Short Description'
      @UI.lineItem: [{ position: 50, label: 'Description' }]
//      @UI.selectionField: [{ position: 50 }]
      @UI.identification: [{ position: 40 }]
      ShortDescription,

      @EndUserText.label: 'Name'
      @UI.lineItem: [{ position: 30, label: 'Name', importance: #HIGH }]
      @UI.selectionField: [{ position: 10 }]
      @UI.identification: [{ position: 20 }]
      Name,

      @EndUserText.label: 'Image'
      @UI.lineItem: [{ position: 10, label: 'Preview Image', importance: #HIGH }]
      @UI.identification: [{ position: 10, label: 'Preview Image' }]
      ImageUrl,

      @EndUserText.label: 'Category'
      @UI.lineItem: [{ position: 20, label: 'Category' }]
      @UI.selectionField: [{ position: 30 }]
      @UI.identification: [{ position: 50 }]
      Category,

      @EndUserText.label: 'Brand'
      @UI.lineItem: [{ position: 40, label: 'Brand'}]
      @UI.selectionField: [{ position: 40 }]
      @UI.identification: [{ position: 60 }]
      Brand,

      @EndUserText.label: 'Description'
//      @UI.lineItem: [{ position: 50, label: 'Description' }]
      @UI.selectionField: [{ position: 50 }]
      @UI.identification: [{ position: 30 }]
      Description

}

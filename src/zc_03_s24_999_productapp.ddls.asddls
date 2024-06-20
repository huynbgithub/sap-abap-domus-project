@EndUserText.label: 'View for Product App'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_03_S24_999_ProductApp
  as projection on ZI_03_S24_999_PRODUCT
{
      @EndUserText.label: 'Product'
      @UI.lineItem: [{ position: 10 }]
      @UI.selectionField: [{ position: 20 }]
      @UI.identification: [{ position: 10 }]
      @UI.facet: [{
          type: #IDENTIFICATION_REFERENCE,
          label: 'Product',
          id: 'idFacet'
      }]
  key Id,

  key ProcatId,
      //      ProductName,
      //      Brand,
      //      IsDeleted,
      //      CreatedBy,
      //      CreatedAt,
      //      CreatedOn,
      //      UpdatedBy,
      //      UpdatedAt,
      //      UpdatedOn,
      //      Description,

      @EndUserText.label: 'Imgurl'
      @UI.identification: [{ position: 20 }]
      @UI.selectionField: [{ position: 10 }]
      @UI.lineItem: [{ position: 20, label: 'Imgurl' }]
      Variants.Images.ImageUrl
}

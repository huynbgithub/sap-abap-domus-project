@EndUserText.label: 'View for Quotation of admin'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@UI.headerInfo: {
    typeName: 'Quotation',
    typeNamePlural: 'Quotations',
    title: {
        label: 'Quotation ID',
        value: 'Id'
    },
    description: {
        label: 'Staff',
        value: 'Staff'
    }
}
define root view entity ZI03_S24_999S_QuotaApp as projection on ZI03_S24_999_DOMUS_QUOTA
{
    @EndUserText.label: 'Quotation'
    @UI.lineItem: [{ position: 10 }]
    @UI.selectionField: [{ position: 10 }]
    @UI.identification: [{ position: 10 }]
    @UI.facet: [{
        type: #IDENTIFICATION_REFERENCE,
        label: 'Quotation Data',
        id: 'idFacet'
    }]
    key Id,

    @EndUserText.label: 'Customer'
    @UI.lineItem: [{ position: 20 }]
    @UI.selectionField: [{ position: 20 }]
    @UI.identification: [{ position: 20 }]
    Customer,

    @EndUserText.label: 'Staff'
    @UI.lineItem: [{ position: 30 }]
    @UI.selectionField: [{ position: 30 }]
    @UI.identification: [{ position: 30 }]
    Staff,

    @EndUserText.label: 'Status'
    @UI.lineItem: [{ position: 40 }]
    @UI.selectionField: [{ position: 40 }]
    @UI.identification: [{ position: 40 }]
    Status,

    @EndUserText.label: 'Package ID'
    @UI.lineItem: [{ position: 50 }]
    @UI.selectionField: [{ position: 50 }]
    @UI.identification: [{ position: 50 }]
    PackageId,

    @EndUserText.label: 'Expiration Date'
    @UI.lineItem: [{ position: 60 }]
    @UI.selectionField: [{ position: 60 }]
    @UI.identification: [{ position: 60 }]
    ExpiredOn,

    @EndUserText.label: 'Expiration Time'
    @UI.lineItem: [{ position: 70 }]
    @UI.selectionField: [{ position: 70 }]
    @UI.identification: [{ position: 70 }]
    ExpiredAt,
    @EndUserText.label: 'Quotation Code'
    @UI.lineItem: [{ position: 100 }]
     @UI.selectionField: [{ position: 80 }]
    @UI.identification: [{ position: 100 }]
    QuotationCode,

    // Fields to be hidden
    @UI.hidden: true
    IsDeleted,
    
    @UI.hidden: true
    CreatedBy,

    @UI.hidden: true
    CreatedOn,
    
    @UI.hidden: true
    CreatedAt,

    @UI.hidden: true
    UpdatedBy,

    @UI.hidden: true
    UpdatedAt,

    @UI.hidden: true
    UpdatedOn
}


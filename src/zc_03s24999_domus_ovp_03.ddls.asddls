@AbapCatalog.sqlViewName: 'ZC03S24999OVP03'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZC_03S24999_DOMUS_OVP_03'
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
@OData.publish: true
define view ZC_03S24999_DOMUS_OVP_03 as select from ZIC_03S24999_DOMUS_OVP_01
{
    key ContractId,
    Status,
    Staff,
    Revenue
}

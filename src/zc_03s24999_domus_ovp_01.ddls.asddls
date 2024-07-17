@EndUserText.label: 'Consumption for ZIC_03S24999DOMUSOVP01'
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
@OData.publish: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZC_03S24999_DOMUS_OVP_01 as projection on ZIC_03S24999_DOMUS_OVP_01
{
    key ContractId,
    Status,
    Staff,
    Revenue
}

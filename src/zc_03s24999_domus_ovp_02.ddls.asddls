@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZC_03S24999_DOMUS_OVP_02'
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
@OData.publish: true
define root view entity ZC_03S24999_DOMUS_OVP_02 as select from ZIC_03S24999_DOMUS_OVP_01
{
    key ContractId,
    Status,
    Staff,
    Revenue
}

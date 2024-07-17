@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@EndUserText.label: 'Composition View for ZI03S24DOMUSOVP01'
define root view entity ZIC_03S24999_DOMUS_OVP_01 as select from ZI_03S24999_DOMUS_OVP_01
{
    key ContractId,
    Status,
    Staff,
    @DefaultAggregation: #SUM
    Revenue
}

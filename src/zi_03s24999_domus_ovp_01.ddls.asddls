@AccessControl.authorizationCheck: #NOT_REQUIRED
@VDM.viewType: #BASIC
@EndUserText.label: 'Domus Overview Page 01'
define root view entity ZI_03S24999_DOMUS_OVP_01 
as select from y03s24999_cntrct as _c
join y03s24999_quover as _q on _q.id = _c.quotation_version_id
{
    
    key _c.id as ContractId,
        _c.status as Status,
        _c.staff as Staff,
        sum(cast(_q.total_price as abap.dec(15, 2))) as Revenue
} where _c.is_deleted <> 'X'
group by _c.id,  _c.status, _c.staff;

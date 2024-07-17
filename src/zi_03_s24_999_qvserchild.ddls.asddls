@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child Class Of Quotation Version'
define view entity ZI_03_S24_999_QVSERChild as select from y03s24999_qvsser
association [1..1] to y03s24999_servce as _Service
    on $projection.ServiceId = _Service.id
   association to parent  ZI_03_S24_999_QUOTAVAR as _Quotation
        on $projection.QuotationVersionId = _Quotation.Id

{
    key id as ServiceVariantId,
    key service_id as ServiceId,
    key quotation_version_id as QuotationVersionId,
    _Service.name as ServiceName,
    _Service.description as ServiceDescription,
    _Quotation
}
where is_deleted <> 'X';

@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Service variant for Quotation version'
define root view entity ZI_03_S24_999_QVSER as select from y03s24999_qvsser
association [1..1] to y03s24999_servce as _Service
    on $projection.ServiceId = _Service.id
{
    key id as ServiceVariantId,
    service_id as ServiceId,
    quotation_version_id as QuotationVersionId,
    _Service.name as ServiceName,
    _Service.description as ServiceDescription
}
where is_deleted <> 'X';

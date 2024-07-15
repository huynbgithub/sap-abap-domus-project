@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZI_03_S24_999_USER'
define root view entity ZI_03_S24_999_USER as select from y03s24999_user
{
   key username as Username
} where is_staff = 'X';

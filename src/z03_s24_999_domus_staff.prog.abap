*&---------------------------------------------------------------------*
*& Module Pool      Z03_S24_999_DOMUS_STAFF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM Z03_S24_999_DOMUS_STAFF.

*&---------------------------------------------------------------------*
*& DOMUS_STAFF Top Include
*&---------------------------------------------------------------------*
INCLUDE Z03_S24_999_DOMUS_STAFF_TOP.
INCLUDE Z03_S24_999_PRODUCT_TOP.
INCLUDE Z03_S24_999_SERVICE_TOP.
INCLUDE Z03_S24_999_PACKAGE_TOP.
INCLUDE Z03_S24_999_QUOTATION_TOP.
INCLUDE Z03_S24_999_CONTRACT_TOP.

*---------------------------------------------------------------------*
* MODULES (Call by Screens)
*---------------------------------------------------------------------*
* Screen 1000
INCLUDE Z03_S24_999_DOMUS_AUTH_PBO1000.
INCLUDE Z03_S24_999_DOMUS_AUTH_PAI1000.
* Screen 100
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO100.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI100.
* Screen 110
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO110.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI110.
* Screen 120
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO120.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI120.
* Screen 122
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO122.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI122.
* Screen 129
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO129.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI129.
* Screen 128
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO128.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI128.
* Screen 130
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO130.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI130.
* Screen 132
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO132.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI132.
* Screen 140
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO140.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI140.
* Screen 150
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO150.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI150.

*---------------------------------------------------------------------*
* CLASS Implementation
*---------------------------------------------------------------------*
INCLUDE Z03_S24_999_CLASS_IMPLEMENT.

*---------------------------------------------------------------------*
* Subroutine (FORM ... PERFORM)
*---------------------------------------------------------------------*
INCLUDE Z03_S24_999_DOMUS_STAFF_FORM.
INCLUDE Z03_S24_999_PRODUCT_FORM.
INCLUDE Z03_S24_999_SERVICE_FORM.
INCLUDE Z03_S24_999_PACKAGE_FORM.
INCLUDE Z03_S24_999_QUOTATION_FORM.
INCLUDE Z03_S24_999_CONTRACT_FORM.

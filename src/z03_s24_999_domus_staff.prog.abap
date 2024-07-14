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
* Screen 125
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO125.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI125.
* Screen 126
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO126.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI126.
* Screen 127
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO127.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI127.
* Screen 128
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO128.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI128.
* Screen 129
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO129.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI129.
* Screen 130
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO130.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI130.
* Screen 134
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO134.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI134.
* Screen 135
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO135.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI135.
* Screen 136
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO136.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI136.
* Screen 137
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO137.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI137.
* Screen 138
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO138.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI138.
* Screen 139
INCLUDE Z03_S24_999_DOMUS_STAFF_PBO139.
INCLUDE Z03_S24_999_DOMUS_STAFF_PAI139.
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

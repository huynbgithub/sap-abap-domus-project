*&---------------------------------------------------------------------*
*& Module Pool      Z03_S24_CUST_PACKAGE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*       .
PROGRAM Z03_S24_CUST_PACKAGE.
*&---------------------------------------------------------------------*
*& CUSTOMER_PACKGE Top Include
*&---------------------------------------------------------------------*
INCLUDE Z03_S24_CUST_PACKAGE_TOP.

*---------------------------------------------------------------------*
* MODULES (Call by Screens)
*---------------------------------------------------------------------*
* Screen 1000
INCLUDE Z03_S24_CUST_PACKAGE_PBO0100.

INCLUDE Z03_S24_CUST_PACKAGE_PAI0100.

INCLUDE Z03_S24_CUST_PACKAGE_PBO0150.

INCLUDE Z03_S24_CUST_PACKAGE_PAI0150.

INCLUDE Z03_S24_CUST_PACKAGE_PBO0120.

INCLUDE Z03_S24_CUST_PACKAGE_PBO0130.

INCLUDE Z03_S24_CUST_PACKAGE_PBO0140.

INCLUDE Z03_S24_CUST_PACKAGE_PAI0140.

INCLUDE Z03_S24_CUST_PACKAGE_PAI0130.

INCLUDE Z03_S24_CUST_PACKAGE_PAI0120.

INCLUDE Z03_S24_CUST_PACKAGE_PBO0160.

INCLUDE Z03_S24_CUST_PACKAGE_PAI0160.


*---------------------------------------------------------------------*
* CLASS Implementation
*---------------------------------------------------------------------*
INCLUDE Z03_S24_CUST_PACKAGE_CLASS_IMP.

*---------------------------------------------------------------------*
* Subroutine (FORM ... PERFORM)
*---------------------------------------------------------------------*
INCLUDE Z03_S24_CUST_PACKAGE_FORM.

INCLUDE z03_s24_cust_package_pai0170.

INCLUDE z03_s24_cust_package_pbo0170.

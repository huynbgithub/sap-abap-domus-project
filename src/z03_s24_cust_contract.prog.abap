*&---------------------------------------------------------------------*
*& Module Pool      Z03_S24_CUST_CONTRACT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM Z03_S24_CUST_CONTRACT.

*&---------------------------------------------------------------------*
*& CUST_CONTRACT Top Include
*&---------------------------------------------------------------------*
INCLUDE Z03_S24_CONT_TOP.

*---------------------------------------------------------------------*
* MODULES
*---------------------------------------------------------------------*

* Screen 1000
INCLUDE Z03_S24_CONT_AUTH_PBO1000.
INCLUDE Z03_S24_CONT_AUTH_PAI1000.

* Screen 100
INCLUDE Z03_S24_CONT_AUTH_PBO100.
INCLUDE Z03_S24_CONT_AUTH_PAI100.

* Screen 200
INCLUDE Z03_S24_CONT_PBO200.
INCLUDE Z03_S24_CONT_PAI200.

*---------------------------------------------------------------------*
* CLASS Implementation
*---------------------------------------------------------------------*
INCLUDE Z03_S24_CONT_CLASS_IMP.
*---------------------------------------------------------------------*
* FORM
*---------------------------------------------------------------------*
INCLUDE Z03_S24_CONT_FORM.

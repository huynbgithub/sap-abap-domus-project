*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_CLASS_IMPLEMENT
*&---------------------------------------------------------------------*

*---------------------------------------------------------------------*
* CL_QUOTATION_ALV_HANDLER IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS CL_QUOTATION_ALV_HANDLER IMPLEMENTATION.

  METHOD HOTSPOT_CLICK.

    READ TABLE IT_QUOTATION INTO DATA(LS_QUOTATION)
      INDEX E_ROW_ID-INDEX.

    MESSAGE I007(Z03S24999_DOMUS_MSGS) WITH LS_QUOTATION-QUOTATION_CODE.

  ENDMETHOD.

ENDCLASS.

*---------------------------------------------------------------------*
* CL_PACKAGE_ALV_HANDLER IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS CL_PACKAGE_ALV_HANDLER IMPLEMENTATION.

  METHOD HOTSPOT_CLICK.
    DATA: LD_CHOICE TYPE C.
    READ TABLE IT_PACKAGE INTO DATA(LS_PACKAGE)
      INDEX E_ROW_ID-INDEX.

    PERFORM PREPARE_PACKAGE_DETAIL USING LS_PACKAGE-ID.
    LEAVE TO SCREEN 0100.

  ENDMETHOD.

ENDCLASS.

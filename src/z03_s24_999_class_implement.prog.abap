*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_CLASS_IMPLEMENT
*&---------------------------------------------------------------------*

*---------------------------------------------------------------------*
* LCL_QUOTATION_ALV_HANDLER IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS LCL_QUOTATION_ALV_HANDLER IMPLEMENTATION.

  METHOD HOTSPOT_CLICK.

    READ TABLE IT_QUOTATION INTO DATA(LS_QUOTATION)
      INDEX E_ROW_ID-INDEX.

    MESSAGE I007(Z03S24999_DOMUS_MSGS) WITH LS_QUOTATION-QUOTATION_CODE.

  ENDMETHOD.

ENDCLASS.

*---------------------------------------------------------------------*
* LCL_PACKAGE_ALV_HANDLER IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS LCL_PACKAGE_ALV_HANDLER IMPLEMENTATION.

  METHOD HOTSPOT_CLICK.

    READ TABLE IT_PACKAGE INTO DATA(LS_PACKAGE)
      INDEX E_ROW_ID-INDEX.

    MESSAGE I007(Z03S24999_DOMUS_MSGS) WITH LS_PACKAGE-NAME.

  ENDMETHOD.

ENDCLASS.

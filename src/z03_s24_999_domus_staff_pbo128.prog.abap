*----------------------------------------------------------------------*
***INCLUDE Z03_S24_999_DOMUS_STAFF_PBO128.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module PREPARE_DATA_0128 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE PREPARE_DATA_0128 OUTPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB2.
    PERFORM PREPARE_PACKAGE_DETAIL USING GV_PACKAGE_ID.
  ENDIF.
ENDMODULE.

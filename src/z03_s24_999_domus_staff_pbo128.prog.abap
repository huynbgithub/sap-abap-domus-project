*----------------------------------------------------------------------*
***INCLUDE Z03_S24_999_DOMUS_STAFF_PBO128.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0128 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0128 OUTPUT.
  SET PF-STATUS 'ZSTATUS_0128'.
  SET TITLEBAR 'ZTITLE_0128'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PREPARE_DATA_0128 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE PREPARE_DATA_0128 OUTPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB2.
      DATA: LV_SUCCESS TYPE ABAP_BOOL.
* Get data from SERVICE_0128 table
      PERFORM GET_SERVICE_0128_DATA CHANGING LV_SUCCESS.
      IF LV_SUCCESS = ABAP_FALSE.
        RETURN.
      ENDIF.
* Show SERVICE_0128 ALV
      PERFORM SHOW_SERVICE_0128_ALV.
  ENDIF.
ENDMODULE.

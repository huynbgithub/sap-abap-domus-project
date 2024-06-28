*----------------------------------------------------------------------*
***INCLUDE Z03_S24_999_DOMUS_STAFF_PBO128.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module PREPARE_DATA_0128 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE PREPARE_DATA_0128 OUTPUT.
  DATA: LV_SUCCESS TYPE ABAP_BOOL.
      PERFORM GET_PCKSER_DATA CHANGING LV_SUCCESS.
      IF LV_SUCCESS = ABAP_FALSE.
        RETURN.
      ENDIF.
* Show PCKSER ALV
      PERFORM SHOW_PCKSER_ALV.
ENDMODULE.

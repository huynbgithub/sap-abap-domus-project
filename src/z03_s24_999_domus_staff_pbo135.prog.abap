*----------------------------------------------------------------------*
***INCLUDE Z03_S24_999_DOMUS_STAFF_PBO135.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0135 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0135 OUTPUT.
  SET PF-STATUS 'ZSTATUS_0135'.
  SET TITLEBAR 'ZTITLE_0135'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PREPARE_DATA_0135 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE PREPARE_DATA_0135 OUTPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB3.
      PERFORM SHOW_PROATV_0135_ALV.
  ENDIF.
ENDMODULE.

*----------------------------------------------------------------------*
***INCLUDE Z03_S24_999_DOMUS_STAFF_PBO138.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0138 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0138 OUTPUT.
  SET PF-STATUS 'ZSTATUS_0138'.
  SET TITLEBAR 'ZTITLE_0138'.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PREPARE_DATA_0138 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE PREPARE_DATA_0138 OUTPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB3.
      PERFORM SHOW_SERVICE_0138_ALV.
  ENDIF.
ENDMODULE.

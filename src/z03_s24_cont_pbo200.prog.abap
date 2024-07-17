*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DOMUS_STAFF_PBO200
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module ADJUST_TABLE_LINE_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE ADJUST_TABLE_LINE_0200 OUTPUT.
  CTRPRV_TABLE_CONTROL-LINES = LINES( GT_CTRPRV ).
  CTRSER_TABLE_CONTROL-LINES = LINES( GT_CTRSER ).
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CALCULATE_TOTAL_PRICE_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CALCULATE_TOTAL_PRICE_0200 OUTPUT.
  GV_CTRPRV_TOTAL_PRICE = 0.
  LOOP AT GT_CTRPRV INTO DATA(LS_CTRPRV_ROW).
    LS_CTRPRV_ROW-TOTAL_PRICE = LS_CTRPRV_ROW-PRICE * LS_CTRPRV_ROW-QUANTITY.
    MODIFY TABLE GT_CTRPRV FROM LS_CTRPRV_ROW.

    GV_CTRPRV_TOTAL_PRICE += LS_CTRPRV_ROW-TOTAL_PRICE.
  ENDLOOP.

  GV_CTRSER_TOTAL_PRICE = 0.
  LOOP AT GT_CTRSER INTO DATA(LS_CTRSER_ROW).
    GV_CTRSER_TOTAL_PRICE += LS_CTRSER_ROW-PRICE.
  ENDLOOP.

  GV_CONTRACT_TOTAL_PRICE = 0.
  GV_CONTRACT_TOTAL_PRICE = GV_CTRPRV_TOTAL_PRICE + GV_CTRSER_TOTAL_PRICE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_PCKDES_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_CTRDES_SCREEN OUTPUT.
  IF CTRDES_EDITOR01 IS NOT INITIAL.
    CTRDES_EDITOR01->SET_READONLY_MODE( ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_CONTRACT_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_CONTRACT_SCREEN OUTPUT.
  LOOP AT SCREEN.
    SCREEN-INPUT     = '0'.

    IF SCREEN-NAME = 'BACK_TO_CNTRCT_LIST'.
      SCREEN-INPUT     = '1'.
    ENDIF.

    IF GS_CONTRACT_DETAIL-STATUS = 'Sent'.
      IF SCREEN-NAME = 'CANCEL' OR SCREEN-NAME = 'SIGN'.
        SCREEN-INPUT = '1'.
      ENDIF.
    ELSE.
      IF SCREEN-NAME = 'CANCEL' OR SCREEN-NAME = 'SIGN'.
        SCREEN-INVISIBLE = '1'.
        SCREEN-ACTIVE    = '0'.
        SCREEN-INPUT     = '0'.
      ENDIF.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_CTRPRV_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_CTRPRV_SCREEN OUTPUT.
  LOOP AT SCREEN.
    SCREEN-INPUT     = '0'.

    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_CTRSER_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_CTRSER_SCREEN OUTPUT.
  LOOP AT SCREEN.
    SCREEN-INPUT     = '0'.

    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module STATUS_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0200 OUTPUT.
  SET PF-STATUS 'ZSTATUS_0200'.
  SET TITLEBAR 'ZTITLE_0200'.
ENDMODULE.

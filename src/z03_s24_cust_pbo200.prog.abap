*&---------------------------------------------------------------------*
*& Include          Z03_S24_CUST_PBO200
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module ADJUST_TABLE_LINE_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE ADJUST_TABLE_LINE_0200 OUTPUT.
  QVSPRV_TABLE_CONTROL-LINES = LINES( GT_QVSPRV ).
  QVSSER_TABLE_CONTROL-LINES = LINES( GT_QVSSER ).
  QUOMSG_TABLE_CONTROL-LINES = LINES( GT_QUOMSG ).
ENDMODULE.

*&---------------------------------------------------------------------*
*& Module CALCULATE_TOTAL_PRICE_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CALCULATE_TOTAL_PRICE_0200 OUTPUT.
  GV_QVSPRV_TOTAL_PRICE = 0.
  GV_QVSSER_TOTAL_PRICE = 0.
  GV_QUOVER_TOTAL_PRICE = 0.

  LOOP AT GT_QVSPRV INTO DATA(LS_QVSPRV_ROW).
    LS_QVSPRV_ROW-TOTAL_PRICE = LS_QVSPRV_ROW-PRICE * LS_QVSPRV_ROW-QUANTITY.
    MODIFY TABLE GT_QVSPRV FROM LS_QVSPRV_ROW.
    GV_QVSPRV_TOTAL_PRICE += LS_QVSPRV_ROW-TOTAL_PRICE.
  ENDLOOP.

  LOOP AT GT_QVSSER INTO DATA(LS_QVSSER_ROW).
    GV_QVSSER_TOTAL_PRICE += LS_QVSSER_ROW-PRICE.
  ENDLOOP.

  GV_QUOVER_TOTAL_PRICE = GV_QVSPRV_TOTAL_PRICE + GV_QVSSER_TOTAL_PRICE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_QSCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_QSCREEN OUTPUT.
  LOOP AT SCREEN.

    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.

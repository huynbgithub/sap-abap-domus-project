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
    SCREEN-INPUT = '0'.

    IF GS_QUOTATION_DETAIL-STATUS = 'Requested'.
      IF SCREEN-NAME = 'CANCLE_QUOTATION'.
        SCREEN-INPUT = '1'.
      ENDIF.
      IF SCREEN-NAME = 'ACCEPT_QUOTATION'.
        SCREEN-INPUT     = '0'.
      ENDIF.

      IF SCREEN-NAME = 'GS_QVSPRV-PRICE' OR
         SCREEN-NAME = 'GS_QVSPRV-TOTAL_PRICE' OR
         SCREEN-NAME = 'GS_QVSSER-PRICE' OR
         SCREEN-NAME = 'GV_QVSPRV_TOTAL_PRICE' OR
         SCREEN-NAME = 'GV_QVSSER_TOTAL_PRICE' OR
         SCREEN-NAME = 'GV_QUOVER_TOTAL_PRICE'.
        SCREEN-INVISIBLE = '1'.
        SCREEN-ACTIVE    = '0'.
        SCREEN-INPUT     = '0'.
      ENDIF.

    ELSEIF GS_QUOTATION_DETAIL-STATUS = 'Negotiating'.
      IF SCREEN-NAME = 'ACCEPT_QUOTATION' OR SCREEN-NAME = 'CANCLE_QUOTATION'.
        SCREEN-INPUT = '1'.
      ENDIF.

    ELSEIF GS_QUOTATION_DETAIL-STATUS = 'Cancelled'.
      IF SCREEN-NAME = 'ACCEPT_QUOTATION' OR SCREEN-NAME = 'CANCLE_QUOTATION'.
        SCREEN-INVISIBLE = '1'.
        SCREEN-ACTIVE    = '0'.
        SCREEN-INPUT     = '0'.
      ENDIF.

      IF SCREEN-NAME = 'GS_QVSPRV-PRICE' OR
         SCREEN-NAME = 'GS_QVSPRV-TOTAL_PRICE' OR
         SCREEN-NAME = 'GS_QVSSER-PRICE' OR
         SCREEN-NAME = 'GV_QVSPRV_TOTAL_PRICE' OR
         SCREEN-NAME = 'GV_QVSSER_TOTAL_PRICE' OR
         SCREEN-NAME = 'GV_QUOVER_TOTAL_PRICE'.
        SCREEN-INVISIBLE = '1'.
        SCREEN-ACTIVE    = '0'.
        SCREEN-INPUT     = '0'.
      ENDIF.
    ELSEIF GS_QUOTATION_DETAIL-STATUS = 'Accepted'.
      IF SCREEN-NAME = 'ACCEPT_QUOTATION' OR SCREEN-NAME = 'CANCLE_QUOTATION'.
        SCREEN-INVISIBLE = '1'.
        SCREEN-ACTIVE    = '0'.
        SCREEN-INPUT     = '0'.
      ENDIF.

    ENDIF.

    IF SCREEN-NAME = 'BACK_TO_QUOTATION_LIST' OR
       SCREEN-NAME = 'SELECT_QUOVER' OR
       SCREEN-NAME = 'SEND_MESSAGE' OR
       SCREEN-NAME = 'GV_QUOMSG_CONTENT'.
      SCREEN-INPUT = '1'.
    ENDIF.

    IF SCREEN-NAME = 'GS_QUOTATION_DETAIL-QUOTATION_CODE' OR
       SCREEN-NAME = 'GS_QUOTATION_DETAIL-CUSTOMER' OR
       SCREEN-NAME = 'GS_QUOTATION_DETAIL-STATUS'.
      SCREEN-INTENSIFIED = '1'.
    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.

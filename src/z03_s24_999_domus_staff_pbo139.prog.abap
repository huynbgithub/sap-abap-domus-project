*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DOMUS_STAFF_PBO139
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module ADJUST_TABLE_LINE_0139 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE ADJUST_TABLE_LINE_0139 OUTPUT.
  QVSPRV_TABLE_CONTROL-LINES = LINES( GT_QVSPRV ).
  QVSSER_TABLE_CONTROL-LINES = LINES( GT_QVSSER ).
  QUOMSG_TABLE_CONTROL-LINES = LINES( GT_QUOMSG ).
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module RELOAD_QUOMSG_0139 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE RELOAD_QUOMSG_0139 OUTPUT.
  PERFORM GET_QUOMSG_ITEMS USING GV_QUOTATION_ID.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CALCULATE_TOTAL_PRICE_0139 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CALCULATE_TOTAL_PRICE_0139 OUTPUT.
  GV_QVSPRV_TOTAL_PRICE = 0.
  LOOP AT GT_QVSPRV INTO DATA(LS_QVSPRV_ROW).
    LS_QVSPRV_ROW-TOTAL_PRICE = LS_QVSPRV_ROW-PRICE * LS_QVSPRV_ROW-QUANTITY.
    MODIFY TABLE GT_QVSPRV FROM LS_QVSPRV_ROW.

    GV_QVSPRV_TOTAL_PRICE += LS_QVSPRV_ROW-TOTAL_PRICE.
  ENDLOOP.

  GV_QVSSER_TOTAL_PRICE = 0.
  LOOP AT GT_QVSSER INTO DATA(LS_QVSSE_ROW).
    GV_QVSSER_TOTAL_PRICE += LS_QVSSE_ROW-PRICE.
  ENDLOOP.

  GV_QUOVER_TOTAL_PRICE = 0.
  GV_QUOVER_TOTAL_PRICE = GV_QVSPRV_TOTAL_PRICE + GV_QVSSER_TOTAL_PRICE.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_QUOTATION_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_QUOTATION_SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE GV_QUOTATION_SCREEN_MODE.
* Display Mode
      WHEN GC_QUOTATION_MODE_DISPLAY.
        SCREEN-INPUT = '0'.

        IF SCREEN-NAME = 'BACK_TO_QUOTATION_LIST' OR
           SCREEN-NAME = 'DISPLAY<->CHANGE' OR
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

        IF SCREEN-NAME = 'INSERT_QVSPRV' OR
           SCREEN-NAME = 'DELETE_QVSPRV' OR
           SCREEN-NAME = 'INSERT_QVSSER' OR
           SCREEN-NAME = 'DELETE_QVSSER'.

          SCREEN-INVISIBLE = '1'.
          SCREEN-ACTIVE    = '0'.
          SCREEN-INPUT     = '0'.
        ENDIF.

* Change Mode
      WHEN GC_QUOTATION_MODE_CHANGE.
        SCREEN-INPUT = '0'.

        IF SCREEN-NAME = 'GS_QUOTATION_DETAIL-QUOVER_VERSION_ORDER' OR
           SCREEN-NAME = 'GS_QUOTATION_DETAIL-QUOVER_CREATED_ON' OR
           SCREEN-NAME = 'GS_QUOTATION_DETAIL-QUOVER_CREATED_AT' OR
           SCREEN-NAME = 'VERSION_TEXT' OR
           SCREEN-NAME = 'CREATED_ON_TEXT' OR
           SCREEN-NAME = 'CREATED_AT_TEXT' OR
           SCREEN-NAME = 'MSG_TITLE_TEXT' OR
           SCREEN-NAME = 'GV_QUOMSG_CONTENT' OR
           SCREEN-NAME = 'SEND_MESSAGE' OR
           SCREEN-NAME = 'SELECT_QUOVER'.

          SCREEN-INVISIBLE = '1'.
          SCREEN-ACTIVE    = '0'.
          SCREEN-INPUT     = '0'.
        ENDIF.

        IF SCREEN-NAME = 'INSERT_QVSPRV' OR
           SCREEN-NAME = 'DELETE_QVSPRV' OR
           SCREEN-NAME = 'INSERT_QVSSER' OR
           SCREEN-NAME = 'DELETE_QVSSER'.

          SCREEN-INVISIBLE = '0'.
          SCREEN-ACTIVE    = '1'.
          SCREEN-INPUT     = '1'.
        ENDIF.

        IF SCREEN-NAME = 'DISPLAY<->CHANGE' OR
           SCREEN-NAME = 'GS_QVSPRV-PRICE' OR
           SCREEN-NAME = 'GS_QVSPRV-QUANTITY' OR
           SCREEN-NAME = 'GS_QVSSER-PRICE'.
          SCREEN-INPUT = '1'.
        ENDIF.

        IF SCREEN-NAME = 'GS_QUOTATION_DETAIL-QUOTATION_CODE' OR
           SCREEN-NAME = 'GS_QUOTATION_DETAIL-CUSTOMER' OR
           SCREEN-NAME = 'GS_QUOTATION_DETAIL-STATUS'.
          SCREEN-INTENSIFIED = '1'.
        ENDIF.
* Create Mode
      WHEN GC_QUOTATION_MODE_CREATE.

      WHEN OTHERS.
    ENDCASE.

    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_QVSPRV_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_QVSPRV_SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF QVSPRV_TABLE_CONTROL-LINES <> 0.
      CASE GV_QUOTATION_SCREEN_MODE.
        WHEN GC_QUOTATION_MODE_DISPLAY.
          SCREEN-INPUT = '0'.
        WHEN GC_QUOTATION_MODE_CHANGE.
          SCREEN-INPUT = '0'.
          IF SCREEN-NAME = 'GS_QVSPRV-SEL'.
            SCREEN-INPUT = '1'.
          ENDIF.
          IF SCREEN-NAME = 'GS_QVSPRV-PRICE' OR SCREEN-NAME = 'GS_QVSPRV-QUANTITY'.
            SCREEN-INPUT = '1'.
            SCREEN-REQUIRED = '2'.
          ENDIF.
        WHEN GC_QUOTATION_MODE_CREATE.
          SCREEN-INPUT = '0'.
          IF SCREEN-NAME = 'GS_QVSPRV-SEL'.
            SCREEN-INPUT = '1'.
          ENDIF.
          IF SCREEN-NAME = 'GS_QVSPRV-PRICE' OR  SCREEN-NAME = 'GS_QVSPRV-QUANTITY'.
            SCREEN-INPUT = '1'.
            SCREEN-REQUIRED = '2'.
          ENDIF.
        WHEN OTHERS.
      ENDCASE.

    ELSE.
      SCREEN-INPUT     = '0'.
    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_QVSSER_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_QVSSER_SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF QVSSER_TABLE_CONTROL-LINES <> 0.
      CASE GV_QUOTATION_SCREEN_MODE.
        WHEN GC_QUOTATION_MODE_DISPLAY.
          SCREEN-INPUT = '0'.
        WHEN GC_QUOTATION_MODE_CHANGE.
          SCREEN-INPUT = '0'.
          IF SCREEN-NAME = 'GS_QVSSER-SEL'.
            SCREEN-INPUT = '1'.
          ENDIF.
          IF SCREEN-NAME = 'GS_QVSSER-PRICE'.
            SCREEN-INPUT = '1'.
            SCREEN-REQUIRED = '2'.
          ENDIF.
        WHEN GC_QUOTATION_MODE_CREATE.
          SCREEN-INPUT = '0'.
          IF SCREEN-NAME = 'GS_QVSSER-SEL'.
            SCREEN-INPUT = '1'.
          ENDIF.
          IF SCREEN-NAME = 'GS_QVSSER-PRICE'.
            SCREEN-INPUT = '1'.
            SCREEN-REQUIRED = '2'.
          ENDIF.
        WHEN OTHERS.
      ENDCASE.

    ELSE.
      SCREEN-INPUT     = '0'.
    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_QUOMSG_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_QUOMSG_SCREEN OUTPUT.
  LOOP AT SCREEN.
    SCREEN-INPUT = '0'.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.

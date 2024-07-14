*&---------------------------------------------------------------------*
*& Include          Z03_S24_CUST_PBO200
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Module CALCULATE_TOTAL_PRICE_0200 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CALCULATE_TOTAL_PRICE_0200 OUTPUT.
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

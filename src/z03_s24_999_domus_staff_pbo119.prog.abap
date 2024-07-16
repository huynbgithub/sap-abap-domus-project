*----------------------------------------------------------------------*
***INCLUDE Z03_S24_999_DOMUS_STAFF_PBO119.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module ADJUST_TABLE_LINE_0119 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE ADJUST_TABLE_LINE_0119 OUTPUT.
  PROVRT_TABLE_CONTROL-LINES = LINES( GT_PROVRT ).
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_PRODUCT_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_PRODUCT_SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE GV_PRODUCT_SCREEN_MODE.
* Display Mode
      WHEN GC_PRODUCT_MODE_DISPLAY.
        SCREEN-INPUT = '0'.

        IF SCREEN-NAME = 'BACK_TO_PRODUCT_LIST'.
          SCREEN-INPUT = '1'.
        ENDIF.

        IF SCREEN-NAME = 'DISPLAY<->CHANGE'.
          SCREEN-INPUT = '1'.
        ENDIF.

        IF SCREEN-NAME = 'GS_PRODUCT_DETAIL-NAME'.
          SCREEN-INTENSIFIED = '1'.
        ENDIF.

        IF SCREEN-NAME = 'SEARCH_PROCAT'.

          SCREEN-INVISIBLE = '1'.
          SCREEN-ACTIVE    = '0'.
          SCREEN-INPUT     = '0'.
        ENDIF.

        IF SCREEN-NAME = 'INSERT_PROVRT' OR
           SCREEN-NAME = 'DELETE_PROVRT'.

          SCREEN-INVISIBLE = '0'.
          SCREEN-ACTIVE    = '1'.
          SCREEN-INPUT     = '1'.
        ENDIF.
* Change Mode
      WHEN GC_PRODUCT_MODE_CHANGE.
        SCREEN-INPUT = '0'.

        IF SCREEN-NAME = 'BACK_TO_PRODUCT_LIST'.
          SCREEN-INPUT = '0'.
        ENDIF.

        IF SCREEN-NAME = 'DISPLAY<->CHANGE'.
          SCREEN-INPUT = '1'.
        ENDIF.

        IF SCREEN-NAME = 'GS_PRODUCT_DETAIL-PRODUCT_NAME' OR
           SCREEN-NAME = 'GS_PRODUCT_DETAIL-BRAND'.
          SCREEN-INPUT = '1'.
        ENDIF.

        IF SCREEN-NAME = 'SEARCH_PROCAT'.

          SCREEN-INVISIBLE = '0'.
          SCREEN-ACTIVE    = '1'.
          SCREEN-INPUT     = '1'.
        ENDIF.

        IF SCREEN-NAME = 'INSERT_PROVRT' OR
           SCREEN-NAME = 'DELETE_PROVRT'.

          SCREEN-INVISIBLE = '1'.
          SCREEN-ACTIVE    = '0'.
          SCREEN-INPUT     = '0'.
        ENDIF.
* Create Mode
      WHEN GC_PRODUCT_MODE_CREATE.

      WHEN OTHERS.
    ENDCASE.

    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_PROVRT_SCREEN_FOR_TABLE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_PROVRT_SCREEN OUTPUT.
  LOOP AT SCREEN.
    IF PROVRT_TABLE_CONTROL-LINES <> 0.
      CASE GV_PRODUCT_SCREEN_MODE.
        WHEN GC_PRODUCT_MODE_DISPLAY.
          SCREEN-INPUT = '0'.
          IF SCREEN-NAME = 'GS_PROVRT-SEL'.
            SCREEN-INPUT     = '1'.
          ENDIF.

        WHEN GC_PRODUCT_MODE_CHANGE.
          SCREEN-INPUT = '0'.
          IF SCREEN-NAME = 'GS_PROVRT-DISPLAY_PRICE'.
            SCREEN-INPUT     = '1'.
          ENDIF.

        WHEN GC_PRODUCT_MODE_CREATE.

        WHEN OTHERS.
      ENDCASE.

    ELSE.
      WRITE '' TO GS_PROVRT-CREATED_AT.
      SCREEN-INPUT = '0'.

    ENDIF.

    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.

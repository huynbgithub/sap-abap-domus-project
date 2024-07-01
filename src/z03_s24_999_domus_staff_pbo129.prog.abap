*----------------------------------------------------------------------*
***INCLUDE Z03_S24_999_DOMUS_STAFF_PBO129.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module PREPARE_DATA_0129 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE PREPARE_DATA_0129 OUTPUT.
  PCKPRV_TABLE_CONTROL-LINES = LINES( GT_PCKPRV ).
  PCKSER_TABLE_CONTROL-LINES = LINES( GT_PCKSER ).
  PCKIMG_TABLE_CONTROL-LINES = LINES( GT_PCKIMG ).
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_PACKAGE_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_PACKAGE_SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE GV_PACKAGE_SCREEN_MODE.
      WHEN GC_PACKAGE_MODE_DISPLAY.

        SCREEN-INPUT = '0'.

        IF SCREEN-NAME = 'BACK_TO_PACKAGE_LIST'.

          SCREEN-INPUT = '1'.
        ENDIF.

        IF SCREEN-NAME = 'DISPLAY<->CHANGE'.

          SCREEN-INPUT = '1'.
        ENDIF.

        IF SCREEN-NAME = 'INSERT_PCKPRV' OR
           SCREEN-NAME = 'DELETE_PCKPRV' OR
           SCREEN-NAME = 'INSERT_PCKSER' OR
           SCREEN-NAME = 'DELETE_PCKSER' OR
           SCREEN-NAME = 'INSERT_PCKIMG' OR
           SCREEN-NAME = 'DELETE_PCKIMG'.

           SCREEN-INVISIBLE = '1'.
           SCREEN-ACTIVE    = '0'.
           SCREEN-INPUT     = '0'.
        ENDIF.

        IF SCREEN-NAME = 'OPEN_PCKIMG_URL'.

          SCREEN-INPUT = '1'.
        ENDIF.

      WHEN GC_PACKAGE_MODE_CHANGE.

        SCREEN-INPUT = '1'.

        IF SCREEN-NAME = 'BACK_TO_PACKAGE_LIST'.
          SCREEN-INPUT = '0'.
        ENDIF.

        IF SCREEN-NAME = 'INSERT_PCKPRV' OR
           SCREEN-NAME = 'DELETE_PCKPRV' OR
           SCREEN-NAME = 'INSERT_PCKSER' OR
           SCREEN-NAME = 'DELETE_PCKSER' OR
           SCREEN-NAME = 'INSERT_PCKIMG' OR
           SCREEN-NAME = 'DELETE_PCKIMG'.

           SCREEN-INVISIBLE = '0'.
           SCREEN-ACTIVE    = '1'.
           SCREEN-INPUT     = '1'.
        ENDIF.

        SCREEN-REQUIRED = '1'.

        IF SCREEN-NAME = 'GS_PACKAGE_DETAIL-ID'.
          SCREEN-INPUT = '0'.
        ENDIF.

        IF SCREEN-NAME = 'OPEN_PCKIMG_URL'.

          SCREEN-INPUT = '0'.
        ENDIF.
      WHEN GC_PACKAGE_MODE_CREATE.

        SCREEN-INPUT = '1'.

        IF SCREEN-NAME = 'BACK_TO_PACKAGE_LIST'.
          SCREEN-INPUT = '0'.
        ENDIF.

        IF SCREEN-NAME = 'DISPLAY<->CHANGE'.

          SCREEN-INPUT = '0'.
        ENDIF.

        IF SCREEN-NAME = 'INSERT_PCKPRV' OR
           SCREEN-NAME = 'DELETE_PCKPRV' OR
           SCREEN-NAME = 'INSERT_PCKSER' OR
           SCREEN-NAME = 'DELETE_PCKSER' OR
           SCREEN-NAME = 'INSERT_PCKIMG' OR
           SCREEN-NAME = 'DELETE_PCKIMG'.

           SCREEN-INVISIBLE = '0'.
           SCREEN-ACTIVE    = '1'.
           SCREEN-INPUT     = '1'.
        ENDIF.

        SCREEN-REQUIRED = '1'.

        IF SCREEN-NAME = 'GS_PACKAGE_DETAIL-ID'.
          SCREEN-INPUT = '0'.
        ENDIF.

        IF SCREEN-NAME = 'OPEN_PCKIMG_URL'.

          SCREEN-INPUT = '0'.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.

    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_PACKAGE_PRODUCT_VARIANT_SCREEN_FOR_TABLE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_PCKPRV_SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE GV_PACKAGE_SCREEN_MODE.
      WHEN GC_PACKAGE_MODE_DISPLAY.
        SCREEN-INPUT = '0'.
      WHEN GC_PACKAGE_MODE_CHANGE.
        SCREEN-INPUT = '0'.
        IF SCREEN-NAME = 'GS_PCKPRV-SEL' OR SCREEN-NAME = 'GS_PCKPRV-QUANTITY'.
          SCREEN-INPUT = '1'.
        ENDIF.
      WHEN GC_PACKAGE_MODE_CREATE.
        SCREEN-INPUT = '0'.
        IF SCREEN-NAME = 'GS_PCKPRV-SEL' OR SCREEN-NAME = 'GS_PCKPRV-QUANTITY'.
          SCREEN-INPUT = '1'.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_PACKAGE_SERVICE_SCREEN_FOR_TABLE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_PCKSER_SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE GV_PACKAGE_SCREEN_MODE.
      WHEN GC_PACKAGE_MODE_DISPLAY.
        SCREEN-INPUT = '0'.
      WHEN GC_PACKAGE_MODE_CHANGE.
        SCREEN-INPUT = '0'.
        IF SCREEN-NAME = 'GS_PCKSER-SEL'.
          SCREEN-INPUT = '1'.
        ENDIF.
      WHEN GC_PACKAGE_MODE_CREATE.
        SCREEN-INPUT = '0'.
        IF SCREEN-NAME = 'GS_PCKSER-SEL'.
          SCREEN-INPUT = '1'.
        ENDIF.
      WHEN OTHERS.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_PACKAGE_IMAGE_SCREEN_FOR_TABLE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_PCKIMG_SCREEN OUTPUT.
  LOOP AT SCREEN.
    CASE GV_PACKAGE_SCREEN_MODE.
      WHEN GC_PACKAGE_MODE_DISPLAY.
        SCREEN-INPUT = '0'.
        IF SCREEN-NAME = 'GS_PCKIMG-SEL'.
           SCREEN-INPUT     = '1'.
        ENDIF.
      WHEN GC_PACKAGE_MODE_CHANGE.

      WHEN GC_PACKAGE_MODE_CREATE.

      WHEN OTHERS.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.

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
        IF SCREEN-NAME = 'INSERT' OR SCREEN-NAME = 'DELETE'.
          SCREEN-ACTIVE = '0'.
        ENDIF.
      WHEN GC_PACKAGE_MODE_CHANGE.
        IF SCREEN-NAME = 'BACK_TO_PACKAGE_LIST'.
          SCREEN-INPUT = '0'.
        ENDIF.
        SCREEN-REQUIRED = '1'.
        IF SCREEN-NAME = 'GS_PACKGE-ID'.
          SCREEN-INPUT = '0'.
        ENDIF.
      WHEN GC_PACKAGE_MODE_CREATE.
        IF SCREEN-NAME = 'BACK_TO_PACKAGE_LIST'.
          SCREEN-INPUT = '0'.
        ENDIF.
        SCREEN-REQUIRED = '1'.
*        IF SCREEN-NAME = 'GS_PURORD-PURCHASE_ORDER'.
*          SCREEN-REQUIRED = '0'.
*        ENDIF.
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

      WHEN GC_PACKAGE_MODE_CREATE.

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

      WHEN GC_PACKAGE_MODE_CREATE.

      WHEN OTHERS.
    ENDCASE.
    MODIFY SCREEN.
  ENDLOOP.
ENDMODULE.

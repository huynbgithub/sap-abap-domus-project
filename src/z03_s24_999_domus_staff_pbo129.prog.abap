*----------------------------------------------------------------------*
***INCLUDE Z03_S24_999_DOMUS_STAFF_PBO129.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module ADJUST_TABLE_LINE_0129 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE ADJUST_TABLE_LINE_0129 OUTPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB2 AND G_ZTAB_001-SUBSCREEN = '0129'.
    PCKPRV_TABLE_CONTROL-LINES = LINES( GT_PCKPRV ).
    PCKSER_TABLE_CONTROL-LINES = LINES( GT_PCKSER ).
    PCKIMG_TABLE_CONTROL-LINES = LINES( GT_PCKIMG ).
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module CALCULATE_TOTAL_PRICE_0129 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE CALCULATE_TOTAL_PRICE_0129 OUTPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB2 AND G_ZTAB_001-SUBSCREEN = '0129'.
    GV_PCKPRV_TOTAL_PRICE = 0.
    LOOP AT GT_PCKPRV INTO DATA(LS_PCKPRV_ROW).
      LS_PCKPRV_ROW-TOTAL_PRICE = LS_PCKPRV_ROW-DISPLAY_PRICE * LS_PCKPRV_ROW-QUANTITY.
      MODIFY TABLE GT_PCKPRV FROM LS_PCKPRV_ROW.

      GV_PCKPRV_TOTAL_PRICE += LS_PCKPRV_ROW-TOTAL_PRICE.
    ENDLOOP.

    GV_PCKSER_TOTAL_PRICE = 0.
    LOOP AT GT_PCKSER INTO DATA(LS_PCKSE_ROW).
      GV_PCKSER_TOTAL_PRICE += LS_PCKSE_ROW-DISPLAY_PRICE.
    ENDLOOP.

    GV_PACKAGE_TOTAL_PRICE = 0.
    GV_PACKAGE_TOTAL_PRICE = GV_PCKPRV_TOTAL_PRICE + GV_PCKSER_TOTAL_PRICE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_PACKAGE_SCREEN OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_PACKAGE_SCREEN OUTPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB2 AND G_ZTAB_001-SUBSCREEN = '0129'.
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

          IF SCREEN-NAME = 'GS_PACKAGE_DETAIL-NAME'.
            SCREEN-INTENSIFIED = '1'.
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

          IF SCREEN-NAME = 'GS_PACKAGE_DETAIL-ID'.
            SCREEN-INPUT = '0'.
          ENDIF.

          IF SCREEN-NAME = 'GS_PACKAGE_DETAIL-NAME' OR SCREEN-NAME = 'GS_PACKAGE_DETAIL-DESCRIPTION'.
            SCREEN-REQUIRED = '2'.
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

*        SCREEN-REQUIRED = '1'.

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
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_PACKAGE_PRODUCT_VARIANT_SCREEN_FOR_TABLE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_PCKPRV_SCREEN OUTPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB2 AND G_ZTAB_001-SUBSCREEN = '0129'.
    LOOP AT SCREEN.
      IF PCKPRV_TABLE_CONTROL-LINES <> 0.
        CASE GV_PACKAGE_SCREEN_MODE.
          WHEN GC_PACKAGE_MODE_DISPLAY.
            SCREEN-INPUT = '0'.
          WHEN GC_PACKAGE_MODE_CHANGE.
            SCREEN-INPUT = '0'.
            IF SCREEN-NAME = 'GS_PCKPRV-SEL'.
              SCREEN-INPUT = '1'.
            ENDIF.
            IF SCREEN-NAME = 'GS_PCKPRV-QUANTITY'.
              SCREEN-INPUT = '1'.
              SCREEN-REQUIRED = '2'.
            ENDIF.
          WHEN GC_PACKAGE_MODE_CREATE.
            SCREEN-INPUT = '0'.
            IF SCREEN-NAME = 'GS_PCKPRV-SEL' OR SCREEN-NAME = 'GS_PCKPRV-QUANTITY'.
              SCREEN-INPUT = '1'.
            ENDIF.
          WHEN OTHERS.
        ENDCASE.

      ELSE.
        SCREEN-INPUT     = '0'.
      ENDIF.

      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_PACKAGE_SERVICE_SCREEN_FOR_TABLE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_PCKSER_SCREEN OUTPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB2 AND G_ZTAB_001-SUBSCREEN = '0129'.
    LOOP AT SCREEN.
      IF PCKSER_TABLE_CONTROL-LINES <> 0.
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

      ELSE.
        SCREEN-INPUT     = '0'.
      ENDIF.

      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module MODIFY_PACKAGE_IMAGE_SCREEN_FOR_TABLE OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE MODIFY_PCKIMG_SCREEN OUTPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB2 AND G_ZTAB_001-SUBSCREEN = '0129'.
    LOOP AT SCREEN.
      IF PCKIMG_TABLE_CONTROL-LINES <> 0.
        CASE GV_PACKAGE_SCREEN_MODE.
          WHEN GC_PACKAGE_MODE_DISPLAY.
            SCREEN-INPUT = '0'.
            IF SCREEN-NAME = 'GS_PCKIMG-SEL'.
              SCREEN-INPUT     = '1'.
            ENDIF.

          WHEN GC_PACKAGE_MODE_CHANGE.
            IF SCREEN-NAME = 'GS_PCKIMG-IMAGE_URL'.
              SCREEN-REQUIRED = '2'.
            ENDIF.

          WHEN GC_PACKAGE_MODE_CREATE.

          WHEN OTHERS.
        ENDCASE.

      ELSE.
        SCREEN-INPUT     = '0'.
      ENDIF.

      MODIFY SCREEN.
    ENDLOOP.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*& Module PREPARE_IMAGES_0129 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE PREPARE_IMAGES_0129 OUTPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB2 AND G_ZTAB_001-SUBSCREEN = '0129'.
    PCKIMG_URL = GT_PCKIMG[ 1 ]-IMAGE_URL.

    IF PCKIMG_CONTROL_1 IS INITIAL.

* Create controls
      CREATE OBJECT PCKIMG_CONTAINER_1
        EXPORTING
          CONTAINER_NAME = 'CUSTOM_CONTROL_0129'.

      CREATE OBJECT PCKIMG_CONTROL_1 EXPORTING PARENT = PCKIMG_CONTAINER_1.

* Register the events
      PCKIMG_EVENT_TAB_LINE-EVENTID = CL_GUI_PICTURE=>EVENTID_PICTURE_DBLCLICK.
      APPEND PCKIMG_EVENT_TAB_LINE TO PCKIMG_EVENT_TAB.
      PCKIMG_EVENT_TAB_LINE-EVENTID = CL_GUI_PICTURE=>EVENTID_CONTEXT_MENU.
      APPEND PCKIMG_EVENT_TAB_LINE TO PCKIMG_EVENT_TAB.
      PCKIMG_EVENT_TAB_LINE-EVENTID = CL_GUI_PICTURE=>EVENTID_CONTEXT_MENU_SELECTED.
      APPEND PCKIMG_EVENT_TAB_LINE TO PCKIMG_EVENT_TAB.

      CALL METHOD PCKIMG_CONTROL_1->SET_REGISTERED_EVENTS
        EXPORTING
          EVENTS = PCKIMG_EVENT_TAB.

* Create the event_receiver object and set the handlers for the events
* of the picture controls
      CREATE OBJECT PCKIMG_EVENT_RECEIVER.
      SET HANDLER PCKIMG_EVENT_RECEIVER->EVENT_HANDLER_PICTURE_DBLCLICK
                  FOR PCKIMG_CONTROL_1.

* Set the display mode to 'normal' (0)
      CALL METHOD PCKIMG_CONTROL_1->SET_DISPLAY_MODE
        EXPORTING
          DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_NORMAL.

* Set 3D Border
      CALL METHOD PCKIMG_CONTROL_1->SET_3D_BORDER
        EXPORTING
          BORDER = 1.

      CALL METHOD PCKIMG_CONTROL_1->SET_DISPLAY_MODE
        EXPORTING
          DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.

    ENDIF.

    CALL METHOD PCKIMG_CONTROL_1->LOAD_PICTURE_FROM_URL_ASYNC
      EXPORTING
        URL = PCKIMG_URL.
  ENDIF.
ENDMODULE.

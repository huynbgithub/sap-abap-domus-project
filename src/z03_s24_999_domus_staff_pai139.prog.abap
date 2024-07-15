*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DOMUS_STAFF_PAI139
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  MODIFY_QVSPRV_TABLE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE MODIFY_QVSPRV_TABLE INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB3 AND G_ZTAB_001-SUBSCREEN = '0139'.
    MODIFY GT_QVSPRV FROM GS_QVSPRV INDEX QVSPRV_TABLE_CONTROL-CURRENT_LINE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MODIFY_QVSSER_TABLE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE MODIFY_QVSSER_TABLE INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB3 AND G_ZTAB_001-SUBSCREEN = '0139'.
    MODIFY GT_QVSSER FROM GS_QVSSER INDEX QVSSER_TABLE_CONTROL-CURRENT_LINE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MODIFY_QUOMSG_TABLE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE MODIFY_QUOMSG_TABLE INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB3 AND G_ZTAB_001-SUBSCREEN = '0139'.
    MODIFY GT_QUOMSG FROM GS_QUOMSG INDEX QUOMSG_TABLE_CONTROL-CURRENT_LINE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0139  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0139 INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB3 AND G_ZTAB_001-SUBSCREEN = '0139'.
    PERFORM HANDLE_UCOMM_0139
    USING GV_OKCODE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_QVSPRV_INPUTS_0139  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_QVSPRV_INPUTS_0139 INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB3 AND G_ZTAB_001-SUBSCREEN = '0139'.
    IF GV_VALIDATION_BYPASSED <> ABAP_TRUE.
      IF GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CHANGE OR GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CREATE.
        PERFORM CHECK_QVSPRV_QUANTITY.
        PERFORM CHECK_QVSPRV_PRICE.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_QVSSER_INPUTS_0139  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_QVSSER_INPUTS_0139 INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB3 AND G_ZTAB_001-SUBSCREEN = '0139'.
    IF GV_VALIDATION_BYPASSED <> ABAP_TRUE.
      IF GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CHANGE OR GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CREATE.
        PERFORM CHECK_QVSSER_PRICE.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_QUOMSG_CONTENT_0139  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_QUOMSG_CONTENT_0139 INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB3 AND G_ZTAB_001-SUBSCREEN = '0139'.
    IF GV_VALIDATION_BYPASSED <> ABAP_TRUE.
      IF GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_DISPLAY.
        IF GV_OKCODE = 'SEND_MESSAGE'.
          PERFORM CHECK_QUOMSG_CONTENT.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMODULE.

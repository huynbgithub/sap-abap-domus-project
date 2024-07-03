*----------------------------------------------------------------------*
***INCLUDE Z03_S24_999_DOMUS_STAFF_PAI129.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0129  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0129 INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB2.
    PERFORM HANDLE_UCOMM_0129
    USING GV_OKCODE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  UCOMM_BYPASS_REQUIRED_0129  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE UCOMM_BYPASS_REQUIRED_0129 INPUT.
* Handle user commands that have to bypass required input field in 0129 Screen
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB2.
    PERFORM HANDLE_UC_BYPASS_REQUIRED_0129
    USING GV_OKCODE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MODIFY_PCKPRV_TABLE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE MODIFY_PCKPRV_TABLE INPUT.
  MODIFY GT_PCKPRV FROM GS_PCKPRV INDEX PCKPRV_TABLE_CONTROL-CURRENT_LINE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MODIFY_PCKSER_TABLE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE MODIFY_PCKSER_TABLE INPUT.
  MODIFY GT_PCKSER FROM GS_PCKSER INDEX PCKSER_TABLE_CONTROL-CURRENT_LINE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MODIFY_PCKIMG_TABLE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE MODIFY_PCKIMG_TABLE INPUT.
  MODIFY GT_PCKIMG FROM GS_PCKIMG INDEX PCKIMG_TABLE_CONTROL-CURRENT_LINE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_PACKAGE_NAME_0129  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_PACKAGE_NAME_0129 INPUT.
  IF GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_CHANGE OR GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_CREATE.
    PERFORM CHECK_PACKAGE_DETAIL_NAME.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_PCK_DESCRIPTION_0129  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_PCK_DESCRIPTION_0129 INPUT.
  IF GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_CHANGE OR GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_CREATE.
    PERFORM CHECK_PCK_DETAIL_DESCRIPTION.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_PCKPRV_INPUTS_0129  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_PCKPRV_INPUTS_0129 INPUT.
  IF GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_CHANGE OR GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_CREATE.
    PERFORM CHECK_PCKPRV_QUANTITY.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_PCKSER_INPUTS_0129  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_PCKSER_INPUTS_0129 INPUT.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_PCKIMG_INPUTS_0129  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_PCKIMG_INPUTS_0129 INPUT.
  IF GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_CHANGE OR GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_CREATE.
    PERFORM CHECK_PCKIMG_URL.
  ENDIF.
ENDMODULE.

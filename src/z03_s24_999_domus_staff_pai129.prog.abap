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

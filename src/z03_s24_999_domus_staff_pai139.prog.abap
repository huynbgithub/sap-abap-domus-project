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

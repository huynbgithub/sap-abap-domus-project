*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DOMUS_STAFF_PAI120
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0120  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0120 INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB2 AND G_ZTAB_001-SUBSCREEN = '0120'.
    PERFORM HANDLE_UCOMM_0120
    USING GV_OKCODE.
  ENDIF.
ENDMODULE.

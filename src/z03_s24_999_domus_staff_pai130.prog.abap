*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DOMUS_STAFF_PAI130
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0130  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0130 INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB3 AND G_ZTAB_001-SUBSCREEN = '0130'.
    PERFORM HANDLE_UCOMM_0130
    USING GV_OKCODE.
  ENDIF.
ENDMODULE.

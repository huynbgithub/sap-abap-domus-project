*----------------------------------------------------------------------*
***INCLUDE Z03_S24_999_DOMUS_STAFF_PAI134.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0134  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0134 INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB3.
    PERFORM HANDLE_UCOMM_0134
    USING GV_OKCODE_0134.
  ENDIF.
ENDMODULE.

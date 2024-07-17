*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DOMUS_STAFF_PAI200
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0200  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0200 INPUT.
    PERFORM HANDLE_UCOMM_0200
    USING GV_OKCODE.
ENDMODULE.

MODULE EXIT_COMMAND_200_EVENT INPUT.
  PERFORM HANDLE_EXIT_COMMAND
  USING SY-UCOMM.
ENDMODULE.

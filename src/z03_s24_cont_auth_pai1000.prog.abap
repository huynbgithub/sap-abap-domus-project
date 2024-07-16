*&---------------------------------------------------------------------*
*& Include          Z03_S24_CONT_AUTH_PAI1000
*&---------------------------------------------------------------------*

MODULE EXIT_COMMAND_1000_EVENT INPUT.
  PERFORM HANDLE_EXIT_COMMAND
  USING SY-UCOMM.
ENDMODULE.

MODULE USER_COMMAND_1000 INPUT.
  PERFORM HANDLE_UCOMM_1000
  USING GV_OKCODE
        GV_USERNAME.
ENDMODULE.

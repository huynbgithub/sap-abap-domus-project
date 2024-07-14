*&---------------------------------------------------------------------*
*& Include          Z03_S24_CUST_PAI100
*&---------------------------------------------------------------------*

MODULE USER_COMMAND_0100 INPUT.
    PERFORM HANDLE_UCOMM_0100
    USING GV_OKCODE.
ENDMODULE.

MODULE EXIT_COMMAND_100_EVENT INPUT.
  PERFORM HANDLE_EXIT_COMMAND
  USING SY-UCOMM.
ENDMODULE.

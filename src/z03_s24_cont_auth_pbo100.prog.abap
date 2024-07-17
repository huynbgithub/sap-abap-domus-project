*&---------------------------------------------------------------------*
*& Include          Z03_S24_CONT_AUTH_PBO100
*&---------------------------------------------------------------------*

MODULE STATUS_0100 OUTPUT.
 SET PF-STATUS 'ZSTATUS_0100'.
 SET TITLEBAR 'ZTITLE_100'.
ENDMODULE.

MODULE SET_INITIAL_VALUES_0100 OUTPUT.
  PERFORM SET_C_CODE_INITIAL_VALUES.
ENDMODULE.

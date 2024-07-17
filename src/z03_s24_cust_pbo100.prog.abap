*&---------------------------------------------------------------------*
*& Include          Z03_S24_CUST_PBO100
*&---------------------------------------------------------------------*

MODULE STATUS_100 OUTPUT.
 SET PF-STATUS 'ZSTATUS_100'.
 SET TITLEBAR 'ZTITLE_CUS_QUOTA'.
ENDMODULE.

MODULE SET_INITIAL_VALUES_0100 OUTPUT.
  PERFORM SET_QCODE_INITIAL_VALUES.
ENDMODULE.

*----------------------------------------------------------------------*
***INCLUDE Z03_S24_CUST_PACKAGE_PBO0160.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module ADJUST_TABLE_LINE_0160 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE ADJUST_TABLE_LINE_0160 OUTPUT.
  PCKPRV_TABLE_CONTROL-LINES = LINES( GT_PCKPRV ).
  PCKSER_TABLE_CONTROL-LINES = LINES( GT_PCKSER ).
  PCKIMG_TABLE_CONTROL-LINES = LINES( GT_PCKIMG ).
ENDMODULE.

*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DOMUS_STAFF_PBO100
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE STATUS_0100 OUTPUT.
 SET PF-STATUS 'ZSTATUS_001'.
 SET TITLEBAR 'ZTITLE_001'.
ENDMODULE.

*&SPWIZARD: OUTPUT MODULE FOR TS 'ZTAB_001'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: SETS ACTIVE TAB
MODULE ZTAB_001_ACTIVE_TAB_SET OUTPUT.
  ZTAB_001-ACTIVETAB = G_ZTAB_001-PRESSED_TAB.
  CASE G_ZTAB_001-PRESSED_TAB.
    WHEN C_ZTAB_001-TAB1.
      G_ZTAB_001-SUBSCREEN = PRODUCT_SCREEN_MODE.
    WHEN C_ZTAB_001-TAB2.
      G_ZTAB_001-SUBSCREEN = PACKAGE_SCREEN_MODE.
    WHEN C_ZTAB_001-TAB3.
      G_ZTAB_001-SUBSCREEN = QUOTATION_SCREEN_MODE.
    WHEN C_ZTAB_001-TAB4.
      G_ZTAB_001-SUBSCREEN = CONTRACT_SCREEN_MODE.
    WHEN C_ZTAB_001-TAB5.
      G_ZTAB_001-SUBSCREEN = '0150'.
    WHEN OTHERS.
*&SPWIZARD:      DO NOTHING
  ENDCASE.
ENDMODULE.

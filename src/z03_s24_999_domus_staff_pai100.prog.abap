*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DOMUS_STAFF_PAI100
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  EXIT_COMMAND_0100_EVENT  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE EXIT_COMMAND_0100_EVENT INPUT.
  PERFORM HANDLE_EXIT_COMMAND
  USING GV_OKCODE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0100 INPUT.
  CLEAR: GV_VALIDATION_BYPASSED.
ENDMODULE.

*&SPWIZARD: INPUT MODULE FOR TS 'ZTAB_001'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: GETS ACTIVE TAB
MODULE ZTAB_001_ACTIVE_TAB_GET INPUT.
  CASE ZTAB_001-ACTIVETAB.
    WHEN C_ZTAB_001-TAB1.
      G_ZTAB_001-PRESSED_TAB = C_ZTAB_001-TAB1.
    WHEN C_ZTAB_001-TAB2.
      G_ZTAB_001-PRESSED_TAB = C_ZTAB_001-TAB2.
    WHEN C_ZTAB_001-TAB3.
      G_ZTAB_001-PRESSED_TAB = C_ZTAB_001-TAB3.
    WHEN C_ZTAB_001-TAB4.
      G_ZTAB_001-PRESSED_TAB = C_ZTAB_001-TAB4.
    WHEN C_ZTAB_001-TAB5.
      G_ZTAB_001-PRESSED_TAB = C_ZTAB_001-TAB5.
    WHEN OTHERS.
*&SPWIZARD:      DO NOTHING
  ENDCASE.
ENDMODULE.
*&SPWIZARD: OUTPUT MODULE FOR TS 'ZTAB_001'. DO NOT CHANGE THIS LINE!
*&SPWIZARD: SETS ACTIVE TAB
MODULE ZTAB_001_ACTIVE_TAB_SET INPUT.
  ZTAB_001-ACTIVETAB = G_ZTAB_001-PRESSED_TAB.
  CASE G_ZTAB_001-PRESSED_TAB.
    WHEN C_ZTAB_001-TAB1.
      G_ZTAB_001-SUBSCREEN = PRODUCT_SCREEN_MODE.
    WHEN C_ZTAB_001-TAB2.
      G_ZTAB_001-SUBSCREEN = PACKAGE_SCREEN_MODE.
    WHEN C_ZTAB_001-TAB3.
      G_ZTAB_001-SUBSCREEN = QUOTATION_SCREEN_MODE.
    WHEN C_ZTAB_001-TAB4.
      G_ZTAB_001-SUBSCREEN = '0140'.
    WHEN C_ZTAB_001-TAB5.
      G_ZTAB_001-SUBSCREEN = '0150'.
    WHEN OTHERS.
*&SPWIZARD:      DO NOTHING
  ENDCASE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  SET_VALIDATION_BYPASSED_VALUE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE SET_VALIDATION_BYPASSED_VALUE INPUT.
  IF GV_OKCODE = 'INSERT_PCKPRV' OR
     GV_OKCODE = 'DELETE_PCKPRV' OR
     GV_OKCODE = 'INSERT_PCKSER' OR
     GV_OKCODE = 'DELETE_PCKSER' OR
     GV_OKCODE = 'INSERT_PCKIMG' OR
     GV_OKCODE = 'DELETE_PCKIMG' OR
     GV_OKCODE = 'INSERT_QVSSER' OR
     GV_OKCODE = 'DELETE_QVSSER' OR
     GV_OKCODE = 'INSERT_QVSPRV' OR
     GV_OKCODE = 'DELETE_QVSPRV' OR
     GV_OKCODE = 'BACK_TO_QUOTA_LIST' OR
     GV_OKCODE = 'BACK_TO_PACKAGE_LIST'.

    GV_VALIDATION_BYPASSED = ABAP_TRUE.
  ENDIF.
ENDMODULE.

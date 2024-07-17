*----------------------------------------------------------------------*
***INCLUDE Z03_S24_CUST_PACKAGE_PAI0170.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0170  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0170 INPUT.
  PERFORM HANDLE_COMMAND_0170
    USING GV_OKCODE_0170.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_PCKPRV_INPUTS_0170  INPUT
*&---------------------------------------------------------------------*
MODULE VALIDATE_PCKPRV_INPUTS_0170 INPUT.
 PERFORM CHECK_PCKPRV_QUANTITY.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Form CHECK_PCKPRV_QUANTITY
*&---------------------------------------------------------------------*
FORM CHECK_PCKPRV_QUANTITY.
  IF GS_PCKPRV-QUANTITY IS INITIAL.
    MESSAGE E014(Z03S24999_DOMUS_MSGS).
    SET CURSOR FIELD 'GS_PCKPRV-QUANTITY' LINE PCKPRV_TABLE_CONTROL_0170-CURRENT_LINE.
  ELSE.
    IF GS_PCKPRV-QUANTITY < 1 OR GS_PCKPRV-QUANTITY > 255.
      MESSAGE E012(Z03S24999_DOMUS_MSGS).
      SET CURSOR FIELD 'GS_PCKPRV-QUANTITY' LINE PCKPRV_TABLE_CONTROL_0170-CURRENT_LINE.
    ENDIF.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Module  MODIFY_PCKPRV_TABLE  INPUT
*&---------------------------------------------------------------------*
MODULE MODIFY_PCKPRV_TABLE INPUT.
  MODIFY GT_PCKPRV_AFTER_MOD FROM GS_PCKPRV INDEX PCKPRV_TABLE_CONTROL_0170-CURRENT_LINE.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MODIFY_PCKSER_TABLE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE MODIFY_PCKSER_TABLE INPUT.
  MODIFY GT_PCKSER_AFTER_MOD FROM GS_PCKSER INDEX PCKSER_TABLE_CONTROL_0170-CURRENT_LINE.
ENDMODULE.

*----------------------------------------------------------------------*
***INCLUDE Z03_S24_999_DOMUS_STAFF_PAI119.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0119  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE USER_COMMAND_0119 INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB1 AND G_ZTAB_001-SUBSCREEN = '0119'.
    PERFORM HANDLE_UCOMM_0119
    USING GV_OKCODE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  MODIFY_PROVRT_TABLE  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE MODIFY_PROVRT_TABLE INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB1 AND G_ZTAB_001-SUBSCREEN = '0119'.
    MODIFY GT_PROVRT FROM GS_PROVRT INDEX PROVRT_TABLE_CONTROL-CURRENT_LINE.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_PRODUCT_NAME_0119  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_PRODUCT_NAME_0119 INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB1 AND G_ZTAB_001-SUBSCREEN = '0119'.
    IF GV_VALIDATION_BYPASSED <> ABAP_TRUE.
      IF GV_PRODUCT_SCREEN_MODE = GC_PRODUCT_MODE_CHANGE OR GV_PRODUCT_SCREEN_MODE = GC_PRODUCT_MODE_CREATE.
        PERFORM CHECK_PRODUCT_DETAIL_NAME.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_PRODUCT_BRAND_0119  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_PRODUCT_BRAND_0119 INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB1 AND G_ZTAB_001-SUBSCREEN = '0119'.
    IF GV_VALIDATION_BYPASSED <> ABAP_TRUE.
      IF GV_PRODUCT_SCREEN_MODE = GC_PRODUCT_MODE_CHANGE OR GV_PRODUCT_SCREEN_MODE = GC_PRODUCT_MODE_CREATE.
        PERFORM CHECK_PRODUCT_DETAIL_BRAND.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_PRODUCT_CATEGORY_0119  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_PRODUCT_CATEGORY_0119 INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB1 AND G_ZTAB_001-SUBSCREEN = '0119'.
    IF GV_VALIDATION_BYPASSED <> ABAP_TRUE.
      IF GV_PRODUCT_SCREEN_MODE = GC_PRODUCT_MODE_CHANGE OR GV_PRODUCT_SCREEN_MODE = GC_PRODUCT_MODE_CREATE.
        PERFORM CHECK_PRODUCT_DETAIL_CATEGORY.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  VALIDATE_PROVRT_INPUTS_0119  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE VALIDATE_PROVRT_INPUTS_0119 INPUT.
  IF ZTAB_001-ACTIVETAB = C_ZTAB_001-TAB1 AND G_ZTAB_001-SUBSCREEN = '0119'.
    IF GV_VALIDATION_BYPASSED <> ABAP_TRUE.
      IF GV_PRODUCT_SCREEN_MODE = GC_PRODUCT_MODE_CHANGE OR GV_PRODUCT_SCREEN_MODE = GC_PRODUCT_MODE_CREATE.
        PERFORM CHECK_PROVRT_PRICE.
      ENDIF.
    ENDIF.
  ENDIF.
ENDMODULE.

*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_PACKAGE_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0130
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&      --> U_QCODE
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0120 USING U_OKCODE
                             U_QCODE.
  DATA: LV_SUCCESS TYPE ABAP_BOOL.
  CASE U_OKCODE.
    WHEN 'EXECUTE'.
* Get data from PACKAGE table
      PERFORM GET_PACKAGE_DATA CHANGING LV_SUCCESS.
      IF LV_SUCCESS = ABAP_FALSE.
        RETURN.
      ENDIF.
* Show PACKAGE ALV
      PERFORM SHOW_PACKAGE_ALV.

      CLEAR: U_OKCODE.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PACKAGE_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_PACKAGE_DATA CHANGING CH_V_SUCCESS TYPE ABAP_BOOL.
  CLEAR: IT_PACKAGE[], CH_V_SUCCESS.

  SELECT *
    FROM Y03S24999_PACKGE
    WHERE NAME IN @P_PKNAME
      AND IS_DELETED <> @ABAP_TRUE
    ORDER BY CREATED_ON DESCENDING, CREATED_AT DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @IT_PACKAGE.

  IF SY-SUBRC <> 0.
    CLEAR IT_PACKAGE[].

    IF O_PACKAGE_CONTAINER IS NOT INITIAL.
      CALL METHOD O_PACKAGE_CONTAINER->FREE.
      CLEAR O_PACKAGE_CONTAINER.
    ENDIF.
    IF O_PACKAGE_ALV_TABLE IS NOT INITIAL.
      CLEAR O_PACKAGE_ALV_TABLE.
    ENDIF.
    IF O_PACKAGE_HANDLER IS NOT INITIAL.
      CLEAR O_PACKAGE_HANDLER.
    ENDIF.

    MESSAGE S004(Z03S24999_DOMUS_MSGS) DISPLAY LIKE 'E'.
    CH_V_SUCCESS = ABAP_FALSE.
    RETURN.
  ELSE.
    CH_V_SUCCESS = ABAP_TRUE.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_PACKAGE_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_PACKAGE_ALV.
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_PACKAGE_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_PACKAGE_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_PACKAGE_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_PACKAGE_FCAT
*&---------------------------------------------------------------------*
FORM ADD_PACKAGE_FCAT USING U_FIELDNAME
                    U_SCRTEXT_M
                    U_OUTPUTLEN
                    U_KEY
                    U_HOTSPOT
                    U_EMPHASIZE
              CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
  DATA: LS_FIELD_CAT TYPE LVC_S_FCAT.
  LS_FIELD_CAT-FIELDNAME = U_FIELDNAME.
  LS_FIELD_CAT-SCRTEXT_M = U_SCRTEXT_M.
  LS_FIELD_CAT-OUTPUTLEN = U_OUTPUTLEN.
  LS_FIELD_CAT-KEY = U_KEY.
  LS_FIELD_CAT-HOTSPOT = U_HOTSPOT.
  LS_FIELD_CAT-EMPHASIZE = U_EMPHASIZE.
  APPEND LS_FIELD_CAT TO CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_PACKAGE_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_PACKAGE_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_PACKAGE_FCAT USING 'NAME'           'Name'              32 '' 'X'  'C500'  CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'DESCRIPTION'    'Description'       64 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'CREATED_BY'     'Created By'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'CREATED_AT'     'Created At'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'CREATED_ON'     'Created On'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'UPDATED_BY'     'Updated By'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'UPDATED_AT'     'Updated At'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'UPDATED_ON'     'Updated On'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_PACKAGE_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_PACKAGE_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_PACKAGE_CONTAINER IS INITIAL.
    O_PACKAGE_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0122' ).
  ENDIF.

  IF O_PACKAGE_ALV_TABLE IS INITIAL.
    O_PACKAGE_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_PACKAGE_CONTAINER ).
  ENDIF.

  O_PACKAGE_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_PACKAGE     " Output Table
      IT_FIELDCATALOG               = CH_T_FIELD_CAT   " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).

  IF O_PACKAGE_HANDLER IS INITIAL.
    O_PACKAGE_HANDLER = NEW CL_PACKAGE_ALV_HANDLER( ).
    SET HANDLER O_PACKAGE_HANDLER->HOTSPOT_CLICK FOR O_PACKAGE_ALV_TABLE.
  ENDIF.

  IF SY-SUBRC = 0.
    MESSAGE S006(Z03S24999_DOMUS_MSGS) WITH 'Package'.
  ELSE.
    MESSAGE E005(Z03S24999_DOMUS_MSGS).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_PACKAGE_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_PACKAGE_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_VARIANT
*&---------------------------------------------------------------------*
*FORM PREPARE_VARIANT CHANGING CH_S_VARIANT TYPE DISVARIANT.
*
*  CH_S_VARIANT-REPORT = SY-REPID.
*  CH_S_VARIANT-HANDLE = 001.
*  CH_S_VARIANT-VARIANT = '/CUSTOM_CONTROL_ALV_0122'.
*
*ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0129
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0129  USING    U_OKCODE.
  CASE U_OKCODE.
    WHEN 'BACK_TO_PACKAGE_LIST'.
      PACKAGE_SCREEN_MODE = '0120'.
      CLEAR: U_OKCODE.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0122
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0122 USING U_OKCODE.
  CASE U_OKCODE.

    WHEN 'VIEW_PACKAGE'.
      DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.

      CALL METHOD O_PACKAGE_ALV_TABLE->GET_SELECTED_ROWS
        IMPORTING
          ET_INDEX_ROWS = LT_INDEX_ROWS.

      READ TABLE IT_PACKAGE INTO DATA(LS_PACKAGE)
           INDEX LT_INDEX_ROWS[ 1 ].

      GV_PACKAGE_ID = LS_PACKAGE-ID.
      PACKAGE_SCREEN_MODE = '0129'.

      PERFORM PREPARE_PACKAGE_DETAIL USING GV_PACKAGE_ID.

      CLEAR: U_OKCODE.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_PACKAGE_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PREPARE_PACKAGE_DETAIL USING U_PACKAGE_ID.
  SELECT SINGLE *
    FROM Y03S24999_PACKGE
    INTO CORRESPONDING FIELDS OF GS_PACKAGE_DETAIL
    WHERE ID = U_PACKAGE_ID AND IS_DELETED <> ABAP_TRUE.

  IF SY-SUBRC <> 0.
    MESSAGE 'Package is not found.' TYPE 'E'.
  ENDIF.

  PERFORM GET_PACKAGE_PRODUCT_ITEMS USING U_PACKAGE_ID.
  PERFORM GET_PACKAGE_SERVICE_ITEMS USING U_PACKAGE_ID.

  GS_PACKAGE_DETAIL_BEFORE_MOD = GS_PACKAGE_DETAIL.
  GT_PCKPRV_BEFORE_MOD = GT_PCKPRV.
  GT_PCKSER_BEFORE_MOD = GT_PCKSER.
  CLEAR: GT_PCKPRV_DELETED.
  CLEAR: GT_PCKSER_DELETED.

  GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_DISPLAY.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PACKAGE_PRODUCT_ITEMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_PACKAGE_ID
*&---------------------------------------------------------------------*
*FORM GET_PACKAGE_PRODUCT_ITEMS USING U_PACKAGE_ID.
*  SELECT ' ' AS SEL,
*         PD~*,
*         S~NAME AS PRODUCT_NAME
*  FROM Y03S24999_PCKSER AS PD
*  JOIN Y03S24999_SERVCE AS S
*  ON PD~PRODUCT_ID = S~ID
*  WHERE S~IS_DELETED <> @ABAP_TRUE
*    AND PD~IS_DELETED <> @ABAP_TRUE
*    AND PD~PACKAGE_ID = @U_PACKAGE_ID
*  INTO CORRESPONDING FIELDS OF TABLE @GT_PCKSER.
*
*  IF SY-SUBRC <> 0.
*    MESSAGE 'No PRODUCT item found.' TYPE 'E'.
*  ENDIF.
*ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PACKAGE_PRODUCT_VARIANT_ITEMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_PACKAGE_ID
*&---------------------------------------------------------------------*
FORM GET_PACKAGE_PRODUCT_ITEMS USING U_PACKAGE_ID.

  DATA: LT_PCKPRV TYPE STANDARD TABLE OF TY_PCKPRV.

  SELECT ' ' AS SEL,
         PCKPRV~*,
         PROVRT~PRODUCT_ID
  FROM Y03S24999_PCKPRV AS PCKPRV
  JOIN Y03S24999_PROVRT AS PROVRT
  ON PCKPRV~PRODUCT_VARIANT_ID = PROVRT~ID
  WHERE PCKPRV~IS_DELETED <> @ABAP_TRUE
    AND PROVRT~IS_DELETED <> @ABAP_TRUE
    AND PCKPRV~PACKAGE_ID = @U_PACKAGE_ID
  INTO CORRESPONDING FIELDS OF TABLE @LT_PCKPRV.

  SELECT LT~*,
         PRODCT~PRODUCT_NAME
  FROM @LT_PCKPRV AS LT
  JOIN Y03S24999_PRODCT AS PRODCT
  ON LT~PRODUCT_ID = PRODCT~ID
  WHERE PRODCT~IS_DELETED <> @ABAP_TRUE
  INTO CORRESPONDING FIELDS OF TABLE @GT_PCKPRV.

  IF SY-SUBRC <> 0.
    MESSAGE 'No PRODUCT VARIANT item found.' TYPE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PACKAGE_SERVICE_ITEMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_PACKAGE_ID
*&---------------------------------------------------------------------*
FORM GET_PACKAGE_SERVICE_ITEMS USING U_PACKAGE_ID.
  SELECT ' ' AS SEL,
         PS~*,
         S~NAME AS SERVICE_NAME,
         S~DISPLAY_PRICE AS DISPLAY_PRICE
  FROM Y03S24999_PCKSER AS PS
  JOIN Y03S24999_SERVCE AS S
  ON PS~SERVICE_ID = S~ID
  WHERE S~IS_DELETED <> @ABAP_TRUE
    AND PS~IS_DELETED <> @ABAP_TRUE
    AND PS~PACKAGE_ID = @U_PACKAGE_ID
  INTO CORRESPONDING FIELDS OF TABLE @GT_PCKSER.

  IF SY-SUBRC <> 0.
    MESSAGE 'No SERVICE item found.' TYPE 'E'.
  ENDIF.
ENDFORM.

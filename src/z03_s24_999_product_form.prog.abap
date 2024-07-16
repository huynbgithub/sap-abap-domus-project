*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_PRODUCT_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0110
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0110 USING U_OKCODE.
  CASE U_OKCODE.
    WHEN 'EXECUTE'.
      PERFORM PROCESS_PRODUCT_LIST.
      CLEAR: U_OKCODE.

    WHEN 'VIEW_PRODUCT'.
      PERFORM PROCESS_VIEW_PRODUCT_DETAIL CHANGING GV_PRODUCT_ID.
      CLEAR: U_OKCODE.
*
*    WHEN 'CREATE_PRODUCT'.
*      PERFORM PROCESS_CREATE_PRODUCT_DETAIL CHANGING GV_PRODUCT_ID.
*      CLEAR: U_OKCODE.
*
*    WHEN 'DELETE_PRODUCT'.
*      PERFORM PROCESS_DELETE_PRODUCTS_0120.
*      CLEAR: U_OKCODE.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0119
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0119 USING U_OKCODE.
  CASE U_OKCODE.
    WHEN 'BACK_TO_PRODUCT_LIST'.
      PERFORM PROCESS_BACK_TO_PRODUCT_LIST.
      CLEAR: U_OKCODE.

    WHEN 'DISPLAY<->CHANGE'.
      PERFORM PROCESS_PRO_DISPLAY_CHANGE.
      CLEAR: U_OKCODE.
*
*    WHEN 'SAVE'.
*      PERFORM PROCESS_PRODUCT_SAVE_EVENT.
*      CLEAR: U_OKCODE.
*
*    WHEN 'SEARCH_PROCAT'.
*      PERFORM PROCESS_PRODUCT_SAVE_EVENT.
*      CLEAR: U_OKCODE.
*
*    WHEN 'INSERT_PROVRT'.
*      PERFORM PROCESS_INSERT_PCKSER.
*      CLEAR: U_OKCODE.
*
*    WHEN 'DELETE_PROVRT'.
*      PERFORM DELETE_SELECTED_PROVRTS.
*      CLEAR: U_OKCODE.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_PRO_DISPLAY_CHANGE.
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_PRO_DISPLAY_CHANGE.
  CASE GV_PRODUCT_SCREEN_MODE.
    WHEN GC_PRODUCT_MODE_DISPLAY.
      GV_PRODUCT_SCREEN_MODE = GC_PRODUCT_MODE_CHANGE.

    WHEN GC_PRODUCT_MODE_CHANGE.
      PERFORM WARNING_PRODUCT_CHANGES_EXIST.
      GV_PRODUCT_SCREEN_MODE = GC_PRODUCT_MODE_DISPLAY.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form WARNING_PRODUCT_CHANGES_EXIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM WARNING_PRODUCT_CHANGES_EXIST .
  DATA: LD_CHOICE TYPE CHAR01.

  IF GS_PRODUCT_DETAIL_BEFORE_MOD <> GS_PRODUCT_DETAIL OR
     GT_PROVRT_BEFORE_MOD <> GT_PROVRT.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        TEXT_QUESTION         = 'Do you want to save before switching mode?'
        TEXT_BUTTON_1         = 'Yes'(001)
        TEXT_BUTTON_2         = 'No'(002)
        DISPLAY_CANCEL_BUTTON = ''
      IMPORTING
        ANSWER                = LD_CHOICE.
    IF LD_CHOICE = '1'.
*      PERFORM CHANGE_PRODUCT_DETAIL.
      PERFORM PREPARE_PRODUCT_DETAIL USING GV_PRODUCT_ID.
    ELSEIF LD_CHOICE = '2'.
      PERFORM PREPARE_PRODUCT_DETAIL USING GV_PRODUCT_ID.
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_BACK_TO_PRODUCT_LIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_BACK_TO_PRODUCT_LIST.
  IF GV_PRODUCT_SCREEN_MODE = GC_PRODUCT_MODE_CREATE.
*    PERFORM WARNING_EXIT_UNSAVED_PRODUCT.
  ELSE.
    PRODUCT_SCREEN_MODE = '0110'.
    PERFORM PROCESS_PRODUCT_LIST.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_PRODUCT_LIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_PRODUCT_LIST.
  DATA: LV_SUCCESS TYPE ABAP_BOOL.

  PERFORM SET_INIT_PRODUCT_COLOR.
* Get data from PRODUCT table
  PERFORM GET_PRODUCT_DATA CHANGING LV_SUCCESS.
  IF LV_SUCCESS = ABAP_FALSE.
    RETURN.
  ENDIF.
* Show PRODUCT ALV
  PERFORM SHOW_PRODUCT_ALV.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PRODUCT_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_PRODUCT_DATA CHANGING CH_V_SUCCESS TYPE ABAP_BOOL.
  CLEAR: IT_PRODUCT, CH_V_SUCCESS.

  SELECT PRODCT~*, PROCAT~NAME AS PROCAT_NAME
    FROM Y03S24999_PRODCT AS PRODCT
    JOIN Y03S24999_PROCAT AS PROCAT
    ON PRODCT~PROCAT_ID = PROCAT~ID
    WHERE PRODCT~PRODUCT_CODE IN @P_PRCODE
      AND PRODCT~IS_DELETED <> @ABAP_TRUE
    ORDER BY PRODCT~UPDATED_ON DESCENDING, PRODCT~UPDATED_AT DESCENDING, PRODCT~PRODUCT_CODE DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @IT_PRODUCT.

  IF SY-SUBRC <> 0.
    CLEAR IT_PRODUCT.

    IF O_PRODUCT_CONTAINER IS NOT INITIAL.
      CALL METHOD O_PRODUCT_CONTAINER->FREE.
      CLEAR O_PRODUCT_CONTAINER.
    ENDIF.
    IF O_PRODUCT_ALV_TABLE IS NOT INITIAL.
      CLEAR O_PRODUCT_ALV_TABLE.
    ENDIF.

    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Product' DISPLAY LIKE 'E'.
    CH_V_SUCCESS = ABAP_FALSE.
    RETURN.
  ELSE.
    CH_V_SUCCESS = ABAP_TRUE.
  ENDIF.

  LOOP AT IT_PRODUCT ASSIGNING FIELD-SYMBOL(<LS_DATA>).
    DATA: LV_LINE_INDEX TYPE SYST-TABIX.
    CLEAR: LV_LINE_INDEX.
    LV_LINE_INDEX = SY-TABIX.
    PERFORM CHANGE_PRODUCT_COLOR USING LV_LINE_INDEX CHANGING <LS_DATA>-LINE_COLOR.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_PRODUCT_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_PRODUCT_ALV.
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_PRODUCT_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_PRODUCT_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_PRODUCT_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_PRODUCT_FCAT
*&---------------------------------------------------------------------*
FORM ADD_PRODUCT_FCAT USING  U_FIELDNAME
                             U_SCRTEXT_M
                             U_OUTPUTLEN
                             U_KEY
                             U_EMPHASIZE
              CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
  DATA: LS_FIELD_CAT TYPE LVC_S_FCAT.
  LS_FIELD_CAT-FIELDNAME = U_FIELDNAME.
  LS_FIELD_CAT-SCRTEXT_M = U_SCRTEXT_M.
  LS_FIELD_CAT-OUTPUTLEN = U_OUTPUTLEN.
  LS_FIELD_CAT-KEY       = U_KEY.
  LS_FIELD_CAT-EMPHASIZE = U_EMPHASIZE.
  APPEND LS_FIELD_CAT TO CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_PRODUCT_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_PRODUCT_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_PRODUCT_FCAT USING 'PRODUCT_CODE' 'Product'      12  'X' ''     CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_FCAT USING 'BRAND'        'Brand'        12  ''  ''     CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_FCAT USING 'PRODUCT_NAME' 'Name'         20  ''  ''     CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_FCAT USING 'CREATED_BY'   'Created By'   10  ''  ''     CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_FCAT USING 'CREATED_AT'   'Created At'   10  ''  'C601' CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_FCAT USING 'CREATED_ON'   'Created On'   10  ''  'C701' CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_FCAT USING 'UPDATED_BY'   'Updated By'   10  ''  ''     CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_FCAT USING 'UPDATED_AT'   'Updated At'   10  ''  'C601' CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_FCAT USING 'UPDATED_ON'   'Updated On'   10  ''  'C701' CHANGING CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_PRODUCT_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_PRODUCT_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_PRODUCT_CONTAINER IS INITIAL.
    O_PRODUCT_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0110' ).
  ENDIF.

  IF O_PRODUCT_ALV_TABLE IS INITIAL.
    O_PRODUCT_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_PRODUCT_CONTAINER ).
  ENDIF.

  O_PRODUCT_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_PRODUCT     " Output Table
      IT_FIELDCATALOG               = CH_T_FIELD_CAT   " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).

  IF SY-SUBRC = 0.
    MESSAGE S006(Z03S24999_DOMUS_MSGS) WITH 'Product'.
  ELSE.
    MESSAGE E005(Z03S24999_DOMUS_MSGS).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_PRODUCT_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_PRODUCT_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-CTAB_FNAME = 'LINE_COLOR'.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_INIT_PRODUCT_COLOR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_INIT_PRODUCT_COLOR .
  CLEAR: GT_PRODUCT_COLOR.
  GT_PRODUCT_COLOR = VALUE #(
                              ( COL = 3 INT = 0 INV = 0 )
                              ( COL = 1 INT = 0 INV = 0 )
                              ( COL = 5 INT = 0 INV = 0 )
                              ( COL = 7 INT = 0 INV = 0 )
                              ( COL = 5 INT = 1 INV = 0 )
                              ( COL = 5 INT = 0 INV = 1 )
                             ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_PRODUCT_COLOR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      -->
*&      <--
*&---------------------------------------------------------------------*
FORM CHANGE_PRODUCT_COLOR  USING    U_LINE_INDEX  TYPE SYST_TABIX
                           CHANGING CH_LINE_COLOR TYPE LVC_T_SCOL.
  DATA LS_COLOR TYPE LVC_S_SCOL.
  DATA: LV_COLOR_INDEX TYPE INT1.

  CLEAR: CH_LINE_COLOR.
  LV_COLOR_INDEX = ( ( U_LINE_INDEX - 1 ) MOD 2 ) + 1.

  TRY.
      MOVE-CORRESPONDING GT_PRODUCT_COLOR[ LV_COLOR_INDEX ] TO LS_COLOR-COLOR.

      LS_COLOR-FNAME = 'PRODUCT_CODE'.
      APPEND LS_COLOR TO CH_LINE_COLOR.

      MOVE-CORRESPONDING GT_PRODUCT_COLOR[ LV_COLOR_INDEX + 4 ] TO LS_COLOR-COLOR.

      LS_COLOR-FNAME = 'PRODUCT_NAME'.
      APPEND LS_COLOR TO CH_LINE_COLOR.

      MOVE-CORRESPONDING GT_PRODUCT_COLOR[ LV_COLOR_INDEX + 2 ] TO LS_COLOR-COLOR.

      LS_COLOR-FNAME = 'CREATED_BY'.
      APPEND LS_COLOR TO CH_LINE_COLOR.

      LS_COLOR-FNAME = 'UPDATED_BY'.
      APPEND LS_COLOR TO CH_LINE_COLOR.

    CATCH CX_SY_ITAB_LINE_NOT_FOUND.

  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_PROVRT_PRICE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHECK_PROVRT_PRICE .
  IF GS_PROVRT-DISPLAY_PRICE IS INITIAL.
    MESSAGE E014(Z03S24999_DOMUS_MSGS).
    SET CURSOR FIELD 'GS_PROVRT-DISPLAY_PRICE' LINE PROVRT_TABLE_CONTROL-CURRENT_LINE.
  ELSE.
    IF GS_PROVRT-DISPLAY_PRICE < 0 OR GS_PROVRT-DISPLAY_PRICE > 999999999999.
      MESSAGE E019(Z03S24999_DOMUS_MSGS).
      SET CURSOR FIELD 'GS_PROVRT-DISPLAY_PRICE' LINE PROVRT_TABLE_CONTROL-CURRENT_LINE.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_PRODUCT_DETAIL_NAME
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHECK_PRODUCT_DETAIL_NAME.
  IF GS_PRODUCT_DETAIL-PRODUCT_NAME IS INITIAL.
    MESSAGE E014(Z03S24999_DOMUS_MSGS).
    SET CURSOR FIELD 'GS_PRODUCT_DETAIL-PRODUCT_NAME'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_PRODUCT_DETAIL_BRAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHECK_PRODUCT_DETAIL_BRAND.
  IF GS_PRODUCT_DETAIL-BRAND IS INITIAL.
    MESSAGE E014(Z03S24999_DOMUS_MSGS).
    SET CURSOR FIELD 'GS_PRODUCT_DETAIL-BRAND'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_PRODUCT_DETAIL_CATEGORY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHECK_PRODUCT_DETAIL_CATEGORY.
  IF GS_PRODUCT_DETAIL-PROCAT_NAME IS INITIAL.
    MESSAGE E014(Z03S24999_DOMUS_MSGS).
    SET CURSOR FIELD 'GS_PRODUCT_DETAIL-PROCAT_NAME'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_VIEW_PRODUCT_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  CH_PRODUCT_ID
*& <--  CH_PRODUCT_ID
*&---------------------------------------------------------------------*
FORM PROCESS_VIEW_PRODUCT_DETAIL CHANGING CH_PRODUCT_ID.
  IF O_PRODUCT_ALV_TABLE IS NOT INITIAL.

    DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
    DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.

    CALL METHOD O_PRODUCT_ALV_TABLE->GET_SELECTED_ROWS
      IMPORTING
        ET_INDEX_ROWS = LT_INDEX_ROWS.

    IF LINES( LT_INDEX_ROWS ) = 1.

      READ TABLE LT_INDEX_ROWS INDEX 1 INTO LS_INDEX_ROW.
      READ TABLE IT_PRODUCT INDEX LS_INDEX_ROW INTO DATA(LS_PRODUCT).

      CH_PRODUCT_ID = LS_PRODUCT-ID.
* Prepare PRODUCT Detail to display on Screen 0119
      PERFORM PREPARE_PRODUCT_DETAIL USING CH_PRODUCT_ID.

    ELSEIF LINES( LT_INDEX_ROWS ) = 0.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'one Product' DISPLAY LIKE 'E'.
    ELSEIF LINES( LT_INDEX_ROWS ) > 1.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'only one Product' DISPLAY LIKE 'E'.
    ENDIF.

  ELSE.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'one Product' DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_PRODUCT_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PREPARE_PRODUCT_DETAIL USING U_PRODUCT_ID.

  PERFORM GET_PRODUCT_BASIC_INFO    USING U_PRODUCT_ID.
  PERFORM GET_PRODUCT_VARIANT_ITEMS   USING U_PRODUCT_ID.

  GS_PRODUCT_DETAIL_BEFORE_MOD = GS_PRODUCT_DETAIL.
  GT_PROVRT_BEFORE_MOD = GT_PROVRT.

  CLEAR: GT_PROVRT_DELETED.

* Set Screen Mode to View only
  GV_PRODUCT_SCREEN_MODE = GC_PRODUCT_MODE_DISPLAY.
* Change Screen from 0110 to 0119
  PRODUCT_SCREEN_MODE = '0119'.

  MESSAGE S009(Z03S24999_DOMUS_MSGS) WITH 'Product'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PRODUCT_BASIC_INFO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_PRODUCT_ID
*&---------------------------------------------------------------------*
FORM GET_PRODUCT_BASIC_INFO USING U_PRODUCT_ID.
  SELECT SINGLE PRODCT~*, PROCAT~ID AS PROCAT_ID, PROCAT~NAME AS PROCAT_NAME
    FROM Y03S24999_PRODCT AS PRODCT
    JOIN Y03S24999_PROCAT AS PROCAT
    ON PRODCT~PROCAT_ID = PROCAT~ID
    WHERE PRODCT~ID = @U_PRODUCT_ID AND PRODCT~IS_DELETED <> @ABAP_TRUE
    INTO CORRESPONDING FIELDS OF @GS_PRODUCT_DETAIL.

  IF SY-SUBRC <> 0.
    MESSAGE E004(Z03S24999_DOMUS_MSGS) WITH 'Product'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PRODUCT_VARIANT_ITEMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_PRODUCT_ID
*&---------------------------------------------------------------------*
FORM GET_PRODUCT_VARIANT_ITEMS USING U_PRODUCT_ID.
  SELECT ' ' AS SEL,
         PI~*
  FROM Y03S24999_PROVRT AS PI
  WHERE IS_DELETED <> @ABAP_TRUE
    AND PRODUCT_ID = @U_PRODUCT_ID
  INTO CORRESPONDING FIELDS OF TABLE @GT_PROVRT.

  IF SY-SUBRC <> 0.
    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Product Variant' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.

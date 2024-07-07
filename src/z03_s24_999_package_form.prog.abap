*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_PACKAGE_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0120
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0120 USING U_OKCODE.
  CASE U_OKCODE.
    WHEN 'EXECUTE'.
      PERFORM PROCESS_PACKAGE_LIST.
      CLEAR: U_OKCODE.

    WHEN 'VIEW_PACKAGE'.
      PERFORM PROCESS_VIEW_PACKAGE_DETAIL CHANGING GV_PACKAGE_ID.
      CLEAR: U_OKCODE.

    WHEN 'CREATE_PACKAGE'.

      CLEAR: U_OKCODE.

    WHEN 'DELETE_PACKAGE'.

      CLEAR: U_OKCODE.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0129
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0129 USING U_OKCODE.
  CASE U_OKCODE.
    WHEN 'BACK_TO_PACKAGE_LIST'.
      PACKAGE_SCREEN_MODE = '0120'.
      PERFORM PROCESS_PACKAGE_LIST.
      CLEAR: U_OKCODE.

    WHEN 'DISPLAY<->CHANGE'.
      PERFORM PROCESS_PCK_DISPLAY_CHANGE..
      CLEAR: U_OKCODE.

    WHEN 'OPEN_PCKIMG_URL'.
      PERFORM OPEN_PCKIMG_URL.
      CLEAR: U_OKCODE.

    WHEN 'SAVE'.
      PERFORM PROCESS_PACKAGE_SAVE_EVENT.
      CLEAR: U_OKCODE.

    WHEN 'INSERT_PCKSER'.
      PERFORM PROCESS_INSERT_PCKSER.
      CLEAR: U_OKCODE.

    WHEN 'DELETE_PCKSER'.
      PERFORM DELETE_SELECTED_PCKSERS.
      CLEAR: U_OKCODE.

    WHEN 'INSERT_PCKIMG'.
      PERFORM PROCESS_INSERT_PCKIMG.
      CLEAR: U_OKCODE.

    WHEN 'DELETE_PCKIMG'.
      PERFORM DELETE_SELECTED_PCKIMGS.
      CLEAR: U_OKCODE.

    WHEN 'INSERT_PCKPRV'.
      PERFORM PROCESS_INSERT_PCKPRV.
      CLEAR: U_OKCODE.

    WHEN 'DELETE_PCKPRV'.
      PERFORM DELETE_SELECTED_PCKPRVS.
      CLEAR: U_OKCODE.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0128
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0128 USING U_OKCODE.

  CASE U_OKCODE.

    WHEN 'ENTER_128'.
      PERFORM HANDLE_ENTER_ON_SCREEN_0128.
      CLEAR: U_OKCODE.

    WHEN 'CANCLE_128'.
      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_PACKAGE_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0127
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0127 USING U_OKCODE.

  CASE U_OKCODE.

    WHEN 'ENTER_127' OR 'VIEW_PRODUCT_0127'.
      PERFORM HANDLE_ENTER_ON_SCREEN_0127.
      CLEAR: U_OKCODE.
    WHEN 'CANCLE_127'.
      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0126
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0126 USING U_OKCODE.

  CASE U_OKCODE.

    WHEN 'ENTER_126'.
      PERFORM HANDLE_ENTER_ON_SCREEN_0126.
      CLEAR: U_OKCODE.
    WHEN 'CANCLE_126'.
      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_PACKAGE_SAVE_EVENT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_PACKAGE_SAVE_EVENT.
  CASE GV_PACKAGE_SCREEN_MODE.
    WHEN GC_PACKAGE_MODE_DISPLAY.

    WHEN GC_PACKAGE_MODE_CHANGE.
      PERFORM CHANGE_PACKAGE_DETAIL.
      PERFORM PREPARE_PACKAGE_DETAIL USING GV_PACKAGE_ID.

      MESSAGE S010(Z03S24999_DOMUS_MSGS) WITH 'Package'.

      GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_DISPLAY.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_PCK_DISPLAY_CHANGE.
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_PCK_DISPLAY_CHANGE..
  CASE GV_PACKAGE_SCREEN_MODE.
    WHEN GC_PACKAGE_MODE_DISPLAY.
      GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_CHANGE.

    WHEN GC_PACKAGE_MODE_CHANGE.
      PERFORM WARNING_PACKAGE_CHANGES_EXIST.
      GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_DISPLAY.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_PACKAGE_LIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_PACKAGE_LIST.
  DATA: LV_SUCCESS TYPE ABAP_BOOL.

  PERFORM SET_INIT_PACKAGE_COLOR.
* Get data from PACKAGE table
  PERFORM GET_PACKAGE_DATA CHANGING LV_SUCCESS.
  IF LV_SUCCESS = ABAP_FALSE.
    RETURN.
  ENDIF.
* Show PACKAGE ALV
  PERFORM SHOW_PACKAGE_ALV.
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
    ORDER BY UPDATED_ON DESCENDING, UPDATED_AT DESCENDING, NAME ASCENDING
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

    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Package' DISPLAY LIKE 'E'.
    CH_V_SUCCESS = ABAP_FALSE.
    RETURN.
  ELSE.
    CH_V_SUCCESS = ABAP_TRUE.
  ENDIF.

  LOOP AT IT_PACKAGE ASSIGNING FIELD-SYMBOL(<LS_DATA>).
    DATA: LV_LINE_INDEX TYPE SYST-TABIX.
    CLEAR: LV_LINE_INDEX.
    LV_LINE_INDEX = SY-TABIX.
    PERFORM CHANGE_PACKAGE_COLOR USING LV_LINE_INDEX CHANGING <LS_DATA>-LINE_COLOR.
  ENDLOOP.
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
  PERFORM: ADD_PACKAGE_FCAT USING 'NAME'         'Name'         28 ''  'X' '' CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'DESCRIPTION'  'Description'  64 ''  ''  ''     CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'CREATED_BY'   'Created By'   10 ''  ''  ''     CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'CREATED_AT'   'Created At'   10 ''  ''  'C601' CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'CREATED_ON'   'Created On'   10 ''  ''  'C701' CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'UPDATED_BY'   'Updated By'   10 ''  ''  ''     CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'UPDATED_AT'   'Updated At'   10 ''  ''  'C601' CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'UPDATED_ON'   'Updated On'   10 ''  ''  'C701' CHANGING CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_PACKAGE_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_PACKAGE_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_PACKAGE_CONTAINER IS INITIAL.
    O_PACKAGE_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0120' ).
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
  CH_S_LAYOUT-CTAB_FNAME = 'LINE_COLOR'.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_VARIANT
*&---------------------------------------------------------------------*
*FORM PREPARE_VARIANT CHANGING CH_S_VARIANT TYPE DISVARIANT.
*
*  CH_S_VARIANT-REPORT = SY-REPID.
*  CH_S_VARIANT-HANDLE = 001.
*  CH_S_VARIANT-VARIANT = '/CUSTOM_CONTROL_ALV_0120'.
*
*ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_INSERT_PCKSER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      -->
*&---------------------------------------------------------------------*
FORM PROCESS_INSERT_PCKSER.
  DATA: LV_SUCCESS TYPE ABAP_BOOL.
* Get data from SERVICE_0128 table
  PERFORM GET_SERVICE_0128_DATA CHANGING LV_SUCCESS.
  IF LV_SUCCESS = ABAP_FALSE.
    RETURN.
  ENDIF.
  CALL SCREEN 0128 STARTING AT 10 08 ENDING AT 70 15.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_INSERT_PCKIMG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      -->
*&---------------------------------------------------------------------*
FORM PROCESS_INSERT_PCKIMG.
  READ TABLE GT_PCKIMG INDEX 1 INTO GS_PCKIMG.
  CLEAR: GS_PCKIMG.
  IF GS_PACKAGE_DETAIL-ID <> ''.
    GS_PCKIMG-PACKAGE_ID = GS_PACKAGE_DETAIL-ID.
  ENDIF.

  PERFORM CREATE_UUID_C36_STATIC CHANGING GS_PCKIMG-ID.

  GS_PCKIMG-IMAGE_URL = '...'.
  GS_PCKIMG-CREATED_BY = SY-UNAME.
  GS_PCKIMG-CREATED_AT = SY-UZEIT + ( 3600 * 5 ).
  GS_PCKIMG-CREATED_ON = SY-DATUM.

  APPEND GS_PCKIMG TO GT_PCKIMG.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_INSERT_PCKPRV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      -->
*&---------------------------------------------------------------------*
FORM PROCESS_INSERT_PCKPRV.
  DATA: LV_SUCCESS TYPE ABAP_BOOL.
* Get data from PRODUCT_0127 table
  PERFORM GET_PRODUCT_0127_DATA CHANGING LV_SUCCESS.
  IF LV_SUCCESS = ABAP_FALSE.
    RETURN.
  ENDIF.
  CALL SCREEN 0127 STARTING AT 10 08 ENDING AT 70 20.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_VIEW_PACKAGE_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  CH_PACKAGE_ID
*& <--  CH_PACKAGE_ID
*&---------------------------------------------------------------------*
FORM PROCESS_VIEW_PACKAGE_DETAIL CHANGING CH_PACKAGE_ID.
  IF O_PACKAGE_ALV_TABLE IS NOT INITIAL.

    DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
    DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.

    CALL METHOD O_PACKAGE_ALV_TABLE->GET_SELECTED_ROWS
      IMPORTING
        ET_INDEX_ROWS = LT_INDEX_ROWS.

    IF LINES( LT_INDEX_ROWS ) = 1.

      READ TABLE LT_INDEX_ROWS INDEX 1 INTO LS_INDEX_ROW.
      READ TABLE IT_PACKAGE INDEX LS_INDEX_ROW INTO DATA(LS_PACKAGE).

      CH_PACKAGE_ID = LS_PACKAGE-ID.
* Prepare Package Detail to display on Screen 0129
      PERFORM PREPARE_PACKAGE_DETAIL USING CH_PACKAGE_ID.

    ELSEIF LINES( LT_INDEX_ROWS ) = 0.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'one Package' DISPLAY LIKE 'E'.
    ELSEIF LINES( LT_INDEX_ROWS ) > 1.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'only one Package' DISPLAY LIKE 'E'.
    ENDIF.

  ELSE.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'one Package' DISPLAY LIKE 'E'.
  ENDIF.
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
  CLEAR: GV_PACKAGE_TOTAL_PRICE.
  CLEAR: GV_PCKPRV_TOTAL_PRICE.
  CLEAR: GV_PCKSER_TOTAL_PRICE.

  PERFORM GET_PACKAGE_BASIC_INFO USING U_PACKAGE_ID.
  PERFORM GET_PACKAGE_PRODUCT_ITEMS USING U_PACKAGE_ID.
  PERFORM GET_PACKAGE_SERVICE_ITEMS USING U_PACKAGE_ID.
  PERFORM GET_PACKAGE_IMAGE_ITEMS   USING U_PACKAGE_ID.

  GS_PACKAGE_DETAIL_BEFORE_MOD = GS_PACKAGE_DETAIL.
  GT_PCKPRV_BEFORE_MOD = GT_PCKPRV.
  GT_PCKSER_BEFORE_MOD = GT_PCKSER.
  GT_PCKIMG_BEFORE_MOD = GT_PCKIMG.

  CLEAR: GT_PCKPRV_DELETED.
  CLEAR: GT_PCKSER_DELETED.
  CLEAR: GT_PCKIMG_DELETED.

* Set Screen Mode to View only
  GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_DISPLAY.
* Change Screen from 0120 to 0129
  PACKAGE_SCREEN_MODE = '0129'.

  MESSAGE S009(Z03S24999_DOMUS_MSGS) WITH 'Package'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PACKAGE_BASIC_INFO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_PACKAGE_ID
*&---------------------------------------------------------------------*
FORM GET_PACKAGE_BASIC_INFO USING U_PACKAGE_ID.
  SELECT SINGLE *
    FROM Y03S24999_PACKGE
    INTO CORRESPONDING FIELDS OF GS_PACKAGE_DETAIL
    WHERE ID = U_PACKAGE_ID AND IS_DELETED <> ABAP_TRUE.

  IF SY-SUBRC <> 0.
    MESSAGE E004(Z03S24999_DOMUS_MSGS) WITH 'Package'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PACKAGE_PRODUCT_VARIANT_ITEMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_PACKAGE_ID
*&---------------------------------------------------------------------*
FORM GET_PACKAGE_PRODUCT_ITEMS USING U_PACKAGE_ID.

  SELECT ' ' AS SEL,
         PCKPRV~*,
         PROVRT~VARIANT_CODE AS VARIANT_CODE,
         PROVRT~DISPLAY_PRICE AS DISPLAY_PRICE,
         ( DISPLAY_PRICE * PCKPRV~QUANTITY ) AS TOTAL_PRICE,
         PROVRT~PRODUCT_ID
  FROM Y03S24999_PCKPRV AS PCKPRV
  JOIN Y03S24999_PROVRT AS PROVRT
  ON PCKPRV~PRODUCT_VARIANT_ID = PROVRT~ID
  WHERE PCKPRV~IS_DELETED <> @ABAP_TRUE
    AND PCKPRV~PACKAGE_ID = @U_PACKAGE_ID
  INTO CORRESPONDING FIELDS OF TABLE @GT_PCKPRV.

  IF SY-SUBRC <> 0.
    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Package Product Variant' DISPLAY LIKE 'E'.

  ELSE.
    SELECT GT~*,
           PRODCT~PRODUCT_NAME
    FROM @GT_PCKPRV AS GT
    JOIN Y03S24999_PRODCT AS PRODCT
    ON GT~PRODUCT_ID = PRODCT~ID
    INTO CORRESPONDING FIELDS OF TABLE @GT_PCKPRV.

    IF SY-SUBRC <> 0.
      MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Product Name' DISPLAY LIKE 'E'.
    ENDIF.

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
    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Package Service' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PACKAGE_IMAGE_ITEMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_PACKAGE_ID
*&---------------------------------------------------------------------*
FORM GET_PACKAGE_IMAGE_ITEMS USING U_PACKAGE_ID.
  SELECT ' ' AS SEL,
         PI~*
  FROM Y03S24999_PCKIMG AS PI
  WHERE IS_DELETED <> @ABAP_TRUE
    AND PACKAGE_ID = @U_PACKAGE_ID
  INTO CORRESPONDING FIELDS OF TABLE @GT_PCKIMG.

  IF SY-SUBRC <> 0.
    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Package Image' DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_ENTER_ON_SCREEN_0126
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM HANDLE_ENTER_ON_SCREEN_0126.
  IF O_PROVRT_0126_ALV_TABLE IS NOT INITIAL.

    DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
    DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.

    CALL METHOD O_PROVRT_0126_ALV_TABLE->GET_SELECTED_ROWS
      IMPORTING
        ET_INDEX_ROWS = LT_INDEX_ROWS.

    IF LINES( LT_INDEX_ROWS ) > 0.
* Loop to append each selected Product Variant into Package Product Variant List
      LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW.
        DATA: LV_IS_REPEATED TYPE ABAP_BOOL.
        READ TABLE IT_PROVRT_0126 INDEX LS_INDEX_ROW INTO DATA(LS_PROVRT_0126).

        LOOP AT GT_PCKPRV INTO DATA(LS_TEMP).
          IF LS_TEMP-PRODUCT_VARIANT_ID = LS_PROVRT_0126-ID.
            LS_TEMP-QUANTITY += 1.
            MODIFY TABLE GT_PCKPRV FROM LS_TEMP.

            LV_IS_REPEATED = ABAP_TRUE.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF LV_IS_REPEATED <> ABAP_TRUE.
          READ TABLE GT_PCKPRV INDEX 1 INTO GS_PCKPRV.
          CLEAR: GS_PCKPRV.

          IF GS_PACKAGE_DETAIL-ID <> ''.
            GS_PCKPRV-PACKAGE_ID = GS_PACKAGE_DETAIL-ID.
          ENDIF.


          GS_PCKPRV-PRODUCT_VARIANT_ID = LS_PROVRT_0126-ID.
          GS_PCKPRV-VARIANT_CODE = LS_PROVRT_0126-VARIANT_CODE.
          GS_PCKPRV-PRODUCT_NAME = LS_PROVRT_0126-PRODUCT_NAME.
          GS_PCKPRV-DISPLAY_PRICE = LS_PROVRT_0126-DISPLAY_PRICE.
          GS_PCKPRV-QUANTITY = 1.
          GS_PCKPRV-TOTAL_PRICE = GS_PCKPRV-DISPLAY_PRICE.

          PERFORM CREATE_UUID_C36_STATIC CHANGING GS_PCKPRV-ID.

          APPEND GS_PCKPRV TO GT_PCKPRV.

        ENDIF.

      ENDLOOP.

      LEAVE TO SCREEN 0.

    ELSE.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'at least one Product Variant' DISPLAY LIKE 'E'.

    ENDIF.

  ELSE.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'at least one Product Variant' DISPLAY LIKE 'E'.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_ENTER_ON_SCREEN_0127
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM HANDLE_ENTER_ON_SCREEN_0127.
  IF O_PRODUCT_0127_ALV_TABLE IS NOT INITIAL.
    DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
    DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.

    CALL METHOD O_PRODUCT_0127_ALV_TABLE->GET_SELECTED_ROWS
      IMPORTING
        ET_INDEX_ROWS = LT_INDEX_ROWS.

    IF LINES( LT_INDEX_ROWS ) = 1.
      READ TABLE LT_INDEX_ROWS INDEX 1 INTO LS_INDEX_ROW.
      READ TABLE IT_PRODUCT_0127 INDEX LS_INDEX_ROW INTO DATA(LS_PRODUCT).

      PERFORM PROCESS_PREPARE_0126_DATA USING LS_PRODUCT-ID.

    ELSEIF LINES( LT_INDEX_ROWS ) = 0.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'one Product' DISPLAY LIKE 'E'.
    ELSEIF LINES( LT_INDEX_ROWS ) > 1.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'only one Product' DISPLAY LIKE 'E'.
    ENDIF.

  ELSE.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'at least one Product' DISPLAY LIKE 'E'.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_PREPARE_0126_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_PREPARE_0126_DATA USING U_PRODUCT_ID.

  CLEAR: IT_PROVRT_0126[].

  SELECT PROVRT~*, PRODCT~PRODUCT_NAME, PRODCT~PRODUCT_CODE
    FROM Y03S24999_PROVRT AS PROVRT
    LEFT JOIN Y03S24999_PRODCT AS PRODCT
    ON PRODCT~ID = PROVRT~PRODUCT_ID
    WHERE PROVRT~IS_DELETED <> @ABAP_TRUE
    AND PRODCT~ID = @U_PRODUCT_ID
    ORDER BY PROVRT~VARIANT_CODE DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @IT_PROVRT_0126.

  IF SY-SUBRC <> 0.
    CLEAR IT_PROVRT_0126[].

    IF O_PROVRT_0126_CONTAINER IS NOT INITIAL.
      CALL METHOD O_PROVRT_0126_CONTAINER->FREE.
      CLEAR O_PROVRT_0126_CONTAINER.
    ENDIF.
    IF O_PROVRT_0126_ALV_TABLE IS NOT INITIAL.
      CLEAR O_PROVRT_0126_ALV_TABLE.
    ENDIF.

    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Product Variant of this product' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  CALL SCREEN 0126 STARTING AT 15 06 ENDING AT 70 12.
  LEAVE TO SCREEN 0.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_ENTER_ON_SCREEN_0128
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM HANDLE_ENTER_ON_SCREEN_0128.
  IF O_SERVICE_0128_ALV_TABLE IS NOT INITIAL.

    DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
    DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.

    CALL METHOD O_SERVICE_0128_ALV_TABLE->GET_SELECTED_ROWS
      IMPORTING
        ET_INDEX_ROWS = LT_INDEX_ROWS.

    IF LINES( LT_INDEX_ROWS ) > 0.
* Loop to append each selected Services into Package Service List
      LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW.

        READ TABLE GT_PCKSER INDEX 1 INTO GS_PCKSER.
        CLEAR: GS_PCKSER.

        IF GS_PACKAGE_DETAIL-ID <> ''.
          GS_PCKSER-PACKAGE_ID = GS_PACKAGE_DETAIL-ID.
        ENDIF.

        READ TABLE IT_SERVICE_0128 INDEX LS_INDEX_ROW INTO DATA(LS_SERVICE_0128).
        GS_PCKSER-SERVICE_ID = LS_SERVICE_0128-ID.
        GS_PCKSER-SERVICE_NAME = LS_SERVICE_0128-NAME.
        GS_PCKSER-DISPLAY_PRICE = LS_SERVICE_0128-DISPLAY_PRICE.

        PERFORM CREATE_UUID_C36_STATIC CHANGING GS_PCKSER-ID.

        APPEND GS_PCKSER TO GT_PCKSER.
      ENDLOOP.

    ELSE.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'at least one Service' DISPLAY LIKE 'E'.
    ENDIF.

    LEAVE TO SCREEN 0.

  ELSE.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'at least one Service' DISPLAY LIKE 'E'.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_SERVICE_0127_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_PRODUCT_0127_DATA CHANGING CH_V_SUCCESS TYPE ABAP_BOOL.
  CLEAR: IT_PRODUCT_0127[], CH_V_SUCCESS.

  SELECT P~*
    FROM Y03S24999_PRODCT AS P
    LEFT JOIN @GT_PCKPRV AS GP
    ON P~ID = GP~PRODUCT_ID
    WHERE P~IS_DELETED <> @ABAP_TRUE
    AND GP~PRODUCT_ID IS NULL
    ORDER BY P~UPDATED_ON DESCENDING, P~UPDATED_ON DESCENDING, P~PRODUCT_CODE
    INTO CORRESPONDING FIELDS OF TABLE @IT_PRODUCT_0127.

  IF SY-SUBRC <> 0.
    CLEAR IT_PRODUCT_0127[].

    IF O_PRODUCT_0127_CONTAINER IS NOT INITIAL.
      CALL METHOD O_PRODUCT_0127_CONTAINER->FREE.
      CLEAR O_PRODUCT_0127_CONTAINER.
    ENDIF.
    IF O_PRODUCT_0127_ALV_TABLE IS NOT INITIAL.
      CLEAR O_PRODUCT_0127_ALV_TABLE.
    ENDIF.

    MESSAGE S000(Z03S24999_DOMUS_MSGS) WITH 'All products were selected!' DISPLAY LIKE 'E'.
    CH_V_SUCCESS = ABAP_FALSE.
  ELSE.
    CH_V_SUCCESS = ABAP_TRUE.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_SERVICE_0128_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_SERVICE_0128_DATA CHANGING CH_V_SUCCESS TYPE ABAP_BOOL.
  CLEAR: IT_SERVICE_0128[], CH_V_SUCCESS.

  SELECT S~*
    FROM Y03S24999_SERVCE AS S
    LEFT JOIN @GT_PCKSER AS GS
    ON S~ID = GS~SERVICE_ID
    WHERE S~IS_DELETED <> @ABAP_TRUE
    AND GS~SERVICE_ID IS NULL
    ORDER BY S~CREATED_ON DESCENDING, S~CREATED_AT DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @IT_SERVICE_0128.

  IF SY-SUBRC <> 0.
    CLEAR IT_SERVICE_0128[].

    IF O_SERVICE_0128_CONTAINER IS NOT INITIAL.
      CALL METHOD O_SERVICE_0128_CONTAINER->FREE.
      CLEAR O_SERVICE_0128_CONTAINER.
    ENDIF.
    IF O_SERVICE_0128_ALV_TABLE IS NOT INITIAL.
      CLEAR O_SERVICE_0128_ALV_TABLE.
    ENDIF.

    MESSAGE S000(Z03S24999_DOMUS_MSGS) WITH 'All services were selected!' DISPLAY LIKE 'E'.
    CH_V_SUCCESS = ABAP_FALSE.
  ELSE.
    CH_V_SUCCESS = ABAP_TRUE.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_SERVICE_0128_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_SERVICE_0128_ALV.
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_SER_0128_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_SERVICE_0128_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_SERVICE_0128_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_SERVICE_0128_FCAT
*&---------------------------------------------------------------------*
FORM ADD_SERVICE_0128_FCAT USING U_FIELDNAME
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
*& Form PREPARE_SERVICE_0128_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_SER_0128_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_SERVICE_0128_FCAT USING 'NAME'           'Name'              20 '' 'X'  'C500'  CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0128_FCAT USING 'DISPLAY_PRICE'  'Price'             14 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0128_FCAT USING 'DESCRIPTION'    'Description'       10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0128_FCAT USING 'CREATED_BY'     'Created By'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0128_FCAT USING 'CREATED_AT'     'Created At'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0128_FCAT USING 'CREATED_ON'     'Created On'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0128_FCAT USING 'UPDATED_BY'     'Updated By'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0128_FCAT USING 'UPDATED_AT'     'Updated At'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0128_FCAT USING 'UPDATED_ON'     'Updated On'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_SERVICE_0128_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_SERVICE_0128_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_SERVICE_0128_CONTAINER IS INITIAL.
    O_SERVICE_0128_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0128' ).
  ENDIF.

  IF O_SERVICE_0128_ALV_TABLE IS INITIAL.
    O_SERVICE_0128_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_SERVICE_0128_CONTAINER ).
  ENDIF.

  O_SERVICE_0128_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_SERVICE_0128     " Output Table
      IT_FIELDCATALOG               = CH_T_FIELD_CAT   " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).

  IF SY-SUBRC <> 0.
    MESSAGE E005(Z03S24999_DOMUS_MSGS).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_SERVICE_0128_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_SERVICE_0128_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELETE_SELECTED_PCKSERS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DELETE_SELECTED_PCKSERS.
  DATA: LD_SEL_PCKSERS LIKE GT_PCKSER.
  LOOP AT GT_PCKSER INTO DATA(LS_PI).
    IF LS_PI-SEL = 'X'.
      APPEND LS_PI TO LD_SEL_PCKSERS.
    ENDIF.
  ENDLOOP.

  IF LINES( LD_SEL_PCKSERS ) = 0.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'a Service for deletion' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSEIF LINES( LD_SEL_PCKSERS ) > 1.
    PERFORM WARNING_MULTI_SELECTED_PCKSER TABLES LD_SEL_PCKSERS.

  ELSEIF LINES( LD_SEL_PCKSERS ) = 1.
    PERFORM HANDLE_PCKSER_FINAL_DELETION TABLES LD_SEL_PCKSERS.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form WARNING_MULTI_SELECTED_PCKSER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM WARNING_MULTI_SELECTED_PCKSER TABLES U_ITAB LIKE GT_PCKSER.
  DATA: LD_CHOICE TYPE C.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      TEXT_QUESTION         = 'Do you want to delete MULTIPLE services?'
      TEXT_BUTTON_1         = 'Yes'(001)
      TEXT_BUTTON_2         = 'No'(002)
      DISPLAY_CANCEL_BUTTON = ''
    IMPORTING
      ANSWER                = LD_CHOICE.
  IF LD_CHOICE = '1'.
    PERFORM HANDLE_PCKSER_FINAL_DELETION TABLES U_ITAB.

  ELSEIF LD_CHOICE = '2'.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_PCKSER_FINAL_DELETION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM HANDLE_PCKSER_FINAL_DELETION TABLES U_ITAB LIKE GT_PCKSER.
  LOOP AT U_ITAB INTO DATA(S_ROW).
    APPEND S_ROW TO GT_PCKSER_DELETED.

    DELETE TABLE GT_PCKSER FROM S_ROW.

    IF SY-SUBRC <> 0.
      MESSAGE E000(Z03S24999_DOMUS_MSGS) WITH 'One deleting Service in Package has caused an error!'.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_PACKAGE_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHANGE_PACKAGE_DETAIL .
  PERFORM CHANGE_PACKAGE_BASIC_DETAIL.
  PERFORM CHANGE_PACKAGE_PROVRTS_DETAIL.
  PERFORM CHANGE_PACKAGE_SERVICES_DETAIL.
  PERFORM CHANGE_PACKAGE_IMAGES_DETAIL.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_PACKAGE_BASIC_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHANGE_PACKAGE_BASIC_DETAIL .
  DATA: LS_PACKGE TYPE Y03S24999_PACKGE.

  MOVE-CORRESPONDING GS_PACKAGE_DETAIL TO LS_PACKGE.

  LS_PACKGE-UPDATED_BY = SY-UNAME.
  LS_PACKGE-UPDATED_AT = SY-UZEIT + ( 3600 * 5 ).
  LS_PACKGE-UPDATED_ON = SY-DATUM.

  UPDATE Y03S24999_PACKGE FROM LS_PACKGE.

  IF SY-SUBRC <> 0.
    MESSAGE E011(Z03S24999_DOMUS_MSGS) WITH 'Package basic information'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_PACKAGE_PROVRTS_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHANGE_PACKAGE_PROVRTS_DETAIL .
  PERFORM MODIFY_PCKPRV_TABLE.
  PERFORM SOFT_DELETE_PCKPRV_TABLE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_PACKAGE_SERVICES_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHANGE_PACKAGE_SERVICES_DETAIL .
  PERFORM MODIFY_PCKSER_TABLE.
  PERFORM SOFT_DELETE_PCKSER_TABLE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_PACKAGE_IMAGES_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHANGE_PACKAGE_IMAGES_DETAIL .
  PERFORM MODIFY_PCKIMG_TABLE.
  PERFORM SOFT_DELETE_PCKIMG_TABLE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_PCKPRV_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MODIFY_PCKPRV_TABLE .
  DATA: LT_PI TYPE STANDARD TABLE OF Y03S24999_PCKPRV.
  MOVE-CORRESPONDING GT_PCKPRV TO LT_PI.

  LOOP AT LT_PI INTO DATA(LS_PI).
    LS_PI-UPDATED_BY = SY-UNAME.
    LS_PI-UPDATED_AT = SY-UZEIT + ( 3600 * 5 ).
    LS_PI-UPDATED_ON = SY-DATUM.

    MODIFY Y03S24999_PCKPRV FROM LS_PI.

    IF SY-SUBRC <> 0.
      MESSAGE E011(Z03S24999_DOMUS_MSGS) WITH 'Package Product Variant details'.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_PCKSER_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MODIFY_PCKSER_TABLE .
  DATA: LT_PI TYPE STANDARD TABLE OF Y03S24999_PCKSER.
  MOVE-CORRESPONDING GT_PCKSER TO LT_PI.

  LOOP AT LT_PI INTO DATA(LS_PI).
    LS_PI-UPDATED_BY = SY-UNAME.
    LS_PI-UPDATED_AT = SY-UZEIT + ( 3600 * 5 ).
    LS_PI-UPDATED_ON = SY-DATUM.

    MODIFY Y03S24999_PCKSER FROM LS_PI.

    IF SY-SUBRC <> 0.
      MESSAGE E011(Z03S24999_DOMUS_MSGS) WITH 'Package Service details'.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form MODIFY_PCKIMG_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MODIFY_PCKIMG_TABLE .
  DATA: LT_PI TYPE STANDARD TABLE OF Y03S24999_PCKIMG.
  MOVE-CORRESPONDING GT_PCKIMG TO LT_PI.

  LOOP AT LT_PI INTO DATA(LS_PI).
    LS_PI-UPDATED_BY = SY-UNAME.
    LS_PI-UPDATED_AT = SY-UZEIT + ( 3600 * 5 ).
    LS_PI-UPDATED_ON = SY-DATUM.

    MODIFY Y03S24999_PCKIMG FROM LS_PI.

    IF SY-SUBRC <> 0.
      MESSAGE E011(Z03S24999_DOMUS_MSGS) WITH 'Package Image details'.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SOFT_DELETE_PCKPRV_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SOFT_DELETE_PCKPRV_TABLE .
  DATA: LT_PID TYPE STANDARD TABLE OF Y03S24999_PCKPRV.

  SELECT 'X' AS IS_DELETED, GPD~*
    FROM @GT_PCKPRV_DELETED AS GPD
    INTO CORRESPONDING FIELDS OF TABLE @LT_PID.

  IF SY-SUBRC = 0.
    LOOP AT LT_PID INTO DATA(LS_PID).
      LS_PID-UPDATED_BY = SY-UNAME.
      LS_PID-UPDATED_AT = SY-UZEIT + ( 3600 * 5 ).
      LS_PID-UPDATED_ON = SY-DATUM.

      MODIFY Y03S24999_PCKPRV FROM LS_PID.

      IF SY-SUBRC <> 0.
        MESSAGE E000(Z03S24999_DOMUS_MSGS) WITH 'Soft delete Package Product Variant failed!'.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SOFT_DELETE_PCKSER_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SOFT_DELETE_PCKSER_TABLE .
  DATA: LT_PID TYPE STANDARD TABLE OF Y03S24999_PCKSER.

  SELECT 'X' AS IS_DELETED, GPD~*
    FROM @GT_PCKSER_DELETED AS GPD
    INTO CORRESPONDING FIELDS OF TABLE @LT_PID.

  IF SY-SUBRC = 0.
    LOOP AT LT_PID INTO DATA(LS_PID).
      LS_PID-UPDATED_BY = SY-UNAME.
      LS_PID-UPDATED_AT = SY-UZEIT + ( 3600 * 5 ).
      LS_PID-UPDATED_ON = SY-DATUM.

      MODIFY Y03S24999_PCKSER FROM LS_PID.

      IF SY-SUBRC <> 0.
        MESSAGE E000(Z03S24999_DOMUS_MSGS) WITH 'Soft delete Package Service failed!'.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SOFT_DELETE_PCKIMG_TABLE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SOFT_DELETE_PCKIMG_TABLE .
  DATA: LT_PID TYPE STANDARD TABLE OF Y03S24999_PCKIMG.

  SELECT 'X' AS IS_DELETED, GPD~*
    FROM @GT_PCKIMG_DELETED AS GPD
    INTO CORRESPONDING FIELDS OF TABLE @LT_PID.

  IF SY-SUBRC = 0.
    LOOP AT LT_PID INTO DATA(LS_PID).
      LS_PID-UPDATED_BY = SY-UNAME.
      LS_PID-UPDATED_AT = SY-UZEIT + ( 3600 * 5 ).
      LS_PID-UPDATED_ON = SY-DATUM.

      MODIFY Y03S24999_PCKIMG FROM LS_PID.

      IF SY-SUBRC <> 0.
        MESSAGE E000(Z03S24999_DOMUS_MSGS) WITH 'Soft delete Package Image failed!'.
      ENDIF.
    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form OPEN_PCKIMG_URL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM OPEN_PCKIMG_URL .
  DATA: LV_SEL_PCKIMGS TYPE STANDARD TABLE OF TY_PCKIMG.

  LOOP AT GT_PCKIMG INTO DATA(LS_ROW).
    IF LS_ROW-SEL = 'X'.
      APPEND LS_ROW TO LV_SEL_PCKIMGS.
    ENDIF.
  ENDLOOP.

  IF LINES( LV_SEL_PCKIMGS ) = 0.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'at least one Image' DISPLAY LIKE 'E'.
  ELSE.
    LOOP AT LV_SEL_PCKIMGS INTO DATA(LS_IMAGE).

      CALL FUNCTION 'CALL_BROWSER'
        EXPORTING
          URL                    = LS_IMAGE-IMAGE_URL
        EXCEPTIONS
          FRONTEND_NOT_SUPPORTED = 1
          FRONTEND_ERROR         = 2
          PROG_NOT_FOUND         = 3
          NO_BATCH               = 4
          UNSPECIFIED_ERROR      = 5
          OTHERS                 = 6.

      IF SY-SUBRC = 0.
        MESSAGE S000(Z03S24999_DOMUS_MSGS) WITH 'Display Images on Browser successfully!'.
      ELSEIF SY-SUBRC = 1.
        MESSAGE S000(Z03S24999_DOMUS_MSGS) WITH 'Frontend Not Supported' DISPLAY LIKE 'E'.
      ELSEIF SY-SUBRC = 2.
        MESSAGE S000(Z03S24999_DOMUS_MSGS) WITH 'Frontend Error' DISPLAY LIKE 'E'.
      ELSEIF SY-SUBRC = 3.
        MESSAGE S000(Z03S24999_DOMUS_MSGS) WITH 'Program Not Found' DISPLAY LIKE 'E'.
      ELSEIF SY-SUBRC = 4.
        MESSAGE S000(Z03S24999_DOMUS_MSGS) WITH 'No Batch' DISPLAY LIKE 'E'.
      ELSE.
        MESSAGE S000(Z03S24999_DOMUS_MSGS) WITH 'Unspecified Error While Displaying Images' DISPLAY LIKE 'E'.
      ENDIF.

    ENDLOOP.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELETE_SELECTED_PCKIMGS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DELETE_SELECTED_PCKIMGS.
  DATA: LD_SEL_PCKIMGS LIKE GT_PCKIMG.
  LOOP AT GT_PCKIMG INTO DATA(LS_PI).
    IF LS_PI-SEL = 'X'.
      APPEND LS_PI TO LD_SEL_PCKIMGS.
    ENDIF.
  ENDLOOP.

  IF LINES( LD_SEL_PCKIMGS ) = 0.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'an Image for deletion' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSEIF LINES( LD_SEL_PCKIMGS ) > 1.
    PERFORM WARNING_MULTI_SELECTED_PCKIMG TABLES LD_SEL_PCKIMGS.

  ELSEIF LINES( LD_SEL_PCKIMGS ) = 1.
    PERFORM HANDLE_PCKIMG_FINAL_DELETION TABLES LD_SEL_PCKIMGS.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form WARNING_MULTI_SELECTED_PCKIMG
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM WARNING_MULTI_SELECTED_PCKIMG TABLES U_ITAB LIKE GT_PCKIMG.
  DATA: LD_CHOICE TYPE C.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      TEXT_QUESTION         = 'Do you want to delete MULTIPLE images?'
      TEXT_BUTTON_1         = 'Yes'(001)
      TEXT_BUTTON_2         = 'No'(002)
      DISPLAY_CANCEL_BUTTON = ''
    IMPORTING
      ANSWER                = LD_CHOICE.
  IF LD_CHOICE = '1'.
    PERFORM HANDLE_PCKIMG_FINAL_DELETION TABLES U_ITAB.

  ELSEIF LD_CHOICE = '2'.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_PCKIMG_FINAL_DELETION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM HANDLE_PCKIMG_FINAL_DELETION TABLES U_ITAB LIKE GT_PCKIMG.
  LOOP AT U_ITAB INTO DATA(S_ROW).
    APPEND S_ROW TO GT_PCKIMG_DELETED.

    DELETE TABLE GT_PCKIMG FROM S_ROW.

    IF SY-SUBRC <> 0.
      MESSAGE E000(Z03S24999_DOMUS_MSGS) WITH 'One deleting Image in Package has caused an error!'.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELETE_SELECTED_PCKPRVS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DELETE_SELECTED_PCKPRVS.
  DATA: LD_SEL_PCKPRVS LIKE GT_PCKPRV.
  LOOP AT GT_PCKPRV INTO DATA(LS_PI).
    IF LS_PI-SEL = 'X'.
      APPEND LS_PI TO LD_SEL_PCKPRVS.
    ENDIF.
  ENDLOOP.

  IF LINES( LD_SEL_PCKPRVS ) = 0.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'a Product Variant for deletion' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSEIF LINES( LD_SEL_PCKPRVS ) > 1.
    PERFORM WARNING_MULTI_SELECTED_PCKPRV TABLES LD_SEL_PCKPRVS.

  ELSEIF LINES( LD_SEL_PCKPRVS ) = 1.
    PERFORM HANDLE_PCKPRV_FINAL_DELETION TABLES LD_SEL_PCKPRVS.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form WARNING_MULTI_SELECTED_PCKPRV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM WARNING_MULTI_SELECTED_PCKPRV TABLES U_ITAB LIKE GT_PCKPRV.
  DATA: LD_CHOICE TYPE C.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      TEXT_QUESTION         = 'Do you want to delete MULTIPLE products?'
      TEXT_BUTTON_1         = 'Yes'(001)
      TEXT_BUTTON_2         = 'No'(002)
      DISPLAY_CANCEL_BUTTON = ''
    IMPORTING
      ANSWER                = LD_CHOICE.
  IF LD_CHOICE = '1'.
    PERFORM HANDLE_PCKPRV_FINAL_DELETION TABLES U_ITAB.

  ELSEIF LD_CHOICE = '2'.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_PCKPRV_FINAL_DELETION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM HANDLE_PCKPRV_FINAL_DELETION TABLES U_ITAB LIKE GT_PCKPRV.
  LOOP AT U_ITAB INTO DATA(S_ROW).
    APPEND S_ROW TO GT_PCKPRV_DELETED.

    DELETE TABLE GT_PCKPRV FROM S_ROW.

    IF SY-SUBRC <> 0.
      MESSAGE E000(Z03S24999_DOMUS_MSGS) WITH 'One deleting Product in Package has caused an error!'.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form WARNING_PACKAGE_CHANGES_EXIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM WARNING_PACKAGE_CHANGES_EXIST .
  DATA: LD_CHOICE TYPE CHAR01.
  IF GS_PACKAGE_DETAIL_BEFORE_MOD <> GS_PACKAGE_DETAIL OR
     GT_PCKPRV_BEFORE_MOD <> GT_PCKPRV OR
     GT_PCKSER_BEFORE_MOD <> GT_PCKSER OR
     GT_PCKIMG_BEFORE_MOD <> GT_PCKIMG.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        TEXT_QUESTION         = 'Do you want to save before switching mode?'
        TEXT_BUTTON_1         = 'Yes'(001)
        TEXT_BUTTON_2         = 'No'(002)
        DISPLAY_CANCEL_BUTTON = ''
      IMPORTING
        ANSWER                = LD_CHOICE.
    IF LD_CHOICE = '1'.
      PERFORM CHANGE_PACKAGE_DETAIL.
      PERFORM PREPARE_PACKAGE_DETAIL USING GV_PACKAGE_ID.
    ELSEIF LD_CHOICE = '2'.
      PERFORM PREPARE_PACKAGE_DETAIL USING GV_PACKAGE_ID.
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_PRODUCT_0127_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_PRODUCT_0127_ALV.
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_PRO_0127_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_PRODUCT_0127_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_PRODUCT_0127_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_PRODUCT_0127_FCAT
*&---------------------------------------------------------------------*
FORM ADD_PRODUCT_0127_FCAT USING U_FIELDNAME
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
*& Form PREPARE_PRODUCT_0127_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_PRO_0127_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_PRODUCT_0127_FCAT USING 'PRODUCT_CODE' 'Code'        12 '' 'X'  'C100'  CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0127_FCAT USING 'BRAND'        'Brand'       16 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0127_FCAT USING 'PRODUCT_NAME' 'Name'        22 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0127_FCAT USING 'CREATED_BY'   'Created By'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0127_FCAT USING 'CREATED_AT'   'Created At'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0127_FCAT USING 'CREATED_ON'   'Created On'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0127_FCAT USING 'UPDATED_BY'   'Updated By'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0127_FCAT USING 'UPDATED_AT'   'Updated At'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0127_FCAT USING 'UPDATED_ON'   'Updated On'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_PRODUCT_0127_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_PRODUCT_0127_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_PRODUCT_0127_CONTAINER IS INITIAL.
    O_PRODUCT_0127_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0127' ).
  ENDIF.

  IF O_PRODUCT_0127_ALV_TABLE IS INITIAL.
    O_PRODUCT_0127_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_PRODUCT_0127_CONTAINER ).
  ENDIF.

  O_PRODUCT_0127_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_PRODUCT_0127     " Output Table
      IT_FIELDCATALOG               = CH_T_FIELD_CAT   " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).

  IF SY-SUBRC <> 0.
    MESSAGE E005(Z03S24999_DOMUS_MSGS).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_PRODUCT_0127_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_PRODUCT_0127_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_PROVRT_0126_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_PROVRT_0126_ALV.
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_PRO_0126_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_PROVRT_0126_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_PROVRT_0126_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_PROVRT_0126_FCAT
*&---------------------------------------------------------------------*
FORM ADD_PROVRT_0126_FCAT USING U_FIELDNAME
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
*& Form PREPARE_PROVRT_0126_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_PRO_0126_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_PROVRT_0126_FCAT USING 'VARIANT_CODE'  'Variant'     6 ''  'X'  'C311'  CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0126_FCAT USING 'PRODUCT_CODE'  'Code'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0126_FCAT USING 'PRODUCT_NAME'  'Name'        20 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0126_FCAT USING 'DISPLAY_PRICE' 'Price'       14 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0126_FCAT USING 'CREATED_BY'    'Created By'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0126_FCAT USING 'CREATED_AT'    'Created At'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0126_FCAT USING 'CREATED_ON'    'Created On'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0126_FCAT USING 'UPDATED_BY'    'Updated By'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0126_FCAT USING 'UPDATED_AT'    'Updated At'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0126_FCAT USING 'UPDATED_ON'    'Updated On'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_PROVRT_0126_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_PROVRT_0126_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_PROVRT_0126_CONTAINER IS INITIAL.
    O_PROVRT_0126_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0126' ).
  ENDIF.

  IF O_PROVRT_0126_ALV_TABLE IS INITIAL.
    O_PROVRT_0126_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_PROVRT_0126_CONTAINER ).
  ENDIF.

  O_PROVRT_0126_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_PROVRT_0126     " Output Table
      IT_FIELDCATALOG               = CH_T_FIELD_CAT   " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).

  IF SY-SUBRC <> 0.
    MESSAGE E005(Z03S24999_DOMUS_MSGS).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_PROVRT_0126_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_PROVRT_0126_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_PACKAGE_DETAIL_NAME
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHECK_PACKAGE_DETAIL_NAME.
  IF GS_PACKAGE_DETAIL-NAME IS INITIAL.
    MESSAGE E014(Z03S24999_DOMUS_MSGS).
    SET CURSOR FIELD 'GS_PACKAGE_DETAIL-NAME'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_PACKAGE_DETAIL_DESCRIPTION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHECK_PCK_DETAIL_DESCRIPTION.
  IF GS_PACKAGE_DETAIL-DESCRIPTION IS INITIAL.
    MESSAGE E014(Z03S24999_DOMUS_MSGS).
    SET CURSOR FIELD 'GS_PACKAGE_DETAIL-DESCRIPTION'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_PCKPRV_QUANTITY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHECK_PCKPRV_QUANTITY.
  IF GS_PCKPRV-QUANTITY IS INITIAL.
    MESSAGE E014(Z03S24999_DOMUS_MSGS).
    SET CURSOR FIELD 'GS_PCKPRV-QUANTITY' LINE PCKIMG_TABLE_CONTROL-CURRENT_LINE.
  ELSE.
    IF GS_PCKPRV-QUANTITY < 1 OR GS_PCKPRV-QUANTITY > 255.
      MESSAGE E012(Z03S24999_DOMUS_MSGS).
      SET CURSOR FIELD 'GS_PCKPRV-QUANTITY' LINE PCKPRV_TABLE_CONTROL-CURRENT_LINE.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_PCKIMG_URL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHECK_PCKIMG_URL.
  IF GS_PCKIMG-IMAGE_URL IS INITIAL.

    MESSAGE E014(Z03S24999_DOMUS_MSGS).
    SET CURSOR FIELD 'GS_PCKIMG-IMAGE_URL' LINE PCKIMG_TABLE_CONTROL-CURRENT_LINE.

  ELSE.
    IF GS_PCKIMG-IMAGE_URL CP 'https://*' OR GS_PCKIMG-IMAGE_URL CP 'http://*'.
*      IF GS_PCKIMG-IMAGE_URL CP '*.jpg' OR
*         GS_PCKIMG-IMAGE_URL CP '*.jpeg' OR
*         GS_PCKIMG-IMAGE_URL CP '*.png' OR
*         GS_PCKIMG-IMAGE_URL CP '*.avif' OR
*         GS_PCKIMG-IMAGE_URL CP '*.gif'.
*
*      ELSE.
*        MESSAGE E000(Z03S24999_DOMUS_MSGS) WITH 'Invalid File Extension for Image!'.
*        SET CURSOR FIELD 'GS_PCKIMG-IMAGE_URL' LINE PCKIMG_TABLE_CONTROL-CURRENT_LINE.
*      ENDIF.
    ELSE.
      MESSAGE E000(Z03S24999_DOMUS_MSGS) WITH 'Invalid URL - Must start with https:// or http://.'.
      SET CURSOR FIELD 'GS_PCKIMG-IMAGE_URL' LINE PCKIMG_TABLE_CONTROL-CURRENT_LINE.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_INIT_PACKAGE_COLOR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_INIT_PACKAGE_COLOR .
  CLEAR: GT_PACKAGE_COLOR.
  GT_PACKAGE_COLOR = VALUE #(
                              ( COL = 3 INT = 0 INV = 0 )
                              ( COL = 1 INT = 0 INV = 0 )
                              ( COL = 5 INT = 0 INV = 0 )
                              ( COL = 7 INT = 0 INV = 0 )
                              ( COL = 5 INT = 1 INV = 0 )
                              ( COL = 5 INT = 0 INV = 1 )
                             ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_PACKAGE_COLOR
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      -->
*&      <--
*&---------------------------------------------------------------------*
FORM CHANGE_PACKAGE_COLOR  USING    U_LINE_INDEX  TYPE SYST_TABIX
                           CHANGING CH_LINE_COLOR TYPE LVC_T_SCOL.
  DATA LS_COLOR TYPE LVC_S_SCOL.
  DATA: LV_COLOR_INDEX TYPE INT1.

  CLEAR: CH_LINE_COLOR.
  LV_COLOR_INDEX = ( ( U_LINE_INDEX - 1 ) MOD 2 ) + 1.

  TRY.
      MOVE-CORRESPONDING GT_PACKAGE_COLOR[ LV_COLOR_INDEX ] TO LS_COLOR-COLOR.

      LS_COLOR-FNAME = 'DESCRIPTION'.
      APPEND LS_COLOR TO CH_LINE_COLOR.

      MOVE-CORRESPONDING GT_PACKAGE_COLOR[ LV_COLOR_INDEX + 4 ] TO LS_COLOR-COLOR.

      LS_COLOR-FNAME = 'NAME'.
      APPEND LS_COLOR TO CH_LINE_COLOR.

      MOVE-CORRESPONDING GT_PACKAGE_COLOR[ LV_COLOR_INDEX + 2 ] TO LS_COLOR-COLOR.

      LS_COLOR-FNAME = 'CREATED_BY'.
      APPEND LS_COLOR TO CH_LINE_COLOR.

      LS_COLOR-FNAME = 'UPDATED_BY'.
      APPEND LS_COLOR TO CH_LINE_COLOR.

    CATCH CX_SY_ITAB_LINE_NOT_FOUND.

  ENDTRY.

ENDFORM.

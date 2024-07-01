*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_PACKAGE_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0120
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

    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Package' DISPLAY LIKE 'E'.
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
FORM HANDLE_UCOMM_0129 USING U_OKCODE.
  CASE U_OKCODE.
    WHEN 'BACK_TO_PACKAGE_LIST'.
      PACKAGE_SCREEN_MODE = '0120'.
      CLEAR: U_OKCODE.

    WHEN 'DISPLAY<->CHANGE'.
      CASE GV_PACKAGE_SCREEN_MODE.
        WHEN GC_PACKAGE_MODE_DISPLAY.
          GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_CHANGE.
        WHEN GC_PACKAGE_MODE_CHANGE.
          GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_DISPLAY.
        WHEN OTHERS.
      ENDCASE.
      CLEAR: U_OKCODE.

    WHEN 'OPEN_PCKIMG_URL'.

      DATA: LV_SEL_PCKIMGS TYPE STANDARD TABLE OF TY_PCKIMG.

      LOOP AT GT_PCKIMG INTO DATA(LS_ROW).
        IF LS_ROW-SEL = 'X'.
          APPEND LS_ROW TO LV_SEL_PCKIMGS.
        ENDIF.
      ENDLOOP.

      IF LINES( LV_SEL_PCKIMGS ) = 0.
        MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'at least' ' one' ' Image' DISPLAY LIKE 'E'.
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

      CLEAR: U_OKCODE.
    WHEN 'INSERT_PCKSER'.
      CALL SCREEN 0128 STARTING AT 10 08 ENDING AT 70 15.
*      READ TABLE GT_PCKSER INDEX 1 INTO GS_PCKSER.
*      CLEAR: GS_PCKSER.
*      IF GS_PCKSER-PACKAGE_ID <> ''.
*        GS_PCKSER-PACKAGE_ID = GS_PACKAGE_DETAIL-ID.
*      ENDIF.
*      APPEND GS_PCKSER TO GT_PCKSER.

      CLEAR: U_OKCODE.
    WHEN 'INSERT_PCKPRV'.
*      READ TABLE GT_PCKPRV INDEX 1 INTO GS_PCKPRV.
*      CLEAR: GS_PCKPRV.
*      IF GS_PCKPRV- <> ''.
*        GS_PCKPRV- = GS_PCKPRV-.
*      ENDIF.
*      APPEND GS_PCKPRV TO GT_PCKPRV.

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

      IF O_PACKAGE_ALV_TABLE IS NOT INITIAL.

        DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
        DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.

        CALL METHOD O_PACKAGE_ALV_TABLE->GET_SELECTED_ROWS
          IMPORTING
            ET_INDEX_ROWS = LT_INDEX_ROWS.

        IF LINES( LT_INDEX_ROWS ) = 1.

          READ TABLE LT_INDEX_ROWS INDEX 1 INTO LS_INDEX_ROW.
          READ TABLE IT_PACKAGE INDEX LS_INDEX_ROW INTO DATA(LS_PACKAGE).

          GV_PACKAGE_ID = LS_PACKAGE-ID.

          PERFORM PREPARE_PACKAGE_DETAIL USING GV_PACKAGE_ID.
          PACKAGE_SCREEN_MODE = '0129'.

        ELSEIF LINES( LT_INDEX_ROWS ) = 0.
          MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH '' 'one' ' Package' DISPLAY LIKE 'E'.
        ELSEIF LINES( LT_INDEX_ROWS ) > 1.
          MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'only' ' one' ' Package' DISPLAY LIKE 'E'.
        ENDIF.

      ELSE.
        MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH '' 'one' ' Package' DISPLAY LIKE 'E'.
      ENDIF.

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
  CLEAR: GV_PACKAGE_TOTAL_PRICE.
  CLEAR: GV_PCKPRV_TOTAL_PRICE.
  CLEAR: GV_PCKSER_TOTAL_PRICE.

  SELECT SINGLE *
    FROM Y03S24999_PACKGE
    INTO CORRESPONDING FIELDS OF GS_PACKAGE_DETAIL
    WHERE ID = U_PACKAGE_ID AND IS_DELETED <> ABAP_TRUE.

  IF SY-SUBRC <> 0.
    MESSAGE 'Package is not found.' TYPE 'E'.
  ENDIF.

  PERFORM GET_PACKAGE_PRODUCT_ITEMS USING U_PACKAGE_ID.
  PERFORM GET_PACKAGE_SERVICE_ITEMS USING U_PACKAGE_ID.
  PERFORM GET_PACKAGE_IMAGE_ITEMS   USING U_PACKAGE_ID.

  GV_PACKAGE_TOTAL_PRICE = GV_PCKPRV_TOTAL_PRICE + GV_PCKSER_TOTAL_PRICE.

  GS_PACKAGE_DETAIL_BEFORE_MOD = GS_PACKAGE_DETAIL.
  GT_PCKPRV_BEFORE_MOD = GT_PCKPRV.
  GT_PCKSER_BEFORE_MOD = GT_PCKSER.
  GT_PCKIMG_BEFORE_MOD = GT_PCKIMG.

  CLEAR: GT_PCKPRV_DELETED.
  CLEAR: GT_PCKSER_DELETED.
  CLEAR: GT_PCKIMG_DELETED.

  GV_PACKAGE_SCREEN_MODE = GC_PACKAGE_MODE_DISPLAY.

  MESSAGE S009(Z03S24999_DOMUS_MSGS) WITH 'Package'.
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

    GV_PCKPRV_TOTAL_PRICE = 0.
    LOOP AT GT_PCKPRV INTO DATA(LS_ROW).
      GV_PCKPRV_TOTAL_PRICE += LS_ROW-TOTAL_PRICE.
    ENDLOOP.

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

  GV_PCKSER_TOTAL_PRICE = 0.
  LOOP AT GT_PCKSER INTO DATA(LS_ROW).
    GV_PCKSER_TOTAL_PRICE += LS_ROW-DISPLAY_PRICE.
  ENDLOOP.
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
*& Include          Z03_S24_999_PACKAGE_FORM
*&---------------------------------------------------------------------*
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

      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.
    WHEN 'CANCLE_128'.

      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.
    WHEN OTHERS.
  ENDCASE.
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

  SELECT *
    FROM Y03S24999_SERVCE
    WHERE IS_DELETED <> @ABAP_TRUE
    ORDER BY CREATED_ON DESCENDING, CREATED_AT DESCENDING
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

    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Service' DISPLAY LIKE 'E'.
    CH_V_SUCCESS = ABAP_FALSE.
    RETURN.
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
  PERFORM PREPARESERVICE0128FIELDCATALOG
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
FORM PREPARESERVICE0128FIELDCATALOG
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

  IF SY-SUBRC = 0.
    MESSAGE S006(Z03S24999_DOMUS_MSGS) WITH 'Service'.
  ELSE.
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

*&---------------------------------------------------------------------*
*& Include          Z03_S24_CUST_FORM
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form HANDLE_EXIT_COMMAND
*&---------------------------------------------------------------------*
FORM HANDLE_EXIT_COMMAND USING IN_UCOMM.
  CASE IN_UCOMM.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
    WHEN 'CANC' OR 'EXIT'.
      LEAVE PROGRAM.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_1000
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&      --> U_USERNAME
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_1000 USING U_OKCODE
                             U_USERNAME.
  IF U_OKCODE = 'CFM'.
    DATA: LV_IS_CUSTOMER TYPE YS03S24999_ROLES-IS_CUSTOMER.
      SELECT SINGLE IS_CUSTOMER FROM Y03S24999_USER
        WHERE USERNAME = @U_USERNAME
        INTO @LV_IS_CUSTOMER.
      IF SY-SUBRC = 0.
        IF LV_IS_CUSTOMER = ABAP_TRUE.
          MESSAGE 'Welcome' TYPE 'S'.
          CALL SCREEN 100.
        ENDIF.
        CLEAR: U_OKCODE.
      ENDIF.
   ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&      --> U_QCODE
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0100 USING U_OKCODE.
  CASE U_OKCODE.
    WHEN 'GET_ALL'.
      MESSAGE 'All quotations' TYPE 'S'.
      PERFORM PROCESS_QUOTATION_LIST_0100.
      CLEAR: U_OKCODE.
    WHEN 'VIEW_DETAILS'.
      PERFORM PROCESS_VIEW_QUOTATION_DETAIL CHANGING GV_QUOTATION_ID.
      CLEAR: U_OKCODE.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form PROCESS_QUOTATION_LIST_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*

FORM PROCESS_QUOTATION_LIST_0100.
  DATA: LV_SUCCESS TYPE ABAP_BOOL.
  PERFORM GET_QUOTATION_DATA CHANGING LV_SUCCESS.
  IF LV_SUCCESS = ABAP_FALSE.
    RETURN.
  ENDIF.
  PERFORM SHOW_QUOTATION_ALV.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form GET_QUOTATION_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_QUOTATION_DATA CHANGING CH_V_SUCCESS TYPE ABAP_BOOL.
  CLEAR: IT_QUOTATION[], CH_V_SUCCESS.

  SELECT Q~*, P~NAME AS PACKAGE_NAME
    FROM Y03S24999_QUOTA AS Q
    LEFT JOIN Y03S24999_PACKGE AS P
    ON Q~PACKAGE_ID = P~ID
    WHERE Q~QUOTATION_CODE IN @P_QCODE
      AND Q~IS_DELETED <> @ABAP_TRUE
      AND P~IS_DELETED <> @ABAP_TRUE
      AND Q~CUSTOMER = @GV_USERNAME
    ORDER BY Q~UPDATED_ON DESCENDING,
             Q~UPDATED_AT DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @IT_QUOTATION.

  IF SY-SUBRC <> 0.
    CLEAR IT_QUOTATION[].

    IF O_QUOTATION_CONTAINER IS NOT INITIAL.
      CALL METHOD O_QUOTATION_CONTAINER->FREE.
      CLEAR O_QUOTATION_CONTAINER.
    ENDIF.
    IF O_QUOTATION_ALV_TABLE IS NOT INITIAL.
      CLEAR O_QUOTATION_ALV_TABLE.
    ENDIF.
    CH_V_SUCCESS = ABAP_FALSE.
    RETURN.
  ELSE.
    CH_V_SUCCESS = ABAP_TRUE.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form SHOW_QUOTATION_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_QUOTATION_ALV.
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_QUOTA_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_QUOTATION_LAYOUT
    CHANGING LS_LAYOUT.

* Show ALV
  PERFORM DISPLAY_QUOTATION_ALV_TABLE
    CHANGING LS_LAYOUT
             LT_FIELD_CAT.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form ADD_QUOTATION_FCAT
*&---------------------------------------------------------------------*
FORM ADD_QUOTATION_FCAT USING U_FIELDNAME
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
*& Form PREPARE_QUOTA_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_QUOTA_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_QUOTATION_FCAT USING 'QUOTATION_CODE' 'Quotation'         10 'X' 'X' ''      CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'CUSTOMER'       'Customer'          10 ''  ''  'C500'  CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'STAFF'          'Staff'             10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'STATUS'         'Status'            10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'PACKAGE_NAME'   'Reference Package' 32 ''  ''  'C700'  CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'EXPIRED_ON'     'Expired On'        10 ''  ''  'C601'  CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'EXPIRED_AT'     'Expired At'        10 ''  ''  'C701'  CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'CREATED_BY'     'Created By'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'CREATED_AT'     'Created At'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'CREATED_ON'     'Created On'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'UPDATED_BY'     'Updated By'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'UPDATED_AT'     'Updated At'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'UPDATED_ON'     'Updated On'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_QUOTATION_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_QUOTATION_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
  IF O_QUOTATION_CONTAINER IS INITIAL.
    O_QUOTATION_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0100' ).
  ENDIF.

  IF O_QUOTATION_ALV_TABLE IS INITIAL.
    O_QUOTATION_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_QUOTATION_CONTAINER ).
  ENDIF.
  O_QUOTATION_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
    CHANGING
      IT_OUTTAB                     = IT_QUOTATION     " Output Table
      IT_FIELDCATALOG               = CH_T_FIELD_CAT   " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).
ENDFORM.

*&---------------------------------------------------------------------*
*& Form PREPARE_QUOTATION_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_QUOTATION_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-SEL_MODE = 'A'.
ENDFORM.



*&---------------------------------------------------------------------*
*& Form PROCESS_VIEW_QUOTATION_DETAIL
*&---------------------------------------------------------------------*
FORM PROCESS_VIEW_QUOTATION_DETAIL CHANGING CH_QUOTATION_ID.
  IF O_QUOTATION_ALV_TABLE IS NOT INITIAL.
    DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
    DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.
    CALL METHOD O_QUOTATION_ALV_TABLE->GET_SELECTED_ROWS
      IMPORTING
        ET_INDEX_ROWS = LT_INDEX_ROWS.

    IF LINES( LT_INDEX_ROWS ) = 1.
      READ TABLE LT_INDEX_ROWS INDEX 1 INTO LS_INDEX_ROW.
      READ TABLE IT_QUOTATION INDEX LS_INDEX_ROW INTO DATA(LS_QUOTATION).
      CH_QUOTATION_ID = LS_QUOTATION-ID.
      PERFORM PREPARE_QUOTATION_DETAIL USING CH_QUOTATION_ID.

    ELSEIF LINES( LT_INDEX_ROWS ) = 0.
      MESSAGE 'Select one Quotation' TYPE 'E'.
    ELSEIF LINES( LT_INDEX_ROWS ) > 1.
      MESSAGE 'Select only one Quotation' TYPE 'E'.
    ENDIF.

  ELSE.
    MESSAGE 'Select one Quotation' TYPE 'E'.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form PREPARE_QUOTATION_DETAIL
*&---------------------------------------------------------------------*
FORM PREPARE_QUOTATION_DETAIL USING U_QUOTATION_ID.
  DATA: LV_QUOVER_ID TYPE Y03S24999_QUOVER-ID.
  CLEAR: GV_QUOVER_TOTAL_PRICE.
  CLEAR: GV_QVSPRV_TOTAL_PRICE.
  CLEAR: GV_QVSSER_TOTAL_PRICE.

  PERFORM GET_QUOTATION_BASIC_INFO USING U_QUOTATION_ID CHANGING LV_QUOVER_ID.
  PERFORM GET_QUOVER_PRODUCT_ITEMS USING LV_QUOVER_ID.
  PERFORM GET_QUOVER_SERVICE_ITEMS USING LV_QUOVER_ID.
  PERFORM GET_QUOMSG_ITEMS         USING U_QUOTATION_ID.

  QUOTATION_SCREEN_MODE = '0200'.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form GET_QUOTATION_BASIC_INFO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_QUOTATION_ID
*&---------------------------------------------------------------------*
FORM GET_QUOTATION_BASIC_INFO USING U_QUOTATION_ID
                              CHANGING CH_QUOVER_ID.

  SELECT SINGLE QUOTA~ID, QUOTATION_CODE, STATUS, CUSTOMER, STAFF,
                QUOTA~CREATED_ON, QUOTA~CREATED_AT, EXPIRED_ON, EXPIRED_AT,
                PACKGE~NAME AS PACKAGE_NAME, PCKIMG~IMAGE_URL AS PCKIMG_URL,
                QUOVER~ID AS QUOVER_ID,
                QUOVER~VERSION_ORDER AS QUOVER_VERSION_ORDER,
                QUOVER~CREATED_AT AS QUOVER_CREATED_AT,
                QUOVER~CREATED_ON AS QUOVER_CREATED_ON

    FROM Y03S24999_QUOTA AS QUOTA

    LEFT JOIN Y03S24999_PACKGE AS PACKGE
      ON QUOTA~PACKAGE_ID = PACKGE~ID

    LEFT JOIN Y03S24999_PCKIMG AS PCKIMG
      ON PCKIMG~PACKAGE_ID = PACKGE~ID

    JOIN Y03S24999_QUOVER AS QUOVER
      ON QUOVER~QUOTATION_ID = QUOTA~ID

    WHERE QUOTA~ID = @U_QUOTATION_ID AND
          QUOTA~IS_DELETED <> @ABAP_TRUE AND
          QUOVER~IS_DELETED <> @ABAP_TRUE AND
          PCKIMG~IS_DELETED <> @ABAP_TRUE AND
          PCKIMG~IMAGE_URL <> '' AND
          QUOVER~VERSION_ORDER = ( SELECT MAX( VERSION_ORDER )
                                    FROM Y03S24999_QUOVER
                                    WHERE QUOTATION_ID = @U_QUOTATION_ID
                                    AND IS_DELETED <> @ABAP_TRUE )

    INTO CORRESPONDING FIELDS OF @GS_QUOTATION_DETAIL.

*    CH_QUOVER_ID = GS_QUOTATION_DETAIL-QUOVER_ID.
*    GV_QUOPCKIMG_URL = GS_QUOTATION_DETAIL-PCKIMG_URL.
*    PERFORM SHOW_QUOPCK_SELECTED_IMAGE USING GV_QUOPCKIMG_URL.
ENDFORM.


*&---------------------------------------------------------------------*
*& Form GET_QUOVER_PRODUCT_VARIANT_ITEMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_QUOVER_ID
*&---------------------------------------------------------------------*
FORM GET_QUOVER_PRODUCT_ITEMS USING U_QUOVER_ID.
  SELECT ' ' AS SEL,
         QVSPRV~*,
         PROVRT~VARIANT_CODE AS VARIANT_CODE,
         ( QVSPRV~PRICE * QVSPRV~QUANTITY ) AS TOTAL_PRICE,
         PROVRT~PRODUCT_ID
  FROM Y03S24999_QVSPRV AS QVSPRV
  JOIN Y03S24999_PROVRT AS PROVRT
  ON QVSPRV~PRODUCT_VARIANT_ID = PROVRT~ID
  WHERE QVSPRV~IS_DELETED <> @ABAP_TRUE AND
        QVSPRV~QUOTATION_VERSION_ID = @U_QUOVER_ID
  INTO CORRESPONDING FIELDS OF TABLE @GT_QVSPRV.
    SELECT GT~*,
           PRODCT~PRODUCT_NAME
    FROM @GT_QVSPRV AS GT
    JOIN Y03S24999_PRODCT AS PRODCT
    ON GT~PRODUCT_ID = PRODCT~ID
    INTO CORRESPONDING FIELDS OF TABLE @GT_QVSPRV.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form GET_QUOMSG_ITEMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_QUOVER_ID
*&---------------------------------------------------------------------*
FORM GET_QUOMSG_ITEMS USING U_QUOTATION_ID.
  CLEAR: GT_QUOMSG.
  SELECT QUOMSG~*
  FROM Y03S24999_QUOMSG AS QUOMSG
  JOIN Y03S24999_QUOTA AS QUOTA
  ON QUOMSG~QUOTATION_ID = QUOTA~ID
  WHERE QUOMSG~IS_DELETED <> @ABAP_TRUE
    AND QUOMSG~QUOTATION_ID = @U_QUOTATION_ID
  ORDER BY QUOMSG~CREATED_ON ASCENDING, QUOMSG~CREATED_AT ASCENDING
  INTO CORRESPONDING FIELDS OF TABLE @GT_QUOMSG.
  LOOP AT GT_QUOMSG INTO DATA(LS_ROW).
    IF LS_ROW-IS_CUSTOMER_MESSAGE = ABAP_TRUE.
      LS_ROW-USER_SENDING = 'Customer'.
    ELSE.
      LS_ROW-USER_SENDING = 'Staff'.
    ENDIF.
    MODIFY GT_QUOMSG FROM LS_ROW.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form GET_QUOVER_SERVICE_ITEMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_QUOVER_ID
*&---------------------------------------------------------------------*
FORM GET_QUOVER_SERVICE_ITEMS USING U_QUOVER_ID.
  SELECT ' ' AS SEL,
         QS~*,
         S~NAME AS SERVICE_NAME
  FROM Y03S24999_QVSSER AS QS
  JOIN Y03S24999_SERVCE AS S
  ON QS~SERVICE_ID = S~ID
  WHERE QS~IS_DELETED <> @ABAP_TRUE AND
        QS~QUOTATION_VERSION_ID = @U_QUOVER_ID
  INTO CORRESPONDING FIELDS OF TABLE @GT_QVSSER.
ENDFORM.

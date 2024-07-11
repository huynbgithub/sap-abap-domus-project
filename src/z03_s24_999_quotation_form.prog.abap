*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_QUOTATION_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0130
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&      --> U_QCODE
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0130 USING U_OKCODE.
  CASE U_OKCODE.
    WHEN 'EXECUTE'.
      PERFORM PROCESS_QUOTATION_LIST_0130.
      CLEAR: U_OKCODE.

    WHEN 'VIEW_QUOTATION'.
      PERFORM PROCESS_VIEW_QUOTATION_DETAIL CHANGING GV_QUOTATION_ID.
      CLEAR: U_OKCODE.

    WHEN OTHERS.

  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_QUOTATION_LIST_0130
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_QUOTATION_LIST_0130.
  DATA: LV_SUCCESS TYPE ABAP_BOOL.

  PERFORM INIT_QUOTATION_STATUS_COLOR CHANGING GT_QUOTATION_COLOR.
* Get data from QUOTATION table
  PERFORM GET_QUOTATION_DATA CHANGING LV_SUCCESS.
  IF LV_SUCCESS = ABAP_FALSE.
    RETURN.
  ENDIF.
* Show QUOTATION ALV
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
      AND Q~STAFF = @GV_USERNAME
    ORDER BY Q~UPDATED_ON DESCENDING,
             Q~UPDATED_AT DESCENDING,
             Q~QUOTATION_CODE DESCENDING
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
    IF O_QUOTATION_HANDLER IS NOT INITIAL.
      CLEAR O_QUOTATION_HANDLER.
    ENDIF.

    MESSAGE S004(Z03S24999_DOMUS_MSGS) DISPLAY LIKE 'E'.
    CH_V_SUCCESS = ABAP_FALSE.
    RETURN.
  ELSE.
    CH_V_SUCCESS = ABAP_TRUE.
  ENDIF.

  LOOP AT IT_QUOTATION ASSIGNING FIELD-SYMBOL(<LS_DATA>).
    PERFORM CHANGE_QUOTATION_COLOR USING <LS_DATA>-STATUS CHANGING <LS_DATA>-LINE_COLOR.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT_QUOTATION_STATUS_COLOR
*&---------------------------------------------------------------------*
FORM INIT_QUOTATION_STATUS_COLOR CHANGING CH_QCOLOR LIKE GT_QUOTATION_COLOR.
  IF CH_QCOLOR IS INITIAL.
    CH_QCOLOR = VALUE #( ( STATUS = 'Negotiating' COL = 7 INT = 1 INV = 1 )
                         ( STATUS = 'Accepted'    COL = 3 INT = 1 INV = 1 )
                         ( STATUS = 'Cancelled'   COL = 6 INT = 1 INV = 1 )
                         ( STATUS = 'Requested'   COL = 5 INT = 1 INV = 1 ) ).
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
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_QUOTA_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_QUOTATION_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_QUOTATION_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
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
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_QUOTATION_CONTAINER IS INITIAL.
    O_QUOTATION_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0130' ).
  ENDIF.

  IF O_QUOTATION_ALV_TABLE IS INITIAL.
    O_QUOTATION_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_QUOTATION_CONTAINER ).
  ENDIF.

  O_QUOTATION_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_QUOTATION     " Output Table
      IT_FIELDCATALOG               = CH_T_FIELD_CAT   " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).

  IF O_QUOTATION_HANDLER IS INITIAL.
    O_QUOTATION_HANDLER = NEW CL_QUOTATION_ALV_HANDLER( ).
    SET HANDLER O_QUOTATION_HANDLER->HOTSPOT_CLICK FOR O_QUOTATION_ALV_TABLE.
  ENDIF.

  IF SY-SUBRC = 0.
    MESSAGE S006(Z03S24999_DOMUS_MSGS) WITH 'Quotation'.
  ELSE.
    MESSAGE E005(Z03S24999_DOMUS_MSGS).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_QUOTATION_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_QUOTATION_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

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
*  CH_S_VARIANT-VARIANT = '/CUSTOM_CONTROL_ALV_0130'.
*
*ENDFORM.
*---------------------------------------------------------------------*
* SET_QCODE_INITIAL_VALUES
*---------------------------------------------------------------------*
FORM SET_QCODE_INITIAL_VALUES.
  IF P_QCODE[] IS INITIAL.
*    P_QCODE-SIGN   = 'I'.  " Include
*    P_QCODE-OPTION = 'EQ'. " EQ Equal
*    P_QCODE-LOW    = 'Q000000156'.

    P_QCODE-SIGN   = 'I'.  " Include
    P_QCODE-OPTION = 'BT'. " BT Between
    P_QCODE-LOW    = 'Q000000000'. " From Q000000000
    P_QCODE-HIGH   = 'Q999999999'. " To   Q999999999

*  P_QCODE-SIGN   = 'I'.  " Include
*  P_QCODE-OPTION = 'CP'. " CP Contain Pattern
*  P_QCODE-LOW    = 'Q*'. " Begin with 'Q'
    APPEND P_QCODE.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_QUOTATION_COLOR
*&---------------------------------------------------------------------*
FORM CHANGE_QUOTATION_COLOR  USING    U_QSTATUS      TYPE Y03S24999_QUOTA-STATUS
                             CHANGING CH_LINE_COLOR  TYPE LVC_T_SCOL.

  DATA LS_COLOR TYPE LVC_S_SCOL.
  CLEAR: CH_LINE_COLOR.

  LS_COLOR-FNAME = 'STATUS'.

  TRY.
      MOVE-CORRESPONDING GT_QUOTATION_COLOR[ STATUS =  U_QSTATUS ] TO LS_COLOR-COLOR.
      APPEND LS_COLOR TO CH_LINE_COLOR.

    CATCH CX_SY_ITAB_LINE_NOT_FOUND.

  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_VIEW_QUOTATION_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  CH_QUOTATION_ID
*& <--  CH_QUOTATION_ID
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
* Prepare QUOTATION Detail to display on Screen 0139
      PERFORM PREPARE_QUOTATION_DETAIL USING CH_QUOTATION_ID.

    ELSEIF LINES( LT_INDEX_ROWS ) = 0.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'one Quotation' DISPLAY LIKE 'E'.
    ELSEIF LINES( LT_INDEX_ROWS ) > 1.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'only one Quotation' DISPLAY LIKE 'E'.
    ENDIF.

  ELSE.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'one Quotation' DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_QUOTATION_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PREPARE_QUOTATION_DETAIL USING U_QUOTATION_ID.
  DATA: LV_QUOVER_ID TYPE Y03S24999_QUOVER-ID.

  CLEAR: GV_QUOVER_TOTAL_PRICE.
  CLEAR: GV_QVSPRV_TOTAL_PRICE.
  CLEAR: GV_QVSSER_TOTAL_PRICE.

  PERFORM GET_QUOTATION_BASIC_INFO USING U_QUOTATION_ID
                                   CHANGING LV_QUOVER_ID.
  PERFORM GET_QUOVER_PRODUCT_ITEMS USING LV_QUOVER_ID.
  PERFORM GET_QUOVER_SERVICE_ITEMS USING LV_QUOVER_ID.
  PERFORM GET_QUOMSG_ITEMS         USING U_QUOTATION_ID.
*
  GS_QUOTATION_DETAIL_BEFORE_MOD = GS_QUOTATION_DETAIL.
  GT_QVSPRV_BEFORE_MOD = GT_QVSPRV.
  GT_QVSSER_BEFORE_MOD = GT_QVSSER.

  CLEAR: GT_QVSPRV_DELETED.
  CLEAR: GT_QVSSER_DELETED.

* Set Screen Mode to View only
  GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_DISPLAY.
* Change Screen from 0130 to 0139
  QUOTATION_SCREEN_MODE = '0139'.

  MESSAGE S009(Z03S24999_DOMUS_MSGS) WITH 'Quotation'.

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
                PACKGE~NAME AS PACKAGE_NAME, PCKIMG~IMAGE_URL,
                QUOVER~ID AS QUOVER_ID,
                MIN( PCKIMG~IMAGE_URL ) AS PCKIMG_URL,
                MAX( QUOVER~VERSION_ORDER ) AS QUOVER_VERSION_ORDER,
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
          QUOVER~IS_DELETED <> @ABAP_TRUE

    GROUP BY QUOTA~ID, STATUS, CUSTOMER, STAFF, QUOTATION_CODE,
             QUOTA~CREATED_ON, QUOTA~CREATED_AT, EXPIRED_ON, EXPIRED_AT,
             PACKGE~NAME, PCKIMG~IMAGE_URL,
             QUOVER~ID,
             QUOVER~CREATED_AT,
             QUOVER~CREATED_ON

    INTO CORRESPONDING FIELDS OF @GS_QUOTATION_DETAIL.

  IF SY-SUBRC <> 0.
    MESSAGE E004(Z03S24999_DOMUS_MSGS) WITH 'Quotation'.
  ELSE.

    CH_QUOVER_ID = GS_QUOTATION_DETAIL-QUOVER_ID.
    GV_QUOPCKIMG_URL = GS_QUOTATION_DETAIL-PCKIMG_URL.
    PERFORM SHOW_QUOPCK_SELECTED_IMAGE USING GV_QUOPCKIMG_URL.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_QUOPCK_SELECTED_IMAGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_QUOPCK_SELECTED_IMAGE USING U_QUOPCKIMG_URL TYPE CNDP_URL.
  IF QUOPCKIMG_CONTAINER IS INITIAL OR QUOPCKIMG_CONTROL IS INITIAL.

* Create controls
    CREATE OBJECT QUOPCKIMG_CONTAINER
      EXPORTING
        CONTAINER_NAME = 'CUSTOM_CONTROL_0139'.

    CREATE OBJECT QUOPCKIMG_CONTROL EXPORTING PARENT = QUOPCKIMG_CONTAINER.

* Register the events
    QUOPCKIMG_EVENT_TAB_LINE-EVENTID = CL_GUI_PICTURE=>EVENTID_PICTURE_DBLCLICK.
    APPEND QUOPCKIMG_EVENT_TAB_LINE TO QUOPCKIMG_EVENT_TAB.
    QUOPCKIMG_EVENT_TAB_LINE-EVENTID = CL_GUI_PICTURE=>EVENTID_CONTEXT_MENU.
    APPEND QUOPCKIMG_EVENT_TAB_LINE TO QUOPCKIMG_EVENT_TAB.
    QUOPCKIMG_EVENT_TAB_LINE-EVENTID = CL_GUI_PICTURE=>EVENTID_CONTEXT_MENU_SELECTED.
    APPEND QUOPCKIMG_EVENT_TAB_LINE TO QUOPCKIMG_EVENT_TAB.

    CALL METHOD QUOPCKIMG_CONTROL->SET_REGISTERED_EVENTS
      EXPORTING
        EVENTS = QUOPCKIMG_EVENT_TAB.

* Create the event_receiver object and set the handlers for the events
* of the picture controls
    CREATE OBJECT QUOPCKIMG_EVENT_RECEIVER.
    SET HANDLER QUOPCKIMG_EVENT_RECEIVER->EVENT_HANDLER_PICTURE_DBLCLICK
                FOR QUOPCKIMG_CONTROL.

* Set the display mode to 'normal' (0)
    CALL METHOD QUOPCKIMG_CONTROL->SET_DISPLAY_MODE
      EXPORTING
        DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_NORMAL.

* Set 3D Border
    CALL METHOD QUOPCKIMG_CONTROL->SET_3D_BORDER
      EXPORTING
        BORDER = 1.

    CALL METHOD QUOPCKIMG_CONTROL->SET_DISPLAY_MODE
      EXPORTING
        DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.

  ENDIF.

  CALL METHOD QUOPCKIMG_CONTROL->LOAD_PICTURE_FROM_URL_ASYNC
    EXPORTING
      URL = U_QUOPCKIMG_URL.

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
         PROVRT~DISPLAY_PRICE AS DISPLAY_PRICE,
         ( DISPLAY_PRICE * QVSPRV~QUANTITY ) AS TOTAL_PRICE,
         PROVRT~PRODUCT_ID
  FROM Y03S24999_QVSPRV AS QVSPRV
  JOIN Y03S24999_PROVRT AS PROVRT
  ON QVSPRV~PRODUCT_VARIANT_ID = PROVRT~ID
  WHERE QVSPRV~IS_DELETED <> @ABAP_TRUE
    AND QVSPRV~QUOTATION_VERSION_ID = @U_QUOVER_ID
  INTO CORRESPONDING FIELDS OF TABLE @GT_QVSPRV.

  IF SY-SUBRC <> 0.
    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Quotation Product Variant' DISPLAY LIKE 'E'.

  ELSE.
    SELECT GT~*,
           PRODCT~PRODUCT_NAME
    FROM @GT_QVSPRV AS GT
    JOIN Y03S24999_PRODCT AS PRODCT
    ON GT~PRODUCT_ID = PRODCT~ID
    INTO CORRESPONDING FIELDS OF TABLE @GT_QVSPRV.

    IF SY-SUBRC <> 0.
      MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Product Name' DISPLAY LIKE 'E'.
    ENDIF.

  ENDIF.
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
         S~NAME AS SERVICE_NAME,
         S~DISPLAY_PRICE AS DISPLAY_PRICE
  FROM Y03S24999_QVSSER AS QS
  JOIN Y03S24999_SERVCE AS S
  ON QS~SERVICE_ID = S~ID
  WHERE S~IS_DELETED <> @ABAP_TRUE
    AND QS~IS_DELETED <> @ABAP_TRUE
    AND QS~QUOTATION_VERSION_ID = @U_QUOVER_ID
  INTO CORRESPONDING FIELDS OF TABLE @GT_QVSSER.

  IF SY-SUBRC <> 0.
    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Quotation Service' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_QUOMSG_ITEMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_QUOVER_ID
*&---------------------------------------------------------------------*
FORM GET_QUOMSG_ITEMS USING U_QUOTATION_ID.
  SELECT QUOMSG~*
  FROM Y03S24999_QUOMSG AS QUOMSG
  JOIN Y03S24999_QUOTA AS QUOTA
  ON QUOMSG~QUOTATION_ID = QUOTA~ID
  WHERE QUOMSG~IS_DELETED <> @ABAP_TRUE
    AND QUOMSG~QUOTATION_ID = @U_QUOTATION_ID
  INTO CORRESPONDING FIELDS OF TABLE @GT_QUOMSG.

  IF SY-SUBRC <> 0.
    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Quotation Message' DISPLAY LIKE 'E'.
  ELSE.
    LOOP AT GT_QUOMSG INTO DATA(LS_ROW).
      IF LS_ROW-IS_CUSTOMER_MESSAGE = ABAP_TRUE.
        LS_ROW-USER_SENDING = 'Customer'.
      ELSE.
        LS_ROW-USER_SENDING = 'Staff'.
      ENDIF.

      MODIFY GT_QUOMSG FROM LS_ROW.
    ENDLOOP.
  ENDIF.

ENDFORM.

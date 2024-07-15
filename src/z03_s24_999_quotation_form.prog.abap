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
*& Form HANDLE_UCOMM_0139
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0139 USING U_OKCODE.
  CASE U_OKCODE.
    WHEN 'BACK_TO_QUOTA_LIST'.
      PERFORM PROCESS_BACK_TO_QUOTATION_LIST.
      CLEAR: U_OKCODE.

    WHEN 'SELECT_QUOVER'.
      PERFORM PROCESS_VIEW_QUOVER_LIST.
      CLEAR: U_OKCODE.

    WHEN 'DISPLAY<->CHANGE'.
      PERFORM PROCESS_QUO_DISPLAY_CHANGE.
      CLEAR: U_OKCODE.

    WHEN 'SEND_MESSAGE'.
      PERFORM PROCESS_SEND_MESSAGE.
      CLEAR: U_OKCODE.

    WHEN 'MAKE_CONTRACT'.
      PERFORM MAKE_CONTRACT USING GV_QUOTATION_ID.
      CLEAR: U_OKCODE.

    WHEN 'SAVE'.
      PERFORM PROCESS_QUOTATION_SAVE_EVENT.
      CLEAR: U_OKCODE.

    WHEN 'INSERT_QVSSER'.
      PERFORM PROCESS_INSERT_QVSSER.
      CLEAR: U_OKCODE.

    WHEN 'DELETE_QVSSER'.
      PERFORM DELETE_SELECTED_QVSSERS.
      CLEAR: U_OKCODE.

    WHEN 'INSERT_QVSPRV'.
      PERFORM PROCESS_INSERT_QVSPRV.
      CLEAR: U_OKCODE.

    WHEN 'DELETE_QVSPRV'.
      PERFORM DELETE_SELECTED_QVSPRVS.
      CLEAR: U_OKCODE.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0134
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0134 USING U_OKCODE.

  CASE U_OKCODE.

    WHEN 'ENTER_134'.
      PERFORM HANDLE_ENTER_ON_SCREEN_0134.
      CLEAR: U_OKCODE.

    WHEN 'CANCLE_134'.
      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_BACK_TO_QUOTATION_LIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_BACK_TO_QUOTATION_LIST.
  IF GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CREATE.
*    PERFORM WARNING_EXIT_UNSAVED_QUOTATION.
  ELSE.
    PERFORM RESET_QUOPCKIMG_CONTAINER.
    QUOTATION_SCREEN_MODE = '0130'.
    PERFORM PROCESS_QUOTATION_LIST_0130.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form RESET_QUOPCKIMG_CONTAINER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM RESET_QUOPCKIMG_CONTAINER.
  IF GV_QUOPCKIMG_URL IS NOT INITIAL.
    CLEAR GV_QUOPCKIMG_URL.
  ENDIF.
  IF QUOPCKIMG_CONTROL IS NOT INITIAL.
    CALL METHOD QUOPCKIMG_CONTROL->CLEAR_PICTURE.
    CLEAR QUOPCKIMG_CONTROL.
  ENDIF.
  IF QUOPCKIMG_CONTAINER IS NOT INITIAL.
    CALL METHOD QUOPCKIMG_CONTAINER->FREE.
    CLEAR QUOPCKIMG_CONTAINER.
  ENDIF.
  IF QUOPCKIMG_EVENT_RECEIVER IS NOT INITIAL.
    CLEAR QUOPCKIMG_EVENT_RECEIVER.
  ENDIF.
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
           ADD_QUOTATION_FCAT USING 'CUSTOMER'       'Customer'          10 ''  ''  'C700'  CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'STAFF'          'Staff'             10 ''  ''  'C500'      CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'STATUS'         'Status'            10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_QUOTATION_FCAT USING 'PACKAGE_NAME'   'Reference Package' 32 ''  ''  'C400'  CHANGING CH_T_FIELD_CAT,
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
         ( QVSPRV~PRICE * QVSPRV~QUANTITY ) AS TOTAL_PRICE,
         PROVRT~PRODUCT_ID
  FROM Y03S24999_QVSPRV AS QVSPRV
  JOIN Y03S24999_PROVRT AS PROVRT
  ON QVSPRV~PRODUCT_VARIANT_ID = PROVRT~ID
  WHERE QVSPRV~IS_DELETED <> @ABAP_TRUE AND
        QVSPRV~QUOTATION_VERSION_ID = @U_QUOVER_ID
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
         S~NAME AS SERVICE_NAME
  FROM Y03S24999_QVSSER AS QS
  JOIN Y03S24999_SERVCE AS S
  ON QS~SERVICE_ID = S~ID
  WHERE QS~IS_DELETED <> @ABAP_TRUE AND
        QS~QUOTATION_VERSION_ID = @U_QUOVER_ID
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
  CLEAR: GT_QUOMSG.

  SELECT QUOMSG~*
  FROM Y03S24999_QUOMSG AS QUOMSG
  JOIN Y03S24999_QUOTA AS QUOTA
  ON QUOMSG~QUOTATION_ID = QUOTA~ID
  WHERE QUOMSG~IS_DELETED <> @ABAP_TRUE
    AND QUOMSG~QUOTATION_ID = @U_QUOTATION_ID
  ORDER BY QUOMSG~CREATED_ON ASCENDING, QUOMSG~CREATED_AT ASCENDING
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
*&---------------------------------------------------------------------*
*& Form PROCESS_VIEW_QUOVER_LIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_VIEW_QUOVER_LIST .
  DATA: LV_SUCCESS TYPE ABAP_BOOL.
* Get data from QUOVER_0134 table
  PERFORM GET_QUOVER_0134_DATA CHANGING LV_SUCCESS.
  IF LV_SUCCESS = ABAP_FALSE.
    RETURN.
  ENDIF.
  CALL SCREEN 0134 STARTING AT 10 08 ENDING AT 70 15.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_QUOVER_0134_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_SUCCESS
*&---------------------------------------------------------------------*
FORM GET_QUOVER_0134_DATA CHANGING CH_V_SUCCESS TYPE ABAP_BOOL.
  CLEAR: IT_QUOVER_0134[], CH_V_SUCCESS.

  SELECT *
    FROM Y03S24999_QUOVER
    WHERE IS_DELETED <> @ABAP_TRUE
    AND QUOTATION_ID = @GS_QUOTATION_DETAIL-ID
    ORDER BY VERSION_ORDER DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @IT_QUOVER_0134.

  IF SY-SUBRC <> 0.
    CLEAR IT_QUOVER_0134[].

    IF O_QUOVER_0134_CONTAINER IS NOT INITIAL.
      CALL METHOD O_QUOVER_0134_CONTAINER->FREE.
      CLEAR O_QUOVER_0134_CONTAINER.
    ENDIF.
    IF O_QUOVER_0134_ALV_TABLE IS NOT INITIAL.
      CLEAR O_QUOVER_0134_ALV_TABLE.
    ENDIF.

    MESSAGE S000(Z03S24999_DOMUS_MSGS) WITH 'No version history found!' DISPLAY LIKE 'E'.
    CH_V_SUCCESS = ABAP_FALSE.
  ELSE.
    CH_V_SUCCESS = ABAP_TRUE.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_QUOVER_0134_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_QUOVER_0134_ALV.
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_VER_0134_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_QUOVER_0134_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_QUOVER_0134_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_QUOVER_0134_FCAT
*&---------------------------------------------------------------------*
FORM ADD_QUOVER_0134_FCAT USING U_FIELDNAME
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
*& Form PREPARE_QUOVER_0134_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_VER_0134_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_QUOVER_0134_FCAT USING 'VERSION_ORDER'  'Version'           6  '' 'X'  'C500'  CHANGING CH_T_FIELD_CAT,
           ADD_QUOVER_0134_FCAT USING 'CREATED_AT'     'Created At'        9  ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_QUOVER_0134_FCAT USING 'CREATED_ON'     'Created On'        9  ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_QUOVER_0134_FCAT USING 'TOTAL_PRICE'    'Total Price'       16 ''  ''  'C100'  CHANGING CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_QUOVER_0134_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_QUOVER_0134_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_QUOVER_0134_CONTAINER IS INITIAL.
    O_QUOVER_0134_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0134' ).
  ENDIF.

  IF O_QUOVER_0134_ALV_TABLE IS INITIAL.
    O_QUOVER_0134_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_QUOVER_0134_CONTAINER ).
  ENDIF.

  O_QUOVER_0134_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_QUOVER_0134     " Output Table
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
*& Form PREPARE_QUOVER_0134_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_QUOVER_0134_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_ENTER_ON_SCREEN_0134
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM HANDLE_ENTER_ON_SCREEN_0134.
  IF O_QUOVER_0134_ALV_TABLE IS NOT INITIAL.

    DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
    DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.

    CALL METHOD O_QUOVER_0134_ALV_TABLE->GET_SELECTED_ROWS
      IMPORTING
        ET_INDEX_ROWS = LT_INDEX_ROWS.

    IF LINES( LT_INDEX_ROWS ) = 1.
      CLEAR: GV_QUOVER_TOTAL_PRICE.
      CLEAR: GV_QVSPRV_TOTAL_PRICE.
      CLEAR: GV_QVSSER_TOTAL_PRICE.

      READ TABLE LT_INDEX_ROWS INDEX 1 INTO DATA(LS_INDEX_ROWS).
      READ TABLE IT_QUOVER_0134 INDEX LS_INDEX_ROWS INTO DATA(LS_QUOVER_0134).

      GS_QUOTATION_DETAIL-QUOVER_ID = LS_QUOVER_0134-ID.
      GS_QUOTATION_DETAIL-QUOVER_VERSION_ORDER = LS_QUOVER_0134-VERSION_ORDER.
      GS_QUOTATION_DETAIL-QUOVER_CREATED_ON = LS_QUOVER_0134-CREATED_ON.
      GS_QUOTATION_DETAIL-QUOVER_CREATED_AT = LS_QUOVER_0134-CREATED_AT.

      PERFORM GET_QUOVER_PRODUCT_ITEMS USING GS_QUOTATION_DETAIL-QUOVER_ID.
      PERFORM GET_QUOVER_SERVICE_ITEMS USING GS_QUOTATION_DETAIL-QUOVER_ID.

      MESSAGE S017(Z03S24999_DOMUS_MSGS) WITH GS_QUOTATION_DETAIL-QUOVER_VERSION_ORDER.
      LEAVE TO SCREEN 0.

    ELSE.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'one Version' DISPLAY LIKE 'E'.
    ENDIF.

  ELSE.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'one Version' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_QUO_DISPLAY_CHANGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_QUO_DISPLAY_CHANGE .
  CASE GV_QUOTATION_SCREEN_MODE.
    WHEN GC_QUOTATION_MODE_DISPLAY.
      IF GS_QUOTATION_DETAIL-STATUS = 'Requested' OR GS_QUOTATION_DETAIL-STATUS = 'Negotiating'.
        GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CHANGE.
      ELSEIF GS_QUOTATION_DETAIL-STATUS = 'Accepted'.
        MESSAGE I000(Z03S24999_DOMUS_MSGS) WITH 'This quotation was' ' already Accepted by customer.' ' You cannot change it.'.
      ELSE.
        MESSAGE E000(Z03S24999_DOMUS_MSGS) WITH 'You cannot edit a Cancelled quotation!'.
      ENDIF.
    WHEN GC_QUOTATION_MODE_CHANGE.
      PERFORM WARNING_QUOTA_CHANGES_EXIST.
      GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_DISPLAY.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_SEND_MESSAGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_SEND_MESSAGE .
  DATA: LS_QUOMSG TYPE Y03S24999_QUOMSG.

  LS_QUOMSG-QUOTATION_ID = GV_QUOTATION_ID.
  LS_QUOMSG-CONTENT = GV_QUOMSG_CONTENT.
  LS_QUOMSG-IS_CUSTOMER_MESSAGE = ABAP_FALSE.
  LS_QUOMSG-CREATED_BY = SY-UNAME.
  LS_QUOMSG-CREATED_AT = SY-UZEIT + ( 3600 * 5 ).
  LS_QUOMSG-CREATED_ON = SY-DATUM.

  PERFORM CREATE_UUID_C36_STATIC CHANGING LS_QUOMSG-ID.

  INSERT Y03S24999_QUOMSG FROM LS_QUOMSG.

  IF SY-SUBRC <> 0.
    MESSAGE E018(Z03S24999_DOMUS_MSGS) WITH 'message'.
  ELSE.
    CLEAR: GV_QUOMSG_CONTENT.
    PERFORM GET_QUOMSG_ITEMS USING GV_QUOTATION_ID.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELETE_SELECTED_QVSSERS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DELETE_SELECTED_QVSSERS.
  DATA: LD_SEL_QVSSERS LIKE GT_QVSSER.
  LOOP AT GT_QVSSER INTO DATA(LS_PI).
    IF LS_PI-SEL = 'X'.
      APPEND LS_PI TO LD_SEL_QVSSERS.
    ENDIF.
  ENDLOOP.

  IF LINES( LD_SEL_QVSSERS ) = 0.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'a Service for deletion' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSEIF LINES( LD_SEL_QVSSERS ) > 1.
    PERFORM WARNING_MULTI_SELECTED_QVSSER TABLES LD_SEL_QVSSERS.

  ELSEIF LINES( LD_SEL_QVSSERS ) = 1.
    PERFORM HANDLE_QVSSER_FINAL_DELETION TABLES LD_SEL_QVSSERS.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form WARNING_MULTI_SELECTED_QVSSER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM WARNING_MULTI_SELECTED_QVSSER TABLES U_ITAB LIKE GT_QVSSER.
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
    PERFORM HANDLE_QVSSER_FINAL_DELETION TABLES U_ITAB.

  ELSEIF LD_CHOICE = '2'.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_QVSSER_FINAL_DELETION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM HANDLE_QVSSER_FINAL_DELETION TABLES U_ITAB LIKE GT_QVSSER.
  LOOP AT U_ITAB INTO DATA(S_ROW).

    DELETE TABLE GT_QVSSER FROM S_ROW.

    IF SY-SUBRC <> 0.
      MESSAGE E000(Z03S24999_DOMUS_MSGS) WITH 'One deleting Service in Quotation has caused an error!'.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DELETE_SELECTED_QVSPRVS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM DELETE_SELECTED_QVSPRVS.
  DATA: LD_SEL_QVSPRVS LIKE GT_QVSPRV.
  LOOP AT GT_QVSPRV INTO DATA(LS_PI).
    IF LS_PI-SEL = 'X'.
      APPEND LS_PI TO LD_SEL_QVSPRVS.
    ENDIF.
  ENDLOOP.

  IF LINES( LD_SEL_QVSPRVS ) = 0.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'a Product Variant for deletion' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSEIF LINES( LD_SEL_QVSPRVS ) > 1.
    PERFORM WARNING_MULTI_SELECTED_QVSPRV TABLES LD_SEL_QVSPRVS.

  ELSEIF LINES( LD_SEL_QVSPRVS ) = 1.
    PERFORM HANDLE_QVSPRV_FINAL_DELETION TABLES LD_SEL_QVSPRVS.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form WARNING_MULTI_SELECTED_QVSPRV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM WARNING_MULTI_SELECTED_QVSPRV TABLES U_ITAB LIKE GT_QVSPRV.
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
    PERFORM HANDLE_QVSPRV_FINAL_DELETION TABLES U_ITAB.

  ELSEIF LD_CHOICE = '2'.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_QVSPRV_FINAL_DELETION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM HANDLE_QVSPRV_FINAL_DELETION TABLES U_ITAB LIKE GT_QVSPRV.
  LOOP AT U_ITAB INTO DATA(S_ROW).

    DELETE TABLE GT_QVSPRV FROM S_ROW.

    IF SY-SUBRC <> 0.
      MESSAGE E000(Z03S24999_DOMUS_MSGS) WITH 'One deleting Product in Quotation has caused an error!'.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_INSERT_QVSSER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      -->
*&---------------------------------------------------------------------*
FORM PROCESS_INSERT_QVSSER.
  DATA: LV_SUCCESS TYPE ABAP_BOOL.
* Get data from SERVICE_0138 table
  PERFORM GET_SERVICE_0138_DATA CHANGING LV_SUCCESS.
  IF LV_SUCCESS = ABAP_FALSE.
    RETURN.
  ENDIF.
  CALL SCREEN 0138 STARTING AT 10 08 ENDING AT 70 15.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_SERVICE_0138_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_SERVICE_0138_DATA CHANGING CH_V_SUCCESS TYPE ABAP_BOOL.
  CLEAR: IT_SERVICE_0138[], CH_V_SUCCESS.

  SELECT S~*
    FROM Y03S24999_SERVCE AS S
    LEFT JOIN @GT_QVSSER AS GS
    ON S~ID = GS~SERVICE_ID
    WHERE S~IS_DELETED <> @ABAP_TRUE
    AND GS~SERVICE_ID IS NULL
    ORDER BY S~CREATED_ON DESCENDING, S~CREATED_AT DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @IT_SERVICE_0138.

  IF SY-SUBRC <> 0.
    CLEAR IT_SERVICE_0138[].

    IF O_SERVICE_0138_CONTAINER IS NOT INITIAL.
      CALL METHOD O_SERVICE_0138_CONTAINER->FREE.
      CLEAR O_SERVICE_0138_CONTAINER.
    ENDIF.
    IF O_SERVICE_0138_ALV_TABLE IS NOT INITIAL.
      CLEAR O_SERVICE_0138_ALV_TABLE.
    ENDIF.

    MESSAGE S000(Z03S24999_DOMUS_MSGS) WITH 'All services were selected!' DISPLAY LIKE 'E'.
    CH_V_SUCCESS = ABAP_FALSE.
  ELSE.
    CH_V_SUCCESS = ABAP_TRUE.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_INSERT_QVSPRV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      -->
*&---------------------------------------------------------------------*
FORM PROCESS_INSERT_QVSPRV.
  DATA: LV_SUCCESS TYPE ABAP_BOOL.
* Get data from PRODUCT_0137 table
  PERFORM GET_PRODUCT_0137_DATA CHANGING LV_SUCCESS.
  IF LV_SUCCESS = ABAP_FALSE.
    RETURN.
  ENDIF.
  CALL SCREEN 0137 STARTING AT 10 08 ENDING AT 70 20.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PRODUCT_0137_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_PRODUCT_0137_DATA CHANGING CH_V_SUCCESS TYPE ABAP_BOOL.
  CLEAR: IT_PRODUCT_0137[], CH_V_SUCCESS.

  SELECT P~*
    FROM Y03S24999_PRODCT AS P
    LEFT JOIN @GT_QVSPRV AS GP
    ON P~ID = GP~PRODUCT_ID
    WHERE P~IS_DELETED <> @ABAP_TRUE
    AND GP~PRODUCT_ID IS NULL
    ORDER BY P~UPDATED_ON DESCENDING, P~UPDATED_ON DESCENDING, P~PRODUCT_CODE
    INTO CORRESPONDING FIELDS OF TABLE @IT_PRODUCT_0137.

  IF SY-SUBRC <> 0.
    CLEAR IT_PRODUCT_0137[].

    IF O_PRODUCT_0137_CONTAINER IS NOT INITIAL.
      CALL METHOD O_PRODUCT_0137_CONTAINER->FREE.
      CLEAR O_PRODUCT_0137_CONTAINER.
    ENDIF.
    IF O_PRODUCT_0137_ALV_TABLE IS NOT INITIAL.
      CLEAR O_PRODUCT_0137_ALV_TABLE.
    ENDIF.

    MESSAGE S000(Z03S24999_DOMUS_MSGS) WITH 'All products were selected!' DISPLAY LIKE 'E'.
    CH_V_SUCCESS = ABAP_FALSE.
  ELSE.
    CH_V_SUCCESS = ABAP_TRUE.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_QUOTATION_SAVE_EVENT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_QUOTATION_SAVE_EVENT .
  CASE GV_QUOTATION_SCREEN_MODE.
    WHEN GC_QUOTATION_MODE_DISPLAY.

    WHEN GC_QUOTATION_MODE_CHANGE.
      PERFORM CHANGE_QUOTATION_DETAIL USING GV_QUOTATION_ID.
      PERFORM PREPARE_QUOTATION_DETAIL USING GV_QUOTATION_ID.

      MESSAGE S010(Z03S24999_DOMUS_MSGS) WITH 'Quotation'.

      GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_DISPLAY.

    WHEN GC_QUOTATION_MODE_CREATE.
*      PERFORM CHANGE_QUOTATION_DETAIL.
*      PERFORM PREPARE_QUOTATION_DETAIL USING GV_QUOTATION_ID.
*
*      MESSAGE S016(Z03S24999_DOMUS_MSGS) WITH 'Quotation'.
*
*      GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_DISPLAY.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_PRODUCT_0137_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_PRODUCT_0137_ALV.
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_PRO_0137_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_PRODUCT_0137_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_PRODUCT_0137_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_PRODUCT_0137_FCAT
*&---------------------------------------------------------------------*
FORM ADD_PRODUCT_0137_FCAT USING U_FIELDNAME
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
*& Form PREPARE_PRODUCT_0137_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_PRO_0137_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_PRODUCT_0137_FCAT USING 'PRODUCT_CODE' 'Code'        12 '' 'X'  'C100'  CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0137_FCAT USING 'BRAND'        'Brand'       16 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0137_FCAT USING 'PRODUCT_NAME' 'Name'        22 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0137_FCAT USING 'CREATED_BY'   'Created By'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0137_FCAT USING 'CREATED_AT'   'Created At'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0137_FCAT USING 'CREATED_ON'   'Created On'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0137_FCAT USING 'UPDATED_BY'   'Updated By'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0137_FCAT USING 'UPDATED_AT'   'Updated At'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0137_FCAT USING 'UPDATED_ON'   'Updated On'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_PRODUCT_0137_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_PRODUCT_0137_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_PRODUCT_0137_CONTAINER IS INITIAL.
    O_PRODUCT_0137_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0137' ).
  ENDIF.

  IF O_PRODUCT_0137_ALV_TABLE IS INITIAL.
    O_PRODUCT_0137_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_PRODUCT_0137_CONTAINER ).
  ENDIF.

  O_PRODUCT_0137_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_PRODUCT_0137     " Output Table
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
*& Form PREPARE_PRODUCT_0137_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_PRODUCT_0137_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_PROVRT_0136_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_PROVRT_0136_ALV.
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_PRO_0136_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_PROVRT_0136_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_PROVRT_0136_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_PROVRT_0136_FCAT
*&---------------------------------------------------------------------*
FORM ADD_PROVRT_0136_FCAT USING U_FIELDNAME
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
*& Form PREPARE_PROVRT_0136_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_PRO_0136_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_PROVRT_0136_FCAT USING 'VARIANT_CODE'  'Variant'     6 ''  'X'  'C311'  CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0136_FCAT USING 'PRODUCT_CODE'  'Code'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0136_FCAT USING 'PRODUCT_NAME'  'Name'        20 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0136_FCAT USING 'DISPLAY_PRICE' 'Price'       14 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0136_FCAT USING 'CREATED_BY'    'Created By'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0136_FCAT USING 'CREATED_AT'    'Created At'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0136_FCAT USING 'CREATED_ON'    'Created On'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0136_FCAT USING 'UPDATED_BY'    'Updated By'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0136_FCAT USING 'UPDATED_AT'    'Updated At'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0136_FCAT USING 'UPDATED_ON'    'Updated On'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_PROVRT_0136_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_PROVRT_0136_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_PROVRT_0136_CONTAINER IS INITIAL.
    O_PROVRT_0136_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0136' ).
  ENDIF.

  IF O_PROVRT_0136_ALV_TABLE IS INITIAL.
    O_PROVRT_0136_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_PROVRT_0136_CONTAINER ).
  ENDIF.

  O_PROVRT_0136_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_PROVRT_0136     " Output Table
      IT_FIELDCATALOG               = CH_T_FIELD_CAT   " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).

  IF O_PROVRT_0136_HANDLER IS INITIAL.
    O_PROVRT_0136_HANDLER = NEW CL_QUOTA_PROVRT_ALV_HANDLER( ).
    SET HANDLER O_PROVRT_0136_HANDLER->HOTSPOT_CLICK FOR O_PROVRT_0136_ALV_TABLE.
  ENDIF.

  IF SY-SUBRC <> 0.
    MESSAGE E005(Z03S24999_DOMUS_MSGS).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_PROVRT_0136_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_PROVRT_0136_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_PROATV_0135_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_PROATV_0135_ALV.
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_PRO_0135_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_PROATV_0135_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_PROATV_0135_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_PROATV_0135_FCAT
*&---------------------------------------------------------------------*
FORM ADD_PROATV_0135_FCAT USING U_FIELDNAME
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
*& Form PREPARE_PROATV_0135_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_PRO_0135_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_PROATV_0135_FCAT USING 'ATTRIBUTE_NAME' 'Attribute' 12 ''  'X' 'C500'  CHANGING CH_T_FIELD_CAT,
           ADD_PROATV_0135_FCAT USING 'VALUE'          'Value'     12 ''  ''  ''      CHANGING CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_PROATV_0135_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_PROATV_0135_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_PROATV_0135_CONTAINER IS INITIAL.
    O_PROATV_0135_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0135' ).
  ENDIF.

  IF O_PROATV_0135_ALV_TABLE IS INITIAL.
    O_PROATV_0135_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_PROATV_0135_CONTAINER ).
  ENDIF.

  O_PROATV_0135_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_PROATV_0135     " Output Table
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
*& Form PREPARE_PROATV_0135_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_PROATV_0135_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_SERVICE_0138_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_SERVICE_0138_ALV.
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_SER_0138_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_SERVICE_0138_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_SERVICE_0138_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_SERVICE_0138_FCAT
*&---------------------------------------------------------------------*
FORM ADD_SERVICE_0138_FCAT USING U_FIELDNAME
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
*& Form PREPARE_SERVICE_0138_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_SER_0138_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_SERVICE_0138_FCAT USING 'NAME'           'Name'              20 '' 'X'  'C500'  CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0138_FCAT USING 'DISPLAY_PRICE'  'Price'             14 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0138_FCAT USING 'DESCRIPTION'    'Description'       10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0138_FCAT USING 'CREATED_BY'     'Created By'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0138_FCAT USING 'CREATED_AT'     'Created At'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0138_FCAT USING 'CREATED_ON'     'Created On'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0138_FCAT USING 'UPDATED_BY'     'Updated By'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0138_FCAT USING 'UPDATED_AT'     'Updated At'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0138_FCAT USING 'UPDATED_ON'     'Updated On'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_SERVICE_0138_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_SERVICE_0138_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_SERVICE_0138_CONTAINER IS INITIAL.
    O_SERVICE_0138_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0138' ).
  ENDIF.

  IF O_SERVICE_0138_ALV_TABLE IS INITIAL.
    O_SERVICE_0138_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_SERVICE_0138_CONTAINER ).
  ENDIF.

  O_SERVICE_0138_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_SERVICE_0138     " Output Table
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
*& Form PREPARE_SERVICE_0138_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_SERVICE_0138_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0137
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0137 USING U_OKCODE.

  CASE U_OKCODE.

    WHEN 'ENTER_137' OR 'VIEW_PRODUCT_0137'.
      PERFORM HANDLE_ENTER_ON_SCREEN_0137.
      CLEAR: U_OKCODE.
    WHEN 'CANCLE_137'.
      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_ENTER_ON_SCREEN_0137
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM HANDLE_ENTER_ON_SCREEN_0137.
  IF O_PRODUCT_0137_ALV_TABLE IS NOT INITIAL.
    DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
    DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.

    CALL METHOD O_PRODUCT_0137_ALV_TABLE->GET_SELECTED_ROWS
      IMPORTING
        ET_INDEX_ROWS = LT_INDEX_ROWS.

    IF LINES( LT_INDEX_ROWS ) = 1.
      READ TABLE LT_INDEX_ROWS INDEX 1 INTO LS_INDEX_ROW.
      READ TABLE IT_PRODUCT_0137 INDEX LS_INDEX_ROW INTO DATA(LS_PRODUCT).

      PERFORM PROCESS_PREPARE_0136_DATA USING LS_PRODUCT-ID.

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
*& Form PROCESS_PREPARE_0136_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_PREPARE_0136_DATA USING U_PRODUCT_ID.

  CLEAR: IT_PROVRT_0136[].

  SELECT PROVRT~*, PRODCT~PRODUCT_NAME, PRODCT~PRODUCT_CODE
    FROM Y03S24999_PROVRT AS PROVRT
    LEFT JOIN Y03S24999_PRODCT AS PRODCT
    ON PRODCT~ID = PROVRT~PRODUCT_ID
    WHERE PROVRT~IS_DELETED <> @ABAP_TRUE
    AND PRODCT~ID = @U_PRODUCT_ID
    ORDER BY PROVRT~VARIANT_CODE DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @IT_PROVRT_0136.

  IF SY-SUBRC <> 0.
    CLEAR IT_PROVRT_0136[].

    IF O_PROVRT_0136_CONTAINER IS NOT INITIAL.
      CALL METHOD O_PROVRT_0136_CONTAINER->FREE.
      CLEAR O_PROVRT_0136_CONTAINER.
    ENDIF.
    IF O_PROVRT_0136_ALV_TABLE IS NOT INITIAL.
      CLEAR O_PROVRT_0136_ALV_TABLE.
    ENDIF.
    IF O_PROVRT_0136_HANDLER IS NOT INITIAL.
      CLEAR O_PROVRT_0136_HANDLER.
    ENDIF.

    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Product Variant of this product' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  CALL SCREEN 0136 STARTING AT 15 06 ENDING AT 70 12.
  LEAVE TO SCREEN 0.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0136
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0136 USING U_OKCODE.

  CASE U_OKCODE.

    WHEN 'ENTER_136'.
      PERFORM HANDLE_ENTER_ON_SCREEN_0136.
      CLEAR: U_OKCODE.
    WHEN 'CANCLE_136'.
      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_ENTER_ON_SCREEN_0136
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM HANDLE_ENTER_ON_SCREEN_0136.
  IF O_PROVRT_0136_ALV_TABLE IS NOT INITIAL.

    DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
    DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.

    CALL METHOD O_PROVRT_0136_ALV_TABLE->GET_SELECTED_ROWS
      IMPORTING
        ET_INDEX_ROWS = LT_INDEX_ROWS.

    IF LINES( LT_INDEX_ROWS ) > 0.
* Loop to append each selected Product Variant into Quotation Product Variant List
      LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW.
        DATA: LV_IS_REPEATED TYPE ABAP_BOOL.
        READ TABLE IT_PROVRT_0136 INDEX LS_INDEX_ROW INTO DATA(LS_PROVRT_0136).

        LOOP AT GT_QVSPRV INTO DATA(LS_TEMP).
          IF LS_TEMP-PRODUCT_VARIANT_ID = LS_PROVRT_0136-ID.
            LS_TEMP-QUANTITY += 1.
            MODIFY TABLE GT_QVSPRV FROM LS_TEMP.

            LV_IS_REPEATED = ABAP_TRUE.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF LV_IS_REPEATED <> ABAP_TRUE.
          READ TABLE GT_QVSPRV INDEX 1 INTO GS_QVSPRV.
          CLEAR: GS_QVSPRV.

          GS_QVSPRV-PRODUCT_VARIANT_ID = LS_PROVRT_0136-ID.
          GS_QVSPRV-VARIANT_CODE = LS_PROVRT_0136-VARIANT_CODE.
          GS_QVSPRV-PRODUCT_NAME = LS_PROVRT_0136-PRODUCT_NAME.
          GS_QVSPRV-PRICE = LS_PROVRT_0136-DISPLAY_PRICE.
          GS_QVSPRV-QUANTITY = 1.
          GS_QVSPRV-TOTAL_PRICE = GS_QVSPRV-PRICE.

          PERFORM CREATE_UUID_C36_STATIC CHANGING GS_QVSPRV-ID.

          APPEND GS_QVSPRV TO GT_QVSPRV.

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
*& Form HANDLE_UCOMM_0138
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0138 USING U_OKCODE.

  CASE U_OKCODE.

    WHEN 'ENTER_138'.
      PERFORM HANDLE_ENTER_ON_SCREEN_0138.
      CLEAR: U_OKCODE.

    WHEN 'CANCLE_138'.
      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_ENTER_ON_SCREEN_0138
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM HANDLE_ENTER_ON_SCREEN_0138.
  IF O_SERVICE_0138_ALV_TABLE IS NOT INITIAL.

    DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
    DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.

    CALL METHOD O_SERVICE_0138_ALV_TABLE->GET_SELECTED_ROWS
      IMPORTING
        ET_INDEX_ROWS = LT_INDEX_ROWS.

    IF LINES( LT_INDEX_ROWS ) > 0.
* Loop to append each selected Services into Quotation Service List
      LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW.

        READ TABLE GT_QVSSER INDEX 1 INTO GS_QVSSER.
        CLEAR: GS_QVSSER.

        READ TABLE IT_SERVICE_0138 INDEX LS_INDEX_ROW INTO DATA(LS_SERVICE_0138).
        GS_QVSSER-SERVICE_ID = LS_SERVICE_0138-ID.
        GS_QVSSER-SERVICE_NAME = LS_SERVICE_0138-NAME.
        GS_QVSSER-PRICE = LS_SERVICE_0138-DISPLAY_PRICE.

        PERFORM CREATE_UUID_C36_STATIC CHANGING GS_QVSSER-ID.

        APPEND GS_QVSSER TO GT_QVSSER.
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
*& Form HANDLE_UCOMM_0135
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0135 USING U_OKCODE.
  CASE U_OKCODE.
    WHEN 'CANCLE_135'.
      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_QUOTATION_PROATV_0135
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_PROVRT_ID
*&---------------------------------------------------------------------*
FORM PREPARE_QUOTATION_PROATV_0135  USING  U_PROVRT_ID.
  SELECT PROATV~VALUE, PROATR~ATTRIBUTE_NAME
    FROM Y03S24999_PROATV AS PROATV
    LEFT JOIN Y03S24999_PROATR AS PROATR
    ON PROATR~ID = PROATV~PRODUCT_ATTRIBUTE_ID
    WHERE PROATV~IS_DELETED <> @ABAP_TRUE
    AND PROATV~PRODUCT_VARIANT_ID = @U_PROVRT_ID
    INTO CORRESPONDING FIELDS OF TABLE @IT_PROATV_0135.

  IF SY-SUBRC <> 0.
    CLEAR IT_PROATV_0135[].

    IF O_PROATV_0135_CONTAINER IS NOT INITIAL.
      CALL METHOD O_PROATV_0135_CONTAINER->FREE.
      CLEAR O_PROATV_0135_CONTAINER.
    ENDIF.
    IF O_PROATV_0135_ALV_TABLE IS NOT INITIAL.
      CLEAR O_PROATV_0135_ALV_TABLE.
    ENDIF.

    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Attribute of this product' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_QUOTATION_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHANGE_QUOTATION_DETAIL USING U_QUOTATION_ID.
  DATA: LV_QUOVER_ID TYPE Y03S24999_QUOVER-ID.
  DATA: LV_TOTAL_PRICE TYPE Y03S24999_QUOVER-TOTAL_PRICE VALUE 0.

  PERFORM CHANGE_QUOTA_BASIC_DETAIL USING U_QUOTATION_ID.
  PERFORM CREATE_QUOVER_BASIC_DETAIL USING U_QUOTATION_ID
                                     CHANGING LV_QUOVER_ID.
  PERFORM CREATE_QUOVER_PROVRTS_DETAIL USING LV_QUOVER_ID
                                     CHANGING LV_TOTAL_PRICE.
  PERFORM CREATE_QUOVER_SERVICES_DETAIL USING LV_QUOVER_ID
                                     CHANGING LV_TOTAL_PRICE.
  PERFORM INSERT_QUOVER_TOTAL_PRICE USING LV_QUOVER_ID
                                          LV_TOTAL_PRICE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_QUOTA_BASIC_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHANGE_QUOTA_BASIC_DETAIL USING U_QUOTATION_ID.
  DATA: LS_QUOTA TYPE Y03S24999_QUOTA.

  IF GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CHANGE.

    SELECT SINGLE *
      FROM Y03S24999_QUOTA
      WHERE ID = @U_QUOTATION_ID
      AND IS_DELETED <> @ABAP_TRUE
      INTO @LS_QUOTA.

    LS_QUOTA-STATUS = 'Negotiating'.
    LS_QUOTA-UPDATED_BY = SY-UNAME.
    LS_QUOTA-UPDATED_AT = SY-UZEIT + ( 3600 * 5 ).
    LS_QUOTA-UPDATED_ON = SY-DATUM.

    MODIFY Y03S24999_QUOTA FROM LS_QUOTA.

    IF SY-SUBRC <> 0.
      MESSAGE E011(Z03S24999_DOMUS_MSGS) WITH 'Quotation basic information'.
    ENDIF.

  ELSEIF GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CREATE.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_QUOVER_BASIC_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CREATE_QUOVER_BASIC_DETAIL USING U_QUOTATION_ID
                                CHANGING CH_QUOVER_ID.
  DATA: LS_QUOVER TYPE Y03S24999_QUOVER.

  LS_QUOVER-QUOTATION_ID = GV_QUOTATION_ID.
  PERFORM CREATE_UUID_C36_STATIC CHANGING CH_QUOVER_ID.

  LS_QUOVER-ID = CH_QUOVER_ID.

  IF GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CHANGE.

    SELECT MAX( VERSION_ORDER ) + 1
      FROM Y03S24999_QUOVER
      WHERE QUOTATION_ID = @U_QUOTATION_ID
      AND IS_DELETED <> @ABAP_TRUE
      INTO @LS_QUOVER-VERSION_ORDER.

    LS_QUOVER-CREATED_BY = SY-UNAME.
    LS_QUOVER-CREATED_AT = SY-UZEIT + ( 3600 * 5 ).
    LS_QUOVER-CREATED_ON = SY-DATUM.

    INSERT Y03S24999_QUOVER FROM LS_QUOVER.

    IF SY-SUBRC <> 0.
      MESSAGE E011(Z03S24999_DOMUS_MSGS) WITH 'Quotation Version basic information'.
    ENDIF.

  ELSEIF GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CREATE.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_QUOVER_PROVRTS_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      -->
*&---------------------------------------------------------------------*
FORM CREATE_QUOVER_PROVRTS_DETAIL USING U_QUOVER_ID
                                  CHANGING CH_TOTAL_PRICE TYPE Y03S24999_QUOVER-TOTAL_PRICE.
  DATA: LT_PI TYPE STANDARD TABLE OF Y03S24999_QVSPRV.
  MOVE-CORRESPONDING GT_QVSPRV TO LT_PI.

  IF GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CHANGE.
    LOOP AT LT_PI INTO DATA(LS_PI).
      LS_PI-QUOTATION_VERSION_ID = U_QUOVER_ID.

      LS_PI-CREATED_BY = SY-UNAME.
      LS_PI-CREATED_AT = SY-UZEIT + ( 3600 * 5 ).
      LS_PI-CREATED_ON = SY-DATUM.

      INSERT Y03S24999_QVSPRV FROM LS_PI.

      IF SY-SUBRC <> 0.
        MESSAGE E011(Z03S24999_DOMUS_MSGS) WITH 'Quotation Product Variant details'.
      ELSE.
        CH_TOTAL_PRICE += ( LS_PI-PRICE * LS_PI-QUANTITY ).
      ENDIF.
    ENDLOOP.

  ELSEIF GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CREATE.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CREATE_QUOVER_SERVICES_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      -->
*&---------------------------------------------------------------------*
FORM CREATE_QUOVER_SERVICES_DETAIL USING U_QUOVER_ID
                                   CHANGING CH_TOTAL_PRICE TYPE Y03S24999_QUOVER-TOTAL_PRICE.
  DATA: LT_PI TYPE STANDARD TABLE OF Y03S24999_QVSSER.
  MOVE-CORRESPONDING GT_QVSSER TO LT_PI.

  IF GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CHANGE.
    LOOP AT LT_PI INTO DATA(LS_PI).
      LS_PI-QUOTATION_VERSION_ID = U_QUOVER_ID.

      LS_PI-CREATED_BY = SY-UNAME.
      LS_PI-CREATED_AT = SY-UZEIT + ( 3600 * 5 ).
      LS_PI-CREATED_ON = SY-DATUM.

      INSERT Y03S24999_QVSSER FROM LS_PI.

      IF SY-SUBRC <> 0.
        MESSAGE E011(Z03S24999_DOMUS_MSGS) WITH 'Quotation Service details'.
      ELSE.
        CH_TOTAL_PRICE += LS_PI-PRICE.
      ENDIF.
    ENDLOOP.

  ELSEIF GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CREATE.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form INSERT_QUOVER_TOTAL_PRICE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM INSERT_QUOVER_TOTAL_PRICE USING U_QUOVER_ID
                                     U_TOTAL_PRICE TYPE Y03S24999_QUOVER-TOTAL_PRICE.

  IF GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CHANGE.

    UPDATE Y03S24999_QUOVER
      SET TOTAL_PRICE = U_TOTAL_PRICE
      WHERE ID = U_QUOVER_ID.

    IF SY-SUBRC <> 0.
      MESSAGE E011(Z03S24999_DOMUS_MSGS) WITH 'Quotation Version total price'.
    ENDIF.

  ELSEIF GV_QUOTATION_SCREEN_MODE = GC_QUOTATION_MODE_CREATE.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form WARNING_QUOTA_CHANGES_EXIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM WARNING_QUOTA_CHANGES_EXIST .
  DATA: LD_CHOICE TYPE CHAR01.
  IF GT_QVSPRV_BEFORE_MOD <> GT_QVSPRV OR
     GT_QVSSER_BEFORE_MOD <> GT_QVSSER.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        TEXT_QUESTION         = 'Do you want to save before switching mode?'
        TEXT_BUTTON_1         = 'Yes'(001)
        TEXT_BUTTON_2         = 'No'(002)
        DISPLAY_CANCEL_BUTTON = ''
      IMPORTING
        ANSWER                = LD_CHOICE.
    IF LD_CHOICE = '1'.
      PERFORM CHANGE_QUOTATION_DETAIL USING GV_QUOTATION_ID.
      PERFORM PREPARE_QUOTATION_DETAIL USING GV_QUOTATION_ID.
    ELSEIF LD_CHOICE = '2'.
      PERFORM PREPARE_QUOTATION_DETAIL USING GV_QUOTATION_ID.
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_QVSPRV_QUANTITY
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHECK_QVSPRV_QUANTITY.
  IF GS_QVSPRV-QUANTITY IS INITIAL.
    MESSAGE E014(Z03S24999_DOMUS_MSGS).
    SET CURSOR FIELD 'GS_QVSPRV-QUANTITY' LINE QVSPRV_TABLE_CONTROL-CURRENT_LINE.
  ELSE.
    IF GS_QVSPRV-QUANTITY < 1 OR GS_QVSPRV-QUANTITY > 255.
      MESSAGE E012(Z03S24999_DOMUS_MSGS).
      SET CURSOR FIELD 'GS_QVSPRV-QUANTITY' LINE QVSPRV_TABLE_CONTROL-CURRENT_LINE.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_QVSPRV_PRICE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHECK_QVSPRV_PRICE.
  IF GS_QVSPRV-PRICE IS INITIAL.
    MESSAGE E014(Z03S24999_DOMUS_MSGS).
    SET CURSOR FIELD 'GS_QVSPRV-PRICE' LINE QVSPRV_TABLE_CONTROL-CURRENT_LINE.
  ELSE.
    IF GS_QVSPRV-PRICE < 0 OR GS_QVSPRV-PRICE > 999999999999.
      MESSAGE E019(Z03S24999_DOMUS_MSGS).
      SET CURSOR FIELD 'GS_QVSPRV-PRICE' LINE QVSPRV_TABLE_CONTROL-CURRENT_LINE.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_QVSSER_PRICE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHECK_QVSSER_PRICE .
  IF GS_QVSSER-PRICE IS INITIAL.
    MESSAGE E014(Z03S24999_DOMUS_MSGS).
    SET CURSOR FIELD 'GS_QVSSER-PRICE' LINE QVSSER_TABLE_CONTROL-CURRENT_LINE.
  ELSE.
    IF GS_QVSSER-PRICE < 0 OR GS_QVSSER-PRICE > 999999999999.
      MESSAGE E019(Z03S24999_DOMUS_MSGS).
      SET CURSOR FIELD 'GS_QVSSER-PRICE' LINE QVSSER_TABLE_CONTROL-CURRENT_LINE.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHECK_QUOMSG_CONTENT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CHECK_QUOMSG_CONTENT.
  IF GV_QUOMSG_CONTENT IS INITIAL.
    MESSAGE E020(Z03S24999_DOMUS_MSGS).
    SET CURSOR FIELD 'GV_QUOMSG_CONTENT'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0133
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0133 USING U_OKCODE.

  CASE U_OKCODE.

    WHEN 'ENTER_133'.
      PERFORM HANDLE_ENTER_ON_SCREEN_0133.
      CLEAR: U_OKCODE.

    WHEN 'CANCLE_133'.
      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_ENTER_ON_SCREEN_0133
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM HANDLE_ENTER_ON_SCREEN_0133.
  DATA: LV_CONTRACT TYPE Y03S24999_CNTRCT.

  PERFORM CREATE_UUID_C36_STATIC CHANGING LV_CONTRACT-ID.

  PERFORM AUTO_GENERATE_CONTRACT_CODE CHANGING LV_CONTRACT-CONTRACT_CODE.
  CONCATENATE 'CT' LV_CONTRACT-CONTRACT_CODE INTO LV_CONTRACT-CONTRACT_CODE.

  LV_CONTRACT-QUOTATION_VERSION_ID = GS_QUOTATION_DETAIL-QUOVER_ID.
  LV_CONTRACT-STAFF = GS_QUOTATION_DETAIL-STAFF.
  LV_CONTRACT-CUSTOMER = GS_QUOTATION_DETAIL-CUSTOMER.
  LV_CONTRACT-STATUS = 'Sent'.
  LV_CONTRACT-CREATED_BY = SY-UNAME.
  LV_CONTRACT-CREATED_AT = SY-UZEIT + ( 3600 * 5 ).
  LV_CONTRACT-CREATED_ON = SY-DATUM.

  CLEAR: CTRDES_TEXT_TAB.
  IF CTRDES_CONTAINER IS NOT INITIAL.
    CTRDES_EDITOR->GET_TEXT_AS_STREAM( IMPORTING TEXT = CTRDES_TEXT_TAB ).
  ENDIF.

  CONCATENATE LINES OF CTRDES_TEXT_TAB INTO LV_CONTRACT-DESCRIPTION.

  INSERT Y03S24999_CNTRCT FROM LV_CONTRACT.

  IF SY-SUBRC <> 0.
    MESSAGE E015(Z03S24999_DOMUS_MSGS) WITH 'Contract'.
  ELSE.
    DATA: LV_QUOMSG TYPE Y03S24999_QUOMSG.

    PERFORM CREATE_UUID_C36_STATIC CHANGING LV_QUOMSG-ID.
    LV_QUOMSG-QUOTATION_ID = GS_QUOTATION_DETAIL-ID.
    CONCATENATE 'Contract' LV_CONTRACT-CONTRACT_CODE 'vừa được tạo thành công!' INTO LV_QUOMSG-CONTENT SEPARATED BY SPACE.
    LV_QUOMSG-CREATED_BY = SY-UNAME.
    LV_QUOMSG-CREATED_AT = SY-UZEIT + ( 3600 * 5 ).
    LV_QUOMSG-CREATED_ON = SY-DATUM.

    INSERT Y03S24999_QUOMSG FROM LV_QUOMSG.

    IF SY-SUBRC <> 0.
      MESSAGE S018(Z03S24999_DOMUS_MSGS) WITH 'Message to Customer' DISPLAY LIKE 'E'.
    ENDIF.

    MESSAGE I023(Z03S24999_DOMUS_MSGS) WITH 'Contract' LV_CONTRACT-CONTRACT_CODE.
    MESSAGE S023(Z03S24999_DOMUS_MSGS) WITH 'Contract' LV_CONTRACT-CONTRACT_CODE.

    PERFORM GET_QUOMSG_ITEMS USING GS_QUOTATION_DETAIL-ID.

    LEAVE TO SCREEN 0.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form MAKE_CONTRACT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM MAKE_CONTRACT USING U_QUOTATION_ID.
  DATA: LV_VERORD TYPE Y03S24999_QUOVER-VERSION_ORDER .
  SELECT MAX( VERSION_ORDER )
      FROM Y03S24999_QUOVER
      WHERE QUOTATION_ID = @U_QUOTATION_ID
      AND IS_DELETED <> @ABAP_TRUE
  INTO @LV_VERORD.

  IF GS_QUOTATION_DETAIL-QUOVER_VERSION_ORDER = LV_VERORD.
    PERFORM RESET_CTRDES_CONTAINER.
    CALL SCREEN 0133 STARTING AT 10 08 ENDING AT 70 24.
  ELSE.
    MESSAGE I000(Z03S24999_DOMUS_MSGS) WITH 'You can just Make Contract' ' from the latest Quotation version!'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form RESET_CTRDES_CONTAINER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM RESET_CTRDES_CONTAINER.
  IF CTRDES_TEXT_TAB IS NOT INITIAL.
    CLEAR CTRDES_TEXT_TAB.
  ENDIF.
  IF CTRDES_EDITOR IS NOT INITIAL.
    CALL METHOD CTRDES_EDITOR->DELETE_TEXT.
    CLEAR CTRDES_EDITOR.
  ENDIF.
  IF CTRDES_CONTAINER IS NOT INITIAL.
    CALL METHOD CTRDES_CONTAINER->FREE.
    CLEAR CTRDES_CONTAINER.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_TEXT_EDITOR_0133
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_TEXT_EDITOR_0133 .

  CREATE OBJECT: CTRDES_CONTAINER EXPORTING CONTAINER_NAME = 'CUSTOM_CONTROL_TEXT_0133',
                 CTRDES_EDITOR    EXPORTING PARENT = CTRDES_CONTAINER
                                            MAX_NUMBER_CHARS = 1333.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form AUTO_GENERATE_CONTRACT_CODE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM AUTO_GENERATE_CONTRACT_CODE CHANGING U_CODE.
  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = '1'
      OBJECT                  = 'Z03G03_CTR'
*     QUANTITY                = '1'
*     SUBOBJECT               = ' '
*     TOYEAR                  = '0000'
*     IGNORE_BUFFER           = ' '
    IMPORTING
      NUMBER                  = U_CODE
*     QUANTITY                =
*     RETURNCODE              =
    EXCEPTIONS
      INTERVAL_NOT_FOUND      = 1
      NUMBER_RANGE_NOT_INTERN = 2
      OBJECT_NOT_FOUND        = 3
      QUANTITY_IS_0           = 4
      QUANTITY_IS_NOT_1       = 5
      INTERVAL_OVERFLOW       = 6
      BUFFER_OVERFLOW         = 7
      OTHERS                  = 8.
  IF SY-SUBRC <> 0.
    MESSAGE E021(Z03S24999_DOMUS_MSGS) WITH 'Contract Code'.
  ENDIF.
ENDFORM.

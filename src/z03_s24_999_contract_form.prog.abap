*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_CONTRACT_FORM
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* SET_CCODE_INITIAL_VALUES
*---------------------------------------------------------------------*
FORM SET_CCODE_INITIAL_VALUES.
  IF P_CCODE[] IS INITIAL.
*    P_CCODE-SIGN   = 'I'.  " Include
*    P_CCODE-OPTION = 'EQ'. " EQ Equal
*    P_CCODE-LOW    = 'CT00000156'.

    P_CCODE-SIGN   = 'I'.  " Include
    P_CCODE-OPTION = 'BT'. " BT Between
    P_CCODE-LOW    = 'CT00000000'. " From CT00000000
    P_CCODE-HIGH   = 'CT99999999'. " To   CT99999999

*  P_CCODE-SIGN   = 'I'.  " Include
*  P_CCODE-OPTION = 'CP'. " CP Contain Pattern
*  P_CCODE-LOW    = 'CT*'. " Begin with 'CT'
    APPEND P_CCODE.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_CONTRACT_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0140
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&      --> U_QCODE
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0140 USING U_OKCODE.
  CASE U_OKCODE.
    WHEN 'EXECUTE'.
      PERFORM PROCESS_CONTRACT_LIST_0140.
      CLEAR: U_OKCODE.

    WHEN 'VIEW_CONTRACT'.
      PERFORM PROCESS_VIEW_CONTRACT_DETAIL CHANGING GV_CONTRACT_ID.
      CLEAR: U_OKCODE.

    WHEN OTHERS.

  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0149
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0149 USING U_OKCODE.
  CASE U_OKCODE.
    WHEN 'BACK_TO_CNTRCT_LIST'.
      PERFORM PROCESS_BACK_TO_CONTRACT_LIST.
      CLEAR: U_OKCODE.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_BACK_TO_CONTRACT_LIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_BACK_TO_CONTRACT_LIST.
    PERFORM RESET_CONTRACT_CONTAINER.
    CONTRACT_SCREEN_MODE = '0140'.
    PERFORM PROCESS_CONTRACT_LIST_0140.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_CONTRACT_LIST_0140
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_CONTRACT_LIST_0140.
  DATA: LV_SUCCESS TYPE ABAP_BOOL.

  PERFORM INIT_CONTRACT_STATUS_COLOR CHANGING GT_CONTRACT_COLOR.
* Get data from CONTRACT table
  PERFORM GET_CONTRACT_DATA CHANGING LV_SUCCESS.
  IF LV_SUCCESS = ABAP_FALSE.
    RETURN.
  ENDIF.
* Show CONTRACT ALV
  PERFORM SHOW_CONTRACT_ALV.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_CONTRACT_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_CONTRACT_DATA CHANGING CH_V_SUCCESS TYPE ABAP_BOOL.
  CLEAR: IT_CONTRACT[], CH_V_SUCCESS.

  SELECT *
    FROM Y03S24999_CNTRCT
    WHERE CONTRACT_CODE IN @P_CCODE
      AND IS_DELETED <> @ABAP_TRUE
    ORDER BY CONTRACT_CODE DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @IT_CONTRACT.

  IF SY-SUBRC <> 0.
    CLEAR IT_CONTRACT.

    IF O_CONTRACT_CONTAINER IS NOT INITIAL.
      CALL METHOD O_CONTRACT_CONTAINER->FREE.
      CLEAR O_CONTRACT_CONTAINER.
    ENDIF.
    IF O_CONTRACT_ALV_TABLE IS NOT INITIAL.
      CLEAR O_CONTRACT_ALV_TABLE.
    ENDIF.
    IF O_CONTRACT_HANDLER IS NOT INITIAL.
      CLEAR O_CONTRACT_HANDLER.
    ENDIF.

    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Contract' DISPLAY LIKE 'E'.
    CH_V_SUCCESS = ABAP_FALSE.
    RETURN.
  ELSE.
    CH_V_SUCCESS = ABAP_TRUE.
  ENDIF.

  LOOP AT IT_CONTRACT ASSIGNING FIELD-SYMBOL(<LS_DATA>).
    PERFORM CHANGE_CONTRACT_COLOR USING <LS_DATA>-STATUS CHANGING <LS_DATA>-LINE_COLOR.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form INIT_CONTRACT_STATUS_COLOR
*&---------------------------------------------------------------------*
FORM INIT_CONTRACT_STATUS_COLOR CHANGING CH_CCOLOR LIKE GT_CONTRACT_COLOR.
  IF CH_CCOLOR IS INITIAL.
    CH_CCOLOR = VALUE #( ( STATUS = 'Sent'      COL = 7 INT = 1 INV = 1 )
                         ( STATUS = 'Signed'    COL = 3 INT = 1 INV = 1 )
                         ( STATUS = 'Cancelled' COL = 6 INT = 1 INV = 1 ) ).
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_CONTRACT_ALV
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_CONTRACT_ALV.
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_CONTRACT_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_CONTRACT_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_CONTRACT_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_CONTRACT_FCAT
*&---------------------------------------------------------------------*
FORM ADD_CONTRACT_FCAT USING U_FIELDNAME
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
*& Form PREPARE_CONTRACT_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_CONTRACT_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_CONTRACT_FCAT USING 'CONTRACT_CODE'  'Contract'    10 '' 'X'  'C700'      CHANGING CH_T_FIELD_CAT,
           ADD_CONTRACT_FCAT USING 'CUSTOMER'       'Customer'    10 ''  ''  'C500'  CHANGING CH_T_FIELD_CAT,
           ADD_CONTRACT_FCAT USING 'STAFF'          'Staff'       10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_CONTRACT_FCAT USING 'STATUS'         'Status'      10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_CONTRACT_FCAT USING 'SIGNED_ON'      'Signed On'   10 ''  ''  'C601'  CHANGING CH_T_FIELD_CAT,
           ADD_CONTRACT_FCAT USING 'SIGNED_AT'      'Signed At'   10 ''  ''  'C701'  CHANGING CH_T_FIELD_CAT,
           ADD_CONTRACT_FCAT USING 'CREATED_BY'     'Created By'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_CONTRACT_FCAT USING 'CREATED_ON'     'Created On'  10 ''  ''  'C601'  CHANGING CH_T_FIELD_CAT,
           ADD_CONTRACT_FCAT USING 'CREATED_AT'     'Created At'  10 ''  ''  'C701'  CHANGING CH_T_FIELD_CAT,
           ADD_CONTRACT_FCAT USING 'UPDATED_BY'     'Updated By'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_CONTRACT_FCAT USING 'UPDATED_ON'     'Updated On'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_CONTRACT_FCAT USING 'UPDATED_AT'     'Updated At'  10 ''  ''  ''      CHANGING CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_CONTRACT_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_CONTRACT_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_CONTRACT_CONTAINER IS INITIAL.
    O_CONTRACT_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0140' ).
  ENDIF.

  IF O_CONTRACT_ALV_TABLE IS INITIAL.
    O_CONTRACT_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_CONTRACT_CONTAINER ).
  ENDIF.

  O_CONTRACT_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_CONTRACT     " Output Table
      IT_FIELDCATALOG               = CH_T_FIELD_CAT   " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).

  IF O_CONTRACT_HANDLER IS INITIAL.
    O_CONTRACT_HANDLER = NEW CL_CONTRACT_ALV_HANDLER( ).
    SET HANDLER O_CONTRACT_HANDLER->HOTSPOT_CLICK FOR O_CONTRACT_ALV_TABLE.
  ENDIF.

  IF SY-SUBRC = 0.
    MESSAGE S006(Z03S24999_DOMUS_MSGS) WITH 'Contract'.
  ELSE.
    MESSAGE E005(Z03S24999_DOMUS_MSGS).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_CONTRACT_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_CONTRACT_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-CTAB_FNAME = 'LINE_COLOR'.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_CONTRACT_COLOR
*&---------------------------------------------------------------------*
FORM CHANGE_CONTRACT_COLOR  USING    U_CSTATUS      TYPE Y03S24999_CNTRCT-STATUS
                             CHANGING CH_LINE_COLOR  TYPE LVC_T_SCOL.

  DATA LS_COLOR TYPE LVC_S_SCOL.
  CLEAR: CH_LINE_COLOR.

  LS_COLOR-FNAME = 'STATUS'.

  TRY.
      MOVE-CORRESPONDING GT_CONTRACT_COLOR[ STATUS =  U_CSTATUS ] TO LS_COLOR-COLOR.
      APPEND LS_COLOR TO CH_LINE_COLOR.

    CATCH CX_SY_ITAB_LINE_NOT_FOUND.

  ENDTRY.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_VIEW_CONTRACT_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  CH_CONTRACT_ID
*& <--  CH_CONTRACT_ID
*&---------------------------------------------------------------------*
FORM PROCESS_VIEW_CONTRACT_DETAIL CHANGING CH_CONTRACT_ID.
  IF O_CONTRACT_ALV_TABLE IS NOT INITIAL.

    DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
    DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.

    CALL METHOD O_CONTRACT_ALV_TABLE->GET_SELECTED_ROWS
      IMPORTING
        ET_INDEX_ROWS = LT_INDEX_ROWS.

    IF LINES( LT_INDEX_ROWS ) = 1.

      READ TABLE LT_INDEX_ROWS INDEX 1 INTO LS_INDEX_ROW.
      READ TABLE IT_CONTRACT INDEX LS_INDEX_ROW INTO DATA(LS_CONTRACT).

      CH_CONTRACT_ID = LS_CONTRACT-ID.
* Prepare CONTRACT Detail to display on Screen 0149
      PERFORM PREPARE_CONTRACT_DETAIL USING CH_CONTRACT_ID.

    ELSEIF LINES( LT_INDEX_ROWS ) = 0.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'one Contract' DISPLAY LIKE 'E'.
    ELSEIF LINES( LT_INDEX_ROWS ) > 1.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'only one Contract' DISPLAY LIKE 'E'.
    ENDIF.

  ELSE.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'one Contract' DISPLAY LIKE 'E'.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_CONTRACT_DETAIL
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PREPARE_CONTRACT_DETAIL USING U_CONTRACT_ID.
  DATA: LV_QUOVER_ID TYPE Y03S24999_QUOVER-ID.

  CLEAR: GV_CONTRACT_TOTAL_PRICE.
  CLEAR: GV_CTRPRV_TOTAL_PRICE.
  CLEAR: GV_CTRSER_TOTAL_PRICE.

  PERFORM RESET_CONTRACT_CONTAINER.

  PERFORM GET_CONTRACT_BASIC_INFO USING U_CONTRACT_ID
                                   CHANGING LV_QUOVER_ID.
  PERFORM GET_CONTRACT_PRODUCT_ITEMS USING LV_QUOVER_ID.
  PERFORM GET_CONTRACT_SERVICE_ITEMS USING LV_QUOVER_ID.

* Change Screen from 0140 to 0149
  CONTRACT_SCREEN_MODE = '0149'.

  MESSAGE S009(Z03S24999_DOMUS_MSGS) WITH 'Contract'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_CONTRACT_BASIC_INFO
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_CONTRACT_ID
*&---------------------------------------------------------------------*
FORM GET_CONTRACT_BASIC_INFO USING U_CONTRACT_ID
                             CHANGING CH_QUOVER_ID.
  SELECT SINGLE *
    FROM Y03S24999_CNTRCT
    INTO CORRESPONDING FIELDS OF GS_CONTRACT_DETAIL
    WHERE ID = U_CONTRACT_ID AND IS_DELETED <> ABAP_TRUE.

  IF SY-SUBRC <> 0.
    MESSAGE E004(Z03S24999_DOMUS_MSGS) WITH 'Contract'.
  ELSE.
    CH_QUOVER_ID = GS_CONTRACT_DETAIL-QUOTATION_VERSION_ID.
    GV_CTRIMG_URL = GS_CONTRACT_DETAIL-SIGNATURE.
    PERFORM SHOW_CTR_SELECTED_IMAGE USING GV_CTRIMG_URL.

    PERFORM SHOW_CONTRACT_DESCRIPTION USING GS_CONTRACT_DETAIL-DESCRIPTION.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_CTR_SELECTED_IMAGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_CTR_SELECTED_IMAGE USING U_CTRIMG_URL TYPE CNDP_URL.
  IF CTRIMG_CONTAINER IS INITIAL OR CTRIMG_CONTROL IS INITIAL.

* Create controls
    CREATE OBJECT CTRIMG_CONTAINER
      EXPORTING
        CONTAINER_NAME = 'CUSTOM_CONTROL_0149'.

    CREATE OBJECT CTRIMG_CONTROL EXPORTING PARENT = CTRIMG_CONTAINER.

* Register the events
    CTRIMG_EVENT_TAB_LINE-EVENTID = CL_GUI_PICTURE=>EVENTID_PICTURE_DBLCLICK.
    APPEND CTRIMG_EVENT_TAB_LINE TO CTRIMG_EVENT_TAB.
    CTRIMG_EVENT_TAB_LINE-EVENTID = CL_GUI_PICTURE=>EVENTID_CONTEXT_MENU.
    APPEND CTRIMG_EVENT_TAB_LINE TO CTRIMG_EVENT_TAB.
    CTRIMG_EVENT_TAB_LINE-EVENTID = CL_GUI_PICTURE=>EVENTID_CONTEXT_MENU_SELECTED.
    APPEND CTRIMG_EVENT_TAB_LINE TO CTRIMG_EVENT_TAB.

    CALL METHOD CTRIMG_CONTROL->SET_REGISTERED_EVENTS
      EXPORTING
        EVENTS = CTRIMG_EVENT_TAB.

* Create the event_receiver object and set the handlers for the events
* of the picture controls
    CREATE OBJECT CTRIMG_EVENT_RECEIVER.
    SET HANDLER CTRIMG_EVENT_RECEIVER->EVENT_HANDLER_PICTURE_DBLCLICK
                FOR CTRIMG_CONTROL.

* Set the display mode to 'normal' (0)
    CALL METHOD CTRIMG_CONTROL->SET_DISPLAY_MODE
      EXPORTING
        DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_NORMAL.

* Set 3D Border
    CALL METHOD CTRIMG_CONTROL->SET_3D_BORDER
      EXPORTING
        BORDER = 1.

    CALL METHOD CTRIMG_CONTROL->SET_DISPLAY_MODE
      EXPORTING
        DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.

  ENDIF.

  CALL METHOD CTRIMG_CONTROL->LOAD_PICTURE_FROM_URL_ASYNC
    EXPORTING
      URL = U_CTRIMG_URL.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SHOW_CONTRACT_DESCRIPTION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SHOW_CONTRACT_DESCRIPTION USING U_CTRDES TYPE Y03S24999_CNTRCT-DESCRIPTION.
  IF CTRDES_CONTAINER01 IS INITIAL OR CTRDES_EDITOR01 IS INITIAL.

    CREATE OBJECT: CTRDES_CONTAINER01 EXPORTING CONTAINER_NAME = 'CUSTOM_CONTROL_TEXT_0149',
                   CTRDES_EDITOR01    EXPORTING PARENT = CTRDES_CONTAINER01
                                              MAX_NUMBER_CHARS = 1333.
  ENDIF.

  CALL FUNCTION 'ZRKD_WORD_WRAP'
    EXPORTING
      TEXTLINE            = U_CTRDES
      OUTPUTLEN           = 256
    TABLES
      OUT_LINES           = CTRDES_TEXT_TAB01
    EXCEPTIONS
      OUTPUTLEN_TOO_LARGE = 1
      OTHERS              = 2.

  IF SY-SUBRC = 0.
    IF CTRDES_CONTAINER01 IS NOT INITIAL.
      CTRDES_EDITOR01->SET_TEXT_AS_STREAM( EXPORTING TEXT = CTRDES_TEXT_TAB01 ).
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_CONTRACT_PRODUCT_VARIANT_ITEMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_QUOVER_ID
*&---------------------------------------------------------------------*
FORM GET_CONTRACT_PRODUCT_ITEMS USING U_QUOVER_ID.

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
  INTO CORRESPONDING FIELDS OF TABLE @GT_CTRPRV.

  IF SY-SUBRC <> 0.
    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Contract Product Variant' DISPLAY LIKE 'E'.

  ELSE.
    SELECT GT~*,
           PRODCT~PRODUCT_NAME
    FROM @GT_CTRPRV AS GT
    JOIN Y03S24999_PRODCT AS PRODCT
    ON GT~PRODUCT_ID = PRODCT~ID
    INTO CORRESPONDING FIELDS OF TABLE @GT_CTRPRV.

    IF SY-SUBRC <> 0.
      MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Product Name' DISPLAY LIKE 'E'.
    ENDIF.

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_CONTRACT_SERVICE_ITEMS
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_QUOVER_ID
*&---------------------------------------------------------------------*
FORM GET_CONTRACT_SERVICE_ITEMS USING U_QUOVER_ID.
  SELECT ' ' AS SEL,
         QS~*,
         S~NAME AS SERVICE_NAME
  FROM Y03S24999_QVSSER AS QS
  JOIN Y03S24999_SERVCE AS S
  ON QS~SERVICE_ID = S~ID
  WHERE QS~IS_DELETED <> @ABAP_TRUE AND
        QS~QUOTATION_VERSION_ID = @U_QUOVER_ID
  INTO CORRESPONDING FIELDS OF TABLE @GT_CTRSER.

  IF SY-SUBRC <> 0.
    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Contract Service' DISPLAY LIKE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form RESET_CONTRACT_CONTAINER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM RESET_CONTRACT_CONTAINER.
  PERFORM RESET_CTRDES01_CONTAINER.
  PERFORM RESET_CTRIMG_CONTAINER.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form RESET_CTRDES01_CONTAINER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM RESET_CTRDES01_CONTAINER.
  IF CTRDES_TEXT_TAB01 IS NOT INITIAL.
    CLEAR CTRDES_TEXT_TAB01.
  ENDIF.
  IF CTRDES_EDITOR01 IS NOT INITIAL.
    CALL METHOD CTRDES_EDITOR01->DELETE_TEXT.
    CLEAR CTRDES_EDITOR01.
  ENDIF.
  IF CTRDES_CONTAINER01 IS NOT INITIAL.
    CALL METHOD CTRDES_CONTAINER01->FREE.
    CLEAR CTRDES_CONTAINER01.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form RESET_CTRIMG_CONTAINER
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM RESET_CTRIMG_CONTAINER.
  IF GV_CTRIMG_URL IS NOT INITIAL.
    CLEAR GV_CTRIMG_URL.
  ENDIF.
  IF CTRIMG_CONTROL IS NOT INITIAL.
    CALL METHOD CTRIMG_CONTROL->CLEAR_PICTURE.
    CLEAR CTRIMG_CONTROL.
  ENDIF.
  IF CTRIMG_CONTAINER IS NOT INITIAL.
    CALL METHOD CTRIMG_CONTAINER->FREE.
    CLEAR CTRIMG_CONTAINER.
  ENDIF.
  IF CTRIMG_EVENT_RECEIVER IS NOT INITIAL.
    CLEAR CTRIMG_EVENT_RECEIVER.
  ENDIF.
ENDFORM.

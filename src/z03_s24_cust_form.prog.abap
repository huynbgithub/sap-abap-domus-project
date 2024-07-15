*&---------------------------------------------------------------------*
*& Include          Z03_S24_CUST_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_UUID_C36_STATIC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- CH_ID
*&---------------------------------------------------------------------*
FORM CREATE_UUID_C36_STATIC CHANGING CH_ID.
  TRY.
      CALL METHOD CL_SYSTEM_UUID=>CREATE_UUID_C36_STATIC
        RECEIVING
          UUID = CH_ID.
    CATCH CX_UUID_ERROR.
  ENDTRY.
ENDFORM.
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
FORM HANDLE_UCOMM_1000  USING    U_OKCODE
                                 U_USERNAME.
  IF U_OKCODE = 'CFM'.

    DATA: LV_IS_CUSTOMER TYPE YS03S24999_ROLES-IS_CUSTOMER.

    IF U_USERNAME = SY-UNAME.

      SELECT SINGLE IS_CUSTOMER FROM Y03S24999_USER
        WHERE USERNAME = @U_USERNAME
        INTO @LV_IS_CUSTOMER.

      IF SY-SUBRC = 0.
        IF LV_IS_CUSTOMER = ABAP_TRUE.
          MESSAGE S024(Z03S24999_DOMUS_MSGS).
          CALL SCREEN 100.
        ELSE.
          MESSAGE S025(Z03S24999_DOMUS_MSGS) WITH U_USERNAME DISPLAY LIKE 'E'.
        ENDIF.
      ELSE.
        MESSAGE S025(Z03S24999_DOMUS_MSGS) WITH U_USERNAME DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
      MESSAGE S003(Z03S24999_DOMUS_MSGS) DISPLAY LIKE 'E'.
    ENDIF.

    CLEAR: U_OKCODE.
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
    WHEN 'EXECUTE'.
      PERFORM PROCESS_QUOTATION_LIST_0100.
      CLEAR: U_OKCODE.
    WHEN 'VIEW_DETAIL'.
      PERFORM PROCESS_VIEW_QUOTATION_DETAIL CHANGING GV_QUOTATION_ID.
      CLEAR: U_OKCODE.
    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0200
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> U_OKCODE
*&      --> U_QCODE
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0200 USING U_OKCODE.
  CASE U_OKCODE.
    WHEN 'BACK_TO_QUOTA_LIST'.
      PERFORM PROCESS_BACK_TO_QUOTATION_LIST.
      CLEAR: U_OKCODE.

    WHEN 'SELECT_QUOVER'.
      PERFORM PROCESS_VIEW_QUOVER_LIST.
      CLEAR: U_OKCODE.

    WHEN 'SEND_MESSAGE'.
      PERFORM PROCESS_SEND_MESSAGE.
      CLEAR: U_OKCODE.

    WHEN 'ACCEPT_QUOTATION'.
      PERFORM PROCESS_ACCEPT_QUOTATION.
      CLEAR: U_OKCODE.

    WHEN 'CANCLE_QUOTATION'.
      PERFORM WARNING_CANCLE_QUOTATION.
      CLEAR: U_OKCODE.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_ACCEPT_QUOTATION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_ACCEPT_QUOTATION.
  DATA: LS_QUOTA TYPE Y03S24999_QUOTA.

  SELECT SINGLE *
    FROM Y03S24999_QUOTA
    WHERE ID = @GS_QUOTATION_DETAIL-ID
    INTO CORRESPONDING FIELDS OF @LS_QUOTA.

  LS_QUOTA-STATUS = 'Accepted'.

  MODIFY Y03S24999_QUOTA FROM LS_QUOTA.

  IF SY-SUBRC <> 0.
    MESSAGE E027(Z03S24999_DOMUS_MSGS).

  ELSE.
    DATA: LV_MESSAGE TYPE Y03S24999_QUOMSG-CONTENT.
    CONCATENATE 'Tôi chấp nhận báo giá của Quotation' GS_QUOTATION_DETAIL-QUOTATION_CODE 'này!'
      INTO LV_MESSAGE SEPARATED BY SPACE.
    PERFORM PROCESS_AUTO_SEND_MESSAGE USING LV_MESSAGE.

    PERFORM PREPARE_QUOTATION_DETAIL USING GS_QUOTATION_DETAIL-ID.
    MESSAGE S026(Z03S24999_DOMUS_MSGS).

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form WARNING_CANCLE_QUOTATION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM WARNING_CANCLE_QUOTATION .
  DATA: LD_CHOICE TYPE CHAR01.
    CALL FUNCTION 'POPUP_TO_CONFIRM'
      EXPORTING
        TEXT_QUESTION         = 'Do you want to CANCLE quotation?'
        TEXT_BUTTON_1         = 'Yes'(001)
        TEXT_BUTTON_2         = 'No'(002)
        DISPLAY_CANCEL_BUTTON = ''
      IMPORTING
        ANSWER                = LD_CHOICE.
    IF LD_CHOICE = '1'.
      PERFORM PROCESS_CANCLE_QUOTATION.

    ELSEIF LD_CHOICE = '2'.

    ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_CANCLE_QUOTATION
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_CANCLE_QUOTATION.
  DATA: LS_QUOTA TYPE Y03S24999_QUOTA.

  SELECT SINGLE *
    FROM Y03S24999_QUOTA
    WHERE ID = @GS_QUOTATION_DETAIL-ID
    INTO CORRESPONDING FIELDS OF @LS_QUOTA.

  LS_QUOTA-STATUS = 'Cancelled'.

  MODIFY Y03S24999_QUOTA FROM LS_QUOTA.

  IF SY-SUBRC <> 0.
    MESSAGE E029(Z03S24999_DOMUS_MSGS).

  ELSE.
    DATA: LV_MESSAGE TYPE Y03S24999_QUOMSG-CONTENT.
    CONCATENATE 'Xin lỗi, tôi xin phép hủy Quotation' GS_QUOTATION_DETAIL-QUOTATION_CODE 'này!'
      INTO LV_MESSAGE SEPARATED BY SPACE.

    PERFORM PROCESS_AUTO_SEND_MESSAGE USING LV_MESSAGE.

    PERFORM PREPARE_QUOTATION_DETAIL USING GS_QUOTATION_DETAIL-ID.
    MESSAGE S028(Z03S24999_DOMUS_MSGS).

  ENDIF.
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
  LS_QUOMSG-IS_CUSTOMER_MESSAGE = ABAP_TRUE.
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
*& Form PROCESS_AUTO_SEND_MESSAGE
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_AUTO_SEND_MESSAGE USING U_QUOMSG_CONTENT.
  DATA: LS_QUOMSG TYPE Y03S24999_QUOMSG.

  LS_QUOMSG-QUOTATION_ID = GV_QUOTATION_ID.
  LS_QUOMSG-CONTENT = U_QUOMSG_CONTENT.
  LS_QUOMSG-IS_CUSTOMER_MESSAGE = ABAP_TRUE.
  LS_QUOMSG-CREATED_BY = SY-UNAME.
  LS_QUOMSG-CREATED_AT = SY-UZEIT + ( 3600 * 5 ).
  LS_QUOMSG-CREATED_ON = SY-DATUM.

  PERFORM CREATE_UUID_C36_STATIC CHANGING LS_QUOMSG-ID.

  INSERT Y03S24999_QUOMSG FROM LS_QUOMSG.

  IF SY-SUBRC <> 0.
    MESSAGE E018(Z03S24999_DOMUS_MSGS) WITH 'message'.
  ENDIF.

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
*& Form PROCESS_BACK_TO_QUOTATION_LIST
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_BACK_TO_QUOTATION_LIST.
  PERFORM RESET_QUOPCKIMG_CONTAINER.
  PERFORM PROCESS_QUOTATION_LIST_0100.
  LEAVE TO SCREEN 0.
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
*& Form PROCESS_QUOTATION_LIST_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM PROCESS_QUOTATION_LIST_0100.
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
    LEFT OUTER JOIN Y03S24999_PACKGE AS P
    ON Q~PACKAGE_ID = P~ID
    WHERE Q~QUOTATION_CODE IN @P_QCODE
      AND Q~IS_DELETED <> @ABAP_TRUE
      AND Q~CUSTOMER = @GV_USERNAME
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
  CH_S_LAYOUT-CTAB_FNAME = 'LINE_COLOR'.
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
* Prepare QUOTATION Detail to display on Screen 0200
      PERFORM PREPARE_QUOTATION_DETAIL USING CH_QUOTATION_ID.
      CALL SCREEN 200.

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
FORM PREPARE_QUOTATION_DETAIL USING U_QUOTATION_ID.
  DATA: LV_QUOVER_ID TYPE Y03S24999_QUOVER-ID.
  CLEAR: GV_QUOVER_TOTAL_PRICE.
  CLEAR: GV_QVSPRV_TOTAL_PRICE.
  CLEAR: GV_QVSSER_TOTAL_PRICE.

  PERFORM GET_QUOTATION_BASIC_INFO USING U_QUOTATION_ID CHANGING LV_QUOVER_ID.
  PERFORM GET_QUOVER_PRODUCT_ITEMS USING LV_QUOVER_ID.
  PERFORM GET_QUOVER_SERVICE_ITEMS USING LV_QUOVER_ID.
  PERFORM GET_QUOMSG_ITEMS         USING U_QUOTATION_ID.

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

  CH_QUOVER_ID = GS_QUOTATION_DETAIL-QUOVER_ID.
  GV_QUOPCKIMG_URL = GS_QUOTATION_DETAIL-PCKIMG_URL.
  PERFORM SHOW_QUOPCK_SELECTED_IMAGE USING GV_QUOPCKIMG_URL.
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
        CONTAINER_NAME = 'CUSTOM_CONTROL_0200'.

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

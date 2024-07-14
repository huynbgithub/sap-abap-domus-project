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
    WHEN 'DETAILS'.
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

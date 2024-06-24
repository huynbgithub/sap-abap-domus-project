*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DOMUS_STAFF_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form HANDLE_EXIT_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
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
*&      --> IN_OKCODE
*&      --> IN_USERNAME
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_1000  USING    IN_OKCODE
                                 IN_USERNAME.
  IF IN_OKCODE = 'CFM'.

    DATA: LV_IS_STAFF TYPE YS03S24999_ROLES-IS_STAFF.

    IF IN_USERNAME = SY-UNAME.

      SELECT SINGLE IS_STAFF FROM Y03S24999_USER
        WHERE USERNAME = @IN_USERNAME
        INTO @LV_IS_STAFF.

      IF SY-SUBRC = 0.
        IF LV_IS_STAFF = ABAP_TRUE.
          MESSAGE S001(Z03S24999_DOMUS_MSGS).
          CALL SCREEN 100.
        ELSE.
          MESSAGE S002(Z03S24999_DOMUS_MSGS) WITH IN_USERNAME DISPLAY LIKE 'E'.
        ENDIF.
      ELSE.
        MESSAGE S002(Z03S24999_DOMUS_MSGS) WITH IN_USERNAME DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
      MESSAGE S003(Z03S24999_DOMUS_MSGS) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0130
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> IN_OKCODE
*&      --> IN_QCODE
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0130  USING    IN_OKCODE
                                 IN_QCODE.
  CASE IN_OKCODE.

    WHEN 'EXECUTE'.
* Get data from QUOTATION table
      PERFORM GET_QUOTATION_DATA.
* Show QUOTATION ALV
      PERFORM SHOW_QUOTATION_ALV.

    WHEN OTHERS.

  ENDCASE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_QUOTATION_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_QUOTATION_DATA .
  CLEAR: IT_QUOTATION[].

  SELECT Q~*, P~NAME AS PACKAGE_NAME
    FROM Y03S24999_QUOTA AS Q
    LEFT JOIN Y03S24999_PACKGE AS P
    ON Q~PACKAGE_ID = P~ID
    WHERE Q~QUOTATION_CODE IN @P_QCODE  AND Q~IS_DELETED <> @ABAP_TRUE AND P~IS_DELETED <> @ABAP_TRUE
    INTO CORRESPONDING FIELDS OF TABLE @IT_QUOTATION.

  IF SY-SUBRC <> 0.
    MESSAGE E004(Z03S24999_DOMUS_MSGS).
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
FORM SHOW_QUOTATION_ALV .
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_LAYOUT
    CHANGING LS_LAYOUT.

* Show ALV
  PERFORM DISPLAY_ALV_TABLE
    USING LS_LAYOUT
    CHANGING LT_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_FCAT
*&---------------------------------------------------------------------*
FORM ADD_FCAT USING FIELDNAME
                    SCRTEXT_M
                    OUTPUTLEN
                    KEY
              CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
  DATA: WA_FIELD_CAT TYPE LVC_S_FCAT.
  WA_FIELD_CAT-FIELDNAME = FIELDNAME.
  WA_FIELD_CAT-SCRTEXT_M = SCRTEXT_M.
  WA_FIELD_CAT-OUTPUTLEN = OUTPUTLEN.
  WA_FIELD_CAT-KEY = KEY.
  APPEND WA_FIELD_CAT TO CH_T_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

  DATA: WA_FIELD_CAT TYPE LVC_S_FCAT.

***** Full form:
  PERFORM: ADD_FCAT USING 'QUOTATION_CODE' 'Quotation Code'    12 'X' CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'CUSTOMER'       'Customer'          12 ''  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'STAFF'          'Staff'             10 ''  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'STATUS'         'Status'            10 ''  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'PACKAGE_NAME'   'Package Name'      20 ''  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'EXPIRED_ON'     'Expired On'        10 ''  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'EXPIRED_AT'     'Expired At'        10 ''  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'CREATED_BY'     'Created By'        10 ''  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'CREATED_AT'     'Created At'        10 ''  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'CREATED_ON'     'Created On'        10 ''  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'UPDATED_BY'     'Updated By'        10 ''  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'UPDATED_AT'     'Updated At'        10 ''  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'UPDATED_ON'     'Updated On'        10 ''  CHANGING CH_T_FIELD_CAT.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_TABLE
  USING IM_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

  O_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0130'
*                                             REPID = SY-REPID
*                                             DYNNR = '0130'
                                             ).

  O_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_CONTAINER ).

  O_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = IM_S_LAYOUT      " Layout
    CHANGING
      IT_OUTTAB                     = IT_QUOTATION          " Output Table
      IT_FIELDCATALOG               = CH_T_FIELD_CAT                 " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).

  IF SY-SUBRC <> 0.
    MESSAGE E002(Z03_S24_000_MYMSGS).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.

ENDFORM.

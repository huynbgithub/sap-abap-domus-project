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
      IF O_CONTAINER IS NOT INITIAL.
        CALL METHOD O_CONTAINER->FREE.
        CLEAR O_CONTAINER.
      ENDIF.
      IF O_ALV_TABLE IS NOT INITIAL.
        FREE O_ALV_TABLE.
        CLEAR O_ALV_TABLE.
      ENDIF.
      IF P_QCODE IS NOT INITIAL.
        FREE P_QCODE.
        CLEAR P_QCODE.
      ENDIF.
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
* Set color for each quotation status
      PERFORM SET_INIT_STATUS_COLOR.
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
    WHERE Q~QUOTATION_CODE IN @P_QCODE  AND
          Q~IS_DELETED <> @ABAP_TRUE AND
          P~IS_DELETED <> @ABAP_TRUE AND
          Q~STAFF = @GV_USERNAME
    INTO CORRESPONDING FIELDS OF TABLE @IT_QUOTATION.

  IF SY-SUBRC <> 0.
    MESSAGE E004(Z03S24999_DOMUS_MSGS).
  ENDIF.

    LOOP AT IT_QUOTATION ASSIGNING FIELD-SYMBOL(<LS_DATA>).

      PERFORM CHANGE_COLOR USING <LS_DATA>-STATUS CHANGING <LS_DATA>-COLOR.
    ENDLOOP.
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
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_FCAT
*&---------------------------------------------------------------------*
FORM ADD_FCAT USING U_FIELDNAME
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
*& Form PREPARE_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_FCAT USING 'QUOTATION_CODE' 'Quotation'         10 'X' 'X' ''      CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'CUSTOMER'       'Customer'          10 ''  ''  'C500'  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'STAFF'          'Staff'             10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'STATUS'         'Status'            10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'PACKAGE_NAME'   'Reference Package' 10 ''  ''  'C700'  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'EXPIRED_ON'     'Expired On'        10 ''  ''  'C601'  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'EXPIRED_AT'     'Expired At'        10 ''  ''  'C701'  CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'CREATED_BY'     'Created By'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'CREATED_AT'     'Created At'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'CREATED_ON'     'Created On'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'UPDATED_BY'     'Updated By'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'UPDATED_AT'     'Updated At'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_FCAT USING 'UPDATED_ON'     'Updated On'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_ALV_TABLE
  CHANGING CH_S_LAYOUT    TYPE LVC_S_LAYO
*          IM_S_VARIANT   TYPE DISVARIANT
           CH_T_FIELD_CAT TYPE LVC_T_FCAT.

  CH_S_LAYOUT-CTAB_FNAME = 'COLOR'.
  IF O_CONTAINER IS INITIAL.

    O_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0132' ).
    O_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_CONTAINER ).
  ENDIF.

  O_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = CH_S_LAYOUT      " Layout
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

  DATA(LO_HANDLER) = NEW LCL_ALV_HANDLER( ).
  SET HANDLER LO_HANDLER->HOTSPOT_CLICK FOR O_ALV_TABLE.

  IF SY-SUBRC = 0.
    MESSAGE S006(Z03S24999_DOMUS_MSGS).
  ELSE.
    MESSAGE E005(Z03S24999_DOMUS_MSGS).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form PREPARE_VARIANT
*&---------------------------------------------------------------------*
*FORM PREPARE_VARIANT CHANGING CH_S_VARIANT TYPE DISVARIANT.
*
*  CH_S_VARIANT-REPORT = SY-REPID.
*  CH_S_VARIANT-HANDLE = 001.
*  CH_S_VARIANT-VARIANT = '/CUSTOM_CONTROL_ALV_0132'.
*
*ENDFORM.
*---------------------------------------------------------------------*
* SET_QCODE_INITIAL_VALUES
*---------------------------------------------------------------------*
FORM SET_QCODE_INITIAL_VALUES.
*  P_QCODE-SIGN   = C_SIGN_I.  " Include
*  P_QCODE-OPTION = C_OPTION_EQ. " EQ Equal
*  P_QCODE-LOW    = 'Q000000001'.

  P_QCODE-SIGN   = 'I'.  " Include
  P_QCODE-OPTION = 'BT'. " BT Between
  P_QCODE-LOW    = 'Q000000170'. " From Q000000170
  P_QCODE-HIGH   = 'Q000000180'. " To Q000000180

*  P_QCODE-SIGN   = 'I'.  " Include
*  P_QCODE-OPTION = 'CP'. " CP Contain Pattern
*  P_QCODE-LOW    = 'Q*'. " Begin with 'Q'

ENDFORM.
*&---------------------------------------------------------------------*
*& Form SET_INIT_STATUS_COLOR
*&---------------------------------------------------------------------*
FORM SET_INIT_STATUS_COLOR.
  GT_COLOR = VALUE #( ( STATUS = 'Negotiating' COL = 7 INT = 1 INV = 1 )
                      ( STATUS = 'Accepted'    COL = 3 INT = 1 INV = 1 )
                      ( STATUS = 'Cancelled'   COL = 6 INT = 1 INV = 1 )
                      ( STATUS = 'Requested'   COL = 5 INT = 1 INV = 1 ) ).
ENDFORM.
*&---------------------------------------------------------------------*
*& Form CHANGE_COLOR
*&---------------------------------------------------------------------*
FORM CHANGE_COLOR  USING    U_QSTATUS TYPE Y03S24999_QUOTA-STATUS
                   CHANGING CH_COLOR TYPE LVC_T_SCOL.

  DATA LS_COLOR TYPE LVC_S_SCOL.
  CLEAR: CH_COLOR.

  LS_COLOR-FNAME = 'STATUS'.

  TRY.
      MOVE-CORRESPONDING GT_COLOR[ STATUS =  U_QSTATUS ] TO LS_COLOR-COLOR.
      APPEND LS_COLOR TO CH_COLOR.
  CATCH CX_SY_ITAB_LINE_NOT_FOUND.

  ENDTRY.

ENDFORM.

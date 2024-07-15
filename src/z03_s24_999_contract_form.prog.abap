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
*      PERFORM PROCESS_VIEW_CONTRACT_DETAIL CHANGING GV_CONTRACT_ID.
      CLEAR: U_OKCODE.

    WHEN OTHERS.

  ENDCASE.
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
    ORDER BY CREATED_ON DESCENDING, CREATED_AT DESCENDING, CONTRACT_CODE DESCENDING
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

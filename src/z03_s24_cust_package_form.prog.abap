*&---------------------------------------------------------------------*
*& Include          Z03_S24_CUST_PACKAGE_FORM
*&---------------------------------------------------------------------*
*& Form HANDLE_EXIT_COMMAND
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SY_UCOMM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_UUID_C36_STATIC
*&---------------------------------------------------------------------*
FORM CREATE_UUID_C36_STATIC CHANGING CH_ID.
  TRY.
      CALL METHOD CL_SYSTEM_UUID=>CREATE_UUID_C36_STATIC
        RECEIVING
          UUID = CH_ID.
    CATCH CX_UUID_ERROR.
  ENDTRY.
ENDFORM.

FORM HANDLE_EXIT_COMMAND  USING    P_SY_UCOMM.
  CASE P_SY_UCOMM.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.

    WHEN 'EXIT' OR 'CANC'.
      LEAVE PROGRAM.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_USER_COMMAND_0100
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SY_UCOMM
*&---------------------------------------------------------------------*
FORM HANDLE_USER_COMMAND_0100  USING    P_SY_UCOMM.
  CASE P_SY_UCOMM.
    WHEN 'EXECUTE'.
      PERFORM DISPLAY_PACKAGE_LIST.
      CLEAR P_SY_UCOMM.

  ENDCASE.
ENDFORM.
* SUBROUTINES FOR PACKAGE ALV DISPLAY ON SCREEN 0100
*&---------------------------------------------------------------------*
*& Form DISPLAY_PACKAGE_LIST
*&---------------------------------------------------------------------*
FORM DISPLAY_PACKAGE_LIST .
  DATA LV_SUCCESS TYPE ABAP_BOOL.

  "Set Color for Package ALV
  PERFORM SET_INIT_PACKAGE_COLOR.

  "Fetch Data for internal table IT_PACKAGE
  PERFORM GET_PACKAGE_DATA CHANGING LV_SUCCESS.

  IF LV_SUCCESS = ABAP_FALSE.
    RETURN.
  ENDIF.

  "Display ALV for Package
  PERFORM SHOW_PACKAGE_ALV.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form SET_INIT_PACKAGE_COLOR
*&---------------------------------------------------------------------*
FORM SET_INIT_PACKAGE_COLOR .
  CLEAR: GT_PACKAGE_COLOR.
  GT_PACKAGE_COLOR = VALUE #(
                              ( COL = 3 INT = 0 INV = 0 )
                              ( COL = 1 INT = 0 INV = 0 )
                              ( COL = 5 INT = 0 INV = 0 )
                              ( COL = 7 INT = 0 INV = 0 )
                              ( COL = 5 INT = 1 INV = 0 )
                              ( COL = 5 INT = 0 INV = 1 )
                             ).
ENDFORM.

*&---------------------------------------------------------------------*
*& Form GET_PACKAGE_DATA to populate the data from db to internal table of Package
*&---------------------------------------------------------------------*
FORM GET_PACKAGE_DATA CHANGING CH_V_SUCCESS TYPE ABAP_BOOL.
  CLEAR: IT_PACKAGE, CH_V_SUCCESS.

  SELECT *
    FROM Y03S24999_PACKGE
    WHERE NAME IN @P_PKNAME
      AND IS_DELETED <> @ABAP_TRUE
    ORDER BY UPDATED_ON DESCENDING, UPDATED_AT DESCENDING, NAME ASCENDING
    INTO CORRESPONDING FIELDS OF TABLE @IT_PACKAGE.

  IF SY-SUBRC <> 0.
    CLEAR IT_PACKAGE.

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

  LOOP AT IT_PACKAGE ASSIGNING FIELD-SYMBOL(<LS_DATA>).
    DATA: LV_LINE_INDEX TYPE SYST-TABIX.
    CLEAR: LV_LINE_INDEX.
    LV_LINE_INDEX = SY-TABIX.
    PERFORM CHANGE_PACKAGE_COLOR USING LV_LINE_INDEX CHANGING <LS_DATA>-LINE_COLOR.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form CHANGE_PACKAGE_COLOR
*&---------------------------------------------------------------------*
FORM CHANGE_PACKAGE_COLOR  USING    U_LINE_INDEX  TYPE SYST_TABIX
                           CHANGING CH_LINE_COLOR TYPE LVC_T_SCOL.
  DATA LS_COLOR TYPE LVC_S_SCOL.
  DATA: LV_COLOR_INDEX TYPE INT1.

  CLEAR: CH_LINE_COLOR.
  LV_COLOR_INDEX = ( ( U_LINE_INDEX - 1 ) MOD 2 ) + 1.

  TRY.
      MOVE-CORRESPONDING GT_PACKAGE_COLOR[ LV_COLOR_INDEX ] TO LS_COLOR-COLOR.

      LS_COLOR-FNAME = 'DESCRIPTION'.
      APPEND LS_COLOR TO CH_LINE_COLOR.

      MOVE-CORRESPONDING GT_PACKAGE_COLOR[ LV_COLOR_INDEX + 4 ] TO LS_COLOR-COLOR.

      LS_COLOR-FNAME = 'NAME'.
      APPEND LS_COLOR TO CH_LINE_COLOR.

    CATCH CX_SY_ITAB_LINE_NOT_FOUND.

  ENDTRY.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form SHOW_PACKAGE_ALV -> display Packge ALV
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
*& Form PREPARE_PACKAGE_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_PACKAGE_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_PACKAGE_FCAT USING 'NAME'         'Name'         28 ''  'X' '' CHANGING CH_T_FIELD_CAT,
           ADD_PACKAGE_FCAT USING 'DESCRIPTION'  'Description'  64 ''  ''  ''     CHANGING CH_T_FIELD_CAT.
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
*& Form PREPARE_PACKAGE_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_PACKAGE_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-CTAB_FNAME = 'LINE_COLOR'.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_PACKAGE_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_PACKAGE_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_PACKAGE_CONTAINER IS INITIAL.
    O_PACKAGE_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0100' ).
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
*& Form PREPARE_PACKAGE_DETAIL_DISPLAY_0160
*&---------------------------------------------------------------------*
FORM PREPARE_PACKAGE_DETAIL  USING    U_PACKAGE_ID.

  PERFORM RESET_PACKAGE_CONTAINER.

  PERFORM GET_PACKAGE_BASIC_INFO    USING U_PACKAGE_ID.
  PERFORM GET_PACKAGE_PRODUCT_ITEMS USING U_PACKAGE_ID.
  PERFORM GET_PACKAGE_SERVICE_ITEMS USING U_PACKAGE_ID.
  PERFORM GET_PACKAGE_IMAGE_ITEMS   USING U_PACKAGE_ID.

  MESSAGE S009(Z03S24999_DOMUS_MSGS) WITH 'Package'.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form RESET_PACKAGE_CONTAINER
*&---------------------------------------------------------------------*
FORM RESET_PACKAGE_CONTAINER .
  PERFORM RESET_PCKDES_CONTAINER.
  PERFORM RESET_PCKIMG_CONTAINER.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form RESET_PCKDES_CONTAINER
*&---------------------------------------------------------------------*
FORM RESET_PCKDES_CONTAINER.
  IF PCKDES_TEXT_TAB IS NOT INITIAL.
    CLEAR PCKDES_TEXT_TAB.
  ENDIF.
  IF PCKDES_EDITOR IS NOT INITIAL.
    CALL METHOD PCKDES_EDITOR->DELETE_TEXT.
    CLEAR PCKDES_EDITOR.
  ENDIF.
  IF PCKDES_CONTAINER IS NOT INITIAL.
    CALL METHOD PCKDES_CONTAINER->FREE.
    CLEAR PCKDES_CONTAINER.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form RESET_PCKIMG_CONTAINER
*&---------------------------------------------------------------------*
FORM RESET_PCKIMG_CONTAINER.
  IF GV_PCKIMG_URL IS NOT INITIAL.
    CLEAR GV_PCKIMG_URL.
  ENDIF.
  IF PCKIMG_CONTROL IS NOT INITIAL.
    CALL METHOD PCKIMG_CONTROL->CLEAR_PICTURE.
    CLEAR PCKIMG_CONTROL.
  ENDIF.
  IF PCKIMG_CONTAINER IS NOT INITIAL.
    CALL METHOD PCKIMG_CONTAINER->FREE.
    CLEAR PCKIMG_CONTAINER.
  ENDIF.
  IF PCKIMG_EVENT_RECEIVER IS NOT INITIAL.
    CLEAR PCKIMG_EVENT_RECEIVER.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form GET_PACKAGE_BASIC_INFO
*&---------------------------------------------------------------------*
FORM GET_PACKAGE_BASIC_INFO USING U_PACKAGE_ID.
  SELECT SINGLE *
    FROM Y03S24999_PACKGE
    INTO CORRESPONDING FIELDS OF GS_PACKAGE_DETAIL
    WHERE ID = U_PACKAGE_ID AND IS_DELETED <> ABAP_TRUE.

  IF SY-SUBRC <> 0.
    MESSAGE E004(Z03S24999_DOMUS_MSGS) WITH 'Package'.
  ELSE.
    PERFORM SHOW_PACKAGE_DESCRIPTION USING GS_PACKAGE_DETAIL-DESCRIPTION.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form SHOW_PACKAGE_DESCRIPTION
*&---------------------------------------------------------------------*
FORM SHOW_PACKAGE_DESCRIPTION USING U_PCKDES TYPE Y03S24999_PACKGE-DESCRIPTION.
  IF PCKDES_CONTAINER IS INITIAL OR PCKDES_EDITOR IS INITIAL.

    CREATE OBJECT: PCKDES_CONTAINER EXPORTING CONTAINER_NAME = 'CUSTOM_CONTROL_TEXT_0160',
                   PCKDES_EDITOR    EXPORTING PARENT = PCKDES_CONTAINER
                                              MAX_NUMBER_CHARS = 1333.
  ENDIF.

  CALL FUNCTION 'RKD_WORD_WRAP'
    EXPORTING
      TEXTLINE            = U_PCKDES
      OUTPUTLEN           = 256
    TABLES
      OUT_LINES           = PCKDES_TEXT_TAB
    EXCEPTIONS
      OUTPUTLEN_TOO_LARGE = 1
      OTHERS              = 2.

  IF SY-SUBRC = 0.

    IF PCKDES_CONTAINER IS NOT INITIAL.
      PCKDES_EDITOR->SET_TEXT_AS_STREAM( EXPORTING TEXT = PCKDES_TEXT_TAB ).
    ENDIF.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form GET_PACKAGE_PRODUCT_VARIANT_ITEMS
*&---------------------------------------------------------------------*
FORM GET_PACKAGE_PRODUCT_ITEMS USING U_PACKAGE_ID.

  SELECT ' ' AS SEL,
         PCKPRV~*,
         PROVRT~VARIANT_CODE AS VARIANT_CODE,
         PROVRT~PRODUCT_ID,
         PROVRT~DISPLAY_PRICE AS DISPLAY_PRICE
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

  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_PACKAGE_SERVICE_ITEMS
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

ENDFORM.

*&---------------------------------------------------------------------*
*& Form GET_PACKAGE_IMAGE_ITEMS
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
  ELSE.
    READ TABLE GT_PCKIMG INDEX 1 INTO DATA(LS_ROW).
    GV_PCKIMG_URL = LS_ROW-IMAGE_URL.
    PERFORM SHOW_PACKAGE_SELECTED_IMAGE USING GV_PCKIMG_URL.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form SHOW_PACKAGE_SELECTED_IMAGE
*&---------------------------------------------------------------------*
FORM SHOW_PACKAGE_SELECTED_IMAGE USING U_PCKIMG_URL TYPE CNDP_URL.
  IF PCKIMG_CONTAINER IS INITIAL OR PCKIMG_CONTROL IS INITIAL.

* Create controls
    CREATE OBJECT PCKIMG_CONTAINER
      EXPORTING
        CONTAINER_NAME = 'CUSTOM_CONTROL_0160'.

    CREATE OBJECT PCKIMG_CONTROL EXPORTING PARENT = PCKIMG_CONTAINER.

* Register the events
    PCKIMG_EVENT_TAB_LINE-EVENTID = CL_GUI_PICTURE=>EVENTID_PICTURE_DBLCLICK.
    APPEND PCKIMG_EVENT_TAB_LINE TO PCKIMG_EVENT_TAB.
    PCKIMG_EVENT_TAB_LINE-EVENTID = CL_GUI_PICTURE=>EVENTID_CONTEXT_MENU.
    APPEND PCKIMG_EVENT_TAB_LINE TO PCKIMG_EVENT_TAB.
    PCKIMG_EVENT_TAB_LINE-EVENTID = CL_GUI_PICTURE=>EVENTID_CONTEXT_MENU_SELECTED.
    APPEND PCKIMG_EVENT_TAB_LINE TO PCKIMG_EVENT_TAB.

    CALL METHOD PCKIMG_CONTROL->SET_REGISTERED_EVENTS
      EXPORTING
        EVENTS = PCKIMG_EVENT_TAB.

* Create the event_receiver object and set the handlers for the events
* of the picture controls
    CREATE OBJECT PCKIMG_EVENT_RECEIVER.
    SET HANDLER PCKIMG_EVENT_RECEIVER->EVENT_HANDLER_PICTURE_DBLCLICK
                FOR PCKIMG_CONTROL.

* Set the display mode to 'normal' (0)
    CALL METHOD PCKIMG_CONTROL->SET_DISPLAY_MODE
      EXPORTING
        DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_NORMAL.

* Set 3D Border
    CALL METHOD PCKIMG_CONTROL->SET_3D_BORDER
      EXPORTING
        BORDER = 1.

    CALL METHOD PCKIMG_CONTROL->SET_DISPLAY_MODE
      EXPORTING
        DISPLAY_MODE = CL_GUI_PICTURE=>DISPLAY_MODE_STRETCH.

  ENDIF.

  CALL METHOD PCKIMG_CONTROL->LOAD_PICTURE_FROM_URL_ASYNC
    EXPORTING
      URL = U_PCKIMG_URL.

ENDFORM.

* Subroutines to prepare for Product Attributes (0140) when the hotspot on Product Variant (0130 is clicked)
*&---------------------------------------------------------------------*
*& Form PREPARE_PACKAGE_PROATV_0140
*&---------------------------------------------------------------------*
FORM PREPARE_PACKAGE_PROATV_0140  USING  U_PROVRT_ID.

  SELECT PROATV~VALUE, PROATR~ATTRIBUTE_NAME
    FROM Y03S24999_PROATV AS PROATV
    LEFT JOIN Y03S24999_PROATR AS PROATR
    ON PROATR~ID = PROATV~PRODUCT_ATTRIBUTE_ID
    WHERE PROATV~IS_DELETED <> @ABAP_TRUE
    AND PROATV~PRODUCT_VARIANT_ID = @U_PROVRT_ID
    INTO CORRESPONDING FIELDS OF TABLE @IT_PROATV_0140.

  IF SY-SUBRC <> 0.
    CLEAR IT_PROATV_0140[].

    IF O_PROATV_0140_CONTAINER IS NOT INITIAL.
      CALL METHOD O_PROATV_0140_CONTAINER->FREE.
      CLEAR O_PROATV_0140_CONTAINER.
    ENDIF.
    IF O_PROATV_0140_ALV_TABLE IS NOT INITIAL.
      CLEAR O_PROATV_0140_ALV_TABLE.
    ENDIF.

    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Attribute of this product' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

ENDFORM.

*SERVICE LIST 0150 SUBROUTINES
*&---------------------------------------------------------------------*
*& Form SHOW_SERVICE_0150_ALV
*&---------------------------------------------------------------------*
FORM SHOW_SERVICE_0150_ALV .
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_SER_0150_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_SERVICE_0150_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_SERVICE_0150_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form PREPARE_SERVICE_0150_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_SER_0150_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_SERVICE_0150_FCAT USING 'NAME'           'Name'              20 '' 'X'  'C500'  CHANGING CH_T_FIELD_CAT,
           ADD_SERVICE_0150_FCAT USING 'DESCRIPTION'    'Description'       10 ''  ''  ''      CHANGING CH_T_FIELD_CAT.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form ADD_SERVICE_0150_FCAT
*&---------------------------------------------------------------------*
FORM ADD_SERVICE_0150_FCAT USING U_FIELDNAME
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
*& Form PREPARE_SERVICE_015-_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_SERVICE_0150_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_SERVICE_0150_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_SERVICE_0150_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_SERVICE_0150_CONTAINER IS INITIAL.
    O_SERVICE_0150_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0150' ).
  ENDIF.

  IF O_SERVICE_0150_ALV_TABLE IS INITIAL.
    O_SERVICE_0150_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_SERVICE_0150_CONTAINER ).
  ENDIF.

  O_SERVICE_0150_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_SERVICE_0150     " Output Table
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
*& Form HANDLE_UCOMM_0150
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0150  USING    U_OKCODE.
  CASE U_OKCODE.

    WHEN 'ENTER_0150'.
      PERFORM HANDLE_ENTER_ON_SCREEN_0150.
      CLEAR: U_OKCODE.

    WHEN 'CANCEL_150'.
      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form HANDLE_ENTER_ON_SCREEN_0150
*&---------------------------------------------------------------------*
FORM HANDLE_ENTER_ON_SCREEN_0150 .
  IF O_SERVICE_0150_ALV_TABLE IS NOT INITIAL.

    DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
    DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.

    CALL METHOD O_SERVICE_0150_ALV_TABLE->GET_SELECTED_ROWS
      IMPORTING
        ET_INDEX_ROWS = LT_INDEX_ROWS.

    IF LINES( LT_INDEX_ROWS ) > 0.
* Loop to append each selected Services into Package Service List
      LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW.

        READ TABLE GT_PCKSER_AFTER_MOD INDEX 1 INTO GS_PCKSER.
        CLEAR: GS_PCKSER.

        GS_PCKSER-PACKAGE_ID = GV_PACKAGE_ID.

        READ TABLE IT_SERVICE_0150 INDEX LS_INDEX_ROW INTO DATA(LS_SERVICE_0150).
        GS_PCKSER-SERVICE_ID = LS_SERVICE_0150-ID.
        GS_PCKSER-SERVICE_NAME = LS_SERVICE_0150-NAME.

        PERFORM CREATE_UUID_C36_STATIC CHANGING GS_PCKSER-ID.

        APPEND GS_PCKSER TO GT_PCKSER_AFTER_MOD .
      ENDLOOP.

    ELSE.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'at least one Service' DISPLAY LIKE 'E'.
    ENDIF.

    LEAVE TO SCREEN 0.

  ELSE.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'at least one Service' DISPLAY LIKE 'E'.

  ENDIF.
ENDFORM.


*PRODUCT LIST 0120 SUBROUTINES
*&---------------------------------------------------------------------*
*& Form SHOW_PRODUCT_0120_ALV
*&---------------------------------------------------------------------*
FORM SHOW_PRODUCT_0120_ALV .
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.

*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_PRO_0120_FIELD_CATALOG
            CHANGING LT_FIELD_CAT.

  "Prepare Layout
  PERFORM PREPARE_PRO_0120_LAYOUT
            CHANGING LS_LAYOUT.

** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_PRODUCT_0120_ALV_TABLE
            CHANGING LS_LAYOUT
                     "LS_VARIANT
                     LT_FIELD_CAT.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form PREPARE_PRODUCT_0127_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_PRO_0120_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_PRODUCT_0120_FCAT USING 'PRODUCT_CODE' 'Code'        12 '' 'X'  'C100'  CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0120_FCAT USING 'BRAND'        'Brand'       16 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PRODUCT_0120_FCAT USING 'PRODUCT_NAME' 'Name'        22 ''  ''  ''      CHANGING CH_T_FIELD_CAT.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form ADD_PRODUCT_0120_FCAT
*&---------------------------------------------------------------------*
FORM ADD_PRODUCT_0120_FCAT USING U_FIELDNAME
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
*& Form PREPARE_PRODUCT_0120_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_PRO_0120_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_PRODUCT_0120_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_PRODUCT_0120_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_PRODUCT_0120_CONTAINER IS INITIAL.
    O_PRODUCT_0120_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0120' ).
  ENDIF.

  IF O_PRODUCT_0120_ALV_TABLE IS INITIAL.
    O_PRODUCT_0120_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_PRODUCT_0120_CONTAINER ).
  ENDIF.

  O_PRODUCT_0120_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_PRODUCT_0120     " Output Table
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

  IF O_PRODUCT_0120_HANDLER IS INITIAL.
     O_PRODUCT_0120_HANDLER = NEW CL_PRODUCT_ALV_HANDLER( ).
     SET HANDLER O_PRODUCT_0120_HANDLER->HOTSPOT_CLICK FOR O_PRODUCT_0120_ALV_TABLE.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form HANDLE_ENTER_ON_SCREEN_0120
*&---------------------------------------------------------------------*
FORM HANDLE_ENTER_ON_SCREEN_0120 .
  IF O_PRODUCT_0120_ALV_TABLE IS NOT INITIAL.
    DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
    DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.

    CALL METHOD O_PRODUCT_0120_ALV_TABLE->GET_SELECTED_ROWS
      IMPORTING
        ET_INDEX_ROWS = LT_INDEX_ROWS.

    IF LINES( LT_INDEX_ROWS ) = 1.
      READ TABLE LT_INDEX_ROWS INDEX 1 INTO LS_INDEX_ROW.
      READ TABLE IT_PRODUCT_0120 INDEX LS_INDEX_ROW INTO DATA(LS_PRODUCT).

      PERFORM PROCESS_PREPARE_0130_DATA USING LS_PRODUCT-ID.

    ELSEIF LINES( LT_INDEX_ROWS ) = 0.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'one Product' DISPLAY LIKE 'E'.
    ELSEIF LINES( LT_INDEX_ROWS ) > 1.
      MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'only one Product' DISPLAY LIKE 'E'.
    ENDIF.

  ELSE.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'at leaset one Product' DISPLAY LIKE 'E'.

  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form PROCESS_PREPARE_0130_DATA
*&---------------------------------------------------------------------*
FORM PROCESS_PREPARE_0130_DATA USING U_PRODUCT_ID.

  CLEAR: IT_PROVRT_0130[].

  SELECT PROVRT~*, PRODCT~PRODUCT_NAME, PRODCT~PRODUCT_CODE
    FROM Y03S24999_PROVRT AS PROVRT
    LEFT JOIN Y03S24999_PRODCT AS PRODCT
    ON PRODCT~ID = PROVRT~PRODUCT_ID
    WHERE PROVRT~IS_DELETED <> @ABAP_TRUE
    AND PRODCT~ID = @U_PRODUCT_ID
    ORDER BY PROVRT~VARIANT_CODE DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @IT_PROVRT_0130.

  IF SY-SUBRC <> 0.
    CLEAR IT_PROVRT_0130[].

    IF O_PROVRT_0130_CONTAINER IS NOT INITIAL.
      CALL METHOD O_PROVRT_0130_CONTAINER->FREE.
      CLEAR O_PROVRT_0130_CONTAINER.
    ENDIF.
    IF O_PROVRT_0130_ALV_TABLE IS NOT INITIAL.
      CLEAR O_PROVRT_0130_ALV_TABLE.
    ENDIF.
    IF O_PROVRT_0130_HANDLER IS NOT INITIAL.
      CLEAR O_PROVRT_0130_HANDLER.
    ENDIF.

    MESSAGE S004(Z03S24999_DOMUS_MSGS) WITH 'Product Variant of this product' DISPLAY LIKE 'E'.
    RETURN.
  ENDIF.

  CALL SCREEN 0130 STARTING AT 15 06 ENDING AT 70 12.
  LEAVE TO SCREEN 0.

ENDFORM.

*PRODUCT VARIANT LIST 0130 SUBROUTINES
*&---------------------------------------------------------------------*
*& Form SHOW_PROVRT_0130_ALV
*&---------------------------------------------------------------------*
FORM SHOW_PROVRT_0130_ALV .
  DATA: LS_LAYOUT    TYPE LVC_S_LAYO,
        "LS_VARIANT TYPE DISVARIANT,
        LT_FIELD_CAT TYPE LVC_T_FCAT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_PRO_0130_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_PROVRT_0130_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_PROVRT_0130_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form PREPARE_PROVRT_0130_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_PRO_0130_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_PROVRT_0130_FCAT USING 'VARIANT_CODE'  'Variant'     6 ''  'X'  'C311'  CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0130_FCAT USING 'PRODUCT_CODE'  'Code'        10 ''  ''  ''      CHANGING CH_T_FIELD_CAT,
           ADD_PROVRT_0130_FCAT USING 'PRODUCT_NAME'  'Name'        20 ''  ''  ''      CHANGING CH_T_FIELD_CAT.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form ADD_PROVRT_0130_FCAT
*&---------------------------------------------------------------------*
FORM ADD_PROVRT_0130_FCAT USING U_FIELDNAME
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
*& Form PREPARE_PROVRT_0130_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_PROVRT_0130_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.
  CH_S_LAYOUT-SEL_MODE = 'A'.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_PROVRT_0130_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_PROVRT_0130_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_PROVRT_0130_CONTAINER IS INITIAL.
    O_PROVRT_0130_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0130' ).
  ENDIF.

  IF O_PROVRT_0130_ALV_TABLE IS INITIAL.
    O_PROVRT_0130_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_PROVRT_0130_CONTAINER ).
  ENDIF.

  O_PROVRT_0130_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_PROVRT_0130     " Output Table
      IT_FIELDCATALOG               = CH_T_FIELD_CAT   " Field Catalog
    EXCEPTIONS
      INVALID_PARAMETER_COMBINATION = 1                " Wrong Parameter
      PROGRAM_ERROR                 = 2                " Program Errors
      TOO_MANY_LINES                = 3                " Too many Rows in Ready for Input Grid
      OTHERS                        = 4
  ).

  IF O_PROVRT_0130_HANDLER IS INITIAL.
    O_PROVRT_0130_HANDLER = NEW CL_PACKAGE_PROVRT_ALV_HANDLER( ).
    SET HANDLER O_PROVRT_0130_HANDLER->HOTSPOT_CLICK FOR O_PROVRT_0130_ALV_TABLE.
  ENDIF.

  IF SY-SUBRC <> 0.
    MESSAGE E005(Z03S24999_DOMUS_MSGS).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0130
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0130 USING U_OKCODE.

  CASE U_OKCODE.

    WHEN 'ENTER_130'.
      PERFORM HANDLE_ENTER_ON_SCREEN_0130.
      CLEAR: U_OKCODE.
    WHEN 'CANCEL_130'.
      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form HANDLE_ENTER_ON_SCREEN_0130
*&---------------------------------------------------------------------*
FORM HANDLE_ENTER_ON_SCREEN_0130.
  IF O_PROVRT_0130_ALV_TABLE IS NOT INITIAL.

    DATA: LT_INDEX_ROWS TYPE LVC_T_ROW.
    DATA: LS_INDEX_ROW  TYPE LVC_S_ROW.

    CALL METHOD O_PROVRT_0130_ALV_TABLE->GET_SELECTED_ROWS
      IMPORTING
        ET_INDEX_ROWS = LT_INDEX_ROWS.

    IF LINES( LT_INDEX_ROWS ) > 0.
* Loop to append each selected Product Variant into Package Product Variant List
      LOOP AT LT_INDEX_ROWS INTO LS_INDEX_ROW.
        DATA: LV_IS_REPEATED TYPE ABAP_BOOL.
        READ TABLE IT_PROVRT_0130 INDEX LS_INDEX_ROW INTO DATA(LS_PROVRT_0130).

        LOOP AT GT_PCKPRV_AFTER_MOD INTO DATA(LS_TEMP).
          IF LS_TEMP-PRODUCT_VARIANT_ID = LS_PROVRT_0130-ID.
            LS_TEMP-QUANTITY += 1.
            MODIFY TABLE GT_PCKPRV_AFTER_MOD FROM LS_TEMP.

            LV_IS_REPEATED = ABAP_TRUE.
            EXIT.
          ENDIF.
        ENDLOOP.

        IF LV_IS_REPEATED <> ABAP_TRUE.
          READ TABLE GT_PCKPRV_AFTER_MOD INDEX 1 INTO GS_PCKPRV.
          CLEAR: GS_PCKPRV.

          GS_PCKPRV-PACKAGE_ID = GV_PACKAGE_ID.
          GS_PCKPRV-PRODUCT_VARIANT_ID = LS_PROVRT_0130-ID.
          GS_PCKPRV-VARIANT_CODE = LS_PROVRT_0130-VARIANT_CODE.
          GS_PCKPRV-PRODUCT_NAME = LS_PROVRT_0130-PRODUCT_NAME.
          GS_PCKPRV-QUANTITY = 1.

          PERFORM CREATE_UUID_C36_STATIC CHANGING GS_PCKPRV-ID.

          APPEND GS_PCKPRV TO GT_PCKPRV_AFTER_MOD.

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

*ATTRIBUTE VALUES LIST 0140 SUBROUTINES
*&---------------------------------------------------------------------*
*& Form SHOW_PROATV_0140_AVL
*&---------------------------------------------------------------------*
FORM SHOW_PROATV_0140_AVL .
  DATA: LT_FIELD_CAT TYPE LVC_T_FCAT,
        LS_LAYOUT    TYPE LVC_S_LAYO.
*        LS_VARIANT   TYPE DISVARIANT.

* Define Table Structure / Define fields catalog
  PERFORM PREPARE_PRO_0140_FIELD_CATALOG
    CHANGING LT_FIELD_CAT.

* Prepare Layout
  PERFORM PREPARE_PROATV_0140_LAYOUT
    CHANGING LS_LAYOUT.
** Prepare Variant
*  PERFORM PREPARE_VARIANT
*    CHANGING LS_VARIANT.

* Show ALV
  PERFORM DISPLAY_PROATV_0140_ALV_TABLE
    CHANGING LS_LAYOUT
*            LS_VARIANT
             LT_FIELD_CAT.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form PREPARE_PROATV_0140_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM PREPARE_PRO_0140_FIELD_CATALOG
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.

***** Full form:
  PERFORM: ADD_PROATV_0140_FCAT USING 'ATTRIBUTE_NAME' 'Attribute' 12 ''  'X' 'C500'  CHANGING CH_T_FIELD_CAT,
           ADD_PROATV_0140_FCAT USING 'VALUE'          'Value'     12 ''  ''  ''      CHANGING CH_T_FIELD_CAT.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form ADD_PROATV_0140_FCAT
*&---------------------------------------------------------------------*
FORM ADD_PROATV_0140_FCAT USING U_FIELDNAME
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
*& Form PREPARE_PROATV_0140_LAYOUT
*&---------------------------------------------------------------------*
FORM PREPARE_PROATV_0140_LAYOUT CHANGING CH_S_LAYOUT TYPE LVC_S_LAYO.

*  CH_S_LAYOUT-CWIDTH_OPT = ABAP_TRUE.
  CH_S_LAYOUT-ZEBRA = ABAP_TRUE.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY_PROATV_0140_ALV_TABLE
*&---------------------------------------------------------------------*
FORM DISPLAY_PROATV_0140_ALV_TABLE
  USING    U_S_LAYOUT    TYPE LVC_S_LAYO
  CHANGING CH_T_FIELD_CAT TYPE LVC_T_FCAT.
*          IM_S_VARIANT   TYPE DISVARIANT

  IF O_PROATV_0140_CONTAINER IS INITIAL.
    O_PROATV_0140_CONTAINER = NEW CL_GUI_CUSTOM_CONTAINER( CONTAINER_NAME = 'CUSTOM_CONTROL_ALV_0140' ).
  ENDIF.

  IF O_PROATV_0140_ALV_TABLE IS INITIAL.
    O_PROATV_0140_ALV_TABLE = NEW CL_GUI_ALV_GRID( I_PARENT = O_PROATV_0140_CONTAINER ).
  ENDIF.

  O_PROATV_0140_ALV_TABLE->SET_TABLE_FOR_FIRST_DISPLAY(
    EXPORTING
      IS_LAYOUT                     = U_S_LAYOUT      " Layout
*      I_SAVE                        = 'A'
*      IS_VARIANT                    = IM_S_VARIANT
    CHANGING
      IT_OUTTAB                     = IT_PROATV_0140     " Output Table
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
*& Form HANDLE_UCOMM_0140
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0140 USING U_OKCODE.
  CASE U_OKCODE.
    WHEN 'CANCEL_140'.
      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0120
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0120 USING U_OKCODE.

  CASE U_OKCODE.

    WHEN 'ENTER_120'.
      PERFORM HANDLE_ENTER_ON_SCREEN_0120.
      CLEAR: U_OKCODE.

    WHEN 'CANCEL_120'.
      CLEAR: U_OKCODE.
      LEAVE TO SCREEN 0.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form HANDLE_UCOMM_0160
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GV_OKCODE
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_0160 USING U_OKCODE.
  CASE U_OKCODE.
     WHEN 'BACK_TO_PAGCKAGE_LIS'.
      PERFORM PROCESS_BACK_TO_PACKAGE_LIST.
      CLEAR: U_OKCODE.

    WHEN 'REQUEST_QUOTATION'.
      PERFORM WARNING_CREATE_NORMAL_QUO.
      "PERFORM CREATE_QUOTATION USING 'DEFAULT'.
      CLEAR: U_OKCODE.

    WHEN 'CUSTOMIZE_PACKAGE'.
      PERFORM CUSTOMIZE_PACKAGE.
      CLEAR: U_OKCODE.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form PROCESS_BACK_TO_PACKAGE_LIST
*&---------------------------------------------------------------------*
FORM PROCESS_BACK_TO_PACKAGE_LIST .
  LEAVE TO SCREEN 0.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form CUSTOMIZE_PACKAGE
*&---------------------------------------------------------------------*
FORM CUSTOMIZE_PACKAGE.
  GT_PCKSER_AFTER_MOD = GT_PCKSER.
  GT_PCKPRV_AFTER_MOD = GT_PCKPRV.
  CALL SCREEN 0170 STARTING AT 15 06.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form HANDLE_COMMAND_0170
*&---------------------------------------------------------------------*
FORM HANDLE_COMMAND_0170  USING U_OKCODE.
 CASE U_OKCODE.
   WHEN 'INSERT_PCKPRV'.
      PERFORM PROCESS_INSERT_PCKPRV.
      CLEAR: U_OKCODE.

    WHEN 'DELETE_PCKPRV'.
      PERFORM DELETE_SELECTED_PCKPRVS.
      CLEAR: U_OKCODE.

    WHEN 'INSERT_PCKSER'.
      PERFORM PROCESS_INSERT_PCKSER.
      CLEAR: U_OKCODE.

    WHEN 'DELETE_PCKSER'.
      PERFORM DELETE_SELECTED_PCKSERS.
      CLEAR: U_OKCODE.

     WHEN 'CANCEL_CUSTOMIZATION'.
      PERFORM WARNING_CANCEL_CUSTOMIZE.
      CLEAR: U_OKCODE.
      "LEAVE TO SCREEN 0.

    WHEN 'REQUEST_QUOTATION'.
      "PERFORM CREATE_QUOTATION USING 'CUSTOMIZE'.
      PERFORM WARNING_CREATE_CUSTOM_QUO.
      CLEAR: U_OKCODE.

    WHEN OTHERS.
  ENDCASE.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form PROCESS_INSERT_PCKPRV
*&---------------------------------------------------------------------*
FORM PROCESS_INSERT_PCKPRV .
 DATA: LV_SUCCESS TYPE ABAP_BOOL.
* Get data from PRODUCT_0127 table
  PERFORM GET_PRODUCT_0120_DATA CHANGING LV_SUCCESS.
  IF LV_SUCCESS = ABAP_FALSE.
    RETURN.
  ENDIF.
  CALL SCREEN 0120 STARTING AT 10 08 ENDING AT 70 20.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form GET_PRODUCT_0120_DATA
*&---------------------------------------------------------------------*
FORM GET_PRODUCT_0120_DATA CHANGING CH_V_SUCCESS TYPE ABAP_BOOL.
  CLEAR: IT_PRODUCT_0120[], CH_V_SUCCESS.

  SELECT P~*
    FROM Y03S24999_PRODCT AS P
    LEFT JOIN @GT_PCKPRV AS GP
    ON P~ID = GP~PRODUCT_ID
    WHERE P~IS_DELETED <> @ABAP_TRUE
    AND GP~PRODUCT_ID IS NULL
    ORDER BY P~UPDATED_ON DESCENDING, P~UPDATED_ON DESCENDING, P~PRODUCT_CODE
    INTO CORRESPONDING FIELDS OF TABLE @IT_PRODUCT_0120.

  IF SY-SUBRC <> 0.
    CLEAR IT_PRODUCT_0120[].

    IF O_PRODUCT_0120_CONTAINER IS NOT INITIAL.
      CALL METHOD O_PRODUCT_0120_CONTAINER->FREE.
      CLEAR O_PRODUCT_0120_CONTAINER.
    ENDIF.
    IF O_PRODUCT_0120_ALV_TABLE IS NOT INITIAL.
      CLEAR O_PRODUCT_0120_ALV_TABLE.
    ENDIF.

    MESSAGE S000(Z03S24999_DOMUS_MSGS) WITH 'All products were selected!' DISPLAY LIKE 'E'.
    CH_V_SUCCESS = ABAP_FALSE.
  ELSE.
    CH_V_SUCCESS = ABAP_TRUE.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form PROCESS_INSERT_PCKSER
*&---------------------------------------------------------------------*
FORM PROCESS_INSERT_PCKSER .
 DATA: LV_SUCCESS TYPE ABAP_BOOL.
* Get data from PRODUCT_0150 table
  PERFORM GET_SERVICE_0150_DATA CHANGING LV_SUCCESS.
  IF LV_SUCCESS = ABAP_FALSE.
    RETURN.
  ENDIF.
  CALL SCREEN 0150 STARTING AT 10 08 ENDING AT 70 20.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form GET_SERVICE_0150_DATA
*&---------------------------------------------------------------------*
FORM GET_SERVICE_0150_DATA CHANGING CH_V_SUCCESS TYPE ABAP_BOOL.
  CLEAR: IT_SERVICE_0150[], CH_V_SUCCESS.

  SELECT S~*
    FROM Y03S24999_SERVCE AS S
    LEFT JOIN @GT_PCKSER AS GS
    ON S~ID = GS~SERVICE_ID
    WHERE S~IS_DELETED <> @ABAP_TRUE
    AND GS~SERVICE_ID IS NULL
    ORDER BY S~CREATED_ON DESCENDING, S~CREATED_AT DESCENDING
    INTO CORRESPONDING FIELDS OF TABLE @IT_SERVICE_0150.

  IF SY-SUBRC <> 0.
    CLEAR IT_SERVICE_0150[].

    IF O_SERVICE_0150_CONTAINER IS NOT INITIAL.
      CALL METHOD O_SERVICE_0150_CONTAINER->FREE.
      CLEAR O_SERVICE_0150_CONTAINER.
    ENDIF.
    IF O_SERVICE_0150_ALV_TABLE IS NOT INITIAL.
      CLEAR O_SERVICE_0150_ALV_TABLE.
    ENDIF.

    MESSAGE S000(Z03S24999_DOMUS_MSGS) WITH 'All services were selected!' DISPLAY LIKE 'E'.
    CH_V_SUCCESS = ABAP_FALSE.
  ELSE.
    CH_V_SUCCESS = ABAP_TRUE.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DELETE_SELECTED_PCKPRVS
*&---------------------------------------------------------------------*
FORM DELETE_SELECTED_PCKPRVS.
  DATA: LD_SEL_PCKPRVS LIKE GT_PCKPRV.
  LOOP AT GT_PCKPRV INTO DATA(LS_PI).
    IF LS_PI-SEL = 'X'.
      APPEND LS_PI TO LD_SEL_PCKPRVS.
    ENDIF.
  ENDLOOP.

  IF LINES( LD_SEL_PCKPRVS ) = 0.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'a Product Variant for deletion' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSEIF LINES( LD_SEL_PCKPRVS ) > 1.
    PERFORM WARNING_MULTI_SELECTED_PCKPRV TABLES LD_SEL_PCKPRVS.

  ELSEIF LINES( LD_SEL_PCKPRVS ) = 1.
    PERFORM HANDLE_PCKPRV_FINAL_DELETION TABLES LD_SEL_PCKPRVS.

  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form WARNING_MULTI_SELECTED_PCKPRV
*&---------------------------------------------------------------------*
FORM WARNING_MULTI_SELECTED_PCKPRV TABLES U_ITAB LIKE GT_PCKPRV.
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
    PERFORM HANDLE_PCKPRV_FINAL_DELETION TABLES U_ITAB.

  ELSEIF LD_CHOICE = '2'.

  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form HANDLE_PCKPRV_FINAL_DELETION
*&---------------------------------------------------------------------*
FORM HANDLE_PCKPRV_FINAL_DELETION TABLES U_ITAB LIKE GT_PCKPRV.
  LOOP AT U_ITAB INTO DATA(S_ROW).

    DELETE TABLE GT_PCKPRV FROM S_ROW.

    IF SY-SUBRC <> 0.
      MESSAGE E000(Z03S24999_DOMUS_MSGS) WITH 'One deleting Product in Package has caused an error!'.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form DELETE_SELECTED_PCKSERS
*&---------------------------------------------------------------------*
FORM DELETE_SELECTED_PCKSERS .

DATA: LD_SEL_PCKSERS LIKE GT_PCKSER.
  LOOP AT GT_PCKSER INTO DATA(LS_PI).
    IF LS_PI-SEL = 'X'.
      APPEND LS_PI TO LD_SEL_PCKSERS.
    ENDIF.
  ENDLOOP.

  IF LINES( LD_SEL_PCKSERS ) = 0.
    MESSAGE S008(Z03S24999_DOMUS_MSGS) WITH 'a Service for deletion' DISPLAY LIKE 'E'.
    LEAVE LIST-PROCESSING.
  ELSEIF LINES( LD_SEL_PCKSERS ) > 1.
    PERFORM WARNING_MULTI_SELECTED_PCKSER TABLES LD_SEL_PCKSERS.

  ELSEIF LINES( LD_SEL_PCKSERS ) = 1.
    PERFORM HANDLE_PCKSER_FINAL_DELETION TABLES LD_SEL_PCKSERS.

  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form WARNING_MULTI_SELECTED_PCKSER
*&---------------------------------------------------------------------*
FORM WARNING_MULTI_SELECTED_PCKSER TABLES U_ITAB LIKE GT_PCKSER.
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
    PERFORM HANDLE_PCKSER_FINAL_DELETION TABLES U_ITAB.

  ELSEIF LD_CHOICE = '2'.

  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form HANDLE_PCKSER_FINAL_DELETION
*&---------------------------------------------------------------------*
FORM HANDLE_PCKSER_FINAL_DELETION TABLES U_ITAB LIKE GT_PCKSER.
  LOOP AT U_ITAB INTO DATA(S_ROW).

    DELETE TABLE GT_PCKSER FROM S_ROW.

    IF SY-SUBRC <> 0.
      MESSAGE E000(Z03S24999_DOMUS_MSGS) WITH 'One deleting Service in Package has caused an error!'.
    ENDIF.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form CREATE_QUOTATION
*&---------------------------------------------------------------------*
FORM CREATE_QUOTATION USING U_TYPE TYPE STRING.

  DATA: LV_QUOTATION TYPE Y03S24999_QUOTA.

  PERFORM CREATE_UUID_C36_STATIC CHANGING LV_QUOTATION-ID.

  "Autoincrement the counter buffer for Quotation Code
  PERFORM AUTO_GENERATE_QUOTATION_CODE CHANGING LV_QUOTATION-QUOTATION_CODE.

  "Append the Q to the beginning of the quotation code
  CONCATENATE 'Q' LV_QUOTATION-QUOTATION_CODE INTO LV_QUOTATION-QUOTATION_CODE.

  LV_QUOTATION-PACKAGE_ID = GS_PACKAGE_DETAIL-ID.
  LV_QUOTATION-CUSTOMER = SY-UNAME.
  LV_QUOTATION-STATUS = 'Requested'.
  LV_QUOTATION-EXPIRED_ON = SY-DATUM + 30. "30 days later than date of creation
  LV_QUOTATION-EXPIRED_AT = SY-UZEIT.
  LV_QUOTATION-CREATED_BY = SY-UNAME.
  LV_QUOTATION-CREATED_AT = SY-UZEIT + ( 3600 * 5 ).
  LV_QUOTATION-CREATED_ON = SY-DATUM.

  "INSERTION
  INSERT Y03S24999_QUOTA FROM LV_QUOTATION.

  IF SY-SUBRC <> 0.
    MESSAGE E015(Z03S24999_DOMUS_MSGS) WITH 'Quotation'.
  ELSE.
    "Create the first (index = 1) Quotation Version for the newly created Quotation
    DATA: LV_QUOVER TYPE Y03S24999_QUOVER.

    PERFORM CREATE_UUID_C36_STATIC CHANGING LV_QUOVER-ID.

    LV_QUOVER-QUOTATION_ID = LV_QUOTATION-ID.
    LV_QUOVER-VERSION_ORDER = 1. "The Fisrt Quotation Version
    LV_QUOVER-CREATED_BY = SY-UNAME.
    LV_QUOVER-CREATED_AT = SY-UZEIT + ( 3600 * 5 ).
    LV_QUOVER-CREATED_ON = SY-DATUM.

    INSERT Y03S24999_QUOVER FROM LV_QUOVER.

    IF SY-SUBRC <> 0.
      MESSAGE S018(Z03S24999_DOMUS_MSGS) WITH 'Quotation Version' DISPLAY LIKE 'E'.
    ELSE.

      MESSAGE I023(Z03S24999_DOMUS_MSGS) WITH 'Quotation' LV_QUOTATION-QUOTATION_CODE.
      "Create Product Variant and Service for Quotation Service.
      PERFORM CREATE_QUOVER_OBJECTS USING U_TYPE LV_QUOVER-ID.
    ENDIF.

*
*    MESSAGE I023(Z03S24999_DOMUS_MSGS) WITH 'Quotation' LV_QUOTATION-QUOTATION_CODE.
*    MESSAGE S023(Z03S24999_DOMUS_MSGS) WITH 'Quotation' LV_QUOTATION-QUOTATION_CODE.

    LEAVE TO SCREEN 0.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& CREATE_QUOVER_OBJECTS
*&---------------------------------------------------------------------*
FORM CREATE_QUOVER_OBJECTS USING U_TYPE TYPE STRING
                                 U_QUOVER_ID TYPE Y03S24999_QUOVER-ID.
  DATA: LS_PCKPRV TYPE TY_PCKPRV,
        LS_PCKSER TYPE TY_PCKSER,
        LV_QVPRV TYPE Y03S24999_QVSPRV,
        LV_QVSSER TYPE Y03S24999_QVSSER.

  CASE U_TYPE.
    WHEN 'DEFAULT'.
      LOOP AT GT_PCKPRV INTO LS_PCKPRV.

        PERFORM CREATE_UUID_C36_STATIC CHANGING LV_QVPRV-ID.

        LV_QVPRV-PRODUCT_VARIANT_ID = LS_PCKPRV-PRODUCT_VARIANT_ID.
        LV_QVPRV-QUOTATION_VERSION_ID = U_QUOVER_ID.
        LV_QVPRV-QUANTITY = LS_PCKPRV-QUANTITY.
        LV_QVPRV-PRICE = LS_PCKPRV-DISPLAY_PRICE.
        LV_QVPRV-CREATED_BY = SY-UNAME.
        LV_QVPRV-CREATED_AT = SY-UZEIT + ( 3600 * 5 ).
        LV_QVPRV-CREATED_ON = SY-DATUM.

        "INSERTION
        INSERT Y03S24999_QVSPRV FROM LV_QVPRV.

        IF SY-SUBRC <> 0.
          MESSAGE S018(Z03S24999_DOMUS_MSGS) WITH 'Quotation Version Product Variant' DISPLAY LIKE 'E'.
        ENDIF.

      ENDLOOP.

      LOOP AT GT_PCKSER INTO LS_PCKSER.

        PERFORM CREATE_UUID_C36_STATIC CHANGING LV_QVSSER-ID.

        LV_QVSSER-SERVICE_ID = LS_PCKSER-SERVICE_ID.
        LV_QVSSER-QUOTATION_VERSION_ID = U_QUOVER_ID.
        LV_QVSSER-PRICE = LS_PCKSER-DISPLAY_PRICE.
        LV_QVSSER-CREATED_BY = SY-UNAME.
        LV_QVSSER-CREATED_AT = SY-UZEIT + ( 3600 * 5 ).
        LV_QVSSER-CREATED_ON = SY-DATUM.

        "INSERTION
        INSERT Y03S24999_QVSSER FROM LV_QVSSER.

        IF SY-SUBRC <> 0.
          MESSAGE S018(Z03S24999_DOMUS_MSGS) WITH 'Quotation Version Service' DISPLAY LIKE 'E'.
        ENDIF.

      ENDLOOP.

    WHEN 'CUSTOMIZE'.
      LOOP AT GT_PCKPRV_AFTER_MOD INTO LS_PCKPRV.

        PERFORM CREATE_UUID_C36_STATIC CHANGING LV_QVPRV-ID.

        LV_QVPRV-PRODUCT_VARIANT_ID = LS_PCKPRV-PRODUCT_VARIANT_ID.
        LV_QVPRV-QUOTATION_VERSION_ID = U_QUOVER_ID.
        LV_QVPRV-QUANTITY = LS_PCKPRV-QUANTITY.
        LV_QVPRV-PRICE = LS_PCKPRV-DISPLAY_PRICE.
        LV_QVPRV-CREATED_BY = SY-UNAME.
        LV_QVPRV-CREATED_AT = SY-UZEIT + ( 3600 * 5 ).
        LV_QVPRV-CREATED_ON = SY-DATUM.

        "INSERTION
        INSERT Y03S24999_QVSPRV FROM LV_QVPRV.

        IF SY-SUBRC <> 0.
          MESSAGE S018(Z03S24999_DOMUS_MSGS) WITH 'Quotation Version Product Variant' DISPLAY LIKE 'E'.
        ENDIF.
      ENDLOOP.

      LOOP AT GT_PCKSER_AFTER_MOD INTO LS_PCKSER.

        PERFORM CREATE_UUID_C36_STATIC CHANGING LV_QVSSER-ID.

        LV_QVSSER-SERVICE_ID = LS_PCKSER-SERVICE_ID.
        LV_QVSSER-QUOTATION_VERSION_ID = U_QUOVER_ID.
        LV_QVSSER-PRICE = LS_PCKSER-DISPLAY_PRICE.
        LV_QVSSER-CREATED_BY = SY-UNAME.
        LV_QVSSER-CREATED_AT = SY-UZEIT + ( 3600 * 5 ).
        LV_QVSSER-CREATED_ON = SY-DATUM.

        "INSERTION
        INSERT Y03S24999_QVSSER FROM LV_QVSSER.

        IF SY-SUBRC <> 0.
          MESSAGE S018(Z03S24999_DOMUS_MSGS) WITH 'Quotation Version Service' DISPLAY LIKE 'E'.
        ENDIF.

      ENDLOOP.
  ENDCASE.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form WARNING_CANCEL_CUSTOMIZE
*&---------------------------------------------------------------------*
FORM WARNING_CANCEL_CUSTOMIZE.
  DATA: LD_CHOICE TYPE C.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      TEXT_QUESTION         = 'Your customization will be lost!'
      TEXT_BUTTON_1         = 'Yes'(001)
      TEXT_BUTTON_2         = 'No'(002)
      DISPLAY_CANCEL_BUTTON = ''
    IMPORTING
      ANSWER                = LD_CHOICE.
  IF LD_CHOICE = '1'.
    LEAVE TO SCREEN 0.

  ELSEIF LD_CHOICE = '2'.

  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form WARNING_CREATE_NORMAL_QUO
*&---------------------------------------------------------------------*
FORM WARNING_CREATE_NORMAL_QUO.
  DATA: LD_CHOICE TYPE C.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      TEXT_QUESTION         = 'Do you want to create a Quotation based on this Package?'
      TEXT_BUTTON_1         = 'Yes'(001)
      TEXT_BUTTON_2         = 'No'(002)
      DISPLAY_CANCEL_BUTTON = ''
    IMPORTING
      ANSWER                = LD_CHOICE.
  IF LD_CHOICE = '1'.
    PERFORM CREATE_QUOTATION USING 'DEFAULT'.

  ELSEIF LD_CHOICE = '2'.

  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*& Form WARNING_CREATE_CUSTOM_QUO
*&---------------------------------------------------------------------*
FORM WARNING_CREATE_CUSTOM_QUO.
  DATA: LD_CHOICE TYPE C.

  CALL FUNCTION 'POPUP_TO_CONFIRM'
    EXPORTING
      TEXT_QUESTION         = 'Do you want to create a Quotation of your own customization?'
      TEXT_BUTTON_1         = 'Yes'(001)
      TEXT_BUTTON_2         = 'No'(002)
      DISPLAY_CANCEL_BUTTON = ''
    IMPORTING
      ANSWER                = LD_CHOICE.
  IF LD_CHOICE = '1'.
    PERFORM CREATE_QUOTATION USING 'CUSTOMIZE'.

  ELSEIF LD_CHOICE = '2'.

  ENDIF.
ENDFORM.


*###########QUOTATIONS
*&---------------------------------------------------------------------*
*& Form AUTO_GENERATE_QUOTATION__CODE
*&---------------------------------------------------------------------*
FORM AUTO_GENERATE_QUOTATION_CODE CHANGING U_CODE.
  CALL FUNCTION 'NUMBER_GET_NEXT'
    EXPORTING
      NR_RANGE_NR             = '1'
      OBJECT                  = 'Z03G03_QUO'
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
    MESSAGE E021(Z03S24999_DOMUS_MSGS) WITH 'Quotation Code'.
  ENDIF.
ENDFORM.

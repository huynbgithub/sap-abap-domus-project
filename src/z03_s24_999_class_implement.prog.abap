*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_CLASS_IMPLEMENT
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* CL_QUOTATION_ALV_HANDLER IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS CL_QUOTATION_ALV_HANDLER IMPLEMENTATION.

  METHOD HOTSPOT_CLICK.

    READ TABLE IT_QUOTATION INTO DATA(LS_QUOTATION)
      INDEX E_ROW_ID-INDEX.

    MESSAGE I007(Z03S24999_DOMUS_MSGS) WITH LS_QUOTATION-QUOTATION_CODE.

  ENDMETHOD.

ENDCLASS.
*---------------------------------------------------------------------*
* CL_PACKAGE_ALV_HANDLER IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS CL_PACKAGE_ALV_HANDLER IMPLEMENTATION.

  METHOD HOTSPOT_CLICK.
    READ TABLE IT_PACKAGE INTO DATA(LS_PACKAGE)
      INDEX E_ROW_ID-INDEX.

    GV_PACKAGE_ID = LS_PACKAGE-ID.
    PERFORM PREPARE_PACKAGE_DETAIL USING GV_PACKAGE_ID.
    LEAVE TO SCREEN 0100.

  ENDMETHOD.

ENDCLASS.
*---------------------------------------------------------------------*
* CL_PACKAGE_PROVRT_ALV_HANDLER IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS CL_PACKAGE_PROVRT_ALV_HANDLER IMPLEMENTATION.

  METHOD HOTSPOT_CLICK.
    READ TABLE IT_PROVRT_0126 INTO DATA(LS_PROVRT_0126)
      INDEX E_ROW_ID-INDEX.

    PERFORM PREPARE_PACKAGE_PROATV_0125 USING LS_PROVRT_0126-ID.
    CALL SCREEN 0125 STARTING AT 15 06 ENDING AT 45 12.

  ENDMETHOD.

ENDCLASS.
*---------------------------------------------------------------------*
* CL_QUOTATION_PROVRT_ALV_HANDLER IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS CL_QUOTA_PROVRT_ALV_HANDLER IMPLEMENTATION.

  METHOD HOTSPOT_CLICK.
    READ TABLE IT_PROVRT_0136 INTO DATA(LS_PROVRT_0136)
      INDEX E_ROW_ID-INDEX.

    PERFORM PREPARE_QUOTATION_PROATV_0135 USING LS_PROVRT_0136-ID.
    CALL SCREEN 0135 STARTING AT 15 06 ENDING AT 45 12.

  ENDMETHOD.

ENDCLASS.
************************************************************************
* CLASS   c_event_receiver
* IMPLEMENTATION
************************************************************************
CLASS C_EVENT_RECEIVER IMPLEMENTATION.

************************************************************************
* CLASS   c_event_receiver
* METHOD  event_handler_picture_dblclick
************************************************************************
  METHOD EVENT_HANDLER_PICTURE_DBLCLICK.
*        for event picture_dblclick of c_picture_control
*        importing mouse_pos_x mouse_pos_y.
    DATA POS_X(5) TYPE C.
    DATA POS_Y(5) TYPE C.
    POS_X = MOUSE_POS_X.
    POS_Y = MOUSE_POS_Y.

    IF SENDER = PCKIMG_CONTROL.
      MESSAGE I000(0K) WITH
        'Double Click' 'Upper Picture' POS_X POS_Y.         "#EC NOTEXT
    ELSE.
      MESSAGE I000(0K) WITH
        'Double Click' 'Lower Picture' POS_X POS_Y.         "#EC NOTEXT
    ENDIF.
  ENDMETHOD.
ENDCLASS.

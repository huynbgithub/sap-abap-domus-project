*----------------------------------------------------------------------*
***INCLUDE Z03_S24_CUST_PACKAGE_CLASS_IMP.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Class (Implementation) CL_PACKAGE_ALV_HANDLER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS CL_PACKAGE_ALV_HANDLER IMPLEMENTATION.
    METHOD HOTSPOT_CLICK.
      READ TABLE IT_PACKAGE INTO DATA(LS_PACKAGE)
        INDEX E_ROW_ID-INDEX.

      GV_PACKAGE_ID = LS_PACKAGE-ID.
      PERFORM PREPARE_PACKAGE_DETAIL USING GV_PACKAGE_ID.
      CALL SCREEN 0160.
    ENDMETHOD.
ENDCLASS.

*---------------------------------------------------------------------*
* CL_PACKAGE_PROVRT_ALV_HANDLER IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS CL_PACKAGE_PROVRT_ALV_HANDLER IMPLEMENTATION.

  METHOD HOTSPOT_CLICK.
    READ TABLE IT_PROVRT_0130 INTO DATA(LS_PROVRT_0130)
      INDEX E_ROW_ID-INDEX.

    PERFORM PREPARE_PACKAGE_PROATV_0140 USING LS_PROVRT_0130-ID.
    CALL SCREEN 0140 STARTING AT 15 06 ENDING AT 45 12.

  ENDMETHOD.

ENDCLASS.
*&---------------------------------------------------------------------*
*& Class (Implementation) C_EVENT_RECEIVER
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
CLASS C_EVENT_RECEIVER IMPLEMENTATION.
  METHOD EVENT_HANDLER_PICTURE_DBLCLICK.
*       for event picture_dblclick of c_picture_control
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

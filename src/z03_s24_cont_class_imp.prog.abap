*&---------------------------------------------------------------------*
*& Include          Z03_S24_CONT_CLASS_IMP
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* CL_CONTRACT_ALV_HANDLER IMPLEMENTATION
*---------------------------------------------------------------------*
CLASS CL_CONTRACT_ALV_HANDLER IMPLEMENTATION.

  METHOD HOTSPOT_CLICK.

    READ TABLE IT_CONTRACT INTO DATA(LS_CONTRACT)
      INDEX E_ROW_ID-INDEX.

    MESSAGE I007(Z03S24999_DOMUS_MSGS) WITH LS_CONTRACT-CONTRACT_CODE.

  ENDMETHOD.

ENDCLASS.
************************************************************************
* CLASS   c_event_receiver_ctr
* IMPLEMENTATION
************************************************************************
CLASS C_EVENT_RECEIVER_CTR IMPLEMENTATION.

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

    IF SENDER = CTRIMG_CONTROL.
      MESSAGE I000(0K) WITH
        'Double Click' 'Upper Picture' POS_X POS_Y.         "#EC NOTEXT
    ELSE.
      MESSAGE I000(0K) WITH
        'Double Click' 'Lower Picture' POS_X POS_Y.         "#EC NOTEXT
    ENDIF.
  ENDMETHOD.
ENDCLASS.

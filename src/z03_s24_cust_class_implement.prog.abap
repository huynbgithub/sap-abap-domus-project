*&---------------------------------------------------------------------*
*& Include          Z03_S24_CUST_CLASS_IMPLEMENT
*&---------------------------------------------------------------------*
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

    IF SENDER = QUOPCKIMG_CONTROL.
      MESSAGE I000(0K) WITH
        'Double Click' 'Upper Picture' POS_X POS_Y.         "#EC NOTEXT
    ELSE.
      MESSAGE I000(0K) WITH
        'Double Click' 'Lower Picture' POS_X POS_Y.         "#EC NOTEXT
    ENDIF.
  ENDMETHOD.
ENDCLASS.

*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DOMUS_STAFF_TOP
*&---------------------------------------------------------------------*

*---------------------------------------------------------------------*
* TYPE Declaration
*---------------------------------------------------------------------*

*---------------------------------------------------------------------*
* CLASS Declaration
*---------------------------------------------------------------------*
* CLASS C_EVENT_RECEIVER
* DEFINITION
CLASS C_EVENT_RECEIVER DEFINITION.
  " The class is used to test the events raised by the cl_gui_pictureclass
  PUBLIC SECTION.
    METHODS EVENT_HANDLER_PICTURE_DBLCLICK
      FOR EVENT PICTURE_DBLCLICK OF CL_GUI_PICTURE
      IMPORTING MOUSE_POS_X MOUSE_POS_Y SENDER.
ENDCLASS.
*---------------------------------------------------------------------*
* DATA Declaration
*---------------------------------------------------------------------*
DATA: GV_USERNAME TYPE Y03S24999_USER-USERNAME.
DATA: GV_OKCODE TYPE SYST-UCOMM.
DATA: GV_VALIDATION_BYPASSED TYPE ABAP_BOOL.

*&SPWIZARD: FUNCTION CODES FOR TABSTRIP 'ZTAB_001'
CONSTANTS: BEGIN OF C_ZTAB_001,
             TAB1 LIKE SY-UCOMM VALUE 'ZTAB_001_FC1',
             TAB2 LIKE SY-UCOMM VALUE 'ZTAB_001_FC2',
             TAB3 LIKE SY-UCOMM VALUE 'ZTAB_001_FC3',
             TAB4 LIKE SY-UCOMM VALUE 'ZTAB_001_FC4',
             TAB5 LIKE SY-UCOMM VALUE 'ZTAB_001_FC5',
           END OF C_ZTAB_001.
*&SPWIZARD: DATA FOR TABSTRIP 'ZTAB_001'
CONTROLS:  ZTAB_001 TYPE TABSTRIP.
DATA:      BEGIN OF G_ZTAB_001,
             SUBSCREEN   LIKE SY-DYNNR,
             PROG        LIKE SY-REPID VALUE 'Z03_S24_999_DOMUS_STAFF',
             PRESSED_TAB LIKE SY-UCOMM VALUE C_ZTAB_001-TAB1,
           END OF G_ZTAB_001.

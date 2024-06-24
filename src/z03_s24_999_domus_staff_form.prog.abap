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
  IF IN_OKCODE = 'CFM' OR IN_OKCODE = 'ENTER'.

    DATA: LV_IS_STAFF TYPE YS03S24999_ROLES-IS_STAFF.

    IF IN_USERNAME = SY-UNAME.

      SELECT SINGLE IS_STAFF FROM Y03S24999_USER
        WHERE USERNAME = @IN_USERNAME
        INTO @LV_IS_STAFF.

      IF SY-SUBRC = 0.
        IF LV_IS_STAFF = ABAP_TRUE.
          MESSAGE 'Welcome Staff!' TYPE 'S'.
          CALL SCREEN 100.
        ELSE.
          MESSAGE |You ({ IN_USERNAME }) are not Staff!| TYPE 'S' DISPLAY LIKE 'E'.
        ENDIF.
      ELSE.
        MESSAGE |You ({ IN_USERNAME }) are not Staff!| TYPE 'S' DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
      MESSAGE |Please enter YOUR username as DEV-###.| TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.

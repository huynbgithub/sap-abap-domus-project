*&---------------------------------------------------------------------*
*& Include          Z03_S24_CUST_FORM
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form HANDLE_EXIT_COMMAND
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
*&      --> U_OKCODE
*&      --> U_USERNAME
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_1000 USING U_OKCODE U_USERNAME.
  IF U_OKCODE = 'CFM'.

    DATA: LV_IS_STAFF TYPE YS03S24999_ROLES-IS_STAFF.
    IF U_USERNAME = SY-UNAME.
      SELECT SINGLE IS_STAFF FROM Y03S24999_USER
        WHERE USERNAME = @U_USERNAME
        INTO @LV_IS_STAFF.

      IF SY-SUBRC = 0.
        IF LV_IS_STAFF = ABAP_TRUE.
          MESSAGE 'Test message' TYPE 'S'.
          CALL SCREEN 100.
        ELSE.
          MESSAGE S002(Z03S24999_DOMUS_MSGS) WITH U_USERNAME DISPLAY LIKE 'E'.
        ENDIF.
      ELSE.
        MESSAGE S002(Z03S24999_DOMUS_MSGS) WITH U_USERNAME DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
      MESSAGE S003(Z03S24999_DOMUS_MSGS) DISPLAY LIKE 'E'.
    ENDIF.

    CLEAR: U_OKCODE.
  ENDIF.
ENDFORM.

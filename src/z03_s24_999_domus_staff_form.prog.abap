*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DOMUS_STAFF_FORM
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form CREATE_UUID_C36_STATIC
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- CH_ID
*&---------------------------------------------------------------------*
FORM CREATE_UUID_C36_STATIC CHANGING CH_ID.
  TRY.
      CALL METHOD CL_SYSTEM_UUID=>CREATE_UUID_C36_STATIC
        RECEIVING
          UUID = CH_ID.
    CATCH CX_UUID_ERROR.
  ENDTRY.
ENDFORM.
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
*&      --> U_OKCODE
*&      --> U_USERNAME
*&---------------------------------------------------------------------*
FORM HANDLE_UCOMM_1000  USING    U_OKCODE
                                 U_USERNAME.
  IF U_OKCODE = 'CFM'.

    DATA: LV_IS_STAFF TYPE YS03S24999_ROLES-IS_STAFF.

    IF U_USERNAME = SY-UNAME.

      SELECT SINGLE IS_STAFF FROM Y03S24999_USER
        WHERE USERNAME = @U_USERNAME
        INTO @LV_IS_STAFF.

      IF SY-SUBRC = 0.
        IF LV_IS_STAFF = ABAP_TRUE.
          MESSAGE S001(Z03S24999_DOMUS_MSGS).
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

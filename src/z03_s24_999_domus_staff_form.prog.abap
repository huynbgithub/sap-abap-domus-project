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
      IF O_QUOTATION_CONTAINER IS NOT INITIAL.
        CALL METHOD O_QUOTATION_CONTAINER->FREE.
        CLEAR O_QUOTATION_CONTAINER.
      ENDIF.
      IF O_QUOTATION_ALV_TABLE IS NOT INITIAL.
        FREE O_QUOTATION_ALV_TABLE.
        CLEAR O_QUOTATION_ALV_TABLE.
      ENDIF.
      IF P_QCODE IS NOT INITIAL.
        FREE P_QCODE.
        CLEAR P_QCODE.
      ENDIF.
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
  IF IN_OKCODE = 'CFM'.

    DATA: LV_IS_STAFF TYPE YS03S24999_ROLES-IS_STAFF.

    IF IN_USERNAME = SY-UNAME.

      SELECT SINGLE IS_STAFF FROM Y03S24999_USER
        WHERE USERNAME = @IN_USERNAME
        INTO @LV_IS_STAFF.

      IF SY-SUBRC = 0.
        IF LV_IS_STAFF = ABAP_TRUE.
          MESSAGE S001(Z03S24999_DOMUS_MSGS).
          CALL SCREEN 100.
        ELSE.
          MESSAGE S002(Z03S24999_DOMUS_MSGS) WITH IN_USERNAME DISPLAY LIKE 'E'.
        ENDIF.
      ELSE.
        MESSAGE S002(Z03S24999_DOMUS_MSGS) WITH IN_USERNAME DISPLAY LIKE 'E'.
      ENDIF.
    ELSE.
      MESSAGE S003(Z03S24999_DOMUS_MSGS) DISPLAY LIKE 'E'.
    ENDIF.
  ENDIF.
ENDFORM.

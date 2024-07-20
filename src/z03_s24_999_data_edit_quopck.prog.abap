*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_EDIT_QUOPCK
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_EDIT_QUOTATION
*&---------------------------------------------------------------------*
DATA: T_QUOTATION TYPE STANDARD TABLE OF Y03S24999_QUOTA.

SELECT *
  FROM Y03S24999_QUOTA
  INTO TABLE @T_QUOTATION.

IF SY-SUBRC = 0.

  LOOP AT T_QUOTATION INTO DATA(S_QUOTATION).
    IF S_QUOTATION-PACKAGE_ID IS INITIAL.
      S_QUOTATION-PACKAGE_ID = '0A755084-C616-4A0F-250A-08DC38CE79FC'.
    ENDIF.

    IF S_QUOTATION-CREATED_BY IS INITIAL.
      S_QUOTATION-CREATED_BY = SY-UNAME.
    ENDIF.

    MODIFY T_QUOTATION FROM S_QUOTATION INDEX SY-TABIX.

  ENDLOOP.

  UPDATE Y03S24999_QUOTA FROM TABLE T_QUOTATION.

  IF SY-SUBRC = 0.
    MESSAGE 'Modify Successfully.' TYPE 'S'.
  ELSE.
    MESSAGE 'Error updating database table' TYPE 'E'.
  ENDIF.

ELSE.
  MESSAGE 'Error: No data found' TYPE 'E'.
ENDIF.

*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_EDIT_QUOPCK
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_EDIT_QUOTA
*&---------------------------------------------------------------------*
DATA: T_QUOTA TYPE STANDARD TABLE OF Y03S24999_QUOTA.

SELECT *
  FROM Y03S24999_QUOTA
  INTO TABLE @T_QUOTA.

IF SY-SUBRC = 0.

  LOOP AT T_QUOTA INTO DATA(S_ROW).
    IF S_ROW-PACKAGE_ID IS INITIAL.
      S_ROW-PACKAGE_ID = '0A755084-C616-4A0F-250A-08DC38CE79FC'.
    ENDIF.

    IF S_ROW-CREATED_BY IS INITIAL.
      S_ROW-CREATED_BY = SY-UNAME.
    ENDIF.

    MODIFY T_QUOTA FROM S_ROW INDEX SY-TABIX.

  ENDLOOP.

  UPDATE Y03S24999_QUOTA FROM TABLE T_QUOTA.

  IF SY-SUBRC = 0.
    MESSAGE 'Modify Successfully.' TYPE 'S'.
  ELSE.
    MESSAGE 'Error updating database table' TYPE 'E'.
  ENDIF.

ELSE.
  MESSAGE 'Error: No data found' TYPE 'E'.
ENDIF.

*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_PACKGE_TIME
*&---------------------------------------------------------------------*
DATA: T_PACKAGE TYPE STANDARD TABLE OF Y03S24999_PACKGE.

SELECT *
  FROM Y03S24999_PACKGE
  INTO TABLE @T_PACKAGE.

IF SY-SUBRC = 0.

  LOOP AT T_PACKAGE INTO DATA(S_PACKAGE).

    S_PACKAGE-CREATED_BY = 'DEVELOPER'.
    S_PACKAGE-CREATED_AT = '093026'.
    S_PACKAGE-CREATED_ON = '20240623'.

    MODIFY T_PACKAGE FROM S_PACKAGE  INDEX SY-TABIX.

  ENDLOOP.

  MODIFY Y03S24999_PACKGE FROM TABLE T_PACKAGE.

  IF SY-SUBRC = 0.
    MESSAGE 'Modify Successfully.' TYPE 'S'.
  ELSE.
    MESSAGE 'Error updating database table' TYPE 'E'.
  ENDIF.

ELSE.
  MESSAGE 'Error: No data found' TYPE 'E'.
ENDIF.

*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_EDIT_PCKIMG
*&---------------------------------------------------------------------*
DATA: T_PCKIMG TYPE STANDARD TABLE OF Y03S24999_PCKIMG.

SELECT *
  FROM Y03S24999_PCKIMG
  INTO TABLE @T_PCKIMG.

IF SY-SUBRC = 0.

  LOOP AT T_PCKIMG INTO DATA(S_ROW).

    S_ROW-CREATED_BY = 'DEV-092'.
    S_ROW-CREATED_AT = '093026'.
    S_ROW-CREATED_ON = '20240702'.

    MODIFY T_PCKIMG FROM S_ROW  INDEX SY-TABIX.

  ENDLOOP.

  MODIFY Y03S24999_PCKIMG FROM TABLE T_PCKIMG.

  IF SY-SUBRC = 0.
    MESSAGE 'Modify Successfully.' TYPE 'S'.
  ELSE.
    MESSAGE 'Error updating database table' TYPE 'E'.
  ENDIF.

ELSE.
  MESSAGE 'Error: No data found' TYPE 'E'.
ENDIF.

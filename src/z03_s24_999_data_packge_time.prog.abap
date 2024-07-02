*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_PACKGE_TIME
*&---------------------------------------------------------------------*
DATA: T_PACKGE TYPE STANDARD TABLE OF Y03S24999_PACKGE.

SELECT *
  FROM Y03S24999_PACKGE
  INTO TABLE @T_PACKGE.

IF SY-SUBRC = 0.

  LOOP AT T_PACKGE INTO DATA(S_ROW).

    S_ROW-CREATED_BY = 'DEV-092'.
    S_ROW-CREATED_AT = '093026'.
    S_ROW-CREATED_ON = '20240623'.

    MODIFY T_PACKGE FROM S_ROW  INDEX SY-TABIX.

  ENDLOOP.

  MODIFY Y03S24999_PACKGE FROM TABLE T_PACKGE.

  IF SY-SUBRC = 0.
    MESSAGE 'Modify Successfully.' TYPE 'S'.
  ELSE.
    MESSAGE 'Error updating database table' TYPE 'E'.
  ENDIF.

ELSE.
  MESSAGE 'Error: No data found' TYPE 'E'.
ENDIF.

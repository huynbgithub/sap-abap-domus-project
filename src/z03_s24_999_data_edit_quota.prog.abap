*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_EDIT_QUOTA
*&---------------------------------------------------------------------*
DATA: T_QUOTA TYPE STANDARD TABLE OF Y03S24999_QUOTA.

SELECT *
  FROM Y03S24999_QUOTA
  INTO TABLE @T_QUOTA.

IF SY-SUBRC = 0.
  DATA: PNUM1 TYPE I VALUE 0.
  DATA: PNUM2 TYPE I VALUE 0.
  DATA: PNUM3 TYPE I VALUE 0.

  LOOP AT T_QUOTA INTO DATA(S_ROW).

    DATA LV_STR TYPE STRING.
    LV_STR = PNUM1 && PNUM2 && PNUM3.

    CONCATENATE 'Q000000' LV_STR INTO S_ROW-QUOTATION_CODE.
    PNUM3 += 1.
    IF PNUM3 = 10.
      PNUM3 = 0.
      PNUM2 += 1.
      IF PNUM2 = 10.
        PNUM2 = 0.
        PNUM1 += 1.
      ENDIF.
    ENDIF.

    MODIFY T_QUOTA FROM S_ROW INDEX SY-TABIX.

  ENDLOOP.

  MODIFY Y03S24999_QUOTA FROM TABLE T_QUOTA.

  IF SY-SUBRC = 0.
    MESSAGE 'Modify Successfully.' TYPE 'S'.
  ELSE.
    MESSAGE 'Error updating database table' TYPE 'E'.
  ENDIF.

ELSE.
  MESSAGE 'Error: No data found' TYPE 'E'.
ENDIF.

*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_EDIT_QUOTA
*&---------------------------------------------------------------------*
DATA: T_QUOTA TYPE STANDARD TABLE OF Y03S24999_QUOTA.

SELECT *
  FROM Y03S24999_QUOTA
  INTO TABLE @T_QUOTA.

IF SY-SUBRC = 0.
  DATA: PQNUM1 TYPE I VALUE 0.
  DATA: PQNUM2 TYPE I VALUE 0.
  DATA: PQNUM3 TYPE I VALUE 0.

  LOOP AT T_QUOTA INTO DATA(S_QUOTA).

    DATA LV_QUOTA_STR TYPE STRING.
    LV_QUOTA_STR = PQNUM1 && PQNUM2 && PQNUM3.

    CONCATENATE 'Q000000' LV_QUOTA_STR INTO S_QUOTA-QUOTATION_CODE.
    PQNUM3 += 1.
    IF PQNUM3 = 10.
      PQNUM3 = 0.
      PQNUM2 += 1.
      IF PQNUM2 = 10.
        PQNUM2 = 0.
        PQNUM1 += 1.
      ENDIF.
    ENDIF.

    MODIFY T_QUOTA FROM S_QUOTA INDEX SY-TABIX.

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

*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_EDIT_PROVRT
*&---------------------------------------------------------------------*
DATA: T_PRODCT TYPE STANDARD TABLE OF Y03S24999_PRODCT.

SELECT *
  FROM Y03S24999_PRODCT
  INTO TABLE @T_PRODCT.

IF SY-SUBRC = 0.

  LOOP AT T_PRODCT INTO DATA(S_PRODCT).

    DATA: LT_PROVRT TYPE STANDARD TABLE OF Y03S24999_PROVRT.

    SELECT *
      FROM Y03S24999_PROVRT
      WHERE PRODUCT_ID = @S_PRODCT-ID
      INTO TABLE @LT_PROVRT.

    IF SY-SUBRC = 0.
      DATA: PNUM1 TYPE I VALUE 1.
      PNUM1 = 1.

      LOOP AT LT_PROVRT INTO DATA(S_PROVRT).
        DATA LV_STR TYPE STRING.
        LV_STR = PNUM1.
        CONCATENATE 'V' LV_STR INTO S_PROVRT-VARIANT_CODE.
        PNUM1 += 1.
        MODIFY Y03S24999_PROVRT FROM S_PROVRT.
      ENDLOOP.

*      MODIFY Y03S24999_PROVRT FROM TABLE LT_PROVRT.

      IF SY-SUBRC = 0.
        MESSAGE 'Modify Successfully.' TYPE 'S'.
      ELSE.
        MESSAGE 'Error updating database table' TYPE 'E'.
      ENDIF.
    ELSE.
      MESSAGE 'Error: No product variant data found' TYPE 'S' DISPLAY LIKE 'E'.
    ENDIF.
  ENDLOOP.

ELSE.
  MESSAGE 'Error: No data found' TYPE 'E'.
ENDIF.

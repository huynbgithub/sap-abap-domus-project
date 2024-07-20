*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_EDIT_PROVRT
*&---------------------------------------------------------------------*
DATA: T_PRODUT TYPE STANDARD TABLE OF Y03S24999_PRODCT.

SELECT *
  FROM Y03S24999_PRODCT
  INTO TABLE @T_PRODUT.

IF SY-SUBRC = 0.

  LOOP AT T_PRODUT INTO DATA(S_PRODCT).

    DATA: LT_PROVRT TYPE STANDARD TABLE OF Y03S24999_PROVRT.

    SELECT *
      FROM Y03S24999_PROVRT
      WHERE PRODUCT_ID = @S_PRODCT-ID
      INTO TABLE @LT_PROVRT.

    IF SY-SUBRC = 0.
      DATA: PRVNUM1 TYPE I VALUE 1.
      PRVNUM1 = 1.

      LOOP AT LT_PROVRT INTO DATA(S_PROVRT).
        DATA LV_PRVSTR TYPE STRING.
        LV_PRVSTR = PRVNUM1.
        CONCATENATE 'V' LV_PRVSTR INTO S_PROVRT-VARIANT_CODE.
        PRVNUM1 += 1.
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

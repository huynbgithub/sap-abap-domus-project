*&---------------------------------------------------------------------*
*& Include z03_s24_999_data_edit_prodct
*&---------------------------------------------------------------------*

DATA: T_PRODCT TYPE STANDARD TABLE OF Y03S24999_PRODCT.

SELECT *
  FROM Y03S24999_PRODCT
  INTO TABLE @T_PRODCT.

IF SY-SUBRC = 0.
  DATA: PNUM1 TYPE I VALUE 0.
  DATA: PNUM2 TYPE I VALUE 0.
  DATA: PNUM3 TYPE I VALUE 0.

  LOOP AT T_PRODCT INTO DATA(S_ROW).

    DATA LV_STR TYPE STRING.
    LV_STR = PNUM1 && PNUM2 && PNUM3.

    CONCATENATE 'P000000' LV_STR INTO S_ROW-PRODUCT_CODE.
    PNUM3 += 1.
    IF PNUM3 = 10.
      PNUM3 = 0.
      PNUM2 += 1.
      IF PNUM2 = 10.
        PNUM2 = 0.
        PNUM1 += 1.
      ENDIF.
    ENDIF.

    SPLIT S_ROW-PRODUCT_NAME AT ' ' INTO DATA(FIRST_WORD) DATA(REST_OF_NAME).
    S_ROW-BRAND = FIRST_WORD.

    CONCATENATE S_ROW-PRODUCT_NAME 'from the brand' FIRST_WORD 'has multiple characteristics including' REST_OF_NAME
                 'features. This innovative offering stands out in the market due to its exceptional features and high-quality design.'
                 FIRST_WORD 'has ensured that' S_ROW-PRODUCT_NAME
                 'meets the needs of modern consumers.'
                 'The products robust performance is complemented by its reliability, making it a preferred choice for users seeking long-term value.'
                 'Its efficiency and effectiveness are enhanced. The advanced features of' FIRST_WORD
                 'are implemented that not only meet but exceed consumer expectations. Whether it’s for personal or professional use, this product is versatile and adaptable.'
                 'Another remarkable aspect of' S_ROW-PRODUCT_NAME 'is its eco-friendly design.'
                 'Customer feedback highlights the exceptional durability and dependability of ' S_ROW-PRODUCT_NAME
                 'product. Whether you are seeking reliability, efficiency, or cutting-edge performance, this product promises to deliver outstanding results in every use.'
                 'Welcome our customers to discover the excellence of the' S_ROW-PRODUCT_NAME 'product.' INTO S_ROW-DESCRIPTION SEPARATED BY SPACE.

    MODIFY T_PRODCT FROM S_ROW INDEX SY-TABIX.

  ENDLOOP.

  MODIFY Y03S24999_PRODCT FROM TABLE T_PRODCT.

  IF SY-SUBRC = 0.
    MESSAGE 'Modify Successfully.' TYPE 'S'.
  ELSE.
    MESSAGE 'Error updating database table' TYPE 'E'.
  ENDIF.

ELSE.
  MESSAGE 'Error: No data found' TYPE 'E'.
ENDIF.

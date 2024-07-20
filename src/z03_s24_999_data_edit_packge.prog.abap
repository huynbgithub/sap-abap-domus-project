*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_EDIT_PACKGE
*&---------------------------------------------------------------------*
DATA: T_PACKGE TYPE STANDARD TABLE OF Y03S24999_PACKGE.

SELECT *
  FROM Y03S24999_PACKGE
  INTO TABLE @T_PACKGE.

IF SY-SUBRC = 0.

  LOOP AT T_PACKGE INTO DATA(S_PACKGE).

    CONCATENATE S_PACKGE-NAME 'has multiple characteristics including valuable services and products.'
                 'This innovative offering stands out in the market due to its exceptional features and high-quality design.'
                 S_PACKGE-NAME 'has ensured that it'
                 'meets the needs of modern consumers.'
                 'The products robust performance is complemented by its reliability, making it a preferred choice for users seeking long-term value.'
                 'Its efficiency and effectiveness are enhanced. The advanced features of' S_PACKGE-NAME
                 'services are implemented that not only meet but exceed consumer expectations. Whether it’s for personal or professional use, this product is versatile and adaptable.'
                 'Another remarkable aspect of' S_PACKGE-NAME 'is its eco-friendly design.'
                 'Customer feedback highlights the exceptional durability and dependability of ' S_PACKGE-NAME
                 'product. Whether you are seeking reliability, efficiency, or cutting-edge performance, this package promises to deliver outstanding results in every use.'
                 'Welcome our customers to discover the excellence of the' S_PACKGE-NAME 'products and services.' INTO S_PACKGE-DESCRIPTION SEPARATED BY SPACE.

    MODIFY T_PACKGE FROM S_PACKGE INDEX SY-TABIX.

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

*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_EDIT_CNTRCT
*&---------------------------------------------------------------------*
DATA: T_CNTRCT TYPE STANDARD TABLE OF Y03S24999_CNTRCT.

SELECT *
  FROM Y03S24999_CNTRCT
  INTO TABLE @T_CNTRCT.

IF SY-SUBRC = 0.
     DATA: PNUM1 TYPE I VALUE 0.
     DATA: PNUM2 TYPE I VALUE 0.
     DATA: PNUM3 TYPE I VALUE 0.

  LOOP AT T_CNTRCT INTO DATA(S_ROW).
    DATA LV_STR TYPE STRING.
    LV_STR = PNUM1 && PNUM2 && PNUM3.

    CONCATENATE 'CT00000' LV_STR INTO S_ROW-CONTRACT_CODE.
    PNUM3 += 1.
    IF PNUM3 = 10.
      PNUM3 = 0.
      PNUM2 += 1.
      IF PNUM2 = 10.
        PNUM2 = 0.
        PNUM1 += 1.
      ENDIF.
    ENDIF.

    S_ROW-CREATED_BY = 'DEV-092'.
    S_ROW-CREATED_AT = '104514'.
    S_ROW-CREATED_ON = '20240712'.
    S_ROW-SIGNED_AT = '092552'.
    S_ROW-SIGNED_ON = '20240714'.
    S_ROW-SIGNATURE =
'https://firebasestorage.googleapis.com/v0/b/sap-domus.appspot.com/o/images%2FHuySignature.png?alt=media&token=122341c9-9728-456d-8e0b-419cb043d87e'.
    S_ROW-STATUS = 'Signed'.
    S_ROW-STAFF = 'DEV-092'.
    S_ROW-CUSTOMER = 'DEV-092'.

    CONCATENATE S_ROW-CONTRACT_CODE 'has multiple characteristics including valuable services and products.'
                 'This innovative offering stands out in the market due to its exceptional features and high-quality design.'
                 S_ROW-CONTRACT_CODE 'has ensured that it'
                 'meets the needs of modern consumers.'
                 'The products robust performance is complemented by its reliability, making it a preferred choice for users seeking long-term value.'
                 'Its efficiency and effectiveness are enhanced. The advanced features of' S_ROW-CONTRACT_CODE
                 'services are implemented that not only meet but exceed consumer expectations. Whether it’s for personal or professional use, this product is versatile and adaptable.'
                 'Another remarkable aspect of' S_ROW-CONTRACT_CODE 'is its eco-friendly design.'
                 'Customer feedback highlights the exceptional durability and dependability of ' S_ROW-CONTRACT_CODE
                 'product. Whether you are seeking reliability, efficiency, or cutting-edge performance, this contract promises to deliver outstanding results in every use.'
                 'Welcome our customers to discover the excellence of the' S_ROW-CONTRACT_CODE 'products and services.' INTO S_ROW-DESCRIPTION SEPARATED BY SPACE.

    MODIFY T_CNTRCT FROM S_ROW  INDEX SY-TABIX.

  ENDLOOP.

  MODIFY Y03S24999_CNTRCT FROM TABLE T_CNTRCT.

  IF SY-SUBRC = 0.
    MESSAGE 'Modify Successfully.' TYPE 'S'.
  ELSE.
    MESSAGE 'Error updating database table' TYPE 'E'.
  ENDIF.

ELSE.
  MESSAGE 'Error: No data found' TYPE 'E'.
ENDIF.

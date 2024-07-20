*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_EDIT_CNTRCT
*&---------------------------------------------------------------------*
DATA: T_CNTRCT TYPE STANDARD TABLE OF Y03S24999_CNTRCT.

SELECT *
  FROM Y03S24999_CNTRCT
  INTO TABLE @T_CNTRCT.

IF SY-SUBRC = 0.
     DATA: PCNUM1 TYPE I VALUE 0.
     DATA: PCNUM2 TYPE I VALUE 0.
     DATA: PCNUM3 TYPE I VALUE 0.

  LOOP AT T_CNTRCT INTO DATA(S_CNTRCT).
    DATA LV_CNTSTR TYPE STRING.
    LV_CNTSTR = PCNUM1 && PCNUM2 && PCNUM3.

    CONCATENATE 'CT00000' LV_CNTSTR INTO S_CNTRCT-CONTRACT_CODE.
    PCNUM3 += 1.
    IF PCNUM3 = 10.
      PCNUM3 = 0.
      PCNUM2 += 1.
      IF PCNUM2 = 10.
        PCNUM2 = 0.
        PCNUM1 += 1.
      ENDIF.
    ENDIF.

    S_CNTRCT-CREATED_BY = 'DEVELOPER'.
    S_CNTRCT-CREATED_AT = '104514'.
    S_CNTRCT-CREATED_ON = '20240712'.
    S_CNTRCT-SIGNED_AT = '092552'.
    S_CNTRCT-SIGNED_ON = '20240714'.
    S_CNTRCT-SIGNATURE =
'https://firebasestorage.googleapis.com/v0/b/sap-domus.appspot.com/o/images%2FHuySignature.png?alt=media&token=122341c9-9728-456d-8e0b-419cb043d87e'.
    S_CNTRCT-STATUS = 'Signed'.
    S_CNTRCT-STAFF = 'DEVELOPER'.
    S_CNTRCT-CUSTOMER = 'DEVELOPER'.

    CONCATENATE S_CNTRCT-CONTRACT_CODE 'has multiple characteristics including valuable services and products.'
                 'This innovative offering stands out in the market due to its exceptional features and high-quality design.'
                 S_CNTRCT-CONTRACT_CODE 'has ensured that it'
                 'meets the needs of modern consumers.'
                 'The products robust performance is complemented by its reliability, making it a preferred choice for users seeking long-term value.'
                 'Its efficiency and effectiveness are enhanced. The advanced features of' S_CNTRCT-CONTRACT_CODE
                 'services are implemented that not only meet but exceed consumer expectations. Whether it’s for personal or professional use, this product is versatile and adaptable.'
                 'Another remarkable aspect of' S_CNTRCT-CONTRACT_CODE 'is its eco-friendly design.'
                 'Customer feedback highlights the exceptional durability and dependability of ' S_CNTRCT-CONTRACT_CODE
                 'product. Whether you are seeking reliability, efficiency, or cutting-edge performance, this contract promises to deliver outstanding results in every use.'
                 'Welcome our customers to discover the excellence of the' S_CNTRCT-CONTRACT_CODE 'products and services.' INTO S_CNTRCT-DESCRIPTION SEPARATED BY SPACE.

    MODIFY T_CNTRCT FROM S_CNTRCT  INDEX SY-TABIX.

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

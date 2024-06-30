*&---------------------------------------------------------------------*
*& Report Z03_S24_999_TEST_PROGRAM
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z03_S24_999_TEST_PROGRAM.
* TYPE Declaration for Y03S24999_PCKPRV Table
TYPES: BEGIN OF TY_PCKPRV,
         SEL            TYPE C,
         ID             TYPE Y03S24999_PCKPRV-ID,
         PRODUCT_ID     TYPE Y03S24999_PRODCT-ID,
         PRODUCT_NAME   TYPE Y03S24999_PRODCT-PRODUCT_NAME,
         CREATED_BY     TYPE Y03S24999_PCKPRV-CREATED_BY,
         CREATED_AT     TYPE Y03S24999_PCKPRV-CREATED_AT,
         CREATED_ON     TYPE Y03S24999_PCKPRV-CREATED_ON,
         UPDATED_BY     TYPE Y03S24999_PCKPRV-UPDATED_BY,
         UPDATED_AT     TYPE Y03S24999_PCKPRV-UPDATED_AT,
         UPDATED_ON     TYPE Y03S24999_PCKPRV-UPDATED_ON,
       END OF TY_PCKPRV.
  DATA: LT_PCKPRV TYPE STANDARD TABLE OF TY_PCKPRV.

START-OF-SELECTION.

  SELECT ' ' AS SEL,
         PCKPRV~*,
         PROVRT~PRODUCT_ID
  FROM Y03S24999_PCKPRV AS PCKPRV
  JOIN Y03S24999_PROVRT AS PROVRT
  ON PCKPRV~PRODUCT_VARIANT_ID = PROVRT~ID
  WHERE PCKPRV~IS_DELETED <> @ABAP_TRUE
    AND PROVRT~IS_DELETED <> @ABAP_TRUE
  INTO CORRESPONDING FIELDS OF TABLE @LT_PCKPRV.

  SELECT LT~*,
         PRODCT~PRODUCT_NAME
  FROM @LT_PCKPRV AS LT
  JOIN Y03S24999_PRODCT AS PRODCT
  ON LT~PRODUCT_ID = PRODCT~ID
  WHERE PRODCT~IS_DELETED <> @ABAP_TRUE
  INTO CORRESPONDING FIELDS OF TABLE @LT_PCKPRV.

WRITE: / LT_PCKPRV[ 1 ]-ID, LT_PCKPRV[ 1 ]-SEL, LT_PCKPRV[ 1 ]-PRODUCT_NAME.

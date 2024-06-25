*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_QUOTATION_TOP
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* TYPE Declaration
*---------------------------------------------------------------------*

* TYPE Declaration for Y03S24999_QUOTA Table
TYPES: BEGIN OF TY_QUOTATION,
         QUOTATION_CODE TYPE Y03S24999_QUOTA-QUOTATION_CODE,
         CUSTOMER       TYPE Y03S24999_QUOTA-CUSTOMER,
         STAFF          TYPE Y03S24999_QUOTA-STAFF,
         STATUS         TYPE Y03S24999_QUOTA-STATUS,
         PACKAGE_NAME   TYPE Y03S24999_PACKGE-NAME,
         EXPIRED_ON     TYPE Y03S24999_QUOTA-EXPIRED_ON,
         EXPIRED_AT     TYPE Y03S24999_QUOTA-EXPIRED_AT,
         CREATED_BY     TYPE Y03S24999_QUOTA-CREATED_BY,
         CREATED_AT     TYPE Y03S24999_QUOTA-CREATED_AT,
         CREATED_ON     TYPE Y03S24999_QUOTA-CREATED_ON,
         UPDATED_BY     TYPE Y03S24999_QUOTA-UPDATED_BY,
         UPDATED_AT     TYPE Y03S24999_QUOTA-UPDATED_AT,
         UPDATED_ON     TYPE Y03S24999_QUOTA-UPDATED_ON,
         COLOR          TYPE LVC_T_SCOL,
       END OF TY_QUOTATION.
* TYPE Declaration for Quotation Status Color
TYPES: BEGIN OF TY_COLOR,
            STATUS TYPE Y03S24999_QUOTA-STATUS.
            INCLUDE TYPE LVC_S_COLO.
       TYPES END OF TY_COLOR.
*---------------------------------------------------------------------*
* CLASS Definition
*---------------------------------------------------------------------*
CLASS LCL_ALV_HANDLER DEFINITION.
  PUBLIC SECTION.

    METHODS HOTSPOT_CLICK FOR EVENT HOTSPOT_CLICK OF CL_GUI_ALV_GRID
      IMPORTING
        E_ROW_ID
        E_COLUMN_ID
        ES_ROW_NO.

ENDCLASS.
*---------------------------------------------------------------------*
* DATA Declaration
*---------------------------------------------------------------------*
TABLES: Y03S24999_QUOTA.

* Internal Table Declaration for QUOTATION Table
DATA: IT_QUOTATION TYPE STANDARD TABLE OF TY_QUOTATION.

* Work Area Declaration for QUOTATION Table
DATA: WA_QUOTATION TYPE TY_QUOTATION.

* Status Color Table
DATA: GT_COLOR TYPE STANDARD TABLE OF TY_COLOR.

* ALV Table Object
DATA: O_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID.

*&---------------------------------------------------------------------*
*& Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 0131 AS SUBSCREEN.
  SELECT-OPTIONS : P_QCODE FOR Y03S24999_QUOTA-QUOTATION_CODE.

SELECTION-SCREEN END OF SCREEN 0131.
*---------------------------------------------------------------------*
* Init
*---------------------------------------------------------------------*
*INITIALIZATION.
*  PERFORM SET_QCODE_INITIAL_VALUES.

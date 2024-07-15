*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_CONTRACT_TOP
*&---------------------------------------------------------------------*
* TYPE Declaration for Y03S24999_CNTRCT Table
TYPES: BEGIN OF TY_CONTRACT,
         ID            TYPE Y03S24999_CNTRCT-ID,
         CONTRACT_CODE TYPE Y03S24999_CNTRCT-CONTRACT_CODE,
         CUSTOMER      TYPE Y03S24999_CNTRCT-CUSTOMER,
         STAFF         TYPE Y03S24999_CNTRCT-STAFF,
         STATUS        TYPE Y03S24999_CNTRCT-STATUS,
         SIGNED_ON     TYPE Y03S24999_CNTRCT-SIGNED_ON,
         SIGNED_AT     TYPE Y03S24999_CNTRCT-SIGNED_AT,
         CREATED_BY    TYPE Y03S24999_CNTRCT-CREATED_BY,
         CREATED_AT    TYPE Y03S24999_CNTRCT-CREATED_AT,
         CREATED_ON    TYPE Y03S24999_CNTRCT-CREATED_ON,
         UPDATED_BY    TYPE Y03S24999_CNTRCT-UPDATED_BY,
         UPDATED_AT    TYPE Y03S24999_CNTRCT-UPDATED_AT,
         UPDATED_ON    TYPE Y03S24999_CNTRCT-UPDATED_ON,
         LINE_COLOR    TYPE LVC_T_SCOL,
*         QUOVER_ID            TYPE Y03S24999_QUOVER-ID,
*         QUOVER_VERSION_ORDER TYPE Y03S24999_QUOVER-VERSION_ORDER,
*         QUOVER_CREATED_ON    TYPE Y03S24999_QUOVER-CREATED_ON,
*         QUOVER_CREATED_AT    TYPE Y03S24999_QUOVER-CREATED_AT,
       END OF TY_CONTRACT.
* TYPE Declaration for CONTRACT Status Color
TYPES: BEGIN OF TY_CONTRACT_COLOR,
         STATUS TYPE Y03S24999_CNTRCT-STATUS.
         INCLUDE TYPE LVC_S_COLO.
TYPES END OF TY_CONTRACT_COLOR.
*---------------------------------------------------------------------*
* CLASS Definition
*---------------------------------------------------------------------*
CLASS CL_CONTRACT_ALV_HANDLER DEFINITION.
  PUBLIC SECTION.

    METHODS HOTSPOT_CLICK FOR EVENT HOTSPOT_CLICK OF CL_GUI_ALV_GRID
      IMPORTING
        E_ROW_ID
        E_COLUMN_ID
        ES_ROW_NO.

ENDCLASS.
*---------------------------------------------------------------------*
* DATA Definition
*---------------------------------------------------------------------*
DATA: CCODE_DUMMY TYPE Y03S24999_CNTRCT-CONTRACT_CODE.

* Internal Table Declaration for CONTRACT Table
DATA: IT_CONTRACT TYPE STANDARD TABLE OF TY_CONTRACT.

* Status Color Table
DATA: GT_CONTRACT_COLOR TYPE STANDARD TABLE OF TY_CONTRACT_COLOR.

* ALV Table Object
DATA: O_CONTRACT_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_CONTRACT_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID,
      O_CONTRACT_HANDLER   TYPE REF TO CL_CONTRACT_ALV_HANDLER.
*&---------------------------------------------------------------------*
*& Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 0141 AS SUBSCREEN.
  SELECT-OPTIONS : P_CCODE FOR CCODE_DUMMY.
SELECTION-SCREEN END OF SCREEN 0141.

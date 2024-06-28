*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_PCKSER_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_PCKSER_TOP
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* TYPE Declaration
*---------------------------------------------------------------------*

* TYPE Declaration for Y03S24999_PCKSER Table
TYPES: BEGIN OF TY_PCKSER,
         ID             TYPE Y03S24999_PCKSER-ID,
         SERVICE_NAME   TYPE Y03S24999_SERVCE-NAME,
         CREATED_BY     TYPE Y03S24999_PCKSER-CREATED_BY,
         CREATED_AT     TYPE Y03S24999_PCKSER-CREATED_AT,
         CREATED_ON     TYPE Y03S24999_PCKSER-CREATED_ON,
         UPDATED_BY     TYPE Y03S24999_PCKSER-UPDATED_BY,
         UPDATED_AT     TYPE Y03S24999_PCKSER-UPDATED_AT,
         UPDATED_ON     TYPE Y03S24999_PCKSER-UPDATED_ON,
       END OF TY_PCKSER.

*---------------------------------------------------------------------*
* CLASS Definition
*---------------------------------------------------------------------*
CLASS CL_PCKSER_ALV_HANDLER DEFINITION.
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
* Internal Table Declaration for PCKSER Table
DATA: IT_PCKSER TYPE STANDARD TABLE OF TY_PCKSER.

* Work Area Declaration for PCKSER Table
DATA: WA_PCKSER TYPE TY_PCKSER.

* ALV Table Object
DATA: O_PCKSER_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_PCKSER_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID,
      O_PCKSER_HANDLER TYPE REF TO CL_PCKSER_ALV_HANDLER.

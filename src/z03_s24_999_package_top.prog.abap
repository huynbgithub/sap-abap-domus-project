*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_PACKAGE_TOP
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_PACKAGE_TOP
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* TYPE Declaration
*---------------------------------------------------------------------*

* TYPE Declaration for Y03S24999_PACKGE Table
TYPES: BEGIN OF TY_PACKAGE,
         ID             TYPE Y03S24999_PACKGE-ID,
         NAME           TYPE Y03S24999_PACKGE-NAME,
         DESCRIPTION    TYPE Y03S24999_PACKGE-DESCRIPTION,
         CREATED_BY     TYPE Y03S24999_PACKGE-CREATED_BY,
         CREATED_AT     TYPE Y03S24999_PACKGE-CREATED_AT,
         CREATED_ON     TYPE Y03S24999_PACKGE-CREATED_ON,
         UPDATED_BY     TYPE Y03S24999_PACKGE-UPDATED_BY,
         UPDATED_AT     TYPE Y03S24999_PACKGE-UPDATED_AT,
         UPDATED_ON     TYPE Y03S24999_PACKGE-UPDATED_ON,
       END OF TY_PACKAGE.

*---------------------------------------------------------------------*
* CLASS Definition
*---------------------------------------------------------------------*
CLASS LCL_PACKAGE_ALV_HANDLER DEFINITION.
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
DATA: PACKAGE_NAME_DUMMY TYPE Y03S24999_PACKGE-NAME.

* Internal Table Declaration for PACKAGE Table
DATA: IT_PACKAGE TYPE STANDARD TABLE OF TY_PACKAGE.

* Work Area Declaration for PACKAGE Table
DATA: WA_PACKAGE TYPE TY_PACKAGE.

* ALV Table Object
DATA: O_PACKAGE_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_PACKAGE_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID.

*&---------------------------------------------------------------------*
*& Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 0121 AS SUBSCREEN.
  SELECT-OPTIONS : P_PKNAME FOR PACKAGE_NAME_DUMMY.
SELECTION-SCREEN END OF SCREEN 0121.

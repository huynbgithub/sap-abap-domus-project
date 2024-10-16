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
         ID          TYPE Y03S24999_PACKGE-ID,
         NAME        TYPE Y03S24999_PACKGE-NAME,
         DESCRIPTION TYPE Y03S24999_PACKGE-DESCRIPTION,
         CREATED_BY  TYPE Y03S24999_PACKGE-CREATED_BY,
         CREATED_AT  TYPE Y03S24999_PACKGE-CREATED_AT,
         CREATED_ON  TYPE Y03S24999_PACKGE-CREATED_ON,
         UPDATED_BY  TYPE Y03S24999_PACKGE-UPDATED_BY,
         UPDATED_AT  TYPE Y03S24999_PACKGE-UPDATED_AT,
         UPDATED_ON  TYPE Y03S24999_PACKGE-UPDATED_ON,
         LINE_COLOR  TYPE LVC_T_SCOL,
       END OF TY_PACKAGE.
* TYPE Declaration for Y03S24999_PCKPRV Table
TYPES: BEGIN OF TY_PCKPRV,
         ID                 TYPE Y03S24999_PCKPRV-ID,
         PACKAGE_ID         TYPE Y03S24999_PACKGE-ID,
         PRODUCT_VARIANT_ID TYPE Y03S24999_PROVRT-ID,
         SEL                TYPE C,
         PRODUCT_ID         TYPE Y03S24999_PRODCT-ID,
         PRODUCT_NAME       TYPE Y03S24999_PRODCT-PRODUCT_NAME,
         VARIANT_CODE       TYPE Y03S24999_PROVRT-VARIANT_CODE,
         DISPLAY_PRICE      TYPE Y03S24999_PROVRT-DISPLAY_PRICE,
         QUANTITY           TYPE Y03S24999_PCKPRV-QUANTITY,
         TOTAL_PRICE        TYPE Y03S24999_PROVRT-DISPLAY_PRICE,
         CREATED_BY         TYPE Y03S24999_PCKPRV-CREATED_BY,
         CREATED_AT         TYPE Y03S24999_PCKPRV-CREATED_AT,
         CREATED_ON         TYPE Y03S24999_PCKPRV-CREATED_ON,
         UPDATED_BY         TYPE Y03S24999_PCKPRV-UPDATED_BY,
         UPDATED_AT         TYPE Y03S24999_PCKPRV-UPDATED_AT,
         UPDATED_ON         TYPE Y03S24999_PCKPRV-UPDATED_ON,
       END OF TY_PCKPRV.
* TYPE Declaration for Y03S24999_PCKSER Table
TYPES: BEGIN OF TY_PCKSER,
         ID            TYPE Y03S24999_PCKSER-ID,
         PACKAGE_ID    TYPE Y03S24999_PACKGE-ID,
         SERVICE_ID    TYPE Y03S24999_PCKSER-ID,
         SEL           TYPE C,
         SERVICE_NAME  TYPE Y03S24999_SERVCE-NAME,
         DISPLAY_PRICE TYPE Y03S24999_SERVCE-DISPLAY_PRICE,
         CREATED_BY    TYPE Y03S24999_PCKSER-CREATED_BY,
         CREATED_AT    TYPE Y03S24999_PCKSER-CREATED_AT,
         CREATED_ON    TYPE Y03S24999_PCKSER-CREATED_ON,
         UPDATED_BY    TYPE Y03S24999_PCKSER-UPDATED_BY,
         UPDATED_AT    TYPE Y03S24999_PCKSER-UPDATED_AT,
         UPDATED_ON    TYPE Y03S24999_PCKSER-UPDATED_ON,
       END OF TY_PCKSER.
* TYPE Declaration for Y03S24999_PCKIMG Table
TYPES: BEGIN OF TY_PCKIMG,
         ID         TYPE Y03S24999_PCKIMG-ID,
         PACKAGE_ID TYPE Y03S24999_PCKIMG-PACKAGE_ID,
         SEL        TYPE C,
         IMAGE_URL  TYPE Y03S24999_PCKIMG-IMAGE_URL,
         CREATED_BY TYPE Y03S24999_PCKIMG-CREATED_BY,
         CREATED_AT TYPE Y03S24999_PCKIMG-CREATED_AT,
         CREATED_ON TYPE Y03S24999_PCKIMG-CREATED_ON,
         UPDATED_BY TYPE Y03S24999_PCKIMG-UPDATED_BY,
         UPDATED_AT TYPE Y03S24999_PCKIMG-UPDATED_AT,
         UPDATED_ON TYPE Y03S24999_PCKIMG-UPDATED_ON,
       END OF TY_PCKIMG.
* TYPE Declaration for Y03S24999_PRODCT Table for 0127 Modal Dialog Box
TYPES: BEGIN OF TY_PRODUCT_0127,
         ID           TYPE Y03S24999_PRODCT-ID,
         PRODUCT_CODE TYPE Y03S24999_PRODCT-PRODUCT_CODE,
         BRAND        TYPE Y03S24999_PRODCT-BRAND,
         PRODUCT_NAME TYPE Y03S24999_PRODCT-PRODUCT_NAME,
         CREATED_BY   TYPE Y03S24999_PRODCT-CREATED_BY,
         CREATED_AT   TYPE Y03S24999_PRODCT-CREATED_AT,
         CREATED_ON   TYPE Y03S24999_PRODCT-CREATED_ON,
         UPDATED_BY   TYPE Y03S24999_PRODCT-UPDATED_BY,
         UPDATED_AT   TYPE Y03S24999_PRODCT-UPDATED_AT,
         UPDATED_ON   TYPE Y03S24999_PRODCT-UPDATED_ON,
       END OF TY_PRODUCT_0127.
* TYPE Declaration for Y03S24999_PROVRT Table for 0126 Modal Dialog Box
TYPES: BEGIN OF TY_PROVRT_0126,
         ID            TYPE Y03S24999_PROVRT-ID,
         PRODUCT_ID    TYPE Y03S24999_PROVRT-PRODUCT_ID,
         PRODUCT_CODE  TYPE Y03S24999_PRODCT-PRODUCT_CODE,
         PRODUCT_NAME  TYPE Y03S24999_PRODCT-PRODUCT_NAME,
         VARIANT_CODE  TYPE Y03S24999_PROVRT-VARIANT_CODE,
         DISPLAY_PRICE TYPE Y03S24999_PROVRT-DISPLAY_PRICE,
         CREATED_BY    TYPE Y03S24999_PROVRT-CREATED_BY,
         CREATED_AT    TYPE Y03S24999_PROVRT-CREATED_AT,
         CREATED_ON    TYPE Y03S24999_PROVRT-CREATED_ON,
         UPDATED_BY    TYPE Y03S24999_PROVRT-UPDATED_BY,
         UPDATED_AT    TYPE Y03S24999_PROVRT-UPDATED_AT,
         UPDATED_ON    TYPE Y03S24999_PROVRT-UPDATED_ON,
       END OF TY_PROVRT_0126.
* TYPE Declaration for Y03S24999_PROATV Table for 0125 Modal Dialog Box
TYPES: BEGIN OF TY_PROATV_0125,
         ID             TYPE Y03S24999_PROATV-ID,
         ATTRIBUTE_NAME TYPE Y03S24999_PROATR-ATTRIBUTE_NAME,
         VALUE          TYPE Y03S24999_PROATV-VALUE,
       END OF TY_PROATV_0125.
* TYPE Declaration for Y03S24999_SERVCE Table for 0128 Modal Dialog Box
TYPES: BEGIN OF TY_SERVICE_0128,
         ID            TYPE Y03S24999_SERVCE-ID,
         NAME          TYPE Y03S24999_SERVCE-NAME,
         DISPLAY_PRICE TYPE Y03S24999_SERVCE-DISPLAY_PRICE,
         DESCRIPTION   TYPE Y03S24999_SERVCE-DESCRIPTION,
         CREATED_BY    TYPE Y03S24999_SERVCE-CREATED_BY,
         CREATED_AT    TYPE Y03S24999_SERVCE-CREATED_AT,
         CREATED_ON    TYPE Y03S24999_SERVCE-CREATED_ON,
         UPDATED_BY    TYPE Y03S24999_SERVCE-UPDATED_BY,
         UPDATED_AT    TYPE Y03S24999_SERVCE-UPDATED_AT,
         UPDATED_ON    TYPE Y03S24999_SERVCE-UPDATED_ON,
       END OF TY_SERVICE_0128.
*---------------------------------------------------------------------*
* CLASS Definition
*---------------------------------------------------------------------*
* CLASS CL_PACKAGE_ALV_HANDLER
* DEFINITION
CLASS CL_PACKAGE_ALV_HANDLER DEFINITION.
  PUBLIC SECTION.

    METHODS HOTSPOT_CLICK FOR EVENT HOTSPOT_CLICK OF CL_GUI_ALV_GRID
      IMPORTING
        E_ROW_ID
        E_COLUMN_ID
        ES_ROW_NO.

ENDCLASS.
* CLASS CL_PACKAGE_PROVRT_ALV_HANDLER
* DEFINITION
CLASS CL_PACKAGE_PROVRT_ALV_HANDLER DEFINITION.
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
DATA: GV_OKCODE_0125 TYPE SYST-UCOMM.
DATA: GV_OKCODE_0126 TYPE SYST-UCOMM.
DATA: GV_OKCODE_0127 TYPE SYST-UCOMM.
DATA: GV_OKCODE_0128 TYPE SYST-UCOMM.
DATA: GV_PACKAGE_NAME_DUMMY TYPE Y03S24999_PACKGE-NAME.

* Internal Table Declaration for PACKAGE Table
DATA: IT_PACKAGE TYPE STANDARD TABLE OF TY_PACKAGE.
DATA: GT_PACKAGE_DELETED TYPE STANDARD TABLE OF TY_PACKAGE WITH KEY ID.

* PACKAGE ALV Table Object
DATA: O_PACKAGE_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_PACKAGE_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID,
      O_PACKAGE_HANDLER   TYPE REF TO CL_PACKAGE_ALV_HANDLER.

* Internal Table Declaration for PRODUCT_0127 Table
DATA: IT_PRODUCT_0127 TYPE STANDARD TABLE OF TY_PRODUCT_0127.

* PRODUCT_0127 ALV Table Object
DATA: O_PRODUCT_0127_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_PRODUCT_0127_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID.

* Internal Table Declaration for PROVRT_0126 Table
DATA: IT_PROVRT_0126 TYPE STANDARD TABLE OF TY_PROVRT_0126.

* PRODUCT_0126 ALV Table Object
DATA: O_PROVRT_0126_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_PROVRT_0126_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID,
      O_PROVRT_0126_HANDLER   TYPE REF TO CL_PACKAGE_PROVRT_ALV_HANDLER.

* Internal Table Declaration for SERVICE_0128 Table
DATA: IT_SERVICE_0128 TYPE STANDARD TABLE OF TY_SERVICE_0128.

* SERVICE_0128 ALV Table Object
DATA: O_SERVICE_0128_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_SERVICE_0128_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID.

* Internal Table Declaration for PROATV_0125 Table
DATA: IT_PROATV_0125 TYPE STANDARD TABLE OF TY_PROATV_0125.

* PROATV_0125 ALV Table Object
DATA: O_PROATV_0125_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_PROATV_0125_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID.

DATA: PACKAGE_SCREEN_MODE TYPE C LENGTH 4 VALUE '0120'.

DATA: GV_PACKAGE_ID TYPE Y03S24999_PACKGE-ID.

DATA: GV_PACKAGE_SCREEN_MODE TYPE I.
DATA: GS_PACKAGE_DETAIL_BEFORE_MOD TYPE TY_PACKAGE.
DATA: GS_PACKAGE_DETAIL TYPE TY_PACKAGE.

DATA: GS_PCKPRV            TYPE TY_PCKPRV.
DATA: GT_PCKPRV            TYPE STANDARD TABLE OF TY_PCKPRV WITH KEY ID PACKAGE_ID PRODUCT_VARIANT_ID.
DATA: GT_PCKPRV_BEFORE_MOD TYPE STANDARD TABLE OF TY_PCKPRV WITH KEY ID PACKAGE_ID PRODUCT_VARIANT_ID.
DATA: GT_PCKPRV_DELETED    TYPE STANDARD TABLE OF TY_PCKPRV WITH KEY ID PACKAGE_ID PRODUCT_VARIANT_ID.

DATA: GS_PCKSER            TYPE TY_PCKSER.
DATA: GT_PCKSER            TYPE STANDARD TABLE OF TY_PCKSER WITH KEY ID PACKAGE_ID SERVICE_ID.
DATA: GT_PCKSER_BEFORE_MOD TYPE STANDARD TABLE OF TY_PCKSER WITH KEY ID PACKAGE_ID SERVICE_ID.
DATA: GT_PCKSER_DELETED    TYPE STANDARD TABLE OF TY_PCKSER WITH KEY ID PACKAGE_ID SERVICE_ID.

DATA: GV_PCKPRV_TOTAL_PRICE  TYPE Y03S24999_PROVRT-DISPLAY_PRICE VALUE 0.
DATA: GV_PCKSER_TOTAL_PRICE  TYPE Y03S24999_SERVCE-DISPLAY_PRICE VALUE 0.
DATA: GV_PACKAGE_TOTAL_PRICE TYPE Y03S24999_PROVRT-DISPLAY_PRICE VALUE 0.

DATA: GS_PCKIMG            TYPE TY_PCKIMG.
DATA: GT_PCKIMG            TYPE STANDARD TABLE OF TY_PCKIMG WITH KEY ID PACKAGE_ID.
DATA: GT_PCKIMG_BEFORE_MOD TYPE STANDARD TABLE OF TY_PCKIMG WITH KEY ID PACKAGE_ID.
DATA: GT_PCKIMG_DELETED    TYPE STANDARD TABLE OF TY_PCKIMG WITH KEY ID PACKAGE_ID.

CONTROLS: PCKPRV_TABLE_CONTROL TYPE TABLEVIEW USING SCREEN 0129.
CONTROLS: PCKSER_TABLE_CONTROL TYPE TABLEVIEW USING SCREEN 0129.
CONTROLS: PCKIMG_TABLE_CONTROL TYPE TABLEVIEW USING SCREEN 0129.

* Package Color Table
DATA: GT_PACKAGE_COLOR TYPE STANDARD TABLE OF LVC_S_COLO.

DATA GV_PCKIMG_URL TYPE CNDP_URL.
DATA PCKIMG_CONTROL TYPE REF TO CL_GUI_PICTURE.
DATA PCKIMG_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER.
DATA PCKIMG_EVENT_RECEIVER  TYPE REF TO C_EVENT_RECEIVER.
DATA PCKIMG_EVENT_TAB TYPE CNTL_SIMPLE_EVENTS.
DATA PCKIMG_EVENT_TAB_LINE TYPE CNTL_SIMPLE_EVENT.
DATA PCKIMG_RETURN TYPE I.

DATA: PCKDES_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      PCKDES_EDITOR    TYPE REF TO CL_GUI_TEXTEDIT.

DATA: PCKDES_LINE                TYPE C LENGTH 256,
      PCKDES_TEXT_TAB            LIKE STANDARD TABLE OF PCKDES_LINE,
      PCKDES_TEXT_TAB_BEFORE_MOD LIKE STANDARD TABLE OF PCKDES_LINE,
      PCKDES_FIELD               LIKE LINE.
*&---------------------------------------------------------------------*
*& CONSTANTS DECLARATION
*&---------------------------------------------------------------------*
CONSTANTS: GC_PACKAGE_MODE_DISPLAY TYPE I VALUE 1,
           GC_PACKAGE_MODE_CREATE  TYPE I VALUE 2,
           GC_PACKAGE_MODE_CHANGE  TYPE I VALUE 3.
*&---------------------------------------------------------------------*
*& Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 0121 AS SUBSCREEN.
  SELECT-OPTIONS : P_PKNAME FOR GV_PACKAGE_NAME_DUMMY.
SELECTION-SCREEN END OF SCREEN 0121.

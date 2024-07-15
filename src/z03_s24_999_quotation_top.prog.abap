*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_QUOTATION_TOP
*&---------------------------------------------------------------------*
*---------------------------------------------------------------------*
* TYPE Declaration
*---------------------------------------------------------------------*

* TYPE Declaration for Y03S24999_QUOTA Table
TYPES: BEGIN OF TY_QUOTATION,
         ID                   TYPE Y03S24999_QUOTA-ID,
         QUOTATION_CODE       TYPE Y03S24999_QUOTA-QUOTATION_CODE,
         CUSTOMER             TYPE Y03S24999_QUOTA-CUSTOMER,
         STAFF                TYPE Y03S24999_QUOTA-STAFF,
         STATUS               TYPE Y03S24999_QUOTA-STATUS,
         PACKAGE_NAME         TYPE Y03S24999_PACKGE-NAME,
         PCKIMG_URL           TYPE Y03S24999_PCKIMG-IMAGE_URL,
         EXPIRED_ON           TYPE Y03S24999_QUOTA-EXPIRED_ON,
         EXPIRED_AT           TYPE Y03S24999_QUOTA-EXPIRED_AT,
         CREATED_BY           TYPE Y03S24999_QUOTA-CREATED_BY,
         CREATED_AT           TYPE Y03S24999_QUOTA-CREATED_AT,
         CREATED_ON           TYPE Y03S24999_QUOTA-CREATED_ON,
         UPDATED_BY           TYPE Y03S24999_QUOTA-UPDATED_BY,
         UPDATED_AT           TYPE Y03S24999_QUOTA-UPDATED_AT,
         UPDATED_ON           TYPE Y03S24999_QUOTA-UPDATED_ON,
         LINE_COLOR           TYPE LVC_T_SCOL,
         QUOVER_ID            TYPE Y03S24999_QUOVER-ID,
         QUOVER_VERSION_ORDER TYPE Y03S24999_QUOVER-VERSION_ORDER,
         QUOVER_CREATED_ON    TYPE Y03S24999_QUOVER-CREATED_ON,
         QUOVER_CREATED_AT    TYPE Y03S24999_QUOVER-CREATED_AT,
       END OF TY_QUOTATION.
* TYPE Declaration for Quotation Status Color
TYPES: BEGIN OF TY_QUOTATION_COLOR,
         STATUS TYPE Y03S24999_QUOTA-STATUS.
         INCLUDE TYPE LVC_S_COLO.
TYPES END OF TY_QUOTATION_COLOR.
* TYPE Declaration for Y03S24999_PCKPRV Table
TYPES: BEGIN OF TY_QVSPRV,
         ID                   TYPE Y03S24999_QVSPRV-ID,
         QUOTATION_VERSION_ID TYPE Y03S24999_QUOVER-ID,
         PRODUCT_VARIANT_ID   TYPE Y03S24999_PROVRT-ID,
         SEL                  TYPE C,
         PRODUCT_ID           TYPE Y03S24999_PRODCT-ID,
         PRODUCT_NAME         TYPE Y03S24999_PRODCT-PRODUCT_NAME,
         VARIANT_CODE         TYPE Y03S24999_PROVRT-VARIANT_CODE,
         PRICE                TYPE Y03S24999_QVSPRV-PRICE,
         QUANTITY             TYPE Y03S24999_QVSPRV-QUANTITY,
         TOTAL_PRICE          TYPE Y03S24999_PROVRT-DISPLAY_PRICE,
         CREATED_BY           TYPE Y03S24999_QVSPRV-CREATED_BY,
         CREATED_AT           TYPE Y03S24999_QVSPRV-CREATED_AT,
         CREATED_ON           TYPE Y03S24999_QVSPRV-CREATED_ON,
         UPDATED_BY           TYPE Y03S24999_QVSPRV-UPDATED_BY,
         UPDATED_AT           TYPE Y03S24999_QVSPRV-UPDATED_AT,
         UPDATED_ON           TYPE Y03S24999_QVSPRV-UPDATED_ON,
       END OF TY_QVSPRV.
* TYPE Declaration for Y03S24999_QVSSER Table
TYPES: BEGIN OF TY_QVSSER,
         ID                   TYPE Y03S24999_QVSSER-ID,
         QUOTATION_VERSION_ID TYPE Y03S24999_QUOVER-ID,
         SERVICE_ID           TYPE Y03S24999_QVSSER-ID,
         SEL                  TYPE C,
         SERVICE_NAME         TYPE Y03S24999_SERVCE-NAME,
         PRICE                TYPE Y03S24999_QVSSER-PRICE,
         CREATED_BY           TYPE Y03S24999_QVSSER-CREATED_BY,
         CREATED_AT           TYPE Y03S24999_QVSSER-CREATED_AT,
         CREATED_ON           TYPE Y03S24999_QVSSER-CREATED_ON,
         UPDATED_BY           TYPE Y03S24999_QVSSER-UPDATED_BY,
         UPDATED_AT           TYPE Y03S24999_QVSSER-UPDATED_AT,
         UPDATED_ON           TYPE Y03S24999_QVSSER-UPDATED_ON,
       END OF TY_QVSSER.
* TYPE Declaration for Y03S24999_QUOMSG Table
TYPES: BEGIN OF TY_QUOMSG,
         ID                  TYPE Y03S24999_QUOMSG-ID,
         QUOTATION_ID        TYPE Y03S24999_QUOMSG-QUOTATION_ID,
         IS_CUSTOMER_MESSAGE TYPE Y03S24999_QUOMSG-IS_CUSTOMER_MESSAGE,
         USER_SENDING        TYPE CHAR20,
         CONTENT             TYPE Y03S24999_QUOMSG-CONTENT,
         CREATED_BY          TYPE Y03S24999_QUOMSG-CREATED_BY,
         CREATED_AT          TYPE Y03S24999_QUOMSG-CREATED_AT,
         CREATED_ON          TYPE Y03S24999_QUOMSG-CREATED_ON,
         UPDATED_BY          TYPE Y03S24999_QUOMSG-UPDATED_BY,
         UPDATED_AT          TYPE Y03S24999_QUOMSG-UPDATED_AT,
         UPDATED_ON          TYPE Y03S24999_QUOMSG-UPDATED_ON,
       END OF TY_QUOMSG.
* TYPE Declaration for Y03S24999_QUOVER Table for 0134 Modal Dialog Box
TYPES: BEGIN OF TY_QUOVER_0134,
         ID            TYPE Y03S24999_QUOVER-ID,
         QUOTATION_ID  TYPE Y03S24999_QUOVER-QUOTATION_ID,
         VERSION_ORDER TYPE Y03S24999_QUOVER-VERSION_ORDER,
         TOTAL_PRICE   TYPE Y03S24999_QUOVER-TOTAL_PRICE,
         CREATED_BY    TYPE Y03S24999_QUOVER-CREATED_BY,
         CREATED_AT    TYPE Y03S24999_QUOVER-CREATED_AT,
         CREATED_ON    TYPE Y03S24999_QUOVER-CREATED_ON,
         UPDATED_BY    TYPE Y03S24999_QUOVER-UPDATED_BY,
         UPDATED_AT    TYPE Y03S24999_QUOVER-UPDATED_AT,
         UPDATED_ON    TYPE Y03S24999_QUOVER-UPDATED_ON,
       END OF TY_QUOVER_0134.
* TYPE Declaration for Y03S24999_PRODCT Table for 0137 Modal Dialog Box
TYPES: BEGIN OF TY_PRODUCT_0137,
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
       END OF TY_PRODUCT_0137.
* TYPE Declaration for Y03S24999_PROVRT Table for 0136 Modal Dialog Box
TYPES: BEGIN OF TY_PROVRT_0136,
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
       END OF TY_PROVRT_0136.
* TYPE Declaration for Y03S24999_PROATV Table for 0135 Modal Dialog Box
TYPES: BEGIN OF TY_PROATV_0135,
         ID             TYPE Y03S24999_PROATV-ID,
         ATTRIBUTE_NAME TYPE Y03S24999_PROATR-ATTRIBUTE_NAME,
         VALUE          TYPE Y03S24999_PROATV-VALUE,
       END OF TY_PROATV_0135.
* TYPE Declaration for Y03S24999_SERVCE Table for 0138 Modal Dialog Box
TYPES: BEGIN OF TY_SERVICE_0138,
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
       END OF TY_SERVICE_0138.
*---------------------------------------------------------------------*
* CLASS Definition
*---------------------------------------------------------------------*
CLASS CL_QUOTATION_ALV_HANDLER DEFINITION.
  PUBLIC SECTION.

    METHODS HOTSPOT_CLICK FOR EVENT HOTSPOT_CLICK OF CL_GUI_ALV_GRID
      IMPORTING
        E_ROW_ID
        E_COLUMN_ID
        ES_ROW_NO.

ENDCLASS.
* CLASS CL_QUOTATION_PROVRT_ALV_HANDLER
* DEFINITION
CLASS CL_QUOTA_PROVRT_ALV_HANDLER DEFINITION.
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
DATA: GV_OKCODE_0133 TYPE SYST-UCOMM.
DATA: GV_OKCODE_0134 TYPE SYST-UCOMM.
DATA: GV_OKCODE_0135 TYPE SYST-UCOMM.
DATA: GV_OKCODE_0136 TYPE SYST-UCOMM.
DATA: GV_OKCODE_0137 TYPE SYST-UCOMM.
DATA: GV_OKCODE_0138 TYPE SYST-UCOMM.

DATA: GV_QUOMSG_CONTENT TYPE Y03S24999_QUOMSG-CONTENT.
DATA: QCODE_DUMMY TYPE Y03S24999_QUOTA-QUOTATION_CODE.

* Internal Table Declaration for QUOTATION Table
DATA: IT_QUOTATION TYPE STANDARD TABLE OF TY_QUOTATION.

* Status Color Table
DATA: GT_QUOTATION_COLOR TYPE STANDARD TABLE OF TY_QUOTATION_COLOR.

* ALV Table Object
DATA: O_QUOTATION_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_QUOTATION_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID,
      O_QUOTATION_HANDLER   TYPE REF TO CL_QUOTATION_ALV_HANDLER.

DATA: QUOTATION_SCREEN_MODE TYPE C LENGTH 4 VALUE '0130'.

DATA: GV_QUOTATION_ID TYPE Y03S24999_QUOTA-ID.
DATA: GV_QUOVER_ID TYPE Y03S24999_QUOVER-ID.

DATA: GV_QUOTATION_SCREEN_MODE TYPE I.
DATA: GS_QUOTATION_DETAIL_BEFORE_MOD TYPE TY_QUOTATION.
DATA: GS_QUOTATION_DETAIL TYPE TY_QUOTATION.

DATA: GS_QVSPRV            TYPE TY_QVSPRV.
DATA: GT_QVSPRV            TYPE STANDARD TABLE OF TY_QVSPRV WITH KEY ID QUOTATION_VERSION_ID PRODUCT_VARIANT_ID.
DATA: GT_QVSPRV_BEFORE_MOD TYPE STANDARD TABLE OF TY_QVSPRV WITH KEY ID QUOTATION_VERSION_ID PRODUCT_VARIANT_ID.

DATA: GS_QVSSER            TYPE TY_QVSSER.
DATA: GT_QVSSER            TYPE STANDARD TABLE OF TY_QVSSER WITH KEY ID QUOTATION_VERSION_ID SERVICE_ID.
DATA: GT_QVSSER_BEFORE_MOD TYPE STANDARD TABLE OF TY_QVSSER WITH KEY ID QUOTATION_VERSION_ID SERVICE_ID.

DATA: GS_QUOMSG            TYPE TY_QUOMSG.
DATA: GT_QUOMSG            TYPE STANDARD TABLE OF TY_QUOMSG WITH KEY ID QUOTATION_ID.

DATA: GV_QVSPRV_TOTAL_PRICE  TYPE Y03S24999_PROVRT-DISPLAY_PRICE VALUE 0.
DATA: GV_QVSSER_TOTAL_PRICE  TYPE Y03S24999_SERVCE-DISPLAY_PRICE VALUE 0.
DATA: GV_QUOVER_TOTAL_PRICE  TYPE Y03S24999_PROVRT-DISPLAY_PRICE VALUE 0.

CONTROLS: QVSPRV_TABLE_CONTROL TYPE TABLEVIEW USING SCREEN 0139.
CONTROLS: QVSSER_TABLE_CONTROL TYPE TABLEVIEW USING SCREEN 0139.
CONTROLS: QUOMSG_TABLE_CONTROL TYPE TABLEVIEW USING SCREEN 0139.

DATA GV_QUOPCKIMG_URL TYPE CNDP_URL.
DATA QUOPCKIMG_CONTROL TYPE REF TO CL_GUI_PICTURE.
DATA QUOPCKIMG_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER.
DATA QUOPCKIMG_EVENT_RECEIVER  TYPE REF TO C_EVENT_RECEIVER_QUOTA.
DATA QUOPCKIMG_EVENT_TAB TYPE CNTL_SIMPLE_EVENTS.
DATA QUOPCKIMG_EVENT_TAB_LINE TYPE CNTL_SIMPLE_EVENT.
DATA QUOPCKIMG_RETURN TYPE I.

* Internal Table Declaration for QUOVER_0134 Table
DATA: IT_QUOVER_0134 TYPE STANDARD TABLE OF TY_QUOVER_0134.

* QUOVER_0134 ALV Table Object
DATA: O_QUOVER_0134_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_QUOVER_0134_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID.

* Internal Table Declaration for PRODUCT_0137 Table
DATA: IT_PRODUCT_0137 TYPE STANDARD TABLE OF TY_PRODUCT_0137.

* PRODUCT_0137 ALV Table Object
DATA: O_PRODUCT_0137_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_PRODUCT_0137_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID.

* Internal Table Declaration for PROVRT_0136 Table
DATA: IT_PROVRT_0136 TYPE STANDARD TABLE OF TY_PROVRT_0136.

* PRODUCT_0136 ALV Table Object
DATA: O_PROVRT_0136_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_PROVRT_0136_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID,
      O_PROVRT_0136_HANDLER   TYPE REF TO CL_QUOTA_PROVRT_ALV_HANDLER.

* Internal Table Declaration for SERVICE_0138 Table
DATA: IT_SERVICE_0138 TYPE STANDARD TABLE OF TY_SERVICE_0138.

* SERVICE_0138 ALV Table Object
DATA: O_SERVICE_0138_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_SERVICE_0138_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID.

* Internal Table Declaration for PROATV_0135 Table
DATA: IT_PROATV_0135 TYPE STANDARD TABLE OF TY_PROATV_0135.

* PROATV_0135 ALV Table Object
DATA: O_PROATV_0135_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_PROATV_0135_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID.

DATA: CTRDES_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      CTRDES_EDITOR    TYPE REF TO CL_GUI_TEXTEDIT.

DATA: CTRDES_LINE     TYPE C LENGTH 256,
      CTRDES_TEXT_TAB LIKE STANDARD TABLE OF CTRDES_LINE,
      CTRDES_FIELD    LIKE LINE.
*&---------------------------------------------------------------------*
*& CONSTANTS DECLARATION
*&---------------------------------------------------------------------*
CONSTANTS: GC_QUOTATION_MODE_DISPLAY TYPE I VALUE 1,
           GC_QUOTATION_MODE_CREATE  TYPE I VALUE 2,
           GC_QUOTATION_MODE_CHANGE  TYPE I VALUE 3.
*&---------------------------------------------------------------------*
*& Selection Screen
*&---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 0131 AS SUBSCREEN.
  SELECT-OPTIONS : P_QCODE FOR QCODE_DUMMY.
SELECTION-SCREEN END OF SCREEN 0131.

*&---------------------------------------------------------------------*
*& Include          Z03_S24_CUST_QUOTA_TOP
*&---------------------------------------------------------------------*

*---------------------------------------------------------------------*
* TYPES DECLARATIONS
*---------------------------------------------------------------------*
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

TYPES: BEGIN OF TY_QUOTATION_COLOR,
         STATUS TYPE Y03S24999_QUOTA-STATUS.
         INCLUDE TYPE LVC_S_COLO.
TYPES END OF TY_QUOTATION_COLOR.

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

TYPES: BEGIN OF TY_QUOMSG,
         ID                   TYPE Y03S24999_QUOMSG-ID,
         QUOTATION_ID         TYPE Y03S24999_QUOMSG-QUOTATION_ID,
         IS_CUSTOMER_MESSAGE  TYPE Y03S24999_QUOMSG-IS_CUSTOMER_MESSAGE,
         USER_SENDING         TYPE CHAR20,
         CONTENT              TYPE Y03S24999_QUOMSG-CONTENT,
         CREATED_BY           TYPE Y03S24999_QUOMSG-CREATED_BY,
         CREATED_AT           TYPE Y03S24999_QUOMSG-CREATED_AT,
         CREATED_ON           TYPE Y03S24999_QUOMSG-CREATED_ON,
         UPDATED_BY           TYPE Y03S24999_QUOMSG-UPDATED_BY,
         UPDATED_AT           TYPE Y03S24999_QUOMSG-UPDATED_AT,
         UPDATED_ON           TYPE Y03S24999_QUOMSG-UPDATED_ON,
       END OF TY_QUOMSG.

*---------------------------------------------------------------------*
* CLASS Definition
*---------------------------------------------------------------------*



*---------------------------------------------------------------------*
* DATA DECLARATIONS
*---------------------------------------------------------------------*
DATA: GV_USERNAME TYPE Y03S24999_USER-USERNAME.
DATA: GV_OKCODE TYPE SYST-UCOMM.
DATA: QCODE_DUMMY TYPE Y03S24999_QUOTA-QUOTATION_CODE.
DATA: QUOTATION_SCREEN_MODE TYPE C LENGTH 4 VALUE '0100'.
DATA: IT_QUOTATION TYPE STANDARD TABLE OF TY_QUOTATION.
DATA: O_QUOTATION_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER,
      O_QUOTATION_ALV_TABLE TYPE REF TO CL_GUI_ALV_GRID.
DATA: GT_QUOTATION_COLOR TYPE STANDARD TABLE OF TY_QUOTATION_COLOR.
DATA: GV_QUOTATION_SCREEN_MODE TYPE I.
DATA: GV_QUOTATION_ID TYPE Y03S24999_QUOTA-ID.
DATA: GV_QUOVER_ID TYPE Y03S24999_QUOVER-ID.
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

CONTROLS: QVSPRV_TABLE_CONTROL TYPE TABLEVIEW USING SCREEN 0200.
CONTROLS: QVSSER_TABLE_CONTROL TYPE TABLEVIEW USING SCREEN 0200.
CONTROLS: QUOMSG_TABLE_CONTROL TYPE TABLEVIEW USING SCREEN 0200.

DATA: BEGIN OF G_ZTAB,
       SUBSCREEN   LIKE SY-DYNNR,
       PROG        LIKE SY-REPID VALUE 'Z03_S24_CUST_QUOTA',
      END OF G_ZTAB.

*DATA GV_QUOPCKIMG_URL TYPE CNDP_URL.
*DATA QUOPCKIMG_CONTROL TYPE REF TO CL_GUI_PICTURE.
*DATA QUOPCKIMG_CONTAINER TYPE REF TO CL_GUI_CUSTOM_CONTAINER.
*DATA QUOPCKIMG_EVENT_RECEIVER  TYPE REF TO C_EVENT_RECEIVER.
*DATA QUOPCKIMG_EVENT_TAB TYPE CNTL_SIMPLE_EVENTS.
*DATA QUOPCKIMG_EVENT_TAB_LINE TYPE CNTL_SIMPLE_EVENT.
*DATA QUOPCKIMG_RETURN TYPE I.

*---------------------------------------------------------------------*
* SELECTION SCREEN
*---------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF SCREEN 0110 AS SUBSCREEN.
  SELECT-OPTIONS : P_QCODE FOR QCODE_DUMMY.
SELECTION-SCREEN END OF SCREEN 0110.

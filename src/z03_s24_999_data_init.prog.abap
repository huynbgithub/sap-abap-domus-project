*&---------------------------------------------------------------------*
*& Report Z03_S24_999_DATA_INIT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z03_S24_999_DATA_INIT.

*INCLUDE Z03_S24_999_DATA_INIT_CURR.
*INCLUDE Z03_S24_999_DATA_INIT_PROCAT.
*INCLUDE Z03_S24_999_DATA_INIT_PRODCT.
*INCLUDE Z03_S24_999_DATA_EDIT_PRODCT.
*INCLUDE Z03_S24_999_DATA_INIT_PROVRT.
*INCLUDE Z03_S24_999_DATA_INIT_PRVIMG.

*INSERT Y03S24999_
*       FROM TABLE @( VALUE #(
*                              ( ID = '' NAME = '' )
*                             )
*                    ).
*IF SY-SUBRC <> 0.
*  MESSAGE 'Insert failed.' TYPE 'E'.
*ELSE.
*  MESSAGE 'Insert successfully.' TYPE 'S'.
*ENDIF.

*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_INIT_USER
*&---------------------------------------------------------------------*
INSERT Y03S24999_USER
       FROM TABLE @( VALUE #(
( ID = 'C71BE31E-D307-48E5-1E77-08DC47CC8AD3' USERNAME = 'DEVELOPER' IS_CUSTOMER = 'X' IS_STAFF = 'X' IS_ADMIN = 'X' )
                             )
                    ).
IF SY-SUBRC <> 0.
  MESSAGE 'Insert failed.' TYPE 'E'.
ELSE.
  MESSAGE 'Insert successfully.' TYPE 'S'.
ENDIF.

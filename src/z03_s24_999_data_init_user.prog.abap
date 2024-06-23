*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_INIT_USER
*&---------------------------------------------------------------------*
INSERT Y03S24999_USER
       FROM TABLE @( VALUE #(
( ID = '9BEE30C1-24E0-48BA-1E78-08DC47CC8AD2' USERNAME = 'DEV-000' )
( ID = '5A184225-8D77-48D9-1E74-08DC47CC8AD2' USERNAME = 'DEV-091' IS_CUSTOMER = 'X' IS_STAFF = 'X' IS_ADMIN = 'X' )
( ID = '75852C6E-82F4-44E4-1E75-08DC47CC8AD2' USERNAME = 'DEV-092' IS_CUSTOMER = 'X' IS_STAFF = 'X' IS_ADMIN = 'X' )
( ID = '5B8B77EF-B2AA-4791-1E76-08DC47CC8AD2' USERNAME = 'DEV-093' IS_CUSTOMER = 'X' IS_STAFF = 'X' IS_ADMIN = 'X' )
( ID = 'E71BE31E-D307-48E5-1E77-08DC47CC8AD2' USERNAME = 'DEV-094' IS_CUSTOMER = 'X' IS_STAFF = 'X' IS_ADMIN = 'X' )
                             )
                    ).
IF SY-SUBRC <> 0.
  MESSAGE 'Insert failed.' TYPE 'E'.
ELSE.
  MESSAGE 'Insert successfully.' TYPE 'S'.
ENDIF.

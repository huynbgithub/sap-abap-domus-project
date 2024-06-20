*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_INIT_CURR
*&---------------------------------------------------------------------*
INSERT Y03S24999_CURR
       FROM TABLE @( VALUE #(
                              ( ID = '96606BD2-4470-488A-7B0E-08DC44C386C1' CURRENCY = 'VND' )
                             )
                    ).
IF SY-SUBRC <> 0.
  MESSAGE 'Insert failed.' TYPE 'E'.
ELSE.
  MESSAGE 'Insert successfully.' TYPE 'S'.
ENDIF.

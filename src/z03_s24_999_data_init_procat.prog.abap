*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_INIT_PROCAT
*&---------------------------------------------------------------------*

INSERT Y03S24999_PROCAT
       FROM TABLE @( VALUE #(
                              ( ID = 'A72B3FB4-D22E-4D41-8169-180405FEDB12' NAME = 'Lamp' )
                              ( ID = 'B1BFA1AB-4884-4707-8254-3D1C89245B38' NAME = 'Rug' )
                              ( ID = 'CEC8C874-4773-4057-B992-5A1B9F7DA577' NAME = 'Bed' )
                              ( ID = '975F5272-442E-47F6-95B3-5D874DA53156' NAME = 'Pantry' )
                              ( ID = 'B4672BBE-46BF-4A7F-8282-621A9538A8A5' NAME = 'Kitchen cabinet' )
                              ( ID = 'C5E2952C-9448-454A-9EBF-D32F3CD8072B' NAME = 'Indoor' )
                              ( ID = '47FD45F2-5A2B-464E-8F91-DA3F649855F2' NAME = 'Sofa' )
                              ( ID = 'A1DD83BA-4414-4BB4-90B5-F0320DDBF1FB' NAME = 'Tv-Stands' )
                              ( ID = 'F71C0730-B273-4363-9573-F9D7B01132DF' NAME = 'Book-shelf' )
                             )
                    ).
IF SY-SUBRC <> 0.
  MESSAGE 'Insert failed.' TYPE 'E'.
ELSE.
  MESSAGE 'Insert successfully.' TYPE 'S'.
ENDIF.

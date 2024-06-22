*&---------------------------------------------------------------------*
*& Include          Z03_S24_999_DATA_INIT_SERVCE
*&---------------------------------------------------------------------*

INSERT Y03S24999_SERVCE
       FROM TABLE @( VALUE #(
                              ( ID = '25DF20FB-915B-449D-A265-08DC255F6E0F' NAME = 'Trasportation within VietNam' DISPLAY_PRICE = '5000000' IS_DELETED = 'X' )
                              ( ID = 'CD0BF091-D0E8-4747-A266-08DC255F6E0F' NAME = 'Trasportation within Ho Chi Minh city' DISPLAY_PRICE = '100000' IS_DELETED = 'X' )
                              ( ID = '6C745475-6B46-41C2-2AE6-08DC3155B379' NAME = 'Wall Paiting' DISPLAY_PRICE = '9877000' IS_DELETED = '' )
                              ( ID = '397D7F86-5DAE-4F0A-2AE7-08DC3155B379' NAME = 'Ceil Roofing' DISPLAY_PRICE = '4961000' IS_DELETED = '' )
                              ( ID = '6B7546E9-DD8B-410D-BED1-08DC45A5F93E' NAME = 'Đập tường sơn gạch' DISPLAY_PRICE = '1000000' IS_DELETED = 'X' )
                              ( ID = '882243BD-A791-41D1-BED2-08DC45A5F93E' NAME = 'Sơn gỗ' DISPLAY_PRICE = '1000000' IS_DELETED = 'X' )
                              ( ID = '7DD5CF6F-995C-44C6-BED3-08DC45A5F93E' NAME = 'Độ nội thất' DISPLAY_PRICE = '9999999' IS_DELETED = 'X' )
                              ( ID = 'BF62FAE5-2C54-452F-BED4-08DC45A5F93E' NAME = 'Độ nội thất' DISPLAY_PRICE = '9999999' IS_DELETED = 'X' )
                              ( ID = '652593AE-ADF4-4FE7-BED5-08DC45A5F93E' NAME = 'Độ nội thất' DISPLAY_PRICE = '21312312' IS_DELETED = 'X' )
                              ( ID = '93A0DCF0-ABE4-4D75-AA20-08DC463BEB47' NAME = 'Độ nội thất' DISPLAY_PRICE = '123124' IS_DELETED = 'X' )
                              ( ID = 'BA3D0D0E-6268-4CFF-AA21-08DC463BEB47' NAME = 'Độ nội thất' DISPLAY_PRICE = '900000' IS_DELETED = 'X' )
                              ( ID = '85ADDD3C-4F37-4E48-4FFE-08DC4676AF56' NAME = 'Độ nội thất' DISPLAY_PRICE = '11' IS_DELETED = 'X' )
                              ( ID = 'DD4B1221-B489-42A1-8420-08DC48086BEC' NAME = 'Floor Carpeting' DISPLAY_PRICE = '7000000' IS_DELETED = '' )
                              ( ID = 'C82FC5A8-886B-4E6C-8421-08DC48086BEC' NAME = 'Moisture Tiling' DISPLAY_PRICE = '21000000' IS_DELETED = '' )
                              ( ID = '97E47AAD-21F4-430E-F159-08DC48A67FE2' NAME = 'Độ nội thất' DISPLAY_PRICE = '10000' IS_DELETED = 'X' )
                             )
                    ).
IF SY-SUBRC <> 0.
  MESSAGE 'Insert failed.' TYPE 'E'.
ELSE.
  MESSAGE 'Insert successfully.' TYPE 'S'.
ENDIF.

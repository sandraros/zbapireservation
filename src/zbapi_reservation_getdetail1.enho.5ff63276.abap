"Name: \FU:BAPI_RESERVATION_GETDETAIL1\SE:END\EI
ENHANCEMENT 0 ZBAPI_RESERVATION_GETDETAIL1.
  zcl_bapi_reservation_getdetail=>end_of_bapi_reser_getdetail1(
    EXPORTING
      reservation  = reservation
    IMPORTING
      extensionout = extensionout[] ).
ENDENHANCEMENT.

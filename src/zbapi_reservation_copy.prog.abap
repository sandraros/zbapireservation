*&---------------------------------------------------------------------*
*& Report zbapi_reservation_copy
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zbapi_reservation_copy.

PARAMETERS p_rsnum TYPE rkpf-rsnum.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_rsnum.
  CALL FUNCTION 'MB_SELECT_RESERVATION'
    EXPORTING
      hilfe = 'HLPR'
    IMPORTING
      rsnum = p_rsnum.

START-OF-SELECTION.

  DATA: sl_header_detail TYPE bapi2093_res_head_detail,
        tl_postes_detail TYPE TABLE OF bapi2093_res_item_detail,
        tl_return        TYPE TABLE OF bapiret2,
        tl_extensionout  TYPE TABLE OF bapiparex.

  CALL FUNCTION 'BAPI_RESERVATION_GETDETAIL1'
    EXPORTING
      reservation        = p_rsnum
    IMPORTING
      reservation_header = sl_header_detail
    TABLES
      reservation_items  = tl_postes_detail
      return             = tl_return
      extensionout       = tl_extensionout.

  IF 0 = REDUCE i( INIT i = 0 FOR <m> IN tl_return WHERE ( type CA 'AEX' ) NEXT i = i + 1 ).

    DATA: sl_header      TYPE bapi2093_res_head,
          tl_postes      TYPE TABLE OF bapi2093_res_item,
          tl_segments    TYPE TABLE OF bapi_profitability_segment,
          tl_extensionin TYPE TABLE OF bapiparex,
          vl_reservation TYPE  bapi2093_res_key-reserv_no.

    sl_header = CORRESPONDING #( sl_header_detail ).
    tl_postes = CORRESPONDING #( tl_postes_detail MAPPING entry_qnt = quantity ).
    tl_extensionin = tl_extensionout.
    CALL FUNCTION 'BAPI_RESERVATION_CREATE1'
      EXPORTING
        reservationheader    = sl_header
      IMPORTING
        reservation          = vl_reservation
      TABLES
        reservationitems     = tl_postes
        profitabilitysegment = tl_segments " <======= ?
        return               = tl_return
        extensionin          = tl_extensionin.
    IF 0 = REDUCE i( INIT i = 0 FOR <m> IN tl_return WHERE ( type CA 'AEX' ) NEXT i = i + 1 ).

      DATA: sl_return TYPE bapiret2.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait   = 'X'
        IMPORTING
          return = sl_return.

    ENDIF.
  ENDIF.

  DATA(result) = COND string( WHEN 0 = REDUCE i( INIT i = 0 FOR <m> IN tl_return WHERE ( type CA 'AEX' ) NEXT i = i + 1 )
                        THEN |Created: { vl_reservation }|
                        ELSE 'Failed' ).

  cl_demo_output=>new( )->write_data( result )->write_data( tl_return )->write_data( sl_return )->display( ).

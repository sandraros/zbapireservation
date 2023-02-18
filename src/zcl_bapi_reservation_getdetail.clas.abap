CLASS zcl_bapi_reservation_getdetail DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES ty_table_extensionout TYPE STANDARD TABLE OF bapiparex WITH DEFAULT KEY.

    CLASS-METHODS end_of_bapi_reser_getdetail1
      IMPORTING
        reservation  TYPE bapi2093_res_key-reserv_no
      EXPORTING
        extensionout TYPE ty_table_extensionout.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_bapi_reservation_getdetail IMPLEMENTATION.
  METHOD end_of_bapi_reser_getdetail1.
    TYPES: BEGIN OF ty_valueparts,
             structure TYPE te_struc,
             BEGIN OF parts,
               _1 TYPE valuepart,
               _2 TYPE valuepart,
               _3 TYPE valuepart,
               _4 TYPE valuepart,
             END OF parts,
           END OF ty_valueparts.
    DATA: zbapi_te_rkpf       TYPE zbapi_te_rkpf,
          table_zbapi_te_resb TYPE TABLE OF zbapi_te_resb.

    SELECT SINGLE *
        FROM rkpf
        WHERE rsnum = @reservation
        INTO CORRESPONDING FIELDS OF @zbapi_te_rkpf.
    IF sy-subrc = 0.
      " ORDER BY is used to make "ZBAPI_TE_RESB" lines in EXTENSIONOUT ordered as
      " RESERVATION_ITEMS lines, so that it's aligned with BAPI_RESERVATION_CREATE1 whose lines
      " "ZBAPI_TE_RESB" of EXTENSIONIN and RESERVATIONITEMS must respect the same logic.
      SELECT *
          FROM resb
          WHERE rsnum = @reservation
          ORDER BY PRIMARY KEY
          INTO CORRESPONDING FIELDS OF TABLE @table_zbapi_te_resb.
      IF sy-subrc = 0.
        extensionout[] = VALUE #(
            ( CONV #( VALUE ty_valueparts(
              structure  = 'ZBAPI_TE_RKPF'
              parts      = CONV #( CORRESPONDING zbapi_te_rkpf( zbapi_te_rkpf ) ) ) ) )
            ( LINES OF VALUE bapiparextab(
              FOR <zbapi_te_resb> IN table_zbapi_te_resb
              ( CONV #( VALUE ty_valueparts(
                structure = 'ZBAPI_TE_RESB'
                parts     = CONV #( CORRESPONDING zbapi_te_resb( <zbapi_te_resb> ) ) ) ) ) ) ) ).
      ENDIF.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

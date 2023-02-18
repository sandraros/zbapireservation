class ZCL_IM_MB_RES_BAPI_CREATE1 definition
  public
  final
  create public .

public section.

  interfaces IF_EX_MB_RES_BAPI_CREATE1 .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_MB_RES_BAPI_CREATE1 IMPLEMENTATION.


  METHOD if_ex_mb_res_bapi_create1~extensionin_to_resb.
    TYPES: BEGIN OF ty_valueparts,
             structure TYPE te_struc,
             BEGIN OF parts,
               _1 TYPE valuepart,
               _2 TYPE valuepart,
               _3 TYPE valuepart,
               _4 TYPE valuepart,
             END OF parts,
           END OF ty_valueparts.
    DATA(resb_index) = 0.
    LOOP AT it_extension_in ASSIGNING FIELD-SYMBOL(<extensionin>).
      CASE <extensionin>-structure.
        WHEN 'ZBAPI_TE_RKPF'.
          DATA(zbapi_te_rkpf) = CONV zbapi_te_rkpf( LET aux_valueparts = CONV ty_valueparts( <extensionin> ) IN aux_valueparts-parts ).
          MOVE-CORRESPONDING zbapi_te_rkpf TO cs_rkpf.
        WHEN 'ZBAPI_TE_RESB'.
          DATA(zbapi_te_resb) = CONV zbapi_te_resb( LET aux_valueparts = CONV ty_valueparts( <extensionin> ) IN aux_valueparts-parts ).
          ADD 1 TO resb_index.
          ASSIGN resb[ resb_index ] TO FIELD-SYMBOL(<resb>).
          IF sy-subrc = 0.
            MOVE-CORRESPONDING zbapi_te_resb TO <resb>.
          ENDIF.
      ENDCASE.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

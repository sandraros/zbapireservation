# zbapireservation
Program ZBAPI_RESERVATION_COPY to copy an existing reservation via BAPI_RESERVATION_GETDETAIL1 and BAPI_RESERVATION_CREATE1 for testing and debugging purpose ONLY.

It also provides code and structures to extend BAPI_RESERVATION_GETDETAIL1 and BAPI_RESERVATION_CREATE1 to copy custom fields from the tables RKPF and RESB. You need to define the custom fields in the structures ZBAPI_TE_RKPF and ZBAPI_TE_RESB (replace the components provided in the repository).

List of objects:
- PROG ZBAPI_RESERVATION_COPY      
- ENHO ZBAPI_RESERVATION_GETDETAIL1      
- TABL ZBAPI_TE_RESB      
- TABL ZBAPI_TE_RKPF      
- CLAS ZCL_BAPI_RESERVATION_GETDETAIL      
- CLAS ZCL_IM_MB_RES_BAPI_CREATE1
- SXCI ZMB_RES_BAPI_CREATE1  

Explained in blog post here: https://blogs.sap.com/2023/02/15/short-snippet-bapi_reservation_create1/

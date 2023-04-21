// Programa   : TESTSPILT
// Fecha/Hora : 15/06/2017 01:10:50
// Propósito  :
// Creado Por :
// Llamado por:
// Aplicación :
// Tabla      :

#INCLUDE "DPXBASE.CH"

PROCE MAIN()
 
   local cTitle := "Testing the Splitter controls"
 
   CLOSE ALL

   PUBLICO("oWnd")
   PUBLICO("oLbx")
   PUBLICO("oLbx2")

   PUBLICO("oSplit")
   PUBLICO("oGet")


   DpMdi("cTitle","oMdi")
   oMdi:Windows(0,0,600,1010,.T.) // Maximizado

   oWnd:=oMdi:oWnd
 
   SELECT 1

   USE DATADBF\DPPROGRA.DBF
 
   @ 0,0 LISTBOX oMdi:oLbx FIELDS SIZE 0,200 PIXEL OF oMdi:oWnd
 
   @ 200,0 LISTBOX oMdi:oLbx2 FIELDS SIZE 200,400 PIXEL OF oMdi:oWnd
 
//oLbx:bChange:={|| oGet:Refresh() }
 
   @ 200,0  SPLITTER oMdi:oSplit ;
            HORIZONTAL ;
            PREVIOUS CONTROLS oMdi:oLbx ;
            HINDS CONTROLS oMdi:oLbx2 ;
            TOP MARGIN 80 ;
            BOTTOM MARGIN 80 ;
            SIZE 500, 4  PIXEL ;
            OF oMdi:oWnd ;
            _3DLOOK

  oMdi:oWnd:oClient := oMdi:oSplit


  oMdi:Activate({||oMdi:oSplit:AdjClient()})

RETURN
// EOF

// Programa   : CLNADMINISION
// Fecha/Hora : 29/08/2020 23:04:32
// Propósito  : Formulario de Admisión de Pacientes
// Creado Por : Juan Navas
// Llamado por: PlugIn Clínico
// Aplicación :
// Tabla      :

#include "DPXBASE.ch"

FUNCTION MAIN()
   local oMenu
   local cTitle := "Admisión"
   LOCAL aEsp   :={},aMedicos:={},aServicios:={},aPagos:={}
   LOCAL oFont,oFontB,oCol  
   LOCAL nValCam:=1,nColIsMon:=13,lCliente:=.T.
   LOCAL aCoors:=GetCoors( GetDesktopWindow() )
   LOCAL nAddH3:=0
   LOCAL aTotal:={}

   aEsp:=ASQL("SELECT DEP_DESCRI,COUNT(*) AS CUANTOS FROM DPDPTO LEFT JOIN DPPERSONAL ON DEP_CODIGO=PER_CODDEP WHERE DEP_ACTIVO=1 GROUP BY DEP_DESCRI")

   IF Empty(aEsp)
      aEsp:={}
      AADD(aEsp,{"Indefinido",0})
   ENDIF

   aMedicos:=GETMEDICOS(aEsp[1,1])

   IF Empty(aMedicos)
      aMedicos:={}
      AADD(aMedicos,{"Indefinido",0})
   ENDIF

   aServicios:=GETSERVICIOS(aEsp[1,1])

   aPagos    :=EJECUTAR("DPRECIBODIV_CAJBCO",NIL,"",nValCam,NIL,nColIsMon,lCliente)
   aTotal    :=ATOTALES(aPagos)

   MENU oMenu
        MENUITEM "&Opciones"
           MENU
               MENUITEM "&Info" ACTION MsgInfo("oAdmision:cInfo")
               MENUITEM "&Exit" ACTION oAdmision:Close()
           ENDMENU
   ENDMENU

  
   DpMDI(cTitle,"oAdmision","CLNADMINISION.EDT",NIL)

   oAdmision:Windows(0,0,aCoors[3]-170,aCoors[4]-20,.T.) // Maximizado

   oAdmision:lMsgBar:=.F.

   oAdmision:nTotal5 :=0
   oAdmision:nMontoBs:=0
   oAdmision:oBrwE:=NIL // Especialidad
   oAdmision:oBrwM:=NIL // Médicos
   oAdmision:oBrwP:=NIL // Pagos
   oAdmision:oBrwS:=NIL // Servicios

   oAdmision:nColSelP  :=7-1 // Seleccionar Pago
   oAdmision:nColCodMon:=8-1 // Código de Moneda
   oAdmision:nColCajBco:=9-1 // Caja/Banco

   oAdmision:nClrPane1 :=16774120
   oAdmision:nClrPane2 :=16771538

   oAdmision:nClrText1 :=CLR_BLUE // 6208256
   oAdmision:nClrText2 :=CLR_RED   // 16751157  // CLR_HRED // 8667648
   oAdmision:nClrText3 :=CLR_HBLUE // 32768
   oAdmision:nClrText4 :=CLR_GREEN // 10440704

   oAdmision:nColPorITG:=12-1        // % IGTF
   oAdmision:nColMtoITG:=13-1        // 13 Monto IGTF
   oAdmision:nColIsMon :=nColIsMon // Si es Mo
   oAdmision:nColIsMon:=nColIsMon

   oAdmision:nClrPane1:=oDp:nClrPane1
   oAdmision:nClrPane2:=oDp:nClrPane2

   @ 30,0 SAY oAdmision:oSay PROMPT "Multiples splitters" SIZE 130,100 PIXEL COLOR CLR_YELLOW,CLR_GREEN BORDER OF oAdmision:oWnd

   @ 135,0 BUTTON oAdmision:oBtn PROMPT "&Splitters ok" SIZE 130, 95 PIXEL ACTION MsgInfo("Splitters FiveWin") OF oAdmision:oWnd

   @ 236, 0 BITMAP oAdmision:oBmp SIZE 130,94 PIXEL FILE "bitmaps\barraaplicacion.BMP" ADJUST OF oAdmision:oWnd

   oAdmision:oBrwE:=TXBrowse():New( oAdmision:oWnd )
   oAdmision:oBrwE:SetArray( aEsp, .F. )
   oAdmision:oBrwE:SetFont(oFont)

   oAdmision:oBrwE:lFooter     := .F.
   oAdmision:oBrwE:lHScroll    := .F.
   oAdmision:oBrwE:nHeaderLines:= 2

   oCol:=oAdmision:oBrwE:aCols[1]
   oCol:cHeader      :="Especialidad"
   oCol:nWidth       := 140

   oCol:=oAdmision:oBrwE:aCols[2]
   oCol:cHeader      :='Cant'
   oCol:nWidth       := 33
   oCol:nDataStrAlign:= AL_RIGHT 
   oCol:nHeadStrAlign:= AL_RIGHT 
   oCol:nFootStrAlign:= AL_RIGHT 
   oCol:bStrData:={|nMonto|nMonto:= oAdmision:oBrwE:aArrayData[oAdmision:oBrwE:nArrayAt,2],TRAN(nMonto,'999')}
   oCol:cFooter      :=""

   AEVAL(oAdmision:oBrwE:aCols,{|oCol|oCol:oHeaderFont:=oFontB})

   oAdmision:oBrwE:bClrStd               := {|oBrwE,nClrText,aData|oBrwE:=oAdmision:oBrwE,aData:=oBrwE:aArrayData[oBrwE:nArrayAt],;
                                           nClrText:=0,;
                                          {nClrText,iif( oBrwE:nArrayAt%2=0, oAdmision:nClrPane1, oAdmision:nClrPane2 ) } }


   oAdmision:oBrwE:bClrHeader            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}
   oAdmision:oBrwE:bClrFooter            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}

   oAdmision:oBrwE:bLDblClick:={|oBrwE|oAdmision:oRep:=oAdmision:RUNCLICKE() }

   oAdmision:oBrwE:bChange:={|| oAdmision:GETMEDICOS(oAdmision:oBrwE:aArrayData[oAdmision:oBrwE:nArrayAt,1] ,oAdmision:oBrwM),;
                                oAdmision:GETSERVICIOS(oAdmision:oBrwE:aArrayData[oAdmision:oBrwE:nArrayAt,1],oAdmision:oBrwS) }

   oAdmision:oBrwE:CreateFromCode()

//   @ 30,135 LISTBOX oAdmision:oBrwE FIELDS SIZE 215,150 PIXEL OF oAdmision:oWnd
//   @ 30,355 GET oAdmision:oGet1 VAR A->REP_FUENTE TEXT SIZE 230,149 PIXEL OF oAdmision:oWnd


   oAdmision:oBrwP:=TXBrowse():New( oAdmision:oWnd )
   oAdmision:oBrwP:SetArray( aPagos, .F. )
   oAdmision:oBrwP:SetFont(oFont)

   oAdmision:oBrwP:lFooter     := .T.
   oAdmision:oBrwP:lHScroll    := .T.
   oAdmision:oBrwP:nHeaderLines:= 2

   oCol:=oAdmision:oBrwP:aCols[1]
   oCol:cHeader      :="Moneda"
   oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth       := 120-40

   oCol:=oAdmision:oBrwP:aCols[2]
   oCol:cHeader      :="Equivalente"+CRLF+oDp:cMoneda
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth       := 120-40
   oCol:nDataStrAlign:= AL_RIGHT 
   oCol:nHeadStrAlign:= AL_RIGHT 
   oCol:nFootStrAlign:= AL_RIGHT 
   oCol:bStrData     :={|nMonto|nMonto:= oAdmision:oBrwP:aArrayData[oAdmision:oBrwP:nArrayAt,2],FDP(nMonto,oDp:cPictValCam)}

   oCol:=oAdmision:oBrwP:aCols[3]
   oCol:cHeader      :="Sugerido"+CRLF+"Divisa"
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth       := 110
   oCol:nDataStrAlign:= AL_RIGHT 
   oCol:nHeadStrAlign:= AL_RIGHT 
   oCol:nFootStrAlign:= AL_RIGHT 
   oCol:bStrData     :={|nMonto|nMonto:= oAdmision:oBrwP:aArrayData[oAdmision:oBrwP:nArrayAt,3],FDP(nMonto,"999,999,999,999.99")}
  
   oCol:=oAdmision:oBrwP:aCols[4]
   oCol:cHeader      :="Recibido"+CRLF+"Divisa"
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth       := 120
   oCol:nDataStrAlign:= AL_RIGHT 
   oCol:nHeadStrAlign:= AL_RIGHT 
   oCol:nFootStrAlign:= AL_RIGHT 
   oCol:cEditPicture := "999,999,999,999.99"
   oCol:bStrData     :={|nMonto|nMonto:= oAdmision:oBrwP:aArrayData[oAdmision:oBrwP:nArrayAt,4],FDP(nMonto,"999,999,999.99")}
   oCol:nEditType    :=1
   oCol:bOnPostEdit  :={|oCol,uValue|oAdmision:PUTMONTO(oCol,uValue,4)}
   oCol:oDataFont    :=oFontB
   oCol:cFooter      :=FDP(aTotal[4],"999,999,999.99")

   oCol:=oAdmision:oBrwP:aCols[5]
   oCol:cHeader      :="Equivalente"+CRLF+"Recibido "+oDp:cMoneda
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth       := 120
   oCol:nDataStrAlign:= AL_RIGHT 
   oCol:nHeadStrAlign:= AL_RIGHT 
   oCol:nFootStrAlign:= AL_RIGHT 
   oCol:bStrData     :={|nMonto|nMonto:= oAdmision:oBrwP:aArrayData[oAdmision:oBrwP:nArrayAt,5],FDP(nMonto,"999,999,999.99")}
   oCol:cFooter      :=FDP(aTotal[5],"999,999,999.99")

   oCol:=oAdmision:oBrwP:aCols[oAdmision:nColSelP]
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:cHeader      :="Ok"
   oCol:AddBmpFile("BITMAPS\checkverde.bmp")
   oCol:AddBmpFile("BITMAPS\checkrojo.bmp")
   oCol:bBmpData    := { |oBrw|oBrw:=oAdmision:oBrwP,IIF(oBrw:aArrayData[oBrw:nArrayAt,oAdmision:nColSelP],1,2) }
   oCol:nDataStyle  := oCol:DefStyle( AL_LEFT, .F.)
   oCol:bStrData    :={||""}

   oCol:=oAdmision:oBrwP:aCols[oAdmision:nColCodMon]
   oCol:cHeader      :="Cód."+CRLF+"Mon."
   oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth       := 30

   oCol:=oAdmision:oBrwP:aCols[oAdmision:nColCajBco]
   oCol:cHeader      :="Caj"+CRLF+"Bco"
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth       := 30
   oCol:bClrStd      := {|oBrw,nClrText,aLine|oBrw    :=oAdmision:oBrwP,;
                                              aLine   :=oBrw:aArrayData[oBrw:nArrayAt],;
	                                         nClrText:=IF("CAJ"$aLine[09],oAdmision:nClrText3,oAdmision:nClrText4),;
                                              {nClrText,iif( oBrw:nArrayAt%2=0, oAdmision:nClrPane1, oAdmision:nClrPane2 ) } }

   oCol:=oAdmision:oBrwP:aCols[10-1]
   oCol:cHeader      :="Cód"+CRLF+"Ins"
   oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth       := 35

   oCol:=oAdmision:oBrwP:aCols[11-1]
   oCol:cHeader      :="Instrumento"+CRLF+"Caja/Banco"
   oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth       := 120

   oCol:=oAdmision:oBrwP:aCols[oAdmision:nColPorITG]
   oCol:cHeader      :="%"+CRLF+"IGTF"
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth       := 35
   oCol:nDataStrAlign:= AL_RIGHT 
   oCol:nHeadStrAlign:= AL_RIGHT 
   oCol:nFootStrAlign:= AL_RIGHT 
   oCol:bStrData     :={|nMonto|nMonto:= oAdmision:oBrwP:aArrayData[oAdmision:oBrwP:nArrayAt,oAdmision:nColPorITG],FDP(nMonto,"9.99")}

   oCol:bClrStd:={|oBrw,nClrText,aLine|oBrw    :=oAdmision:oBrwP,;
                                       aLine   :=oBrw:aArrayData[oBrw:nArrayAt],;
	                                       nClrText:=IF(aLine[oAdmision:nColPorITG]>0,oAdmision:nClrText1,oAdmision:nClrText),;
                                       {nClrText,iif( oBrw:nArrayAt%2=0, oAdmision:nClrPane1, oAdmision:nClrPane2 ) } }

   oCol:=oAdmision:oBrwP:aCols[oAdmision:nColMtoITG]
   oCol:cHeader      :="Monto"+CRLF+"IGTF "
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth       := 80
   oCol:nDataStrAlign:= AL_RIGHT 
   oCol:nHeadStrAlign:= AL_RIGHT 
   oCol:nFootStrAlign:= AL_RIGHT 
   oCol:bStrData     :={|nMonto|nMonto:= oAdmision:oBrwP:aArrayData[oAdmision:oBrwP:nArrayAt,oAdmision:nColMtoITG],FDP(nMonto,"999,999,999.99")}
   oCol:cFooter      :=FDP(aTotal[oAdmision:nColMtoITG],"999,999,999.99")

   oCol:=oAdmision:oBrwP:aCols[oAdmision:nColIsMon]
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:cHeader      :="Mone"+CRLF+"da"
   oCol:AddBmpFile("BITMAPS\monedas2.bmp")
   oCol:AddBmpFile("BITMAPS\checkrojo.bmp")
   oCol:bBmpData    := { |oBrw|oBrw:=oAdmision:oBrwP,IIF(oBrw:aArrayData[oBrw:nArrayAt,oAdmision:nColIsMon],1,2) }
   oCol:nDataStyle  := oCol:DefStyle( AL_LEFT, .F.)
   oCol:bStrData    :={||""}

   oCol:=oAdmision:oBrwP:aCols[15-1]
   oCol:cHeader      :="Marca"+CRLF+"Financiera"
   oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth       := 120

   oCol:=oAdmision:oBrwP:aCols[16-1]
   oCol:cHeader      :="Banco"
   oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth       := 20

   oCol:=oAdmision:oBrwP:aCols[17-1]
   oCol:cHeader      :="Cuenta"+CRLF+"Bancaria"
   oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth       := 120

   oCol:=oAdmision:oBrwP:aCols[18-1]
   oCol:cHeader       :="Referencia"
   oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:nWidth        := 120

   oCol:=oAdmision:oBrwP:aCols[18]
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAdmision:oBrwP:aArrayData ) } 
   oCol:cHeader      :="Dupli-"+CRLF+"car"
   oCol:AddBmpFile("BITMAPS\checkverde.bmp")
   oCol:AddBmpFile("BITMAPS\xcheckon.BMP")
   oCol:bBmpData    := { |oBrw|oBrw:=oAdmision:oBrwP,IIF(oBrw:aArrayData[oBrw:nArrayAt,18],1,2) }
   oCol:nDataStyle  := oCol:DefStyle( AL_LEFT, .F.)
   oCol:bStrData    :={||""}

/*  
   oAdmision:oBrwP:bClrStd  := {|oBrw,nClrText,aLine|oBrw:=oAdmision:oBrwP,aLine:=oBrw:aArrayData[oBrw:nArrayAt],;
                                                 nClrText:=oAdmision:nClrText,;
                                                 nClrText:=IF(!Empty(aLine[4]),oAdmision:nClrText1,nClrText),;
                                                 nClrText:=IF(aLine[4]>0 .AND. (oAdmision:nTotal5=oAdmision:nMontoBs) ,oAdmision:nClrText2,nClrText),;
                                                 {nClrText,iif( oBrw:nArrayAt%2=0, oAdmision:nClrPane1, oAdmision:nClrPane2 ) } }
*/

   oAdmision:oBrwP:bClrStd  := {|oBrw,nClrText,aLine|oBrw:=oAdmision:oBrwP,aLine:=oBrw:aArrayData[oBrw:nArrayAt],;
                                                 nClrText:=0,;
                                                 nClrText:=IF(!Empty(aLine[4]),CLR_HBLUE,nClrText),;
                                                 nClrText:=IF(aLine[4]>0 .AND. (oAdmision:nTotal5=oAdmision:nMontoBs) ,CLR_BLUE,nClrText),;
                                                 {nClrText,iif( oBrw:nArrayAt%2=0, oAdmision:nClrPane1, oAdmision:nClrPane2 ) } }


   oAdmision:oBrwP:bClrHeader:= {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}
   oAdmision:oBrwP:bClrFooter:= {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}

   oAdmision:oBrwP:bLDblClick:={|oBrw|oAdmision:RUNCLICKP() }

   oAdmision:oBrwPFocus :=oAdmision:oBrwP

   oAdmision:oBrwP:bChange:={|| NIL}

   oAdmision:oBrwP:CreateFromCode()

   oAdmision:oBrwM:=TXBrowse():New( oAdmision:oWnd )
   oAdmision:oBrwM:SetArray( aMedicos, .F. )
   oAdmision:oBrwM:SetFont(oFont)

   oAdmision:oBrwM:lFooter     := .F.
   oAdmision:oBrwM:lHScroll    := .F.
   oAdmision:oBrwM:nHeaderLines:= 2

   oCol:=oAdmision:oBrwM:aCols[1]
   oCol:cHeader      :="Especialista"
   oCol:nWidth       := 180

   oCol:=oAdmision:oBrwM:aCols[2]
   oCol:cHeader      :='Cant'
   oCol:nWidth       := 40
   oCol:nDataStrAlign:= AL_RIGHT 
   oCol:nHeadStrAlign:= AL_RIGHT 
   oCol:nFootStrAlign:= AL_RIGHT 
   oCol:bStrData:={|nMonto|nMonto:= oAdmision:oBrwM:aArrayData[oAdmision:oBrwM:nArrayAt,2],TRAN(nMonto,'999')}
   oCol:cFooter      :=""

   AEVAL(oAdmision:oBrwM:aCols,{|oCol|oCol:oHeaderFont:=oFontB})

   oAdmision:oBrwM:bClrStd               := {|oBrwM,nClrText,aData|oBrwM:=oAdmision:oBrwM,aData:=oBrwM:aArrayData[oBrwM:nArrayAt],;
                                           nClrText:=0,;
                                          {nClrText,iif( oBrwM:nArrayAt%2=0, oAdmision:nClrPane1, oAdmision:nClrPane2 ) } }


   oAdmision:oBrwM:bClrHeader            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}
   oAdmision:oBrwM:bClrFooter            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}

   oAdmision:oBrwM:bLDblClick:={|oBrwM|oAdmision:oRep:=oAdmision:RUNCLICKM() }

   oAdmision:oBrwM:CreateFromCode()

   oAdmision:oBrwS:=TXBrowse():New( oAdmision:oWnd )
   oAdmision:oBrwS:SetArray( aServicios, .F. )
   oAdmision:oBrwS:SetFont(oFont)

   oAdmision:oBrwS:lFooter     := .F.
   oAdmision:oBrwS:lHScroll    := .F.
   oAdmision:oBrwS:nHeaderLines:= 2

   oCol:=oAdmision:oBrwS:aCols[1]
   oCol:cHeader      :="Código"
   oCol:nWidth       := 80

   oCol:=oAdmision:oBrwS:aCols[2]
   oCol:cHeader      :="Descripción"
   oCol:nWidth       := 120

   oCol:=oAdmision:oBrwS:aCols[3]
   oCol:cHeader      :="ID"+CRLF+"Paciente"
   oCol:nWidth       := 80

   oCol:=oAdmision:oBrwS:aCols[4]
   oCol:cHeader      :="Apellido y Nombre"
   oCol:nWidth       := 120

   oCol:=oAdmision:oBrwS:aCols[5]
   oCol:cHeader      :="Und"+CRLF+"Med"
   oCol:nWidth       := 40

   oCol:=oAdmision:oBrwS:aCols[6]
   oCol:cHeader      :="L"+CRLF+"P"
   oCol:nWidth       := 30

   oCol:=oAdmision:oBrwS:aCols[7]
   oCol:cHeader      :="$"
   oCol:nWidth       := 30

   oCol:=oAdmision:oBrwS:aCols[8]
   oCol:cHeader      :="%"+CRLF+"IVA"
   oCol:nWidth       := 40

   oCol:=oAdmision:oBrwS:aCols[9]
   oCol:cHeader      :="Cant."
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAdmision:oBrwS:aArrayData ) } 
   oCol:nWidth       := 80
   oCol:nDataStrAlign:= AL_RIGHT 
   oCol:nHeadStrAlign:= AL_RIGHT 
   oCol:nFootStrAlign:= AL_RIGHT 
   oCol:bStrData     :={|nMonto|nMonto:= oAdmision:oBrwS:aArrayData[oAdmision:oBrwS:nArrayAt,9],FDP(nMonto,"999,999,999.99")}

   oCol:=oAdmision:oBrwS:aCols[10]
   oCol:cHeader      :="Precio"
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAdmision:oBrwS:aArrayData ) } 
   oCol:nWidth       := 80
   oCol:nDataStrAlign:= AL_RIGHT 
   oCol:nHeadStrAlign:= AL_RIGHT 
   oCol:nFootStrAlign:= AL_RIGHT 
   oCol:bStrData     :={|nMonto|nMonto:= oAdmision:oBrwS:aArrayData[oAdmision:oBrwS:nArrayAt,10],FDP(nMonto,"999,999,999.99")}

   oCol:=oAdmision:oBrwS:aCols[11]
   oCol:cHeader      :="Total"
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAdmision:oBrwS:aArrayData ) } 
   oCol:nWidth       := 80
   oCol:nDataStrAlign:= AL_RIGHT 
   oCol:nHeadStrAlign:= AL_RIGHT 
   oCol:nFootStrAlign:= AL_RIGHT 
   oCol:bStrData     :={|nMonto|nMonto:= oAdmision:oBrwS:aArrayData[oAdmision:oBrwS:nArrayAt,11],FDP(nMonto,"999,999,999.99")}


   oCol:=oAdmision:oBrwS:aCols[12]
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAdmision:oBrwS:aArrayData ) } 
   oCol:cHeader      :="Ok"
   oCol:AddBmpFile("BITMAPS\checkverde.bmp")
   oCol:AddBmpFile("BITMAPS\checkrojo.bmp")
   oCol:bBmpData    := { |oBrw|oBrw:=oAdmision:oBrwS,IIF(oBrw:aArrayData[oBrw:nArrayAt,12],1,2) }
   oCol:nDataStyle  := oCol:DefStyle( AL_LEFT, .F.)
   oCol:bStrData    :={||""}


   AEVAL(oAdmision:oBrwS:aCols,{|oCol|oCol:oHeaderFont:=oFontB})

   oAdmision:oBrwS:bClrStd               := {|oBrwS,nClrText,aData|oBrwS:=oAdmision:oBrwS,aData:=oBrwS:aArrayData[oBrwS:nArrayAt],;
                                           nClrText:=0,;
                                          {nClrText,iif( oBrwS:nArrayAt%2=0, oAdmision:nClrPane1, oAdmision:nClrPane2 ) } }


   oAdmision:oBrwS:bClrHeader            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}
   oAdmision:oBrwS:bClrFooter            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}

   oAdmision:oBrwS:bLDblClick:={|oBrwS|oAdmision:oRep:=oAdmision:RUNCLICKE() }

   oAdmision:oBrwS:bChange:={|| NIL}

   oAdmision:oBrwS:CreateFromCode()

   oAdmision:nLin30  :=30
   oAdmision:nLin130 :=130
   oAdmision:nCol135 :=135

   oAdmision:nAltoAdd:=0

   oAdmision:nLin180 :=180
   oAdmision:nLin185 :=185

   nAddH3:=90-2

   oAdmision:oBrwE:Move(oAdmision:nLin30         ,135,215,150+nAddH3,.T.) // Especialidad
   oAdmision:oBrwM:Move(oAdmision:nLin185+nAddH3 ,135,245,145,.T.) // Medicos

   oAdmision:oBrwP:Move(oAdmision:nLin30         ,355,230,149+nAddH3,.T.) // Pagos
   oAdmision:oBrwS:Move(oAdmision:nLin185+nAddH3 ,385,200,144,.T.) // Servicios

   @ oAdmision:nLin130,0  SPLITTER oAdmision:oHSplit1 ;
            HORIZONTAL ;
            PREVIOUS CONTROLS oAdmision:oSay ;
            HINDS CONTROLS oAdmision:oBtn ;
            TOP MARGIN 80 ;
            BOTTOM MARGIN oAdmision:oHSplit2:nLast + 50+0 ;
            SIZE 130, 4 PIXEL ;
            OF oAdmision:oWnd ;
            _3DLOOK ;
            UPDATE

   @ 231,0  SPLITTER oAdmision:oHSplit2 ;
            HORIZONTAL ;
            PREVIOUS CONTROLS oAdmision:oBtn NO ADJUST ;
            HINDS CONTROLS oAdmision:oBmp ;
            TOP MARGIN oAdmision:oHSplit1:nFirst + 50 ;
            BOTTOM MARGIN 80 ;
            SIZE 130, 4 PIXEL ;
            OF oAdmision:oWnd ;
            _3DLOOK ;
            UPDATE

  @ oAdmision:nLin30,350  SPLITTER oAdmision:oVSplit1 ;
            VERTICAL ;
            PREVIOUS CONTROLS oAdmision:oBrwE ;
            HINDS CONTROLS oAdmision:oBrwP ;
            LEFT MARGIN oAdmision:oVSplit3:nFirst + 50 ;
            RIGHT MARGIN 80 ;
            SIZE 4, 150+nAddH3  PIXEL ;
            OF oAdmision:oWnd ;
            _3DLOOK

  @ oAdmision:nLin185+nAddH3,380 SPLITTER oAdmision:oVSplit2 ;
            VERTICAL ;
            PREVIOUS CONTROLS oAdmision:oBrwM ;
            HINDS CONTROLS oAdmision:oBrwS ;
            LEFT MARGIN oAdmision:oVSplit3:nFirst + 50 ;
            RIGHT MARGIN 80 ;
            SIZE 4, 145  PIXEL ;
            OF oAdmision:oWnd ;
            _3DLOOK

  @ oAdmision:nLin180+nAddH3,135 SPLITTER oAdmision:oHSplit3 ;
            HORIZONTAL ;
            PREVIOUS CONTROLS oAdmision:oBrwE, oAdmision:oVSplit1, oAdmision:oBrwP ;
            HINDS CONTROLS oAdmision:oBrwM, oAdmision:oVSplit2, oAdmision:oBrwS ;
            TOP MARGIN 80 ;
            BOTTOM MARGIN 80 ;
            SIZE 450, 4 PIXEL ;
            OF oAdmision:oWnd ;
            _3DLOOK ;
            UPDATE

   @ oAdmision:nLin30,130 SPLITTER oAdmision:oVSplit3 ;
            VERTICAL ;
            PREVIOUS CONTROLS oAdmision:oSay, oAdmision:oHSplit1, oAdmision:oBtn, oAdmision:oHSplit2, oAdmision:oBmp ;
            HINDS CONTROLS oAdmision:oBrwE, oAdmision:oHSplit3, oAdmision:oBrwM ;
            LEFT MARGIN 80 ;
            RIGHT MARGIN MAX( oAdmision:oVSplit1:nLast, oAdmision:oVSplit2:nLast ) + 50 ;
            SIZE 4, 300  PIXEL ;
            OF oAdmision:oWnd ;
            _3DLOOK


  oAdmision:Activate({||oAdmision:CLDBOTBAR()})

  oAdmision:oWnd:bResized:={|| oAdmision:oVSplit3:AdjClient(), ;
                          oAdmision:oHSplit3:AdjRight(), ;
                          oAdmision:oHSplit1:Adjust( .t., .f., .t., .f. ), ;
                          oAdmision:oHSplit2:Adjust( .f., .t., .t., .f. ), ;
                          oAdmision:oVSplit1:Adjust( .t., .f., .f., .t. ), ;
                          oAdmision:oVSplit2:Adjust( .f., .t., .f., .t. )  }

  EVAL(oAdmision:oWnd:bResized)

return nil

/*
// Barra de Botones
*/
FUNCTION CLDBOTBAR()

   LOCAL oCursor,oBar,oBtn,oFont,oCol
   LOCAL oDlg:=oAdmision:oDlg
   LOCAL nLin:=0

   DEFINE CURSOR oCursor HAND
   DEFINE BUTTONBAR oBar SIZE 52-15,60-15 OF oDlg 3D CURSOR oCursor
   DEFINE FONT oFont  NAME "Tahoma"   SIZE 0, -14 BOLD

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\XSAVE.BMP",NIL,"BITMAPS\XSAVEG.BMP";
          ACTION oAdmision:GRABARDOC()


    oBtn:cToolTip:="Ejecutar"

    DEFINE BUTTON oBtn;
           OF oBar;
           NOBORDER;
           FONT oFont;
           FILENAME "BITMAPS\XSALIR.BMP";
           ACTION (oAdmision:Close()) CANCEL

   oBar:SetColor(CLR_BLACK,oDp:nGris)

   AEVAL(oBar:aControls,{|o,n| o:SetColor(CLR_BLACK,oDp:nGris) })

   oAdmision:oBrwE:SetColor(0,oAdmision:nClrPane1)
   oAdmision:oBrwM:SetColor(0,oAdmision:nClrPane1)
   oAdmision:oBrwP:SetColor(0,oAdmision:nClrPane1)
   oAdmision:oBrwS:SetColor(0,oAdmision:nClrPane1)

   oBar:SetSize(NIL,80,.T.)

RETURN .T.

FUNCTION RUNCLICKE()
   ? "RUNCLICKE"
RETURN .T.

FUNCTION GRABARDOC()
   ? "GRABARDOC"
RETURN .T.

FUNCTION GETMEDICOS(cEspecial,oBrw)
    LOCAL cWhere:="DEP_DESCRI"+GetWhere("=",cEspecial),aData

    aData:=ASQL("SELECT PER_NOMBRE,0 FROM DPPERSONAL INNER JOIN DPDPTO ON PER_CODDEP=DEP_CODIGO WHERE PER_ACTIVO=1 AND "+cWhere)

    IF Empty(aData)
       AADD(aData,{"Indefinida",0})
    ENDIF

    IF ValType(oBrw)="O"
        oBrw:aArrayData:=ACLONE(aData)
        oBrw:nArrayAt  :=1
        oBrw:GoTop()
        oBrw:Refresh(.T.)
    ENDIF

RETURN aData


FUNCTION GETSERVICIOS(cEspecial,oBrw)
    LOCAL cWhere:="DEP_DESCRI"+GetWhere("=",cEspecial)
    LOCAL aData :={},cSql

    cWhere:=[ LEFT(INV_ESTADO,1)="A" AND ]+cWhere

    cSql  :=[ SELECT INV_CODIGO,INV_DESCRI,SPACE(10) AS ID,SPACE(100) AS PACIENTE,PRE_UNDMED,PRE_LISTA,PRE_CODMON,0 AS CANT,0 AS PORIVA,PRE_PRECIO,0 AS TOTAL,0 AS LOGICO]+;
            [ FROM DPINV ]+;
            [ INNER JOIN DPDPTO ON INV_CODDEP=DEP_CODIGO ]+;
            [ LEFT JOIN VIEW_UNDMEDXINV ON INV_CODIGO=IME_CODIGO LEFT JOIN VIEW_DPINVPRECIOS ON DPINV.INV_CODIGO=PRE_CODIGO ]+;
            [ WHERE ]+cWhere

    aData:=ASQL(cSql)

    IF Empty(aData)
      aData:=EJECUTAR("SQLARRAYEMPTY",cSql)
    ENDIF

    IF ValType(oBrw)="O"
        oBrw:aArrayData:=ACLONE(aData)
        oBrw:nArrayAt  :=1
        oBrw:GoTop()
        oBrw:Refresh(.T.)
    ENDIF

RETURN aData

// EOF

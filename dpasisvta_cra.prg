// Programa   : DPASISVTA_CRA
// Fecha/Hora : 13/06/2017 15:04:37
// Propósito  : Asistente de Venta Repuestos Automotrices
// Creado Por : Automáticamente por BRWMAKER
// Llamado por: <DPXBASE>
// Aplicación : Gerencia
// Tabla      : <TABLA>

#INCLUDE "DPXBASE.CH"

PROCE MAIN(cCodigo,cWhere,cCodSuc,nPeriodo,dDesde,dHasta,cTitle,cTableA,nValCam,cTipDoc)
   LOCAL aData,aFechas,cFileMem:="USER\BRPLANTILLADOC.MEM",V_nPeriodo:=4,cCodPar
   LOCAL V_dDesde:=CTOD(""),V_dHasta:=CTOD("")
   LOCAL cServer:=oDp:cRunServer,aVars:={}
   LOCAL lConectar:=.F.,cSql
   LOCAL aData2:={},aGrupo:={}
   LOCAL aTree :={},dFechaDiv:=CTOD("")

   oDp:cRunServer:=NIL

   IF !Empty(cServer)

     MsgRun("Conectando con Servidor "+cServer+" ["+ALLTRIM(SQLGET("DPSERVERBD","SBD_DOMINI","SBD_CODIGO"+GetWhere("=",cServer)))+"]",;
            "Por Favor Espere",{||lConectar:=EJECUTAR("DPSERVERDBOPEN",cServer)})

     IF !lConectar
        RETURN .F.
     ENDIF

   ENDIF

   IF Type("oAsisVtaR")="O" .AND. oAsisVtaR:oWnd:hWnd>0
      EJECUTAR("BRRUNNEW",oAsisVtaR,GetScript())
      RETURN oAsisVtaR
   ENDIF

   IF nValCam=NIL
     dFechaDiv :=SQLGET("VIEW_HISMONMAXVALOR","MAX_FECHA,MAX_VALOR","MAX_CODIGO"+GetWhere("=",oDp:cMonedaExt))
     nValCam   :=DPSQLROW(2,0)
   ENDIF

   cTitle:="Asistente de Venta " +IF(Empty(cTitle),"",cTitle)

   oDp:oFrm:=NIL

   DEFAULT cCodSuc :=oDp:cSucursal,;
           nPeriodo:=4,;
           dDesde  :=CTOD(""),;
           dHasta  :=CTOD(""),;
           cWhere  :="",;
           cCodigo :="PRY-001",;
           cTableA :="DPAUDELIMODCNF"

   DEFAULT cTipDoc:="NEN"

   cWhere:="AEM_CLAVE"+GetWhere("=",cCodigo)

   aData:={}

   aData2:=GetDataLic(.T.)

   cSql :=oDp:cWhere
 
   AADD(aData,{"",0,0,NIL})

//   AADD(aData,{"p02","Usuarios"          ,"N","5"})
//   AADD(aData,{"p03","Empresas Adicional","L","S"})
//   AADD(aData,{"p04","Alojamiento de Personalizaciones","L","S"})

   IF Empty(aData)
      MensajeErr("no hay "+cTitle,"Información no Encontrada")
      RETURN .F.
   ENDIF

   oDp:oDbLic:=NIL

   cTitle:=cTitle+" ["+oDp:cMonedaExt+" "+ALLTRIM(TRAN(nValCam,oDp:cPictValCam))+"]"

   aTree :=EJECUTAR("DPINVREOAUTOTREE")
   aGrupo:=ASQL(" SELECT DPGRU.GRU_CODIGO,DPGRU.GRU_DESCRI,SUM(IF(DPINV.INV_GRUPO=DPGRU.GRU_CODIGO,1,0)) AS CUANTOS FROM DPGRU "+;
                " INNER JOIN DPINV ON DPGRU.GRU_CODIGO=INV_GRUPO GROUP BY GRU_CODIGO")

//   ViewArray(aGrupo)

   ViewData(aData,cTitle,oDp:cWhere)

   oDp:oFrm:=oAsisVtaR
           
RETURN .T.  

FUNCTION ViewData(aData,cTitle,cWhere_)
   LOCAL oBrw,oCol,aTotal:=ATOTALES(aData),aTree2,aTree3
   LOCAL oFont,oFontB,I,U,X,Y,Z,oFontT
   LOCAL aPeriodos:=ACLONE(oDp:aPeriodos)
   LOCAL aCoors:=GetCoors( GetDesktopWindow() )

   DEFINE FONT oFont   NAME "Tahoma" SIZE 0, -12
   DEFINE FONT oFontB  NAME "Tahoma" SIZE 0, -12 BOLD
   DEFINE FONT oFontT  NAME "Tahoma" SIZE 0, -14 BOLD

   DpMdi(cTitle,"oAsisVtaR","DPASISVTA_CRA.EDT")


   oAsisVtaR:Windows(0,0,aCoors[3]-160,aCoors[4]-10,.T.) // Maximizado
   oAsisVtaR:lMsgBar  :=.F.
   oAsisVtaR:cPeriodo :=aPeriodos[nPeriodo]
   oAsisVtaR:cCodSuc  :=cCodSuc
   oAsisVtaR:nPeriodo :=nPeriodo
   oAsisVtaR:cNombre  :=""
   oAsisVtaR:dDesde   :=dDesde
   oAsisVtaR:cServer  :=cServer
   oAsisVtaR:dHasta   :=dHasta
   oAsisVtaR:cWhere   :=cWhere
   oAsisVtaR:cWhere_  :=cWhere_
   oAsisVtaR:cWhereQry:=""
   oAsisVtaR:cSql     :=oDp:cSql
   oAsisVtaR:oWhere   :=TWHERE():New(oAsisVtaR)
   oAsisVtaR:cCodPar  :=cCodPar // Código del Parámetro
   oAsisVtaR:lWhen    :=.T.
   oAsisVtaR:cTextTit :="" // Texto del Titulo Heredado
   oAsisVtaR:oDb      :=oDp:oDb
   oAsisVtaR:cBrwCod  :=""
   oAsisVtaR:lTmdi    :=.T.
   oAsisVtaR:cWhereCli:=""
   oAsisVtaR:cTitleCli:=NIL
   oAsisVtaR:cCodigo  :=cCodigo
   oAsisVtaR:cMemo    :=""
   oAsisVtaR:cTableA  :=cTableA
   oAsisVtaR:cNombre  :="Definición de Proyecto de Pruebas"
   oAsisVtaR:cMemo    :="Programa"+SPACE(200)
   oAsisVtaR:oSplitV  :=nil
   oAsisVtaR:aTree    :=aTree
   oAsisVtaR:nAddBar  :=50+50+5+4
   oAsisVtaR:cCodCli  :=SPACE(10)
   oAsisVtaR:cCodInv  :=SPACE(20)
   oAsisVtaR:cWhereInv:="" // Filtrar productos
   oAsisVtaR:aData2   :=ACLONE(aData2)
   oAsisVtaR:aData    :=ACLONE(aData)
   oAsisVtaR:aVacio   :=ACLONE(aData)
   oAsisVtaR:aGrupo   :=ACLONE(aGrupo)
   oAsisVtaR:oImg     :=NIL
   oAsisVtaR:lValRif  :=.F.
   oAsisVtaR:nTotal   :=0
   oAsisVtaR:dFecha   :=oDp:dFecha
   oAsisVtaR:cHora    :=oDp:cHora
   oAsisVtaR:nValCam  :=nValCam
   oAsisVtaR:nCantOrg :=1
   oAsisVtaR:oMtoBs   :=NIL

   oAsisVtaR:lVerProducto:=.F.

   oAsisVtaR:lHtml    :=.T.
   oAsisVtaR:lAuto    :=.T.

// oAsisVtaR:nColPrecio:=12
// oAsisVtaR:nNeto    :=0
   oAsisVtaR:nMtoBase :=0 // Monto Base
   oAsisVtaR:nMtoNeto :=0 // Monto Neto
   oAsisVtaR:nMtoIva  :=0 // Monto IVA
   oAsisVtaR:nMtoBs   :=0 // Monto Bs


   oAsisVtaR:nColUndMed:=11
   oAsisVtaR:nColCantid:=3  // 10 // Monto Neto
   oAsisVtaR:nColDolar :=4  // 11 // Precio USD
   oAsisVtaR:nColPrecio:=5  // 12 // Precio Bs
   oAsisVtaR:nColLista :=10 // 12 // Lista de Precios


   oAsisVtaR:cPieza   :=SPACE(40)
   oAsisVtaR:cModelo  :=SPACE(40)
   oAsisVtaR:cAno     :=SPACE(04) // Vacio Todos
   oAsisVtaR:nCantid  :=1         // Cantidad

   oAsisVtaR:cNomCli  :=SPACE(100)
   oAsisVtaR:cNumero  :=STRZERO(1,10)
   oAsisVtaR:lValRif  :=.F.
   oAsisVtaR:nTotal   :=0
   oAsisVtaR:cTipDoc  :=cTipDoc // "CTZ"
   oAsisVtaR:lIva     :=SQLGET("DPTIPDOCCLI","TDC_IVA","TDC_TIPO"+GetWhere("=",cTipDoc))
   oAsisVtaR:oBrwG    :=NIL

   oAsisVtaR:dFechaDiv :=SQLGET("VIEW_HISMONMAXVALOR","MAX_FECHA,MAX_VALOR","MAX_CODIGO"+GetWhere("=",oDp:cMonedaExt))
   oAsisVtaR:nMontoDiv :=DPSQLROW(2,0)
   oAsisVtaR:cTitleDiv :=oDp:cMonedaExt+" "+DTOC(oAsisVtaR:dFechaDiv)+" "+ALLTRIM(TRAN( oAsisVtaR:nMontoDiv,"999,999,999,999.99"))

   IF Empty(oAsisVtaR:aTree)

      oAsisVtaR:oBrwG:=TXBrowse():New( oAsisVtaR:oWnd)
      oAsisVtaR:oBrwG:SetArray( aGrupo, .F. )
      oAsisVtaR:oBrwG:SetFont(oFont)

      oAsisVtaR:oBrwG:lFooter     := .F.
      oAsisVtaR:oBrwG:lHScroll    := .F.
      oAsisVtaR:oBrwG:nHeaderLines:= 1
      oAsisVtaR:oBrwG:nDataLines  := 1
      oAsisVtaR:oBrwG:nFooterLines:= 1

      oCol:=oAsisVtaR:oBrwG:aCols[1]
      oCol:cHeader      :='Código'
      oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrwG:aArrayData ) }
      oCol:nWidth       :=80

      oCol:=oAsisVtaR:oBrwG:aCols[2]
      oCol:cHeader      :='Descripción del Grupo'
      oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrwG:aArrayData ) }
      oCol:nWidth       :=280+40+10

      oCol:=oAsisVtaR:oBrwG:aCols[3]
      oCol:cHeader      :="Prod."
      oCol:nWidth       :=45
      oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrwG:aArrayData ) }
      oCol:cFooter      :="0"
      oCol:cEditPicture :='999,999'
      oCol:bStrData     :={|nMonto,oCol|nMonto:= oAsisVtaR:oBrwG:aArrayData[oAsisVtaR:oBrwG:nArrayAt,3],;
                                        oCol  := oAsisVtaR:oBrwG:aCols[2],;
                                        FDP(nMonto,oCol:cEditPicture)}


      oAsisVtaR:oBrwG:bClrStd      := {|oBrw,nClrText,aData|oBrw:=oAsisVtaR:oBrwG,aData:=oBrw:aArrayData[oBrw:nArrayAt],;
                                        oAsisVtaR:nClrText,;
                                       {nClrText,iif( oBrw:nArrayAt%2=0, oAsisVtaR:nClrPane1, oAsisVtaR:nClrPane2 ) } }

      oAsisVtaR:oBrwG:bClrHeader            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}
      oAsisVtaR:oBrwG:bClrFooter            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}

      oAsisVtaR:oBrwG:bLDblClick:={|oBrw|oAsisVtaR:RUNCLICKBRWG() }

      oAsisVtaR:oBrwG:bGotFocus:={||oAsisVtaR:oBrwFocus:=oAsisVtaR:oBrwG}

      oAsisVtaR:oBrwG:CreateFromCode()

   ENDIF

   oAsisVtaR:oBrwF:=TXBrowse():New( oAsisVtaR:oWnd)
   oAsisVtaR:oBrwF:SetArray( aData, .F. )
   oAsisVtaR:oBrwF:SetFont(oFont)

   oAsisVtaR:oBrwF:lFooter     := .T.
   oAsisVtaR:oBrwF:lHScroll    := .T.
   oAsisVtaR:oBrwF:nHeaderLines:= 2
   oAsisVtaR:oBrwF:nDataLines  := 2
   oAsisVtaR:oBrwF:nFooterLines:= 1

   oAsisVtaR:aData            :=ACLONE(aData)
   oAsisVtaR:nClrText :=0
   oAsisVtaR:nClrPane1:=16774120
   oAsisVtaR:nClrPane2:=16771538

   AEVAL(oAsisVtaR:oBrwF:aCols,{|oCol|oCol:oHeaderFont:=oFont})

   oCol:=oAsisVtaR:oBrwF:aCols[1]
   oCol:cHeader      :='Producto'
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrwF:aArrayData ) }
   oCol:nWidth       :=300

   oCol:=oAsisVtaR:oBrwF:aCols[2]
   oCol:cHeader      :="Cant"
   oCol:nWidth       :=60+20
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrwF:aArrayData ) }
   oCol:cFooter      :="0"
   oCol:cEditPicture :='999,999,999.99'
   oCol:bStrData     :={|nMonto,oCol|nMonto:= oAsisVtaR:oBrwF:aArrayData[oAsisVtaR:oBrwF:nArrayAt,2],;
                                     oCol  := oAsisVtaR:oBrwF:aCols[2],;
                                     FDP(nMonto,oCol:cEditPicture)}


   oCol:=oAsisVtaR:oBrwF:aCols[3]
   oCol:cHeader      :="Total"+CRLF+oDp:cMonedaExt
   oCol:nWidth       :=80
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrwF:aArrayData ) }
   oCol:cFooter      :="0.00"
   oCol:cEditPicture :='999,999,999.99'
   oCol:bStrData     :={|nMonto,oCol|nMonto:= oAsisVtaR:oBrwF:aArrayData[oAsisVtaR:oBrwF:nArrayAt,3],;
                                     oCol  := oAsisVtaR:oBrwF:aCols[3],;
                                     FDP(nMonto,oCol:cEditPicture)}
   oCol:=oAsisVtaR:oBrwF:aCols[4]
   oCol:Hide()


   oAsisVtaR:oBrwF:bKeyDown:={|nKey| IF(nKey=46, oAsisVtaR:BRWDELITEM(),NIL)}


   oAsisVtaR:oBrwF:bClrStd               := {|oBrw,nClrText,aData|oBrw:=oAsisVtaR:oBrwF,aData:=oBrw:aArrayData[oBrw:nArrayAt],;
                                           oAsisVtaR:nClrText,;
                                          {nClrText,iif( oBrw:nArrayAt%2=0, oAsisVtaR:nClrPane1, oAsisVtaR:nClrPane2 ) } }

   oAsisVtaR:oBrwF:bClrHeader            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}
   oAsisVtaR:oBrwF:bClrFooter            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}

   oAsisVtaR:oBrwF:bLDblClick:={|oBrw|oAsisVtaR:RUNCLICK() }

   oAsisVtaR:oBrwF:bChange:={||oAsisVtaR:BRWCHANGE()}
   oAsisVtaR:oBrwF:CreateFromCode()

   oAsisVtaR:oBrwFocus:=oAsisVtaR:oBrwF

   oAsisVtaR:oBrwF:bGotFocus:={||oAsisVtaR:oBrwFocus:=oAsisVtaR:oBrwF}
   
 
   /*
   // 2DO Browse, Productos
   */
   oAsisVtaR:oBrw:=TXBrowse():New( oAsisVtaR:oWnd)

   oAsisVtaR:oBrw:SetArray( aData2, .F. )
   oAsisVtaR:oBrw:SetFont(oFont)

   oAsisVtaR:oBrw:lFooter     := .F.
   oAsisVtaR:oBrw:lHScroll    := .T.
   oAsisVtaR:oBrw:nHeaderLines:= 2
   oAsisVtaR:oBrw:nDataLines  := 1
   oAsisVtaR:oBrw:nFooterLines:= 1

   AEVAL(oAsisVtaR:oBrw:aCols,{|oCol|oCol:oHeaderFont:=oFont})

   oCol:=oAsisVtaR:oBrw:aCols[1]
   oCol:cHeader      :='Código'
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrw:aArrayData ) }
   oCol:nWidth       :=110

   oCol:=oAsisVtaR:oBrw:aCols[2]
   oCol:cHeader      :='Descripción'
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrw:aArrayData ) }
   oCol:nWidth       :=210

   oCol:=oAsisVtaR:oBrw:aCols[oAsisVtaR:nColCantid]
   oCol:cHeader      :='Cant.'+CRLF+"Unid."
   oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oAsisVtaR:oBrw:aArrayData ) }
   oCol:nWidth       := 80
   oCol:nDataStrAlign:= AL_RIGHT
   oCol:nHeadStrAlign:= AL_RIGHT
   oCol:nFootStrAlign:= AL_RIGHT
   oCol:cEditPicture :='999,999,999.99'
   oCol:nEditType    :=1
   oCol:bOnPostEdit  :={|oCol,uValue|oAsisVtaR:PUTCANTID(oCol,uValue,oAsisVtaR:nColCantid)}
   oCol:bStrData     :={|nMonto,oCol|nMonto:= oAsisVtaR:oBrw:aArrayData[oAsisVtaR:oBrw:nArrayAt,oAsisVtaR:nColCantid],;
                                     oCol  := oAsisVtaR:oBrw:aCols[oAsisVtaR:nColCantid],;
                                     FDP(nMonto,oCol:cEditPicture)}
   oCol:oDataFont:=oFontT
   oCol:oHeadFont:=oFontT

   oCol:=oAsisVtaR:oBrw:aCols[oAsisVtaR:nColDolar]
   oCol:cHeader      :='Precio'+CRLF+oDp:cMonedaExt
   oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oAsisVtaR:oBrw:aArrayData ) }
   oCol:nWidth       := 80
   oCol:nDataStrAlign:= AL_RIGHT
   oCol:nHeadStrAlign:= AL_RIGHT
   oCol:nFootStrAlign:= AL_RIGHT
   oCol:cEditPicture :='999,999,999.99'
   oCol:nEditType    :=1
   oCol:bOnPostEdit  :={|oCol,uValue|oAsisVtaR:PUTDOLAR(oCol,uValue,oAsisVtaR:nColDolar)}

   oCol:bStrData     :={|nMonto,oCol|nMonto:= oAsisVtaR:oBrw:aArrayData[oAsisVtaR:oBrw:nArrayAt,oAsisVtaR:nColDolar],;
                                     oCol  := oAsisVtaR:oBrw:aCols[oAsisVtaR:nColDolar],;
                                     FDP(nMonto,oCol:cEditPicture)}
   oCol:oDataFont:=oFontT
   oCol:oHeadFont:=oFontT

   oCol:=oAsisVtaR:oBrw:aCols[oAsisVtaR:nColPrecio]
   oCol:cHeader      :='Precio'+CRLF+oDp:cMoneda
   oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oAsisVtaR:oBrw:aArrayData ) }
   oCol:nWidth       := 110
   oCol:nDataStrAlign:= AL_RIGHT
   oCol:nHeadStrAlign:= AL_RIGHT
   oCol:nFootStrAlign:= AL_RIGHT
   oCol:cEditPicture :='999,999,999,999.99'
   oCol:bOnPostEdit  :={|oCol,uValue|oAsisVtaR:PUTMONTO(oCol,uValue,oAsisVtaR:nColPrecio)}
   oCol:nEditType    :=1

   oCol:bStrData     :={|nMonto,oCol|nMonto:= oAsisVtaR:oBrw:aArrayData[oAsisVtaR:oBrw:nArrayAt,oAsisVtaR:nColPrecio],;
                                     oCol  := oAsisVtaR:oBrw:aCols[oAsisVtaR:nColPrecio],;
                                     FDP(nMonto,oCol:cEditPicture)}
   oCol:oDataFont:=oFontT
   oCol:oHeadFont:=oFontT


   oCol:=oAsisVtaR:oBrw:aCols[6]
   oCol:cHeader      :='Marca'
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrw:aArrayData ) }
   oCol:nWidth       :=210

   oCol:=oAsisVtaR:oBrw:aCols[7]
   oCol:cHeader      :='Modelo'
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrw:aArrayData ) }
   oCol:nWidth       :=110

   oCol:=oAsisVtaR:oBrw:aCols[8]
   oCol:cHeader      :='Año'+CRLF+"Desde"
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrw:aArrayData ) }
   oCol:nWidth       :=42

   oCol:=oAsisVtaR:oBrw:aCols[9]
   oCol:cHeader      :='Año'+CRLF+"Hasta"
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrw:aArrayData ) }
   oCol:nWidth       :=42

   oCol:=oAsisVtaR:oBrw:aCols[10]
   oCol:cHeader      :="Lista"
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrw:aArrayData ) }
   oCol:nWidth       :=30

   oCol:=oAsisVtaR:oBrw:aCols[11]
   oCol:cHeader      :="Und"+CRLF+"Medida"
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrw:aArrayData ) }
   oCol:nWidth       :=60

   oCol:=oAsisVtaR:oBrw:aCols[12]
   oCol:cHeader      :="Mone"+CRLF+"-da"
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrw:aArrayData ) }
   oCol:nWidth       :=40




   oCol:=oAsisVtaR:oBrw:aCols[13]
   oCol:cHeader      :="Fecha"+CRLF+"Precio"
   oCol:bLClickHeader:= {|r,c,f,o| SortArray( o, oAsisVtaR:oBrw:aArrayData ) }
   oCol:nWidth       :=65

   oCol:=oAsisVtaR:oBrw:aCols[14]
   oCol:cHeader      :='Exist'+CRLF+"Contab"
   oCol:bLClickHeader := {|r,c,f,o| SortArray( o, oAsisVtaR:oBrw:aArrayData ) }
   oCol:nWidth       := 60
   oCol:nDataStrAlign:= AL_RIGHT
   oCol:nHeadStrAlign:= AL_RIGHT
   oCol:nFootStrAlign:= AL_RIGHT
   oCol:cEditPicture :='999,999,999'
   oCol:bStrData     :={|nMonto,oCol|nMonto:= oAsisVtaR:oBrw:aArrayData[oAsisVtaR:oBrw:nArrayAt,14],;
                                     oCol  := oAsisVtaR:oBrw:aCols[14],;
                                     FDP(nMonto,oCol:cEditPicture)}

   oCol:=oAsisVtaR:oBrw:aCols[15]
   oCol:cHeader      :='Tipo'+CRLF+'IVA'
   oCol:nWidth       := 40

   oCol:=oAsisVtaR:oBrw:aCols[16]
   oCol:cHeader      :='Sustitutos'
   oCol:nWidth       := 160

   oCol:=oAsisVtaR:oBrw:aCols[17]
   oCol:cHeader      :='Imagen'
   oCol:nWidth       := 160

   oCol:=oAsisVtaR:oBrw:aCols[18]
   oCol:cHeader      :='Grupo'
   oCol:nWidth       := 160


   oAsisVtaR:oBrw:bKeyDown:={|nKey| IF(nKey=13 .AND. oAsisVtaR:oBrw:nColSel>oAsisVtaR:nColPrecio, oAsisVtaR:RUNCLICKBRW2(),NIL)}



   oAsisVtaR:oBrw:bClrStd               := {|oBrw,nClrText,aData|oBrw:=oAsisVtaR:oBrw,aData:=oBrw:aArrayData[oBrw:nArrayAt],;
                                           oAsisVtaR:nClrText,;
                                          {nClrText,iif( oBrw:nArrayAt%2=0, oAsisVtaR:nClrPane1, oAsisVtaR:nClrPane2 ) } }

   oAsisVtaR:oBrw:bClrHeader            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}
   oAsisVtaR:oBrw:bClrFooter            := {|| { oDp:nLbxClrHeaderText, oDp:nLbxClrHeaderPane}}

   oAsisVtaR:oBrw:bLDblClick:={|oBrw2|oAsisVtaR:RUNCLICKBRW2() }

   oAsisVtaR:oBrw:bChange:={||oAsisVtaR:BRWCHANGE2()}
   oAsisVtaR:oBrw:CreateFromCode()

   oAsisVtaR:oBrwFocus:=oAsisVtaR:oBrw
   oAsisVtaR:oBrw:bGotFocus:={||oAsisVtaR:oBrwFocus:=oAsisVtaR:oBrw}

IF !Empty(aTree)

   oAsisVtaR:oImageList:=TImageList():New()

   oAsisVtaR:oBmp1:= TBitmap():Define( "bitmaps\folder.bmp" ,, oAsisVtaR:oWnd )
   oAsisVtaR:oBmp2:= TBitmap():Define( "bitmaps\fldMask.bmp",, oAsisVtaR:oWnd )

   ooPrgRec:ImageList:Add( oAsisVtaR:oBmp1, oAsisVtaR:oBmp2 )

   oAsisVtaR:oTree:= TTreeView():New( 2.2, 0, oAsisVtaR:oWnd )
   oAsisVtaR:oTree:cargo:="0"
//   oAsisVtaR:oTree:bChanged = { || MsgBeep(), oAsisVtaR:oWnd:SetText( oAsisVtaR:oTree:GetSelText() ),oDp:oFrameDp:SetText("cargo0") }
   oAsisVtaR:oTree:bChanged:= { || oAsisVtaR:VERTREE(oAsisVtaR:oTree) }


   FOR I=1 TO LEN(oAsisVtaR:aTree)

      aTree2:=oAsisVtaR:aTree[I,2]
      oAsisVtaR:oItem1:=oAsisVtaR:oTree:Add(oAsisVtaR:aTree[I,1]+" ("+LSTR(LEN(aTree2))+")"+CHR(10))
      oAsisVtaR:oItem1:cargo:="1"
   
      FOR U=1 TO LEN(aTree2)

        aTree3:=aTree2[U,2]
        oAsisVtaR:oItem2:=oAsisVtaR:oItem1:Add( aTree2[U,1] +" ("+LSTR(LEN(aTree3))+")"+CHR(13))
        oAsisVtaR:oItem2:cargo:="2"


        FOR X=1 TO LEN(aTree3)

          oAsisVtaR:oItem3:=oAsisVtaR:oItem2:Add( aTree3[X,1]+CRLF)
          oAsisVtaR:oItem3:cargo:="3"
          aTree4:=aTree2[X,2]

        NEXT X

      NEXT U

   NEXT I

ENDIF

   oAsisVtaR:nAddCol:=70+20+20

   IF !oAsisVtaR:oBrwG=NIL
      oAsisVtaR:oTree:=oAsisVtaR:oBrwG
   ENDIF

   oAsisVtaR:oTree:Move(50-2+oAsisVtaR:nAddBar,0    ,400+oAsisVtaR:nAddCol,200,.T.)
 
   oAsisVtaR:oBrwF:Move(250+5+oAsisVtaR:nAddBar,0    ,400+oAsisVtaR:nAddCol,400,.T.)
   oAsisVtaR:oBrw:Move(50  +oAsisVtaR:nAddBar,400+5+oAsisVtaR:nAddCol,400+400,400,.T.)

   @ 45+205+oAsisVtaR:nAddBar,0 SPLITTER oAsisVtaR:oSplitH ;
          HORIZONTAL ;
          PREVIOUS CONTROLS oAsisVtaR:oTree,oAsisVtaR:oSplitV ;
          HINDS CONTROLS oAsisVtaR:oBrwF;
          TOP MARGIN 10 ;
          BOTTOM MARGIN 20 ;
          SIZE (205+200-8)+oAsisVtaR:nAddCol, 5 PIXEL ;
          OF oAsisVtaR:oWnd;
          COLOR CLR_YELLOW


  @ 50, (83+300+20)-5+oAsisVtaR:nAddCol  SPLITTER oAsisVtaR:oSplitV ;
          VERTICAL ;
          PREVIOUS CONTROLS oAsisVtaR:oBrwF,oAsisVtaR:oTree,oAsisVtaR:oSplitH ;
          HINDS CONTROLS oAsisVtaR:oBrw ;
          LEFT MARGIN 100 ;
          RIGHT MARGIN 120+120 ;
          SIZE 4, oAsisVtaR:oWnd:nHeight()-10  PIXEL ;
          OF oAsisVtaR:oWnd ;
          _3DLOOK ;
          COLOR CLR_BLUE

  oAsisVtaR:oSplitH:aPrevCtrols := { oAsisVtaR:oTree,oAsisVtaR:oSplitV }

  oAsisVtaR:Activate({||oAsisVtaR:ViewDatBar()})

  oAsisVtaR:bValid   :={|| EJECUTAR("BRWSAVEPAR",oAsisVtaR)}
  oAsisVtaR:BRWRESTOREPAR()

  oAsisVtaR:oPieza:VarPut(CTOEMPTY(oAsisVtaR:cPieza),.T.)
  oAsisVtaR:oModelo:VarPut(CTOEMPTY(oAsisVtaR:cModelo),.T.)

RETURN .T.

/*
// Barra de Botones
*/
FUNCTION ViewDatBar()
   LOCAL oCursor,oBar,oBtn,oFont,oCol,oFontB,oFontT
   LOCAL oDlg:=IF(oAsisVtaR:lTmdi,oAsisVtaR:oWnd,oAsisVtaR:oDlg)
   LOCAL nLin:=0
   LOCAL nWidth:=oAsisVtaR:oBrwF:nWidth()
   LOCAL nAltoBrw:=150,nCol

   oAsisVtaR:oWnd:bResized:={|| oAsisVtaR:oSplitH:AdjLeft(),;
                                oAsisVtaR:oSplitV:AdjLeft(),;
                                oAsisVtaR:oSplitV:AdjRight() }


   oAsisVtaR:oBrwF:GoBottom(.T.)
   oAsisVtaR:oBrwF:Refresh(.T.)

   DEFINE CURSOR oCursor HAND
   DEFINE BUTTONBAR oBar SIZE 52-15,60-15+oAsisVtaR:nAddBar OF oDlg 3D CURSOR oCursor

   DEFINE FONT oFont   NAME "Tahoma"   SIZE 0, -14
   DEFINE FONT oFontB  NAME "Tahoma"   SIZE 0, -12 BOLD
   DEFINE FONT oFontT  NAME "Tahoma"   SIZE 0, -16 BOLD



 // Emanager no Incluye consulta de Vinculos
  DEFINE BUTTON oAsisVtaR:oBtnSave;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\XSAVE.BMP",NIL,"BITMAPS\XSAVEG.BMP";
          WHEN oAsisVtaR:nMtoNeto>0;
          ACTION oAsisVtaR:GUARDARDOC()

   oAsisVtaR:oBtnSave:cToolTip:="Crear Documento"

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\ZOOM.BMP";
          ACTION IF(oAsisVtaR:oWnd:IsZoomed(),oAsisVtaR:oWnd:Restore(),oAsisVtaR:oWnd:Maximize())

   oBtn:cToolTip:="Maximizar"


   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\XFIND.BMP";
          ACTION EJECUTAR("BRWSETFIND",oAsisVtaR:oBrwFocus)

   oBtn:cToolTip:="Buscar"

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\CLIENTE.BMP";
          ACTION EJECUTAR("DPCREACLI",oAsisVtaR:oCodCli)

   oBtn:cToolTip:="Creación Rápida de Cliente"


   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\FILTRAR.BMP";
          ACTION EJECUTAR("BRWSETFILTER",oAsisVtaR:oBrwFocus)

   oBtn:cToolTip:="Filtrar Registros"

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\OPTIONS.BMP",NIL,"BITMAPS\OPTIONSG.BMP";
          ACTION EJECUTAR("BRWSETOPTIONS",oAsisVtaR:oBrwFocus);
          WHEN LEN(oAsisVtaR:oBrwF:aArrayData)>1

   oBtn:cToolTip:="Filtrar según Valores Comunes"


   DEFINE BUTTON oAsisVtaR:oBtnSeniat;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\SENIAT.BMP";
          ACTION oAsisVtaR:lValRif:=oAsisVtaR:lValRif CANCEL

   oAsisVtaR:oBtnSeniat:cToolTip:="Activar/Inactivar Validación del RIF en el Seniat"


   DEFINE BUTTON oAsisVtaR:oBtnInv;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\PRODUCTO.BMP",NIL,"BITMAPS\PRODUCTOG.BMP";
          WHEN oAsisVtaR:lVerProducto;
          ACTION oAsisVtaR:VERPRODUCTO()

   oAsisVtaR:oBtnInv:cToolTip:="Consultar Producto"


   DEFINE BUTTON oAsisVtaR:oBtnNen;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\facturavta.BMP";
          ACTION oAsisVtaR:SetTipDoc("FAV")

   oAsisVtaR:oBtnNen:cToolTip:="Asignar Factura de Venta"


   DEFINE BUTTON oAsisVtaR:oBtnPed;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\POS.BMP";
          ACTION oAsisVtaR:SetTipDoc("TIK")

   oAsisVtaR:oBtnPed:cToolTip:="Ticket"


   DEFINE BUTTON oAsisVtaR:oBtnNen;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\notaentrega.BMP";
          ACTION oAsisVtaR:SetTipDoc("NEN")

   oAsisVtaR:oBtnNen:cToolTip:="Asignar Nota de Entrega"

   DEFINE BUTTON oAsisVtaR:oBtnPed;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\pedidoventa.BMP";
          ACTION oAsisVtaR:SetTipDoc("PED")

   oAsisVtaR:oBtnPed:cToolTip:="Pedido"

   DEFINE BUTTON oAsisVtaR:oBtnPed;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\COTIZA.BMP";
          ACTION oAsisVtaR:SetTipDoc("CTZ")

   oAsisVtaR:oBtnPed:cToolTip:="Cotiza"



   DEFINE BUTTON oAsisVtaR:oBtnPla;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\PLANTILLAS.BMP";
          ACTION oAsisVtaR:SelPlantilla()

   oAsisVtaR:oBtnPla:cToolTip:="Seleccionar Plantillas"


   DEFINE BUTTON oAsisVtaR:oBtnDel;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\XDELETE.BMP",NIL,"BITMAPS\XDELETEG.BMP";
          ACTION oAsisVtaR:BRWDELITEM();
          WHEN oAsisVtaR:nTotal>0

  oAsisVtaR:oBtnDel:cToolTip:="Remover Item"

/*
IF nWidth>300

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\REFRESH.BMP";
          ACTION oAsisVtaR:BRWREFRESCAR()

   oBtn:cToolTip:="Refrescar"

ENDIF


   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\CRYSTAL.BMP";
          ACTION EJECUTAR("BRWTODBF",oAsisVtaR)

   oBtn:cToolTip:="Visualizar Mediante Crystal Report"

*/

IF nWidth>400

 
     DEFINE BUTTON oBtn;
            OF oBar;
            NOBORDER;
            FONT oFont;
            FILENAME "BITMAPS\EXCEL.BMP";
            ACTION (EJECUTAR("BRWTOEXCEL",oAsisVtaR:oBrwF,oAsisVtaR:cTitle,oAsisVtaR:cNombre))

     oBtn:cToolTip:="Exportar hacia Excel"

     oAsisVtaR:oBtnXls:=oBtn

ENDIF

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\html.BMP";
          ACTION (EJECUTAR("BRWTOHTML",oAsisVtaR:oBrwF))

   oBtn:cToolTip:="Generar Archivo html"

   oAsisVtaR:oBtnHtml:=oBtn

 

IF nWidth>300

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\PREVIEW.BMP";
          ACTION (EJECUTAR("BRWPREVIEW",oAsisVtaR:oBrwF))

   oBtn:cToolTip:="Previsualización"

   oAsisVtaR:oBtnPreview:=oBtn

ENDIF

   IF ISSQLGET("DPREPORTES","REP_CODIGO","BRPLANTILLADOC")

     DEFINE BUTTON oBtn;
            OF oBar;
            NOBORDER;
            FONT oFont;
            FILENAME "BITMAPS\XPRINT.BMP";
            ACTION oAsisVtaR:IMPRIMIR()

      oBtn:cToolTip:="Imprimir"

     oAsisVtaR:oBtnPrint:=oBtn

   ENDIF

IF nWidth>700


   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\QUERY.BMP";
          ACTION oAsisVtaR:BRWQUERY()

   oBtn:cToolTip:="Imprimir"

ENDIF




   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\xTOP.BMP";
          ACTION (oAsisVtaR:oBrwF:GoTop(),oAsisVtaR:oBrwF:Setfocus())

IF nWidth>800 .OR. nWidth=0

   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\xSIG.BMP";
          ACTION (oAsisVtaR:oBrwF:PageDown(),oAsisVtaR:oBrwF:Setfocus())

  DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\xANT.BMP";
          ACTION (oAsisVtaR:oBrwF:PageUp(),oAsisVtaR:oBrwF:Setfocus())

ENDIF


  DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\xFIN.BMP";
          ACTION (oAsisVtaR:oBrwF:GoBottom(),oAsisVtaR:oBrwF:Setfocus())


   DEFINE BUTTON oBtn;
          OF oBar;
          NOBORDER;
          FONT oFont;
          FILENAME "BITMAPS\XSALIR.BMP";
          ACTION oAsisVtaR:Close()

  oAsisVtaR:oBrwF:SetColor(0,oAsisVtaR:nClrPane1)
  oAsisVtaR:oBrw:SetColor(0,oAsisVtaR:nClrPane1)

  EVAL(oAsisVtaR:oBrwF:bChange)
 
  oBar:SetColor(CLR_BLACK,oDp:nGris)

  oAsisVtaR:SETBTNBAR(40,40,oBar)


  AEVAL(oBar:aControls,{|o,n|o:SetColor(CLR_BLACK,oDp:nGris)})

  nLin:=15

  @ 45+01,nLin SAY "Cliente "  OF oBar SIZE 70,20 BORDER PIXEL RIGHT COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont
  @ 70-03,nLin SAY "Producto " OF oBar SIZE 70,20 BORDER PIXEL RIGHT COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont

  @ 3.7-.2,11.7-1 BMPGET oAsisVtaR:oCodCli VAR oAsisVtaR:cCodCli;
             VALID oAsisVtaR:ValCodCli();
             NAME "BITMAPS\FIND.BMP";
             ACTION (oDpLbx:=DpLbx("DPCLIENTES",NIL,NIL,NIL,NIL,NIL,NIL,NIL,NIL,oAsisVtaR:oCodCli),;
                     oDpLbx:GetValue("CLI_CODIGO",oAsisVtaR:oCodCli));
             SIZE 130,21 OF oAsisVtaR:oBar FONT oFontB

  oAsisVtaR:oCodCli:bkeyDown:={|nkey| IIF(nKey=13, oAsisVtaR:VALCODCLI(),NIL) }


  @ oAsisVtaR:oCodCli:nTop(),oAsisVtaR:oCodCli:nRight()+20 GET oAsisVtaR:oNomCli VAR oAsisVtaR:cNomCLi    OF oBar;
                                                       SIZE 150+150,20 PIXEL FONT oFontB

  oAsisVtaR:oNomCli:bkeyDown:={|nkey| IIF(nKey=13, oAsisVtaR:BUSCARCLIENTE(),NIL) }


  @ 5.2,11.7-1 BMPGET oAsisVtaR:oCodInv VAR oAsisVtaR:cCodInv;
             VALID oAsisVtaR:ValCodInv();
             NAME "BITMAPS\FIND.BMP";
             ACTION (oDpLbx:=DpLbx("DPINVREPUESTOS.LBX",NIL,"LEFT(INV_ESTADO,1)"+GetWhere("=","A")+oAsisVtaR:cWhereInv,NIL,NIL,NIL,NIL,NIL,NIL,oAsisVtaR:oCodInv),;
                     oDpLbx:GetValue("INV_CODIGO",oAsisVtaR:oCodInv));
             SIZE 130,21 OF oAsisVtaR:oBar FONT oFontB

  oAsisVtaR:oCodInv:bkeyDown:={|nkey| IIF(nKey=13, oAsisVtaR:ValCodInv(),NIL) }

  @ oAsisVtaR:oCodInv:nTop(),oAsisVtaR:oCodInv:nRight()+20 SAY oAsisVtaR:oSayInv PROMPT " "+SQLGET("DPINV","INV_DESCRI","INV_CODIGO"+GetWhere("=",oAsisVtaR:cCodInv))+" " OF oBar SIZE 390,20 BORDER PIXEL  COLOR CLR_WHITE,16761992

  nCol:=600-600+15
  nLin:=50+7

  @ nLin+32,nCol+00 SAY "Modelo " OF oBar SIZE 70,20 BORDER PIXEL RIGHT COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont
  @ nLin+53,nCol+00 SAY "Pieza "  OF oBar SIZE 70,20 BORDER PIXEL RIGHT COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont
  @ nLin+74,nCol+00 SAY "Año "    OF oBar SIZE 70,20 BORDER PIXEL RIGHT COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont

  @ nLin+74,nCol+135 SAY "Cant. "  OF oBar SIZE 40,20 BORDER PIXEL RIGHT COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont

  @ nLin+32,nCol+265 SAY " Tipo  "  OF oBar SIZE 60,20 BORDER PIXEL RIGHT COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont
  @ nLin+53,nCol+265 SAY "Número "  OF oBar SIZE 60,20 BORDER PIXEL RIGHT COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont
  @ nLin+74,nCol+265 SAY "Divisa "  OF oBar SIZE 60,20 BORDER PIXEL RIGHT COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont


  @ nLin+32,nCol+326 SAY oAsisVtaR:oTipDoc PROMPT " "+oAsisVtaR:cTipDoc+" "+SQLGET("DPTIPDOCCLI","TDC_DESCRI","TDC_TIPO"+GetWhere("=",oAsisVtaR:cTipDoc)) OF oBar;
                     SIZE 260,20 BORDER PIXEL COLOR oDp:nClrLabelText,oDp:nClrLabelPane FONT oFontT

  @ nLin+53,nCol+326 SAY oAsisVtaR:oNumero PROMPT " "+oAsisVtaR:cNumero  OF oBar;
                     SIZE 90,20 BORDER PIXEL COLOR oDp:nClrLabelText,oDp:nClrLabelPane FONT oFontB

  @ nLin+74,nCol+326 SAY oAsisVtaR:oDivisa PROMPT " "+oAsisVtaR:cTitleDiv  OF oBar;
                     SIZE 240,20 BORDER PIXEL COLOR oDp:nClrLabelText,oDp:nClrLabelPane FONT oFontB

  @ nLin+32,nCol+070 BMPGET oAsisVtaR:oModelo VAR oAsisVtaR:cModelo OF oBar PIXEL SIZE 170,20;
                ACTION oAsisVtaR:INVBUSCARMOD() FONT oFontB

  @ nLin+53,nCol+070 BMPGET oAsisVtaR:oPieza  VAR oAsisVtaR:cPieza  OF oBar PIXEL SIZE 170,20;
                ACTION oAsisVtaR:INVBUSCARPIEZA() FONT oFontB

  @ nLin+74,nCol+070 BMPGET oAsisVtaR:oAno    VAR oAsisVtaR:cAno    OF oBar PIXEL SIZE 040,20;
                ACTION oAsisVtaR:INVBUSCARANO() FONT oFontB

  oAsisVtaR:oAno:bkeyDown  :={|nkey| IIF(nKey=13, oAsisVtaR:INVBUSCARANO(),NIL) }
  oAsisVtaR:oAno:bLostFocus:={||oAsisVtaR:INVBUSCARANO()}

  @ nLin+74,nCol+176 GET oAsisVtaR:oCantid    VAR oAsisVtaR:nCantid    OF oBar PIXEL SIZE 060,20;
                PICTURE "99999";
                VALID oAsisVtaR:INVCANTID() SPINNER RIGHT FONT oFontB


  BMPGETBTN(oAsisVtaR:oCodCli)
  BMPGETBTN(oAsisVtaR:oCodInv)

  BMPGETBTN(oAsisVtaR:oModelo)
  BMPGETBTN(oAsisVtaR:oPieza)
  BMPGETBTN(oAsisVtaR:oAno)

  oAsisVtaR:cFileBmp:=""

  @ 1,800+80 BITMAP oAsisVtaR:oImg FILENAME oAsisVtaR:cFileBmp PIXEL;
          SIZE 150,150 OF oBar ADJUST

  oAsisVtaR:SETTIPDOC(oAsisVtaR:cTipDoc)

  nLin:=nLin-21

  oAsisVtaR:nMtoBs   :=0 // Monto Bs

  @ nLin+32,nCol+610 SAY "Base " OF oBar SIZE 50,20 BORDER PIXEL RIGHT COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont
  @ nLin+53,nCol+610 SAY "IVA "  OF oBar SIZE 50,20 BORDER PIXEL RIGHT COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont
  @ nLin+74,nCol+610 SAY "Neto " OF oBar SIZE 50,20 BORDER PIXEL RIGHT COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont
  @ nLin+95,nCol+610 SAY oDp:cMoneda+" " OF oBar SIZE 50,20 BORDER PIXEL RIGHT COLOR oDp:nClrYellowText,oDp:nClrYellow FONT oFont

  @ nLin+32,nCol+710-49 SAY oAsisVtaR:oMtoBase PROMPT FDP(oAsisVtaR:nMtoBase,"999,999,999,999.99") OF oBar SIZE 140,20 BORDER PIXEL RIGHT COLOR oDp:nClrLabelText,oDp:nClrLabelPane FONT oFontT
  @ nLin+53,nCol+710-49 SAY oAsisVtaR:oMtoIva  PROMPT FDP(oAsisVtaR:nMtoIva ,"999,999,999,999.99") OF oBar SIZE 140,20 BORDER PIXEL RIGHT COLOR oDp:nClrLabelText,oDp:nClrLabelPane FONT oFontT
  @ nLin+74,nCol+710-49 SAY oAsisVtaR:oMtoNeto PROMPT FDP(oAsisVtaR:nMtoNeto,"999,999,999,999.99") OF oBar SIZE 140,20 BORDER PIXEL RIGHT COLOR oDp:nClrLabelText,oDp:nClrLabelPane FONT oFontT
  @ nLin+95,nCol+710-49 SAY oAsisVtaR:oMtoBs   PROMPT FDP(oAsisVtaR:nMtoBs  ,"999,999,999,999.99") OF oBar SIZE 140,20 BORDER PIXEL RIGHT COLOR oDp:nClrLabelText,oDp:nClrLabelPane FONT oFontT

  oAsisVtaR:oBar:=oBar
 
  IF !oAsisVtaR:oBrwG=NIL
     oAsisVtaR:oBrwG:SetColor(0,oAsisVtaR:nClrPane1)
  ENDIF

RETURN .T.

FUNCTION INVBUSCARMOD()
RETURN .T.

FUNCTION INVBUSCARPIEZA()
RETURN .T.

FUNCTION INVBUSCARANO(cWhereMar)
  LOCAL cWhere:="",cWhereD

  IF !Empty(oAsisVtaR:cModelo)
     cWhere:=cWhere+IF(Empty(cWhere),""," AND ")+"CXI_CODSAT"+GetWhere(" LIKE ","%"+ALLTRIM(oAsisVtaR:cModelo)+"%")
  ENDIF

//  IF !Empty(oAsisVtaR:cPieza)
//     cWhere:=cWhere+IF(Empty(cWhere),""," AND ")+"INV_DESCRI"+GetWhere(" LIKE ","%"+ALLTRIM(oAsisVtaR:cPieza)+"%")
//  ENDIF

  IF !Empty(oAsisVtaR:cAno)

     cWhere:=cWhere+IF(Empty(cWhere),""," AND ")+;
             GetWhere("",oAsisVtaR:cAno)+">=CXI_ANOD AND "+GetWhere("",oAsisVtaR:cAno)+"<=CXI_ANOH"

  ENDIF

  IF !Empty(cWhereMar)

   cWhere:=cWhere+IF(Empty(cWhere),""," AND ")+;
           cWhereMar

  ENDIF

  IF !Empty(oAsisVtaR:cModelo)
     cWhereD:="INV_DESCRI"+GetWhere(" LIKE ","%"+ALLTRIM(oAsisVtaR:cModelo)+"%")
  ENDIF

  IF !Empty(oAsisVtaR:cPieza)
     cWhereD:=cWhereD+IF(Empty(cWhereD),""," AND ")+"INV_DESCRI"+GetWhere(" LIKE ","%"+ALLTRIM(oAsisVtaR:cPieza)+"%")
  ENDIF

  IF !Empty(oAsisVtaR:cAno)
     cWhereD:=cWhereD+IF(Empty(cWhereD),""," AND ")+"INV_DESCRI"+GetWhere(" LIKE ","%"+ALLTRIM(oAsisVtaR:cAno)+"%")
  ENDIF

  IF !Empty(cWhereD) .AND. !Empty(cWhere)
     cWhere:=cWhere+" OR ("+cWhereD+")"
  ENDIF

  oAsisVtaR:GetDataLic(.F.,cWhere,oAsisVtaR:oBrw)
  DPFOCUS(oAsisVtaR:oBrw)

RETURN .T.

/*
// Evento para presionar CLICK
*/
FUNCTION RUNCLICK()
RETURN .T.


/*
// Imprimir
*/
FUNCTION IMPRIMIR()
RETURN .T.

FUNCTION LEEFECHAS()
RETURN .T.


FUNCTION HACERWHERE(dDesde,dHasta,cWhere_,lRun)
RETURN cWhere


FUNCTION LEERDATA(cWhere,oBrw,cServer,cTableA)
   LOCAL aData:={},aTotal:={},oCol,cSql,aLines:={}
   LOCAL oDb

   DEFAULT cWhere:=""

   IF !Empty(cServer)

     IF !EJECUTAR("DPSERVERDBOPEN",cServer)
        RETURN .F.
     ENDIF

     oDb:=oDp:oDb

   ENDIF

   DEFAULT cTableA:="DPAUDELIMODCNF"

   cSql:=" SELECT * FROM XTABLA"

   cSql:=EJECUTAR("WHERE_VAR",cSql)

   oDp:lExcluye:=.T.

   aData:=ASQL(cSql,oDb)

   oDp:cWhere:=cWhere

   IF EMPTY(aData)
      aData:=EJECUTAR("SQLARRAYEMPTY",cSql,oDb)
   ENDIF

RETURN aData


FUNCTION SAVEPERIODO()
RETURN .T.

/*
// Permite Crear Filtros para las Búquedas
*/
FUNCTION BRWQUERY()
     EJECUTAR("BRWQUERY",oAsisVtaR)
RETURN .T.

/*
// Ejecución Cambio de Linea
*/
FUNCTION BRWCHANGE()
  LOCAL aLine   :=oAsisVtaR:oBrwF:aArrayData[oAsisVtaR:oBrwF:nArrayAt]
  LOCAL aLine2  :=aLine[4]
  LOCAL cFileBmp:=IF(ValType(aLine2)="A",aLine2[LEN(aLine2)],"")

  IF ValType(oAsisVtaR:oImg)="O"
    oAsisVtaR:VERFOTO(cFileBmp)
  ENDIF

  IF !Empty(aLine2)
    oAsisVtaR:lVerProducto:=!Empty(aLine2[1])
    oAsisVtaR:oBtnInv:ForWhen(.T.)
  ENDIF

RETURN NIL

/*
// Refrescar Browse
*/
FUNCTION BRWREFRESCAR()
    LOCAL cWhere

    IF Type("oAsisVtaR")="O" .AND. oAsisVtaR:oWnd:hWnd>0

      cWhere:=" "+IIF(!Empty("oAsisVtaR":cWhere_),"oAsisVtaR":cWhere_,"oAsisVtaR":cWhere)
      cWhere:=STRTRAN(cWhere," WHERE ","")

      oAsisVtaR:LEERDATA(oAsisVtaR:cWhere_,oAsisVtaR:oBrwF,oAsisVtaR:cServer)
      oAsisVtaR:oWnd:Show()
      oAsisVtaR:oWnd:Maximize()

    ENDIF

RETURN NIL

FUNCTION TXTGUARDAR()
RETURN .T.

FUNCTION BRWRESTOREPAR()
RETURN EJECUTAR("BRWRESTOREPAR",oAsisVtaR)

FUNCTION VALCODCLI()
  LOCAL lOk
  LOCAL cRif:=oAsisVtaR:cCodCli
  LOCAL cNombre:=SQLGET("DPCLIENTES","CLI_NOMBRE","CLI_CODIGO"+GetWhere("=",oAsisVtaR:cCodCli))
  LOCAL cCodigo
 
  cCodigo:=SQLGET("DPCLIENTES","CLI_CODIGO","CLI_RIF"+GetWhere("=",cRif))

  IF !Empty(cCodigo)
     oAsisVtaR:oCodCli:VarPut(cCodigo,.T.)
     cNombre:=SQLGET("DPCLIENTES","CLI_NOMBRE","CLI_CODIGO"+GetWhere("=",oAsisVtaR:cCodCli))
  ENDIF  

  IF !Empty(cNombre)
     oAsisVtaR:oNomCli:VarPut(cNombre,.T.)
  ENDIF

  DPFOCUS(oAsisVtaR:oCodInv)

  IF !oAsisVtaR:lValRif
     RETURN .T.
  ENDIF

  MsgRun("Verificando RIF "+cRif,"Por Favor, Espere",;
         {|| lOk:=EJECUTAR("VALRIFSENIAT",cRif,!ISDIGIT(cRif),!ISDIGIT(cRif),NIL,.T.) })

  IF !Empty(oDp:aRif)
     oAsisVtaR:oNomCli:VarPut(oDp:aRif[1],.T.)
     oAsisVtaR:oNomCli:Refresh(.T.)
  ENDIF


RETURN .T.

FUNCTION VALCODINV()
  LOCAL lOk,nCount
  LOCAL cNombre:=SQLGET("DPINV","INV_DESCRI","INV_CODIGO"+GetWhere("=",oAsisVtaR:cCodInv))

  oAsisVtaR:oSayInv:Refresh(.T.)

  IF !ISSQLFIND("DPINV","INV_CODIGO"+GetWhere("=",oAsisVtaR:cCodInv))

    // Buscar Sustitutos
    nCount:=COUNT("DPSUSTITUTOS","SUS_SUSTIT"+GetWhere(" LIKE ","%"+ALLTRIM(oAsisVtaR:cCodInv)+"%"))    

    IF nCount=1
      oAsisVtaR:cCodInv:=SQLGET("DPSUSTITUTOS","SUS_CODIGO","SUS_SUSTIT"+GetWhere(" LIKE ","%"+ALLTRIM(oAsisVtaR:cCodInv)+"%"))
      oAsisVtaR:oCodInv:VarPut(oAsisVtaR:cCodInv,.T.)
      oAsisVtaR:oSayInv:Refresh(.T.)
      RETURN .T.
    ENDIF

    IF nCount>1
       oAsisVtaR:cWhereInv:=" AND SUS_SUSTIT"+GetWhere(" LIKE ","%"+ALLTRIM(oAsisVtaR:cCodInv)+"%")
       EVAL(oAsisVtaR:oCodInv:bAction)
       oAsisVtaR:cWhereInv:=""
       RETURN .F.
    ENDIF

  ENDIF

  IF Empty(cNombre)
     EVAL(oAsisVtaR:oCodInv:bAction)
     RETURN .F.
  ENDIF

  oAsisVtaR:GetDataLic(.F.,"INV_CODIGO"+GetWhere("=",oAsisVtaR:cCodInv),oAsisVtaR:oBrw)

RETURN .T.

FUNCTION GetDataLic(lEmpty,cWhere,oBrw2)
  LOCAL aData,cSql,oDb,cSql2

  DEFAULT lEmpty:=.T.

  cSql:=" SELECT "+;
        " INV_CODIGO, "+;
        " INV_DESCRI, "+;
        " 1 AS CANTID,PRE_PRECIO,PRE_MONNAC,"+;
        " MAR_DESCRI, "+;
        " CXI_CODSAT, "+;
        " CXI_ANOD,  "+;
        " CXI_ANOH,  "+;
        " PRE_LISTA,PRE_UNDMED,PRE_CODMON,PRE_FECHA,EXC_CANTID,INV_IVA,SUS_SUSTIT,INV_FILBMP,GRU_DESCRI "+;
        " FROM "+;
        " dpcatsat_inv "+;
        " LEFT JOIN dpinv                 ON CXI_CODINV=INV_CODIGO "+;
        " LEFT JOIN dpgru                 ON INV_GRUPO=GRU_CODIGO "+;
        " LEFT JOIN dpmarcas              ON INV_CODMAR=MAR_CODIGO "+;
        " LEFT JOIN VIEW_UNDMEDXINV       ON INV_CODIGO=IME_CODIGO "+;
        " LEFT JOIN VIEW_DPINVPRECIOS     ON DPINV.INV_CODIGO=PRE_CODIGO "+;
        " LEFT JOIN VIEW_INVEXICON        ON INV_CODIGO=EXC_CODIGO "+;
        " LEFT JOIN VIEW_SUSTITUTOSCONCAT ON INV_CODIGO=SUS_CODIGO "


  cSql2:=" SELECT INV_CODIGO, "+;
         " INV_DESCRI, "+;
         " MAR_DESCRI, "+;
         " 1 AS CANTID,PRE_PRECIO,PRE_MONNAC,"+;
         " CXI_CODSAT, "+;
         " CXI_ANOD,  "+;
         " CXI_ANOH,  "+;
         " PRE_LISTA,PRE_UNDMED,PRE_CODMON,PRE_FECHA,EXC_CANTID,INV_IVA,SUS_SUSTIT,INV_FILBMP,GRU_DESCRI "+;
         " FROM DPINV "+;
         " LEFT JOIN dpgru                 ON INV_GRUPO=GRU_CODIGO "+;
         " LEFT JOIN dpcatsat_inv          ON CXI_CODINV=INV_CODIGO "+;
           " LEFT JOIN dpcatsat              ON CAT_CODIGO=CXI_CODSAT "+;
         " LEFT JOIN DPMARCAS             ON INV_CODMAR=MAR_CODIGO OR CAT_CODMAR=MAR_CODIGO "+;
         " LEFT JOIN VIEW_UNDMEDXINV       ON INV_CODIGO=IME_CODIGO "+;
         " LEFT JOIN VIEW_DPINVPRECIOS     ON DPINV.INV_CODIGO=PRE_CODIGO "+;
         " LEFT JOIN VIEW_INVEXICON        ON INV_CODIGO=EXC_CODIGO "+;
         " LEFT JOIN VIEW_SUSTITUTOSCONCAT ON INV_CODIGO=SUS_CODIGO "


  IF !Empty(cWhere) .AND. "INV_CODIGO"$cWhere
   cSql:=cSql2
  ENDIF

// ? cWhere

  IF !Empty(cWhere)
     cSql :=cSql+" WHERE "+cWhere
     cSql2:=cSql2+" WHERE "+cWhere

  ENDIF

  DPWRITE("TEMP\DPASISVTA_CRA.SQL",cSql)


  IF lEmpty

   aData:=EJECUTAR("SQLARRAYEMPTY",cSql,oDb)

 ELSE

    aData:=ASQL(cSql,.T.)

    IF Empty(aData) .AND. cSql<>cSql2
       aData:=ASQL(cSql2,.T.)
       DPWRITE("TEMP\DPASISVTA_CRA.SQL",oDp:cSql)
    ENDIF

    IF Empty(aData)
      aData:=ACLONE(oAsisVtaR:aData2)
      aData[1,2]:="No Encontrado"
      // EJECUTAR("SQLARRAYEMPTY",cSql,oDb)
    ENDIF

 ENDIF

 IF ValType(oBrw2)="O"
    oBrw2:aArrayData:=ACLONE(aData)
    oBrw2:nArrayAt:=1
    oBrw2:nRowSel :=1
    oBrw2:Gotop()
    oBrw2:Refresh(.T.)
    EVAL(oBrw2:bChange)
    oAsisVtaR:oBrwFocus:=oBrw2
    CursorArrow()
 ENDIF

RETURN aData

FUNCTION RUNCLICKBRW2()
  LOCAL aLine  :=ACLONE(oAsisVtaR:oBrw:aArrayData[oAsisVtaR:oBrw:nArrayAt])
  LOCAL aData  :=ACLONE(oAsisVtaR:aData),cPrecio,aTotal:={}
  LOCAL nAt    :=oAsisVtaR:oBrw:nArrayAt
  LOCAL nRowSel:=oAsisVtaR:oBrw:nRowSel

  IF Empty(aLine[1]) .OR. Empty(aLine[oAsisVtaR:nColPrecio])
     RETURN .F.
  ENDIF

  IF Empty(aData[1,1])
     aData:={}
  ENDIF

  cPrecio:=ALLTRIM(FDP(aLine[oAsisVtaR:nColPrecio],"999,999,999,999.99"))
 
  AADD(aData,{ALLTRIM(aLine[2])+CRLF+aLine[1]+" "+cPrecio,oAsisVtaR:nCantid,oAsisVtaR:nCantid*aLine[oAsisVtaR:nColDolar],ACLONE(aLine)})

  oAsisVtaR:oBrwF:aArrayData:=ACLONE(aData)
  oAsisVtaR:oBrwF:GoBottom()

  EJECUTAR("BRWCALTOTALES",oAsisVtaR:oBrwF,.T.)
 
  oAsisVtaR:aData:=ACLONE(aData)

  ARREDUCE(oAsisVtaR:oBrw:aArrayData,oAsisVtaR:oBrw:nArrayAt)

  oAsisVtaR:oBrwFocus:=oAsisVtaR:oBrw

  IF Empty(oAsisVtaR:oBrw:aArrayData)
    oAsisVtaR:oBrw:aArrayData:=ACLONE(oAsisVtaR:aData2)
    oAsisVtaR:oBrwFocus:=oAsisVtaR:oBrwF
  ENDIF
 
  oAsisVtaR:oBrw:nArrayAt:=MIN(oAsisVtaR:oBrw:nArrayAt,LEN(oAsisVtaR:oBrw:aArrayData))
  oAsisVtaR:oBrw:DrawLine(.T.)
// nArrayAt

  oAsisVtaR:oBrw:nColSel:=oAsisVtaR:nColCantid
  oAsisVtaR:oBrw:nRowSel:=MIN(oAsisVtaR:oBrw:nRowSel,nRowSel)
  oAsisVtaR:oBrw:Refresh(.F.)

  // Restaura Cantidad
  oAsisVtaR:oCantid:VarPut(oAsisVtaR:nCantOrg,.T.)
 
  oAsisVtaR:CALTOTAL() // Calcular Totales
  oAsisVtaR:oBrwF:GoBottom(.T.)

RETURN .T.

/*
// Calcular Total e IVA
*/
FUNCTION CALTOTAL()
 LOCAL aData  :=oAsisVtaR:oBrwF:aArrayData,I,cTipIva
 LOCAL nMtoIva:=0,nMtoBase:=0,nPorIva:=0,aLine,aTotal
 LOCAL nCol   :=3

 IF !Empty(oAsisVtaR:cCodCli)
    nCol   :=IIF(SQLGET("DPCLIENTES","CLI_ZONANL","CLI_CODIGO"+GetWhere("=",oAsisVtaR:cCodCli),NIL,oDp:oDbLic)="N",3,5)
 ENDIF

 oAsisVtaR:nMtoIva:=0

 FOR I=1 TO LEN(aData)

     aLine  :=aData[I,4]

     IF !Empty(aLine)

       cTipIva:=aLine[14+1]
       nPorIva:=0

       IF oAsisVtaR:lIva
         nPorIva:=EJECUTAR("IVACAL",cTipIva,nCol,oAsisVtaR:dFecha)
       ENDIF

       oAsisVtaR:nMtoIva:=oAsisVtaR:nMtoIva+PORCEN(aData[I,3],nPorIva)

     ENDIF

  NEXT I

  aTotal:=ATOTALES(aData)
  oAsisVtaR:nMtoBase:=aTotal[3]
  oAsisVtaR:nMtoNeto:=oAsisVtaR:nMtoBase+oAsisVtaR:nMtoIva
  oAsisVtaR:nMtoBs  :=oAsisVtaR:nMontoDiv*oAsisVtaR:nMtoNeto

// ? oAsisVtaR:nMtoIva,"oAsisVtaR:nMtoIva",oAsisVtaR:nMtoNeto

  oAsisVtaR:nTotal:=aTotal[3]
  oAsisVtaR:oBtnSave:ForWhen(.T.)

  oAsisVtaR:oMtoBase:Refresh(.T.)
  oAsisVtaR:oMtoIva:Refresh(.T.)
  oAsisVtaR:oMtoNeto:Refresh(.T.)
  oAsisVtaR:oMtoBs:Refresh(.T.)

  oAsisVtaR:oBtnDel:ForWhen(.T.)

RETURN .T.

FUNCTION INVCANTID()
RETURN .T.

FUNCTION BRWCHANGE2()
   LOCAL aLine:=oAsisVtaR:oBrw:aArrayData[oAsisVtaR:oBrw:nArrayAt]
   LOCAL cFileBmp:=aLine[LEN(aLine)]

   oAsisVtaR:lVerProducto:=!Empty(aLine[1])
   oAsisVtaR:oBtnInv:ForWhen(.T.)

   oAsisVtaR:VERFOTO(cFileBmp)

RETURN .T.

FUNCTION VERFOTO(cFichero)

  DEFAULT cFichero:="FOTOS\sensoroxigeno.bmp"

  IF !FILE(cFichero)
     cFichero:="FOTOS\SINIMAGEN.bmp"
  ENDIF

  oAsisVtaR:oImg:LoadBmp(cFichero)

  sysrefresh()

RETURN .T.

/*
// Asigna Tipo de Documento
*/
FUNCTION SETTIPDOC(cTipDoc)
  LOCAL cScope,cCodSuc:=oDp:cSucursal
  LOCAL cNumero
  LOCAL oData  :=DATASET("SUC_V"+oDp:cSucursal,"ALL")
  LOCAL cNumIni:=oData:Get(cTipDoc+"Numero",STRZERO(0,10))

  oData:End()

// cNumFis   :=oData:Get(oTIPDOCCLI:cTipDoc+"NumFis",STRZERO(0,10))
// oTIPDOCCLI:TDC_PICFIS:=oData:Get(oTIPDOCCLI:cTipDoc+"PicFis",REPLI("9",10) )


  oAsisVtaR:cTipDoc:=cTipDoc
  oAsisVtaR:oTipDoc:Refresh(.T.)

  cScope:="DOC_CODSUC"+GetWhere("=",cCodSuc)+" AND "+;
          "DOC_TIPDOC"+GetWhere("=",cTipDoc)+" AND "+;
          "DOC_TIPTRA"+GetWhere("=","D")

// Obtiene Numero de Documento Cuando No es Impresora Epson
  cNumero:=SQLINCREMENTAL("DPDOCCLI","DOC_NUMERO",cScope)
  cNumero:=IIF(cNumero>cNumIni,cNumero,cNumIni)

  oAsisVtaR:lIva     :=SQLGET("DPTIPDOCCLI","TDC_IVA","TDC_TIPO"+GetWhere("=",cTipDoc))

  IF ValType(oAsisVtaR:oMtoBs)="O"
    oAsisVtaR:CALTOTAL()
  ENDIF

  oAsisVtaR:cNumero:=cNumero
  oAsisVtaR:oNumero:Refresh(.T.)

RETURN .T.

FUNCTION SELPLANTILLA()
  LOCAL cWhere,cCodSuc,nPeriodo,dDesde,dHasta,cTitle,cTipDes
  EJECUTAR("BRPLATODOC",cWhere,cCodSuc,nPeriodo,dDesde,dHasta,cTitle,cTipDes,oAsisVtaR)
RETURN .T.

FUNCTION  VERTREE(oTree,cPrompt)
  LOCAL cPrompt:=oTree:GetSelText(),nAt,nLen
  LOCAL cModelo:=SPACE(LEN(oAsisVtaR:cModelo))

  // Marcas
  IF CRLF$cPrompt .AND. !Empty(cPrompt)

    nAt:=RAT("(",cPrompt)
    IF nAt>0
      cPrompt:=LEFT(cPrompt,nAt-1)
    ENDIF

    cPrompt:=STRTRAN(cPrompt,CRLF,"")
    oAsisVtaR:INVBUSCARANO("MAR_DESCRI"+GetWhere("=",cPrompt))

    RETURN .T.

  ENDIF
 
  IF CHR(10)$cPrompt .AND. !Empty(cPrompt)
    nAt:=RAT("(",cPrompt)
    cPrompt:=LEFT(cPrompt,nAt-1)
    nLen   :=LEN(oAsisVtaR:cPieza)
    cPrompt:=PADR(cPrompt,nLen)
    oAsisVtaR:oPieza:VarPut(cPrompt,.T.)
    oAsisVtaR:oModelo:VarPut(cModelo,.T.)

    RETURN .T.
  ENDIF

  IF CHR(13)$cPrompt .AND. !Empty(cPrompt)
    nAt:=RAT("(",cPrompt)
    cPrompt:=LEFT(cPrompt,nAt-1)
    nLen   :=LEN(oAsisVtaR:cModelo)
    cPrompt:=PADR(cPrompt,nLen)
    oAsisVtaR:oModelo:VarPut(cPrompt,.T.)
    oAsisVtaR:INVBUSCARANO()
    RETURN .T.
  ENDIF

RETURN .T.
/*
// Genera Correspondencia Masiva
*/
FUNCTION GUARDARDOC()
  LOCAL dHasta :=oAsisVtaR:dHasta
  LOCAL x      :=oAsisVtaR:oBrwF:aArrayData:=ACLONE(oAsisVtaR:aData),y:=oAsisVtaR:oBrwF:Refresh(.f.)
  LOCAL cDescri:=ALLTRIM(SQLGET("DPTIPDOCCLI","TDC_DESCRI","TDC_TIPO"+GetWhere("=",oAsisVtaR:cTipDoc)))
  LOCAL aData  :=ACLONE(oAsisVtaR:oBrwF:aArrayData)
  LOCAL nMonto :=0

  oAsisVtaR:CALTOTAL()
  oAsisVtaR:SETTIPDOC(oAsisVtaR:cTipDoc)

  IF Empty(oAsisVtaR:cCodCli)
    oAsisVtaR:oCodCli:MsgErr("Código de Cliente Requerido","Validación")
    RETURN .F.
  ENDIF

 
  nMonto :=oAsisVtaR:nMtoNeto

  IF !MsgNoYes("Desea Crear Documento "+oAsisVtaR:cTipDoc+" #"+oAsisVtaR:cNumero+" "+cDescri+CRLF+"Monto "+ALLTRIM(TRAN(nMonto,"999,999,999,999.99"))+oDp:cMonedaExt+CRLF+ALLTRIM(ENLETRAS(nMonto))+oDp:cMonedaExt)
     RETURN .T.
  ENDIF

  ADEPURA(aData,{|a,n|a[3]=0 })

  EJECUTAR("DPASISVTA_CRACREADOC",oAsisVtaR,oAsisVtaR:cCodSuc,oAsisVtaR:cCodCli,aData,oAsisVtaR:cTipDoc,oAsisVtaR:lHtml,oAsisVtaR:lAuto)


  // Reinicia el Documento
  oAsisVtaR:aData          :=ACLONE(oAsisVtaR:aVacio)
  oAsisVtaR:oBrwF:aArrayData:=ACLONE(oAsisVtaR:aVacio)
 
  oAsisVtaR:oBrwF:nArrayAt:=MIN(oAsisVtaR:oBrwF:nArrayAt,LEN(oAsisVtaR:oBrwF:aArrayData))
  oAsisVtaR:oBrwF:nRowSel :=MIN(oAsisVtaR:oBrwF:nRowSel ,oAsisVtaR:oBrwF:nArrayAt)

  oAsisVtaR:oBrwF:Refresh(.F.)

  oAsisVtaR:CALTOTAL() // Calcular Totales

  oAsisVtaR:oCodCli:VarPut(CTOEMPTY(oAsisVtaR:cCodCli),.T.)
  oAsisVtaR:oNomCli:VarPut(CTOEMPTY(oAsisVtaR:cNomCLi),.T.)

RETURN .T.

FUNCTION VERPRODUCTO()
 LOCAL aLine:=oAsisVtaR:oBrwFocus:aArrayData[oAsisVtaR:oBrwFocus:nArrayAt]

// ? aLine,oAsisVtaR:oBrwFocus

 IF Empty(aLine[1])
    RETURN .T.
 ENDIF

 IF LEN(aLine)>10
    EJECUTAR("DPINV",0,aLine[1])
    RETURN .F.
 ENDIF

 aLine:=aLine[4]
 IF LEN(aLine)>10
    EJECUTAR("DPINV",0,aLine[1])
    RETURN .F.
 ENDIF

// ? oAsisVtaR:oBrwFocus:ClassName(),aLine[1],LEN(aLine)
// ViewArray(aLine)

RETURN .T.

FUNCTION PUTCANTID(oCol,uValue,nCol)
  oAsisVtaR:oBrw:aArrayData[oAsisVtaR:oBrw:nArrayAt,nCol+0]:=uValue
  oAsisVtaR:oBrw:DrawLine(.T.)

  oAsisVtaR:nCantOrg:=oAsisVtaR:nCantid

  oAsisVtaR:oCantid:VarPut(uValue,.T.)
  oAsisVtaR:nCantid:=uValue

  oAsisVtaR:oBrw:nColSel:=nCol+1

RETURN .T.

FUNCTION PUTDOLAR(oCol,uValue,nCol)
  LOCAL nBs:=ROUND(uValue*oAsisVtaR:nValCam,2)

  oAsisVtaR:oBrw:aArrayData[oAsisVtaR:oBrw:nArrayAt,nCol+0]:=uValue
  oAsisVtaR:oBrw:aArrayData[oAsisVtaR:oBrw:nArrayAt,nCol+1]:=nBs
  oAsisVtaR:oBrw:DrawLine(.T.)

  oAsisVtaR:oBrw:nColSel:=nCol+1

RETURN .T.

FUNCTION PUTMONTO(oCol,uValue,nCol)
  LOCAL nUsd:=ROUND(uValue/oAsisVtaR:nValCam,2)

  oAsisVtaR:oBrw:aArrayData[oAsisVtaR:oBrw:nArrayAt,nCol+0]:=uValue
  oAsisVtaR:oBrw:aArrayData[oAsisVtaR:oBrw:nArrayAt,nCol-1]:=nUsd
// oAsisVtaR:oBrw:nColSel:=10
// oAsisVtaR:RUNCLICKBRW2()
// oAsisVtaR:oBrw:Refresh(.F.) // DrawLine(.T.)
 oAsisVtaR:oBrw:nColSel:=nCol+1 // 10+1n

RETURN .T.

FUNCTION BRWDELITEM()
  LOCAL aLine:={}

  IF !MsgNoYes("Desea Remover Item "+LSTR(oAsisVtaR:oBrwF:nArrayAt))
     RETURN .T.
  ENDIF


  aLine:=ACLONE(oAsisVtaR:oBrwF:aArrayData[oAsisVtaR:oBrwF:nArrayAt,4])

  IF !Empty(aLine)
    AINSERTAR(oAsisVtaR:oBrw:aArrayData,1,aLine)
    oAsisVtaR:oBrw:nArrayAt:=1
    oAsisVtaR:oBrw:GoTop()
    oAsisVtaR:oBrw:Refresh(.F.)
  ENDIF

  ARREDUCE(oAsisVtaR:oBrwF:aArrayData,oAsisVtaR:oBrwF:nArrayAt)

  IF Empty(oAsisVtaR:oBrwF:aArrayData)
    oAsisVtaR:aData          :=ACLONE(oAsisVtaR:aVacio)
    oAsisVtaR:oBrwF:aArrayData:=ACLONE(oAsisVtaR:aVacio)
  ENDIF

  oAsisVtaR:oBrwF:nArrayAt:=MIN(oAsisVtaR:oBrwF:nArrayAt,LEN(oAsisVtaR:oBrwF:aArrayData))
  oAsisVtaR:oBrwF:nRowSel :=MIN(oAsisVtaR:oBrwF:nRowSel ,oAsisVtaR:oBrwF:nArrayAt)

  oAsisVtaR:oBrwF:Refresh(.F.)

  oAsisVtaR:CALTOTAL() // Calcular Totales


RETURN .T.


FUNCTION RUNCLICKBRWG()
  LOCAL aLine :=ACLONE(oAsisVtaR:oBrwG:aArrayData[oAsisVtaR:oBrwG:nArrayAt])
  LOCAL cWhere:="INV_GRUPO"+GetWhere("=",aLine[1])

  oAsisVtaR:GetDataLic(.F.,cWhere,oAsisVtaR:oBrw)
  DPFOCUS(oAsisVtaR:oBrw)

RETURN .T.

FUNCTION BUSCARCLIENTE()
  LOCAL cWhere

  IF Empty(oAsisVtaR:cNomCLi)
     RETURN .T.
  ENDIF

  cWhere:="CLI_NOMBRE"+GetWhere(" LIKE ","%"+ALLTRIM(oAsisVtaR:cNomCLi)+"%")

  oDpLbx:=DpLbx("DPCLIENTES",NIL,cWhere) 
  oDpLbx:GetValue("CLI_CODIGO",oAsisVtaR:oCodCli)

RETURN .T.
// EOF

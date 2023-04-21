// Testing FiveWin splitter controls

#include "DPXBASE.ch"
#include "Splitter.ch"

FUNCTION Main()

   PUBLICO("cTitle","Testing the Splitter controls")
  
   PUBLICO("cInfo","Lee las indicaciones que he puesto al final de cada " + ;
                   "programa fuente." + CRLF + "R.Avenda±o.")
   
   PUBLICO("oCursorHand")


   PUBLICO("oWnd")
   PUBLICO("oMenu")
   PUBLICO("oBar")
   PUBLICO("oBmp")
   PUBLICO("oSay1")
   PUBLICO("oSay2")
   PUBLICO("oSay3")
   PUBLICO("oSay4")

   PUBLICO("oVSplit1")
   PUBLICO("oVSplit2")
   PUBLICO("oHSplit1")
   PUBLICO("oHSplit2")
   PUBLICO("oWndChild")

//   DEFINE WINDOW oWndChild FROM 0,0 TO 300,400 PIXEL MDICHILD OF oWnd;

   DpMDI("cTitle","oTest","TESTSLPLITTER.EDT",NIL)

   oTest:Windows(0,0,600,1000,.T.) // Maximizado
   oWndChild:=oTest:oWnd

   @ 0,0     SAY oSay1 PROMPT "Control 1" SIZE 100,205 PIXEL BORDER COLOR CLR_WHITE, CLR_BLUE OF oWndChild
   @ 0,105   SAY oSay2 PROMPT "Control 2" SIZE 205,100 PIXEL BORDER COLOR CLR_WHITE, CLR_RED OF oWndChild
   @ 210,0   SAY oSay3 PROMPT "Control 3" SIZE 205,100 PIXEL BORDER COLOR CLR_BLACK, CLR_YELLOW OF oWndChild
   @ 105,210 SAY oSay4 PROMPT "Control 4" SIZE 100,205 PIXEL BORDER COLOR CLR_WHITE, CLR_GREEN OF oWndChild

   @ 105,105 BITMAP oBmp SIZE 100,100 PIXEL FILE "BITMAPS\LOGO.BMP" ADJUST OF oWndChild


   @ 205,0  SPLITTER oHSplit1 ;
            HORIZONTAL ;
            PREVIOUS CONTROLS oSay1, oVSplit2, oBmp ;
            HINDS CONTROLS oSay3 ;
            TOP MARGIN oHSplit2:nFirst + oHSplit2:nWidth + 1 ;
            BOTTOM MARGIN 10 ;
            SIZE 205, 4 PIXEL ;
            OF oWndChild ;
            COLOR CLR_RED

  @ 105,205 SPLITTER oVSplit1 ;
            VERTICAL ;
            PREVIOUS CONTROLS oSay3, oHSplit1, oBmp ;
            HINDS CONTROLS oSay4 ;
            LEFT MARGIN oVSplit2:nFirst + oVSplit2:nWidth + 1 ;
            RIGHT MARGIN 10 ;
            SIZE 4, 205  PIXEL ;
            OF oWndChild ;
            COLOR CLR_BLUE

  @ 100,105 SPLITTER oHSplit2 ;
            HORIZONTAL ;
            PREVIOUS CONTROLS oSay2 ;
            HINDS CONTROLS oSay4, oVSplit1, oBmp ;
            TOP MARGIN 10 ;
            BOTTOM MARGIN oHSplit1:nLast + oHSplit1:nWidth + 1 ;
            SIZE 205, 4 PIXEL ;
            OF oWndChild ;
            COLOR CLR_YELLOW

  @ 0,100  SPLITTER oVSplit2 ;
            VERTICAL ;
            PREVIOUS CONTROLS oSay1 ;
            HINDS CONTROLS oSay2, oHSplit2, oBmp ;
            LEFT MARGIN 10 ;
            RIGHT MARGIN oVSplit1:nLast + oVSplit1:nWidth + 1 ;
            SIZE 4, 205  PIXEL ;
            OF oWndChild ;
            COLOR CLR_GREEN

  oHSplit1:aPrevCtrols := { oSay1, oVSplit2, oBmp }

 /* esta asignaci¾n es necesaria por que cuando se definio oHSplit1
     oVSplit2 no estaba definido aun.                                
 */

  oTest:Activate({|| oTest:INICIO()})

/*
  ACTIVATE WINDOW oWndChild ;
     ON RESIZE ( oHSplit1:AdjLeft(), ;
                 oVSplit1:AdjBottom(), ;
                 oHSplit2:AdjRight(), ;
                 oVSplit2:AdjTop() ) ;
     ON INIT Eval( oWndChild:bResized )
*/
return nil

FUNCTION INICIO()

   oTest:oWnd:bResized:={||( oHSplit1:AdjLeft(), ;
                             oVSplit1:AdjBottom(), ;
                             oHSplit2:AdjRight(), ;
                         	    oVSplit2:AdjTop() ) }


   Eval( oTest:oWnd:bResized )


RETURN .T.

//----------------------------------------------------------------------------//

function DlgCreate()

  local oDlg

  local oLbx, oGet

  local oSplit

  DEFINE DIALOG oDlg SIZE 400, 300 WINDOW oWnd ;
         TITLE "Dialog Splitter"

  SELECT 1
  USE EJEMPLO1.DBF

  @ 5,5 LISTBOX oLbx FIELDS SIZE 80,120 PIXEL OF oDlg

  @ 5,90 GET oGet VAR EJEMPLO1->SINTAX TEXT SIZE 102,119 PIXEL OF oDlg

  oLbx:bChange:={|| oGet:Refresh() }

  @ 5, 85  SPLITTER oSplit ;
           VERTICAL ;
           PREVIOUS CONTROLS oLbx ;
           HINDS CONTROLS oGet ;
           LEFT MARGIN 100 ;
           RIGHT MARGIN 120 ;
           SIZE 4, 120  PIXEL ;
           OF oDlg ;
           _3DLOOK

 @ 130,80 BUTTON "&Cerrar" SIZE 42,11 PIXEL ACTION oDlg:End() OF oDlg

 ACTIVATE DIALOG oDlg CENTERED

return nil

//----------------------------------------------------------------------------//

function DlgResource()

  local oDlg

  local oGet1, oGet2, oGet3

  local oSplit

  local cVar1:=SPACE(255), cVar2:=SPACE(255), cVar3:=SPACE(255)

  DEFINE DIALOG oDlg RESOURCE "TEST_SPLITTER" OF oWnd

  REDEFINE GET oGet1 VAR cVar1 TEXT ID 101 OF oDlg
  REDEFINE GET oGet2 VAR cVar2 TEXT ID 103 OF oDlg
  REDEFINE GET oGet3 VAR cVar3 TEXT ID 104 OF oDlg

  REDEFINE SPLITTER oSplit ID 102 ;
           HORIZONTAL ;
           PREVIOUS CONTROLS oGet1 ;
           HINDS CONTROLS oGet2, oGet3 ;
           TOP MARGIN 20 ;
           BOTTOM MARGIN 60 ;
           OF oDlg ;
           ON CHANGE MsgBeep() ;
           _3DLOOK

  REDEFINE BUTTON ID 201 OF oDlg ACTION oSplit:SetPosition(39)
  REDEFINE BUTTON ID 202 OF oDlg ACTION oSplit:SetPosition(82)
  REDEFINE BUTTON ID 203 OF oDlg ACTION oSplit:SetPosition(124)

  REDEFINE BUTTON ID 1 OF oDlg ACTION oDlg:End()

  ACTIVATE DIALOG oDlg

return nil


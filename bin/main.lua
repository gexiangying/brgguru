package.cpath = "./?51.dll;./?.dll"
require('iuplua')
require( "iupluacontrols" )
require("menu")
require("tree")

APPNAME = 'BrgGuru'

MDIMenu = menu.mainmenu
t = tree.get_tree() 
MainForm = iup.dialog{
  menu = MDIMenu,
  TITLE = APPNAME,
  PLACEMENT = "MAXIMIZED",
  MDIFRAME = 'YES',
	SHRINK = "YES",
	ICON="SMALL.ICO",
  iup.vbox {
  	iup.hbox {
	  iup.split {
	    VALUE = '200',
		AUTOHIDE = "YES",
  	    iup.vbox {
  	      iup.frame { t, NULL }
	    },
	    iup.vbox {
		iup.canvas { 
          EXPAND = 'YES', 
          MDICLIENT = 'YES', 
     --     BGCOLOR = '128 128 128' 
     	  --MDIMENU = MDIMenu
          }
	    }, NULL,
	  },
	}, NULL, 
  },
}
MainForm:map()
tree.add_nodes(t)

--local mat = iup.matrix {numcol=5, numlin=3,numcol_visible=5, numlin_visible=3, widthdef=34}
local mat = iup.matrix{widthdef=34}
mat.resizematrix = "YES"
--[[
mat:setcell(0,0,"Inflation")
mat:setcell(1,0,"Medicine")
mat:setcell(2,0,"Food")
mat:setcell(3,0,"Energy")
mat:setcell(0,1,"January 2000")
mat:setcell(0,2,"February 2000")
mat:setcell(1,1,"5.6")
mat:setcell(2,1,"2.2")
mat:setcell(3,1,"7.2")
mat:setcell(1,2,"4.6")
mat:setcell(2,2,"1.3")
mat:setcell(3,2,"1.4")
--]]
MDI1Form = iup.dialog{
  TITLE = 'MDI1',
  MDICHILD = 'YES',
  PARENTDIALOG = MainForm,
  PLACEMENT = "FULL",
  RESIZE = "YES",
  ICON="SMALL.ICO",
  CONTROL="YES",
  iup.vbox{mat,EXPAND="YES"}
}

MainForm:show()
MDI1Form:show()
iup.Refresh(MainForm)

function redraw_mat()
mat.numcol =1
mat.numcol_visible =1
mat.numlin=1
mat.numlin_visible=1
mat:setcell(0,0,"Inflation")
mat:setcell(1,0,"Medicine")
mat:setcell(2,0,"Food")
mat:setcell(3,0,"Energy")
mat:setcell(0,1,"January 2000")
mat:setcell(0,2,"February 2000")
mat:setcell(1,1,"5.6")
mat:setcell(2,1,"2.2")
mat:setcell(3,1,"7.2")
mat:setcell(1,2,"4.6")
mat:setcell(2,2,"1.3")
mat:setcell(3,2,"1.4")
iup.UpdateChildren(MDI1Form)
end
function rollback_mat()
mat.numcol =5
mat.numcol_visible =5
mat.numlin=3
mat.numlin_visible=3
mat:setcell(0,0,"Inflation")
mat:setcell(1,0,"Medicine")
mat:setcell(2,0,"Food")
mat:setcell(3,0,"Energy")
mat:setcell(0,1,"January 2000")
mat:setcell(0,2,"February 2000")
mat:setcell(1,1,"5.6")
mat:setcell(2,1,"2.2")
mat:setcell(3,1,"7.2")
mat:setcell(1,2,"4.6")
mat:setcell(2,2,"1.3")
mat:setcell(3,2,"1.4")
iup.UpdateChildren(MDI1Form)
end
menu.set_action(menu.item_new,redraw_mat)
menu.set_action(menu.item_open,rollback_mat)
if (iup.MainLoopLevel()==0) then
  iup.MainLoop()
end

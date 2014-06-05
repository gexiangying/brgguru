module(...,package.seeall)
function get_main(MDIMenu,t)
local MainForm = iup.dialog{
  menu = MDIMenu,
  TITLE = "BrgGuru",
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
	SHRINK="YES",	  
     --     BGCOLOR = '128 128 128' 
     	  --MDIMENU = MDIMenu
          }
	    }, NULL,
	  },
	}, NULL, 
  },
}
MainForm:map()
return MainForm
end

function get_child(mat)
local MDI1Form = iup.dialog{
  TITLE = 'MDI1',
  MDICHILD = 'YES',
  PARENTDIALOG = MainForm,
  PLACEMENT = "FULL",
  RESIZE = "YES",
  ICON="SMALL.ICO",
  CONTROL="YES",
  SHRINK="YES",
  iup.vbox{mat,EXPAND="YES"}
}
return MDI1Form;
end

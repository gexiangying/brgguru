package.cpath = "./?51.dll;./?.dll"
require('iuplua')
require( "iupluacontrols" )
require("menu")
require("tree")
require("matrix")
require("frm")
require("file")
require("session")
require("jieguo")
require "ado"

project = {}
project.name = ""
project.cur_round = 0
project.rounds = 0
project.round = {}
project.sections = 0
project.desks = 0

MDIMenu = menu.mainmenu
t = tree.get_tree()
mat = matrix.get_matrix()
file.link_menu(menu)
session.link_menu(menu)
jieguo.link_menu(menu)

MainForm = frm.get_main(MDIMenu,t)
MDI1Form = frm.get_child(mat)
MainForm:show()
MDI1Form:show()
iup.Refresh(MainForm)


if (iup.MainLoopLevel()==0) then
  iup.MainLoop()
end

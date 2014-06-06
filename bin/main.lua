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

file.link_menu(menu)
session.link_menu(menu)
jieguo.link_menu(menu)

MainForm = frm.get_main(menu.mainmenu,tree.get_tree())
MDI1Form = frm.get_child(matrix.get_matrix())
MainForm:show()
MDI1Form:show()
iup.Refresh(MainForm)


if (iup.MainLoopLevel()==0) then
  iup.MainLoop()
end

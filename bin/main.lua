package.cpath = "./?51.dll;./?.dll"

require('iuplua')
require( "iupluacontrols" )
require("menu")
require("tree")
require("matrix")
require("frm")
require("file")
require("session")
require("result")
require ("mgr")
require "ado"


project = {}
project.cur_round = 0
project.data = {}
function init_prj()
 project = {}
 project.cur_round = 0
 project.data={}
end

file.link_menu(menu)
session.link_menu(menu)
result.link_menu(menu)

MainForm = frm.get_main(menu.mainmenu,tree.get_tree())
MDI1Form = frm.get_child(matrix.get_matrix())


MainForm:show()
MDI1Form:show()
iup.Refresh(MainForm)


if (iup.MainLoopLevel()==0) then
  iup.MainLoop()
end

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

--[[
project = { desks=;cur_round=;type=;database_name=;sections=;players_num=;rounds=;name=;file_name=;db_string=;
data = {{},}
players[no][round] ={vp,boards,ximp,mp}
players[no] = {no,mp,ximp,vp,boards,bonus}
round[round][desk] = {l,h,NS,EW,section}
}
--]]
project = {}

function init_prj()
 project = {}
 project.cur_round = 0
 project.data={}
 project.session_type = 0
end

init_prj()

file.link_menu(menu)
session.link_menu(menu)
result.link_menu(menu)

mat_control = matrix.get_matrix()
MainForm,sp = frm.get_main(menu.mainmenu,tree.get_tree())
MDI1Form = frm.get_child(mat_control)


MainForm:show()
MDI1Form:show()
iup.Refresh(MainForm)


if (iup.MainLoopLevel()==0) then
  iup.MainLoop()
end

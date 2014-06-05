module(...,package.seeall)
require "luabridge"


function download()
local data = {}
local temp_r = {}
local db_string = project.db_string
if not db_string then return end
local db = ADO_Open(db_string)
db:exec("select * from [ReceivedData]")
local t = db:row()

if t then
while t ~= nil do
local set = {}

set.NS = t.PairNS

set.EW = t.PairEW

local declare = string.gsub(t["NS/EW"]," ","")
local contract = string.gsub(t.Contract," ","")

if contract == "PASS" then
declare = ""
contract = "AP"
end

local result = t.Result
set.board = t.Board
set.table = t.Table
set.round = t.Round
set.section = t.Section
set.erased = t.Erased
set.constr = declare .. contract .. result
local flag
flag,set.score = luabridge.score(tonumber(set.board),set.constr)

temp_r[set.round] = temp_r[set.round] or {}
temp_r[set.round][set.NS] = temp_r[set.round][set.NS] or {}
temp_r[set.round][set.NS][set.EW] = temp_r[set.round][set.NS][set.EW] or {}
if not set.erased then
if not temp_r[set.round][set.NS][set.EW][set.board] then
temp_r[set.round][set.NS][set.EW][set.board] = true
table.insert(data,set)
end
end
t= db:row()
end
end
db:close()

project.data = data
end

function show_data()
 local cur = project.cur_round or 0
 local desk = 1
 status,cur,desk = iup.GetParam("ÏÔÊ¾",nil,"ÂÖ´Î %i\n×ÀºÅ %i\n",cur,desk)
 if not status then return end
 matrix.reset(mat,"data",cur,desk)
end

function cal()
end

function sum()
end



local function random_contract()
  local Declare = math.random(1,4)
  local str= {"N","E","S","W"}
  local num = math.random(1,7)
  local color = math.random(1,4)
  local color_str={"C","D","H","S"}
  local tricks = math.random(1,13)
  local result = Declare .. ",'" .. str[Declare] .. "','" .. num .. color_str[color] .. "',"
  if(tricks > num + 6) then
   result = result .. "'+" .. tricks-num-6 .. "'"
   elseif tricks == num +6 then
   result = result .. "'='"
   else
   result = result .. "'-" .. num+6 - tricks .. "'"
  end
  return result
end

function test()
math.randomseed(os.time())
local db_string = project.db_string
  if db_string then 
  local db = ADO_Open(db_string)
  local round = project.round[project.cur_round]
  local cur_round = project.cur_round
  db:exec("delete * from [ReceivedData] where [Round] = " .. cur_round)
  for k,v in pairs(round) do
   local section = v.section
   local NS = v.NS
   local EW = v.EW 
   local l = v.l
   local h = v.h
   for i=l,h do
   db:exec("insert into [ReceivedData] ([Section],[Table],[Round],[Board],[PairNS],[PairEW],[Declarer],[NS/EW],[Contract],[Result]) VALUES ( " ..
     section .. "," .. k .. "," .. cur_round .. "," .. i .. "," .. NS .. "," .. EW .. "," .. random_contract().. ")")
   end
  end
  db:close()
  end
end

function link_menu(menu)
 menu.item_result_get.action = download
 menu.item_result_show_data.action = show_data
 menu.item_result_cal.action = cal
 menu.item_result_sum.action = sum
 menu.item_result_create.action = test
end


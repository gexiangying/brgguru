module(...,package.seeall)
require "luabridge"
require "brg"

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
cal()
end

function show_data()
 local cur = project.cur_round or 0
 local desk = 1
 local status
 status,cur,desk = iup.GetParam("显示",nil,"轮次 %i\n桌号 %i\n",cur,desk)
 if not status then return end
 --assert(nil,cur .. desk)
 matrix.reset("data",cur,desk)
end

local function mk_index(sets)
  local index = {}
  for k,v in pairs(sets) do
    table.insert(index,k)
  end
  table.sort(index)
  return index
end

function cal()
 local cur_round = project.cur_round or 0
-- local status
-- status,cur = iup.GetParam("计算",nil,"轮次 %i\n",cur)
-- if not status or cur < 1  then return end
 for cur=1,cur_round do
 local sets = brg.mk_sets(project.data,cur)  -- {[6]={set,set,set},[7]={record,record}}
 local index = mk_index(sets)    --{6,7,8....}
 for i,v in ipairs(index) do
   local rs = sets[v]   --rs = {set,set,set}
   if rs and #rs > 1 then
   brg.mp(rs)
   brg.ximp(rs)
   end
 end
 end
end

local function init_players(cur)
  
  if not project.players_num then return false end
  local players = project.players or {}

  for i=1,project.players_num do
    players[i] = players[i] or {}
    players[i][cur] = players[i][cur] or {}
    players[i][cur].mp =  0.0
    players[i][cur].ximp =  0.0
    players[i][cur].vp =  0.0
    players[i][cur].boards = 0
    players[i].no = i
  end
  
  project.players = players
  return true
end

local function sum_im(v,cur)
  local NS = v.NS
  local EW = v.EW
  local p_ns_cur = project.players[NS][cur]
  local p_ew_cur = project.players[EW][cur]
  
  p_ns_cur.mp = p_ns_cur.mp + (v.NS_mp or 0.0)
  p_ns_cur.ximp = p_ns_cur.ximp + (v.NS_ximp or 0.0)
  p_ns_cur.boards = p_ns_cur.boards + 1
  
  p_ew_cur.mp = p_ew_cur.mp + (v.EW_mp or 0.0)
  p_ew_cur.ximp = p_ew_cur.ximp + (v.EW_ximp or 0.0)
  p_ew_cur.boards = p_ew_cur.boards + 1
  
end

local function ave_result()
  local players = project.players
  for i=1,project.players_num do
     local total_mp = 0.0
     local total_ximp = 0.0
     local total_boards = 0
     for j,v in ipairs(players[i]) do 
        total_mp = total_mp + v.mp
	total_ximp = total_ximp + v.ximp
	total_boards = total_boards + v.boards
     end
    if total_boards >0 then 
       players[i].ave_mp = brg.floor_num(total_mp / total_boards)
       players[i].ave_ximp = brg.floor_num(total_ximp / total_boards)
       players[i].boards = total_boards
    else
       players[i].ave_mp = players[i].ave_mp or 0.0
       players[i].ave_ximp = players[i].ave_ximp or 0.0
       players[i].boards = 0
    end
  end
end

function sum()
  
  local cur = project.cur_round or 0
  if cur < 1 then return end
 
  if not init_players(cur) then return end
  
  for i,v in ipairs(project.data) do
    if v.round == cur then  
      sum_im(v,cur)
    end
  end
  ave_result()
  matrix.reset_sum()
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
 --menu.item_result_show_data.action = show_data
 --menu.item_result_cal.action = cal
 menu.item_result_sum.action = sum
 menu.item_result_create.action = test
end


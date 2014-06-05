require "luabridge"
require "ado"
require "comma"

dofile("setup.lua")
data = {}
temp_r = {}

local db = ADO_Open(db_string)
db:exec("select * from ReceivedData")
t = db:row()

if t then
while t ~= nil do
local set = {}
--NS = t.PairNS * 2 - 1
--EW = t.PairEW * 2
set.NS = t.PairNS
set.EW = t.PairEW
declare = string.gsub(t["NS/EW"]," ","")
contract = string.gsub(t.Contract," ","")
if contract == "PASS" then
declare = ""
contract = "AP"
end
result = t.Result
set.board = t.Board
set.table = t.Table
set.round = t.Round
set.section = t.Section
set.erased = t.Erased
set.constr = declare .. contract .. result
flag,set.score = luabridge.score(tonumber(set.board),set.constr)
--imp = luabridge.imp(score)
--print(board .. "\t" .. NS .. "\t" .. EW .. "\t" .. constr .. "\t" .. score .. "\t" .. imp)
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

local save_t = {}
save_t.data = data
comma.save_file("data.lua",save_t)

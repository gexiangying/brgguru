require("comma")
dofile("setup.lua")
dofile("round_datas.lua")

local updateFromRound = round_datas.cur_round
local cur = round_datas.cur_round
local flag = false

if cur > round_datas.rounds then
	print("END of the game!")
	os.exit()
end
--[[
if updateFromRound ~= round_datas.rounds then
  updateFromRound = updateFromRound + 256
end
--]]

local db = ADO_Open(db_string)

for i,v in ipairs(round_datas) do
 if v.round == cur then
	local NS = v.NS
	local EW = v.EW
  local desk = v.table
	local section = v.section
	local round = v.round
	flag = true
	db:exec("INSERT INTO [RoundData] VALUES(" .. section .. "," .. desk .. "," .. round .. "," .. NS .. "," .. EW .. "," .. v.l .. "," .. v.h  .. ",'')")
 end
end
db:exec("UPDATE Tables SET UpdateFromRound = " .. updateFromRound .. " WHERE UpdateFromRound <> " .. updateFromRound )
db:close()

if not flag then
	print("no round ".. cur .. " data")
	os.exit()
end

round_datas.cur_round = cur + 1

local save_t = {}
save_t.round_datas = round_datas
comma.save_file("round_datas.lua",save_t)

require "comma"
require "brg"

if not arg[3] then
print("lua swiss_tm.lua teams rounds boards")
os.exit()
end

local teams = tonumber(arg[1])
local round_datas = {}
local ns_dat = {}
local ew_dat = {}
local miss = {}
local pk = {}
--`local team_datas = {}

round_datas.rounds = tonumber(arg[2])
round_datas.cur_round = 1
round_datas.section = 2
round_datas.boards = tonumber(arg[3])
--[[
for i =1,teams do
team_datas[i] = 0.0
end
--]]
if teams % 2 == 0 then
round_datas.desks = teams / 2
else
round_datas.desks = (teams - 1) / 2
miss[teams] = 1
--team_datas[teams] = brg.default_vp
end
function add_pk(ns,ew)
	pk[ns] = pk[ns] or {}
	pk[ns][ew] = 1
end
for i = 1,round_datas.section do
  for j = 1,round_datas.desks do
		local temp = {}
		temp.section = i
		temp.round = 1
    temp.table = j
		temp.l = 1
		temp.h = round_datas.boards
		if i == 1 then
		temp.NS = j * 2 - 1
		temp.EW = j * 2 
    add_pk(temp.NS,temp.EW)
    else
		temp.NS = j * 2 
		temp.EW = j * 2 - 1
		add_pk(temp.NS,temp.EW)
    end
		round_datas[#round_datas + 1] = temp
	end 		
end



local save_t = {}
save_t.round_datas = round_datas
--save_t.team_datas = team_datas
comma.save_file("round_datas.lua",save_t)
save_t = {}
save_t.ns_dat = ns_dat
save_t.ew_dat = ew_dat
save_t.miss = miss
save_t.pk = pk
comma.save_file("result.dat",save_t)

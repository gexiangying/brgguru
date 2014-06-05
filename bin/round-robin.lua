require "brg"
require "comma"
if not arg[2] then
print("单循环赛事编排")
print("lua bgl.lua teams boards")
os.exit()
end
--round_datas[n] = { section,round,table,l,h,NS,EW}
local n = tonumber(arg[1])
local m
local desks
local rounds
local teams = n
local round_datas = {}
local ns_dat = {}
local ew_dat = {}
local miss={}
local pk = {}
local flag = false


if (n % 2 == 0) then
m = n
desks = m / 2
else
m = n +1
desks = (n - 1) / 2
flag = true
end

rounds = m - 1

round_datas.rounds = rounds
round_datas.cur_round = 1
round_datas.section = 2
round_datas.boards = tonumber(arg[2])
round_datas.desks = desks

local result = brg.bgl(m)
--result[round] = { n1,n2,.....m}
for i,v in ipairs(result) do
io.write("round " .. i )
	for k,v1 in ipairs(v) do
    io.write("\t" .. v1) 
  end
io.write("\n")
end

for i,v in ipairs(result) do
    local index 
    if flag then
			local no = v[1] < v[2] and v[1] or v[2]
			miss[no] = i
			index = 3
		else
			index = 1
	  end
		for j = index,#v-1,2 do
      local desk = (j -1) /2
      local temp = {}
			temp.round = i
			temp.section = 1
			temp.l = 1
			temp.h = round_datas.boards
      temp.table = desk
      temp.NS = v[j]
			temp.EW = v[j + 1]
			table.insert(round_datas,temp)
      temp = {}
			temp.round = i
			temp.section = 2
			temp.l = 1
			temp.h = round_datas.boards
      temp.table = desk
      temp.NS = v[j + 1]
			temp.EW = v[j]
			table.insert(round_datas,temp)
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

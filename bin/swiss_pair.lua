require "mgr"

if not arg[3] then
print("lua swiss_pair.lua desks rounds boards")
os.exit()
end

local desks = tonumber(arg[1])
local rounds = tonumber(arg[2])
local boards = tonumber(arg[3])
local cur_round = 1
local sections = 1

mgr.init()

mgr.set_sections(1)
mgr.set_desks(tonumber(arg[1]))
mgr.set_rounds(tonumber(arg[2]))
mgr.set_boards(tonumber(arg[3]))
mgr.set_cur_round(1)

for i = 1,desks do
	local NS = i * 2 - 1
	local EW = i * 2
	mgr.add_round(cur_round,sections,i,NS,EW,1,boards)	
	mgr.add_pk(cur_round,NS,EW)
end

mgr.save_round_data()
mgr.save_result_dat()

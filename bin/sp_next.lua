require "mgr"
--io.write(v.name .. "\t\t" .. v.mp .. "\t\t" .. v.ximp .. "\t\t" .. v.plus .. "--" .. v.minus .. "\t\t" .. v.num .. "\t\t" .. v.vp .. "\n")
mgr.load_result()
mgr.load_round_data()

local rounds = mgr.rounds() 
local cur_round = mgr.cur_round()
local desks = mgr.desks()

local paris = {}
for i = 1,desks do
		for j = 1,4 do
			local no = (i - 1) * 4 + j
			local temp = {}
			temp.no = no
			temp.ximp = mgr.cal_ximp(no)
			table.insert(paris,temp)
		end
end

table.sort(paris,function(a,b) return a.ximp > b.ximp end)

for i,v in ipairs(paris) do
	print("no[" .. v.no .. "].ximp =  " .. v.ximp)
end

if cur_round > rounds then 
	print("game over")
	os.exit()
end


if arg[1] and arg[1] == "w" then

	for i = 1,desks do
		mgr.add_round(cur_round,1,desks,paris[i*2 -1].no,paris[i*2].no,1,mgr.boards())	
	end

	mgr.save_round_data()
	mgr.save_result_dat()
end

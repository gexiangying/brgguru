require "comma"
if not arg[1] then
print("lua txs.lua desks")
os.exit()
end

local desks = tonumber(arg[1])

if desks < 3 or desks > 18 then
print("error desks number must between(3,18)")
os.exit()
end
local valid_round = { 0,0,2,2,4,4,6,6,8,8,8,8,12,12,12,12}
local total_sets = 24
local jump_round = 0

if desks % 2 == 0 then
	jump_round = desks /  2
end

local rounds = valid_round[desks]
local sets_perround = total_sets / rounds
local max_sets = sets_perround * desks
local round_datas = {}

round_datas.cur_round = 1
round_datas.rounds = rounds
round_datas.desks = desks
round_datas.section = 1

local desk_info = {}

for i =1,desks do
	desk_info[i] = {}
	desk_info[i].NS = i
	desk_info[i].EW = i
	desk_info[i].boards = {}
	desk_info[i].l = 1 + ( i - 1) * sets_perround
end

local function mv_EW(round,desk,temp)
	local EW  = desk_info[desk].EW - 1
	if round == jump_round then EW = EW -1 end
	if EW <= 0  then EW = EW + desks end
	desk_info[desk].EW = EW
	temp.EW = EW
end

local function mv_board(desk,temp)
	local num = desk_info[desk].l + sets_perround
	if num > max_sets then num = num - max_sets end 
	temp.l = num
	desk_info[desk].l = num
	temp.h = num + sets_perround - 1
end

for i = 1,rounds do
  for j = 1,desks do
		local temp = {}
		temp.section = 1
		temp.round = i
    temp.table = j
		temp.NS = desk_info[j].NS
		mv_EW(i,j,temp)
		mv_board(j,temp)
		round_datas[#round_datas + 1] = temp
	end 		
end

local save_t = {}
save_t.round_datas = round_datas
comma.save_file("round_datas.lua",save_t)

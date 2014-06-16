module(...,package.seeall)

local desks
local total_sets = 24
local valid_round = { 0,0,2,2,4,4,6,6,8,8,8,8,12,12,12,12}
local jump_round = 0
local rounds
local sets_perround
local max_sets
local desk_info = {}

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


function init_txs()

desks =   project.desks
assert(desks >=3 and desks <=18,"error desks number must between(3,18)")

if desks % 2 == 0 then
	jump_round = desks /  2
end

rounds = valid_round[desks]
sets_perround = total_sets / rounds
max_sets = sets_perround * desks


project.rounds = rounds
project.desks = desks
project.section = 1
project.players_num = desks * 2

for i =1,desks do
	desk_info[i] = {}
	desk_info[i].NS = i
	desk_info[i].EW = i
	desk_info[i].boards = {}
	desk_info[i].l = 1 + ( i - 1) * sets_perround
end

project.round = project.round or {}
local round_data = project.round

for i = 1,rounds do
  round_data[i] = {}
  for j = 1,desks do
  round_data[i][j] = {}
		local temp = {}
		temp.section = 1
		temp.round = i
                temp.table = j
		temp.NS = desk_info[j].NS
		mv_EW(i,j,temp)
		mv_board(j,temp)
		round_data[i][j].NS = temp.NS
		round_data[i][j].EW = temp.EW
		round_data[i][j].l = temp.l
		round_data[i][j].h = temp.h
		round_data[i][j].section = 1
	end 		
end

end


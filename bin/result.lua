require "comma"
require "brg"
dofile("data.lua")
dofile("result.dat")

local open
local close
local round = tonumber(arg[1])
local desk = tonumber(arg[2])
local filename
if desk then
	filename = "r" .. round .. "-table" .. desk .. ".txt"
elseif round then
	filename = "r" .. round .. ".txt"
else
  filename = "result.txt"
end 

function add_result_dat(t,v)
	if not round then return end
	t[round] = t[round] or {}
	t[round][v.no] = v
end

local preout = io.output()
io.output(filename)

function floor_result(t)
	t.NS_mp = brg.floor_num(t.NS_mp)
	t.EW_mp = brg.floor_num(t.EW_mp)
	t.NS_ximp = brg.floor_num(t.NS_ximp)
	t.EW_ximp = brg.floor_num(t.EW_ximp)
	t.NS_imp = brg.floor_num(t.NS_imp)
	t.EW_imp = brg.floor_num(t.EW_imp)
end

function print_sets_pair(sets,board)
io.write("#board = " .. board .. "\n")
io.write("NS\t\tEW\t\tcontract\tscore\t\tmp\t\tximp\t\timp\n")
for i,v in ipairs(sets) do
  floor_result(v)
	io.write(v.NS .. "\t\t" ..v.EW .. "\t\t" .. v.constr .. "\t\t" .. v.score .. "\t\t" .. v.NS_mp .. "\t\t" .. v.NS_ximp .. "\t\t" .. v.NS_imp .. "\n")
end
end

function print_sets_team_desk(sets,round,board)
for i,v in ipairs(sets) do
	floor_result(v)
	if v.section == 1 then
		open = v
	elseif v.section == 2 then
		close = v
	end
end
local imp = open.NS_imp
if imp > 0 then
io.write(open.board .. "\t\t" .. open.NS .. "\t\t" ..open.EW .. "\t\t" .. open.constr .. "\t\t" .. close.constr .. "\t\t" .. open.score .. "\t\t" .. -close.score .. "\t\t" .. open.score - close.score .. "\t\t" .. open.NS_imp .. "\n")
elseif imp < 0 then
io.write(open.board .. "\t\t" .. open.NS .. "\t\t" ..open.EW .. "\t\t" .. open.constr .. "\t\t" .. close.constr .. "\t\t" .. open.score .. "\t\t" .. -close.score .. "\t\t" .. open.score - close.score .. "\t\t \t\t" .. -open.NS_imp .. "\n")
else
io.write(open.board .. "\t\t" .. open.NS .. "\t\t" ..open.EW .. "\t\t" .. open.constr .. "\t\t" .. close.constr .. "\t\t" .. open.score .. "\n")
end
io.write("------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
end


function print_sets_team(sets,round,board)
io.write( "board = " .. board .. "\n")
io.write("NS\t\tEW\t\tcontract\tscore\t\tmp\t\tximp\t\timp\n")
for i,v in ipairs(sets) do
  floor_result(v)
	io.write(v.NS .. "\t\t" ..v.EW .. "\t\t" .. v.constr .. "\t\t" .. v.score .. "\t\t" .. v.NS_mp .. "\t\t" .. v.NS_ximp .. "\t\t" .. v.NS_imp .. "\n")
end
end


function cmp_result(a,b)
	if a.mp > b.mp then 
		return true 
  elseif a.mp < b.mp then
		return false 
  elseif a.ximp > b.ximp then
    return true
  else
		return false
  end
end

function sort_result(result)
	local temp = {}
  for k,v in pairs(result) do
    v.name = k
    v.vp = brg.vp(v.num,v.plus - v.minus) 
		table.insert(temp,v)
	end 
	table.sort(temp,cmp_result)
	return temp
end

local sets = brg.mk_sets(data,round,desk)

if round then
io.write("#轮次 = " .. round .. "\n")
io.write("------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
end
if desk then 
io.write("副数\t\t主队\t\t客队\t\t开室\t\t闭室\t\t开室得分\t闭室得分\t主队得分\t主队\t\t客队\n")
io.write("------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
end

for k,v in pairs(sets) do
brg.mp(v)
brg.ximp(v)
brg.imp(v)
if desk then
print_sets_team_desk(v,round,k)
elseif round then
print_sets_team(v,round,k)
else
print_sets_pair(v,k)
end
end

local result = brg.cal_sets_NS(sets)
result = sort_result(result)

if desk then
for i,v in ipairs(result) do
if v.section == 1 then
io.write("\nimp\t\t \t\t \t\t \t\t \t\t \t\t \t\t \t\t " .. v.plus .. "\t\t" .. v.minus .. "\n")
--io.write("------------------------------------------------------------------------------------------------------------------------------------------------------------------\n")
io.write("\nvp\t\t \t\t \t\t \t\t \t\t \t\t \t\t \t\t " .. v.vp .. "\t\t" .. 20-v.vp .. "\n")
end
end
else
io.write("\n\n#result\n\n")
io.write("NAME\t\tMP\t\tximp\t\timp\t\tnum\t\tvp\n")
for i,v in ipairs(result) do
add_result_dat(ns_dat,v)
io.write(v.name .. "\t\t" .. v.mp .. "\t\t" .. v.ximp .. "\t\t" .. v.plus .. "--" .. v.minus .. "\t\t" .. v.num .. "\t\t" .. v.vp .. "\n")
end

io.write("\n\n")
result = brg.cal_sets_EW(sets)
result = sort_result(result)
for i,v in ipairs(result) do
add_result_dat(ew_dat,v)
io.write(v.name .. "\t\t" .. v.mp .. "\t\t" .. v.ximp .. "\t\t" .. v.plus .. "--" .. v.minus .. "\t\t" .. v.num .. "\t\t" .. v.vp .. "\n")
end
end

io.flush()
io.output():close()
io.output(preout)
--os.execute("start  " .. filename)

local save_t = {}
save_t.ns_dat = ns_dat
save_t.ew_dat = ew_dat
save_t.miss = miss
save_t.pk = pk
comma.save_file("result.dat",save_t)

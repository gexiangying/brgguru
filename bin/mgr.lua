require "comma"
module(...,package.seeall)

local round_datas 
local pk 
local miss 
local ew_dat 
local ns_dat

function cal_ximp(no)
	local ximp = 0.0	
	for k,v in pairs(ns_dat) do
		if(v.no == no) then
			ximp = ximp + v.ximp
		end
	end
	for k,v in pairs(ew_dat) do
		if(v.no == no) then
			ximp = ximp + v.ximp
		end
	end
	return ximp
end

function desks()
	return round_datas.desks
end
function rounds()
	return round_datas.rounds
end
function cur_round()
	return round_datas.cur_round
end
function borads()
	return round_datas.borads
end
function load_round_data()
	dofile("round_datas.lua")
	round_datas = _G.round_datas
end

function load_result()
	dofile("result.dat")
	pk  = _G.pk
	miss = _G.miss
	ew_dat = _G.ew_dat
	ns_dat = _G.ns_dat
end

function add_pk(round,NS,EW)
	pk[NS] = pk[NS] or {}
	pk[NS][EW] = round
	pk[EW] = pk[EW] or {}
	pk[EW][NS] = round
end

function add_round(round,section,table,NS,EW,l,h)
	local temp = {}
	temp.round = round
	temp.section = section
	temp.table = table
	temp.NS = NS
	temp.EW = EW
	temp.l = l
	temp.h = h	
	round_datas[#round_datas + 1] = temp
end

function set_rounds(rounds)
	round_datas.rounds = rounds
end
function set_sections(sections)
	round_datas.section = sections
end

function set_boards(boards)
	round_datas.boards = boards
end

function set_cur_round(cur)
	round_datas.cur_round = cur
end
function set_desks(desks)
	round_datas.desks = desks
end
function init()
	init_result()
	init_round_data()
end

function init_result()
	pk = {}
	miss = {}
	ew_dat = {}
	ns_dat = {}
end

function init_round_data()
	round_datas = {}
end

function save_round_data()
	local save_t = {}
	save_t.round_datas = round_datas
	comma.save_file("round_datas.lua",save_t)	
end

function save_result_dat()
	local save_t = {}
	save_t.ns_dat = ns_dat
	save_t.ew_dat = ew_dat
	save_t.miss = miss
	save_t.pk = pk
	comma.save_file("result.dat",save_t)
end

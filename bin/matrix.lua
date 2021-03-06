module(...,package.seeall)

local mat = iup.matrix{widthdef=50,SCROLLBAR="YES"}
mat.resizematrix = "YES"
mode_flag = "round"
function get_matrix()
	return mat
end

local function cmp_ave_ximp(a,b)
	return a.ave_ximp > b.ave_ximp
end

local function cmp_vp(a,b)
	return a.vp > b.vp
end

function get_sort_players()
	local players = {}
	for i,v in ipairs(project.players) do
		players[i] = v
	end
	table.sort(players,cmp_vp)
--[[
	local cur = project.cur_round + 1
	local desks = project.desks 

	local round = project.round
	round[cur] = round[cur] or {}
	local temp = round[cur]
	for i = 1,desks do
		temp[i] = temp[i] or {}
		temp[i].NS = players[i * 2 -1].no
		temp[i].EW = players[i * 2].no
		temp[i].section = 1
	end
	--]]
	return players
end

local function cmp_mp(a,b)
	return a.mp > b.mp
end

function reset_sum1(NS,EW)
	mode_flag = "sum1"
	mat.numcol = 3
	mat.numcol_visible = 3 
	mat.numlin = project.players_num + 1
	mat.numlin_visible = project.players_num + 1
	mat:setcell(0,0,"对号")
	mat:setcell(0,1,"mp")
	mat:setcell(0,2,"总副数")
	mat:setcell(0,3,"ximp")

	table.sort(NS,cmp_mp)
	table.sort(EW,cmp_mp)

	for i,v in ipairs(NS) do
		mat:setcell(i,0,v.no)
		mat:setcell(i,1,brg.floor_num(v.mp / v.boards))
		mat:setcell(i,2,v.boards)
		mat:setcell(i,3,v.ximp)
	end

	for i,v in ipairs(EW) do
		mat:setcell(project.desks + i + 1,0,v.no)
		mat:setcell(project.desks + i + 1,1,brg.floor_num(v.mp / v.boards))
		mat:setcell(project.desks + i + 1,2,v.boards)
		mat:setcell(project.desks + i + 1,3,v.ximp)
	end
	iup.UpdateChildren(MDI1Form)
end

function reset_sum()
	mode_flag = "sum"
	local cur = project.cur_round
	mat.numcol = cur + 4
	mat.numcol_visible = cur + 4
	mat.numlin = project.players_num
	mat.numlin_visible = project.players_num
	mat:setcell(0,0,"对号")
	mat:setcell(0,1,"名次")
	for i=2,cur+1 do
		mat:setcell(0,i,"第" .. i-1 .. "轮")
	end
	mat:setcell(0,cur+2,"vp")
	mat:setcell(0,cur+3,"总副数")
	mat:setcell(0,cur+4,"ximp")
	local players = get_sort_players()
	for i,v in ipairs(players) do
		mat:setcell(i,0,v.no)
		mat:setcell(i,1,i)
		for j=2,cur+1 do
			mat:setcell(i,j,v[j-1].vp) 
		end
		mat:setcell(i,cur+2,v.vp)
		mat:setcell(i,cur+3,v.boards)
		mat:setcell(i,cur+4,v.ximp)
	end
	iup.UpdateChildren(MDI1Form)
end

local function reset_round(cur)
	mat.numcol = 5
	mat.numcol_visible = 5
	mat.numlin=project.desks or 0
	mat.numlin_visible=project.desks or 0
	local desks = project.desks or 0
	mat:setcell(0,0,"桌号")
	mat:setcell(0,1,"NS")
	mat:setcell(0,2,"EW")
	mat:setcell(0,3,"分区")
	mat:setcell(0,4,"起始牌号")
	mat:setcell(0,5,"结束牌号")
	for i=1,desks do
		local round = project.round[cur][i]
		mat:setcell(i,0,i)
		mat:setcell(i,1,round.NS)
		mat:setcell(i,2,round.EW)
		mat:setcell(i,3,round.section)
		mat:setcell(i,4,round.l)
		mat:setcell(i,5,round.h)
	end
end


function reset_txs_board(board)
	mode_flag = "board"
	mat.numcol = 10
	mat.numcol_visible = 10
	local num =0
	for i,v in ipairs(project.data) do
		if v["board"] == board then
			num = num + 1
		end
	end

	mat.numlin= num
	mat.numlin_visible= num

	mat:setcell(0,0,"记录")
	mat:setcell(0,1,"桌号")
	mat:setcell(0,2,"南北")
	mat:setcell(0,3,"东西")
	mat:setcell(0,4,"分区")
	mat:setcell(0,5,"轮次")
	mat:setcell(0,6,"牌号")
	mat:setcell(0,7,"定约")
	mat:setcell(0,8,"得分")
	mat:setcell(0,9,"mp")
	mat:setcell(0,10,"ximp")
	num=0
	for i,v in ipairs(project.data) do
		if v["board"] == board then
			num = num + 1
			mat:setcell(num,0,i)
			mat:setcell(num,1,v["table"])
			mat:setcell(num,2,v["NS"])
			mat:setcell(num,3,v["EW"])
			mat:setcell(num,4,v["section"])
			mat:setcell(num,5,v["round"])
			mat:setcell(num,6,v["board"])
			mat:setcell(num,7,v["constr"])
			mat:setcell(num,8,v["score"])
			mat:setcell(num,9,v.NS_mp or "")
			mat:setcell(num,10,v.NS_ximp or "")
		end
	end
	iup.UpdateChildren(MDI1Form)
end

function reset_board(cur,board)
	mode_flag = "board"
	mat.numcol = 10
	mat.numcol_visible = 10
	local num =0
	for i,v in ipairs(project.data) do
		if v.round == cur and v["board"] == board then
			num = num + 1
		end
	end

	mat.numlin= num
	mat.numlin_visible= num

	mat:setcell(0,0,"记录")
	mat:setcell(0,1,"桌号")
	mat:setcell(0,2,"南北")
	mat:setcell(0,3,"东西")
	mat:setcell(0,4,"分区")
	mat:setcell(0,5,"轮次")
	mat:setcell(0,6,"牌号")
	mat:setcell(0,7,"定约")
	mat:setcell(0,8,"得分")
	mat:setcell(0,9,"mp")
	mat:setcell(0,10,"ximp")
	num=0
	for i,v in ipairs(project.data) do
		if v.round == cur and v["board"] == board then
			num = num + 1
			mat:setcell(num,0,i)
			mat:setcell(num,1,v["table"])
			mat:setcell(num,2,v["NS"])
			mat:setcell(num,3,v["EW"])
			mat:setcell(num,4,v["section"])
			mat:setcell(num,5,v["round"])
			mat:setcell(num,6,v["board"])
			mat:setcell(num,7,v["constr"])
			mat:setcell(num,8,v["score"])
			mat:setcell(num,9,v.NS_mp or "")
			mat:setcell(num,10,v.NS_ximp or "")
		end
	end
	iup.UpdateChildren(MDI1Form)
end

local function reset_data(cur,desk)
	if not project.data then return end
	mat.numcol = 10
	mat.numcol_visible = 10
	local num =0
	for i,v in ipairs(project.data) do
		if v.round == cur and v["table"] == desk then
			num = num + 1
		end
	end
	mat.numlin= num
	mat.numlin_visible= num

	mat:setcell(0,0,"记录")
	mat:setcell(0,1,"桌号")
	mat:setcell(0,2,"南北")
	mat:setcell(0,3,"东西")
	mat:setcell(0,4,"分区")
	mat:setcell(0,5,"轮次")
	mat:setcell(0,6,"牌号")
	mat:setcell(0,7,"定约")
	mat:setcell(0,8,"得分")
	mat:setcell(0,9,"mp")
	mat:setcell(0,10,"ximp")
	num=0
	for i,v in ipairs(project.data) do
		if v.round == cur and v["table"] == desk then
			num = num + 1
			mat:setcell(num,0,i)
			mat:setcell(num,1,v["table"])
			mat:setcell(num,2,v["NS"])
			mat:setcell(num,3,v["EW"])
			mat:setcell(num,4,v["section"])
			mat:setcell(num,5,v["round"])
			mat:setcell(num,6,v["board"])
			mat:setcell(num,7,v["constr"])
			mat:setcell(num,8,v["score"])
			mat:setcell(num,9,v.NS_mp or "")
			mat:setcell(num,10,v.NS_ximp or "")
		end
	end

end

function reset(flag,cur,desk)
	mode_flag = flag or "round"
	if mode_flag == "round" then
		reset_round(cur or project.cur_round)
	elseif mode_flag == "data" then
		reset_data(cur,desk)
	end
	iup.UpdateChildren(MDI1Form)
end

function get_value()
	if mode_flag ~= "round" then return nil end
	local dat = {}
	for i = 1,mat.numlin do
		dat[i] = dat[i] or {}
		dat[i].NS = tonumber(mat[i .. ":" .. 1])
		dat[i].EW = tonumber(mat[i .. ":" .. 2])
		dat[i].section = tonumber(mat[i .. ":" .. 3])
		dat[i].l = tonumber(mat[i .. ":" .. 4])
		dat[i].h = tonumber(mat[i .. ":" .. 5])
	end
	return dat
end

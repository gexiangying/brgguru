module(...,package.seeall)
local next_bypass 
function set()
  local status
  local sections = project.sections or 1
  local desks = project.desks or 0
  local rounds = project.rounds or 0  
  local players_num = project.players_num or 0
  local session_type = project.session_type or 0
  status,sections,desks,rounds,players_num,session_type = iup.GetParam("设置",nil,"分区 %i\n桌数 %i\n总轮次 %i\n单位数目 %i\n比赛类型 %l|血战到底|通讯赛|\n",sections,desks,rounds,players_num,session_type)
  --assert(nil,session_type .. type(session_type))
  if status then
   project.sections = sections
   project.desks = desks
   project.rounds = rounds
   project.players_num = players_num
   project.session_type = session_type
	 project.players = {}
	 result.init_players(1)
  end
  if session_type == 1 then require("txs").init_txs() end
end
function upset()
  local sections = project.sections or 1
  local desks = project.desks or 0
  local db_string = project.db_string
  if db_string then 
  local db = ADO_Open(db_string)
  local computer_name = get_computer_name()
 -- assert(nil,computer_name)
  db:exec("UPDATE [Clients] SET Computer = '" .. computer_name .. "' WHERE Computer <> '" .. computer_name .. "'")
  db:exec("DELETE * FROM [Section]")
  db:exec("DELETE * FROM [Tables]")
  for i =1,sections do
    db:exec("INSERT INTO [Section] ([ID],[Letter],[Tables],[MissingPair]) VALUES(" .. i .. ",'" .. string.char(string.byte("A") + i - 1) .. "'," .. desks .. ",0)")
  end

   for j=1,sections do
   for i=1,desks do
    db:exec("INSERT INTO [Tables] ([Section],[Table],[ComputerID],[Status],[LogOnOff],[CurrentRound],[CurrentBoard],[UpdateFromRound]) VALUES (" .. j .. "," .. i .. ",1,0,2,0,0,0)")
   end
   end
   db:close()
   end
end

local function txs_add()
local cur_round = project.cur_round or 0
 cur_round = cur_round + 1
 if cur_round < project.rounds + 1 then
  matrix.reset("round",cur_round)
 end
end

local function adjust_bypass(players)
	local result = {}
	local flag = false
	for i=#players,1,-1 do
		if not flag and not players[i].bypass	then
			flag = true
			next_bypass = players[i].no
		else
			table.insert(result,1,players[i])
		end
	end
	return result
end

function add()
 if project.cur_round == project.rounds then return end
 if project.session_type == 1 then 
   txs_add() 
 else
 local status
 local l = project.cur_l or 1
 local h = project.cur_h or 16
 status,l,h = iup.GetParam("副数设定",nil,"起始牌号 %i\n结束牌号 %i\n",l,h)
 if not status then return end
 
 local cur_round = project.cur_round or 0
 cur_round = cur_round + 1
 
 local desks = project.desks or 0

 if cur_round < project.rounds + 1 then
	 --project.cur_round = cur_round
	 project.round = project.round or {}
	 local round = project.round
	 round[cur_round] = round[cur_round] or {}
	 local temp = round[cur_round]
	 local players = matrix.get_sort_players()

	 if cur_round ~= 1 and project.players_num % 2 == 1 then -- use bypass resort players  ..not set byapss flag
		 players = adjust_bypass(players)
	 end

	 if cur_round == 1 and project.players_num%2 == 1 then  --first round last player bypass
		 project.players[project.players_num].bypass = true
	 end

	 for i = 1,desks do
		 temp[i] = temp[i] or {}
		 if cur_round == 1 then
			 temp[i].NS = i * 2 -1
			 temp[i].EW = i * 2
			 temp[i].section = 1
		 else
			 temp[i].NS = players[i*2-1].no
			 temp[i].EW = players[i*2].no
			 temp[i].section = 1
		 end
		 temp[i].l = l
		 temp[i].h = h
	 end
	 matrix.reset("round",cur_round)
 end
 end
end

function save()
	if matrix.mode_flag ~= "round" then return end
	local cur_round = project.cur_round or 0 
	cur_round = cur_round + 1
	if cur_round > 0 then
		project.cur_round = cur_round
		project.round = project.round or {}
		local round = matrix.get_value()
		if round then
			project.round[cur_round] = round
			if project.players_num %2 == 1 and next_bypass then  --if next_bypass and playersnum odds then bypass next
				project.players[next_bypass].bypass = true
			end
		end
		tree.reset()
	end
end

function show()
	matrix.reset("round",project.cur_round)
end

function open()
	local database_name = project.database_name
	if database_name then
		os.execute([["C:\\Program Files (x86)\\Bridgemate Pro\\BMPro.exe"]] .. " /f:\[" .. database_name .. "]  /s /r")
	end
end

function upload()
	if project.cur_round > 0 then
		local db = ADO_Open(project.db_string)

		local round = project.round[project.cur_round]
		for i =1,project.sections do
			db:exec("DELETE * FROM [RoundData] where [Section] = " .. i .. " AND Round = " .. project.cur_round)
		end
		for i,v in ipairs(round) do
			local section = v.section or 1
			local NS = v.NS
			local EW = v.EW
			local desk = i
			local num = project.cur_round
			local l = v.l
			local h = v.h
			db:exec("INSERT INTO [RoundData] VALUES(" .. section .. "," .. desk .. "," .. num .. "," .. NS .. "," .. EW .. "," .. l .. "," .. h  .. ",'')")
		end
		db:exec("UPDATE Tables SET UpdateFromRound = " .. project.cur_round .. " WHERE UpdateFromRound <> " .. project.cur_round )
		db:close()
	end
end
function link_menu(menu)
	menu.item_session_set.action = set
	menu.item_session_upset.action = upset
	menu.item_session_open.action = open
	menu.item_session_add.action = add
	menu.item_session_save.action = save
	menu.item_session_show.action = show
	menu.item_session_upload.action = upload
end

module(...,package.seeall)
function set()
  local status
  local sections = project.sections or 1
  local desks = project.desks or 0
  local rounds = project.rounds or 0  
  local players_num = project.players_num or 0
  status,sections,desks,rounds,players_num = iup.GetParam("设置",nil,"分区 %i\n桌数 %i\n总轮次 %i\n单位数目 %i\n",sections,desks,rounds,players_num)
  if status then
   project.sections = sections
   project.desks = desks
   project.rounds = rounds
   project.players_num = players_num
  end
end
function upset()
  local sections = project.sections or 1
  local desks = project.desks or 0
  local db_string = project.db_string
  if db_string then 
  local db = ADO_Open(db_string)
  db:exec("DELETE * FROM [Section]")
  db:exec("DELETE * FROM [Tables]")
  for i =1,sections do
    db:exec("INSERT INTO [Section] VALUES(" .. i .. ",'" .. string.char(string.byte("A") + i - 1) .. "'," .. desks .. ",0)")
  end

   for j=1,sections do
   for i=1,desks do
    db:exec("INSERT INTO [Tables] VALUES (" .. j .. "," .. i .. ",1,0,2,0,0,0)")
   end
   end
   db:close()
   end
end

function add()
 local status
 local l = project.cur_l or 1
 local h = project.cur_h or 16
 status,l,h = iup.GetParam("副数设定",nil,"起始牌号 %i\n结束牌号 %i\n",l,h)
 if not status then return end
 
 local cur_round = project.cur_round or 0
 cur_round = cur_round + 1
 project.cur_round = cur_round
 local desks = project.desks or 0
 
 if cur_round < project.rounds then
   project.round = project.round or {}
   local round = project.round
   round[cur_round] = round[cur_round] or {}
   local temp = round[cur_round]
   for i = 1,desks do
     temp[i] = temp[i] or {}
     temp[i].NS = i * 2 -1
     temp[i].EW = i * 2
     temp[i].section = 1
     temp[i].l = l
     temp[i].h = h
   end
   matrix.reset()
 end
end

function save()
 local cur_round = project.cur_round or 0
 if cur_round > 0 then
   project.round = project.round or {}
   local round = matrix.get_value()
   if round then
   project.round[cur_round] = round
   end
   tree.reset()
 end
end

function show()
 matrix.reset()
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
 menu.item_session_add.action = add
 menu.item_session_save.action = save
 menu.item_session_show.action = show
 menu.item_session_upload.action = upload
end

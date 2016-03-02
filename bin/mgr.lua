module(...,package.seeall)


function get_round_boards()
local rounds = {}  --{ 1={l=,h=} , 2={l=,h=)}
for i,v in ipairs(project.data) do
   rounds[v.round] = rounds[v.round] or {}
   local temp = rounds[v.round]
   temp.l = temp.l or v.board
   temp.h = temp.h or v.board
   if v.board < temp.l then temp.l = v.board end
   if v.board > temp.h then temp.h = v.board end
end
return rounds
end
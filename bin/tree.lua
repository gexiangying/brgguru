module(...,package.seeall)

local t = iup.tree{ RASTERSIZE = '200x',ADDROOT="YES"}
function get_tree()
  return t
end

function reset()
  if project.name then 
  t.value = 0
  t.DELNODE = "MARKED"
  t.value = 0
  t.addbranch = project.name
  for i=project.cur_round,1,-1 do
    local round = project.round[i]
    t.addbranch = "round " .. i
    for k,v in pairs(round) do
      t.addleaf1 = k .. "-" .. v.NS .. "-" .. v.EW
    end
  end
  end
end
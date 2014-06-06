module(...,package.seeall)

local t = iup.tree{ RASTERSIZE = '200x',ADDROOT="YES"}

function t:executeleaf_cb(id)
    local temp = iup.TreeGetUserId(t,id)
    assert(temp,"no userdata")
    matrix.reset("data",temp.round,temp.desk)
end

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
    for k=#round,1,-1  do
      t.addleaf1 = k .. "-" .. round[k].NS .. "-" .. round[k].EW
      local temp = {round=i,desk = k}
      iup.TreeSetUserId(t,2,temp)
    end
  end
  end
end
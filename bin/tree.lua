module(...,package.seeall)

local t = iup.tree{ RASTERSIZE = '200x',ADDROOT="YES"}
local t1 = iup.tree{ RASTERSIZE = '200x',ADDROOT="YES"}
local vboxA = iup.vbox{t}
local vboxB = iup.vbox{t1}
vboxA.tabtitle = "ÅÆ×À"
vboxB.tabtitle = "ÅÆºÅ"
local tabs = iup.tabs{vboxA, vboxB;TABTYPE="BOTTOM"}


function t:executeleaf_cb(id)
    local temp = iup.TreeGetUserId(t,id)
    assert(temp,"no userdata")
    matrix.reset("data",temp.round,temp.desk)
end

function t1:executeleaf_cb(id)
    local temp = iup.TreeGetUserId(t1,id)
    assert(temp,"no userdata")
    matrix.reset_board(temp.round,temp.board)
    --print("temp.round" .. "temp.board")
end

function get_tree()
  return tabs
end

function reset_t1()
  local rounds = mgr.get_round_boards()
  if #rounds < 1 then return end
  t1.value = 0
  t1.DELNODE = "MARKED"
  t1.value = 0
  t1.addbranch = project.name
  for i=#rounds,1,-1 do
    local round = rounds[i]
    t1.addbranch = "µÚ" .. i .. "ÂÖ"
    for k=round.h,round.l,-1  do
      t1.addleaf1 = "µÚ" .. k .. "¸±"
      local temp = {round=i,board = k}
      iup.TreeSetUserId(t1,2,temp)
    end
  end

end

local function reset_t()
  if project.name then 
  t.value = 0
  t.DELNODE = "MARKED"
  t.value = 0
  t.addbranch = project.name
  for i=project.cur_round,1,-1 do
    local round = project.round[i]
    t.addbranch = "µÚ" .. i .. "ÂÖ"
    for k=#round,1,-1  do
      t.addleaf1 = k .. "×À-(NS-" .. round[k].NS .. ")+(EW-" .. round[k].EW .. ")"
      local temp = {round=i,desk = k}
      iup.TreeSetUserId(t,2,temp)
    end
  end
  end
end

function reset()
  reset_t()
end
module(...,package.seeall)
--[[
tree_nodes = 
{
  branchname = "Figures",
  "Other",
  {
    branchname = "triangle",
    state = "COLLAPSED",
    "equilateral",
    "isoceles",
    "scalenus",
  },
  {
    branchname = "parallelogram",
    "square",
    { leafname = "diamond", color = "92 92 255", titlefont = "Courier, 14" },
  },
  { branchname = "2D" },
  { branchname = "3D" },
}
--]]
function get_tree()
	local t = iup.tree{ RASTERSIZE = '200x',ADDROOT="YES"}
	return t
end

function add_nodes(t)
	iup.TreeAddNodes(t, tree_nodes)
end

function reset(t)
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
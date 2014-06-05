module(...,package.seeall)
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
function get_tree()
	local t = iup.tree{ RASTERSIZE = '200x'}
	return t
end

function add_nodes(t)
	iup.TreeAddNodes(t, tree_nodes)
end

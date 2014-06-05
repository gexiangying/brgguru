module(...,package.seeall)

item_new = iup.item{title="New",key="K_N"}
item_open = iup.item{title="Open",key="K_O"}
item_close = iup.item{title="Close",key="K_C"}

function item_close:action()
	return iup.CLOSE
end

menu_file = iup.menu{item_new,item_open,item_close}
submenu_file = iup.submenu{menu_file,title="File"}
submenu_windows = iup.submenu{title="Windows"}
mainmenu = iup.menu{submenu_file,submenu_windows}

function set_action(item,func)
 item.action = func
end
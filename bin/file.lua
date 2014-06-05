require "comma"
module(...,package.seeall)

function new()
 local s
 s,project.name = iup.GetParam("ÐÂ½¨",nil,"Ãû×Ö %s\n","")
 if s then 
  project.file_name = project.name .. ".apc"
  project.database_name = project.name .. ".bws"
  project.db_string = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" .. project.database_name
  os.execute("copy Default.bws " .. project.database_name)
  tree.reset(t)
 end
end

function open()
  local str,status = iup.GetFile("./*.apc")
  if status == 0 then
    dofile(str)
    tree.reset(t)
  end
end

function save()
  if project.file_name then
    comma.save_file(project.file_name,project,"project")
  end
end

function close()
	return iup.CLOSE
end

function link_menu(menu)
	menu.item_new.action = new
	menu.item_open.action = open
	menu.item_save.action = save
	menu.item_close.action = close
end

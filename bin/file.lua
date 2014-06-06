require "comma"
module(...,package.seeall)

function new()
 local s,name = iup.GetParam("�½�",nil,"���� %s\n","")
 if s then 
  init_prj()
  project.name = name
  project.file_name = project.name .. ".apc"
  project.database_name = project.name .. ".bws"
  project.db_string = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" .. project.database_name
  os.execute("copy Default.bws " .. project.database_name)
  tree.reset()
 end
end

function open()
  local str,status = iup.GetFile("./*.apc")
  if status == 0 then
    dofile(str)
    tree.reset()
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

module(...,package.seeall)

item_new = iup.item{title="�½�",key="K_N"}
item_open = iup.item{title="��",key="K_O"}
item_save = iup.item{title="����",key="K_S"}
item_close = iup.item{title="�˳�",key="K_C"}

menu_file = iup.menu{item_new,item_open,item_save,item_close}
submenu_file = iup.submenu{menu_file,title="�ļ�"}


item_session_set = iup.item{title="����"}
item_session_upset = iup.item{title="�ϴ�����"}
item_session_open = iup.item{title="�򿪷�����"}
item_session_add = iup.item{title="�½��ִ�"}
item_session_save = iup.item{title="�����ִ�"}
item_session_show = iup.item{title="��ʾ�ִ�"}
item_session_upload = iup.item{title="�ϴ��ִ�"}

--menu_session = iup.menu{item_session_set,item_session_upset,item_session_open,item_session_add,item_session_save,item_session_show,item_session_upload}
menu_session = iup.menu{item_session_set,item_session_upset,item_session_add,item_session_save,item_session_show,item_session_upload}
submenu_session = iup.submenu{menu_session,title="����"}

item_result_get = iup.item{title="���ؼ�¼"}
--item_result_show_data = iup.item{title="��ʾ��¼"}
--item_result_cal = iup.item{title="����"}
item_result_sum = iup.item{title="�ۼƽ��"}
item_result_adjust = iup.item{title="�����÷�"}
item_result_create = iup.item{title="���ɲ�������"}
item_result_txs = iup.item{title = "txs.txt"}

--menu_result = iup.menu{item_result_get,item_result_show_data,item_result_cal,item_result_sum,item_result_adjust,item_result_create}
menu_result = iup.menu{item_result_get,item_result_show_data,item_result_cal,item_result_sum,item_result_adjust}

submenu_result = iup.submenu{menu_result,title="���"}


mainmenu = iup.menu{submenu_file,submenu_session,submenu_result}


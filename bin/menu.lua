module(...,package.seeall)

item_new = iup.item{title="新建",key="K_N"}
item_open = iup.item{title="打开",key="K_O"}
item_save = iup.item{title="保存",key="K_S"}
item_close = iup.item{title="退出",key="K_C"}

menu_file = iup.menu{item_new,item_open,item_save,item_close}
submenu_file = iup.submenu{menu_file,title="文件"}


item_session_set = iup.item{title="设置"}
item_session_upset = iup.item{title="上传设置"}
item_session_open = iup.item{title="打开服务器"}
item_session_add = iup.item{title="新建轮次"}
item_session_save = iup.item{title="更新轮次"}
item_session_show = iup.item{title="显示轮次"}
item_session_upload = iup.item{title="上传轮次"}

--menu_session = iup.menu{item_session_set,item_session_upset,item_session_open,item_session_add,item_session_save,item_session_show,item_session_upload}
menu_session = iup.menu{item_session_set,item_session_upset,item_session_add,item_session_save,item_session_show,item_session_upload}
submenu_session = iup.submenu{menu_session,title="比赛"}

item_result_get = iup.item{title="下载记录"}
--item_result_show_data = iup.item{title="显示记录"}
--item_result_cal = iup.item{title="计算"}
item_result_sum = iup.item{title="累计结果"}
item_result_adjust = iup.item{title="调整得分"}
item_result_create = iup.item{title="生成测试数据"}

menu_result = iup.menu{item_result_get,item_result_show_data,item_result_cal,item_result_sum,item_result_adjust,item_result_create}
--menu_result = iup.menu{item_result_get,item_result_show_data,item_result_cal,item_result_sum,item_result_adjust}

submenu_result = iup.submenu{menu_result,title="结果"}


mainmenu = iup.menu{submenu_file,submenu_session,submenu_result}


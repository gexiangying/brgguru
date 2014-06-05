#include <stdio.h>
#include <string.h>
#include <windows.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"
HINSTANCE g_hinst = NULL;
int WINAPI WinMain(HINSTANCE hinstance, HINSTANCE hPrevInstance, // 
		   LPSTR lpCmdLine, int nCmdShow) // 
{				// 
	g_hinst = hinstance;
	lua_State* L = lua_open();	
	luaL_openlibs(L);
	if(luaL_dofile(L,"main.lua") != 0){
		const char* error_str = lua_tostring(L,-1);
		MessageBox(NULL,error_str,"Error",MB_OK);
		lua_pop(L,1);
		lua_close(L);
		return 1;
	}
	return 0; 
}

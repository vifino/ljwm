// ljwm main.c
// Contains the startup code. Maybe.
// It's not very difficult.

#include <stdio.h>
#include <stdlib.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

void bailout(int status, const char* msg) {
	printf("%s\n", msg);
	exit(status);
}

int lua_require(lua_State* L, char* libname) {
	lua_getglobal(L, "require");
	lua_pushstring(L, libname);
	return lua_pcall(L, 1, 0, 0);
}

int main(int argc, char *argv[]) {
	lua_State* L = luaL_newstate();
	if (L == NULL)
		bailout(1, "Unable to initialize LuaJIT! This is _BAD_!");

	// Continue state initialization as usual.
	luaL_openlibs(L);

	// Arguments.
	// Maybe make that chunk arguments instead of a global var?
	lua_newtable(L);
	int i;
	for (i = 0; i < argc; i++) {
		lua_pushnumber(L, i);
		lua_pushstring(L, argv[i]);
		lua_settable(L, -3);
	}
	lua_setglobal(L, "arg");

	// Since we explicitly need LuaJIT, we won't have to do much here.
	int retval = lua_require(L, "ljwm.bootscript");
	if (retval != 0)
		bailout(retval, lua_tolstring(L, -1, 0));
	return 0;
}

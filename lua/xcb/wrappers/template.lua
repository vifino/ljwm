--- Wrapper for XCB $NAME

local ffi = require("ffi")
local xcbr = require("xcb.raw")

local index = {

}

ffi.metatype("$TYPE", {__index=index})

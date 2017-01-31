--- Wrapper for XCB $NAME

local ffi = require("ffi")
local xcbr = require("xcbr")

local index = {

}

ffi.metatype("$TYPE", {__index=index})

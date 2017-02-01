--- Wrapper for xcb_generic_iterator_t

local ffi = require("ffi")
local xcbr = require("xcb.raw")

local index = {

}

ffi.metatype("xcb_generic_iterator_t", {__index=index})

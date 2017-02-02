--- Basic initialization.
-- While most of this stuff is optional, a few things are loaded on startup no matter what.

local ffi = require("ffi")

ffi.cdef [[
/* From the C library */
void free(void*);
void *malloc(size_t size);
]]

-- Better stack traces.
STP = require("StackTracePlus")
debug.traceback = STP.stacktrace

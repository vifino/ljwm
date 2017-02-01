-- A slightly hacky way of pulling FFI definitions.

local args = {...}

print("local ffi = require(\"ffi\")")
print("ffi.cdef [[")
local allow = false
while true do
 local l = io.read()
 if not l then
  print("]]")
  return
 end
 if l:sub(1, 1) == "#" then
  local s = l:find("\"")
  if not s then
   error("Unknown preprocessor -> compiler directive.")
  end
  local f = l:sub(s + 1)
  f = f:sub(1, f:find("\"") - 1)
  allow = (f:sub(1, args[1]:len()) == args[1])
 else
  if not l:find("^[ \t\r\n]*$") then
   if allow then
    print(l)
   end
  end
 end
end

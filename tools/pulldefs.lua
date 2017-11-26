-- A slightly hacky way of pulling FFI definitions.

local args = {...}

if not #args == 3 then
	error("Usage: pulldefs.lua $(XCBINCLUDE) ffi_cdefs.lua enums.lua")
end

local cdefs = assert(io.open(args[2], "w"))
local enums = assert(io.open(args[3], "w"))

cdefs:write("local ffi = require(\"ffi\")\n")
cdefs:write("ffi.cdef [[\n")

local constants = {}

local previousstate = "none" -- for debugging.
local state = "waiting"
local state_targetenum = nil
local state_enumindex = nil
local state_enumconstname = nil
-- reaction = {"nextState", optFunction}
-- Note that the state change happens before the function runs, so it can be overridden.
-- The function is called with the token.
-- state = {["tokenText"] = reaction, [0] = reaction}
-- state_machine = {["name"] = state}

local function generate_error(e)
	return function ()
		error(e)
	end
end

local state_machine = {
	["waiting"] = {
		["enum"] = {"grab_enum_name"},
		["typedef"] = {"type_check"},
		[0] = {"wait_for_semicolon"},
	},
	["wait_for_semicolon"] = {
		[";"] = {"waiting"},
		[0] = {"wait_for_semicolon"},
	},
	["type_check"] = {
		["enum"] = {"grab_enum_name"},
		[0] = {"wait_for_semicolon"},
	},
	["grab_enum_name"] = {
		["{"] = {"read_enum_constant_name", function ()
			state_targetenum = {}
		end},
		[0] = {"read_enum_start", function (tkn)
			state_targetenum = {}
			constants[tkn] = state_targetenum
		end},
	},
	-- state_targetenum must be initialized by this point
	["read_enum_start"] = {
		["{"] = {"read_enum_constant_name"},
		[0] = {"", generate_error("Unexpected non-{ during enum reading.")},
	},
	["read_enum_constant_name"] = {
		["{"] = {"", generate_error("Unexpected { during enum reading.")},
		["}"] = {"enum_epilogue"},
		[0] = {"read_enum_equals", function (tkn)
			state_enumconstname = tkn
		end}
	},
	["read_enum_equals"] = {
		["="] = {"read_enum_constant_val"},
		["}"] = {"enum_epilogue", function (tkn)
			state_targetenum[state_enumconstname] = state_enumindex
		end},
		[","] = {"read_enum_constant_name", function (tkn)
			state_targetenum[state_enumconstname] = state_enumindex
			state_enumindex = state_enumindex + 1
		end},
		[0] = {"", generate_error("Unexpected token after enum constant name")}
	},
	["read_enum_constant_val"] = {
		[0] = {"read_enum_constant_comma", function (tkn)
			local n = tonumber(tkn)
			if not n then error("Value not number: " .. tkn) end
			state_targetenum[state_enumconstname] = n
			state_enumindex = n
		end},
	},
	["read_enum_constant_comma"] = {
		["}"] = {"enum_epilogue"},
		[","] = {"read_enum_constant_name"},
		[0] = {"", generate_error("Unexpected token inside enum in place of comma or epilogue")},
	},
	["enum_epilogue"] = {
		[";"] = {"waiting"},
		[0] = {"wait_for_semicolon", function (tkn)
			constants[tkn] = state_targetenum
			state_enumindex = nil
		end},
	},
}

local function submit_token(tkn, meaning)
	if tkn == "" then return end
	if meaning == "ws" then return end
	local cstate = state_machine[state]
	local reaction = cstate[tkn]
	if not reaction then
		reaction = cstate[0]
	end
	if not reaction then
		error("State machine could not handle default @ " .. state)
	end
	local oldstate = state
	state = reaction[1]
	if reaction[2] then
		local ok, e = pcall(reaction[2], tkn)
		if not ok then
			error("Failure in state " .. oldstate .. ", previously " .. previousstate .. ", token '" .. tkn .. "': " .. e)
		end
	end
	previousstate = oldstate
end

local splitters = {
	[" "] = "ws",
	["\t"] = "ws",
	["\r"] = "ws",
	["\n"] = "ws",
	["{"] = true,
	["}"] = true,
	["("] = true,
	[")"] = true,
	["*"] = true,
	[","] = true,
	[";"] = true,
	["["] = true,
	["]"] = true,
}

local function tokenize_line(line)
	local token_start = 1
	for i = 1, line:len() do
		local meaning = splitters[line:sub(i, i)]
		if meaning then
			submit_token(line:sub(token_start, i - 1), false)
			submit_token(line:sub(i, i), meaning)
			token_start = i + 1
		end
	end
	submit_token(line:sub(token_start), false)
end

-- Type name replacements.
local constant_name_replacements = {
	ATOM_ENUM = "ATOM",
	PIXMAP_ENUM = "PIXMAP",
}
local function constant_name_fixup_key(typename)
	return typename:gsub("^xcb_", ""):gsub("_t$", "")
end

local function constant_name_fixup_value(ENUM_NAME, value)
	local prefix = constant_name_replacements[ENUM_NAME] or ENUM_NAME
	return value:gsub("^XCB_"..prefix.."_", "")
end

local function end_file()
	cdefs:write("]]\nreturn true")
	enums:write("return {\n")
	for k, v in pairs(constants) do
		local enum_name = constant_name_fixup_key(k)
		local ENUM_NAME = enum_name:upper()
		enums:write("\t[\"" .. enum_name .. "\"] = {\n")
		for k, v in pairs(v) do
			enums:write("\t\t[\"" .. constant_name_fixup_value(ENUM_NAME, k) .. "\"] = " .. v .. ",\n")
		end
		enums:write("\t},\n")
	end
	enums:write([[
	none = (require("ffi")).new("long int", 0),
	]])
	enums:write("}\n")
	if state == "wait_for_semicolon" then
		io.stderr:write("pulldefs.lua: Warning: stopped while waiting for a semicolon. Check state machine & tokenization logic.\n")
	end
end

local allow = false
while true do
	local l = io.read()
	if not l then
		end_file()
		cdefs:close()
		enums:close()
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
				cdefs:write(l.."\n")
				tokenize_line(l)
			end
		end
	end
end


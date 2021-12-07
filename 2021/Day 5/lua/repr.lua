--[[
Author : roc<rocaltair@gmail.com>
Description:
	repr for lua values, especially for lua table
--]]

local default_conf = {
	beautify = true,
	array_index = true,
	indent = "  ",
	maxdepth = 32,
	sort = true,
	func_info = true,
	userdata_info = true,
	skip_type = {["function"] = nil},
}

local function pairs_orderly(tbl)
	local keys = {}
	for k, v in pairs(tbl) do
		table.insert(keys, k)
	end
	table.sort(keys, function(a, b)
		return tostring(a) < tostring(b)
	end)

	local i = 0
	return function()
		i = i + 1
		local key = keys[i]
		if not key then
			return 
		end
		return key, tbl[key]
	end
end

local function get_func_info(func)
	local info = debug.getinfo(func, "Sln")
	if info.what == "C" then
		return "<C." .. tostring(func) .. ">"
	end
	return string.format("<Lua.%s:%s:%d>", tostring(func), info.source, info.linedefined)
end

local function get_userdata_info(value)
	local mt = getmetatable(value)
	if mt then
		for k, v in pairs(debug.getregistry()) do
			if v == mt then
				return string.format("<userdata:%s:%s>", tostring(k), tostring(value))
			end
		end
	end
	return "<" .. tostring(value) .. ">"
end

local function normalize(value, conf)
	local vtype = type(value)
	if vtype == "string" then
		return string.format('%q', value)
	elseif vtype == "table" or vtype == "thread" then
		return "<" .. tostring(value) .. ">"
	elseif vtype == "function" then
		if not conf.func_info then
			return "<" .. tostring(value) .. ">"
		end
		return get_func_info(value)
	elseif vtype == "userdata" then
		if conf.userdata_info then
			return get_userdata_info(value)
		end
		return "<" .. tostring(value) .. ">"
	end
	return tostring(value)
end

local empty_map = {}
local function dump(value, conf, depth)
	conf = conf or default_conf
	local maxdepth = conf.maxdepth or 32
	local beautify = conf.beautify
	local indent_str = conf.indent or " "
	local array_index = conf.array_index
	local skip_type = conf.skip_type or empty_map
	assert(not next(skip_type) or array_index)
	depth = depth or 1
	if depth > maxdepth then
		return normalize(value, conf)
	end
	local vtype = type(value)
	if vtype ~= "table" then
		return normalize(value, conf)
	end
	local visited = {}
	local list = {}

	local brace_indent = beautify and string.rep(indent_str, depth - 1) or ""
	local indent = beautify and string.rep(indent_str, depth) or ""

	table.insert(list, "{")
	local endl = beautify and "\n" or ""
	table.insert(list, endl)
	for i, v in ipairs(value) do
		visited[i] = true
		local svtype = type(v)
		if not skip_type[svtype] then
			table.insert(list, indent)
			if array_index then
				table.insert(list, "[")
				table.insert(list, i)
				table.insert(list, "]=")
			end
			local sv = dump(v, conf, depth + 1)
			table.insert(list, sv)
			table.insert(list, "," .. endl)
		end
	end
	local pairs_func = conf.sort and pairs_orderly or pairs
	for k, v in pairs_func(value) do
		local svtype = type(v)
		if not visited[k] and not skip_type[svtype] then
			table.insert(list, indent)
			if type(k) == "number" then
				table.insert(list, "[")
				table.insert(list, k)
				table.insert(list, "]")
			else
				table.insert(list, tostring(k))
			end
			table.insert(list, "=")
			local sv = dump(v, conf, depth + 1)
			table.insert(list, sv)
			table.insert(list, "," .. endl)
		end
	end
	table.insert(list, brace_indent)
	table.insert(list, "}")
	return table.concat(list, "")
end

local inline_conf = {
	array_index = true,
	maxdepth = 32,
	sort = true,
	func_info = true,
	userdata_info = true,
}

local function repr_in_line(value)
	return dump(value, inline_conf)
end

local function repr(value, conf)
	return dump(value, conf)
end

local function test()
	local sample_table = {
		co = coroutine.create(function() end),
		tbl = {1,2,3,"fdas",a=2,b=3,c=4, sub_tbl = {print, io.stdout}},
		func = dump,
		stdout = io.stdout,
		bool = true,
	}
	print(repr(sample_table))
end

local M = {
	default_conf = default_conf,
	repr = repr,
	repr_in_line = repr_in_line,
	test = test,
}

return M
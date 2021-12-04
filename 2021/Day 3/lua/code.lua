local code = {}
-- https://stackoverflow.com/questions/1426954/split-string-in-lua
--
-- gsplit: iterate over substrings in a string separated by a pattern
--
-- Parameters:
-- text (string)    - the string to iterate over
-- pattern (string) - the separator pattern
-- plain (boolean)  - if true (or truthy), pattern is interpreted as a plain
--                    string, not a Lua pattern
--
-- Returns: iterator
--
-- Usage:
-- for substr in gsplit(text, pattern, plain) do
--   doSomething(substr)
-- end
local function gsplit(text, pattern, plain)
	local splitStart, length = 1, #text
	return function()
		if splitStart then
			local sepStart, sepEnd = string.find(text, pattern, splitStart, plain)
			local ret
			if not sepStart then
				ret = string.sub(text, splitStart)
				splitStart = nil
			elseif sepEnd < sepStart then
				-- Empty separator!
				ret = string.sub(text, splitStart, sepStart)
				if sepStart < length then
					splitStart = sepStart + 1
				else
					splitStart = nil
				end
			else
				ret = sepStart > splitStart and string.sub(text, splitStart, sepStart - 1) or ""
				splitStart = sepEnd + 1
			end
			return ret
		end
	end
end

-- split: split a string into substrings separated by a pattern.
--
-- Parameters:
-- text (string)    - the string to iterate over
-- pattern (string) - the separator pattern
-- plain (boolean)  - if true (or truthy), pattern is interpreted as a plain
--                    string, not a Lua pattern
--
-- Returns: table (a sequence table containing the substrings)
local function split(text, pattern, plain)
	local ret = {}
	for match in gsplit(text, pattern, plain) do
		table.insert(ret, match)
	end
	return ret
end

-- https://stackoverflow.com/questions/11669926/is-there-a-lua-equivalent-of-scalas-map-or-cs-select-function
-- Modified by hayper
local function map(tbl, f)
	local t = {}
	for k, v in pairs(tbl) do
		if #tbl >= 1 then
			table.insert(t, f(v, k, tbl))
		else
			t[k] = f(v, k, tbl)
		end
	end
	return t
end

-- https://gist.github.com/FGRibreau/3790217
--
-- filter({"a", "b", "c", "d"}, function(o, k, i) return o >= "c" end)  --> {"c","d"}
--
-- @FGRibreau - Francois-Guillaume Ribreau
-- @Redsmin - A full-feature client for Redis http://redsmin.com
-- 
-- Modifed a bit by hayper
local function filter(t, filterIter)
	local out = {}

	for k, v in pairs(t) do
		if filterIter(v, k, t) then
			if #t >= 1 then
				table.insert(out, v)
			else
				out[k] = v
			end
		end
	end

	return out
end

function commonList(arr)
	local list = {}
	for _, bitData in pairs(arr) do
		local bs = split(bitData, "")
		for i = 1, #bs do
			local bit = bs[i]
			if list[i] == nil then
				list[i] = { one = 0, zero = 0 }
			end
			if bit == "1" then
				list[i].one = list[i].one + 1
			elseif bit == "0" then
				list[i].zero = list[i].zero + 1
			end
		end
	end
	return list
end

function code:part1(input)
	local input = split(input, "\n")
	local list = commonList(input)
	local gammaRate = map(list, function(v)
		return v.one > v.zero and "1" or "0"
	end)
	local epsilonRate = map(list, function(v)
		return v.one > v.zero and "0" or "1"
	end)
	gammaRate = table.concat(gammaRate, "")
	epsilonRate = table.concat(epsilonRate, "")
	return tonumber(gammaRate, 2) * tonumber(epsilonRate, 2)
end

function code:part2(input)
	local input = split(input, "\n")

	local generatorRate = input
	local scrubberRate = input

	for l = 1, #commonList(generatorRate) do
		local generatorCommonList = commonList(generatorRate)
		local scrubberCommonList = commonList(scrubberRate)

		generatorRate = filter(generatorRate, function(bitData, _, _)
			return #generatorRate == 1
				or (split(bitData, "")[l] == (generatorCommonList[l].one >= generatorCommonList[l].zero and "1" or "0"))
		end)

		scrubberRate = filter(scrubberRate, function(bitData, _, _)
			return #scrubberRate == 1
				or (split(bitData, "")[l] == (scrubberCommonList[l].one >= scrubberCommonList[l].zero and "0" or "1"))
		end)
	end

	return tonumber(generatorRate[1], 2) * tonumber(scrubberRate[1], 2)
end

return code

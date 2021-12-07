function dofile(filename) return assert(loadfile(filename))() end

local Array = dofile("..\\..\\Common\\lua\\Array.lua")

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
	local ret = Array()
	for match in gsplit(text, pattern, plain) do
		ret:push(match)
	end
	return ret
end

function code:part1(input)
	local point = split(input, "\n", true)
	local map = Array()
	for _, raw in pairs(point) do
		local res = split(raw, " -> ", true):map(function(x)
			return split(x, ",", true):map(function(x)
				return tonumber(x)
			end)
		end)

		local origin = res[1]
		local destination = res[2]

		function addPoint(x, y)
			x = x + 1
			y = y + 1
			map[y] = map[y] or Array()
			map[y][x] = map[y][x] or 0
			map[y][x] = map[y][x] + 1
		end

		if origin[1] == destination[1] or origin[2] == destination[2] then
			if origin[1] == destination[1] then
				do
					local i = origin[2]
					while i <= destination[2] do
						addPoint(origin[1], i)
						i = i + 1
					end
				end

				do
					local i = origin[2]
					while i >= destination[2] do
						addPoint(origin[1], i)
						i = i - 1
					end
				end
			end

			if origin[2] == destination[2] then
				do
					local i = origin[1]
					while i <= destination[1] do
						addPoint(i, origin[2])
						i = i + 1
					end
				end
				do
					local i = origin[1]
					while i >= destination[1] do
						addPoint(i, origin[2])
						i = i - 1
					end
				end
			end
		end
	end
	return map
		:map(function(m)
			return m:filter(function(x)
				return x > 1
			end)
		end)
		:reduce(function(p, v)
			return p + v:filter(function(x)
				return tonumber(x) ~= nil and x > 1
			end).length
		end, 0)
end

function code:part2(input)
	local point = split(input, "\n", true)
	local map = Array()
	for _, raw in pairs(point) do
		local res = split(raw, " -> ", true):map(function(x)
			return split(x, ",", true):map(function(x)
				return tonumber(x)
			end)
		end)

		local origin = res[1]
		local destination = res[2]

		function addPoint(x, y)
			x = x + 1
			y = y + 1
			map[y] = map[y] or Array()
			map[y][x] = map[y][x] or 0
			map[y][x] = map[y][x] + 1
		end

		if origin[1] == destination[1] or origin[2] == destination[2] then
			if origin[1] == destination[1] then
				do
					local i = origin[2]
					while i <= destination[2] do
						addPoint(origin[1], i)
						i = i + 1
					end
				end

				do
					local i = origin[2]
					while i >= destination[2] do
						addPoint(origin[1], i)
						i = i - 1
					end
				end
			end

			if origin[2] == destination[2] then
				do
					local i = origin[1]
					while i <= destination[1] do
						addPoint(i, origin[2])
						i = i + 1
					end
				end
				do
					local i = origin[1]
					while i >= destination[1] do
						addPoint(i, origin[2])
						i = i - 1
					end
				end
			end
		else
			do
				local x = origin[1]
				while x <= destination[1] do
					addPoint(
						x,
						origin[2] > destination[2] and (origin[2] - math.abs(x - origin[1]))
							or (origin[2] + math.abs(x - origin[1]))
					)
					x = x + 1
				end
			end
			do
				local x = origin[1]
				while x >= destination[1] do
					addPoint(
						x,
						origin[2] > destination[2] and (origin[2] - math.abs(x - origin[1]))
							or (origin[2] + math.abs(x - origin[1]))
					)
					x = x - 1
				end
			end
		end
	end
	return map
		:map(function(m)
			return m:filter(function(x)
				return x > 1
			end)
		end)
		:reduce(function(p, v)
			return p + v:filter(function(x)
				return tonumber(x) ~= nil and x > 1
			end).length
		end, 0)
end

return code

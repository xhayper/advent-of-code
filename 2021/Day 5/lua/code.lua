function dofile(filename)
	return assert(loadfile(filename))()
end

local Array = dofile("../../Common\\lua\\Array.lua")
local Utility = dofile("../../Common\\lua\\Utility.lua")

local code = {}

function code:part1(input)
	local point = Utility.split(input, "\n", true)
	local map = Array()
	for _, raw in pairs(point) do
		local res = Utility.split(raw, " -> ", true):map(function(x)
			return Utility.split(x, ",", true):map(function(x)
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
	local point = Utility.split(input, "\n", true)
	local map = Array()
	for _, raw in pairs(point) do
		local res = Utility.split(raw, " -> ", true):map(function(x)
			return Utility.split(x, ",", true):map(function(x)
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

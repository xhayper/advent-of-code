function dofile(filename)
	return assert(loadfile(filename))()
end

local Utility = dofile("./../../Common/lua/Utility.lua")

local code = {}

function nthTriangleNumber(n)
	return n * (n + 1) / 2
end

function code:part1(input)
	local crabPositions = Utility.split(input, ",", true)
		:map(function(x)
			return tonumber(x)
		end)
		:sort(function(a, b)
			return a - b
		end)

	local leastPosition = math.ceil(
		#crabPositions % 2 == 0 and (crabPositions[#crabPositions / 2] + crabPositions[#crabPositions / 2 - 1]) / 2
			or crabPositions[math.floor(#crabPositions / 2)]
	)

	local crabPositionObject = {}

	crabPositions:forEach(function(v)
		crabPositionObject[v] = (crabPositionObject[v] or 0) + 1
	end)

	local fuelUsed = 0

	for k, v in pairs(crabPositionObject) do
		fuelUsed = fuelUsed + math.abs(leastPosition - k) * v
	end

	return fuelUsed
end

function code:part2(input)
	local crabPositions = Utility.split(input, ",", true)
		:map(function(x)
			return tonumber(x)
		end)
		:sort(function(a, b)
			return a - b
		end)

	local crabPositionObject = {}

	crabPositions:forEach(function(v)
		crabPositionObject[v] = (crabPositionObject[v] or 0) + 1
	end)

	local leastFuel = math.huge

	for pos = crabPositions[1], crabPositions[#crabPositions] do
		local fuelUsed = 0

		for k, v in pairs(crabPositionObject) do
			fuelUsed = fuelUsed + nthTriangleNumber(math.abs(pos - k)) * v
		end

		leastFuel = math.min(fuelUsed, leastFuel)
	end

	return leastFuel
end

return code

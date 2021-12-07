function dofile(filename)
	return assert(loadfile(filename))()
end

local Utility = dofile("..\\..\\Common\\lua\\Utility.lua")

local code = {}

function code:part1(input)
	local ageObject = {}

	Utility
		.split(input, ",", true)
		:map(function(x)
			return tonumber(x)
		end)
		:forEach(function(v)
			ageObject[v] = (ageObject[v] and ageObject[v] + 1) or 1
		end)

	for day = 1, 80 do
		local newAgeObject = {}
		for k, v in pairs(ageObject) do
			if k == 0 then
				newAgeObject[6] = (newAgeObject[6] or 0) + v
				newAgeObject[8] = (newAgeObject[8] or 0) + v
			else
				newAgeObject[k - 1] = (newAgeObject[k - 1] or 0) + v
			end
		end
		ageObject = newAgeObject
	end

	local fishCount = 0

	for _, v in pairs(ageObject) do
		fishCount = fishCount + v
	end

	return fishCount
end

function code:part2(input)
	local ageObject = {}

	Utility
		.split(input, ",", true)
		:map(function(x)
			return tonumber(x)
		end)
		:forEach(function(v)
			ageObject[v] = (ageObject[v] and ageObject[v] + 1) or 1
		end)

	for day = 1, 256 do
		local newAgeObject = {}
		for k, v in pairs(ageObject) do
			if k == 0 then
				newAgeObject[6] = (newAgeObject[6] or 0) + v
				newAgeObject[8] = (newAgeObject[8] or 0) + v
			else
				newAgeObject[k - 1] = (newAgeObject[k - 1] or 0) + v
			end
		end
		ageObject = newAgeObject
	end

	local fishCount = 0

	for _, v in pairs(ageObject) do
		fishCount = fishCount + v
	end

	return fishCount
end

return code

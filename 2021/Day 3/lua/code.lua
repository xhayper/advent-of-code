function dofile(filename) return assert(loadfile(debug.getinfo(2, "S").source:sub(2):match("(.*/)") .. "/" .. filename))() end

local Array = dofile("./../../Common/lua/Array.lua")
local Utility = dofile("./../../Common/lua/Utility.lua")

local code = {}

function commonList(arr)
	local list = Array()
	for _, bitData in pairs(arr) do
		local bs = Utility.split(bitData, "")
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
	local input = Utility.split(input, "\n", true)
	local list = commonList(input)
	local gammaRate = list:map(function(v)
		return v.one > v.zero and "1" or "0"
	end)
	local epsilonRate = list:map(function(v)
		return v.one > v.zero and "0" or "1"
	end)
	gammaRate = table.concat(gammaRate, "")
	epsilonRate = table.concat(epsilonRate, "")
	return tonumber(gammaRate, 2) * tonumber(epsilonRate, 2)
end

function code:part2(input)
	local input = Utility.split(input, "\n", true)

	local generatorRate = input
	local scrubberRate = input

	for l = 1, #commonList(generatorRate) do
		local generatorCommonList = commonList(generatorRate)
		local scrubberCommonList = commonList(scrubberRate)

		generatorRate = generatorRate:filter(function(bitData)
			return #generatorRate == 1
				or (
					Utility.split(bitData, "")[l]
					== (generatorCommonList[l].one >= generatorCommonList[l].zero and "1" or "0")
				)
		end)

		scrubberRate = scrubberRate:filter(function(bitData)
			return #scrubberRate == 1
				or (
					Utility.split(bitData, "")[l]
					== (scrubberCommonList[l].one >= scrubberCommonList[l].zero and "0" or "1")
				)
		end)
	end

	return tonumber(generatorRate[1], 2) * tonumber(scrubberRate[1], 2)
end

return code

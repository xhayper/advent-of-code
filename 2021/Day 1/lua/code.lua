function dofile(filename) return assert(loadfile(debug.getinfo(2, "S").source:sub(2):match("(.*/)") .. "/" .. filename))() end

local Array = dofile("./../../Common/lua/Array.lua")
local Utility = dofile("./../../Common/lua/Utility.lua")

local code = {}

function code:part1(input)
	local input = Utility.split(input, "\n", true)
	return input:filter(function(v, k, t)
		return k > 1 and v > t[k - 1]
	end).length
end

function code:part2(input)
	local input = Utility.split(input, "\n", true)
	return input:filter(function(v, k, t)
		return k > 1 and (v + (t[k + 1] or 0) + (t[k + 2] or 0)) > (t[k - 1] + v + (t[k + 1] or 0))
	end).length
end

return code

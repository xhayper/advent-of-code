function dofile(filename) return assert(loadfile(debug.getinfo(2, "S").source:sub(2):match("(.*/)") .. "/" .. filename))() end

local Array = dofile("./../../Common/lua/Array.lua")
local Utility = dofile("./../../Common/lua/Utility.lua")

local code = {}

function code:part1(input)
	local input = Utility.split(input, "\n", true)

	local horizontalPosition = 0
	local depth = 0
	local instruction = {
		forward = function(n)
			horizontalPosition = horizontalPosition + n
		end,
		down = function(n)
			depth = depth + n
		end,
		up = function(n)
			depth = depth - n
		end,
	}
	for _, v in pairs(input) do
		local opcode = Utility.split(v, " ", true)
		instruction[opcode[1]](tonumber(opcode[2]))
	end
	return depth * horizontalPosition
end

function code:part2(input)
	local input = Utility.split(input, "\n", true)

	local horizontalPosition = 0
	local depth = 0
	local aim = 0

	local instruction = {
		forward = function(n)
			horizontalPosition = horizontalPosition + n
			depth = depth + (aim * n)
		end,
		down = function(n)
			aim = aim + n
		end,
		up = function(n)
			aim = aim - n
		end,
	}

	for _, v in pairs(input) do
		local opcode = Utility.split(v, " ", true)
		instruction[opcode[1]](tonumber(opcode[2]))
	end

	return depth * horizontalPosition
end

return code

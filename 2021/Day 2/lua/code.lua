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

function code:part1(input)
	local input = split(input, "\n")

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
		local opcode = split(v, " ")
		instruction[opcode[1]](tonumber(opcode[2]))
	end
	return depth * horizontalPosition
end

function code:part2(input)
	local input = split(input, "\n")

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
		local opcode = split(v, " ")
		instruction[opcode[1]](tonumber(opcode[2]))
	end

	return depth * horizontalPosition
end

return code

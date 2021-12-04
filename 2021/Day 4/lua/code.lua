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

-- https://stackoverflow.com/questions/2282444/how-to-check-if-a-table-contains-an-element-in-lua
local function find(table, element)
	for _, value in pairs(table) do
		if value == element then
			return true
		end
	end
	return false
end

-- https://stackoverflow.com/questions/1410862/concatenation-of-tables-in-lua
local function concat(t1, t2)
	for i = 1, #t2 do
		t1[#t1 + 1] = t2[i]
	end
	return t1
end

-- By me
local function reduce(tab, f, initialValue, index, originalTab)
	if #tab == 0 then
		return initialValue
	end
	if #tab == 1 then
		return tab[1]
	end
	local index = index or (initialValue and 0 or 1)
	index = index + 1
	local originalTab = originalTab or tab
	if index == 1 then
		table.insert(tab, initialValue)
	end
	local newtab = {}
	table.insert(newtab, f(tab[1], tab[2], index, originalTab))
	table.remove(tab, 1)
	table.remove(tab, 1)
	newtab = concat(newtab, tab)
	return reduce(newtab, f, initialValue, index, originalTab)
end

function code:part1(input)
	input = filter(split(input, "\n"), function(x)
		return x ~= ""
	end)
	local drawableNumber = map(split(input[1], ","), function(x)
		return tonumber(x)
	end)
	table.remove(input, 1)
	local boardList = {}
	for i = 1, #input / 5, 1 do
		local board = {}
		for j = 1, 5 do
			board[j] = map(split(input[((i - 1) * 5) + j]:gsub("  ", " "), " "), function(x)
				return tonumber(x)
			end)
		end
		table.insert(boardList, board)
	end

	local playedNumber = {}

	local bingo = false
	local firstBingoBoard = 0
	local bingoNumber = 0

	for _, currentNum in pairs(drawableNumber) do
		if bingo then
			break
		end
		table.insert(playedNumber, currentNum)
		for board, _ in pairs(boardList) do
			local arr = {}
			for y = 1, 5 do
				arr[y] = {}
				for x = 1, 5 do
					arr[y][x] = find(playedNumber, boardList[board][y][x])
					if
						(arr[1] and arr[1][x])
						and (arr[2] and arr[2][x])
						and (arr[3] and arr[3][x])
						and (arr[4] and arr[4][x])
						and (arr[5] and arr[5][x])
					then
						bingo = true
						firstBingoBoard = board
						bingoNumber = currentNum
						break
					end
				end
				if bingo then
					break
				end
				if
					(arr[y] and arr[y][1])
					and (arr[y] and arr[y][2])
					and (arr[y] and arr[y][3])
					and (arr[y] and arr[y][4])
					and (arr[y] and arr[y][5])
				then
					bingo = true
					firstBingoBoard = board
					bingoNumber = currentNum
				end
			end
			if bingo then
				break
			end
		end
	end
	return reduce(
		map(boardList[firstBingoBoard], function(v)
			return reduce(
				filter(v, function(v2)
					return not find(playedNumber, v2)
				end),
				function(p, c)
					return p + c
				end,
				0
			)
		end),
		function(p, c)
			return p + c
		end,
		0
	) * bingoNumber
end

function code:part2(input)
	input = filter(split(input, "\n"), function(x)
		return x ~= ""
	end)
	local drawableNumber = map(split(input[1], ","), function(x)
		return tonumber(x)
	end)
	table.remove(input, 1)
	local boardList = {}
	for i = 1, #input / 5, 1 do
		local board = {}
		for j = 1, 5 do
			board[j] = map(split(input[((i - 1) * 5) + j]:gsub("  ", " "), " "), function(x)
				return tonumber(x)
			end)
		end
		table.insert(boardList, board)
	end

	local playedNumber = {}

	local bingoBoardList = {}
	local bingoNumber = 0

	for _, currentNum in pairs(drawableNumber) do
		if #bingoBoardList >= #boardList then
			break
		end
		table.insert(playedNumber, currentNum)
		for board, _ in pairs(boardList) do
			if not find(bingoBoardList, board) then
				local arr = {}
				for y = 1, 5 do
					arr[y] = {}
					for x = 1, 5 do
						arr[y][x] = find(playedNumber, boardList[board][y][x])
						if
							(arr[1] and arr[1][x])
							and (arr[2] and arr[2][x])
							and (arr[3] and arr[3][x])
							and (arr[4] and arr[4][x])
							and (arr[5] and arr[5][x])
						then
							bingoNumber = currentNum
							table.insert(bingoBoardList, board)
							break
						end
					end
					if find(bingoBoardList, board) then
						break
					end
					if
						(arr[y] and arr[y][1])
						and (arr[y] and arr[y][2])
						and (arr[y] and arr[y][3])
						and (arr[y] and arr[y][4])
						and (arr[y] and arr[y][5])
					then
						bingoNumber = currentNum
						table.insert(bingoBoardList, board)
					end
				end
			end
		end
	end

	return reduce(
		map(boardList[bingoBoardList[#bingoBoardList]], function(v)
			return reduce(
				filter(v, function(v2)
					return not find(playedNumber, v2)
				end),
				function(p, c)
					return p + c
				end,
				0
			)
		end),
		function(p, c)
			return p + c
		end,
		0
	) * bingoNumber
end

return code

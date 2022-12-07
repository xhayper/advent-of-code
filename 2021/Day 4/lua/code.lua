function dofile(filename)
	return assert(loadfile(filename))()
end

local Array = dofile("../../Common/lua/Array.lua")
local Utility = dofile("../../Common/lua/Utility.lua")

local code = {}

function code:part1(input)
	input = Utility.split(input, "\n", true):filter(function(x)
		return x ~= ""
	end)
	local drawableNumber = Utility.split(input[1], ",", true):map(function(x)
		return tonumber(x)
	end)
	input:shift()
	local boardList = Array()
	for i = 1, #input / 5, 1 do
		local board = Array()
		for j = 1, 5 do
			board[j] = Utility.split(input[((i - 1) * 5) + j]:gsub("  ", " "), " ", true):map(function(x)
				return tonumber(x)
			end)
		end
		boardList:push(board)
	end

	local playedNumber = Array()

	local bingo = false
	local firstBingoBoard = 0
	local bingoNumber = 0

	for _, currentNum in pairs(drawableNumber) do
		if bingo then
			break
		end
		playedNumber:push(currentNum)
		for board, _ in pairs(boardList) do
			local arr = Array()
			for y = 1, 5 do
				arr[y] = Array()
				for x = 1, 5 do
					arr[y][x] = playedNumber:includes(boardList[board][y][x])
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

	return boardList[firstBingoBoard]
		:map(function(v)
			return v
				:filter(function(v2)
					return not playedNumber:includes(v2)
				end)
				:reduce(function(p, c)
					return p + c
				end, 0)
		end)
		:reduce(function(p, c)
			return p + c
		end, 0) * bingoNumber
end

function code:part2(input)
	input = Utility.split(input, "\n", true):filter(function(x)
		return x ~= ""
	end)
	local drawableNumber = Utility.split(input[1], ",", true):map(function(x)
		return tonumber(x)
	end)
	input:shift()
	local boardList = Array()
	for i = 1, #input / 5, 1 do
		local board = Array()
		for j = 1, 5 do
			board[j] = Utility.split(input[((i - 1) * 5) + j]:gsub("  ", " "), " ", true):map(function(x)
				return tonumber(x)
			end)
		end
		boardList:push(board)
	end

	local playedNumber = Array()

	local bingoBoardList = Array()
	local bingoNumber = 0

	for _, currentNum in pairs(drawableNumber) do
		if #bingoBoardList >= #boardList then
			break
		end
		playedNumber:push(currentNum)
		for board, _ in pairs(boardList) do
			if not bingoBoardList:includes(board) then
				local arr = Array()
				for y = 1, 5 do
					arr[y] = Array()
					for x = 1, 5 do
						arr[y][x] = playedNumber:includes(boardList[board][y][x])
						if
							(arr[1] and arr[1][x])
							and (arr[2] and arr[2][x])
							and (arr[3] and arr[3][x])
							and (arr[4] and arr[4][x])
							and (arr[5] and arr[5][x])
						then
							bingoNumber = currentNum
							bingoBoardList:push(board)
							break
						end
					end
					if bingoBoardList:includes(board) then
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
						bingoBoardList:push(board)
					end
				end
			end
		end
	end

	return boardList[bingoBoardList[bingoBoardList.length]]
		:map(function(v)
			return v
				:filter(function(v2)
					return not playedNumber:includes(v2)
				end)
				:reduce(function(p, c)
					return p + c
				end, 0)
		end)
		:reduce(function(p, c)
			return p + c
		end, 0) * bingoNumber
end

return code

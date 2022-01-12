local Array = {}

Array.type = "Array"
Array.__metatable = "Array"
Array.__type = "Array"

Array.prototype = {}
Array.prototype.__metatable = "Array"
Array.prototype.__type = "Array"

function Array.prototype.at(self, index)
	return self[math.min(math.max(0 > index and #self + index or index, 1), #self)]
end

function Array.prototype.concat(self, ...)
	local values = { ... }
	local __newArray = self:clone()
	for i = 1, #values do
		if type(values[i]) == "table" or Array.isArray(values[i]) then
			__newArray:push(table.unpack(values[i]))
		else
			__newArray:push(values[i])
		end
	end
	return __newArray
end

function Array.prototype.copyWithin(self, target, start, _end)
	error("Not implemented")
end

function Array.prototype.every(self, callbackFn)
	for i, v in pairs(self) do
		if not callbackFn(v, i, rawget(self, "__table")) then
			return false
		end
	end
	return true
end

function Array.prototype.fill(self, value, start, _end)
	if #self == 0 then
		return self
	end
	local start = math.min(math.max(start and (0 > start and #self + start or start) or 1, 1), #self)
	local _end = math.max(math.min(_end and (0 > _end and #self + _end or _end) or #self, #self), 1)
	if start >= _end or start == _end then
		return self
	end
	for count = start, _end do
		self[count] = value
	end
	return self
end

function Array.prototype.filter(self, callbackFn)
	local __newArray = Array.__call()
	for i, v in pairs(self) do
		if callbackFn(v, i, rawget(self, "__table")) then
			__newArray:push(v)
		end
	end
	return __newArray
end

function Array.prototype.find(self, callbackFn)
	for i, v in pairs(self) do
		if callbackFn(v, i, rawget(self, "__table")) then
			return v
		end
	end
end

function Array.prototype.findIndex(self, callbackFn)
	for i, v in pairs(self) do
		if callbackFn(v, i, rawget(self, "__table")) then
			return i
		end
	end
end

function Array.prototype.flat(self, depth)
	error("Not implemented")
end

function Array.prototype.flapMap(self, callbackFn)
	error("Not implemented")
end

function Array.prototype.forEach(self, callbackFn)
	for index = 1, #self do
		callbackFn(self[index], index, rawget(self, "__table"))
	end
end

function Array.prototype.includes(self, searchElement, fromIndex)
	local fromIndex = math.abs((fromIndex and 1 > fromIndex and (#self + fromIndex)) or 1)
	for index = fromIndex, #self do
		if self[index] == searchElement then
			return true
		end
	end
	return false
end

function Array.prototype.join(self, separator)
	local separator = separator or ""
	local __newString = ""
	local __insertSeperator = false
	for _, v in pairs(self) do
		__newString = __newString
			.. (__insertSeperator and separator or "")
			.. ((v ~= nil and (not Array.isArray(v) or Array.isArray(v) and #v ~= 0)) and tostring(v) or "")
		-- TODO: Make v empty string if v is an Empty Array
		__insertSeperator = true
	end
	return __newString
end

function Array.prototype.lastIndexOf(self, searchElement, fromIndex)
	if #self == 0 then
		return -1
	end
	local fromIndex = math.min(
		math.max(((fromIndex and 0 > fromIndex) and #self + fromIndex or fromIndex) or #self, 1),
		#self
	)
	for index = fromIndex, 1, -1 do
		if self[index] == searchElement then
			return index
		end
	end
	return -1
end

function Array.prototype.map(self, callbackFn)
	local __newArray = Array.__call()
	for i, v in pairs(self) do
		__newArray:push(callbackFn(v, i, rawget(self, "__table")))
	end
	return __newArray
end

function Array.prototype.pop(self)
	local element = rawget(self, "__table")[#self]
	pcall(function()
		table.remove(rawget(self, "__table"), #self)
	end)
	rawset(self, "length", self.length - 1)
	return element
end

function Array.prototype.push(self, ...)
	local elements = { ... }
	for i = 1, #elements do
		rawget(self, "__table")[self.length + i] = elements[i]
	end
	rawset(self, "length", rawget(self, "length") + #elements)
	return #self
end

local function internalReduce(self, callbackFn, initialValue, __index, __array)
	if not __array then
		__array = self:clone()
	end

	if initialValue then
		__array:unshift(initialValue)
		__index = 0
	else
		__index = __index or 1
	end

	if #__array == 1 then
		return __array[1]
	end

	__index = __index + 1

	__array[1] = callbackFn(__array[1], __array[2], __index, self)

	__array:delete(2)

	return internalReduce(self, callbackFn, nil, __index, __array)
end

function Array.prototype.reduce(self, callbackFn, initialValue)
	return internalReduce(self, callbackFn, initialValue)
end

local function internalReduceRight(self, accuminator, initialValue, __index, __array)
	if not __array then
		__array = self:clone()
	end

	if initialValue then
		__array:push(initialValue)
		__index = 0
	else
		__index = __index or 1
	end

	if #__array == 1 then
		return __array[1]
	end

	__index = __index + 1

	__array[#__array] = accuminator(__array[#__array], __array[#__array - 1], __index, self)

	__array:delete(#__array - 1)

	return internalReduceRight(self, accuminator, nil, __index, __array)
end

function Array.prototype.reduceRight(self, accuminator, initialValue)
	return internalReduceRight(self, accuminator, initialValue)
end

function Array.prototype.reverse(self)
	local __newArray = Array.__call()
	for i = self.length, 1, -1 do
		__newArray:push(rawget(self, "__table")[i])
	end
	rawset(self, "__table", __newArray)
	return self
end

function Array.prototype.shift(self)
	local element = rawget(self, "__table")[#self]
	pcall(function()
		table.remove(rawget(self, "__table"), 1)
	end)
	rawset(self, "length", self.length - 1)
	return element
end

function Array.prototype.slice(self, start, _end)
	error("Not implemented")
end

function Array.prototype.some(self, callbackFn)
	for i, v in pairs(self) do
		if callbackFn(v, i, self) then
			return true
		end
	end
	return false
end

function Array.prototype.sort(self, compareFunction)
	table.sort(rawget(self, "__table"), compareFunction and function(a, b)
		return 0 > compareFunction(a, b)
	end)
	return self
end

function Array.prototype.splice(self, start, deleteCount, ...)
	error("Not implemented")
end

function Array.prototype.toString(self, ...)
	return self:join(",")
end

function Array.prototype.unshift(self, ...)
	local elements = { ... }
	for i = 1, #elements do
		table.insert(rawget(self, "__table"), 1, elements[i])
	end
	rawset(self, "length", rawget(self, "length") + #elements)
	return #self
end

function Array.prototype.delete(self, index)
	pcall(function()
		table.remove(rawget(self, "__table"), index)
		rawset(self, "length", self.length - 1)
	end)
end

function Array.prototype.clone(self)
	return Array.__call(self, table.unpack(rawget(self, "__table")))
end

Array.prototype.__tostring = function(self)
	local __newString = ""
	local __insertSeperator = false
	for _, v in pairs(self) do
		__newString = __newString
			.. (__insertSeperator and ", " or "")
			.. (
				v ~= nil
					and string.format(
						"%s%s%s",
						type(v) ~= "number" and type(v) ~= "nil" and not Array.isArray(v) and "'" or "",
						tostring(v),
						type(v) ~= "number" and type(v) ~= "nil" not Array.isArray(v) and "'" or ""
					)
				or ""
			)
		__insertSeperator = true
	end
	return #self == 0 and "[]" or string.format("[ %s ]", __newString)
end

Array.prototype.__len = function(self)
	return self.length
end

Array.prototype.__newindex = function(self, key, value)
	if type(key) ~= "number" and tonumber(key) == nil then
		return
	end
	key = math.abs(tonumber(key))
	if 1 > key then
		return
	end
	if self.__table[key] == nil then
		self.__table[key] = value
		self.length = key > self.length and key or self.length
	else
		self.__table[key] = value
	end
end

Array.prototype.__index = function(self, key)
	if type(key) == "number" or tonumber(key) ~= nil then
		return rawget(self, "__table")[math.abs(tonumber(key))]
	end
	return Array.prototype[key] or rawget(self, key)
end

Array.prototype.__pairs = function(self)
	return next, self.__table, nil
end

function Array.isArray(value)
	return type(value) == "table" and getmetatable(value) == "Array"
end

function Array.__call(_, ...)
	local elements = { ... }
	local self = setmetatable({
		__table = {},
		length = 0,
	}, Array.prototype)
	for _, v in pairs(elements) do
		self[#self + 1] = v
	end
	return self
end

return setmetatable({}, Array)

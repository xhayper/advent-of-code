-- My implementation of the Array class from Javascript

------------------------------------------------------------

local Array = {}

Array.prototype = {}

function Array.prototype.concat(self, ...)
    local values = {...}
    local __newArray = Array.__call(table.unpack(self.__table))
    for index=1, #values do
        for i=1, #values[index] do
            table.insert(__newArray, values[index][i])
        end
    end
    return __newArray
end

function Array.prototype.copyWithin(self, target, start, end_)
    error("Not implemented")
end

function Array.prototype.every(self, callbackFn)
    for index=1, #self.__table do
        if not callbackFn(self.__table[index], index, self.__table) then return false end
    end
    return true
end

function Array.prototype.fill(self, value, start, end_)
    local start = 0 < start and #self.__table + start or 0
    local end_ = 0 < end_ and #self.__table + end_ or #self.__table
    for index=start, end_ do
        self.__table[index] = value
    end
    return self
end

function Array.prototype.filter(self, callbackFn)
    local __newArray = Array.__call()
    for index=1, #self.__table do
        if callbackFn(self.__table[index], index, self.__table) then
            table.insert(__newArray, self.__table[index])
        end
    end
    return __newArray
end

function Array.prototype.find(self, callbackFn)
    for index=1, #self.__table do
        if callbackFn(self.__table[index], index, self.__table) then return self.__table[index] end
    end
end

function Array.prototype.findIndex(self, callbackFn)
    for index=1, #self.__table do
        if callbackFn(self.__table[index], index, self.__table) then return index end
    end
end

function Array.prototype.flat(self, depth)
    error("Not implemented")
end

function Array.prototype.flatMap(self, callbackFn)
    error("Not implemented")
end

function Array.prototype.forEach(self, callbackFn)
    for index=1, #self.__table do
        callbackFn(self.__table[index], index, self.__table)
    end
end

function Array.prototype.includes(self, searchElement, fromIndex)
    local fromIndex = 0 > fromIndex and #self.__table + fromIndex or 0
    fromIndex = math.abs(fromIndex)
    for index=fromIndex, #self.__table do
        if self.__table[index] == searchElement then return true end
    end
end

function Array.prototype.indexOf(self, searchElement, fromIndex)
    local fromIndex = 0 > fromIndex and #self.__table + fromIndex or 0
    fromIndex = math.abs(fromIndex)
    for index=fromIndex, #self.__table do
        if self.__table[index] == searchElement then return index end
    end
    return -1
end

function Array.prototype.join(self, separator)
    local separator = separator or ""
    local __newString = ""
    for index=1, #self.__table do
        __newString = __newString..(index ~= 1 and separator or "")..self.__table[index]
    end
    return __newString
end

function Array.prototype.lastIndexOf(self, searchElement, fromIndex)
    local fromIndex = 0 > fromIndex and #self.__table + fromIndex or #self.__table
    fromIndex = math.abs(fromIndex)
    for index=fromIndex, 1, -1 do
        if self.__table[index] == searchElement then return index end
    end
    return -1
end

function Array.prototype.map(self, callbackFn)
    local __newArray = Array.__call()
    for index=1, #self.__table do
        table.insert(__newArray, callbackFn(self.__table[index], index, self.__table))
    end
    return __newArray
end

function Array.prototype.pop(self)
    local element = self.__table[#self.__table]
    table.remove(self.__table, #self.__table)
    return element
end

function Array.prototype.push(self, ...)
    local elements = {...}
    for index=1, #elements do
        table.insert(self.__table, index, elements[index])
    end
    return #self.__table
end

function internalReduce(self, array, callbackFn, initialValue, __index)
    if #array == 1 then return array[1] end
    local __index = __index or (initialValue and 0 or 1)
    __index = __index + 1
    if __index == 1 then table.insert(array, initialValue) end
    array[1] = callbackFn(array[1], array[2], __index, self.__table)
    table.remove(array, 2)
    return internalReduce(array, callbackFn, nil, __index)
end

function Array.prototype.reduce(self, callbackFn, initialValue)
    return internalReduce(self, Array.__call(table.unpack(self.__table)), callbackFn, initialValue)
end

function Array.prototype.reduceRight(self, callbackFn, initialValue)
    error("Not implemented")
end

function Array.prototype.reverse(self)
    local __newArray = Array.__call()
    for index=#self.__table, 1, -1 do
        table.insert(__newArray, self.__table[index])
    end
    self.__table = __newArray.__table
    return __newArray
end

function Array.prototype.shift(self)
    local element = self.__table[1]
    table.remove(self.__table, 1)
    return element
end

function Array.prototype.slice(self, start, end_)
    local start = 0 < start and #self.__table + start or 0
    local end_ = 0 < end_ and #self.__table + end_ or #self.__table
    local __newArray = Array.__call()
    for index=start, end_ do
        __newArray.push(self.__table[index])
    end
    return __newArray
end

function Array.prototype.some(self, callbackFn)
    for index=1, #self.__table do
        if callbackFn(self.__table[index], index, self.__table) then return true end
    end
    return false
end

function Array.prototype.splice(self, start, deleteCount, ...)
    error("Not implemented")
end

function Array.prototype.toString(self)
    return tostring(self)
end

function Array.prototype.unshift(self, ...)
    local elements = {...}
    for index=1, #elements do
        table.insert(self, index, elements[index])
    end
    return #self.__table
end

--------------------------------------------------------------

function Array.prototype.__metatable()
    return "Array.prototype"
end

function Array.prototype.__call(self)
    return self.__table
end

function Array.prototype.__index(self, index)
    if (index == "length") then return #rawget(self, "__table") end
    if (index == "__table") then return rawget(self, "__table") end
    return Array.prototype[index] or rawget(self, "__table")[index]
end

function Array.prototype.__newindex(self, index, value)
    if type(index) ~= "number" and tonumber(index) == nil then error("Attempt to set non-number index to array") end
    self.__table[math.abs(tonumber(index))] = value
end

--------------------------------------------------------------

function Array.__call(self, ...)
    local elements = {...}
    local self = setmetatable({}, Array.prototype)
    rawset(self, "__table", {})
    rawset(self, "__type", "Array")
    for index=1, #elements do table.insert(self.__table, elements[index]) end
    return self
end

function Array.__metatable()
    return "Array"
end

--------------------------------------------------------------

return setmetatable({}, Array)

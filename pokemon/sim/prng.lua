--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
____exports.PRNG = __TS__Class()
local PRNG = ____exports.PRNG
PRNG.name = "PRNG"
function PRNG.prototype.____constructor(self, seed)
    if seed == nil then
        seed = nil
    end
    if not seed then
        seed = ____exports.PRNG:generateSeed()
    end
    self.initialSeed = __TS__ArraySlice(seed)
    self.seed = __TS__ArraySlice(seed)
end
__TS__SetDescriptor(
    PRNG.prototype,
    "startingSeed",
    {
        get = function(self)
            return self.initialSeed
        end
    },
    true
)
function PRNG.prototype.clone(self)
    return __TS__New(____exports.PRNG, self.seed)
end
function PRNG.prototype.next(self, from, to)
    self.seed = self:nextFrame(self.seed)
    local result = bit.rshift(
        bit.lshift(self.seed[1], 16),
        0
    ) + self.seed[2]
    if from then
        from = math.floor(from)
    end
    if to then
        to = math.floor(to)
    end
    if from == nil then
        result = result / 4294967296
    elseif not to then
        result = math.floor((result * from) / 4294967296)
    else
        result = math.floor((result * (to - from)) / 4294967296) + from
    end
    return result
end
function PRNG.prototype.randomChance(self, numerator, denominator)
    return self:next(denominator) < numerator
end
function PRNG.prototype.sample(self, items)
    if #items == 0 then
        error(
            __TS__New(RangeError, "Cannot sample an empty array"),
            0
        )
    end
    local index = self:next(#items)
    local item = items[index + 1]
    if (item == nil) and (not Object.prototype.hasOwnProperty(items, index)) then
        error(
            __TS__New(RangeError, "Cannot sample a sparse array"),
            0
        )
    end
    return item
end
function PRNG.prototype.shuffle(self, items, start, ____end)
    if start == nil then
        start = 0
    end
    if ____end == nil then
        ____end = #items
    end
    while start < (____end - 1) do
        local nextIndex = self:next(start, ____end)
        if start ~= nextIndex then
            items[start + 1], items[nextIndex + 1] = __TS__Unpack({items[nextIndex + 1], items[start + 1]})
        end
        start = start + 1
    end
end
function PRNG.prototype.multiplyAdd(self, a, b, c)
    local out = {0, 0, 0, 0}
    local carry = 0
    do
        local outIndex = 3
        while outIndex >= 0 do
            do
                local bIndex = outIndex
                while bIndex < 4 do
                    local aIndex = 3 - (bIndex - outIndex)
                    carry = carry + (a[aIndex + 1] * b[bIndex + 1])
                    bIndex = bIndex + 1
                end
            end
            carry = carry + c[outIndex + 1]
            out[outIndex + 1] = bit.band(carry, 65535)
            carry = bit.rshift(carry, 16)
            outIndex = outIndex - 1
        end
    end
    return out
end
function PRNG.prototype.nextFrame(self, seed, framesToAdvance)
    if framesToAdvance == nil then
        framesToAdvance = 1
    end
    local a = {23896, 35685, 27655, 35173}
    local c = {0, 0, 38, 40643}
    do
        local i = 0
        while i < framesToAdvance do
            seed = self:multiplyAdd(seed, a, c)
            i = i + 1
        end
    end
    return seed
end
function PRNG.generateSeed(self)
    return {
        math.floor(
            math.random() * 65536
        ),
        math.floor(
            math.random() * 65536
        ),
        math.floor(
            math.random() * 65536
        ),
        math.floor(
            math.random() * 65536
        )
    }
end
return ____exports

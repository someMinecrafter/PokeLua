--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____lib = require("lib/index")
local Utils = ____lib.Utils
function ____exports.toID(self, text)
    if text and text.id then
        text = text.id
    elseif text and text.userid then
        text = text.userid
    elseif text and text.roomid then
        text = text.roomid
    end
    if (type(text) ~= "string") and (type(text) ~= "number") then
        return ""
    end
    return __TS__StringReplace(
        string.lower(
            "" .. tostring(text)
        ),
        nil,
        ""
    )
end
____exports.BasicEffect = __TS__Class()
local BasicEffect = ____exports.BasicEffect
BasicEffect.name = "BasicEffect"
function BasicEffect.prototype.____constructor(self, data)
    self.exists = true
    __TS__ObjectAssign(self, data)
    self.name = __TS__StringTrim(
        Utils:getString(data.name)
    )
    self.id = ((data.realMove and (function() return ____exports.toID(_G, data.realMove) end)) or (function() return ____exports.toID(_G, self.name) end))()
    self.fullname = Utils:getString(data.fullname) or self.name
    self.effectType = Utils:getString(data.effectType) or "Condition"
    self.exists = not (not (self.exists and self.id))
    self.num = data.num or 0
    self.gen = data.gen or 0
    self.shortDesc = data.shortDesc or ""
    self.desc = data.desc or ""
    self.isNonstandard = data.isNonstandard or nil
    self.duration = data.duration
    self.noCopy = not (not data.noCopy)
    self.affectsFainted = not (not data.affectsFainted)
    self.status = data.status or nil
    self.weather = data.weather or nil
    self.sourceEffect = data.sourceEffect or ""
end
function BasicEffect.prototype.__tostring(self)
    return self.name
end
____exports.Nature = __TS__Class()
local Nature = ____exports.Nature
Nature.name = "Nature"
__TS__ClassExtends(Nature, ____exports.BasicEffect)
function Nature.prototype.____constructor(self, data)
    Nature.____super.prototype.____constructor(self, data)
    data = self
    self.fullname = "nature: " .. self.name
    self.effectType = "Nature"
    self.gen = 3
    self.plus = data.plus or nil
    self.minus = data.minus or nil
end
____exports.DexNatures = __TS__Class()
local DexNatures = ____exports.DexNatures
DexNatures.name = "DexNatures"
function DexNatures.prototype.____constructor(self, dex)
    self.natureCache = __TS__New(Map)
    self.allCache = nil
    self.dex = dex
end
function DexNatures.prototype.get(self, name)
    if name and (type(name) ~= "string") then
        return name
    end
    return self:getByID(
        ____exports.toID(_G, name)
    )
end
function DexNatures.prototype.getByID(self, id)
    local nature = self.natureCache:get(id)
    if nature then
        return nature
    end
    if rawget(self.dex.data.Aliases, id) ~= nil then
        nature = self:get(self.dex.data.Aliases[id])
        if nature.exists then
            self.natureCache:set(id, nature)
        end
        return nature
    end
    if id and (rawget(self.dex.data.Natures, id) ~= nil) then
        local natureData = self.dex.data.Natures[id]
        nature = __TS__New(____exports.Nature, natureData)
        if nature.gen > self.dex.gen then
            nature.isNonstandard = "Future"
        end
    else
        nature = __TS__New(____exports.Nature, {name = id, exists = false})
    end
    if nature.exists then
        self.natureCache:set(id, nature)
    end
    return nature
end
function DexNatures.prototype.all(self)
    if self.allCache then
        return self.allCache
    end
    local natures = {}
    for id in pairs(self.dex.data.Natures) do
        __TS__ArrayPush(
            natures,
            self:getByID(id)
        )
    end
    self.allCache = natures
    return self.allCache
end
____exports.TypeInfo = __TS__Class()
local TypeInfo = ____exports.TypeInfo
TypeInfo.name = "TypeInfo"
function TypeInfo.prototype.____constructor(self, data)
    self.exists = true
    __TS__ObjectAssign(self, data)
    self.name = data.name
    self.id = data.id
    self.effectType = Utils:getString(data.effectType) or "Type"
    self.exists = not (not (self.exists and self.id))
    self.gen = data.gen or 0
    self.isNonstandard = data.isNonstandard or nil
    self.damageTaken = data.damageTaken or ({})
    self.HPivs = data.HPivs or ({})
    self.HPdvs = data.HPdvs or ({})
end
function TypeInfo.prototype.__tostring(self)
    return self.name
end
____exports.DexTypes = __TS__Class()
local DexTypes = ____exports.DexTypes
DexTypes.name = "DexTypes"
function DexTypes.prototype.____constructor(self, dex)
    self.typeCache = __TS__New(Map)
    self.allCache = nil
    self.namesCache = nil
    self.dex = dex
end
function DexTypes.prototype.get(self, name)
    if name and (type(name) ~= "string") then
        return name
    end
    return self:getByID(
        ____exports.toID(_G, name)
    )
end
function DexTypes.prototype.getByID(self, id)
    local ____type = self.typeCache:get(id)
    if ____type then
        return ____type
    end
    local typeName = id:charAt(0):toUpperCase() + id:substr(1)
    if typeName and (rawget(self.dex.data.TypeChart, id) ~= nil) then
        ____type = __TS__New(
            ____exports.TypeInfo,
            __TS__ObjectAssign({name = typeName, id = id}, self.dex.data.TypeChart[id])
        )
    else
        ____type = __TS__New(____exports.TypeInfo, {name = typeName, id = id, exists = false, effectType = "EffectType"})
    end
    if ____type.exists then
        self.typeCache:set(id, ____type)
    end
    return ____type
end
function DexTypes.prototype.names(self)
    if self.namesCache then
        return self.namesCache
    end
    self.namesCache = __TS__ArrayMap(
        __TS__ArrayFilter(
            self:all(),
            function(____, ____type) return not ____type.isNonstandard end
        ),
        function(____, ____type) return ____type.name end
    )
    return self.namesCache
end
function DexTypes.prototype.isName(self, name)
    local id = string.lower(name)
    local typeName = tostring(
        string.upper(
            string.sub(id, 1, 1)
        )
    ) .. tostring(
        __TS__StringSubstr(id, 1)
    )
    return (name == typeName) and (rawget(self.dex.data.TypeChart, id) ~= nil)
end
function DexTypes.prototype.all(self)
    if self.allCache then
        return self.allCache
    end
    local types = {}
    for id in pairs(self.dex.data.TypeChart) do
        __TS__ArrayPush(
            types,
            self:getByID(id)
        )
    end
    self.allCache = types
    return self.allCache
end
local idsCache = {"hp", "atk", "def", "spa", "spd", "spe"}
local reverseCache = {__proto = nil, hitpoints = "hp", attack = "atk", defense = "def", specialattack = "spa", spatk = "spa", spattack = "spa", specialatk = "spa", special = "spa", spc = "spa", specialdefense = "spd", spdef = "spd", spdefense = "spd", specialdef = "spd", speed = "spe"}
____exports.DexStats = __TS__Class()
local DexStats = ____exports.DexStats
DexStats.name = "DexStats"
function DexStats.prototype.____constructor(self, dex)
    if dex.gen ~= 1 then
        self.shortNames = {__proto__ = nil, hp = "HP", atk = "Atk", def = "Def", spa = "SpA", spd = "SpD", spe = "Spe"}
        self.mediumNames = {__proto__ = nil, hp = "HP", atk = "Attack", def = "Defense", spa = "Sp. Atk", spd = "Sp. Def", spe = "Speed"}
        self.names = {__proto__ = nil, hp = "HP", atk = "Attack", def = "Defense", spa = "Special Attack", spd = "Special Defense", spe = "Speed"}
    else
        self.shortNames = {__proto__ = nil, hp = "HP", atk = "Atk", def = "Def", spa = "Spc", spd = "[SpD]", spe = "Spe"}
        self.mediumNames = {__proto__ = nil, hp = "HP", atk = "Attack", def = "Defense", spa = "Special", spd = "[Sp. Def]", spe = "Speed"}
        self.names = {__proto__ = nil, hp = "HP", atk = "Attack", def = "Defense", spa = "Special", spd = "[Special Defense]", spe = "Speed"}
    end
end
function DexStats.prototype.getID(self, name)
    if name == "Spd" then
        return "spe"
    end
    local id = ____exports.toID(_G, name)
    if reverseCache[id] then
        return reverseCache[id]
    end
    if idsCache:includes(id) then
        return id
    end
    return nil
end
function DexStats.prototype.ids(self)
    return idsCache
end
return ____exports

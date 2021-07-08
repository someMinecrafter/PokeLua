--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
local ____dex_2Ddata = require("sim/dex-data")
local BasicEffect = ____dex_2Ddata.BasicEffect
local toID = ____dex_2Ddata.toID
____exports.Item = __TS__Class()
local Item = ____exports.Item
Item.name = "Item"
__TS__ClassExtends(Item, BasicEffect)
function Item.prototype.____constructor(self, data)
    BasicEffect.prototype.____constructor(self, data)
    data = self
    self.fullname = "item: " .. self.name
    self.effectType = "Item"
    self.fling = data.fling or nil
    self.onDrive = data.onDrive or nil
    self.onMemory = data.onMemory or nil
    self.megaStone = data.megaStone or nil
    self.megaEvolves = data.megaEvolves or nil
    self.zMove = data.zMove or nil
    self.zMoveType = data.zMoveType or nil
    self.zMoveFrom = data.zMoveFrom or nil
    self.itemUser = data.itemUser or nil
    self.isBerry = not (not data.isBerry)
    self.ignoreKlutz = not (not data.ignoreKlutz)
    self.onPlate = data.onPlate or nil
    self.isGem = not (not data.isGem)
    self.isPokeball = not (not data.isPokeball)
    if not self.gen then
        if self.num >= 689 then
            self.gen = 7
        elseif self.num >= 577 then
            self.gen = 6
        elseif self.num >= 537 then
            self.gen = 5
        elseif self.num >= 377 then
            self.gen = 4
        else
            self.gen = 3
        end
    end
    if self.isBerry then
        self.fling = {basePower = 10}
    end
    if self.id:endsWith("plate") then
        self.fling = {basePower = 90}
    end
    if self.onDrive then
        self.fling = {basePower = 70}
    end
    if self.megaStone then
        self.fling = {basePower = 80}
    end
    if self.onMemory then
        self.fling = {basePower = 50}
    end
end
____exports.DexItems = __TS__Class()
local DexItems = ____exports.DexItems
DexItems.name = "DexItems"
function DexItems.prototype.____constructor(self, dex)
    self.itemCache = __TS__New(Map)
    self.allCache = nil
    self.dex = dex
end
function DexItems.prototype.get(self, name)
    if name and (type(name) ~= "string") then
        return name
    end
    name = (name or ""):trim()
    local id = toID(_G, name)
    return self:getByID(id)
end
function DexItems.prototype.getByID(self, id)
    local item = self.itemCache:get(id)
    if item then
        return item
    end
    if rawget(self.dex.data.Aliases, id) ~= nil then
        item = self:get(self.dex.data.Aliases[id])
        if item.exists then
            self.itemCache:set(id, item)
        end
        return item
    end
    if (id and (not self.dex.data.Items[id])) and self.dex.data.Items[tostring(id) .. "berry"] then
        item = self:getByID(
            tostring(id) .. "berry"
        )
        self.itemCache:set(id, item)
        return item
    end
    if id and (rawget(self.dex.data.Items, id) ~= nil) then
        local itemData = self.dex.data.Items[id]
        local itemTextData = self.dex:getDescs("Items", id, itemData)
        item = __TS__New(
            ____exports.Item,
            __TS__ObjectAssign({name = id}, itemData, itemTextData)
        )
        if item.gen > self.dex.gen then
            item.isNonstandard = "Future"
        end
        if ((self.dex.currentMod == "gen7letsgo") and (not item.isNonstandard)) and (not item.megaStone) then
            item.isNonstandard = "Past"
        end
    else
        item = __TS__New(____exports.Item, {name = id, exists = false})
    end
    if item.exists then
        self.itemCache:set(id, item)
    end
    return item
end
function DexItems.prototype.all(self)
    if self.allCache then
        return self.allCache
    end
    local items = {}
    for id in pairs(self.dex.data.Items) do
        __TS__ArrayPush(
            items,
            self:getByID(id)
        )
    end
    self.allCache = items
    return self.allCache
end
return ____exports

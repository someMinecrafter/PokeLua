--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
require("lualib_bundle");
local ____exports = {}
____exports.BattleQueue = __TS__Class()
local BattleQueue = ____exports.BattleQueue
BattleQueue.name = "BattleQueue"
function BattleQueue.prototype.____constructor(self, battle)
    self.battle = battle
    self.list = {}
    local queueScripts = battle.format.queue or battle.dex.data.Scripts.queue
    if queueScripts then
        __TS__ObjectAssign(self, queueScripts)
    end
end
function BattleQueue.prototype.shift(self)
    return __TS__ArrayShift(self.list)
end
function BattleQueue.prototype.peek(self)
    return self.list[1]
end
function BattleQueue.prototype.push(self, action)
    return __TS__ArrayPush(self.list, action)
end
function BattleQueue.prototype.unshift(self, action)
    return __TS__ArrayUnshift(self.list, action)
end
BattleQueue.prototype[Symbol.iterator] = function(self)
    return (function()
        local ____self = self.list
        return ____self[Symbol.iterator](____self)
    end)()
end
function BattleQueue.prototype.entries(self)
    return self.list:entries()
end
function BattleQueue.prototype.resolveAction(self, action, midTurn)
    if midTurn == nil then
        midTurn = false
    end
    if not action then
        error(
            __TS__New(Error, "Action not passed to resolveAction"),
            0
        )
    end
    if action.choice == "pass" then
        return {}
    end
    local actions = {action}
    if (not action.side) and action.pokemon then
        action.side = action.pokemon.side
    end
    if (not action.move) and action.moveid then
        action.move = self.battle.dex:getActiveMove(action.moveid)
    end
    if not action.order then
        local orders = {team = 1, start = 2, instaswitch = 3, beforeTurn = 4, beforeTurnMove = 5, runUnnerve = 100, runSwitch = 101, runPrimal = 102, switch = 103, megaEvo = 104, runDynamax = 105, shift = 200, residual = 300}
        if orders[action.choice] ~= nil then
            action.order = orders[action.choice]
        else
            action.order = 200
            if not ({"move", "event"}):includes(action.choice) then
                error(
                    __TS__New(Error, "Unexpected orderless action " .. action.choice),
                    0
                )
            end
        end
    end
    if not midTurn then
        if action.choice == "move" then
            if ((not action.maxMove) and (not action.zmove)) and action.move.beforeTurnCallback then
                __TS__ArrayUnshift(
                    actions,
                    __TS__Unpack(
                        self:resolveAction({choice = "beforeTurnMove", pokemon = action.pokemon, move = action.move, targetLoc = action.targetLoc})
                    )
                )
            end
            if action.mega then
                __TS__ArrayUnshift(
                    actions,
                    __TS__Unpack(
                        self:resolveAction({choice = "megaEvo", pokemon = action.pokemon})
                    )
                )
            end
            if action.maxMove and (not action.pokemon.volatiles.dynamax) then
                __TS__ArrayUnshift(
                    actions,
                    __TS__Unpack(
                        self:resolveAction({choice = "runDynamax", pokemon = action.pokemon})
                    )
                )
            end
            action.fractionalPriority = self.battle:runEvent("FractionalPriority", action.pokemon, nil, action.move, 0)
        elseif ({"switch", "instaswitch"}):includes(action.choice) then
            if type(action.pokemon.switchFlag) == "string" then
                action.sourceEffect = self.battle.dex.moves:get(action.pokemon.switchFlag)
            end
            action.pokemon.switchFlag = false
        end
    end
    local deferPriority = ((self.battle.gen == 7) and action.mega) and (action.mega ~= "done")
    if action.move then
        local target = nil
        action.move = self.battle.dex:getActiveMove(action.move)
        if not action.targetLoc then
            target = self.battle:getRandomTarget(action.pokemon, action.move)
            if target then
                action.targetLoc = action.pokemon:getLocOf(target)
            end
        end
        action.originalTarget = action.pokemon:getAtLoc(action.targetLoc)
    end
    if not deferPriority then
        self.battle:getActionSpeed(action)
    end
    return actions
end
function BattleQueue.prototype.prioritizeAction(self, action, sourceEffect)
    for ____, ____value in __TS__Iterator(
        self.list:entries()
    ) do
        local i
        i = ____value[1]
        local curAction
        curAction = ____value[2]
        if curAction == action then
            __TS__ArraySplice(self.list, i, 1)
            break
        end
    end
    action.sourceEffect = sourceEffect
    action.order = 3
    __TS__ArrayUnshift(self.list, action)
end
function BattleQueue.prototype.changeAction(self, pokemon, action)
    self:cancelAction(pokemon)
    if not action.pokemon then
        action.pokemon = pokemon
    end
    self:insertChoice(action)
end
function BattleQueue.prototype.addChoice(self, choices)
    if not __TS__ArrayIsArray(choices) then
        choices = {choices}
    end
    for ____, choice in ipairs(choices) do
        local resolvedChoices = self:resolveAction(choice)
        __TS__ArrayPush(
            self.list,
            __TS__Unpack(resolvedChoices)
        )
        local resolvedChoice = resolvedChoices[1]
        if (resolvedChoice and (resolvedChoice.choice == "move")) and (resolvedChoice.move.id ~= "recharge") then
            resolvedChoice.pokemon.side.lastSelectedMove = resolvedChoice.move.id
        end
    end
end
function BattleQueue.prototype.willAct(self)
    for ____, action in ipairs(self.list) do
        if ({"move", "switch", "instaswitch", "shift"}):includes(action.choice) then
            return action
        end
    end
    return nil
end
function BattleQueue.prototype.willMove(self, pokemon)
    if pokemon.fainted then
        return nil
    end
    for ____, action in ipairs(self.list) do
        if (action.choice == "move") and (action.pokemon == pokemon) then
            return action
        end
    end
    return nil
end
function BattleQueue.prototype.cancelAction(self, pokemon)
    local oldLength = #self.list
    do
        local i = 0
        while i < #self.list do
            if self.list[i + 1].pokemon == pokemon then
                __TS__ArraySplice(self.list, i, 1)
                i = i - 1
            end
            i = i + 1
        end
    end
    return #self.list ~= oldLength
end
function BattleQueue.prototype.cancelMove(self, pokemon)
    for ____, ____value in __TS__Iterator(
        self.list:entries()
    ) do
        local i
        i = ____value[1]
        local action
        action = ____value[2]
        if (action.choice == "move") and (action.pokemon == pokemon) then
            __TS__ArraySplice(self.list, i, 1)
            return true
        end
    end
    return false
end
function BattleQueue.prototype.willSwitch(self, pokemon)
    for ____, action in ipairs(self.list) do
        if ({"switch", "instaswitch"}):includes(action.choice) and (action.pokemon == pokemon) then
            return action
        end
    end
    return nil
end
function BattleQueue.prototype.insertChoice(self, choices, midTurn)
    if midTurn == nil then
        midTurn = false
    end
    if __TS__ArrayIsArray(choices) then
        for ____, choice in ipairs(choices) do
            self:insertChoice(choice)
        end
        return
    end
    local choice = choices
    if choice.pokemon then
        choice.pokemon:updateSpeed()
    end
    local actions = self:resolveAction(choice, midTurn)
    local firstIndex = nil
    local lastIndex = nil
    for ____, ____value in __TS__Iterator(
        self.list:entries()
    ) do
        local i
        i = ____value[1]
        local curAction
        curAction = ____value[2]
        local compared = self.battle:comparePriority(actions[1], curAction)
        if (compared <= 0) and (firstIndex == nil) then
            firstIndex = i
        end
        if compared < 0 then
            lastIndex = i
            break
        end
    end
    if firstIndex == nil then
        __TS__ArrayPush(
            self.list,
            __TS__Unpack(actions)
        )
    else
        if lastIndex == nil then
            lastIndex = #self.list
        end
        local index = (((firstIndex == lastIndex) and (function() return firstIndex end)) or (function() return self.battle:random(firstIndex, lastIndex + 1) end))()
        __TS__ArraySplice(
            self.list,
            index,
            0,
            __TS__Unpack(actions)
        )
    end
end
function BattleQueue.prototype.clear(self)
    self.list = {}
end
function BattleQueue.prototype.debug(self, action)
    if action then
        return (((((((((tostring(action.order or "") .. ":") .. tostring(action.priority or "")) .. ":") .. tostring(action.speed or "")) .. ":") .. tostring(action.subOrder or "")) .. " - ") .. tostring(action.choice)) .. ((action.pokemon and (function() return " " .. tostring(action.pokemon) end)) or (function() return "" end))()) .. ((action.move and (function() return " " .. tostring(action.move) end)) or (function() return "" end))()
    end
    return tostring(
        table.concat(
            __TS__ArrayMap(
                self.list,
                function(____, queueAction) return self:debug(queueAction) end
            ),
            "\n" or ","
        )
    ) .. "\n"
end
function BattleQueue.prototype.sort(self)
    self.battle:speedSort(self.list)
    return self
end
____exports.default = ____exports.BattleQueue
return ____exports

---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2023/3/31 10:58
---

---@class TargetConditionHelper
local TargetConditionHelper = T(Lib, "TargetConditionHelper")
---@type TaskConfig
local TaskConfig = T(Config, "TaskConfig")
---@type GrowthSystem
local GrowthSystem = T(Lib, "GrowthSystem")
---@type AbilitySystem
local AbilitySystem = T(Lib, "AbilitySystem")
---@type InventorySystem
local InventorySystem = T(Lib, "InventorySystem")
---@type SafeRegionConfig
local SafeRegionConfig = T(Config, "SafeRegionConfig")

function TargetConditionHelper:init()
    self.playerPartRegionInfo = {}
    self.playerSafeRegionInfo = {}
    self.playerMissionSafeInfo = {}
    self:initEvent()
end

function TargetConditionHelper:initEvent()
    if World.isClient then
        Lib.subscribeEvent(Event.EVENT_PLAYER_LOGIN, function(playerInf)
            if playerInf.objID == Me.objID then
                if not Me.firstLoginTime then
                    Me.firstLoginTime = os.time()
                    Me:updateBloomSetting()
                    Me:updateSensitiveView()
                end
            end
        end)

        Lib.subscribeEvent(Event.EVENT_CLIENT_CHANGE_SCENE_MAP, function(mapName)
            Me:updateBloomSetting()

            if self.playerPartRegionInfo[Me.platformUserId] then
                for partName, partId in pairs(self.playerPartRegionInfo[Me.platformUserId]) do
                    if partId then
                        local part = Instance.getByInstanceId(partId)
                        if not part or not part:isValid() then
                            self.playerPartRegionInfo[Me.platformUserId][partName] = false
                        end
                    end
                end
            end

            if self.playerSafeRegionInfo[Me.platformUserId] then
                local partId = self.playerSafeRegionInfo[Me.platformUserId]
                local part = Instance.getByInstanceId(partId)
                if not part or not part:isValid() then
                    self.playerSafeRegionInfo[Me.platformUserId] = false
                end
            end

            if self.playerMissionSafeInfo[Me.platformUserId] then
                local partId = self.playerMissionSafeInfo[Me.platformUserId]
                local part = Instance.getByInstanceId(partId)
                if not part or not part:isValid() then
                    self.playerMissionSafeInfo[Me.platformUserId] = false
                end
            end
            Lib.emitEvent(Event.EVENT_SAFE_REGION_UPDATE)
        end)
    end
end

function TargetConditionHelper:updatePlayerPartRegionData(player, partName, partId, inRegion)
    if not self.playerPartRegionInfo[player.platformUserId] then
        self.playerPartRegionInfo[player.platformUserId] = {}
    end
    if inRegion then
        self.playerPartRegionInfo[player.platformUserId][partName] = partId
    else
        self.playerPartRegionInfo[player.platformUserId][partName] = inRegion
    end

    if not World.isClient then
        if TaskConfig:checkIsTaskRegionPart(partName) then
            player:checkUpdateTaskData(Define.TargetConditionKey.LOCATION)
        end

        if SafeRegionConfig:getCfgByRegionName(partName) then
            if SafeRegionConfig:getCfgMissionRegion(partName) then
                if inRegion then
                    self.playerMissionSafeInfo[player.platformUserId] = partId
                else
                    self.playerMissionSafeInfo[player.platformUserId] = inRegion
                end
            else
                if inRegion then
                    self.playerSafeRegionInfo[player.platformUserId] = partId
                else
                    self.playerSafeRegionInfo[player.platformUserId] = inRegion
                end
            end
            player:updateSafeBuffShow()
        end
    else
        if SafeRegionConfig:getCfgByRegionName(partName) then
            if SafeRegionConfig:getCfgMissionRegion(partName) then
                if inRegion then
                    self.playerMissionSafeInfo[player.platformUserId] = partId
                else
                    self.playerMissionSafeInfo[player.platformUserId] = inRegion
                end
            else
                if inRegion then
                    self.playerSafeRegionInfo[player.platformUserId] = partId
                else
                    self.playerSafeRegionInfo[player.platformUserId] = inRegion
                end
            end
            if player.objID == Me.objID then
                Lib.emitEvent(Event.EVENT_SAFE_REGION_UPDATE)
            end
        end
    end
end

function TargetConditionHelper:isInSafeRegion(player)
    if not player.platformUserId then
        return false
    end
    return self.playerSafeRegionInfo[player.platformUserId]
end

function TargetConditionHelper:isInMissionSafe(player)
    if not player.platformUserId then
        return false
    end
    return self.playerMissionSafeInfo[player.platformUserId]
end

function TargetConditionHelper:cleanPlayerPartRegionData(player)
    self.playerPartRegionInfo[player.platformUserId] = {}
    self.playerMissionSafeInfo[player.platformUserId] = nil
    self.playerSafeRegionInfo[player.platformUserId] = nil
end

function TargetConditionHelper:playerIsInPartRegionData(player, partName)
    if not self.playerPartRegionInfo[player.platformUserId] then
        self.playerPartRegionInfo[player.platformUserId] = {}
        return false
    end
    return  self.playerPartRegionInfo[player.platformUserId][partName]
end

function TargetConditionHelper:initConditionData(params)
    if not params[1] then
        return
    end
    local result
    if params[1] == Define.TargetConditionKey.LEVEL then
        result = {
            minLevel = tonumber(params[2] or 0),
            maxLevel = tonumber(params[3] or 0),
            curLevel = 1
        }
    elseif params[1] == Define.TargetConditionKey.NPC then
        result = {
            npcId = params[2] or "",
            dialogId = tonumber(params[3] or 0),
        }
    elseif params[1] == Define.TargetConditionKey.LOCATION then
        result = {
            partName = params[2] or ""
        }
    elseif params[1] == Define.TargetConditionKey.ITEM then
        result = {
            item_alias = params[2],
            needCounts = tonumber(params[3] or 0),
            ownCounts = 0
        }
    elseif params[1] == Define.TargetConditionKey.KILL then
        result = {
            monsterId = tonumber(params[2] or 0),
            needKills = tonumber(params[3] or 0),
            killCounts = 0
        }
    elseif params[1] == Define.TargetConditionKey.ABILITY then
        result = {
            abilityId = tonumber(params[2] or 0),
            minLevel = tonumber(params[3] or 0),
            maxLevel = tonumber(params[4] or 0),
            curLevel = 1
        }
    elseif params[1] == Define.TargetConditionKey.TASK then
        result = {
            needTaskId = tonumber(params[2] or 0)
        }
    elseif params[1] == Define.TargetConditionKey.BORN then
        result = {
            mapName = params[2] or ""
        }
    elseif params[1] == Define.TargetConditionKey.MISSION then
        result = {
            needMissionGroup = tonumber(params[2] or 0)
        }
    end
    if not result then
        return
    end
    result.conditionKey = params[1]
    return result
end

function TargetConditionHelper.BORN(condition, player)
    local bornMap = player:getBornMap()
    if bornMap == condition.mapName then
        return true
    end
    return false
end

function TargetConditionHelper.LEVEL(condition, player)
    local curLevel = GrowthSystem:getLevel(player)
    if curLevel >= condition.minLevel and curLevel <= condition.maxLevel then
        return true
    end
    return false
end

function TargetConditionHelper.NPC(condition, player)
    local counts = player:getOneDialogRecord(condition.npcId, condition.dialogId)
    return counts > 0
end

function TargetConditionHelper.LOCATION(condition, player)
    return TargetConditionHelper:playerIsInPartRegionData(player, condition.partName)
end

function TargetConditionHelper.ITEM(condition, player)
    local ownCounts = InventorySystem:getItemAmountByItemAlias(player, Define.INVENTORY_TYPE.ABILITY, condition.item_alias)
    if ownCounts >= condition.needCounts then
        return true
    end
    return false
end

function TargetConditionHelper.KILL(condition, player, taskId)
    if not taskId then
        return false
    end
    local mainTask = player:getMainTask()
    if mainTask[taskId] then
        if mainTask[taskId].taskCompleteCondition[Define.TargetConditionKey.KILL] then
            local allFinish = true
            for index, val in pairs(mainTask[taskId].taskCompleteCondition[Define.TargetConditionKey.KILL]) do
                if val.killCounts < val.needKills then
                    allFinish = false
                end
            end
            if allFinish then
                return true
            end
        end
    end

    local branchTask = player:getBranchTask()
    if branchTask[taskId] then
        if branchTask[taskId].taskCompleteCondition[Define.TargetConditionKey.KILL] then
            local allFinish = true
            for index, val in pairs(branchTask[taskId].taskCompleteCondition[Define.TargetConditionKey.KILL]) do
                if val.killCounts < val.needKills then
                    allFinish = false
                end
            end
            if allFinish then
                return true
            end
        end
    end
    return false
end

function TargetConditionHelper.ABILITY(condition, player)
    local abilityList = AbilitySystem:getAbilityListByAbilityId(player, condition.abilityId) or {}
    local maxLevel = 0
    ---@type number, Ability
    for _, ability in pairs(abilityList) do
        local level = ability:getLevel()
        if level > maxLevel then
            maxLevel = level
        end
    end
    if maxLevel >= condition.minLevel and maxLevel <= condition.maxLevel then
        return true
    end
    return true
end

function TargetConditionHelper.TASK(condition, player)
    local completeTask = player:getCompleteTask()
    if completeTask[condition.needTaskId or 0] then
        return true
    end
    return false
end

function TargetConditionHelper.MISSION(condition, player, taskId, params)
    if params and params.missionGroup and (condition.needMissionGroup == params.missionGroup) then
        return true
    end
    return false
end
TargetConditionHelper:init()
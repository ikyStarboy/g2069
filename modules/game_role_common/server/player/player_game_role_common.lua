---
--- Generated by PluginCreator
--- game_role_common player
--- DateTime:2023-03-03
---

local Player = Player
---@type AbilitySystem
local AbilitySystem = T(Lib, "AbilitySystem")
---@type AbilityConfig
local AbilityConfig = T(Config, "AbilityConfig")

local function _updateActionMap(player)
    if not player then
        return
    end
    local ability=AbilitySystem:getAbility(player)
    if ability then
        local cfg=AbilityConfig:getCfgByAbilityId(ability:getItemId())
        if cfg then
            --print("xxxxxxx",Lib.v2s(cfg))
            local normalMap={}
            normalMap.idle=cfg.idleAction
            normalMap.run=cfg.runAction
            local battleMap={}
            battleMap.idle=cfg.fightAction
            battleMap.run=cfg.fightRunAction
            player:setPlayerActionMap(normalMap,battleMap)
        end
    end
end

Lib.subscribeEvent(Event.EVENT_GAME_ROLE_COMMON_SYNC_ROLE_DATA, function(player)
    _updateActionMap(player)
end)

Lib.subscribeEvent(Event.EVENT_GAME_ROLE_COMMON_UPDATE_ABILITY, function(success, player)
    if not success then
        return
    end
    _updateActionMap(player)
end)




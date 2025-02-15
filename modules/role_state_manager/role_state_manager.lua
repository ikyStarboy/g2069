---
--- Generated by PluginCreator
--- role_state_manager mainLua
--- DateTime:2023-03-13
---

require "common.entity_role_state_manager"
require "common.event_role_state_manager"
require "common.define_role_state_manager"
require "common.role_state_helper"

if World.isClient then
    require "client.player.player_role_state_manager"
    require "client.player.packet_role_state_manager"
    require "client.entity.entity_role_state_manager"
    require "client.entity.entity_value_func_role_state_manager"
    require "client.gm_role_state_manager"

else
    require "server.player.player_role_state_manager"
    require "server.player.packet_role_state_manager"
    require "server.entity.entity_role_state_manager"
    require "server.gm_role_state_manager"
end

---@type setting
local setting = require "common.setting"

local handlers = {}
function handlers.SKILL_CAST(context)
    local entity=World.CurWorld:getEntity(context.obj1.objID)
    if entity and entity:isValid() and entity.isPlayer then
        ---@type ModMeta
        local CfgMod = setting:mod("skill")
        local cfg = CfgMod:get(context.fullName)
        if cfg then
            --print("---------------------handlers.SKILL_CAST",context.fullName,entity.objID,cfg.skillId,cfg.type)
            if cfg.skillId and cfg.type~="Fly" then
                entity:enterStateType(Define.RoleStatus.BATTLE_STATE)
            end
        end
    end
end

if World.isClient then

else
    ---@type RoleStateHelper
    local RoleStateHelper = T(Lib, "RoleStateHelper")
    -- 服务端登陆
    function handlers.OnPlayerLogin(player)
        RoleStateHelper:removeEntityStateData(player.objID)
    end
end

return function(name, ...)
	if type(handlers[name]) ~= "function" then
		return
	end
	return handlers[name](...)
end

---
--- Generated by PluginCreator
--- scene_object mainLua
--- DateTime:2023-03-23
---

require "common.entity_scene_object"
require "common.event_scene_object"
require "common.define_scene_object"
require "common.instance.instance_scene_object"

if World.isClient then
    require "client.player.player_scene_object"
    require "client.player.packet_scene_object"
    require "client.entity.entity_scene_object"
    require "client.entity.entity_value_func_scene_object"
    require "client.entity.entity_event_scene_object"
    require "client.scene.scene_handler"
    require "client.gm_scene_object"

    --- 初始化管理器
    local initManager = function()
        ---@type SceneObjectManagerClient
        local SceneObjectManagerClient = require "client.manager.scene_object_manager"
        SceneObjectManagerClient:instance():init()
    end
    initManager()

else
    require "server.player.player_scene_object"
    require "server.player.packet_scene_object"
    require "server.entity.entity_scene_object"
    require "server.entity.entity_event_scene_object"
    require "server.world.map_scene_object"
    require "server.gm_scene_object"

    --- 初始化管理器
    local initManager = function()
        ---@type SceneObjectManagerServer
        local SceneObjectManagerServer = require "server.manager.scene_object_manager"
        SceneObjectManagerServer:instance():init()
    end
    initManager()
end

local handlers = {}

--function handlers.openXXXWnd()
	--TODO
--end

if World.isClient then

else
    ---@type SceneObjectManagerServer
    local SceneObjectManagerServer = require "server.manager.scene_object_manager"
    ---@type MonsterConfig
    local MonsterConfig = T(Config, "MonsterConfig")

    --- 击杀怪物
    ---@param entity Entity
    function handlers.onKillMonsterDropItem(entity)
        if not entity or not entity:isValid() or not entity:isMonster() then
            return
        end
        local monsterId = entity:getMonsterId()
        local itemId = MonsterConfig:getCfgByMonsterId(monsterId).drop_item
        if itemId and itemId > 0 then
            local position = entity:getPosition()
            SceneObjectManagerServer:instance():createInstance(entity.map, itemId, position, nil, { drop_item = 1 })
        end
    end

    --- 丢弃能力
    ---@param entity Entity
    ---@param ability Ability
    function handlers.onDropAbility(entity, ability)
        SceneObjectManagerServer:instance():onDropAbility(entity, ability)
    end

    --- 丢弃物品
    ---@param entity Entity
    ---@param item Item
    function handlers.onDropItem(entity, item)
        SceneObjectManagerServer:instance():onDropItem(entity, item)
    end
end

--- 子弹技能回调
---@param context any
function handlers.PART_HITTED(context)
    ---@type Instance
    local part = context.part1
    ---@type Entity
    local owner = context.obj2
    local missile = context.missile
    if part and part:isValid() then
        Lib.emitEvent(Event.EVENT_SCENE_OBJECT_HIT_PART, owner, part)
    end
end

return function(name, ...)
	if type(handlers[name]) ~= "function" then
		return
	end
	return handlers[name](...)
end

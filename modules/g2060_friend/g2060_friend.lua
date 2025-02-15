---
--- Generated by PluginCreator
--- g2060_friend mainLua
--- DateTime:2022-07-07
---

--[[
    好友跟随功能：请求玩家游戏数据判断隐私字段是否为true，可以跟随则判断是否同服，同服则传送，否则 sendGotoOtherGame进行跳服，服务器设置跟随cd没有存db，跳服的话cd会失效
]]

require "common.entity_g2060_friend"
require "common.event_g2060_friend"
require "common.define_g2060_friend"
require "common.player.player_g2060_friend"
require "common.friend_utils"
if World.isClient then
    require "client.g2060_friend_client_event"
    require "client.player.player_g2060_friend"
    require "client.player.packet_g2060_friend"
    require "client.entity.entity_g2060_friend"
    require "client.entity.entity_value_func_g2060_friend"
    require "client.gm_g2060_friend"
    require "client.g2060_friend_special_data"
else
    require "server.player.player_g2060_friend"
    require "server.player.packet_g2060_friend"
    require "server.entity.entity_g2060_friend"
    require "server.gm_g2060_friend"
    require "server.async_process_g2060_friend"
    require "server.g2060_friend_special_data"
end

--local FriendSpecialData = T(Lib, "FriendSpecialData")

local handlers = {}

--function handlers.ENTITY_TELEPORT(context)
--    local entity = context.obj1
--    if entity and entity:isValid() and entity.isPlayer then
--        local mapName = entity.map.name
--        local game_mode  = Game.GetGameMode()
--        if not game_mode or game_mode == "" then
--            if mapName == "map001" then
--                FriendSpecialData:setPlayerSpecialData(entity.platformUserId, {
--                    gameStatus = Define.FriendGameStatus.Hall
--                }, true)
--            else
--                FriendSpecialData:setPlayerSpecialData(entity.platformUserId, {
--                    gameStatus = Define.FriendGameStatus.Other
--                }, true)
--            end
--        end
--    end
--end

function handlers.ENTITY_ENTER(context)
    local entity = context.obj1
    if entity and entity:isValid() and entity.isPlayer then
        entity:checkFollowTarget()
    end
end
--
--function handlers.ENTITY_LEAVE(context)
--    local entity = context.obj1
--    if entity:isValid() and entity.isPlayer then
--
--    end
--end

function handlers.RESET_GAME_FAILED(context)
    local entity = context.obj1
    if entity:isValid() and entity.isPlayer then
        entity:sendPacket({
            pid = "ShowGameTopTips",
            text = "g2060_friend_follow_fail",
        })
    end
end

return function(name, ...)
	if type(handlers[name]) ~= "function" then
		return
	end
	return handlers[name](...)
end

---
--- Generated by PluginCreator
--- engine_overwrite event
--- DateTime:2023-02-24
---

if World.isClient then
    Event.EVENT_ENGINE_OVERWRITE_FALL_ON_GROUND = Event.register("EVENT_ENGINE_OVERWRITE_FALL_ON_GROUND")
    Event.EVENT_HANDLE_RENDER_TICK_CLIENT = Event.register("EVENT_HANDLE_RENDER_TICK_CLIENT") --客户端渲染帧
    Event.EVENT_SCENE_OBJECT_CLIENT_CREATE_INSTANCE = Event.register("EVENT_SCENE_OBJECT_CLIENT_CREATE_INSTANCE")
    Event.EVENT_SCENE_OBJECT_CLOSE_NOVICE_TELEPORT = Event.register("EVENT_SCENE_OBJECT_CLOSE_NOVICE_TELEPORT")
else
    Event.EVENT_ENTITY_SKIN_INFO_UPDATE = Event.register("EVENT_ENTITY_SKIN_INFO_UPDATE")
end

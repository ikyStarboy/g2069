---
--- Generated by PluginCreator
--- engine_overwrite handler
--- DateTime:2023-02-24
---

local handles = T(Player, "PackageHandlers")

local oldChangeMap = handles.ChangeMap
function handles:ChangeMap(packet)
    Lib.emitEvent(Event.EVENT_CLIENT_CHANGE_MAP_START)
    oldChangeMap(self, packet)
    local map = World.CurMap
    Lib.emitEvent(Event.EVENT_CLIENT_CHANGE_SCENE_MAP, map.name)
end

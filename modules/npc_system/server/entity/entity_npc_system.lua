---
--- Generated by PluginCreator
--- npc_system entity
--- DateTime:2023-03-29
---

local Entity = Entity
local EntityServer = EntityServer
local ValueFunc = T(Entity, "ValueFunc")

--buff key:
--function Entity.EntityProp:xxx(value, add, buff)
--end


function Entity.ValueFunc:dialogRecord(value)
    self:checkUpdateTaskData(Define.TargetConditionKey.NPC)
end
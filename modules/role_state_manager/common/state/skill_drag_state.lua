---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2023/3/23 15:32
---

local RoleStateBase = require "common.state.base_state"

--- @class SkillDragState : RoleStateBase
local SkillDragState = Lib.class("SkillDragState", RoleStateBase)

function SkillDragState:init(type)
    RoleStateBase.init(self, type or Define.RoleStatus.SKILL_ACTION_STATE)
end

function SkillDragState:enterState(objID)
    RoleStateBase.enterState(self, objID)
    local entity=World.CurWorld:getEntity(objID)
    if not entity or not entity:isValid() or entity.objID~=Me.objID or not World.isClient then
        return
    end
    entity:setEntityProp("gravity",0)
    --print("++++++++++++++++++++++++++++++++++  SkillDragState:enterState",objID)
end

function SkillDragState:exitState(objID)
    RoleStateBase.exitState(self, objID)
    local entity=World.CurWorld:getEntity(objID)
    if not entity or not entity:isValid() or entity.objID~=Me.objID or not World.isClient then
        return
    end
    entity:resetEntityProp("gravity")
    --print("==================================== SkillDragState:exitState",objID)
end

function SkillDragState:stopTimer(entity)
end

return SkillDragState
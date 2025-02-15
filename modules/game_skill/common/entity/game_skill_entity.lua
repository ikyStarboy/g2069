---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 10184.
--- DateTime: 2021/1/20 12:01
---

------@class chargeStateData
---@field isCharging boolean
---@field skillId number
---@field skillMoveId number
---@field canCastSkill boolean
---@field isBurst boolean
---@field chargeTimeRate number

---@type SkillMovesConfig
local SkillMovesConfig = T(Config, "SkillMovesConfig")

local ValueDef = T(Entity, "ValueDef")
-- key				                         = {isCpp,	client,	toSelf,	toOther,	init,	                            saveDB}
ValueDef.defaultUpperAction                  = {false,	true,	true,	true,       "idle",		                         false}
ValueDef.chargeState                         = {false,	false,	true,	true,       {},  		                         false}
ValueDef.sprintMotion                        = {false,	true,	true,	true,       {},  		                         false}
ValueDef.skillSpeedUp                        = {false,	false,	true,	false,       0,  		                         false} -- 技能冷却百分比增减
ValueDef.flyState                            = {false,	false,	true,	true,       {},  		                         false}
ValueDef.curChildActor                       = {false,	false,	true,	true,       nil,  		                         false}
ValueDef.playerBeBlowAway                    = {false,	true,	false,	true,      0, 		                             false}
ValueDef.dragState                           = {false,	false,	true,	false,       0,  		                         false}

local Entity = Entity

function Entity:getSkillSpeedUp()
    return self:getValue("skillSpeedUp")
end

function Entity:setSkillSpeedUp(value)
    return self:setValue("skillSpeedUp",value)
end

function Entity:addSkillSpeedUp(value)
    local skillSpeedUp = self:getSkillSpeedUp()
    skillSpeedUp = skillSpeedUp + value
    self:setSkillSpeedUp(skillSpeedUp)
end

function Entity:getRealSkillCd(skillCd)
    return skillCd*(1 + self:getSkillSpeedUp())
end

function Entity:getSprintMotion()
    return self:getValue("sprintMotion")
end

function Entity:setSprintMotion(value)
    return self:setValue("sprintMotion",value)
end

---@return chargeStateData
function Entity:getChargeState()
    return self:getValue("chargeState")
end

function Entity:getIsCanNotMoveCharging()
    ---@type chargeStateData
    local data=self:getValue("chargeState")
    if not data.isCharging then
        return false
    end
    return SkillMovesConfig:checkStopMoveOnCharge(data.skillMoveId)
end

--function Entity:getIsCanNotRotateCharging()
--    ---@type chargeStateData
--    local data=self:getValue("chargeState")
--    if not data.isCharging then
--        return false
--    end
--    local cfg=SkillMovesConfig:getSkillConfig(data.skillId)
--    if cfg then
--        return cfg.storageLimitRotate==1
--    end
--    return false
--end

function Entity:getFlyState()
    return self:getValue("flyState")
end

function Entity:setFlyState(value)
    return self:setValue("flyState",value)
end

function Entity:getCurChildActor()
    return self:getValue("curChildActor")
end

function Entity:setCurChildActor(value)
    return self:setValue("curChildActor",value)
end

function Entity:getPlayerBeBlowAway()
    return self:getValue("playerBeBlowAway")
end

function Entity:setPlayerBeBlowAway(value)
    return self:setValue("playerBeBlowAway",value)
end

function Entity:getDragState()
    return self:getValue("dragState")
end

function Entity:setDragState(value)
    return self:setValue("dragState",value)
end
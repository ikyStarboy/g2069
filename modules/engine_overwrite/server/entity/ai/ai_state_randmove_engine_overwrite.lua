---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Administrator.
--- DateTime: 2023/4/21 16:56
---

local AIStateBase = require("entity.ai.ai_state_base")

local AIStateRandMove = L("AIStateRandMove", Lib.derive(AIStateBase))
AIStateRandMove.NAME = "RANDMOVE"

function AIStateRandMove:enter()
    local entity = self:getEntity()
    local control = self.control

    local curPos = entity:getPosition()
    local enterIdlePos = control:aiData("enterIdlePos")
    local distanceDec = Lib.getPosDistance(curPos, enterIdlePos)
    if distanceDec > 1 then
        control:setAiData("idleStartTime", -1)
    end

    local entityCfg =  entity:cfg()
    if entityCfg.randMoveSpeed ~= entity:prop("moveSpeed") then
        entity:setProp("moveSpeed", entityCfg.randMoveSpeed)
    end

    local lastState = control:getLastState()
    if lastState and ((lastState.NAME ~= self.NAME) or (lastState.NAME ~= "IDLE")) then
        control:setAiData("homePos", entity:getPosition())
    end
    if entity:isInStateType(Define.RoleStatus.BATTLE_STATE) then
        entity:exitStateType(Define.RoleStatus.BATTLE_STATE)
    end

    local target = control:randPosInHomeArea()
    if not target then
        target = control:randPosNearBy(control:aiData("patrolDistance") or 5)
    end

    if target then
        control:setTargetPos(target, true)
    else
        control:setTargetPos()
    end

    local timeRange = control:aiData("randMoveTime") or {20, 30}
    local min = math.ceil(timeRange[1])
    local max = math.ceil(timeRange[2])
    local randomTime = math.random(min, max)
    self.endTime = World.Now() + randomTime
end

function AIStateRandMove:update()

end

function AIStateRandMove:aiStateIsEnd()
    return self.endTime - World.Now() <= 0
end

function AIStateRandMove:exit()
    self.endTime = nil
end

RETURN(AIStateRandMove)
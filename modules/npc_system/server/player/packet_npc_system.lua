---
--- Generated by PluginCreator
--- npc_system handler
--- DateTime:2023-03-29
---

local handles = T(Player, "PackageHandlers")
---@type RewardHelper
local RewardHelper = T(Lib, "RewardHelper")
---@type NpcDialogueReplyConfig
local NpcDialogueReplyConfig = T(Config, "NpcDialogueReplyConfig")
---@type WalletSystem
local WalletSystem = T(Lib, "WalletSystem")
---@type NpcRewardSettingConfig
local NpcRewardSettingConfig = T(Config, "NpcRewardSettingConfig")
---@type GrowthSystem
local GrowthSystem = T(Lib, "GrowthSystem")
---@type InventorySystem
local InventorySystem = T(Lib, "InventorySystem")

function handles:ReceiveDialogReward(packet)
    local replyConfig = NpcDialogueReplyConfig:getCfgById(packet.replyId)
    if replyConfig then
        RewardHelper:gainNPCDialogRewards(self, packet.replyId)
    end
end

function handles:RequestReceiveNpcTask(packet)
    local replyConfig = NpcDialogueReplyConfig:getCfgById(packet.replyId)
    if replyConfig and replyConfig.taskId > 0 then
        return self:receiveOneTask(replyConfig.taskId)
    end
end

--- npc抽奖
---@param packet any
function handles:C2SBuyNpcLuckyDraw(packet)
    local groupId = packet.groupId

    local dialogDrawTime = self:getDialogDrawTime()
    local curLevel = GrowthSystem:getLevel(self)
    local rewardCfg
    if dialogDrawTime[groupId] then
        rewardCfg = NpcRewardSettingConfig:getCfgByGroupAndLv(groupId, curLevel)
    else -- 首次抽奖
        local firstDraw = NpcRewardSettingConfig:getCfgByGroupAFirst(groupId, curLevel)
        if firstDraw then
            rewardCfg = firstDraw
        else
            rewardCfg = NpcRewardSettingConfig:getCfgByGroupAndLv(groupId, curLevel)
        end
    end

    if not rewardCfg then
        self:pushNpcLuckyDrawResult(1)
        return
    end

    local poolId = rewardCfg.pool_id
    local dialogDrawTime = self:getDialogDrawTime()
    local lastDrawTime = dialogDrawTime[groupId] or 0
    local passTime = os.time() - lastDrawTime
    local remainTime = rewardCfg.coolTime - passTime
    if remainTime > 0 then
        self:pushNpcLuckyDrawResult(1)
        return
    end

    local coinName = rewardCfg.item_alias
    local coinNum = rewardCfg.kValue*curLevel + rewardCfg.bValue

    if packet.isUseScribe then
        if self:isCanUseFreeLuckyDraw() then
            coinNum = 0
            self:doNpcLuckyDraw(groupId, poolId, coinName, coinNum)
            self:setDialogFreeDrawTime(os.time())
            return
        end
    end

    if WalletSystem:getCoin(self, coinName) < coinNum then
        self:pushNpcLuckyDrawResult(2, rewardCfg.item_alias)
    else
        if coinName == Define.ITEM_ALIAS.GOLDEN_CUBE then
            InventorySystem.MODIFY_SOURCE = Define.ITEM_REWARD_SOURCE[Define.REWARD_TYPE.NPC_LUCKY_DRAW]
            WalletSystem:payCube(self, "npd_lucky_draw_" .. poolId, coinNum, function(success)
                InventorySystem.MODIFY_SOURCE = nil
                if not self or not self:isValid() then
                    return
                end
                if success then
                    self:doNpcLuckyDraw(groupId, poolId, coinName, coinNum)
                else
                    self:pushNpcLuckyDrawResult(1)
                end
            end, 1, "npd_lucky_draw_" .. poolId)
        else
            InventorySystem.MODIFY_SOURCE = Define.ITEM_REWARD_SOURCE[Define.REWARD_TYPE.NPC_LUCKY_DRAW]
            --- 购买商品
            WalletSystem:payCoin(self, coinName, coinNum, false, false, "npd_lucky_draw_" .. poolId, nil)
            InventorySystem.MODIFY_SOURCE = nil
            self:doNpcLuckyDraw(groupId, poolId, coinName, coinNum)
        end
    end
end
---
--- Generated by PluginCreator
--- new_chat player
--- DateTime:2022-01-06
---

local Player = Player
function Player:sendChatMsg(packet)
    if packet.msgData.msgType==Define.MsgType.Voice then
        if  self:checkCanSendVoice() then
            self:updateVoiceCounts()
        else
            print(">>>>>>>>>>>>>>>>>>>  can not send voice!")
            return
        end
    end
    local pageType=packet.msgData.pageType
    if pageType==Define.ChatPage.Gang then
        self:sendChatMsgGang(packet)
    else
        WorldServer.BroadcastPacket(packet)
    end
end

---sendChatMsgGang 帮会聊天
---@param packet table
function Player:sendChatMsgGang(packet)
    local memberList=Plugins.CallTargetPluginFunc("gangs", "getPlayerGangMemberList", self)
    if not memberList then
        return
    end
    for k, _ in pairs(memberList) do
        local member=Game.GetPlayerByUserId(k)
        if member and member:isValid() then
            member:sendPacket(packet)
        end
    end
end

function Player:checkVoiceMoonEnable()
    local mac = self:getSoundMoonCardMac()
    if mac == 0 then
        return false
    elseif mac - os.time() < 0 then
        self:setSoundMoonCardMac(0)
        return false
    else
        return true
    end
end

function Player:addMoonCard(reward)
    print(">>>>>>>>>>>>>>>>>>>>>>>> Player:addMoonCard:",reward,self:getSoundMoonCardMac())
    if self:getSoundMoonCardMac() == 0 then
        self:setSoundMoonCardMac((reward) * 30 * 24 * 3600 + os.time())
    else
        self:setSoundMoonCardMac((reward) * 30 * 24 * 3600 + self:getSoundMoonCardMac())
    end
end

function Player:addVoiceCnt(reward)
    print(">>>>>>>>>>>>>>>>>>>>>>>> Player:addVoiceCnt:",reward,self:getSoundTimes())
    self:setValue("soundTimes", self:getSoundTimes() + reward)
end

function Player:getVoiceCardTime()
    local mac = self:getSoundMoonCardMac()
    if mac == 0 then
        return -1
    else
        return math.max(-1, mac - os.time())
    end
end

function Player:initVoiceInfo(info)
    if info.expiryDateLong and tonumber(info.expiryDateLong) > 0 then
        self:setSoundMoonCardMac(tonumber(info.expiryDateLong) )
    end
    if info.times and tonumber(info.times) > 0 then
        self:setValue("soundTimes",tonumber(info.times) )
    end
    if info.freeTimes and tonumber(info.times) > 0 then
        self:setValue("freeSoundTimes",tonumber(info.times) )
    end
end

-- 更新语音聊天次数
function Player:updateVoiceCounts()
    if not self:checkVoiceMoonEnable() then
        -- 优先消耗免费喇叭，然后再消费付费喇叭
        if self:getFreeSoundTimes() > 0 then
            self:useFreeSoundTimes()
        else
            if self:getSoundTimes() > 0 then
                self:useSoundTimes()
            end
        end
    end
end

-- 检测是否还有语音聊天次数
function Player:checkCanSendVoice()
    if not self:checkVoiceMoonEnable() and self:getSoundTimes() < 1 and self:getFreeSoundTimes() < 1 then
        --local packet = {
        --    pid = "ChatSystemMessage",
        --    msg = "ui.chat.voiceless",
        --    isLang = true,
        --    args = table.pack(nil, nil, Define.Page.SYSTEM),
        --}
        --self:sendChatMsg(packet, true)
        return false
    end
    return true
end
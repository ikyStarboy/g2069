---
--- Generated by PluginCreator
--- fly_new_tips handler
--- DateTime:2023-04-17
---

local handles = T(Player, "PackageHandlers")

function handles:RequestBoardFlyNewTips(packet)
    self:pushClientShowOneFlyTips(packet.itemInfo, true)
end

-- Initialize the addon
local addonName, addon = ...

-- Create the frame for displaying information
local frame = CreateFrame("Frame", "RaidExportFrame", UIParent, "BackdropTemplate")
frame:SetSize(380, 440)
frame:SetPoint("CENTER")
frame:Hide()
frame:SetMovable(true)
frame:SetScript("OnMouseDown", function(self, button)
	self:StartMoving()
end)
frame:SetScript("OnMouseUp", function(self, button)
	self:StopMovingOrSizing()
end)


-- Create a backdrop and border for the frame
frame:SetBackdrop({
    bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background-Dark",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
})

-- Create a scrollable text area inside the frame
local scrollFrame = CreateFrame("ScrollFrame", "RaidExportScrollFrame", frame, "UIPanelScrollFrameTemplate")
scrollFrame:SetSize(360, 400)
scrollFrame:SetPoint("CENTER")
scrollFrame:SetClipsChildren(true)

-- Create the text area inside the scroll frame
local editBox = CreateFrame("EditBox", nil, scrollFrame)
editBox:SetMultiLine(true)
editBox:SetFontObject("ChatFontNormal")
editBox:SetSize(360, 400)
editBox:SetAutoFocus(true)
editBox:HighlightText()
editBox:SetScript("OnEscapePressed", function(self)
    self:ClearFocus()
end)

scrollFrame:SetScrollChild(editBox)

-- Create a top frame with the "Raid Export" text, anchored to the top of the frame
local topFrame = CreateFrame("Frame", nil, frame, "BackdropTemplate")
topFrame:SetSize(380, 40)
topFrame:SetPoint("TOP", frame, "TOP", 0, 36) -- Anchored outside of the scroll frame
topFrame:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 },
})
local topText = topFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
topText:SetPoint("CENTER", topFrame, "CENTER")
topText:SetText("Raid Export")


-- Create a close button for the frame
local closeButton = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
closeButton:SetPoint("TOPRIGHT", topFrame, "TOPRIGHT", 0, -4)

-- Slash command to show/hide the frame
SLASH_RAIDEXPORT1 = "/raidexport"
SlashCmdList["RAIDEXPORT"] = function(msg)
    if frame:IsShown() then
        frame:Hide()
    else
        frame:Show()
        local raidMembersInfo = {}
        local tankMembers = {}
        local damagerMembers = {}
        local healerMembers = {}
        
        for i = 1, GetNumGroupMembers() do
            local name, _, _, _, _, className, _, _, _, _ = GetRaidRosterInfo(i)
            local role = UnitGroupRolesAssigned("raid" .. i)
            if role == "TANK" then
                table.insert(tankMembers, string.format("%s,%s,%s\n", name, className, role))
            elseif role == "DAMAGER" then
                table.insert(damagerMembers, string.format("%s,%s,%s\n", name, className, role))
            elseif role == "HEALER" then
                table.insert(healerMembers, string.format("%s,%s,%s\n", name, className, role))
            end
        end
        
        for _, member in ipairs(tankMembers) do
            table.insert(raidMembersInfo, member)
        end
        for _, member in ipairs(damagerMembers) do
            table.insert(raidMembersInfo, member)
        end
        for _, member in ipairs(healerMembers) do
            table.insert(raidMembersInfo, member)
        end
        
        editBox:SetText(table.concat(raidMembersInfo))
    end
end
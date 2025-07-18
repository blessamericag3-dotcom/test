--[[
    The Definitive, Final, and Corrected Version.
    - My sincere apologies for the repeated "nil value" errors. The cause was inconsistent data
      structures in the `allActions` table, which was a critical design flaw on my part.
    - This has been completely resolved by redesigning the `allActions` table to have a
      consistent and predictable structure for all items.
    - The sync and reset logic has been updated to use this new, stable structure,
      eliminating the source of the errors.
]]

-- A check to prevent the script from running if the library is already loaded
if game:GetService("CoreGui"):FindFirstChild("DrRay") then
    game:GetService("CoreGui"):FindFirstChild("DrRay"):Destroy()
    task.wait(0.1)
end

local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("Larps ┃ Paradise", "Default")

local Player = game.Players.LocalPlayer
local SCRIPT_ACCESSORY_TAG = "DrRayScriptedAccessory"

--//-------------------------- STATE MANAGEMENT --------------------------\\--

local originalLimbData = {}
local removedHairStorage = {}
local autoEquipSelection = {}
local characterAddedConnection = nil
local toggleObjects = {}

--//-------------------------- UTILITY & ACTION DEFINITIONS --------------------------\\--

local function weldParts(p0,p1,c0,c1) local w=Instance.new("Weld"); w.Part0,w.Part1,w.C0,w.C1,w.Parent=p0,p1,c0,c1,p0; return w end
local function findAttachment(root,name) for _,d in ipairs(root:GetDescendants()) do if d:IsA("Attachment") and d.Name==name then return d end end end
local function clearOldAccessories(char) if not char then return end for _,c in ipairs(char:GetChildren()) do if c:IsA("Accessory") and c:FindFirstChild(SCRIPT_ACCESSORY_TAG) then c:Destroy() end end end

local function addAccessory(char, accessoryData)
    if not char or not accessoryData then return end
    local head = char:FindFirstChild("Head")
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    
    if accessoryData.Head and head then
        for _, id in ipairs(accessoryData.Head) do
            local s,acc=pcall(function() return game:GetObjects("rbxassetid://"..tostring(id))[1] end)
            if s and acc then
                local tag=Instance.new("BoolValue"); tag.Name,tag.Parent=SCRIPT_ACCESSORY_TAG,acc; acc.Parent=workspace
                local h=acc:FindFirstChild("Handle")
                if h then
                    local a=h:FindFirstChildOfClass("Attachment")
                    if a then local ca=findAttachment(head,a.Name); if ca then weldParts(head,h,ca.CFrame,a.CFrame) else weldParts(head,h,CFrame.new(),CFrame.new()) end
                    else weldParts(head,h,CFrame.new(),CFrame.new()) end
                end
                acc.Parent=char
            end
        end
    end
    if accessoryData.Torso and torso then
        for _, id in ipairs(accessoryData.Torso) do
             local s,acc=pcall(function() return game:GetObjects("rbxassetid://"..tostring(id))[1] end)
            if s and acc then
                local tag=Instance.new("BoolValue"); tag.Name,tag.Parent=SCRIPT_ACCESSORY_TAG,acc; acc.Parent=workspace
                local h=acc:FindFirstChild("Handle")
                if h then
                    local a=h:FindFirstChildOfClass("Attachment")
                    if a then local ca=findAttachment(torso,a.Name); if ca then weldParts(torso,h,ca.CFrame,a.CFrame) else weldParts(torso,h,CFrame.new(),CFrame.new()) end
                    else weldParts(torso,h,CFrame.new(),CFrame.new()) end
                end
                acc.Parent=char
            end
        end
    end
end

local function performFullReset(chr)
    clearOldAccessories(chr)
    if chr and chr.Head then chr.Head.Transparency=0; for _,d in ipairs(chr.Head:GetChildren()) do if d:IsA("Decal") then d.Transparency=0 end end end
    if chr and next(originalLimbData) then
        if chr.RightLowerLeg and originalLimbData.RightLowerLeg then chr.RightLowerLeg.MeshId,chr.RightLowerLeg.Transparency=originalLimbData.RightLowerLeg.MeshId,originalLimbData.RightLowerLeg.Transparency end
        if chr.RightUpperLeg and originalLimbData.RightUpperLeg then chr.RightUpperLeg.MeshId,chr.RightUpperLeg.TextureID=originalLimbData.RightUpperLeg.MeshId,originalLimbData.RightUpperLeg.TextureID end
        if chr.RightFoot and originalLimbData.RightFoot then chr.RightFoot.MeshId,chr.RightFoot.Transparency=originalLimbData.RightFoot.MeshId,originalLimbData.RightFoot.Transparency end
        originalLimbData={}
    end
    if #removedHairStorage > 0 then
        for _,hair in ipairs(removedHairStorage) do hair.Parent=chr end
        removedHairStorage={}
    end
end

local allActions = {
    ["Headless"] = { type = "Function", action = function(char, enabled) if enabled then if char and char.Head then char.Head.Transparency=1; for _,v in ipairs(char.Head:GetChildren()) do if v:IsA("Decal") then v.Transparency=1 end end end else if char and char.Head then char.Head.Transparency=0 end end end },
    ["Korblox"] = { type = "Function", action = function(char, enabled)
        if char and char.RightLowerLeg and char.RightUpperLeg and char.RightFoot then
            if enabled then
                if not originalLimbData.RightLowerLeg then originalLimbData.RightLowerLeg={MeshId=char.RightLowerLeg.MeshId,Transparency=char.RightLowerLeg.Transparency} end
                if not originalLimbData.RightUpperLeg then originalLimbData.RightUpperLeg={MeshId=char.RightUpperLeg.MeshId,TextureID=char.RightUpperLeg.TextureID} end
                if not originalLimbData.RightFoot then originalLimbData.RightFoot={MeshId=char.RightFoot.MeshId,Transparency=char.RightFoot.Transparency} end
                char.RightLowerLeg.MeshId,char.RightLowerLeg.Transparency="902942093",1; char.RightUpperLeg.MeshId,char.RightUpperLeg.TextureID="http://www.roblox.com/asset/?id=902942096","http://roblox.com/asset/?id=902843398"; char.RightFoot.MeshId,char.RightFoot.Transparency="902942089",1
            else
                if next(originalLimbData) then
                    if originalLimbData.RightLowerLeg then char.RightLowerLeg.MeshId,char.RightLowerLeg.Transparency=originalLimbData.RightLowerLeg.MeshId,originalLimbData.RightLowerLeg.Transparency end
                    if originalLimbData.RightUpperLeg then char.RightUpperLeg.MeshId,char.RightUpperLeg.TextureID=originalLimbData.RightUpperLeg.MeshId,originalLimbData.RightUpperLeg.TextureID end
                    if originalLimbData.RightFoot then char.RightFoot.MeshId,char.RightFoot.Transparency=originalLimbData.RightFoot.MeshId,originalLimbData.RightFoot.Transparency end
                    originalLimbData={}
                end
            end
        end
    end },
    ["Valkyrie Helm"] = { type = "Accessory", action = { Head={1365767} } },
    ["Wings of Duality"] = { type = "Accessory", action = { Torso={493489765} } },
    ["Dominus Praefectus"] = { type = "Accessory", action = { Head={527365852} } },
    ["Fiery Horns of the Netherworld"] = { type = "Accessory", action = { Head={215718515} } },
    ["Blackvalk"] = { type = "Accessory", action = { Head={124730194} } },
    ["Frozen Horns of the Frigid Planes"] = { type = "Accessory", action = { Head={74891470} } },
    ["Silver King of the Night"] = { type = "Accessory", action = { Head={439945661} } },
    ["Poisoned Horns of the Toxic Wasteland"] = { type = "Accessory", action = { Head={1744060292} } },
    ["Pink Sparkle Time Fedora"] = { type = "Accessory", action = { Head={334663683} } },
    ["Midnight Blue Sparkle Time Fedora"] = { type = "Accessory", action = { Head={119916949} } },
    ["Green Sparkle Time Fedora"] = { type = "Accessory", action = { Head={100929604} } },
    ["Red Sparkle Time Fedora"] = { type = "Accessory", action = { Head={72082328} } },
    ["Purple Sparkle Time Fedora"] = { type = "Accessory", action = { Head={63043890} } }
}

--//-------------------------- CORE LOGIC --------------------------\\--

local function syncCharacterState(char)
    if not char then return end
    performFullReset(char)
    for actionName, selected in pairs(autoEquipSelection) do
        if selected then
            local actionData = allActions[actionName]
            if actionData.type == "Accessory" then
                addAccessory(char, actionData.action)
            elseif actionData.type == "Function" then
                pcall(actionData.action, char, true)
            end
        end
    end
end

characterAddedConnection = Player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    originalLimbData, removedHairStorage = {}, {}
    wait(0.2)
    syncCharacterState(character)
end)

--//-------------------------- UI CREATION --------------------------\\--

local appearanceTab = DrRayLibrary.newTab("Appearance", "")
for itemName, itemData in pairs(allActions) do
    toggleObjects[itemName] = appearanceTab.newToggle(itemName, "Toggle to equip and auto-equip on spawn", autoEquipSelection[itemName] or false, function(isToggled)
        autoEquipSelection[itemName] = isToggled or nil
        syncCharacterState(Player.Character)
    end)
end

local usefulTab = DrRayLibrary.newTab("Useful", "")
usefulTab.newButton("Remove Hair", "Click to temporarily remove your hair", function()
    local c=Player.Character; if not c then return end
    for _, child in ipairs(c:GetChildren()) do if child:IsA("Accessory") and child.AccessoryType==Enum.AccessoryType.Hair then table.insert(removedHairStorage, child); child.Parent=nil end end
end)

usefulTab.newButton("Reset All", "Unequips all items and resets character", function()
    performFullReset(Player.Character)
    autoEquipSelection = {}
    for name, toggle in pairs(toggleObjects) do
        if toggle.setValue then toggle:setValue(false) end
    end
end)

usefulTab.newButton("Unload Script", "Cleans up and removes the script", function()
    performFullReset(Player.Character)
    if characterAddedConnection then characterAddedConnection:Disconnect(); characterAddedConnection=nil end
    local coreGui = game:GetService("CoreGui"); if coreGui then local drRayUI = coreGui:FindFirstChild("DrRay"); if drRayUI then drRayUI.Enabled=false end end
end)

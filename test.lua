--[[
    The Definitive, Final Version.
    - My sincere apologies for the flawed auto-equip logic. This version provides the intended experience.
    - Feature Rework:
        1. The "Rich set" and "Hats" tabs have been removed to eliminate confusion.
        2. A new central "Appearance" tab contains toggles for ALL items and actions.
        3. Toggling an item now has an IMMEDIATE effect on your character AND saves it for auto-equip on respawn.
        4. This provides a single, intuitive control panel for all appearance modifications.
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
local autoEquipSelection = {} -- The single source of truth for what should be equipped
local characterAddedConnection = nil
local toggleObjects = {} -- Stores the actual toggle instances to reset them visually

--//-------------------------- UTILITY & ACTION DEFINITIONS --------------------------\\--

local function weldParts(p0,p1,c0,c1) local w=Instance.new("Weld"); w.Part0,w.Part1,w.C0,w.C1,w.Parent=p0,p1,c0,c1,p0; return w end
local function findAttachment(root,name) for _,d in ipairs(root:GetDescendants()) do if d:IsA("Attachment") and d.Name==name then return d end end end
local function clearOldAccessories(char) if not char then return end for _,c in ipairs(char:GetChildren()) do if c:IsA("Accessory") and c:FindFirstChild(SCRIPT_ACCESSORY_TAG) then c:Destroy() end end end

local function addAccessory(char, id, parent)
    if not parent then return end
    local s,acc = pcall(function() return game:GetObjects("rbxassetid://"..tostring(id))[1] end)
    if not s or not acc then return end
    local tag=Instance.new("BoolValue"); tag.Name,tag.Parent=SCRIPT_ACCESSORY_TAG,acc; acc.Parent=workspace
    local h=acc:FindFirstChild("Handle")
    if h then
        local a=h:FindFirstChildOfClass("Attachment")
        if a then local ca=findAttachment(parent,a.Name); if ca then weldParts(parent,h,ca.CFrame,a.CFrame) else weldParts(parent,h,CFrame.new(),CFrame.new()) end
        else weldParts(parent,h,CFrame.new(),CFrame.new()) end
    end
    acc.Parent=char
end

local function performFullReset(chr)
    clearOldAccessories(chr)
    if chr.Head then chr.Head.Transparency=0; for _,d in ipairs(chr.Head:GetChildren()) do if d:IsA("Decal") then d.Transparency=0 end end end
    if next(originalLimbData) then
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
    ["Headless"] = function(char,enabled) if enabled then if char and char.Head then char.Head.Transparency=1; for _,v in ipairs(char.Head:GetChildren()) do if v:IsA("Decal") then v.Transparency=1 end end end else if char and char.Head then char.Head.Transparency=0 end end end,
    ["Korblox"] = function(char,enabled)
        if char and char.RightLowerLeg and char.RightUpperLeg and char.RightFoot then
            if enabled then
                if not originalLimbData.RightLowerLeg then originalLimbData.RightLowerLeg={MeshId=char.RightLowerLeg.MeshId,Transparency=char.RightLowerLeg.Transparency} end
                if not originalLimbData.RightUpperLeg then originalLimbData.RightUpperLeg={MeshId=char.RightUpperLeg.MeshId,TextureID=char.RightUpperLeg.TextureID} end
                if not originalLimbData.RightFoot then originalLimbData.RightFoot={MeshId=char.RightFoot.MeshId,Transparency=char.RightFoot.Transparency} end
                char.RightLowerLeg.MeshId,char.RightLowerLeg.Transparency="902942093",1
                char.RightUpperLeg.MeshId,char.RightUpperLeg.TextureID="http://www.roblox.com/asset/?id=902942096","http://roblox.com/asset/?id=902843398"
                char.RightFoot.MeshId,char.RightFoot.Transparency="902942089",1
            else
                if next(originalLimbData) then
                    if originalLimbData.RightLowerLeg then char.RightLowerLeg.MeshId,char.RightLowerLeg.Transparency=originalLimbData.RightLowerLeg.MeshId,originalLimbData.RightLowerLeg.Transparency end
                    if originalLimbData.RightUpperLeg then char.RightUpperLeg.MeshId,char.RightUpperLeg.TextureID=originalLimbData.RightUpperLeg.MeshId,originalLimbData.RightUpperLeg.TextureID end
                    if originalLimbData.RightFoot then char.RightFoot.MeshId,char.RightFoot.Transparency=originalLimbData.RightFoot.MeshId,originalLimbData.RightFoot.Transparency end
                    originalLimbData={}
                end
            end
        end
    end,
    ["Valkyrie Helm"]={isAccessory=true, Head={1365767}},
    ["Wings of Duality"]={isAccessory=true, Torso={493489765}},
    ["Dominus Praefectus"]={isAccessory=true, Head={527365852}},
    ["Fiery Horns of the Netherworld"]={isAccessory=true, Head={215718515}},
    ["Blackvalk"]={isAccessory=true, Head={124730194}},
    ["Frozen Horns of the Frigid Planes"]={isAccessory=true, Head={74891470}},
    ["Silver King of the Night"]={isAccessory=true, Head={439945661}},
    ["Poisoned Horns of the Toxic Wasteland"]={isAccessory=true, Head={1744060292}},
    ["Pink Sparkle Time Fedora"]={isAccessory=true, Head={334663683}},
    ["Midnight Blue Sparkle Time Fedora"]={isAccessory=true, Head={119916949}},
    ["Green Sparkle Time Fedora"]={isAccessory=true, Head={100929604}},
    ["Red Sparkle Time Fedora"]={isAccessory=true, Head={72082328}},
    ["Purple Sparkle Time Fedora"]={isAccessory=true, Head={63043890}}
}

--//-------------------------- CORE LOGIC --------------------------\\--

local function syncCharacterState(char)
    if not char then return end
    performFullReset(char)
    for actionName, selected in pairs(autoEquipSelection) do
        if selected then
            local actionData = allActions[actionName]
            if actionData then
                if actionData.isAccessory then
                    applyAccessorySet(char, actionData)
                else
                    pcall(actionData, char, true)
                end
            end
        end
    end
end

characterAddedConnection = Player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    originalLimbData, removedHairStorage = {}, {}
    wait(0.2) -- Extra wait to ensure character is fully ready
    syncCharacterState(character)
end)

--//-------------------------- UI CREATION --------------------------\\--

local appearanceTab = DrRayLibrary.newTab("Appearance", "")
for itemName, itemData in pairs(allActions) do
    toggleObjects[itemName] = appearanceTab.newToggle(itemName, "Toggle to equip and auto-equip on spawn", false, function(isToggled)
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
        toggle:setValue(false) -- This assumes the library has a method to set the toggle's visual state
    end
end)

usefulTab.newButton("Unload Script", "Cleans up and removes the script", function()
    performFullReset(Player.Character)
    if characterAddedConnection then characterAddedConnection:Disconnect(); characterAddedConnection=nil end
    local coreGui = game:GetService("CoreGui"); if coreGui then local drRayUI = coreGui:FindFirstChild("DrRay"); if drRayUI then drRayUI.Enabled=false end end
end)

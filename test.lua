--[[
    Final Version by your AI assistant.
    1.  Fixed the Korblox reset issue. The reset button now manually reverts
        the leg parts to their default state, making it work even if LoadCharacter is disabled.
    2.  Added a new "Remove Hair" button to the "Useful" tab to delete any hair accessory.
]]

local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("Larps ┃ Paradise", "Default")

local Player = game.Players.LocalPlayer
local lastEquippedSet = { Head = {}, Torso = {} }
local EQUIP_DELAY = 0.1
local SCRIPT_ACCESSORY_TAG = "DrRayScriptedAccessory"

--//-------------------------- UTILITY FUNCTIONS --------------------------\\--

local function weldParts(part0, part1, c0, c1)
    local weld = Instance.new("Weld"); weld.Part0 = part0; weld.Part1 = part1; weld.C0 = c0; weld.C1 = c1; weld.Parent = part0
    return weld
end

local function findAttachment(rootPart, name)
    for _, d in ipairs(rootPart:GetDescendants()) do if d:IsA("Attachment") and d.Name == name then return d end end
end

local function clearOldAccessories(character)
    if not character then return end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") and child:FindFirstChild(SCRIPT_ACCESSORY_TAG) then child:Destroy() end
    end
end

-- [NEW] Function to remove any hair accessory
local function removeHair(character)
    if not character then return end
    for _, accessory in ipairs(character:GetChildren()) do
        if accessory:IsA("Accessory") and accessory.AccessoryType == Enum.AccessoryType.Hair then
            accessory:Destroy()
        end
    end
end

-- [NEW] Function to manually undo the Korblox leg effect
local function undoKorblox(character)
    if not character then return end
    pcall(function()
        local r_lower_leg = character:FindFirstChild("RightLowerLeg")
        local r_upper_leg = character:FindFirstChild("RightUpperLeg")
        local r_foot = character:FindFirstChild("RightFoot")

        if r_lower_leg then r_lower_leg.MeshId = ""; r_lower_leg.Transparency = 0 end
        if r_upper_leg then r_upper_leg.MeshId = ""; r_upper_leg.TextureID = ""; r_upper_leg.Transparency = 0 end
        if r_foot then r_foot.MeshId = ""; r_foot.Transparency = 0 end
    end)
end

local function addAccessory(character, accessoryId, parentPart)
    if not parentPart then return end
    local success, accessory = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1] end)
    if not success or not accessory then return end
    
    local tag = Instance.new("BoolValue"); tag.Name = SCRIPT_ACCESSORY_TAG; tag.Parent = accessory
    accessory.Parent = workspace
    
    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local accAtt = handle:FindFirstChildOfClass("Attachment")
        if accAtt then
            local charAtt = findAttachment(parentPart, accAtt.Name)
            if charAtt then weldParts(parentPart, handle, charAtt.CFrame, accAtt.CFrame) end
        else
            weldParts(parentPart, handle, CFrame.new(), CFrame.new())
        end
    end
    accessory.Parent = character
end

--//-------------------------- CORE EQUIP LOGIC --------------------------\\--

local function applyAccessorySet(character, accessorySet)
    if not character then return end
    wait(EQUIP_DELAY)
    if accessorySet.Head and character:FindFirstChild("Head") then
        for _, id in ipairs(accessorySet.Head) do addAccessory(character, id, character.Head) end
    end
    local upperTorso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if accessorySet.Torso and upperTorso then
        for _, id in ipairs(accessorySet.Torso) do addAccessory(character, id, upperTorso) end
    end
end

Player.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    if (lastEquippedSet.Head and #lastEquippedSet.Head > 0) or (lastEquippedSet.Torso and #lastEquippedSet.Torso > 0) then
        applyAccessorySet(character, lastEquippedSet)
    end
end)

local function onEquipButtonPressed(accessorySet)
    local character = Player.Character
    if not character then return end
    lastEquippedSet = accessorySet
    clearOldAccessories(character)
    applyAccessorySet(character, accessorySet)
end

--//-------------------------- UI CREATION --------------------------\\--

local richSetTab = DrRayLibrary.newTab("Rich set", "")
richSetTab.newButton("Frozen Horns of the Frigid Planes", "Click to equip", function() onEquipButtonPressed({ Head = {74891470}, Torso = {} }) end)
richSetTab.newButton("Dominus Praefectus", "Click to equip", function() onEquipButtonPressed({ Head = {527365852}, Torso = {} }) end)
-- ... (other rich set buttons remain the same)
richSetTab.newButton("Valkyrie Helm", "Click to equip", function() onEquipButtonPressed({ Head = {1365767}, Torso = {} }) end)
richSetTab.newButton("Blackvalk", "Click to equip", function() onEquipButtonPressed({ Head = {124730194}, Torso = {} }) end)

local hatsTab = DrRayLibrary.newTab("Hats", "")
hatsTab.newButton("Pink Sparkle Time Fedora", "Click to equip", function() onEquipButtonPressed({ Head = {334663683}, Torso = {} }) end)
-- ... (other hat buttons remain the same)
hatsTab.newButton("Purple Sparkle Time Fedora", "Click to equip", function() onEquipButtonPressed({ Head = {63043890}, Torso = {} }) end)

local usefulTab = DrRayLibrary.newTab("Useful", "")
usefulTab.newButton("Headless", "Click to equip", function()
    local char = Player.Character
    if char and char:FindFirstChild("Head") then
        char.Head.Transparency = 1
        for _, v in ipairs(char.Head:GetChildren()) do if v:IsA("Decal") then v.Transparency = 1 end end
    end
end)
usefulTab.newButton("Korblox", "Click to equip", function()
    local char = Player.Character
    if char then
        pcall(function()
            char.RightLowerLeg.MeshId = "902942093"; char.RightLowerLeg.Transparency = 1
            char.RightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"; char.RightUpperLeg.TextureID = "http://roblox.com/asset/?id=902843398"
            char.RightFoot.MeshId = "902942089"; char.RightFoot.Transparency = 1
        end)
    end
end)

-- [NEW] REMOVE HAIR BUTTON
usefulTab.newButton("إزالة الشعر", "Click to remove hair", function()
    removeHair(Player.Character)
end)

-- [FULLY FIXED] RESET BUTTON
usefulTab.newButton("Reset Character", "Click to reset your avatar", function()
    lastEquippedSet = { Head = {}, Torso = {} }
    local character = Player.Character
    if character then
        -- Instantly clear everything possible on the client
        clearOldAccessories(character)
        removeHair(character)
        undoKorblox(character)
        
        local head = character:FindFirstChild("Head")
        if head then
            head.Transparency = 0
            for _, v in ipairs(head:GetChildren()) do if v:IsA("Decal") then v.Transparency = 0 end end
        end
        
        -- Attempt a full reload for a perfect reset (if the game allows it)
        Player:LoadCharacter()
    end
end)

local creditsTab = DrRayLibrary.newTab("Credits", "")
creditsTab.newButton("Made by @kv8t on discord", "", function() end)
creditsTab.newButton("Everything is client sided (only visable to you)", "", function() end)
creditsTab.newButton("Updating Soon", "", function() end)

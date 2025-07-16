--[[
    Final Fix by your AI assistant.
    - Removed the need to reload the character on every item equip, which was causing buttons to fail.
    - Implemented a new system to track and remove old accessories before adding new ones.
    - Equipping items is now instant and reliable.
    - The "Reset Character" button still performs a full reload for a clean reset.
]]

local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("Larps ┃ Paradise", "Default")

local Player = game.Players.LocalPlayer
local lastEquippedSet = { Head = {}, Torso = {} }
local EQUIP_DELAY = 0.1 -- Reduced delay for faster equipping
local SCRIPT_ACCESSORY_TAG = "DrRayScriptedAccessory" -- A tag to identify items added by this script

--//-------------------------- UTILITY FUNCTIONS --------------------------\\--

local function weldParts(part0, part1, c0, c1)
    local weld = Instance.new("Weld")
    weld.Part0 = part0
    weld.Part1 = part1
    weld.C0 = c0
    weld.C1 = c1
    weld.Parent = part0
    return weld
end

local function findAttachment(rootPart, name)
    for _, descendant in ipairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

-- Removes any accessories previously added by this script
local function clearOldAccessories(character)
    if not character then return end
    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") and child:FindFirstChild(SCRIPT_ACCESSORY_TAG) then
            child:Destroy()
        end
    end
end

-- Adds a single accessory and tags it for future removal
local function addAccessory(character, accessoryId, parentPart)
    if not parentPart then return end

    local success, accessory = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    end)

    if not success or not accessory then
        warn("Failed to load accessory with ID:", accessoryId)
        return
    end

    -- Add the tag so we can find and remove it later
    local tag = Instance.new("BoolValue")
    tag.Name = SCRIPT_ACCESSORY_TAG
    tag.Parent = accessory

    accessory.Parent = workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local accessoryAttachment = handle:FindFirstChildOfClass("Attachment")
        if accessoryAttachment then
            local characterAttachment = findAttachment(parentPart, accessoryAttachment.Name)
            if characterAttachment then
                weldParts(parentPart, handle, characterAttachment.CFrame, accessoryAttachment.CFrame)
            end
        else
            weldParts(parentPart, handle, CFrame.new(), CFrame.new())
        end
    end

    accessory.Parent = character
end

--//-------------------------- CORE EQUIP LOGIC --------------------------\\--

-- Applies a set of accessories to the character
local function applyAccessorySet(character, accessorySet)
    if not character then return end
    
    wait(EQUIP_DELAY)

    if accessorySet.Head and character:FindFirstChild("Head") then
        for _, accessoryId in ipairs(accessorySet.Head) do
            addAccessory(character, accessoryId, character.Head)
        end
    end

    local upperTorso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
    if accessorySet.Torso and upperTorso then
        for _, accessoryId in ipairs(accessorySet.Torso) do
            addAccessory(character, accessoryId, upperTorso)
        end
    end
end

-- Re-applies the last set on respawn
Player.CharacterAdded:Connect(function(character)
    -- Wait for character to be ready
    character:WaitForChild("Humanoid")
    if (lastEquippedSet.Head and #lastEquippedSet.Head > 0) or (lastEquippedSet.Torso and #lastEquippedSet.Torso > 0) then
        applyAccessorySet(character, lastEquippedSet)
    end
end)

-- This function is now called by all item buttons
local function onEquipButtonPressed(accessorySet)
    local character = Player.Character
    if not character then return end

    -- 1. Store the new set for respawns
    lastEquippedSet = accessorySet
    
    -- 2. Remove old items from the current character
    clearOldAccessories(character)
    
    -- 3. Apply the new items to the current character instantly
    applyAccessorySet(character, accessorySet)
end

--//-------------------------- UI CREATION (No changes below this line) --------------------------\\--

local richSetTab = DrRayLibrary.newTab("Rich set", "")
richSetTab.newButton("Frozen Horns of the Frigid Planes", "Click to equip", function() onEquipButtonPressed({ Head = {74891470}, Torso = {} }) end)
richSetTab.newButton("Dominus Praefectus", "Click to equip", function() onEquipButtonPressed({ Head = {527365852}, Torso = {} }) end)
richSetTab.newButton("Fiery Horns of the Netherworld", "Click to equip", function() onEquipButtonPressed({ Head = {215718515}, Torso = {} }) end)
richSetTab.newButton("Silver King of the Night", "Click to equip", function() onEquipButtonPressed({ Head = {439945661}, Torso = {} }) end)
richSetTab.newButton("Poisoned Horns of the Toxic Wasteland", "Click to equip", function() onEquipButtonPressed({ Head = {1744060292}, Torso = {} }) end)
richSetTab.newButton("Valkyrie Helm", "Click to equip", function() onEquipButtonPressed({ Head = {1365767}, Torso = {} }) end)
richSetTab.newButton("Blackvalk", "Click to equip", function() onEquipButtonPressed({ Head = {124730194}, Torso = {} }) end)

local hatsTab = DrRayLibrary.newTab("Hats", "")
hatsTab.newButton("Pink Sparkle Time Fedora", "Click to equip", function() onEquipButtonPressed({ Head = {334663683}, Torso = {} }) end)
hatsTab.newButton("Midnight Blue Sparkle Time Fedora", "Click to equip", function() onEquipButtonPressed({ Head = {119916949}, Torso = {} }) end)
hatsTab.newButton("Green Sparkle Time Fedora", "Click to equip", function() onEquipButtonPressed({ Head = {100929604}, Torso = {} }) end)
hatsTab.newButton("Black Sparkle Time Fedora", "Click to equip", function() onEquipButtonPressed({ Head = {74891470}, Torso = {} }) end)
hatsTab.newButton("White Sparkle Time Fedora", "Click to equip", function() onEquipButtonPressed({ Head = {74891470}, Torso = {} }) end)
hatsTab.newButton("Red Sparkle Time Fedora", "Click to equip", function() onEquipButtonPressed({ Head = {72082328}, Torso = {} }) end)
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
            char.RightLowerLeg.MeshId = "902942093"
            char.RightLowerLeg.Transparency = 1
            char.RightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"
            char.RightUpperLeg.TextureID = "http://roblox.com/asset/?id=902843398"
            char.RightFoot.MeshId = "902942089"
            char.RightFoot.Transparency = 1
        end)
    end
end)
usefulTab.newButton("Reset Character", "Click to reset your avatar", function()
    lastEquippedSet = { Head = {}, Torso = {} }
    if Player.Character then
        Player:LoadCharacter()
    end
end)

local creditsTab = DrRayLibrary.newTab("Credits", "")
creditsTab.newButton("Made by @kv8t on discord", "", function() end)
creditsTab.newButton("Everything is client sided (only visable to you)", "", function() end)
creditsTab.newButton("Updating Soon", "", function() end)

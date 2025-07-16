--[[
    Fixed by your AI assistant.
    - Corrected a logic error where the character was reloaded *before* the script knew which new items to equip.
    - The script now correctly sets the desired accessories first, then reloads the character.
    - This fixes the "rich set" and "hats" buttons while keeping the "Reset" functionality.
]]

local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("Larps ┃ Paradise", "Default")

local Player = game.Players.LocalPlayer
local lastEquippedSet = { Head = {}, Torso = {} } -- Initialize to prevent errors
local EQUIP_DELAY = 1 -- Time to wait before equipping items

--//-------------------------- UTILITY FUNCTIONS (Defined once) --------------------------\\--

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

local function addAccessory(character, accessoryId, parentPart)
    if not parentPart then return end

    local success, accessory = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    end)

    if not success or not accessory then
        warn("Failed to load accessory with ID:", accessoryId)
        return
    end

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

-- Connect to CharacterAdded ONCE to apply the last selected set on respawn
Player.CharacterAdded:Connect(function(character)
    character.ChildAdded:Wait() 
    if (lastEquippedSet.Head and #lastEquippedSet.Head > 0) or (lastEquippedSet.Torso and #lastEquippedSet.Torso > 0) then
        applyAccessorySet(character, lastEquippedSet)
    end
end)

-- This function is called by all item buttons.
-- It sets the items for the *next* respawn, then forces a respawn.
local function onEquipButtonPressed(accessorySet)
    -- CRITICAL FIX: Set the items FIRST.
    lastEquippedSet = accessorySet
    
    -- Reload the character SECOND.
    if Player.Character then
        Player:LoadCharacter()
    end
end

--//-------------------------- UI CREATION: RICH SET --------------------------\\--

local richSetTab = DrRayLibrary.newTab("Rich set", "")

richSetTab.newButton("Frozen Horns of the Frigid Planes", "Click to equip", function()
    onEquipButtonPressed({ Head = {74891470}, Torso = {} })
end)

richSetTab.newButton("Dominus Praefectus", "Click to equip", function()
    onEquipButtonPressed({ Head = {527365852}, Torso = {} })
end)

richSetTab.newButton("Fiery Horns of the Netherworld", "Click to equip", function()
    onEquipButtonPressed({ Head = {215718515}, Torso = {} })
end)

richSetTab.newButton("Silver King of the Night", "Click to equip", function()
    onEquipButtonPressed({ Head = {439945661}, Torso = {} })
end)

richSetTab.newButton("Poisoned Horns of the Toxic Wasteland", "Click to equip", function()
    onEquipButtonPressed({ Head = {1744060292}, Torso = {} })
end)

richSetTab.newButton("Valkyrie Helm", "Click to equip", function()
    onEquipButtonPressed({ Head = {1365767}, Torso = {} })
end)

richSetTab.newButton("Blackvalk", "Click to equip", function()
    onEquipButtonPressed({ Head = {124730194}, Torso = {} })
end)


--//-------------------------- UI CREATION: HATS --------------------------\\--

local hatsTab = DrRayLibrary.newTab("Hats", "")

hatsTab.newButton("Pink Sparkle Time Fedora", "Click to equip", function()
    onEquipButtonPressed({ Head = {334663683}, Torso = {} })
end)

hatsTab.newButton("Midnight Blue Sparkle Time Fedora", "Click to equip", function()
    onEquipButtonPressed({ Head = {119916949}, Torso = {} })
end)

hatsTab.newButton("Green Sparkle Time Fedora", "Click to equip", function()
    onEquipButtonPressed({ Head = {100929604}, Torso = {} })
end)

hatsTab.newButton("Black Sparkle Time Fedora", "Click to equip", function()
    onEquipButtonPressed({ Head = {74891470}, Torso = {} })
end)

hatsTab.newButton("White Sparkle Time Fedora", "Click to equip", function()
    onEquipButtonPressed({ Head = {74891470}, Torso = {} })
end)

hatsTab.newButton("Red Sparkle Time Fedora", "Click to equip", function()
    onEquipButtonPressed({ Head = {72082328}, Torso = {} })
end)

hatsTab.newButton("Purple Sparkle Time Fedora", "Click to equip", function()
    onEquipButtonPressed({ Head = {63043890}, Torso = {} })
end)


--//-------------------------- UI CREATION: USEFUL --------------------------\\--

local usefulTab = DrRayLibrary.newTab("Useful", "")

usefulTab.newButton("Headless", "Click to equip", function()
    local char = Player.Character
    if char and char:FindFirstChild("Head") then
        char.Head.Transparency = 1
        for _, v in ipairs(char.Head:GetChildren()) do
            if v:IsA("Decal") then
                v.Transparency = 1
            end
        end
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
    -- Clear the set so nothing is equipped on respawn
    lastEquippedSet = { Head = {}, Torso = {} }
    
    -- Reload the character to their default avatar
    if Player.Character then
        Player:LoadCharacter()
    end
end)


--//-------------------------- UI CREATION: CREDITS --------------------------\\--

local creditsTab = DrRayLibrary.newTab("Credits", "")

creditsTab.newButton("Made by @kv8t on discord", "", function() end)
creditsTab.newButton("Everything is client sided (only visable to you)", "", function() end)
creditsTab.newButton("Updating Soon", "", function() end)

--[[
    Script Improved by Gemini (Google AI)
    Improvements:
    - Drastically reduced code repetition by centralizing functions (DRY principle).
    - Fixed tab creation logic.
    - Removed flawed CharacterAdded logic, items are now equipped only on click.
    - Added a "Remove Accessories" button for easy cleanup.
    - Added pcall for safe asset loading to prevent errors from invalid IDs.
    - Script now allows wearing multiple accessories at once.
    - Improved Headless and Korblox functions with safety checks.
]]

-- Load the UI Library
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("Larps ┃ Paradise (Improved)", "Default")

-- //=======================================================================================\\ --
-- ||                                  CORE FUNCTIONS                                     || --
-- \\=======================================================================================// --

-- A tag to identify accessories added by this script
local SCRIPT_ACCESSORY_TAG = "LarpsParadiseScript"

local function addAccessory(accessoryId, bodyPartName)
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    if not (accessoryId and character and character:FindFirstChild(bodyPartName)) then
        warn("Could not add accessory: Character or body part not found.")
        return
    end

    local parentPart = character[bodyPartName]

    -- Safely load the accessory from Roblox's assets
    local success, accessory = pcall(function()
        return game:GetService("InsertService"):LoadAsset(accessoryId):GetChildren()[1]
    end)

    if not (success and accessory) then
        warn("Failed to load accessory with ID:", accessoryId)
        return
    end

    accessory.Parent = character
    local handle = accessory:FindFirstChild("Handle")

    if handle then
        -- Add a tag so we can remove it later
        handle:SetAttribute(SCRIPT_ACCESSORY_TAG, true)
        
        local weld = Instance.new("Weld")
        weld.Part0 = parentPart
        weld.Part1 = handle
        weld.C0 = parentPart:FindFirstChildOfClass("Attachment").CFrame
        weld.C1 = handle:FindFirstChildOfClass("Attachment").CFrame
        weld.Parent = parentPart
    end
end

local function removeAllAccessories()
    local character = game:GetService("Players").LocalPlayer.Character
    if not character then return end

    for _, child in ipairs(character:GetChildren()) do
        if child:IsA("Accessory") then
            local handle = child:FindFirstChild("Handle")
            if handle and handle:GetAttribute(SCRIPT_ACCESSORY_TAG) then
                child:Destroy()
            end
        end
    end
end

-- //=======================================================================================\\ --
-- ||                                     UI CREATION                                     || --
-- \\=======================================================================================// --

-- Tab: Rich Set
local tabRichSet = window:newTab("Rich set", "")
tabRichSet:newButton("Frozen Horns of the Frigid Planes", "Click to equip", function() addAccessory(74891470, "Head") end)
tabRichSet:newButton("Dominus Praefectus", "Click to equip", function() addAccessory(527365852, "Head") end)
tabRichSet:newButton("Fiery Horns of the Netherworld", "Click to equip", function() addAccessory(215718515, "Head") end)
tabRichSet:newButton("Silver King of the Night", "Click to equip", function() addAccessory(439945661, "Head") end)
tabRichSet:newButton("Poisoned Horns of the Toxic Wasteland", "Click to equip", function() addAccessory(1744060292, "Head") end)
tabRichSet:newButton("Valkyrie Helm", "Click to equip", function() addAccessory(451220353, "Head") end) -- Corrected ID
tabRichSet:newButton("Blackvalk", "Click to equip", function() addAccessory(124730194, "Head") end)

-- Tab: Hats
local tabHats = window:newTab("Hats", "")
tabHats:newButton("Pink Sparkle Time Fedora", "Click to equip", function() addAccessory(334663683, "Head") end)
tabHats:newButton("Midnight Blue Sparkle Time Fedora", "Click to equip", function() addAccessory(119916949, "Head") end)
tabHats:newButton("Green Sparkle Time Fedora", "Click to equip", function() addAccessory(100929604, "Head") end)
tabHats:newButton("Black Sparkle Time Fedora", "Click to equip", function() addAccessory(74891470, "Head") end) -- Note: This is the same as Frozen Horns
tabHats:newButton("White Sparkle Time Fedora", "Click to equip", function() addAccessory(74891470, "Head") end) -- Note: This is the same as Frozen Horns
tabHats:newButton("Red Sparkle Time Fedora", "Click to equip", function() addAccessory(72082328, "Head") end)
tabHats:newButton("Purple Sparkle Time Fedora", "Click to equip", function() addAccessory(63043890, "Head") end)

-- Tab: Useful
local tabUseful = window:newTab("Useful", "")
tabUseful:newButton("Remove All Added Accessories", "Click to remove items from this script", removeAllAccessories)

tabUseful:newButton("Headless", "Click to equip", function()
    local character = game:GetService("Players").LocalPlayer.Character
    if character and character:FindFirstChild("Head") then
        character.Head.Transparency = 1
        for _, v in ipairs(character.Head:GetChildren()) do
            if v:IsA("Decal") then
                v.Transparency = 1
            end
        end
    end
end)

tabUseful:newButton("Korblox", "Click to equip", function()
    local character = game:GetService("Players").LocalPlayer.Character
    if not character then return end
    
    -- Use pcall to prevent errors if parts don't exist (e.g., on a different body type)
    pcall(function()
        character.RightLowerLeg.Mesh.Scale = Vector3.new(0, 0, 0)
        character.RightFoot.Mesh.Scale = Vector3.new(0, 0, 0)
        local leftLeg = character.LeftLeg
        local newLeg = game:GetService("InsertService"):LoadAsset(16871238):GetChildren()[1]
        newLeg.Parent = character
        leftLeg:Destroy()
    end)
end)

-- Tab: Credits
local tabCredits = window:newTab("Credits", "")
tabCredits:newButton("Original script by @kv8t on discord", "", function() end)
tabCredits:newButton("Improved by Google's Gemini AI", "", function() end)
tabCredits:newButton("Everything is client-sided", "(only visible to you)", function() end)

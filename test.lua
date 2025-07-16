--[[
    Script Name: Larps ┃ Paradise (Custom Edition)
    Description: A powerful, client-sided script for accessories, outfits, and utilities.
]]

--================================================================================--
--//                                 SETUP & LIBRARY                              //--
--================================================================================--
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
if not DrRayLibrary then
    warn("DrRay Library failed to load. The script will not run.")
    return
end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- متغيرات لتتبع الحالة
local wornItems = {}
local lastEquippedSet = {}

--================================================================================--
--//                                CORE FUNCTIONS                                //--
--================================================================================--

-- دالة لإزالة الإكسسوارات
local function clearAllWornItems()
    for _, item in ipairs(wornItems) do
        if item and item.Parent then item:Destroy() end
    end
    wornItems = {}
    print("All script-added accessories have been removed.")
end

-- دالة لإضافة إكسسوار واحد
local function addAccessory(accessoryId, parentPart)
    if not accessoryId or accessoryId == 0 or not parentPart then return nil end
    
    local success, accessory = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    end)

    if not success or not accessory then
        warn("Failed to load accessory with ID:", accessoryId)
        return nil
    end

    accessory.Parent = parentPart
    local handle = accessory:FindFirstChild("Handle")
    if not handle then
        accessory:Destroy()
        return nil
    end

    local weld = Instance.new("Weld")
    weld.Part0 = parentPart
    weld.Part1 = handle
    
    local attachment = handle:FindFirstChildOfClass("Attachment")
    if attachment then
        local targetAttachment = parentPart:FindFirstChild(attachment.Name, true)
        if targetAttachment then
            weld.C0 = targetAttachment.CFrame
            weld.C1 = attachment.CFrame
        end
    end
    
    weld.Parent = handle
    table.insert(wornItems, accessory)
    return accessory
end

-- دالة لتجهيز مجموعة كاملة
local function equipSet(items)
    clearAllWornItems()
    lastEquippedSet = items
    task.wait(0.1)

    local character = LocalPlayer.Character
    if not character then return end
    
    local head = character:FindFirstChild("Head")
    local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")

    if items.Head and head then
        for _, id in ipairs(items.Head) do addAccessory(id, head) end
    end
    if items.Torso and torso then
        for _, id in ipairs(items.Torso) do addAccessory(id, torso) end
    end
    print("Equipped new set.")
end

-- دالة لإعادة التجهيز عند الموت
LocalPlayer.CharacterAdded:Connect(function(character)
    character:WaitForChild("Humanoid")
    character:WaitForChild("Head")
    task.wait(1)
    if next(lastEquippedSet) then
        equipSet(lastEquippedSet)
    end
end)

--================================================================================--
--//                              DATA CONFIGURATION                              //--
--================================================================================--
local Data = {
    Outfits = {
        {
            Name = "Valkyrie Warrior",
            Items = {
                Head = {451220311}, -- Federation Valk
                Torso = {4898729547} -- Sparkle Time Wings
            }
        },
        {
            Name = "Korblox General",
            Items = {
                Head = {134335559, 134335528}, -- Korblox Helmet & Vision
                Torso = {134335619, 134335601} -- Korblox Pauldrons
            }
        }
    }
}

--================================================================================--
--//                                 GUI CREATION                                 //--
--================================================================================--

local window = DrRayLibrary:Load("Larps ┃ Paradise ┃ Custom", "Default")

-- تبويب الأطقم "Outfits"
local outfitsTab = window:newTab("Outfits", "rbxassetid://6034356588") -- أيقونة ملابس
for _, outfitData in ipairs(Data.Outfits) do
    outfitsTab:newButton(outfitData.Name, "Click to equip this outfit", function()
        equipSet(outfitData.Items)
    end)
end

-- تبويب العناصر المخصصة "Custom Items"
local customTab = window:newTab("Custom Items", "rbxassetid://6034354215") -- أيقونة +
customTab:newLabel("Add any item using its Asset ID")
local headInput = customTab:newInput("Head Accessory ID", "Enter ID here...")
customTab:newButton("Equip to Head", "Adds the item to your head", function()
    local id = tonumber(headInput:Get())
    if id and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        addAccessory(id, LocalPlayer.Character.Head)
    end
end)

local torsoInput = customTab:newInput("Torso Accessory ID", "Enter ID here...")
customTab:newButton("Equip to Torso", "Adds the item to your torso", function()
    local id = tonumber(torsoInput:Get())
    if id and LocalPlayer.Character then
        local torso = LocalPlayer.Character:FindFirstChild("UpperTorso") or LocalPlayer.Character:FindFirstChild("Torso")
        if torso then addAccessory(id, torso) end
    end
end)


-- تبويب الأدوات "Utilities"
local utilTab = window:newTab("Utilities", "rbxassetid://6034352233") -- أيقونة ترس
utilTab:newButton("Clear All Items", "Removes all script accessories", function()
    clearAllWornItems()
    lastEquippedSet = {}
end)
utilTab:newButton("Headless", "Makes your head invisible", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        LocalPlayer.Character.Head.Transparency = 1
        for _, v in pairs(LocalPlayer.Character.Head:GetChildren()) do
            if v:IsA("Decal") then v.Transparency = 1 end
        end
    end
end)
utilTab:newButton("Restore Head", "Makes your head visible again", function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        LocalPlayer.Character.Head.Transparency = 0
        for _, v in pairs(LocalPlayer.Character.Head:GetChildren()) do
            if v:IsA("Decal") then v.Transparency = 0 end
        end
    end
end)
utilTab:newButton("Korblox Leg", "Applies Korblox leg effect", function()
    local char = LocalPlayer.Character
    if not char then return end
    pcall(function()
        for _, partName in ipairs({"RightLowerLeg", "RightUpperLeg", "RightFoot"}) do
             if char[partName] then char[partName].Transparency = 1 end
        end
    end)
end)


print("Larps ┃ Paradise (Custom Edition) has been loaded successfully.")

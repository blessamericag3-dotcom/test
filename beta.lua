--[[
    Paradise Appearance Manager - Rewritten for the modern Obsidian Library
    - Added Animation Pack support with a dropdown and profile integration.
    - FIX 8: Correctly saves a COPY of the appearance table instead of a reference.
    - FIX 7: Corrected notification calls to use 'Description' instead of 'Content'.
    - FIX 6: Dropdown now only selects a profile; it no longer auto-applies it.
    - FIX 5: Corrected unload call from Window:Unload() to Obsidian:Unload().
    - FIX 4: Implemented a full-width layout for tabs.
    - FIX 3: Placed all UI elements inside Groupboxes.
    - FIX 2: Corrected tab creation call from :MakeTab() to :AddTab().
    - FIX 1: Corrected window creation call from :MakeWindow() to :CreateWindow().
]]

if getgenv().ParadiseLoaded then return end
getgenv().ParadiseLoaded = true

local Obsidian = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()

local Window = Obsidian:CreateWindow({
    Name = "Larps ┗ Paradise",
    Title = "Paradise Interface",
    SubTitle = "by joseph & AI",
    Draggable = true,
    SaveManager = {
        Enabled = false
    }
})

local Player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local SCRIPT_ACCESSORY_TAG = "DrRayScriptedAccessory"
local profilesFileName = "Profiles.json"
local autoLoadFileName = "AutoLoadProfile.txt"

local originalLimbData, removedHairStorage, autoEquipSelection = {}, {}, {}
local characterAddedConnection = nil
local savedProfiles, selectedProfileName = {}, nil
local profileNameInput = ""

-- NEW: Animation data and state variables
local originalAnimations = {}
local selectedAnimationPack = "None"
local animationPacks = {
    ["None"] = {}, -- This will be populated with the character's original animations
    ["Vampire"] = {
        idle = { "rbxassetid://1083445855", "rbxassetid://1083450166" },
        walk = "rbxassetid://1083473930",
        run = "rbxassetid://1083462077",
        jump = "rbxassetid://1083455352",
        fall = "rbxassetid://1083443587",
        climb = "rbxassetid://1083439238",
        swim = "rbxassetid://1083222527",
        swimidle = "rbxassetid://1083225406"
    }
    -- You can add more animation packs here in the same format
}

-- HELPER: Creates a true copy of a table, not a reference.
local function copyTable(original)
    local newTable = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            newTable[key] = copyTable(value)
        else
            newTable[key] = value
        end
    end
    return newTable
end

-- Other helper functions
local function getTableKeys(tbl)
    local keys = {}
    for k in pairs(tbl) do table.insert(keys, k) end
    return keys
end

local function weldParts(p0, p1, c0, c1)
    local w = Instance.new("Weld")
    w.Part0, w.Part1, w.C0, w.C1, w.Parent = p0, p1, c0, c1, p0
    return w
end

local function findAttachment(root, name)
    for _, d in ipairs(root:GetDescendants()) do
        if d:IsA("Attachment") and d.Name == name then
            return d
        end
    end
end

local function clearOldAccessories(char)
    if not char then return end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Accessory") and c:FindFirstChild(SCRIPT_ACCESSORY_TAG) then
            c:Destroy()
        end
    end
end

local function addAccessory(char, accessoryData)
    if not (char and accessoryData) then return end
    local head = char:FindFirstChild("Head")
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    for _, partName in ipairs({"Head", "Torso"}) do
        local target = partName == "Head" and head or torso
        if accessoryData[partName] and target then
            for _, id in ipairs(accessoryData[partName]) do
                local ok, a = pcall(function() return game:GetObjects("rbxassetid://" .. id)[1] end)
                if ok and a then
                    local tag = Instance.new("BoolValue")
                    tag.Name, tag.Parent = SCRIPT_ACCESSORY_TAG, a
                    a.Parent = workspace
                    local handle = a:FindFirstChild("Handle")
                    if handle then
                        local at = handle:FindFirstChildOfClass("Attachment")
                        if at then
                            local ca = findAttachment(target, at.Name)
                            if ca then weldParts(target, handle, ca.CFrame, at.CFrame)
                            else weldParts(target, handle, CFrame.new(), CFrame.new()) end
                        else weldParts(target, handle, CFrame.new(), CFrame.new()) end
                    end
                    a.Parent = char
                end
            end
        end
    end
end

-- NEW: Animation handling functions
local function captureOriginalAnimations(animateScript)
    if not animateScript or next(originalAnimations) then return end
    
    local anims = {
        idle = { animateScript.idle.Animation1.AnimationId, animateScript.idle.Animation2.AnimationId },
        walk = animateScript.walk.WalkAnim.AnimationId,
        run = animateScript.run.RunAnim.AnimationId,
        jump = animateScript.jump.JumpAnim.AnimationId,
        fall = animateScript.fall.FallAnim.AnimationId,
        climb = animateScript.climb.ClimbAnim.AnimationId,
        swim = animateScript.swim.Swim.AnimationId,
        swimidle = animateScript.swimidle.SwimIdle.AnimationId
    }
    originalAnimations = anims
    animationPacks["None"] = anims -- Set the "None" pack to the captured originals
end

local function applyAnimationPack(char, packName)
    coroutine.wrap(function()
        if not char then return end
        local animate = char:WaitForChild("Animate", 5)
        if not animate then return end
        
        local success = pcall(function()
            captureOriginalAnimations(animate) -- Capture originals if we haven't already
        end)
        if not success then return end

        local pack = animationPacks[packName]
        if not pack then return end
        
        -- Use a small delay to ensure animations apply correctly
        task.wait(0.1)

        animate.idle.Animation1.AnimationId = pack.idle and pack.idle[1] or originalAnimations.idle[1]
        animate.idle.Animation2.AnimationId = pack.idle and pack.idle[2] or originalAnimations.idle[2]
        animate.walk.WalkAnim.AnimationId = pack.walk or originalAnimations.walk
        animate.run.RunAnim.AnimationId = pack.run or originalAnimations.run
        animate.jump.JumpAnim.AnimationId = pack.jump or originalAnimations.jump
        animate.fall.FallAnim.AnimationId = pack.fall or originalAnimations.fall
        animate.climb.ClimbAnim.AnimationId = pack.climb or originalAnimations.climb
        animate.swim.Swim.AnimationId = pack.swim or originalAnimations.swim
        animate.swimidle.SwimIdle.AnimationId = pack.swimidle or originalAnimations.swimidle
    end)()
end

local function performFullReset(chr)
    clearOldAccessories(chr)
    applyAnimationPack(chr, "None") -- Reset animations
    if chr and chr:FindFirstChild("Head") then
        chr.Head.Transparency = 0
        for _, d in ipairs(chr.Head:GetChildren()) do
            if d:IsA("Decal") then d.Transparency = 0 end
        end
    end
    for limb, data in pairs(originalLimbData) do
        if chr and chr:FindFirstChild(limb) then
            for prop, val in pairs(data) do chr[limb][prop] = val end
        end
    end
    originalLimbData = {}
    for _, hair in ipairs(removedHairStorage) do
        if hair and not hair.Parent and chr then hair.Parent = chr end
    end
    removedHairStorage = {}
end

local function applyAppearance(char, appearanceData)
    if not char then return end
    for name, enabled in pairs(appearanceData) do
        if enabled and allActions[name] then
            local a = allActions[name]
            if a.type == "Accessory" then addAccessory(char, a.action)
            else pcall(a.action, char, true) end
        end
    end
end

local function syncCharacterState(char)
    if not char then return end
    performFullReset(char)
    applyAppearance(char, autoEquipSelection)
    applyAnimationPack(char, selectedAnimationPack)
end

characterAddedConnection = Player.CharacterAdded:Connect(function(c)
    c:WaitForChild("Humanoid")
    originalAnimations = {}
    originalLimbData, removedHairStorage = {}, {}
    task.wait(0.2)
    syncCharacterState(c)
end)

local function updateTogglesFromState()
    for name, _ in pairs(allActions) do
        local toggle = Library.Toggles[name]
        if toggle then
            toggle:SetValue(autoEquipSelection[name] or false)
        end
    end
end

local function saveProfilesToFile()
    local ok, encoded = pcall(function() return HttpService:JSONEncode(savedProfiles) end)
    if ok and encoded and writefile then writefile(profilesFileName, encoded) end
end

local function loadProfilesFromFile()
    if isfile and isfile(profilesFileName) then
        local f = readfile(profilesFileName)
        if f and f ~= "" then
            local ok, data = pcall(function() return HttpService:JSONDecode(f) end)
            if ok and data then savedProfiles = data end
        end
    end
end

local function getDropdownOptions()
    local opts = { "None" }
    local keys = getTableKeys(savedProfiles)
    table.sort(keys)
    for _, k in ipairs(keys) do table.insert(opts, k) end
    return opts
end

-- Create Tabs
local appearanceTab = Window:AddTab("Appearance", "shirt")
local profilesTab = Window:AddTab("Profiles", "save")
local usefulTab = Window:AddTab("Useful", "wrench")

-- Function to force a tab's layout to be full-width instead of two columns
local function makeTabFullWidth(tab)
    if tab and tab.Sides and #tab.Sides == 2 then
        local leftColumn = tab.Sides[1]
        local rightColumn = tab.Sides[2]
        leftColumn.Size = UDim2.new(1, 0, 1, 0) 
        rightColumn.Visible = false
    end
end

-- Apply this fix to all created tabs
makeTabFullWidth(appearanceTab)
makeTabFullWidth(profilesTab)
makeTabFullWidth(usefulTab)

-- Populate Appearance Tab
local appearanceGroup = appearanceTab:AddLeftGroupbox("Items")
for name, _ in pairs(allActions) do
    appearanceGroup:AddToggle(name, {
        Text = name,
        Default = autoEquipSelection[name] or false,
        Callback = function(value)
            autoEquipSelection[name] = value
            syncCharacterState(Player.Character)
        end
    })
end

local animationGroup = appearanceTab:AddLeftGroupbox("Animation")
animationGroup:AddDropdown("AnimationPackSelector", {
    Values = getTableKeys(animationPacks),
    Default = selectedAnimationPack,
    Text = "Animation Pack",
    Callback = function(pack)
        selectedAnimationPack = pack
        applyAnimationPack(Player.Character, selectedAnimationPack)
    end
})

-- Populate Profiles Tab
local profilesGroup = profilesTab:AddLeftGroupbox("Management")
profilesGroup:AddLabel("AutoLoadStatusLabel", { Text = "Auto Load: None" })

profilesGroup:AddDropdown("ProfileSelector", {
    Values = getDropdownOptions(),
    Default = "None",
    Text = "Select Profile",
    Callback = function(selection)
        if not selection then return end
        selectedProfileName = (selection ~= "None") and selection or nil
    end
})

profilesGroup:AddButton("ApplyProfileButton", {
    Text = "Apply Selected Profile",
    DoubleClick = false,
    Func = function()
        if selectedProfileName and savedProfiles[selectedProfileName] then
            performFullReset(Player.Character)
            
            local profileData = savedProfiles[selectedProfileName]
            autoEquipSelection = copyTable(profileData)
            selectedAnimationPack = profileData._AnimationPack or "None"
            autoEquipSelection._AnimationPack = nil -- Remove it from the main table
            
            updateTogglesFromState()
            Library.Options.AnimationPackSelector:SetValue(selectedAnimationPack)
            
            applyAppearance(Player.Character, autoEquipSelection)
            applyAnimationPack(Player.Character, selectedAnimationPack)
            
            Obsidian:Notify({ Title = "Profile Applied", Description = "'" .. selectedProfileName .. "' has been applied." })
        else
            Obsidian:Notify({ Title = "Error", Description = "No profile is selected to apply." })
        end
    end
})

profilesGroup:AddInput("ProfileNameInput", {
    Text = "Profile Name",
    Placeholder = "Enter name here...",
    Callback = function(text) profileNameInput = text end
})

profilesGroup:AddButton("SaveProfileButton", {
    Text = "Save Current Profile",
    DoubleClick = false,
    Func = function()
        if profileNameInput and profileNameInput ~= "" then
            local profileToSave = copyTable(autoEquipSelection)
            profileToSave._AnimationPack = selectedAnimationPack
            savedProfiles[profileNameInput] = profileToSave
            
            saveProfilesToFile()
            Library.Options.ProfileSelector:SetValues(getDropdownOptions())
            Library.Options.ProfileSelector:SetValue(profileNameInput)
            selectedProfileName = profileNameInput
            Obsidian:Notify({ Title = "Profile Saved", Description = "'" .. profileNameInput .. "' has been saved." })
        else
            Obsidian:Notify({ Title = "Error", Description = "Please enter a profile name first." })
        end
    end
})

profilesGroup:AddButton("RenameProfileButton", {
    Text = "Rename Selected",
    DoubleClick = false,
    Func = function()
        local newName = profileNameInput
        if selectedProfileName and newName and newName ~= "" and not savedProfiles[newName] then
            savedProfiles[newName] = savedProfiles[selectedProfileName]
            savedProfiles[selectedProfileName] = nil
            if isfile and isfile(autoLoadFileName) and readfile(autoLoadFileName) == selectedProfileName then
                writefile(autoLoadFileName, newName)
                Library.Labels.AutoLoadStatusLabel:SetText("Auto Load: " .. newName)
            end
            selectedProfileName = newName
            saveProfilesToFile()
            Library.Options.ProfileSelector:SetValues(getDropdownOptions())
            Library.Options.ProfileSelector:SetValue(newName)
        end
    end
})

profilesGroup:AddButton("DeleteProfileButton", {
    Text = "Delete Selected",
    DoubleClick = false,
    Func = function()
        if selectedProfileName then
            savedProfiles[selectedProfileName] = nil
            selectedProfileName = nil
            saveProfilesToFile()
            Library.Options.ProfileSelector:SetValues(getDropdownOptions())
            Library.Options.ProfileSelector:SetValue("None")
        end
    end
})

profilesGroup:AddButton("SetAutoLoadButton", {
    Text = "Set Auto Load",
    DoubleClick = false,
    Func = function()
        if selectedProfileName and writefile then
            writefile(autoLoadFileName, tostring(selectedProfileName))
            Library.Labels.AutoLoadStatusLabel:SetText("Auto Load: " .. selectedProfileName)
        end
    end
})

profilesGroup:AddButton("ClearAutoLoadButton", {
    Text = "Clear Auto Load",
    DoubleClick = false,
    Func = function()
        if writefile then
            writefile(autoLoadFileName, "")
            Library.Labels.AutoLoadStatusLabel:SetText("Auto Load: None")
        end
    end
})

-- Populate Useful Tab
local usefulGroup = usefulTab:AddLeftGroupbox("Tools")

usefulGroup:AddLabel("Toggle UI"):AddKeyPicker("ToggleUIKeybind", {
    Default = "RightControl",
    NoUI = true,
    Text = "Toggle UI"
})
Library.ToggleKeybind = Library.Options.ToggleUIKeybind

usefulGroup:AddButton("ResetAllButton", {
    Text = "Reset All",
    DoubleClick = false,
    Func = function()
        autoEquipSelection = {}
        selectedAnimationPack = "None"
        performFullReset(Player.Character)
        updateTogglesFromState()
        Library.Options.AnimationPackSelector:SetValue("None")
    end
})

usefulGroup:AddButton("UnloadButton", {
    Text = "Unload Script",
    DoubleClick = false,
    Risky = true,
    Func = function()
        performFullReset(Player.Character)
        if characterAddedConnection then
            characterAddedConnection:Disconnect()
            characterAddedConnection = nil
        end
        getgenv().ParadiseLoaded = nil
        Obsidian:Unload()
    end
})

-- Initial load sequence
loadProfilesFromFile()
Library.Options.ProfileSelector:SetValues(getDropdownOptions())

if isfile and isfile(autoLoadFileName) then
    local autoProfileName = readfile(autoLoadFileName)
    if autoProfileName and autoProfileName ~= "" and savedProfiles[autoProfileName] then
        local profileData = savedProfiles[autoProfileName]
        autoEquipSelection = copyTable(profileData)
        selectedAnimationPack = profileData._AnimationPack or "None"
        autoEquipSelection._AnimationPack = nil

        selectedProfileName = autoProfileName
        Library.Labels.AutoLoadStatusLabel:SetText("Auto Load: " .. autoProfileName)
        Library.Options.ProfileSelector:SetValue(autoProfileName)
        Library.Options.AnimationPackSelector:SetValue(selectedAnimationPack)
        
        updateTogglesFromState()
        syncCharacterState(Player.Character)
    end
end

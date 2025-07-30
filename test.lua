--[[
    Paradise Appearance Manager - Final Version
    - Added a new "Full Outfits" section with a toggle for the "Scary Smile" outfit.
    - FIX 22: Removed aggressive character re-parenting to prevent anti-cheat issues.
    - FIX 21: Re-engineered the save/load system to correctly handle morphed characters.
]]

if getgenv().ParadiseLoaded then return end

-- Load Library and Addons
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local success, Obsidian = pcall(function() return loadstring(game:HttpGet(repo .. "Library.lua"))() end)
if not success or not Obsidian then
    warn("Paradise Manager: Failed to load the core Obsidian library. The script will not run.")
    return
end

local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

getgenv().ParadiseLoaded = true

-- Services
local Players = game:GetService("Players")
local Player = Players.LocalPlayer or Players.PlayerAdded:Wait()

local Window = Obsidian:CreateWindow({
    Name = "Larps ┗ Paradise",
    Title = "Paradise Interface",
    SubTitle = "by joseph & AI",
    Draggable = true,
    Footer = "Made By gemini & Thank him"
})

-- Original state tracking variables
local originalLimbData, removedHairStorage, originalFaceTexture, scriptedShirtGraphic, originalPartColors = {}, {}, nil, nil, {}
local originalClothing = { Shirt = nil, Pants = nil, TShirts = {}, Accessories = {} }
local characterAddedConnection = nil
local happierJumpAnimTrack = nil

-- Animation and clothing definitions
local originalAnimations = {}
local animationPacks = {
    ["None"] = {},
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
}
local clothingItems = {
    TShirt = {
        ["None"] = nil,
        ["Oh Noez!"] = "http://www.roblox.com/asset/?id=1641286",
        ["Spread The Lulz!"] = "http://www.roblox.com/asset/?id=24774765",
    }
}
local limbMappings = {
    Head = { "Head" },
    Torso = { "UpperTorso", "LowerTorso" },
    LeftArm = { "LeftUpperArm", "LeftLowerArm", "LeftHand" },
    RightArm = { "RightUpperArm", "RightLowerArm", "RightHand" },
    LeftLeg = { "LeftUpperLeg", "LeftLowerLeg", "LeftFoot" },
    RightLeg = { "RightUpperLeg", "RightLowerLeg", "RightFoot" },
}
local originalLimbColors = {}

-- Helper functions
local function getTableKeys(tbl)
    local keys = {}; for k in pairs(tbl) do table.insert(keys, k) end; table.sort(keys); return keys
end

local function weldParts(p0, p1, c0, c1)
    local w = Instance.new("Weld"); w.Part0, w.Part1, w.C0, w.C1, w.Parent = p0, p1, c0, c1, p0; return w
end

local function findAttachment(root, name)
    for _, d in ipairs(root:GetDescendants()) do
        if d:IsA("Attachment") and d.Name == name then return d end
    end
end

local function clearOldAccessories(char)
    if not char then return end
    for _, c in ipairs(char:GetChildren()) do
        if c:IsA("Accessory") and c:FindFirstChild("DrRayScriptedAccessory") then c:Destroy() end
    end
end

local function addAccessory(char, accessoryData)
    if not (char and accessoryData) then return end
    local head = char:FindFirstChild("Head"); local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
    for _, partName in ipairs({"Head", "Torso"}) do
        local target = partName == "Head" and head or torso
        if accessoryData[partName] and target then
            for _, id in ipairs(accessoryData[partName]) do
                local ok, a = pcall(function() return game:GetObjects("rbxassetid://" .. id)[1] end)
                if ok and a then
                    local tag = Instance.new("BoolValue"); tag.Name, tag.Parent = "DrRayScriptedAccessory", a
                    a.Parent = workspace
                    local handle = a:FindFirstChild("Handle")
                    if handle then
                        local at = handle:FindFirstChildOfClass("Attachment")
                        if at then
                            local ca = findAttachment(target, at.Name)
                            if ca then weldParts(target, handle, ca.CFrame, at.CFrame) else weldParts(target, handle, CFrame.new(), CFrame.new()) end
                        else weldParts(target, handle, CFrame.new(), CFrame.new()) end
                    end
                    a.Parent = char
                end
            end
        end
    end
end

local function captureOriginalAnimations(animateScript)
    if not animateScript or next(originalAnimations) then return end
    local anims = {
        idle = { animateScript.idle.Animation1.AnimationId, animateScript.idle.Animation2.AnimationId },
        walk = animateScript.walk.WalkAnim.AnimationId, run = animateScript.run.RunAnim.AnimationId,
        jump = animateScript.jump.JumpAnim.AnimationId, fall = animateScript.fall.FallAnim.AnimationId,
        climb = animateScript.climb.ClimbAnim.AnimationId, swim = animateScript.swim.Swim.AnimationId,
        swimidle = animateScript.swimidle.SwimIdle.AnimationId
    }; originalAnimations = anims; animationPacks["None"] = anims
end

local function applyAnimationPack(char, packName)
    coroutine.wrap(function()
        if not char then return end
        local animate = char:WaitForChild("Animate", 5); if not animate then return end
        pcall(captureOriginalAnimations, animate)
        local pack = animationPacks[packName]; if not pack then return end
        task.wait(0.1)
        animate.idle.Animation1.AnimationId = pack.idle and pack.idle[1] or originalAnimations.idle[1]
        animate.idle.Animation2.AnimationId = pack.idle and pack.idle[2] or originalAnimations.idle[2]
        animate.walk.WalkAnim.AnimationId = pack.walk or originalAnimations.walk; animate.run.RunAnim.AnimationId = pack.run or originalAnimations.run
        animate.jump.JumpAnim.AnimationId = pack.jump or originalAnimations.jump; animate.fall.FallAnim.AnimationId = pack.fall or originalAnimations.fall
        animate.climb.ClimbAnim.AnimationId = pack.climb or originalAnimations.climb; animate.swim.Swim.AnimationId = pack.swim or originalAnimations.swim
        animate.swimidle.SwimIdle.AnimationId = pack.swimidle or originalAnimations.swimidle
    end)()
end

local function applyTShirt(char, tShirtName)
    if not char then return end
    if scriptedShirtGraphic and scriptedShirtGraphic.Parent then scriptedShirtGraphic:Destroy() end
    scriptedShirtGraphic = nil
    local tShirtId = clothingItems.TShirt[tShirtName]
    if tShirtId then
        local newShirtGraphic = Instance.new("ShirtGraphic", char); newShirtGraphic.Graphic = tShirtId; scriptedShirtGraphic = newShirtGraphic
    end
end

local function applyLimbColor(char, limbName, color)
    if not char then return end
    local partsToColor = limbMappings[limbName]; if not partsToColor then return end
    for _, partName in ipairs(partsToColor) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") then
            if not originalPartColors[partName] then originalPartColors[partName] = part.Color end
            part.Color = color
        end
    end
end

local function performFullReset(chr)
    if happierJumpAnimTrack then happierJumpAnimTrack:Stop() end
    clearOldAccessories(chr); applyAnimationPack(chr, "None")
    if chr then
        if scriptedShirtGraphic and scriptedShirtGraphic.Parent then scriptedShirtGraphic:Destroy() end
        scriptedShirtGraphic = nil
        if chr:FindFirstChild("Head") then
            local head = chr:FindFirstChild("Head"); head.Transparency = 0
            for _, d in ipairs(head:GetChildren()) do if d:IsA("Decal") then d.Transparency = 0 end end
            if originalFaceTexture then local faceDecal = head:FindFirstChild("face"); if faceDecal then faceDecal.Texture = originalFaceTexture end end
        end
        for partName, color in pairs(originalPartColors) do local part = chr:FindFirstChild(partName); if part then part.Color = color end end
        originalPartColors = {}
        if originalClothing.Shirt and not originalClothing.Shirt.Parent then originalClothing.Shirt.Parent = chr end
        if originalClothing.Pants and not originalClothing.Pants.Parent then originalClothing.Pants.Parent = chr end
        for _, item in ipairs(originalClothing.TShirts) do if item and not item.Parent then item.Parent = chr end end
        for _, item in ipairs(originalClothing.Accessories) do if item and not item.Parent then item.Parent = chr end end
        originalClothing = { Shirt = nil, Pants = nil, TShirts = {}, Accessories = {} }
    end
    originalFaceTexture = nil
    for limb, data in pairs(originalLimbData) do if chr and chr:FindFirstChild(limb) then for prop, val in pairs(data) do chr[limb][prop] = val end end end
    originalLimbData = {}
    for _, hair in ipairs(removedHairStorage) do if hair and not hair.Parent and chr then hair.Parent = chr end end
    removedHairStorage = {}
end

-- Action definitions
local allActions = {
    ["Headless"] = { category = "Body", type = "Function", action = function(c, e) if c and c:FindFirstChild("Head") then c.Head.Transparency = e and 1 or 0; for _, v in ipairs(c.Head:GetChildren()) do if v:IsA("Decal") then v.Transparency = e and 1 or 0 end end end end },
    ["Korblox"] = { category = "Body", type = "Function", action = function(c, e) if not (c and c.RightLowerLeg and c.RightUpperLeg and c.RightFoot) then return end if e then for _, part in ipairs({"RightLowerLeg", "RightUpperLeg", "RightFoot"}) do local p = c:FindFirstChild(part); if p and not originalLimbData[part] then originalLimbData[part] = { MeshId = p.MeshId, Transparency = p.Transparency, TextureID = p.TextureID } end end; c.RightLowerLeg.MeshId, c.RightLowerLeg.Transparency = "rbxassetid://902942093", 1; c.RightUpperLeg.MeshId, c.RightUpperLeg.TextureID = "rbxassetid://902942096", "rbxassetid://902843398"; c.RightFoot.MeshId, c.RightFoot.Transparency = "rbxassetid://902942089", 1 else performFullReset(c) end end },
    ["Naked"] = { category = "Body", type = "Function", action = function(c, e) if not c then return end if e then local shirt = c:FindFirstChildOfClass("Shirt"); if shirt and not originalClothing.Shirt then originalClothing.Shirt = shirt; shirt.Parent = nil end; local pants = c:FindFirstChildOfClass("Pants"); if pants and not originalClothing.Pants then originalClothing.Pants = pants; pants.Parent = nil end; if #originalClothing.TShirts == 0 then for _, item in ipairs(c:GetChildren()) do if item:IsA("ShirtGraphic") and item ~= scriptedShirtGraphic then table.insert(originalClothing.TShirts, item); item.Parent = nil end end end else if originalClothing.Shirt and not originalClothing.Shirt.Parent then originalClothing.Shirt.Parent = c end; if originalClothing.Pants and not originalClothing.Pants.Parent then originalClothing.Pants.Parent = c end; for _, item in ipairs(originalClothing.TShirts) do if item and not item.Parent then item.Parent = c end end; originalClothing.Shirt, originalClothing.Pants, originalClothing.TShirts = nil, nil, {} end end },
    ["Remove Hair"] = { category = "Body", type = "Function", action = function(c, e) if not c then return end if e then for _, hair in ipairs(removedHairStorage) do if hair and not hair.Parent then hair:Destroy() end end; removedHairStorage = {}; for _, h in ipairs(c:GetChildren()) do if h:IsA("Accessory") and h.AccessoryType == Enum.AccessoryType.Hair then table.insert(removedHairStorage, h); h.Parent = nil end end else for _, hair in ipairs(removedHairStorage) do if hair and not hair.Parent then hair.Parent = c end end; removedHairStorage = {} end end },
    ["Epic Face"] = { category = "Faces", type = "Function", action = function(c, e) if not c then return end; local head = c:FindFirstChild("Head"); if not head then return end; local faceDecal = head:FindFirstChild("face"); if not faceDecal then return end; if e then if not originalFaceTexture then originalFaceTexture = faceDecal.Texture end; faceDecal.Texture = "http://www.roblox.com/asset/?id=42070872" else if originalFaceTexture then faceDecal.Texture = originalFaceTexture; originalFaceTexture = nil end end end },
    ["Loop Happier Jump Emote"] = { category = "Animation", type = "Function", action = function(c, e) if not (c and c:FindFirstChild("Humanoid")) then return end; if e then if not happierJumpAnimTrack then local anim = Instance.new("Animation"); anim.AnimationId = "rbxassetid://15609995579"; happierJumpAnimTrack = c.Humanoid:LoadAnimation(anim); happierJumpAnimTrack.Looped = true end; happierJumpAnimTrack:Play() else if happierJumpAnimTrack then happierJumpAnimTrack:Stop() end end end },
    ["Scary Smile Outfit"] = { category = "Outfits", type = "Function", action = function(c, e)
        if not c then return end
        if e then
            -- Clean existing items
            for _, item in ipairs(c:GetChildren()) do
                if item:IsA("Accessory") and item.Name == "ScarySmileAccessory" then item:Destroy() end
                if item:IsA("Shirt") or item:IsA("Pants") then item:Destroy() end
            end
            if c.Head then for _, item in ipairs(c.Head:GetChildren()) do if item:IsA("Decal") then item:Destroy() end end end
            
            -- Build and add accessory
            local acc = Instance.new("Accessory"); acc.Name = "ScarySmileAccessory"
            local handle = Instance.new("Part", acc); handle.Name = "Handle"; handle.Size = Vector3.new(1, 1, 1); handle.Transparency = 1
            local mesh = Instance.new("SpecialMesh", handle); mesh.Name = "ScarySmileMesh"; mesh.MeshType = Enum.MeshType.FileMesh; mesh.MeshId = "rbxassetid://111022241256851"; mesh.Scale = Vector3.new(1.03, 1.03, 1.03)
            local decal = Instance.new("Decal", handle); decal.Name = "ScarySmileTexture"; decal.Texture = "http://www.roblox.com/asset/?id=120935988855219"; decal.Face = Enum.NormalId.Front
            local faceAttachment = c.Head and (c.Head:FindFirstChild("FaceCenterAttachment") or c.Head:FindFirstChild("FaceFrontAttachment"))
            if faceAttachment then local weld = Instance.new("Weld", handle); weld.Part0 = handle; weld.Part1 = c.Head; weld.C0 = faceAttachment.CFrame end
            acc.Parent = c
            
            -- Apply clothing
            local shirt = Instance.new("Shirt", c); shirt.ShirtTemplate = "http://www.roblox.com/asset/?id=11275376793"
            local pants = Instance.new("Pants", c); pants.PantsTemplate = "http://www.roblox.com/asset/?id=5043452775"
        else
            -- Remove outfit
            for _, item in ipairs(c:GetChildren()) do
                if (item:IsA("Accessory") and item.Name == "ScarySmileAccessory") or (item:IsA("Shirt") and item.ShirtTemplate:find("11275376793")) or (item:IsA("Pants") and item.PantsTemplate:find("5043452775")) then
                    item:Destroy()
                end
            end
            syncCharacterState(c) -- Resync to restore previous state
        end
    end },
    ["Remove Original Shirt"] = { category = "Outfit", type = "Function", action = function(c, e) if not c then return end; if e then local shirt = c:FindFirstChildOfClass("Shirt"); if shirt and not originalClothing.Shirt then originalClothing.Shirt = shirt; shirt.Parent = nil end else if originalClothing.Shirt and not originalClothing.Shirt.Parent then originalClothing.Shirt.Parent = c end; originalClothing.Shirt = nil end end },
    ["Remove Original Pants"] = { category = "Outfit", type = "Function", action = function(c, e) if not c then return end; if e then local pants = c:FindFirstChildOfClass("Pants"); if pants and not originalClothing.Pants then originalClothing.Pants = pants; pants.Parent = nil end else if originalClothing.Pants and not originalClothing.Pants.Parent then originalClothing.Pants.Parent = c end; originalClothing.Pants = nil end end },
    ["Remove Original T-Shirts"] = { category = "Outfit", type = "Function", action = function(c, e) if not c then return end; if e then originalClothing.TShirts = {}; for _, item in ipairs(c:GetChildren()) do if item:IsA("ShirtGraphic") and item ~= scriptedShirtGraphic then table.insert(originalClothing.TShirts, item); item.Parent = nil end end else for _, item in ipairs(originalClothing.TShirts) do if item and not item.Parent then item.Parent = c end end; originalClothing.TShirts = {} end end },
    ["Remove Original Accessories"] = { category = "Outfit", type = "Function", action = function(c, e) if not c then return end; if e then originalClothing.Accessories = {}; for _, item in ipairs(c:GetChildren()) do if item:IsA("Accessory") and not item:FindFirstChild("DrRayScriptedAccessory") then table.insert(originalClothing.Accessories, item); item.Parent = nil end end else for _, item in ipairs(originalClothing.Accessories) do if item and not item.Parent then item.Parent = c end end; originalClothing.Accessories = {} end end },
    ["Valkyrie Helm"] = { category = "Accessories", type = "Accessory", action = { Head = { 1365767 } } },
    ["Wings of Duality"] = { category = "Accessories", type = "Accessory", action = { Torso = { 493489765 } } },
    ["Dominus Praefectus"] = { category = "Accessories", type = "Accessory", action = { Head = { 527365852 } } },
    ["Fiery Horns of the Netherworld"] = { category = "Accessories", type = "Accessory", action = { Head = { 215718515 } } },
    ["Blackvalk"] = { category = "Accessories", type = "Accessory", action = { Head = { 124730194 } } },
    ["Frozen Horns of the Frigid Planes"] = { category = "Accessories", type = "Accessory", action = { Head = { 74891470 } } },
    ["Silver King of the Night"] = { category = "Accessories", type = "Accessory", action = { Head = { 439945661 } } },
    ["Poisoned Horns of the Toxic Wasteland"] = { category = "Accessories", type = "Accessory", action = { Head = { 1744060292 } } },
    ["Pink Sparkle Time Fedora"] = { category = "Accessories", type = "Accessory", action = { Head = { 334663683 } } },
    ["Midnight Blue Sparkle Time Fedora"] = { category = "Accessories", type = "Accessory", action = { Head = { 119916949 } } },
    ["Green Sparkle Time Fedora"] = { category = "Accessories", type = "Accessory", action = { Head = { 100929604 } } },
    ["Red Sparkle Time Fedora"] = { category = "Accessories", type = "Accessory", action = { Head = { 72082328 } } },
    ["Purple Sparkle Time Fedora"] = { category = "Accessories", type = "Accessory", action = { Head = { 63043890 } } }
}

local function syncCharacterState(char)
    if not char then return end; performFullReset(char)
    for name, action in pairs(allActions) do
        if Library.Toggles[name] and Library.Toggles[name].Value then
            if action.type == "Accessory" then addAccessory(char, action.action) else pcall(action.action, char, true) end
        end
    end
    applyLimbColor(char, "Head", Library.Options.HeadColor.Value); applyLimbColor(char, "Torso", Library.Options.TorsoColor.Value)
    applyLimbColor(char, "LeftArm", Library.Options.LeftArmColor.Value); applyLimbColor(char, "RightArm", Library.Options.RightArmColor.Value)
    applyLimbColor(char, "LeftLeg", Library.Options.LeftLegColor.Value); applyLimbColor(char, "RightLeg", Library.Options.RightLegColor.Value)
    applyTShirt(char, Library.Options.TShirtSelector.Value); applyAnimationPack(char, Library.Options.AnimationPackSelector.Value)
end

local function captureOriginalColors(char, force)
    if not char then return end; if not force and next(originalLimbColors) then return end; originalLimbColors = {}
    for limbGroup, parts in pairs(limbMappings) do
        local representativePart = char:FindFirstChild(parts[1])
        if representativePart then originalLimbColors[limbGroup] = representativePart.Color end
    end
end

characterAddedConnection = Player.CharacterAdded:Connect(function(c)
    c:WaitForChild("Humanoid")
    originalAnimations, originalLimbData, removedHairStorage = {}, {}, {}
    originalFaceTexture, scriptedShirtGraphic, originalPartColors = nil, nil, {}
    originalLimbColors, originalClothing = {}, { Shirt = nil, Pants = nil, TShirts = {}, Accessories = {} }
    happierJumpAnimTrack = nil
    task.wait(0.2); captureOriginalColors(c, true); syncCharacterState(c)
end)

if Player.Character then captureOriginalColors(Player.Character) end

-- Create Tabs
local appearanceTab = Window:AddTab("Appearance", "shirt")
local usefulTab = Window:AddTab("Useful", "wrench")
local uiSettingsTab = Window:AddTab("UI Settings", "settings")

local function makeTabFullWidth(tab) if tab and tab.Sides and #tab.Sides == 2 then local left = tab.Sides[1]; local right = tab.Sides[2]; left.Size = UDim2.new(1, 0, 1, 0); right.Visible = false end end
makeTabFullWidth(appearanceTab); makeTabFullWidth(usefulTab)

-- Populate Appearance Tab
local groupboxes = {
    Accessories = appearanceTab:AddLeftGroupbox("Accessories"), Body = appearanceTab:AddLeftGroupbox("Body Modifications"),
    Faces = appearanceTab:AddLeftGroupbox("Faces"), Clothing = appearanceTab:AddLeftGroupbox("Clothing (Visual)"),
    Outfit = appearanceTab:AddLeftGroupbox("Outfit Management (Original)"), Animation = appearanceTab:AddLeftGroupbox("Animation"),
    Outfits = appearanceTab:AddLeftGroupbox("Full Outfits")
}

for name, data in pairs(allActions) do
    local targetGroup = groupboxes[data.category]
    if targetGroup then targetGroup:AddToggle(name, {Text = name, Default = false, Callback = function(v) syncCharacterState(Player.Character) end}) end
end

local fallbackColor = Color3.fromRGB(245, 205, 172)
groupboxes.Body:AddLabel("Head Color"):AddColorPicker("HeadColor", { Default = originalLimbColors.Head or fallbackColor, Callback = function(c) applyLimbColor(Player.Character, "Head", c) end })
groupboxes.Body:AddLabel("Torso Color"):AddColorPicker("TorsoColor", { Default = originalLimbColors.Torso or fallbackColor, Callback = function(c) applyLimbColor(Player.Character, "Torso", c) end })
groupboxes.Body:AddLabel("Left Arm Color"):AddColorPicker("LeftArmColor", { Default = originalLimbColors.LeftArm or fallbackColor, Callback = function(c) applyLimbColor(Player.Character, "LeftArm", c) end })
groupboxes.Body:AddLabel("Right Arm Color"):AddColorPicker("RightArmColor", { Default = originalLimbColors.RightArm or fallbackColor, Callback = function(c) applyLimbColor(Player.Character, "RightArm", c) end })
groupboxes.Body:AddLabel("Left Leg Color"):AddColorPicker("LeftLegColor", { Default = originalLimbColors.LeftLeg or fallbackColor, Callback = function(c) applyLimbColor(Player.Character, "LeftLeg", c) end })
groupboxes.Body:AddLabel("Right Leg Color"):AddColorPicker("RightLegColor", { Default = originalLimbColors.RightLeg or fallbackColor, Callback = function(c) applyLimbColor(Player.Character, "RightLeg", c) end })

local function resetLimbColors()
    local char = Player.Character; if not char then return end
    for limbGroup, parts in pairs(limbMappings) do
        local originalColor = originalLimbColors[limbGroup]
        if originalColor then
            for _, partName in ipairs(parts) do local part = char:FindFirstChild(partName); if part then part.Color = originalColor end end
            if Library.Options[limbGroup .. "Color"] then Library.Options[limbGroup .. "Color"]:SetValueRGB(originalColor) end
        end
    end
    originalPartColors = {}
end

groupboxes.Body:AddButton("Reset Limb Colors", resetLimbColors)
groupboxes.Clothing:AddDropdown("TShirtSelector", { Values = getTableKeys(clothingItems.TShirt), Default = "None", Text = "T-Shirt", Callback = function(s) applyTShirt(Player.Character, s) end })
groupboxes.Animation:AddDropdown("AnimationPackSelector", { Values = getTableKeys(animationPacks), Default = "None", Text = "Animation Pack", Callback = function(p) applyAnimationPack(Player.Character, p) end })

-- Populate Useful Tab
local usefulGroup = usefulTab:AddLeftGroupbox("Tools")
usefulGroup:AddLabel("Toggle UI"):AddKeyPicker("ToggleUIKeybind", { Default = "RightControl", NoUI = true, Text = "Toggle UI" })
Library.ToggleKeybind = Library.Options.ToggleUIKeybind

local function resetAllToggles()
    for name, _ in pairs(allActions) do if Library.Toggles[name] then Library.Toggles[name]:SetValue(false) end end
    Library.Options.TShirtSelector:SetValue("None"); Library.Options.AnimationPackSelector:SetValue("None"); resetLimbColors()
end

local function fullCharacterReset()
    performFullReset(Player.Character); resetAllToggles()
end

usefulGroup:AddButton("Reset All", fullCharacterReset)
usefulGroup:AddButton("UnloadButton", { Text = "Unload Script", DoubleClick = false, Risky = true, Func = function() performFullReset(Player.Character); if characterAddedConnection then characterAddedConnection:Disconnect() end; getgenv().ParadiseLoaded = nil; Obsidian:Unload() end })

-- Setup Addons
if ThemeManager and SaveManager then
    ThemeManager:SetLibrary(Obsidian); SaveManager:SetLibrary(Obsidian)
    SaveManager:IgnoreThemeSettings(); SaveManager:SetIgnoreIndexes({ "ToggleUIKeybind" })
    ThemeManager:SetFolder("Paradise"); SaveManager:SetFolder("Paradise")
    ThemeManager:ApplyToTab(uiSettingsTab); SaveManager:BuildConfigSection(uiSettingsTab)
    
    local oldLoadFunc = SaveManager.Load
    function SaveManager:Load(...)
        fullCharacterReset() -- Reset everything before loading a new config
        local success, err = oldLoadFunc(self, ...)
        if success then task.wait(0.2); syncCharacterState(Player.Character) end
        return success, err
    end
    
    SaveManager:LoadAutoloadConfig()
else
    warn("Paradise Manager: ThemeManager or SaveManager failed to load. The UI Settings tab will be disabled.")
end

local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("Larps ┃ Paradise", "Default")

local tab = DrRayLibrary.newTab("Rich set", "")
tab.newButton("Frozen Horns of the Frigid Planes", "Click to equip", function()
 getgenv().Time = 1 -- Adjust the time waited before adding the items

getgenv().Head = {
    74891470,
    0000000000
    -- Add more head accessory IDs
}

getgenv().Torso = {
    0000000000
    -- Add more torso accessory IDs
}

--//------------------------------------------------------------------------------------------\\--

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
    for _, descendant in pairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart)
    local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    local character = game.Players.LocalPlayer.Character

    accessory.Parent = game.Workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        if attachment then
            local parentAttachment = findAttachment(parentPart, attachment.Name)
            if parentAttachment then
                weldParts(parentPart, handle, parentAttachment.CFrame, attachment.CFrame)
            end
        else
            local parent = character:FindFirstChild(parentPart.Name)
            if parent then
                local attachmentPoint = accessory.AttachmentPoint
                weldParts(parent, handle, CFrame.new(0, 0.5, 0), attachmentPoint.CFrame)
            end
        end
    end

    accessory.Parent = game.Players.LocalPlayer.Character
end

local function onCharacterAdded(character)
    wait(getgenv().Time) -- Wait for the character to fully load

    for _, accessoryId in ipairs(getgenv().Head) do
        addAccessoryToCharacter(accessoryId, character.Head)
    end

    for _, accessoryId in ipairs(getgenv().Torso) do
        addAccessoryToCharacter(accessoryId, character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end
end)

tab.newButton("Dominus Praefectus", "Click to equip", function()
    
getgenv().Time = 1 -- Adjust the time waited before adding the items

getgenv().Head = {
    527365852,
    0000000000
    -- Add more head accessory IDs
}

getgenv().Torso = {
    0000000000
    -- Add more torso accessory IDs
}

--//------------------------------------------------------------------------------------------\\--

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
    for _, descendant in pairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart)
    local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    local character = game.Players.LocalPlayer.Character

    accessory.Parent = game.Workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        if attachment then
            local parentAttachment = findAttachment(parentPart, attachment.Name)
            if parentAttachment then
                weldParts(parentPart, handle, parentAttachment.CFrame, attachment.CFrame)
            end
        else
            local parent = character:FindFirstChild(parentPart.Name)
            if parent then
                local attachmentPoint = accessory.AttachmentPoint
                weldParts(parent, handle, CFrame.new(0, 0.5, 0), attachmentPoint.CFrame)
            end
        end
    end

    accessory.Parent = game.Players.LocalPlayer.Character
end

local function onCharacterAdded(character)
    wait(getgenv().Time) -- Wait for the character to fully load

    for _, accessoryId in ipairs(getgenv().Head) do
        addAccessoryToCharacter(accessoryId, character.Head)
    end

    for _, accessoryId in ipairs(getgenv().Torso) do
        addAccessoryToCharacter(accessoryId, character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end
end)

tab.newButton("Fiery Horns of the Netherworld", "Clcick to equip", function()
    
getgenv().Time = 1 -- Adjust the time waited before adding the items

getgenv().Head = {
    215718515,
    0000000000
    -- Add more head accessory IDs
}

getgenv().Torso = {
    0000000000
    -- Add more torso accessory IDs
}

--//------------------------------------------------------------------------------------------\\--

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
    for _, descendant in pairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart)
    local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    local character = game.Players.LocalPlayer.Character

    accessory.Parent = game.Workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        if attachment then
            local parentAttachment = findAttachment(parentPart, attachment.Name)
            if parentAttachment then
                weldParts(parentPart, handle, parentAttachment.CFrame, attachment.CFrame)
            end
        else
            local parent = character:FindFirstChild(parentPart.Name)
            if parent then
                local attachmentPoint = accessory.AttachmentPoint
                weldParts(parent, handle, CFrame.new(0, 0.5, 0), attachmentPoint.CFrame)
            end
        end
    end

    accessory.Parent = game.Players.LocalPlayer.Character
end

local function onCharacterAdded(character)
    wait(getgenv().Time) -- Wait for the character to fully load

    for _, accessoryId in ipairs(getgenv().Head) do
        addAccessoryToCharacter(accessoryId, character.Head)
    end

    for _, accessoryId in ipairs(getgenv().Torso) do
        addAccessoryToCharacter(accessoryId, character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end
end)

tab.newButton("Silver King of the Night", "Click to equip", function()
    
getgenv().Time = 1 -- Adjust the time waited before adding the items

getgenv().Head = {
    439945661,
    0000000000
    -- Add more head accessory IDs
}

getgenv().Torso = {
    0000000000
    -- Add more torso accessory IDs
}

--//------------------------------------------------------------------------------------------\\--

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
    for _, descendant in pairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart)
    local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    local character = game.Players.LocalPlayer.Character

    accessory.Parent = game.Workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        if attachment then
            local parentAttachment = findAttachment(parentPart, attachment.Name)
            if parentAttachment then
                weldParts(parentPart, handle, parentAttachment.CFrame, attachment.CFrame)
            end
        else
            local parent = character:FindFirstChild(parentPart.Name)
            if parent then
                local attachmentPoint = accessory.AttachmentPoint
                weldParts(parent, handle, CFrame.new(0, 0.5, 0), attachmentPoint.CFrame)
            end
        end
    end

    accessory.Parent = game.Players.LocalPlayer.Character
end

local function onCharacterAdded(character)
    wait(getgenv().Time) -- Wait for the character to fully load

    for _, accessoryId in ipairs(getgenv().Head) do
        addAccessoryToCharacter(accessoryId, character.Head)
    end

    for _, accessoryId in ipairs(getgenv().Torso) do
        addAccessoryToCharacter(accessoryId, character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end
end)

tab.newButton("Poisoned Horns of the Toxic Wasteland", "Click to equip", function()
    
getgenv().Time = 1 -- Adjust the time waited before adding the items

getgenv().Head = {
    1744060292,
    0000000000
    -- Add more head accessory IDs
}

getgenv().Torso = {
    0000000000
    -- Add more torso accessory IDs
}

--//------------------------------------------------------------------------------------------\\--

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
    for _, descendant in pairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart)
    local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    local character = game.Players.LocalPlayer.Character

    accessory.Parent = game.Workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        if attachment then
            local parentAttachment = findAttachment(parentPart, attachment.Name)
            if parentAttachment then
                weldParts(parentPart, handle, parentAttachment.CFrame, attachment.CFrame)
            end
        else
            local parent = character:FindFirstChild(parentPart.Name)
            if parent then
                local attachmentPoint = accessory.AttachmentPoint
                weldParts(parent, handle, CFrame.new(0, 0.5, 0), attachmentPoint.CFrame)
            end
        end
    end

    accessory.Parent = game.Players.LocalPlayer.Character
end

local function onCharacterAdded(character)
    wait(getgenv().Time) -- Wait for the character to fully load

    for _, accessoryId in ipairs(getgenv().Head) do
        addAccessoryToCharacter(accessoryId, character.Head)
    end

    for _, accessoryId in ipairs(getgenv().Torso) do
        addAccessoryToCharacter(accessoryId, character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end
end)

tab.newButton("Valkyrie Helm", "Click to equip", function()
    
getgenv().Time = 1 -- Adjust the time waited before adding the items

getgenv().Head = {
    1365767,
    0000000000
    -- Add more head accessory IDs
}

getgenv().Torso = {
    0000000000
    -- Add more torso accessory IDs
}

--//------------------------------------------------------------------------------------------\\--

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
    for _, descendant in pairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart)
    local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    local character = game.Players.LocalPlayer.Character

    accessory.Parent = game.Workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        if attachment then
            local parentAttachment = findAttachment(parentPart, attachment.Name)
            if parentAttachment then
                weldParts(parentPart, handle, parentAttachment.CFrame, attachment.CFrame)
            end
        else
            local parent = character:FindFirstChild(parentPart.Name)
            if parent then
                local attachmentPoint = accessory.AttachmentPoint
                weldParts(parent, handle, CFrame.new(0, 0.5, 0), attachmentPoint.CFrame)
            end
        end
    end

    accessory.Parent = game.Players.LocalPlayer.Character
end

local function onCharacterAdded(character)
    wait(getgenv().Time) -- Wait for the character to fully load

    for _, accessoryId in ipairs(getgenv().Head) do
        addAccessoryToCharacter(accessoryId, character.Head)
    end

    for _, accessoryId in ipairs(getgenv().Torso) do
        addAccessoryToCharacter(accessoryId, character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end
end)

tab.newButton("Blackvalk", "Click to equip", function()
    
getgenv().Time = 1 -- Adjust the time waited before adding the items

getgenv().Head = {
    124730194,
    0000000000
    -- Add more head accessory IDs
}

getgenv().Torso = {
    0000000000
    -- Add more torso accessory IDs
}

--//------------------------------------------------------------------------------------------\\--

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
    for _, descendant in pairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart)
    local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    local character = game.Players.LocalPlayer.Character

    accessory.Parent = game.Workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        if attachment then
            local parentAttachment = findAttachment(parentPart, attachment.Name)
            if parentAttachment then
                weldParts(parentPart, handle, parentAttachment.CFrame, attachment.CFrame)
            end
        else
            local parent = character:FindFirstChild(parentPart.Name)
            if parent then
                local attachmentPoint = accessory.AttachmentPoint
                weldParts(parent, handle, CFrame.new(0, 0.5, 0), attachmentPoint.CFrame)
            end
        end
    end

    accessory.Parent = game.Players.LocalPlayer.Character
end

local function onCharacterAdded(character)
    wait(getgenv().Time) -- Wait for the character to fully load

    for _, accessoryId in ipairs(getgenv().Head) do
        addAccessoryToCharacter(accessoryId, character.Head)
    end

    for _, accessoryId in ipairs(getgenv().Torso) do
        addAccessoryToCharacter(accessoryId, character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end
end)


local tab = DrRayLibrary.newTab("Hats", "ImageIdHere")
tab.newButton("Pink Sparkle Time Fedora", "Click to equip", function()
    
getgenv().Time = 1 -- Adjust the time waited before adding the items

getgenv().Head = {
    334663683,
    0000000000
    -- Add more head accessory IDs
}

getgenv().Torso = {
    0000000000
    -- Add more torso accessory IDs
}

--//------------------------------------------------------------------------------------------\\--

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
    for _, descendant in pairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart)
    local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    local character = game.Players.LocalPlayer.Character

    accessory.Parent = game.Workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        if attachment then
            local parentAttachment = findAttachment(parentPart, attachment.Name)
            if parentAttachment then
                weldParts(parentPart, handle, parentAttachment.CFrame, attachment.CFrame)
            end
        else
            local parent = character:FindFirstChild(parentPart.Name)
            if parent then
                local attachmentPoint = accessory.AttachmentPoint
                weldParts(parent, handle, CFrame.new(0, 0.5, 0), attachmentPoint.CFrame)
            end
        end
    end

    accessory.Parent = game.Players.LocalPlayer.Character
end

local function onCharacterAdded(character)
    wait(getgenv().Time) -- Wait for the character to fully load

    for _, accessoryId in ipairs(getgenv().Head) do
        addAccessoryToCharacter(accessoryId, character.Head)
    end

    for _, accessoryId in ipairs(getgenv().Torso) do
        addAccessoryToCharacter(accessoryId, character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end
end)

tab.newButton("Midnight Blue Sparkle Time Fedora", "Click to equip", function()
    
getgenv().Time = 1 -- Adjust the time waited before adding the items

getgenv().Head = {
    119916949,
    0000000000
    -- Add more head accessory IDs
}

getgenv().Torso = {
    0000000000
    -- Add more torso accessory IDs
}

--//------------------------------------------------------------------------------------------\\--

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
    for _, descendant in pairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart)
    local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    local character = game.Players.LocalPlayer.Character

    accessory.Parent = game.Workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        if attachment then
            local parentAttachment = findAttachment(parentPart, attachment.Name)
            if parentAttachment then
                weldParts(parentPart, handle, parentAttachment.CFrame, attachment.CFrame)
            end
        else
            local parent = character:FindFirstChild(parentPart.Name)
            if parent then
                local attachmentPoint = accessory.AttachmentPoint
                weldParts(parent, handle, CFrame.new(0, 0.5, 0), attachmentPoint.CFrame)
            end
        end
    end

    accessory.Parent = game.Players.LocalPlayer.Character
end

local function onCharacterAdded(character)
    wait(getgenv().Time) -- Wait for the character to fully load

    for _, accessoryId in ipairs(getgenv().Head) do
        addAccessoryToCharacter(accessoryId, character.Head)
    end

    for _, accessoryId in ipairs(getgenv().Torso) do
        addAccessoryToCharacter(accessoryId, character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end
end)


tab.newButton("Green Sparkle Time Fedora", "Click to equip", function()
    
getgenv().Time = 1 -- Adjust the time waited before adding the items

getgenv().Head = {
    100929604,
    0000000000
    -- Add more head accessory IDs
}

getgenv().Torso = {
    0000000000
    -- Add more torso accessory IDs
}

--//------------------------------------------------------------------------------------------\\--

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
    for _, descendant in pairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart)
    local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    local character = game.Players.LocalPlayer.Character

    accessory.Parent = game.Workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        if attachment then
            local parentAttachment = findAttachment(parentPart, attachment.Name)
            if parentAttachment then
                weldParts(parentPart, handle, parentAttachment.CFrame, attachment.CFrame)
            end
        else
            local parent = character:FindFirstChild(parentPart.Name)
            if parent then
                local attachmentPoint = accessory.AttachmentPoint
                weldParts(parent, handle, CFrame.new(0, 0.5, 0), attachmentPoint.CFrame)
            end
        end
    end

    accessory.Parent = game.Players.LocalPlayer.Character
end

local function onCharacterAdded(character)
    wait(getgenv().Time) -- Wait for the character to fully load

    for _, accessoryId in ipairs(getgenv().Head) do
        addAccessoryToCharacter(accessoryId, character.Head)
    end

    for _, accessoryId in ipairs(getgenv().Torso) do
        addAccessoryToCharacter(accessoryId, character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end
end)


tab.newButton("Black Sparkle Time Fedora", "Click to equip", function()
    
getgenv().Time = 1 -- Adjust the time waited before adding the items

getgenv().Head = {
    74891470,
    0000000000
    -- Add more head accessory IDs
}

getgenv().Torso = {
    0000000000
    -- Add more torso accessory IDs
}

--//------------------------------------------------------------------------------------------\\--

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
    for _, descendant in pairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart)
    local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    local character = game.Players.LocalPlayer.Character

    accessory.Parent = game.Workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        if attachment then
            local parentAttachment = findAttachment(parentPart, attachment.Name)
            if parentAttachment then
                weldParts(parentPart, handle, parentAttachment.CFrame, attachment.CFrame)
            end
        else
            local parent = character:FindFirstChild(parentPart.Name)
            if parent then
                local attachmentPoint = accessory.AttachmentPoint
                weldParts(parent, handle, CFrame.new(0, 0.5, 0), attachmentPoint.CFrame)
            end
        end
    end

    accessory.Parent = game.Players.LocalPlayer.Character
end

local function onCharacterAdded(character)
    wait(getgenv().Time) -- Wait for the character to fully load

    for _, accessoryId in ipairs(getgenv().Head) do
        addAccessoryToCharacter(accessoryId, character.Head)
    end

    for _, accessoryId in ipairs(getgenv().Torso) do
        addAccessoryToCharacter(accessoryId, character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end
end)



tab.newButton("White Sparkle Time Fedora", "Click to equip", function()
    
getgenv().Time = 1 -- Adjust the time waited before adding the items

getgenv().Head = {
    74891470,
    0000000000
    -- Add more head accessory IDs
}

getgenv().Torso = {
    0000000000
    -- Add more torso accessory IDs
}

--//------------------------------------------------------------------------------------------\\--

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
    for _, descendant in pairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart)
    local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    local character = game.Players.LocalPlayer.Character

    accessory.Parent = game.Workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        if attachment then
            local parentAttachment = findAttachment(parentPart, attachment.Name)
            if parentAttachment then
                weldParts(parentPart, handle, parentAttachment.CFrame, attachment.CFrame)
            end
        else
            local parent = character:FindFirstChild(parentPart.Name)
            if parent then
                local attachmentPoint = accessory.AttachmentPoint
                weldParts(parent, handle, CFrame.new(0, 0.5, 0), attachmentPoint.CFrame)
            end
        end
    end

    accessory.Parent = game.Players.LocalPlayer.Character
end

local function onCharacterAdded(character)
    wait(getgenv().Time) -- Wait for the character to fully load

    for _, accessoryId in ipairs(getgenv().Head) do
        addAccessoryToCharacter(accessoryId, character.Head)
    end

    for _, accessoryId in ipairs(getgenv().Torso) do
        addAccessoryToCharacter(accessoryId, character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end
end)

tab.newButton("Red Sparkle Time Fedora", "Click to equip", function()
    
getgenv().Time = 1 -- Adjust the time waited before adding the items

getgenv().Head = {
    72082328,
    0000000000
    -- Add more head accessory IDs
}

getgenv().Torso = {
    0000000000
    -- Add more torso accessory IDs
}

--//------------------------------------------------------------------------------------------\\--

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
    for _, descendant in pairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart)
    local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    local character = game.Players.LocalPlayer.Character

    accessory.Parent = game.Workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        if attachment then
            local parentAttachment = findAttachment(parentPart, attachment.Name)
            if parentAttachment then
                weldParts(parentPart, handle, parentAttachment.CFrame, attachment.CFrame)
            end
        else
            local parent = character:FindFirstChild(parentPart.Name)
            if parent then
                local attachmentPoint = accessory.AttachmentPoint
                weldParts(parent, handle, CFrame.new(0, 0.5, 0), attachmentPoint.CFrame)
            end
        end
    end

    accessory.Parent = game.Players.LocalPlayer.Character
end

local function onCharacterAdded(character)
    wait(getgenv().Time) -- Wait for the character to fully load

    for _, accessoryId in ipairs(getgenv().Head) do
        addAccessoryToCharacter(accessoryId, character.Head)
    end

    for _, accessoryId in ipairs(getgenv().Torso) do
        addAccessoryToCharacter(accessoryId, character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end
end)

tab.newButton("Purple Sparkle Time Fedora", "Click to equip", function()
    
getgenv().Time = 1 -- Adjust the time waited before adding the items

getgenv().Head = {
    63043890,
    0000000000
    -- Add more head accessory IDs
}

getgenv().Torso = {
    0000000000
    -- Add more torso accessory IDs
}

--//------------------------------------------------------------------------------------------\\--

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
    for _, descendant in pairs(rootPart:GetDescendants()) do
        if descendant:IsA("Attachment") and descendant.Name == name then
            return descendant
        end
    end
end

local function addAccessoryToCharacter(accessoryId, parentPart)
    local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
    local character = game.Players.LocalPlayer.Character

    accessory.Parent = game.Workspace

    local handle = accessory:FindFirstChild("Handle")
    if handle then
        local attachment = handle:FindFirstChildOfClass("Attachment")
        if attachment then
            local parentAttachment = findAttachment(parentPart, attachment.Name)
            if parentAttachment then
                weldParts(parentPart, handle, parentAttachment.CFrame, attachment.CFrame)
            end
        else
            local parent = character:FindFirstChild(parentPart.Name)
            if parent then
                local attachmentPoint = accessory.AttachmentPoint
                weldParts(parent, handle, CFrame.new(0, 0.5, 0), attachmentPoint.CFrame)
            end
        end
    end

    accessory.Parent = game.Players.LocalPlayer.Character
end

local function onCharacterAdded(character)
    wait(getgenv().Time) -- Wait for the character to fully load

    for _, accessoryId in ipairs(getgenv().Head) do
        addAccessoryToCharacter(accessoryId, character.Head)
    end

    for _, accessoryId in ipairs(getgenv().Torso) do
        addAccessoryToCharacter(accessoryId, character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso"))
    end
end

game.Players.LocalPlayer.CharacterAdded:Connect(onCharacterAdded)

if game.Players.LocalPlayer.Character then
    onCharacterAdded(game.Players.LocalPlayer.Character)
end
end)


local tab = DrRayLibrary.newTab("Useful", "ImageIdHere")
tab.newButton("Headless", "Click to equip", function()
    game.Players.LocalPlayer.Character.Head.Transparency = 1
game.Players.LocalPlayer.Character.Head.Transparency = 1
for i,v in pairs(game.Players.LocalPlayer.Character.Head:GetChildren()) do
if (v:IsA("Decal")) then
v.Transparency = 1
end
end
end)

tab.newButton("Korblox", "Click to equip", function()
    local ply = game.Players.LocalPlayer
local chr = ply.Character
chr.RightLowerLeg.MeshId = "902942093"
chr.RightLowerLeg.Transparency = "1"
chr.RightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"
chr.RightUpperLeg.TextureID = "http://roblox.com/asset/?id=902843398"
chr.RightFoot.MeshId = "902942089"
chr.RightFoot.Transparency = "1"
end)

local tab = DrRayLibrary.newTab("Credits", "ImageIdHere")
tab.newButton("Made by @kv8t on discord", "", function()
    print('')
end)

tab.newButton("Everything is cilent sidded (only visable to you)", "", function()
    print('')
end)

tab.newButton("Updating Soon", "", function()
    print('')
end)

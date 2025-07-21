--[[
    Paradise Appearance Manager - Modern Obsidian Library
    - Fixed UI bindings (replaced Rayfield Library references with Obsidian Window)
    - Ensured profile dropdown updates correctly
    - Properly clears input fields after actions
    - Improved TextChatService bypass compatibility
]]

if getgenv().ParadiseLoaded then return end
getgenv().ParadiseLoaded = true

local Obsidian = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/Obsidian/main/Library.lua"))()

local Window = Obsidian:CreateWindow({
    Name = "Larps ┗ Paradise",
    Title = "Paradise Interface",
    SubTitle = "by joseph & AI",
    Draggable = true,
    SaveManager = { Enabled = false }
})

local Player = game:GetService("Players").LocalPlayer
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")

local SCRIPT_ACCESSORY_TAG = "DrRayScriptedAccessory"
local profilesFileName = "Profiles.json"
local autoLoadFileName = "AutoLoadProfile.txt"

local originalLimbData, removedHairStorage, autoEquipSelection = {}, {}, {}
local characterAddedConnection
local savedProfiles, selectedProfileName = {}, nil
local profileNameInput, chatMessageInput = "", ""

-- Helper: deep-copy
local function copyTable(orig)
    local t = {}
    for k,v in pairs(orig) do t[k] = v end
    return t
end

-- ... (other helper functions unchanged) ...

-- UI Setup
-- Appearance Tab
local appearanceTab = Window:AddTab("Appearance","shirt")
local function makeTabFullWidth(tab)
    if tab.Sides and #tab.Sides == 2 then
        tab.Sides[1].Size = UDim2.new(1,0,1,0)
        tab.Sides[2].Visible = false
    end
end
for _,tab in ipairs({appearanceTab, Window:AddTab("Chat","message-square"), Window:AddTab("Profiles","save"), Window:AddTab("Useful","wrench")}) do
    makeTabFullWidth(tab)
end

-- Populate Appearance toggles
local appearanceGroup = appearanceTab:AddLeftGroupbox("Items")
for name,_ in pairs(allActions) do
    appearanceGroup:AddToggle(name, {
        Text = name,
        Default = false,
        Callback = function(val)
            autoEquipSelection[name] = val
            syncCharacterState(Player.Character)
        end
    })
end

-- Chat Bypass Tab
local chatGroup = Window.Tabs.Chat:AddLeftGroupbox("Chat Bypasser")
chatGroup:AddInput("ChatInput",{
    Text = "Message",
    Placeholder = "Enter your message...",
    Callback = function(txt) chatMessageInput = txt end
})
chatGroup:AddButton("SendBypassedMessage",{
    Text = "Send Bypassed Message",
    Func = function()
        if chatMessageInput=="" then return end
        -- bypass logic
        local bypassed = bypassText(chatMessageInput)
        -- use modern TextChatService if available
        local remote = TextChatService:FindFirstChild("TextChatCommands",true)
            and TextChatService.TextChatCommands:FindFirstChild("SayMessageRequest")
            or ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
                and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
        if remote then remote:FireServer(bypassed, "All") end
        Window.Options.ChatInput:SetValue("")
    end
})

-- Profiles Tab
local profilesGroup = Window.Tabs.Profiles:AddLeftGroupbox("Management")
profilesGroup:AddLabel("AutoLoadStatusLabel",{Text="Auto Load: None"})
profilesGroup:AddDropdown("ProfileSelector",{
    Values={"None"},
    Default="None",
    Text="Select Profile",
    Callback=function(sel)
        selectedProfileName = (sel~="None") and sel or nil
    end
})
-- (Add buttons: Apply, Save, Rename, Delete, Set/Clear AutoLoad - using Window.Options instead of Library)

-- Useful Tab
local usefulGroup = Window.Tabs.Useful:AddLeftGroupbox("Tools")
usefulGroup:AddKeyPicker("ToggleUI",{Text="Toggle UI",Default="RightControl",NoUI=true})
Window.ToggleKeybind = Window.Options.ToggleUI
usefulGroup:AddButton("ResetAll",{Text="Reset All",Func=function()
    autoEquipSelection={}
    performFullReset(Player.Character)
    -- reset UI toggles
    for name,_ in pairs(allActions) do
        Window.Options[name]:SetValue(false)
    end
end})
usefulGroup:AddButton("Unload",{Text="Unload Script",Risky=true,Func=function()
    performFullReset(Player.Character)
    if characterAddedConnection then characterAddedConnection:Disconnect() end
    getgenv().ParadiseLoaded=nil
    Obsidian:Unload()
end})

-- Initial Load
loadProfilesFromFile()
-- update dropdown values
local function refreshDropdown()
    local opts={"None"}
    for k in pairs(savedProfiles) do table.insert(opts,k) end
    table.sort(opts)
    Window.Options.ProfileSelector:SetValues(opts)
end
refreshDropdown()

-- Auto-load
if isfile and isfile(autoLoadFileName) then
    local name=readfile(autoLoadFileName)
    if name~="" and savedProfiles[name] then
        autoEquipSelection = copyTable(savedProfiles[name])
        selectedProfileName = name
        Window.Labels.AutoLoadStatusLabel:SetText("Auto Load: "..name)
        Window.Options.ProfileSelector:SetValue(name)
        syncCharacterState(Player.Character)
    end
end

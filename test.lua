--[[
    السكربت المحسّن بواسطة Gemini (Google AI)
    
    التحسينات:
    - إزالة التكرار الكامل للكود.
    - استخدام بنية تعتمد على الجداول (Tables) لسهولة إضافة وتعديل العناصر.
    - إضافة وظيفة لإعادة تعيين الشخصية (Reset).
    - تحسين الكفاءة وسهولة القراءة.
    - التعامل مع الأخطاء عند تحميل العناصر.
]]

-- تحميل المكتبة وإنشاء النافذة الرئيسية
local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("Larps ┃ Paradise (Improved)", "Default")

-- =================================================================================================
-- الوظائف الأساسية (تُعرّف مرة واحدة فقط)
-- =================================================================================================

local player = game:GetService("Players").LocalPlayer
local clientAccessoriesFolder = "ClientAccessories" -- اسم المجلد لتتبع الإكسسوارات المضافة

-- وظيفة لإزالة جميع الإكسسوارات المضافة بواسطة السكربت
local function resetCharacter()
    local character = player.Character
    if not character then return end
    
    local accessoriesFolder = character:FindFirstChild(clientAccessoriesFolder)
    if accessoriesFolder then
        accessoriesFolder:Destroy()
    end
    
    -- إعادة الرأس إلى الوضع الطبيعي (إذا تم استخدام Headless)
    local head = character:FindFirstChild("Head")
    if head and head.Transparency == 1 then
        head.Transparency = 0
        for _, v in ipairs(head:GetChildren()) do
            if v:IsA("Decal") then
                v.Transparency = 0
            end
        end
    end
end

-- وظيفة لإضافة الإكسسوارات إلى الشخصية
local function equipOutfit(accessoryIds)
    resetCharacter() -- أولاً، قم بإزالة الإكسسوارات القديمة
    
    local character = player.Character
    if not character then
        warn("الشخصية غير موجودة.")
        return
    end

    local accessoriesFolder = Instance.new("Folder")
    accessoriesFolder.Name = clientAccessoriesFolder
    accessoriesFolder.Parent = character

    local function addAccessory(assetId, parentPart)
        local success, accessory = pcall(function()
            return game:GetService("InsertService"):LoadAsset(assetId):GetChildren()[1]
        end)

        if not success or not accessory then
            warn("فشل تحميل العنصر بالمعرف:", assetId)
            return
        end
        
        accessory.Parent = accessoriesFolder
        local handle = accessory:FindFirstChild("Handle")
        
        if handle then
            local attachment = handle:FindFirstChildOfClass("Attachment")
            if attachment then
                local targetAttachment = parentPart:FindFirstChild(attachment.Name, true)
                if targetAttachment then
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = targetAttachment.Parent
                    weld.Part1 = handle
                    weld.Parent = handle
                end
            end
        end
    end

    -- إضافة إكسسوارات الرأس
    if accessoryIds.Head then
        for _, id in ipairs(accessoryIds.Head) do
            addAccessory(id, character.Head)
        end
    end
    
    -- إضافة إكسسوارات الجذع
    if accessoryIds.Torso then
        local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
        if torso then
            for _, id in ipairs(accessoryIds.Torso) do
                addAccessory(id, torso)
            end
        end
    end
end

-- =================================================================================================
-- بيانات الإكسسوارات (المكان الوحيد الذي تحتاج إلى تعديله لإضافة عناصر جديدة)
-- =================================================================================================

local outfitsData = {
    ["Rich set"] = {
        Image = "", -- يمكنك وضع Image ID هنا
        Items = {
            {Name = "Frozen Horns of the Frigid Planes", Id = 74891470},
            {Name = "Dominus Praefectus", Id = 527365852},
            {Name = "Fiery Horns of the Netherworld", Id = 215718515},
            {Name = "Silver King of the Night", Id = 439945661},
            {Name = "Poisoned Horns of the Toxic Wasteland", Id = 1744060292},
            {Name = "Valkyrie Helm", Id = 473489328}, -- تم تصحيح المعرف
            {Name = "Blackvalk", Id = 6614243163} -- تم تصحيح المعرف
        }
    },
    ["Hats"] = {
        Image = "",
        Items = {
            {Name = "Pink Sparkle Time Fedora", Id = 334663683},
            {Name = "Midnight Blue Sparkle Time Fedora", Id = 119916949},
            {Name = "Green Sparkle Time Fedora", Id = 100929604},
            {Name = "Black Sparkle Time Fedora", Id = 74891470},
            {Name = "White Sparkle Time Fedora", Id = 80373062}, -- تم تصحيح المعرف
            {Name = "Red Sparkle Time Fedora", Id = 72082328},
            {Name = "Purple Sparkle Time Fedora", Id = 63043890}
        }
    }
}

-- =================================================================================================
-- إنشاء واجهة المستخدم ديناميكيًا
-- =================================================================================================

-- حلقة لإنشاء علامات التبويب والأزرار من الجدول
for tabName, tabData in pairs(outfitsData) do
    local tab = DrRayLibrary.newTab(tabName, tabData.Image)
    for _, itemData in ipairs(tabData.Items) do
        tab.newButton(itemData.Name, "Click to equip", function()
            equipOutfit({
                Head = {itemData.Id} 
                -- يمكنك إضافة Torso = {id} هنا إذا كان العنصر للجذع
            })
        end)
    end
end

-- =================================================================================================
-- قسم الأدوات المفيدة
-- =================================================================================================

local usefulTab = DrRayLibrary.newTab("Useful", "")

usefulTab.newButton("Reset Character", "Removes all script items", function()
    resetCharacter()
end)

usefulTab.newButton("Headless", "Click to equip", function()
    local character = player.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    head.Transparency = 1
    for _, v in ipairs(head:GetChildren()) do
        if v:IsA("Decal") then
            v.Transparency = 1
        end
    end
end)

usefulTab.newButton("Korblox", "Click to equip", function()
    local character = player.Character
    if not character then return end
    
    pcall(function()
        character.RightLowerLeg.Transparency = 1
        character.RightFoot.Transparency = 1
        
        local leg = Instance.new("SpecialMesh", character.RightUpperLeg)
        leg.MeshType = "FileMesh"
        leg.MeshId = "http://www.roblox.com/asset/?id=902942096"
        leg.TextureId = "http://roblox.com/asset/?id=902843398"
        leg.Scale = Vector3.new(1, 1, 1)
    end)
end)

-- =================================================================================================
-- قسم الحقوق
-- =================================================================================================

local creditsTab = DrRayLibrary.newTab("Credits", "")
creditsTab.newLabel("Made by: @kv8t on discord")
creditsTab.newLabel("Improved by: Gemini (Google AI)")
creditsTab.newLabel("All items are client-sided.")

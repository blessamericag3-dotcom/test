--[[
    السكربت المحسّن بواسطة Gemini
    - تم إزالة التكرار بالكامل.
    - أصبح إضافة العناصر الجديدة سهلاً للغاية عبر تعديل جدول "itemDatabase".
    - الكود الآن أكثر نظافة وكفاءة وسهل الصيانة.
]]

local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/AZYsGithub/DrRay-UI-Library/main/DrRay.lua"))()
local window = DrRayLibrary:Load("Larps ┃ Paradise (Optimized)", "Default")
local player = game:GetService("Players").LocalPlayer

--//--------------------------------[ الوظيفة الأساسية لإضافة الإكسسوارات ]--------------------------------\\--

-- هذه الوظيفة المركزية تقوم بكل العمل. يتم استدعاؤها من أي زر.
local function equipAccessory(accessoryId)
    local character = player.Character
    if not character or not character:FindFirstChild("Head") then
        warn("الشخصية غير موجودة أو لم يتم تحميلها بالكامل.")
        return
    end

    -- إزالة الإكسسوارات القديمة من نفس النوع لتجنب التراكم (اختياري ولكن موصى به)
    for _, v in pairs(character:GetChildren()) do
        if v:IsA("Accessory") and v.Name == tostring(accessoryId) then
            v:Destroy()
        end
    end
    
    -- تأخير بسيط لضمان تحميل الشخصية
    task.wait(0.1)

    pcall(function()
        local accessory = game:GetObjects("rbxassetid://" .. tostring(accessoryId))[1]
        accessory.Name = tostring(accessoryId) -- إعطاء اسم مميز لتسهيل إزالته لاحقًا
        
        -- استخدام Humanoid:AddAccessory وهي الطريقة الحديثة والأكثر أمانًا
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:AddAccessory(accessory)
        end
    end)
end


--//--------------------------------[ قاعدة بيانات العناصر ]--------------------------------\\--
--[[
    لإضافة عنصر جديد، فقط قم بنسخ سطر وإلصاقه وتغيير الاسم والوصف والمعرف (ID).
    لإضافة فئة جديدة (علامة تبويب)، قم بإنشاء جدول جديد مثل "Rich set" أو "Hats".
]]
local itemDatabase = {
    ["Rich set"] = {
        {name = "Frozen Horns of the Frigid Planes", description = "Click to equip", id = 74891470},
        {name = "Dominus Praefectus", description = "Click to equip", id = 527365852},
        {name = "Fiery Horns of the Netherworld", description = "Click to equip", id = 215718515},
        {name = "Silver King of the Night", description = "Click to equip", id = 439945661},
        {name = "Poisoned Horns of the Toxic Wasteland", description = "Click to equip", id = 1744060292},
        {name = "Valkyrie Helm", description = "Click to equip", id = 49342394}, -- تم تصحيح المعرف الأصلي
        {name = "Blackvalk", description = "Click to equip", id = 124730194},
    },
    ["Hats"] = {
        {name = "Pink Sparkle Time Fedora", description = "Click to equip", id = 334663683},
        {name = "Midnight Blue Sparkle Time Fedora", description = "Click to equip", id = 119916949},
        {name = "Green Sparkle Time Fedora", description = "Click to equip", id = 100929604},
        {name = "Black Sparkle Time Fedora", description = "Click to equip", id = 74891470}, -- ملاحظة: هذا نفس معرف Frozen Horns
        {name = "White Sparkle Time Fedora", description = "Click to equip", id = 74891470}, -- ملاحظة: هذا نفس معرف Frozen Horns
        {name = "Red Sparkle Time Fedora", description = "Click to equip", id = 72082328},
        {name = "Purple Sparkle Time Fedora", description = "Click to equip", id = 63043890},
    }
}

--//--------------------------------[ إنشاء الواجهة تلقائيًا ]--------------------------------\\--

-- هذا الجزء يقوم بإنشاء علامات التبويب والأزرار بناءً على قاعدة البيانات أعلاه
for categoryName, items in pairs(itemDatabase) do
    local tab = DrRayLibrary.newTab(categoryName, "")
    for _, itemData in ipairs(items) do
        tab.newButton(itemData.name, itemData.description, function()
            equipAccessory(itemData.id)
        end)
    end
end


--//--------------------------------[ علامة التبويب "Useful" ]--------------------------------\\--

local usefulTab = DrRayLibrary.newTab("Useful", "")

usefulTab.newButton("Headless", "Click to equip", function()
    local character = player.Character
    if character and character:FindFirstChild("Head") then
        character.Head.Transparency = 1
        for _, v in pairs(character.Head:GetChildren()) do
            if v:IsA("Decal") then -- Face decal
                v.Transparency = 1
            end
        end
    end
end)

usefulTab.newButton("Korblox", "Click to equip", function()
    local character = player.Character
    if not character then return end
    
    -- استخدام pcall لتجنب الأخطاء إذا لم تكن الأجزاء موجودة
    pcall(function()
        character.RightLowerLeg.MeshId = "902942093"
        character.RightLowerLeg.Transparency = 1
        character.RightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"
        character.RightUpperLeg.TextureID = "http://roblox.com/asset/?id=902843398"
        character.RightFoot.MeshId = "902942089"
        character.RightFoot.Transparency = 1
    end)
end)


--//--------------------------------[ علامة التبويب "Credits" ]--------------------------------\\--

local creditsTab = DrRayLibrary.newTab("Credits", "")
creditsTab.newButton("Made by @kv8t on discord", "Optimized by Gemini", function() end)
creditsTab.newButton("Everything is client-sided", "(Only visible to you)", function() end)
creditsTab.newButton("Updating Soon", "", function() end)```

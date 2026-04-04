-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "Auto Farm | by Quoc Hoa",
    Image = "rbxassetid://76048047842530"
})

-- ==================== TẠO TAB ====================
local farmTab = window:AddTab("🌾 Farming")
local masteryTab = window:AddTab("🔰 Mastery")
local settingTab = window:AddTab("⚙️ Settings")

-- ==================== BIẾN TRẠNG THÁI ====================
_G.DistanceFarm = false
_G.Aura = false
_G.IgnoreKatakuri = false
_G.HopFindKatakuri = false
_G.AutoQuest = false
_G.StartFarm = false
_G.MasteryFarm = false
_G.MasteryFruit = false

-- Hàm thông báo
function Notify(title, text)
    game.StarterGui:SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2
    })
end

-- ==================== GROUP: SELECT METHOD FARM ====================
local methodGroup = farmTab:AddLeftGroupbox("📋 Select Method Farm")

-- Nút Distance Farm (dạng checkbox)
methodGroup:AddButton({
    Title = "☐ 📏 Distance Farm",
    Callback = function(btn)
        _G.DistanceFarm = not _G.DistanceFarm
        if _G.DistanceFarm then
            btn:SetTitle("☑ 📏 Distance Farm")
            Notify("Distance Farm", "✅ ĐÃ BẬT")
        else
            btn:SetTitle("☐ 📏 Distance Farm")
            Notify("Distance Farm", "❌ ĐÃ TẮT")
        end
    end
})

-- Nút Aura (dạng checkbox)
methodGroup:AddButton({
    Title = "☐ ✨ Aura",
    Callback = function(btn)
        _G.Aura = not _G.Aura
        if _G.Aura then
            btn:SetTitle("☑ ✨ Aura")
            Notify("Aura", "✅ ĐÃ BẬT")
        else
            btn:SetTitle("☐ ✨ Aura")
            Notify("Aura", "❌ ĐÃ TẮT")
        end
    end
})

-- Nút Ignore Attack Katakuri
methodGroup:AddButton({
    Title = "☐ 🚫 Ignore Attack Katakuri",
    Callback = function(btn)
        _G.IgnoreKatakuri = not _G.IgnoreKatakuri
        if _G.IgnoreKatakuri then
            btn:SetTitle("☑ 🚫 Ignore Attack Katakuri")
            Notify("Ignore Attack Katakuri", "✅ ĐÃ BẬT")
        else
            btn:SetTitle("☐ 🚫 Ignore Attack Katakuri")
            Notify("Ignore Attack Katakuri", "❌ ĐÃ TẮT")
        end
    end
})

-- Nút Hop Find Katakuri
methodGroup:AddButton({
    Title = "☐ 🔄 Hop Find Katakuri",
    Callback = function(btn)
        _G.HopFindKatakuri = not _G.HopFindKatakuri
        if _G.HopFindKatakuri then
            btn:SetTitle("☑ 🔄 Hop Find Katakuri")
            Notify("Hop Find Katakuri", "✅ ĐÃ BẬT")
        else
            btn:SetTitle("☐ 🔄 Hop Find Katakuri")
            Notify("Hop Find Katakuri", "❌ ĐÃ TẮT")
        end
    end
})

-- Nút Auto Quest
methodGroup:AddButton({
    Title = "☐ 📜 Auto Quest [Katakuri/Bone/Tyrant]",
    Callback = function(btn)
        _G.AutoQuest = not _G.AutoQuest
        if _G.AutoQuest then
            btn:SetTitle("☑ 📜 Auto Quest [Katakuri/Bone/Tyrant]")
            Notify("Auto Quest", "✅ ĐÃ BẬT")
        else
            btn:SetTitle("☐ 📜 Auto Quest [Katakuri/Bone/Tyrant]")
            Notify("Auto Quest", "❌ ĐÃ TẮT")
        end
    end
})

-- Nút Start Farm
methodGroup:AddButton({
    Title = "☐ ▶️ Start Farm",
    Callback = function(btn)
        _G.StartFarm = not _G.StartFarm
        if _G.StartFarm then
            btn:SetTitle("☑ ▶️ Start Farm")
            Notify("Start Farm", "✅ ĐÃ BẬT - Bắt đầu farm!")
        else
            btn:SetTitle("☐ ▶️ Start Farm")
            Notify("Start Farm", "❌ ĐÃ TẮT - Dừng farm!")
        end
    end
})

-- ==================== GROUP: MASTERY FARM ====================
local masteryGroup = masteryTab:AddLeftGroupbox("🔰 Mastery Farm")

-- Nút Mastery Farm
masteryGroup:AddButton({
    Title = "☐ ⚔️ Mastery Farm",
    Callback = function(btn)
        _G.MasteryFarm = not _G.MasteryFarm
        if _G.MasteryFarm then
            btn:SetTitle("☑ ⚔️ Mastery Farm")
            Notify("Mastery Farm", "✅ ĐÃ BẬT")
        else
            btn:SetTitle("☐ ⚔️ Mastery Farm")
            Notify("Mastery Farm", "❌ ĐÃ TẮT")
        end
    end
})

-- Nút Mastery Fruit
masteryGroup:AddButton({
    Title = "☐ 🍎 Mastery Fruit",
    Callback = function(btn)
        _G.MasteryFruit = not _G.MasteryFruit
        if _G.MasteryFruit then
            btn:SetTitle("☑ 🍎 Mastery Fruit")
            Notify("Mastery Fruit", "✅ ĐÃ BẬT")
        else
            btn:SetTitle("☐ 🍎 Mastery Fruit")
            Notify("Mastery Fruit", "❌ ĐÃ TẮT")
        end
    end
})

-- ==================== GROUP: SETTINGS ====================
local settingGroup = settingTab:AddLeftGroupbox("⚙️ Cài Đặt")

_G.TweenSpeed = 350
_G.AttackDelay = 0.08
_G.FlyHeight = 10

-- Thanh trượt tốc độ bay
settingGroup:AddSlider({
    Title = "🚀 Tốc độ bay",
    Min = 200,
    Max = 500,
    Default = 350,
    Callback = function(v)
        _G.TweenSpeed = v
        Notify("Tốc độ bay", tostring(v))
    end
})

-- Thanh trượt delay đánh
settingGroup:AddSlider({
    Title = "⚔️ Delay đánh",
    Min = 0.05,
    Max = 0.3,
    Default = 0.08,
    Decimal = true,
    Callback = function(v)
        _G.AttackDelay = v
        Notify("Delay đánh", tostring(v))
    end
})

-- Thanh trượt độ cao bay
settingGroup:AddSlider({
    Title = "🗻 Độ cao bay",
    Min = 5,
    Max = 20,
    Default = 10,
    Callback = function(v)
        _G.FlyHeight = v
        Notify("Độ cao bay", tostring(v))
    end
})

-- Nút Reset tất cả
settingGroup:AddButton({
    Title = "🔄 RESET ALL",
    Callback = function()
        _G.DistanceFarm = false
        _G.Aura = false
        _G.IgnoreKatakuri = false
        _G.HopFindKatakuri = false
        _G.AutoQuest = false
        _G.StartFarm = false
        _G.MasteryFarm = false
        _G.MasteryFruit = false
        
        -- Cập nhật lại tên các nút (cần lưu lại reference)
        Notify("RESET", "Đã reset tất cả về TẮT!")
    end
})

-- ==================== HIỂN THỊ UI ====================
UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ APPLE HUB PREMIUM - UI CHECKBOX BẰNG BUTTON!")
print("📌 Mỗi lần bấm nút sẽ đổi ☐ thành ☑ và ngược lại")
print("📌 Có thông báo hiện trên màn hình")
print("=" .. string.rep("=", 50)) 

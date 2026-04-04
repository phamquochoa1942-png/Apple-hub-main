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

-- ==================== GROUP: SELECT METHOD FARM ====================
local methodGroup = farmTab:AddLeftGroupbox("📋 Select Method Farm")

-- Biến trạng thái
_G.DistanceFarm = false
_G.Aura = false
_G.IgnoreKatakuri = false
_G.HopFindKatakuri = false
_G.AutoQuest = false
_G.StartFarm = false

-- ✅ Nút Distance Farm (Toggle dạng checkbox)
methodGroup:AddToggle({
    Title = "📏 Distance Farm",
    Default = false,
    Callback = function(value)
        _G.DistanceFarm = value
        print("📏 Distance Farm:", value and "BẬT" or "TẮT")
    end
})

-- ✅ Nút Aura (Toggle dạng checkbox)
methodGroup:AddToggle({
    Title = "✨ Aura",
    Default = false,
    Callback = function(value)
        _G.Aura = value
        print("✨ Aura:", value and "BẬT" or "TẮT")
    end
})

-- ✅ Nút Ignore Attack Katakuri
methodGroup:AddToggle({
    Title = "🚫 Ignore Attack Katakuri",
    Default = false,
    Callback = function(value)
        _G.IgnoreKatakuri = value
        print("🚫 Ignore Attack Katakuri:", value and "BẬT" or "TẮT")
    end
})

-- ✅ Nút Hop Find Katakuri
methodGroup:AddToggle({
    Title = "🔄 Hop Find Katakuri",
    Default = false,
    Callback = function(value)
        _G.HopFindKatakuri = value
        print("🔄 Hop Find Katakuri:", value and "BẬT" or "TẮT")
    end
})

-- ✅ Nút Auto Quest
methodGroup:AddToggle({
    Title = "📜 Auto Quest [Katakuri/Bone/Tyrant]",
    Default = false,
    Callback = function(value)
        _G.AutoQuest = value
        print("📜 Auto Quest:", value and "BẬT" or "TẮT")
    end
})

-- ✅ Nút Start Farm (Toggle quan trọng)
methodGroup:AddToggle({
    Title = "▶️ Start Farm",
    Default = false,
    Callback = function(value)
        _G.StartFarm = value
        if value then
            print("✅ START FARM - Bắt đầu farm!")
        else
            print("⏸️ STOP FARM - Dừng farm!")
        end
    end
})

-- ==================== GROUP: MASTERY FARM ====================
local masteryGroup = masteryTab:AddLeftGroupbox("🔰 Mastery Farm")

_G.MasteryFarm = false
_G.MasteryFruit = false

-- ✅ Nút Mastery Farm
masteryGroup:AddToggle({
    Title = "⚔️ Mastery Farm",
    Default = false,
    Callback = function(value)
        _G.MasteryFarm = value
        print("⚔️ Mastery Farm:", value and "BẬT" or "TẮT")
    end
})

-- ✅ Nút Mastery Fruit
masteryGroup:AddToggle({
    Title = "🍎 Mastery Fruit",
    Default = false,
    Callback = function(value)
        _G.MasteryFruit = value
        print("🍎 Mastery Fruit:", value and "BẬT" or "TẮT")
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
        print("🚀 Tốc độ bay:", v)
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
        print("⚔️ Delay đánh:", v)
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
        print("🗻 Độ cao bay:", v)
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
        print("🔄 Đã RESET tất cả cài đặt!")
    end
})

-- ==================== HIỂN THỊ UI ====================
UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ APPLE HUB PREMIUM - UI ĐÃ SẴN SÀNG!")
print("📌 Các nút đều là TOGGLE (checkbox) như trong ảnh")
print("📌 Bấm vào ô vuông để bật/tắt từng chức năng")
print("📌 Bật 'Start Farm' để bắt đầu farm")
print("=" .. string.rep("=", 50)) 

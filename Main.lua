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

-- Nút Distance Farm (Toggle)
methodGroup:AddToggle({
    Title = "📏 Distance Farm",
    Default = false,
    Callback = function(value)
        _G.DistanceFarm = value
        print("[TEST] Distance Farm:", value and "✅ BẬT" or "❌ TẮT")
    end
})

-- Nút Aura (Toggle)
methodGroup:AddToggle({
    Title = "✨ Aura",
    Default = false,
    Callback = function(value)
        _G.Aura = value
        print("[TEST] Aura:", value and "✅ BẬT" or "❌ TẮT")
    end
})

-- Nút Ignore Attack Katakuri (Toggle)
methodGroup:AddToggle({
    Title = "🚫 Ignore Attack Katakuri",
    Default = false,
    Callback = function(value)
        _G.IgnoreKatakuri = value
        print("[TEST] Ignore Attack Katakuri:", value and "✅ BẬT" or "❌ TẮT")
    end
})

-- Nút Hop Find Katakuri (Toggle)
methodGroup:AddToggle({
    Title = "🔄 Hop Find Katakuri",
    Default = false,
    Callback = function(value)
        _G.HopFindKatakuri = value
        print("[TEST] Hop Find Katakuri:", value and "✅ BẬT" or "❌ TẮT")
    end
})

-- Nút Auto Quest (Toggle)
methodGroup:AddToggle({
    Title = "📜 Auto Quest [Katakuri/Bone/Tyrant]",
    Default = false,
    Callback = function(value)
        _G.AutoQuest = value
        print("[TEST] Auto Quest:", value and "✅ BẬT" or "❌ TẮT")
    end
})

-- Nút Start Farm (Toggle)
methodGroup:AddToggle({
    Title = "▶️ Start Farm",
    Default = false,
    Callback = function(value)
        _G.StartFarm = value
        if value then
            print("[TEST] ✅ START FARM - ĐÃ BẬT!")
        else
            print("[TEST] ❌ STOP FARM - ĐÃ TẮT!")
        end
    end
})

-- ==================== GROUP: MASTERY FARM ====================
local masteryGroup = masteryTab:AddLeftGroupbox("🔰 Mastery Farm")

_G.MasteryFarm = false
_G.MasteryFruit = false

-- Nút Mastery Farm (Toggle)
masteryGroup:AddToggle({
    Title = "⚔️ Mastery Farm",
    Default = false,
    Callback = function(value)
        _G.MasteryFarm = value
        print("[TEST] Mastery Farm:", value and "✅ BẬT" or "❌ TẮT")
    end
})

-- Nút Mastery Fruit (Toggle)
masteryGroup:AddToggle({
    Title = "🍎 Mastery Fruit",
    Default = false,
    Callback = function(value)
        _G.MasteryFruit = value
        print("[TEST] Mastery Fruit:", value and "✅ BẬT" or "❌ TẮT")
    end
})

-- ==================== GROUP: SETTINGS ====================
local settingGroup = settingTab:AddLeftGroupbox("⚙️ Cài Đặt")

-- Thanh trượt tốc độ bay
settingGroup:AddSlider({
    Title = "🚀 Tốc độ bay",
    Min = 200,
    Max = 500,
    Default = 350,
    Callback = function(v)
        _G.TweenSpeed = v
        print("[TEST] Tốc độ bay:", v)
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
        print("[TEST] Delay đánh:", v)
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
        print("[TEST] Độ cao bay:", v)
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
        print("[TEST] 🔄 ĐÃ RESET TẤT CẢ!")
    end
})

-- ==================== HIỂN THỊ UI ====================
UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ APPLE HUB PREMIUM - UI ĐÃ SẴN SÀNG!")
print("📌 Các nút toggle có chức năng bật/tắt test")
print("📌 Bấm F9 để xem console in ra trạng thái")
print("📌 Slider có thể kéo để test")
print("=" .. string.rep("=", 50))

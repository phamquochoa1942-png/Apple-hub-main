-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "by Quoc Hoa",
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

-- ==================== GROUP: SELECT METHOD FARM ====================
local methodGroup = farmTab:AddLeftGroupbox("📋 Select Method Farm")

-- Nút Distance Farm
methodGroup:AddButton({
    Title = "📏 Distance Farm",
    Callback = function()
        _G.DistanceFarm = not _G.DistanceFarm
        print("[Distance Farm]:", _G.DistanceFarm and "✅ BẬT" or "❌ TẮT")
    end
})

-- Nút Aura
methodGroup:AddButton({
    Title = "✨ Aura",
    Callback = function()
        _G.Aura = not _G.Aura
        print("[Aura]:", _G.Aura and "✅ BẬT" or "❌ TẮT")
    end
})

-- Nút Ignore Attack Katakuri
methodGroup:AddButton({
    Title = "🚫 Ignore Attack Katakuri",
    Callback = function()
        _G.IgnoreKatakuri = not _G.IgnoreKatakuri
        print("[Ignore Attack Katakuri]:", _G.IgnoreKatakuri and "✅ BẬT" or "❌ TẮT")
    end
})

-- Nút Hop Find Katakuri
methodGroup:AddButton({
    Title = "🔄 Hop Find Katakuri",
    Callback = function()
        _G.HopFindKatakuri = not _G.HopFindKatakuri
        print("[Hop Find Katakuri]:", _G.HopFindKatakuri and "✅ BẬT" or "❌ TẮT")
    end
})

-- Nút Auto Quest
methodGroup:AddButton({
    Title = "📜 Auto Quest [Katakuri/Bone/Tyrant]",
    Callback = function()
        _G.AutoQuest = not _G.AutoQuest
        print("[Auto Quest]:", _G.AutoQuest and "✅ BẬT" or "❌ TẮT")
    end
})

-- Nút Start Farm
methodGroup:AddButton({
    Title = "▶️ Start Farm",
    Callback = function()
        _G.StartFarm = not _G.StartFarm
        if _G.StartFarm then
            print("[Start Farm]: ✅ ĐÃ BẬT - Bắt đầu farm!")
        else
            print("[Start Farm]: ❌ ĐÃ TẮT - Dừng farm!")
        end
    end
})

-- ==================== GROUP: MASTERY FARM ====================
local masteryGroup = masteryTab:AddLeftGroupbox("🔰 Mastery Farm")

-- Nút Mastery Farm
masteryGroup:AddButton({
    Title = "⚔️ Mastery Farm",
    Callback = function()
        _G.MasteryFarm = not _G.MasteryFarm
        print("[Mastery Farm]:", _G.MasteryFarm and "✅ BẬT" or "❌ TẮT")
    end
})

-- Nút Mastery Fruit
masteryGroup:AddButton({
    Title = "🍎 Mastery Fruit",
    Callback = function()
        _G.MasteryFruit = not _G.MasteryFruit
        print("[Mastery Fruit]:", _G.MasteryFruit and "✅ BẬT" or "❌ TẮT")
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
        print("[Tốc độ bay]:", v)
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
        print("[Delay đánh]:", v)
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
        print("[Độ cao bay]:", v)
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
        print("[RESET]: 🔄 Đã reset tất cả về TẮT!")
    end
})

-- ==================== HIỂN THỊ UI ====================
UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ APPLE HUB PREMIUM - UI ĐÃ SẴN SÀNG!")
print("📌 Bấm F9 để xem console in ra trạng thái")
print("📌 Mỗi lần bấm nút sẽ bật/tắt chức năng")
print("📌 Slider có thể kéo để điều chỉnh")
print("=" .. string.rep("=", 50)) 

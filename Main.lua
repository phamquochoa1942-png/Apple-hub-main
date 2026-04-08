-- ==========================================
-- 🧠 BLOX FRUITS AUTO FARM ARCHITECTURE
-- ✅ Mobile Optimized | ✅ pcall Safe | ✅ TweenService | ✅ Data-Driven Quest
-- 📌 Framework học thuật - Không bypass server validation
-- ==========================================

-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "Auto Farm 1-2800 | by Quoc Hoa",
    Image = "rbxassetid://76048047842530"
})

-- ==================== TẠO TAB ====================
local farmTab = window:AddTab("🌾 Farming")
local settingTab = window:AddTab("⚙️ Settings")

-- ==================== SERVICE ====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- ==================== BIẾN TOÀN CỤC ====================
_G.AutoFarm = false
_G.BringMob = true
_G.AutoHaki = true
_G.TweenSpeed = 65
_G.AttackDelay = 0.25
_G.FlyHeight = 8
_G.GatherRadius = 20

-- ==================== CẤU HÌNH HỆ THỐNG ====================
local Config = {
    FlyOffset = CFrame.new(0, _G.FlyHeight, 0),
    TweenSpeed = 65,
    GatherRadius = 20,
    AttackInterval = 0.25,
    SeaThresholds = {700, 1500},
    CacheRefreshRate = 3,
    MaxLoopFPS = 15
}

-- ==================== BẢNG DỮ LIỆU QUEST ====================
local QuestDatabase = {
    -- SEA 1
    {1, 10, 1, "Bandit", "Bandit", Vector3.new(1120, 13, 1450), Vector3.new(1100, 13, 1480)},
    {11, 20, 1, "Monkey", "Monkey", Vector3.new(-1177, 68, 292), Vector3.new(-1200, 68, 320)},
    {21, 30, 1, "Pirate", "Pirate", Vector3.new(2677, 28, 180), Vector3.new(2650, 28, 200)},
    {31, 40, 1, "Brute", "Brute", Vector3.new(2865, 29, 482), Vector3.new(2840, 29, 510)},
    {41, 50, 1, "Viking", "Viking", Vector3.new(249, 51, 435), Vector3.new(220, 51, 460)},
    {51, 70, 1, "SnowTrooper", "SnowTrooper", Vector3.new(873, 114, -1269), Vector3.new(850, 114, -1290)},
    {71, 85, 1, "ChiefPettyOfficer", "ChiefPettyOfficer", Vector3.new(-438, 18, 618), Vector3.new(-460, 18, 640)},
    {86, 100, 1, "SkyBandit", "SkyBandit", Vector3.new(-4838, 721, -2660), Vector3.new(-4860, 721, -2680)},
    {101, 120, 1, "DarkMaster", "DarkMaster", Vector3.new(-5174, 593, -2759), Vector3.new(-5200, 593, -2780)},
    {121, 140, 1, "Toga", "Toga", Vector3.new(-5236, 817, -3103), Vector3.new(-5260, 817, -3120)},
    {141, 160, 1, "Fishman", "Fishman", Vector3.new(3928, 10, -1032), Vector3.new(3900, 10, -1050)},
    {161, 180, 1, "FishmanCommander", "FishmanCommander", Vector3.new(3904, 12, -1408), Vector3.new(3880, 12, -1430)},
    {181, 210, 1, "GalleyPirate", "GalleyPirate", Vector3.new(5598, 13, 700), Vector3.new(5570, 13, 720)},
    {211, 240, 1, "GalleyCaptain", "GalleyCaptain", Vector3.new(5697, 14, 686), Vector3.new(5670, 14, 710)},
    {241, 270, 1, "Marine", "Marine", Vector3.new(-2937, 12, -2857), Vector3.new(-2960, 12, -2880)},
    {271, 300, 1, "MarineCaptain", "MarineCaptain", Vector3.new(-2936, 13, -2998), Vector3.new(-2960, 13, -3020)},
    {301, 330, 1, "Prisoner", "Prisoner", Vector3.new(5308, 18, 42), Vector3.new(5280, 18, 60)},
    {331, 360, 1, "DangerousPrisoner", "DangerousPrisoner", Vector3.new(5310, 16, 137), Vector3.new(5280, 16, 160)},
    {361, 400, 1, "MilitarySoldier", "MilitarySoldier", Vector3.new(-2381, 23, -2352), Vector3.new(-2400, 23, -2370)},
    {401, 450, 1, "MilitarySpy", "MilitarySpy", Vector3.new(-2581, 24, -2485), Vector3.new(-2600, 24, -2500)},
    {451, 500, 1, "SaberExpert", "SaberExpert", Vector3.new(1432, 11, 26), Vector3.new(1410, 11, 50)},
    {501, 550, 1, "GodHuman", "GodHuman", Vector3.new(-4652, 822, -3030), Vector3.new(-4670, 822, -3050)},
    {551, 600, 1, "CursedCaptain", "CursedCaptain", Vector3.new(3637, 17, -354), Vector3.new(3610, 17, -370)},
    {601, 650, 1, "IceAdmiral", "IceAdmiral", Vector3.new(1562, 13, 433), Vector3.new(1540, 13, 450)},
    {651, 700, 1, "MagmaNinja", "MagmaNinja", Vector3.new(-5718, 9, 273), Vector3.new(-5740, 9, 290)},
    -- SEA 2
    {701, 725, 2, "Raider", "Raider", Vector3.new(771, 31, 1351), Vector3.new(750, 31, 1370)},
    {726, 750, 2, "Mercenary", "Mercenary", Vector3.new(786, 32, 1172), Vector3.new(760, 32, 1190)},
    {751, 775, 2, "SwanPirate", "SwanPirate", Vector3.new(527, 18, 1406), Vector3.new(500, 18, 1420)},
    {776, 800, 2, "FactoryStaff", "FactoryStaff", Vector3.new(435, 209, -376), Vector3.new(410, 209, -390)},
    {801, 850, 2, "MarineLieutenant", "MarineLieutenant", Vector3.new(-2804, 72, -3342), Vector3.new(-2820, 72, -3360)},
    {851, 900, 2, "MarineCaptain", "MarineCaptain", Vector3.new(-2828, 73, -3497), Vector3.new(-2850, 73, -3510)},
    {901, 950, 2, "Zombie", "Zombie", Vector3.new(-546, 34, -486), Vector3.new(-570, 34, -500)},
    {951, 1000, 2, "Vampire", "Vampire", Vector3.new(-549, 30, -609), Vector3.new(-570, 30, -630)},
    {1001, 1050, 2, "Snowman", "Snowman", Vector3.new(529, 154, -433), Vector3.new(500, 154, -450)},
    {1051, 1100, 2, "SnowTrooper", "SnowTrooper", Vector3.new(705, 158, -543), Vector3.new(680, 158, -560)},
    {1101, 1150, 2, "LabSubordinate", "LabSubordinate", Vector3.new(-4117, 345, -2661), Vector3.new(-4140, 345, -2680)},
    {1151, 1200, 2, "HornedMan", "HornedMan", Vector3.new(-4183, 343, -2788), Vector3.new(-4200, 343, -2800)},
    {1201, 1250, 2, "Diamond", "Diamond", Vector3.new(-1665, 243, 85), Vector3.new(-1680, 243, 100)},
    {1251, 1300, 2, "PirateMilitia", "PirateMilitia", Vector3.new(-1266, 73, 967), Vector3.new(-1280, 73, 980)},
    {1301, 1350, 2, "Gunslinger", "Gunslinger", Vector3.new(-1393, 64, 990), Vector3.new(-1410, 64, 1010)},
    {1351, 1400, 2, "Crewmate", "Crewmate", Vector3.new(-285, 44, 1643), Vector3.new(-300, 44, 1660)},
    {1401, 1450, 2, "Bentham", "Bentham", Vector3.new(-138, 46, 1634), Vector3.new(-160, 46, 1650)},
    {1451, 1525, 2, "DonSwan", "DonSwan", Vector3.new(288, 31, 1629), Vector3.new(260, 31, 1650)},
    -- SEA 3
    {1526, 1575, 3, "Pirate", "Pirate", Vector3.new(-1110, 12, 3870), Vector3.new(-1130, 12, 3890)},
    {1576, 1625, 3, "Brute", "Brute", Vector3.new(-1116, 14, 3966), Vector3.new(-1140, 14, 3980)},
    {1626, 1675, 3, "Gladiator", "Gladiator", Vector3.new(1364, 25, 1190), Vector3.new(1340, 25, 1210)},
    {1676, 1725, 3, "MilitarySoldier", "MilitarySoldier", Vector3.new(1322, 24, 1127), Vector3.new(1300, 24, 1140)},
    {1726, 1775, 3, "Marine", "Marine", Vector3.new(-2620, 198, 3199), Vector3.new(-2640, 198, 3220)},
    {1776, 1825, 3, "MarineCaptain", "MarineCaptain", Vector3.new(-2628, 199, 3316), Vector3.new(-2650, 199, 3330)},
    {1826, 1875, 3, "Thug", "Thug", Vector3.new(-3244, 246, 952), Vector3.new(-3260, 246, 970)},
    {1876, 1925, 3, "Raider", "Raider", Vector3.new(-3256, 247, 832), Vector3.new(-3280, 247, 850)},
    {1926, 1975, 3, "GalleyPirate", "GalleyPirate", Vector3.new(-456, 77, -2960), Vector3.new(-480, 77, -2980)},
    {1976, 2025, 3, "GalleyCaptain", "GalleyCaptain", Vector3.new(-444, 78, -3088), Vector3.new(-470, 78, -3100)},
    {2026, 2075, 3, "Pirate", "Pirate", Vector3.new(5694, 613, -132), Vector3.new(5670, 613, -150)},
    {2076, 2125, 3, "Brute", "Brute", Vector3.new(5782, 614, -192), Vector3.new(5760, 614, -210)},
    {2126, 2175, 3, "Pirate", "Pirate", Vector3.new(-1683, 35, -5038), Vector3.new(-1700, 35, -5060)},
    {2176, 2225, 3, "Brute", "Brute", Vector3.new(-1615, 37, -5117), Vector3.new(-1640, 37, -5140)},
    {2226, 2275, 3, "Firefighter", "Firefighter", Vector3.new(-134, 445, -202), Vector3.new(-160, 445, -220)},
    {2276, 2325, 3, "Scientist", "Scientist", Vector3.new(-76, 444, -219), Vector3.new(-100, 444, -240)},
    {2326, 2375, 3, "Zombie", "Zombie", Vector3.new(-2249, 445, -815), Vector3.new(-2270, 445, -830)},
    {2376, 2425, 3, "Vampire", "Vampire", Vector3.new(-2344, 445, -934), Vector3.new(-2370, 445, -950)},
    {2426, 2475, 3, "Ghost", "Ghost", Vector3.new(-4550, 390, -3672), Vector3.new(-4570, 390, -3690)},
    {2476, 2525, 3, "Reaper", "Reaper", Vector3.new(-4727, 391, -3802), Vector3.new(-4750, 391, -3820)},
    {2526, 2600, 3, "DragonCrew", "DragonCrew", Vector3.new(-5374, 309, -5053), Vector3.new(-5400, 309, -5070)},
    {2601, 2675, 3, "EliteHunter", "EliteHunter", Vector3.new(-5418, 314, -2667), Vector3.new(-5440, 314, -2690)},
    {2676, 2750, 3, "EliteHunter", "EliteHunter", Vector3.new(-5418, 314, -2667), Vector3.new(-5440, 314, -2690)},
    {2751, 2800, 3, "Legendary", "Legendary", Vector3.new(-5500, 320, -2700), Vector3.new(-5520, 320, -2720)},
}

-- ==================== HÀM LẤY QUEST THEO LEVEL ====================
function GetQuestByLevel(level)
    for _, quest in ipairs(QuestDatabase) do
        if level >= quest[1] and level <= quest[2] then
            return quest
        end
    end
    return nil
end

-- ==================== NOCLIP ====================
local noclipConnection = nil

function Noclip(enable)
    if enable then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(function()
            if _G.AutoFarm then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
    end
end

-- ==================== ANTI-FALL ====================
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarm and root and root.Velocity.Y < -30 then
            root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        end
    end
end)

-- ==================== AUTO HAKI ====================
function EnableHaki()
    if not _G.AutoHaki then return end
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote and remote:FindFirstChild("CommF_") then
            remote.CommF_:InvokeServer("Enhancement", true)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(10)
        if _G.AutoFarm and _G.AutoHaki then
            EnableHaki()
        end
    end
end)

-- ==================== TWEEN DI CHUYỂN ====================
function TweenMove(targetCFrame)
    if not root then return end
    
    local distance = (root.Position - targetCFrame.Position).Magnitude
    local duration = math.max(distance / _G.TweenSpeed, 0.2)
    
    local prevStand = humanoid.PlatformStand
    humanoid.PlatformStand = true
    Noclip(true)
    
    local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
    
    humanoid.PlatformStand = prevStand
    Noclip(false)
    root.Velocity = Vector3.zero
end

-- ==================== TẤN CÔNG ====================
function PerformAttack()
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote and remote:FindFirstChild("CommF_") then
            remote.CommF_:InvokeServer("Melee")
        end
    end)
end

-- ==================== TÌM QUÁI ====================
local enemyCache = {}
local lastCacheTime = 0

function ScanMobs()
    if tick() - lastCacheTime < 3 and #enemyCache > 0 then
        return enemyCache
    end
    
    enemyCache = {}
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, mob in ipairs(enemies:GetChildren()) do
            if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") then
                if mob.Humanoid.Health > 0 then
                    table.insert(enemyCache, mob)
                end
            end
        end
    end
    lastCacheTime = tick()
    return enemyCache
end

function FindNearestMob(mobName)
    local mobs = ScanMobs()
    local nearest = nil
    local nearestDist = 100
    
    for _, mob in ipairs(mobs) do
        if mobName and string.find(mob.Name, mobName) then
            local dist = (root.Position - mob.HumanoidRootPart.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = mob
            end
        end
    end
    return nearest
end

-- ==================== GOM QUÁI ====================
function BringMobs(mobName)
    if not _G.BringMob then return end
    
    local mobs = ScanMobs()
    local gathered = 0
    local gatherPoint = root.Position + (root.CFrame.LookVector * 15)
    
    for _, mob in ipairs(mobs) do
        if mobName and string.find(mob.Name, mobName) then
            local hum = mob:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local dist = (root.Position - mob.HumanoidRootPart.Position).Magnitude
                if dist <= _G.GatherRadius and dist > 5 then
                    mob.HumanoidRootPart.CFrame = CFrame.new(gatherPoint)
                    mob.HumanoidRootPart.Velocity = Vector3.zero
                    gathered = gathered + 1
                end
            end
        end
    end
    
    if gathered > 0 then
        print("📦 Đã gom " .. gathered .. " quái")
    end
end

-- ==================== KIỂM TRA QUEST ====================
function HasActiveQuest()
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then return false end
    
    local main = playerGui:FindFirstChild("Main")
    if not main then return false end
    
    for _, frame in pairs(main:GetChildren()) do
        if frame:IsA("Frame") and frame.Visible then
            for _, text in pairs(frame:GetDescendants()) do
                if text:IsA("TextLabel") and text.Visible then
                    local content = text.Text or ""
                    if content:find("Đánh bài") or content:find("Tiêu diệt") then
                        return true
                    end
                end
            end
        end
    end
    return false
end

-- ==================== NHẬN QUEST ====================
function AcceptQuest(questName, npcPos)
    TweenMove(CFrame.new(npcPos) * CFrame.new(0, 0, 4))
    task.wait(0.5)
    
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote and remote:FindFirstChild("CommF_") then
            remote.CommF_:InvokeServer("StartQuest", questName)
        end
    end)
    
    task.wait(1)
end

-- ==================== STATE MACHINE ====================
_G.State = "IDLE"
local currentQuest = nil
local lastAttack = 0

task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.AutoFarm then
            pcall(function()
                local level = player.Data.Level.Value
                
                if _G.State == "IDLE" then
                    local quest = GetQuestByLevel(level)
                    if quest then
                        currentQuest = quest
                        _G.State = "GET_QUEST"
                        print("🔍 Tìm thấy quest:", quest[4])
                    end
                    
                elseif _G.State == "GET_QUEST" then
                    if not HasActiveQuest() then
                        AcceptQuest(currentQuest[4], currentQuest[6])
                        if HasActiveQuest() then
                            _G.State = "MOVE_TO_FARM"
                        end
                    else
                        _G.State = "MOVE_TO_FARM"
                    end
                    
                elseif _G.State == "MOVE_TO_FARM" then
                    TweenMove(CFrame.new(currentQuest[7]) * CFrame.new(0, _G.FlyHeight, 0))
                    _G.State = "FARMING"
                    print("✅ Bắt đầu farming:", currentQuest[5])
                    
                elseif _G.State == "FARMING" then
                    if not HasActiveQuest() then
                        _G.State = "IDLE"
                        print("✅ Quest hoàn thành!")
                        return
                    end
                    
                    if _G.BringMob then
                        BringMobs(currentQuest[5])
                    end
                    
                    local mob = FindNearestMob(currentQuest[5])
                    if mob then
                        local mobPos = mob.HumanoidRootPart.Position
                        local dist = (root.Position - mobPos).Magnitude
                        if dist > 15 then
                            TweenMove(CFrame.new(mobPos) * CFrame.new(0, _G.FlyHeight, 0))
                        end
                        
                        if tick() - lastAttack > _G.AttackDelay then
                            PerformAttack()
                            lastAttack = tick()
                        end
                    end
                end
            end)
        else
            _G.State = "IDLE"
        end
    end
end)

-- ==================== UI ====================
local farmGroup = farmTab:AddLeftGroupbox("🤖 Điều Khiển")

farmGroup:AddButton({
    Title = "▶️ BẬT AUTO FARM",
    Callback = function()
        _G.AutoFarm = true
        print("✅ Auto Farm đã BẬT")
    end
})

farmGroup:AddButton({
    Title = "⏹️ TẮT AUTO FARM",
    Callback = function()
        _G.AutoFarm = false
        print("⏸️ Auto Farm đã TẮT")
    end
})

farmGroup:AddButton({
    Title = "📦 BẬT GOM QUÁI",
    Callback = function()
        _G.BringMob = true
        print("✅ Bring Mob BẬT")
    end
})

farmGroup:AddButton({
    Title = "📦 TẮT GOM QUÁI",
    Callback = function()
        _G.BringMob = false
        print("⏸️ Bring Mob TẮT")
    end
})

farmGroup:AddButton({
    Title = "⚡ BẬT HAKI",
    Callback = function()
        _G.AutoHaki = true
        EnableHaki()
        print("✅ Haki đã BẬT")
    end
})

farmGroup:AddButton({
    Title = "⚡ TẮT HAKI",
    Callback = function()
        _G.AutoHaki = false
        print("⏸️ Haki đã TẮT")
    end
})

-- Settings Tab
local settingGroup = settingTab:AddLeftGroupbox("⚙️ Cài Đặt")

settingGroup:AddSlider({
    Title = "🚀 Tốc độ bay",
    Min = 40,
    Max = 100,
    Default = 65,
    Callback = function(v) _G.TweenSpeed = v end
})

settingGroup:AddSlider({
    Title = "⚔️ Delay đánh",
    Min = 0.1,
    Max = 0.5,
    Default = 0.25,
    Decimal = true,
    Callback = function(v) _G.AttackDelay = v end
})

settingGroup:AddSlider({
    Title = "🗻 Độ cao bay",
    Min = 5,
    Max = 15,
    Default = 8,
    Callback = function(v) _G.FlyHeight = v end
})

settingGroup:AddSlider({
    Title = "📏 Bán kính gom quái",
    Min = 10,
    Max = 40,
    Default = 20,
    Callback = function(v) _G.GatherRadius = v end
})

-- ==================== HIỂN THỊ UI ====================
UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ APPLE HUB PREMIUM - AUTO FARM 1-2800!")
print("📌 State Machine: IDLE → GET_QUEST → MOVE_TO_FARM → FARMING")
print("📌 Tối ưu cho mobile, chống lag, chống rơi")
print("📌 Bấm 'BẬT AUTO FARM' để bắt đầu")
print("=" .. string.rep("=", 50)) 

-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "Auto Farm 1-2600 | by Quoc Hoa",
    Image = "rbxassetid://76048047842530"
})

local farmTab = window:AddTab("🌾 Farm")
local settingTab = window:AddTab("⚙️ Settings")

-- ==================== BIẾN CẤU HÌNH ====================
_G.AutoFarm = false
_G.BringMob = true
_G.TweenSpeed = 200
_G.AttackDelay = 0.15
_G.BringMobRadius = 20
_G.BringMobOffset = 12
_G.FlyHeight = 12

-- ==================== SERVICE ====================
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = Players.LocalPlayer

-- ==================== MỐC LEVEL 1-2600 ====================
local QuestLevels = {
    {min = 1, max = 10, npc = "Bandit", location = Vector3.new(1120, 13, 1450), mobArea = Vector3.new(1100, 13, 1480)},
    {min = 11, max = 20, npc = "Monkey", location = Vector3.new(-1177, 68, 292), mobArea = Vector3.new(-1200, 68, 320)},
    {min = 21, max = 30, npc = "Pirate", location = Vector3.new(2677, 28, 180), mobArea = Vector3.new(2650, 28, 200)},
    {min = 31, max = 40, npc = "Brute", location = Vector3.new(2865, 29, 482), mobArea = Vector3.new(2840, 29, 510)},
    {min = 41, max = 50, npc = "Viking", location = Vector3.new(249, 51, 435), mobArea = Vector3.new(220, 51, 460)},
    {min = 51, max = 70, npc = "SnowTrooper", location = Vector3.new(873, 114, -1269), mobArea = Vector3.new(850, 114, -1290)},
    {min = 71, max = 85, npc = "ChiefPettyOfficer", location = Vector3.new(-438, 18, 618), mobArea = Vector3.new(-460, 18, 640)},
    {min = 86, max = 100, npc = "SkyBandit", location = Vector3.new(-4838, 721, -2660), mobArea = Vector3.new(-4860, 721, -2680)},
    {min = 101, max = 120, npc = "DarkMaster", location = Vector3.new(-5174, 593, -2759), mobArea = Vector3.new(-5200, 593, -2780)},
    {min = 121, max = 140, npc = "Toga", location = Vector3.new(-5236, 817, -3103), mobArea = Vector3.new(-5260, 817, -3120)},
    {min = 141, max = 160, npc = "Fishman", location = Vector3.new(3928, 10, -1032), mobArea = Vector3.new(3900, 10, -1050)},
    {min = 161, max = 180, npc = "FishmanCommander", location = Vector3.new(3904, 12, -1408), mobArea = Vector3.new(3880, 12, -1430)},
    {min = 181, max = 210, npc = "GalleyPirate", location = Vector3.new(5598, 13, 700), mobArea = Vector3.new(5570, 13, 720)},
    {min = 211, max = 240, npc = "GalleyCaptain", location = Vector3.new(5697, 14, 686), mobArea = Vector3.new(5670, 14, 710)},
    {min = 241, max = 270, npc = "Marine", location = Vector3.new(-2937, 12, -2857), mobArea = Vector3.new(-2960, 12, -2880)},
    {min = 271, max = 300, npc = "MarineCaptain", location = Vector3.new(-2936, 13, -2998), mobArea = Vector3.new(-2960, 13, -3020)},
    {min = 301, max = 330, npc = "Prisoner", location = Vector3.new(5308, 18, 42), mobArea = Vector3.new(5280, 18, 60)},
    {min = 331, max = 360, npc = "DangerousPrisoner", location = Vector3.new(5310, 16, 137), mobArea = Vector3.new(5280, 16, 160)},
    {min = 361, max = 400, npc = "MilitarySoldier", location = Vector3.new(-2381, 23, -2352), mobArea = Vector3.new(-2400, 23, -2370)},
    {min = 401, max = 450, npc = "MilitarySpy", location = Vector3.new(-2581, 24, -2485), mobArea = Vector3.new(-2600, 24, -2500)},
    {min = 451, max = 500, npc = "SaberExpert", location = Vector3.new(1432, 11, 26), mobArea = Vector3.new(1410, 11, 50)},
    {min = 501, max = 550, npc = "GodHuman", location = Vector3.new(-4652, 822, -3030), mobArea = Vector3.new(-4670, 822, -3050)},
    {min = 551, max = 600, npc = "CursedCaptain", location = Vector3.new(3637, 17, -354), mobArea = Vector3.new(3610, 17, -370)},
    {min = 601, max = 650, npc = "IceAdmiral", location = Vector3.new(1562, 13, 433), mobArea = Vector3.new(1540, 13, 450)},
    {min = 651, max = 700, npc = "MagmaNinja", location = Vector3.new(-5718, 9, 273), mobArea = Vector3.new(-5740, 9, 290)},
    {min = 701, max = 725, npc = "Raider", location = Vector3.new(771, 31, 1351), mobArea = Vector3.new(750, 31, 1370)},
    {min = 726, max = 750, npc = "Mercenary", location = Vector3.new(786, 32, 1172), mobArea = Vector3.new(760, 32, 1190)},
    {min = 751, max = 775, npc = "SwanPirate", location = Vector3.new(527, 18, 1406), mobArea = Vector3.new(500, 18, 1420)},
    {min = 776, max = 800, npc = "FactoryStaff", location = Vector3.new(435, 209, -376), mobArea = Vector3.new(410, 209, -390)},
    {min = 801, max = 850, npc = "MarineLieutenant", location = Vector3.new(-2804, 72, -3342), mobArea = Vector3.new(-2820, 72, -3360)},
    {min = 851, max = 900, npc = "MarineCaptain", location = Vector3.new(-2828, 73, -3497), mobArea = Vector3.new(-2850, 73, -3510)},
    {min = 901, max = 950, npc = "Zombie", location = Vector3.new(-546, 34, -486), mobArea = Vector3.new(-570, 34, -500)},
    {min = 951, max = 1000, npc = "Vampire", location = Vector3.new(-549, 30, -609), mobArea = Vector3.new(-570, 30, -630)},
    {min = 1001, max = 1050, npc = "Snowman", location = Vector3.new(529, 154, -433), mobArea = Vector3.new(500, 154, -450)},
    {min = 1051, max = 1100, npc = "SnowTrooper", location = Vector3.new(705, 158, -543), mobArea = Vector3.new(680, 158, -560)},
    {min = 1101, max = 1150, npc = "LabSubordinate", location = Vector3.new(-4117, 345, -2661), mobArea = Vector3.new(-4140, 345, -2680)},
    {min = 1151, max = 1200, npc = "HornedMan", location = Vector3.new(-4183, 343, -2788), mobArea = Vector3.new(-4200, 343, -2800)},
    {min = 1201, max = 1250, npc = "Diamond", location = Vector3.new(-1665, 243, 85), mobArea = Vector3.new(-1680, 243, 100)},
    {min = 1251, max = 1300, npc = "PirateMilitia", location = Vector3.new(-1266, 73, 967), mobArea = Vector3.new(-1280, 73, 980)},
    {min = 1301, max = 1350, npc = "Gunslinger", location = Vector3.new(-1393, 64, 990), mobArea = Vector3.new(-1410, 64, 1010)},
    {min = 1351, max = 1400, npc = "Crewmate", location = Vector3.new(-285, 44, 1643), mobArea = Vector3.new(-300, 44, 1660)},
    {min = 1401, max = 1450, npc = "Bentham", location = Vector3.new(-138, 46, 1634), mobArea = Vector3.new(-160, 46, 1650)},
    {min = 1451, max = 1525, npc = "DonSwan", location = Vector3.new(288, 31, 1629), mobArea = Vector3.new(260, 31, 1650)},
    {min = 1526, max = 1575, npc = "Pirate", location = Vector3.new(-1110, 12, 3870), mobArea = Vector3.new(-1130, 12, 3890)},
    {min = 1576, max = 1625, npc = "Brute", location = Vector3.new(-1116, 14, 3966), mobArea = Vector3.new(-1140, 14, 3980)},
    {min = 1626, max = 1675, npc = "Gladiator", location = Vector3.new(1364, 25, 1190), mobArea = Vector3.new(1340, 25, 1210)},
    {min = 1676, max = 1725, npc = "MilitarySoldier", location = Vector3.new(1322, 24, 1127), mobArea = Vector3.new(1300, 24, 1140)},
    {min = 1726, max = 1775, npc = "Marine", location = Vector3.new(-2620, 198, 3199), mobArea = Vector3.new(-2640, 198, 3220)},
    {min = 1776, max = 1825, npc = "MarineCaptain", location = Vector3.new(-2628, 199, 3316), mobArea = Vector3.new(-2650, 199, 3330)},
    {min = 1826, max = 1875, npc = "Thug", location = Vector3.new(-3244, 246, 952), mobArea = Vector3.new(-3260, 246, 970)},
    {min = 1876, max = 1925, npc = "Raider", location = Vector3.new(-3256, 247, 832), mobArea = Vector3.new(-3280, 247, 850)},
    {min = 1926, max = 1975, npc = "GalleyPirate", location = Vector3.new(-456, 77, -2960), mobArea = Vector3.new(-480, 77, -2980)},
    {min = 1976, max = 2025, npc = "GalleyCaptain", location = Vector3.new(-444, 78, -3088), mobArea = Vector3.new(-470, 78, -3100)},
    {min = 2026, max = 2075, npc = "Pirate", location = Vector3.new(5694, 613, -132), mobArea = Vector3.new(5670, 613, -150)},
    {min = 2076, max = 2125, npc = "Brute", location = Vector3.new(5782, 614, -192), mobArea = Vector3.new(5760, 614, -210)},
    {min = 2126, max = 2175, npc = "Pirate", location = Vector3.new(-1683, 35, -5038), mobArea = Vector3.new(-1700, 35, -5060)},
    {min = 2176, max = 2225, npc = "Brute", location = Vector3.new(-1615, 37, -5117), mobArea = Vector3.new(-1640, 37, -5140)},
    {min = 2226, max = 2275, npc = "Firefighter", location = Vector3.new(-134, 445, -202), mobArea = Vector3.new(-160, 445, -220)},
    {min = 2276, max = 2325, npc = "Scientist", location = Vector3.new(-76, 444, -219), mobArea = Vector3.new(-100, 444, -240)},
    {min = 2326, max = 2375, npc = "Zombie", location = Vector3.new(-2249, 445, -815), mobArea = Vector3.new(-2270, 445, -830)},
    {min = 2376, max = 2425, npc = "Vampire", location = Vector3.new(-2344, 445, -934), mobArea = Vector3.new(-2370, 445, -950)},
    {min = 2426, max = 2475, npc = "Ghost", location = Vector3.new(-4550, 390, -3672), mobArea = Vector3.new(-4570, 390, -3690)},
    {min = 2476, max = 2525, npc = "Reaper", location = Vector3.new(-4727, 391, -3802), mobArea = Vector3.new(-4750, 391, -3820)},
    {min = 2526, max = 2600, npc = "DragonCrew", location = Vector3.new(-5374, 309, -5053), mobArea = Vector3.new(-5400, 309, -5070)},
}

function GetQuestByLevel(level)
    for _, q in pairs(QuestLevels) do
        if level >= q.min and level <= q.max then return q end
    end
    return QuestLevels[1]
end

-- ==================== LOGIC BAY (BODYVELOCITY - CHỐNG RỚT) ====================
local BodyVel = nil

function StopFly()
    if BodyVel then
        pcall(function() BodyVel:Destroy() end)
        BodyVel = nil
    end
end

function FlyToPosition(Position)
    if not _G.AutoFarm then return false end
    StopFly()
    
    pcall(function()
        local char = Player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        -- Tạo BodyVelocity giữ nhân vật trên không
        BodyVel = Instance.new("BodyVelocity")
        BodyVel.MaxForce = Vector3.new(4000, 4000, 4000)
        BodyVel.P = 2000
        BodyVel.Parent = hrp
        
        local targetPos = Vector3.new(Position.X, Position.Y + _G.FlyHeight, Position.Z)
        
        while _G.AutoFarm and (hrp.Position - targetPos).Magnitude > 10 do
            local direction = (targetPos - hrp.Position).Unit
            BodyVel.Velocity = direction * _G.TweenSpeed
            task.wait(0.05)
        end
        
        StopFly()
    end)
    return true
end

-- ==================== NOCLIP (XUYÊN TƯỜNG) ====================
task.spawn(function()
    while true do
        task.wait(0.2)
        if _G.AutoFarm then
            pcall(function()
                local char = Player.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== ANTI-FALL (DỰ PHÒNG) ====================
task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.AutoFarm then
            pcall(function()
                local char = Player.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp.Velocity.Y < -30 and not BodyVel then
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                    end
                end
            end)
        end
    end
end)

-- ==================== AUTO QUEST (3 CÁCH GỌI) ====================
function StartQuest(questData)
    if not questData then return end
    
    pcall(function()
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
        
        -- Cách 1: InvokeServer chuẩn
        local success, _ = pcall(function()
            remote:InvokeServer("StartQuest", questData.npc)
        end)
        
        if not success then
            -- Cách 2: FireServer
            pcall(function()
                remote:FireServer("StartQuest", questData.npc)
            end)
            
            -- Cách 3: InvokeServer với table
            pcall(function()
                remote:InvokeServer({[1] = "StartQuest", [2] = questData.npc})
            end)
        end
        
        print("✅ Đã gửi yêu cầu quest: " .. questData.npc)
    end)
end

-- ==================== BRING MOB (GOM QUÁI - RADIUS NHỎ) ====================
task.spawn(function()
    while true do
        task.wait(0.15)
        if _G.AutoFarm and _G.BringMob then
            pcall(function()
                local char = Player.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local targetPos = hrp.Position + (hrp.CFrame.LookVector * _G.BringMobOffset)
                
                for _, v in pairs(workspace:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        local enemyHrp = v.HumanoidRootPart
                        local enemyHum = v.Humanoid
                        local dist = (enemyHrp.Position - hrp.Position).Magnitude
                        
                        if enemyHum.Health > 0 and dist <= _G.BringMobRadius and dist > 5 then
                            enemyHrp.CFrame = CFrame.new(targetPos)
                            enemyHrp.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== AUTO ATTACK (M1) ====================
task.spawn(function()
    while true do
        task.wait(_G.AttackDelay)
        if _G.AutoFarm then
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.03)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        end
    end
end)

-- ==================== MAIN LOOP FARM ====================
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AutoFarm then
            pcall(function()
                if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then
                    task.wait(2)
                    return
                end
                
                local playerLevel = Player.Data.Level.Value
                local questData = GetQuestByLevel(playerLevel)
                
                if not questData then 
                    print("⚠️ Không tìm thấy quest cho level " .. playerLevel)
                    return 
                end
                
                print("🚶 Di chuyển đến " .. questData.npc)
                FlyToPosition(questData.location)
                task.wait(0.8)
                
                print("📜 Nhận quest từ " .. questData.npc)
                StartQuest(questData)
                task.wait(1)
                
                print("⚔️ Di chuyển đến khu vực farm")
                FlyToPosition(questData.mobArea)
                task.wait(0.5)
                
                print("🔥 Farming | Level: " .. playerLevel .. " | Quái: " .. questData.npc)
            end)
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
        StopFly()
        print("⏸️ Auto Farm đã TẮT")
    end
})

farmGroup:AddButton({
    Title = "📦 BẬT GOM QUÁI",
    Callback = function()
        _G.BringMob = true
        print("✅ Bring Mob BẬT (bán kính 20)")
    end
})

farmGroup:AddButton({
    Title = "📦 TẮT GOM QUÁI",
    Callback = function()
        _G.BringMob = false
        print("⏸️ Bring Mob TẮT")
    end
})

-- Settings Tab
local settingGroup = settingTab:AddLeftGroupbox("⚙️ Cài Đặt")

settingGroup:AddSlider({
    Title = "🚀 Tốc độ bay",
    Min = 100,
    Max = 500,
    Default = 200,
    Callback = function(v) _G.TweenSpeed = v end
})

settingGroup:AddSlider({
    Title = "⚔️ Delay đánh",
    Min = 0.05,
    Max = 0.5,
    Default = 0.15,
    Decimal = true,
    Callback = function(v) _G.AttackDelay = v end
})

settingGroup:AddSlider({
    Title = "📏 Bán kính gom quái",
    Min = 10,
    Max = 50,
    Default = 20,
    Callback = function(v) _G.BringMobRadius = v end
})

settingGroup:AddSlider({
    Title = "🗻 Độ cao bay",
    Min = 5,
    Max = 25,
    Default = 12,
    Callback = function(v) _G.FlyHeight = v end
})

-- ==================== HIỂN THỊ UI ====================
UI.ToggleUI()
print("=" .. string.rep("=", 40))
print("✅ Apple Hub Premium - ĐÃ FIX HOÀN CHỈNH!")
print("📌 Hướng dẫn:")
print("   1. Bấm 'BẬT AUTO FARM'")
print("   2. Script dùng BodyVelocity -> KHÔNG BỊ RỚT")
print("   3. Auto Quest với 3 cách gọi Remote")
print("   4. Gom quái bán kính 20 (tránh mất damage)")
print("=" .. string.rep("=", 40)) 

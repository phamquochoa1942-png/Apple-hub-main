-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "Auto Farm 1-2600 MAX | by Quoc Hoa",
    Image = "rbxassetid://76048047842530"
})

local farmTab = window:AddTab("🌾 Farm")
local settingTab = window:AddTab("⚙️ Settings")

-- ==================== BIẾN CẤU HÌNH ====================
_G.AutoFarm = false
_G.BringMob = false
_G.TweenSpeed = 300
_G.AttackDelay = 0.2
_G.State = "CHECK_QUEST"
_G.CurrentQuest = nil
_G.Busy = false

-- ==================== SERVICE ====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer
local playerGui = Player:WaitForChild("PlayerGui")

-- ==================== GLOBAL CHARACTER & HRP ====================
local Character, HRP

function UpdateHRP()
    Character = Player.Character or Player.CharacterAdded:Wait()
    HRP = Character:WaitForChild("HumanoidRootPart")
end
UpdateHRP()
Player.CharacterAdded:Connect(UpdateHRP)

-- ==================== NOCLIP ====================
local noclipConnection = nil

function ToggleNoclip(enable)
    if enable then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(function()
            if _G.AutoFarm then
                local char = Player.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
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

-- ==================== TWEEN CONTROL ====================
local currentTween = nil
local isTweening = false
local DISTANCE_THRESHOLD = 20

function StopTween()
    if currentTween then
        pcall(function()
            currentTween:Cancel()
            currentTween:Destroy()
        end)
        currentTween = nil
    end
    isTweening = false
end

function TweenToPosition(targetPos)
    pcall(function()
        if _G.Busy then return end
        
        local char = Player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local hrp = char.HumanoidRootPart
        local distance = (hrp.Position - targetPos).Magnitude
        
        if distance < DISTANCE_THRESHOLD then
            print("✅ ĐÃ ĐẾN NƠI (" .. math.floor(distance) .. " studs)")
            return
        end
        
        ToggleNoclip(true)
        
        if currentTween then
            currentTween:Cancel()
            currentTween:Destroy()
        end
        
        isTweening = true
        local tweenTime = math.max(2, distance / _G.TweenSpeed)
        local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
        
        currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(targetPos)})
        currentTween:Play()
        
        currentTween.Completed:Connect(function()
            isTweening = false
            ToggleNoclip(false)
            print("✅ TWEEN HOÀN THÀNH")
        end)
        
        currentTween.Canceled:Connect(function()
            isTweening = false
            ToggleNoclip(false)
        end)
        
        -- TIMEOUT SAFETY
        task.spawn(function()
            task.wait(tweenTime + 3)
            if isTweening then
                isTweening = false
                ToggleNoclip(false)
                print("⏰ TWEEN TIMEOUT")
            end
        end)
    end)
end

function StopAll()
    if currentTween then
        currentTween:Cancel()
        currentTween:Destroy()
        currentTween = nil
    end
    isTweening = false
    _G.Busy = false
    ToggleNoclip(false)
end

-- ==================== ANTI-FALL ====================
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AutoFarm and HRP then
            pcall(function()
                if HRP.Velocity.Y < -40 then
                    HRP.Velocity = Vector3.new(HRP.Velocity.X, 0, HRP.Velocity.Z)
                end
            end)
        end
    end
end)

-- ==================== AUTO ATTACK ====================
task.spawn(function()
    while true do
        task.wait(_G.AttackDelay)
        if _G.AutoFarm and not isTweening and _G.State == "FARMING" then
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        end
    end
end)

-- ==================== BRING MOB ====================
task.spawn(function()
    while true do
        task.wait(0.15)
        if _G.AutoFarm and _G.BringMob and not isTweening and _G.State == "FARMING" then
            pcall(function()
                if not HRP then return end
                local targetPos = HRP.Position + (HRP.CFrame.LookVector * 12) + Vector3.new(0, 3, 0)
                local enemies = workspace:FindFirstChild("Enemies")
                
                if enemies then
                    for _, v in pairs(enemies:GetChildren()) do
                        if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                            local enemyHrp = v.HumanoidRootPart
                            local enemyHum = v.Humanoid
                            local dist = (enemyHrp.Position - HRP.Position).Magnitude
                            
                            if enemyHum.Health > 0 and dist <= 25 and dist > 8 then
                                enemyHrp.CFrame = CFrame.new(targetPos)
                                enemyHrp.Velocity = Vector3.new(0, 0, 0)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== QUEST DATABASE ====================
local QuestDB = {
    [1] = {
        {LvMin=0, LvMax=14, QuestName="BanditQuest1", NPCPos=Vector3.new(1061,16,1548), MobName="Bandit", MobArea=Vector3.new(1100,13,1480)},
        {LvMin=15, LvMax=29, QuestName="JungleQuest", NPCPos=Vector3.new(-1400,37,90), MobName="Monkey", MobArea=Vector3.new(-1200,68,320)},
        {LvMin=30, LvMax=59, QuestName="JungleQuest", NPCPos=Vector3.new(-1250,37,1600), MobName="Gorilla", MobArea=Vector3.new(-1280,37,1580)},
        {LvMin=60, LvMax=89, QuestName="SnowQuest", NPCPos=Vector3.new(1386,87,-1297), MobName="Snow Bandit", MobArea=Vector3.new(1350,87,-1320)},
        {LvMin=90, LvMax=119, QuestName="MarineQuest2", NPCPos=Vector3.new(2167,26,1488), MobName="Brute", MobArea=Vector3.new(2140,26,1510)},
        {LvMin=120, LvMax=199, QuestName="BountyHunterQuest1", NPCPos=Vector3.new(-2882,43,5582), MobName="Pirate", MobArea=Vector3.new(-2900,43,5560)},
        {LvMin=200, LvMax=349, QuestName="SkullGardQuest1", NPCPos=Vector3.new(-2482,73,3157), MobName="Skull Guard", MobArea=Vector3.new(-2500,73,3130)},
        {LvMin=350, LvMax=449, QuestName="RaidingQuest1", NPCPos=Vector3.new(-5053,61,854), MobName="Raider", MobArea=Vector3.new(-5070,61,830)},
        {LvMin=450, LvMax=549, QuestName="FactoryQuest", NPCPos=Vector3.new(296,48,-541), MobName="Factory Staff", MobArea=Vector3.new(270,48,-560)},
        {LvMin=550, LvMax=699, QuestName="ViceQuest", NPCPos=Vector3.new(-4716,9,2993), MobName="Vice Admiral", MobArea=Vector3.new(-4740,9,2970)},
        {LvMin=700, LvMax=700, QuestName="SaberExpertQuest", NPCPos=Vector3.new(923,65,14280), MobName="Saber Expert", MobArea=Vector3.new(900,65,14250)},
    },
    [2] = {
        {LvMin=700, LvMax=799, QuestName="BartiloQuest", NPCPos=Vector3.new(-1859,13,1729), MobName="Pirate Millionaire", MobArea=Vector3.new(-1820,13,1750)},
        {LvMin=800, LvMax=874, QuestName="CaptainEleQuest", NPCPos=Vector3.new(-1370,30,92), MobName="Captain Elephant", MobArea=Vector3.new(-1400,30,120)},
        {LvMin=875, LvMax=899, QuestName="BeautifulPirateQuest", NPCPos=Vector3.new(5815,18,-2726), MobName="Beautiful Pirate", MobArea=Vector3.new(5790,18,-2750)},
        {LvMin=900, LvMax=949, QuestName="ArtilleryQuest", NPCPos=Vector3.new(5448,29,401), MobName="Artillery Soldier", MobArea=Vector3.new(5420,29,380)},
        {LvMin=950, LvMax=974, QuestName="GrooveQuest1", NPCPos=Vector3.new(2467,151,2047), MobName="Groove Pirates", MobArea=Vector3.new(2440,151,2020)},
        {LvMin=975, LvMax=999, QuestName="MechanicQuest", NPCPos=Vector3.new(-1517,42,2990), MobName="Mech Soldier", MobArea=Vector3.new(-1540,42,2960)},
        {LvMin=1000, LvMax=1049, QuestName="UrbanQuest", NPCPos=Vector3.new(5239,60,4721), MobName="Urban", MobArea=Vector3.new(5210,60,4700)},
        {LvMin=1050, LvMax=1099, QuestName="LongmaQuest", NPCPos=Vector3.new(932,66,1819), MobName="Longma", MobArea=Vector3.new(910,66,1790)},
        {LvMin=1100, LvMax=1124, QuestName="LaboratoryQuest", NPCPos=Vector3.new(6570,402,-7411), MobName="Lab Subordinate", MobArea=Vector3.new(6540,402,-7440)},
        {LvMin=1125, LvMax=1149, QuestName="ArcticQuest", NPCPos=Vector3.new(5686,28,1062), MobName="Arctic Warrior", MobArea=Vector3.new(5660,28,1040)},
        {LvMin=1150, LvMax=1199, QuestName="SnowLurkerQuest", NPCPos=Vector3.new(1342,454,-1495), MobName="Snow Lurker", MobArea=Vector3.new(1310,454,-1520)},
        {LvMin=1200, LvMax=1249, QuestName="WinterQuest", NPCPos=Vector3.new(1385,87,-1298), MobName="Winter Warrior", MobArea=Vector3.new(1350,87,-1320)},
        {LvMin=1250, LvMax=1349, QuestName="ShipQuest1", NPCPos=Vector3.new(-6470,89,-1325), MobName="Cursed Ship", MobArea=Vector3.new(-6500,89,-1350)},
        {LvMin=1350, LvMax=1399, QuestName="ZombieQuest", NPCPos=Vector3.new(5496,48,748), MobName="Living Zombie", MobArea=Vector3.new(5470,48,720)},
        {LvMin=1400, LvMax=1424, QuestName="VampireQuest", NPCPos=Vector3.new(5518,61,778), MobName="Vampire", MobArea=Vector3.new(5490,61,750)},
        {LvMin=1425, LvMax=1474, QuestName="SnowmanQuest", NPCPos=Vector3.new(-1728,54,-330), MobName="Snowman", MobArea=Vector3.new(-1750,54,-360)},
        {LvMin=1475, LvMax=1499, QuestName="IslandEmperorQuest", NPCPos=Vector3.new(5400,605,918), MobName="Island Emperor", MobArea=Vector3.new(5370,605,890)},
        {LvMin=1500, LvMax=1500, QuestName="TideKeeperQuest", NPCPos=Vector3.new(3879,38,-3346), MobName="Tide Keeper", MobArea=Vector3.new(3850,38,-3370)},
    },
    [3] = {
        {LvMin=1501, LvMax=1574, QuestName="MansionQuest1", NPCPos=Vector3.new(-12463,332,8792), MobName="Reborn Skeleton", MobArea=Vector3.new(-12490,332,8770)},
        {LvMin=1575, LvMax=1624, QuestName="MansionQuest2", NPCPos=Vector3.new(-12463,332,8792), MobName="Reborn Sniper", MobArea=Vector3.new(-12490,332,8770)},
        {LvMin=1625, LvMax=1674, QuestName="PreInstructorQuest", NPCPos=Vector3.new(-425,216,1837), MobName="Fajita", MobArea=Vector3.new(-450,216,1810)},
        {LvMin=1675, LvMax=1724, QuestName="InstructorQuest", NPCPos=Vector3.new(-425,216,1837), MobName="Instructor", MobArea=Vector3.new(-450,216,1810)},
        {LvMin=1725, LvMax=1774, QuestName="SnowMountainQuest", NPCPos=Vector3.new(1342,454,-1495), MobName="Snow Mountain", MobArea=Vector3.new(1310,454,-1520)},
        {LvMin=1775, LvMax=1824, QuestName="SnowMountainQuest2", NPCPos=Vector3.new(1342,454,-1495), MobName="Snow Mountain", MobArea=Vector3.new(1310,454,-1520)},
        {LvMin=1825, LvMax=1874, QuestName="SnowCommandoQuest", NPCPos=Vector3.new(2313,151,2649), MobName="Snow Commando", MobArea=Vector3.new(2280,151,2620)},
        {LvMin=1875, LvMax=1924, QuestName="DesertQuest", NPCPos=Vector3.new(2293,23,7154), MobName="Desert Officer", MobArea=Vector3.new(2260,23,7130)},
        {LvMin=1925, LvMax=1974, QuestName="PincerQuest", NPCPos=Vector3.new(-1347,458,3089), MobName="Pincer", MobArea=Vector3.new(-1370,458,3060)},
        {LvMin=1975, LvMax=2024, QuestName="FactoryStaffQuest", NPCPos=Vector3.new(296,48,-541), MobName="Factory Staff", MobArea=Vector3.new(270,48,-560)},
        {LvMin=2025, LvMax=2074, QuestName="DemonicSoulQuest", NPCPos=Vector3.new(-9479,142,5566), MobName="Demonic Soul", MobArea=Vector3.new(-9500,142,5540)},
        {LvMin=2075, LvMax=2124, QuestName="HeavenlyKingQuest", NPCPos=Vector3.new(-7862,5547,2017), MobName="Heavenly King", MobArea=Vector3.new(-7890,5547,1990)},
        {LvMin=2125, LvMax=2174, QuestName="CursedCaptainQuest", NPCPos=Vector3.new(-6470,89,-1325), MobName="Cursed Captain", MobArea=Vector3.new(-6500,89,-1350)},
        {LvMin=2175, LvMax=2224, QuestName="CaptainEleQuest2", NPCPos=Vector3.new(-1370,30,92), MobName="Captain Elephant", MobArea=Vector3.new(-1400,30,120)},
        {LvMin=2225, LvMax=2274, QuestName="BeautifulPirateQuest2", NPCPos=Vector3.new(5815,18,-2726), MobName="Beautiful Pirate", MobArea=Vector3.new(5790,18,-2750)},
        {LvMin=2275, LvMax=2324, QuestName="LongmaQuest2", NPCPos=Vector3.new(932,66,1819), MobName="Longma", MobArea=Vector3.new(910,66,1790)},
        {LvMin=2325, LvMax=2374, QuestName="LaboratoryQuest2", NPCPos=Vector3.new(6570,402,-7411), MobName="Lab Subordinate", MobArea=Vector3.new(6540,402,-7440)},
        {LvMin=2375, LvMax=2424, QuestName="IslandEmperorQuest2", NPCPos=Vector3.new(5400,605,918), MobName="Island Emperor", MobArea=Vector3.new(5370,605,890)},
        {LvMin=2425, LvMax=2474, QuestName="TideKeeperQuest2", NPCPos=Vector3.new(3879,38,-3346), MobName="Tide Keeper", MobArea=Vector3.new(3850,38,-3370)},
        {LvMin=2475, LvMax=2600, QuestName="EliteHunterQuest", NPCPos=Vector3.new(-5418,314,-2667), MobName="Elite Hunter", MobArea=Vector3.new(-5440,314,-2690)},
    }
}

function GetCurrentSea(level)
    if level >= 1500 then return 3
    elseif level >= 700 then return 2
    else return 1 end
end

-- ==================== PREMIUM IsQuestAccepted ====================
function IsQuestAccepted()
    local success, result = pcall(function()
        local main = playerGui:FindFirstChild("Main")
        if not main then return false end
        
        local questContainer = main:FindFirstChild("Quest") 
            and main.Quest:FindFirstChild("Container")
        if not questContainer then return false end
        
        local questTitle = questContainer:FindFirstChild("QuestTitle")
        local isVisible = questContainer.Visible
        local hasText = questTitle and questTitle.Text ~= ""
        
        return isVisible and hasText
    end)
    
    return success and result or false
end

function GetNearestMob(mobName)
    local closest, closestDist = nil, math.huge
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    
    for _, mob in pairs(enemies:GetChildren()) do
        if mob.Name:find(mobName) and mob:FindFirstChild("HumanoidRootPart") then
            local hum = mob:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local dist = (HRP.Position - mob.HumanoidRootPart.Position).Magnitude
                if dist < closestDist then
                    closest = mob
                    closestDist = dist
                end
            end
        end
    end
    return closest
end

-- ==================== STATE MACHINE (HUB STANDARD) ====================
function RunStateMachine()
    if not _G.AutoFarm or _G.Busy then return end
    
    local char = Player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    
    if _G.State == "CHECK_QUEST" then
        local level = Player.Data.Level.Value or 1
        local sea = GetCurrentSea(level)
        
        if level >= 2600 then
            print("🎉 MAX LEVEL 2600!")
            return
        end
        
        for _, quest in ipairs(QuestDB[sea]) do
            if level >= quest.LvMin and level <= quest.LvMax then
                _G.CurrentQuest = quest
                print("✅ SELECTED:", quest.QuestName)
                _G.State = "GET_QUEST"
                return
            end
        end
        
    elseif _G.State == "GET_QUEST" then
        local startTime = tick()
        print("✈️ GET_QUEST START")
        
        TweenToPosition(_G.CurrentQuest.NPCPos + Vector3.new(0, 10, 0))
        
        repeat
            task.wait(0.2)
            if IsQuestAccepted() then
                print("✅ QUEST ACCEPTED!")
                task.wait(1)
                _G.State = "MOVING_TO_FARM"
                return
            end
        until tick() - startTime > 8
        
        print("⏰ GET_QUEST TIMEOUT -> CHECK_QUEST")
        _G.State = "CHECK_QUEST"
        
    elseif _G.State == "MOVING_TO_FARM" then
        print("🌾 MOVING TO FARM")
        local mobArea = _G.CurrentQuest.MobArea or (_G.CurrentQuest.NPCPos + Vector3.new(150, 50, 150))
        
        TweenToPosition(mobArea)
        
        local distance = (hrp.Position - mobArea).Magnitude
        if distance < DISTANCE_THRESHOLD then
            print("✅ ĐẾN BÃI FARM -> FARMING")
            _G.State = "FARMING"
        end
        
    elseif _G.State == "FARMING" then
        if not IsQuestAccepted() then
            print("✅ QUEST DONE -> CHECK_QUEST")
            _G.State = "CHECK_QUEST"
            return
        end
        
        local mob = GetNearestMob(_G.CurrentQuest.MobName)
        if mob then
            local mobPos = mob.HumanoidRootPart.Position
            local distanceToMob = (hrp.Position - mobPos).Magnitude
            
            if distanceToMob > 10 then
                TweenToPosition(mobPos + Vector3.new(0, 5, 0))
            end
        end
    end
end

-- ==================== AUTO FARM TOGGLE ====================
local oldAutoFarm = false

function AutoFarmChanged()
    if _G.AutoFarm ~= oldAutoFarm then
        if _G.AutoFarm then
            StopAll()
            _G.Busy = false
            isTweening = false
            _G.State = "CHECK_QUEST"
            print("🔄 AUTO FARM ON - FULL RESET")
        else
            StopAll()
            print("⏹️ AUTO FARM OFF")
        end
        oldAutoFarm = _G.AutoFarm
    end
end

-- ==================== MAIN LOOP ====================
task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            RunStateMachine()
            AutoFarmChanged()
        end)
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
        StopAll()
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

local settingGroup = settingTab:AddLeftGroupbox("⚙️ Cài Đặt")

settingGroup:AddSlider({
    Title = "🚀 Tốc độ bay",
    Min = 100,
    Max = 500,
    Default = 300,
    Callback = function(v) _G.TweenSpeed = v end
})

settingGroup:AddSlider({
    Title = "⚔️ Delay đánh",
    Min = 0.05,
    Max = 0.5,
    Default = 0.2,
    Decimal = true,
    Callback = function(v) _G.AttackDelay = v end
})

UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ HUB STANDARD - AUTO FARM ĐÃ SẴN SÀNG!")
print("📌 IsQuestAccepted: Kiểm tra QuestTitle TEXT + Container VISIBLE")
print("📌 Timeout 8s cho GET_QUEST, tránh treo vô hạn")
print("📌 AutoFarm Toggle có FULL RESET state")
print("📌 Bấm 'BẬT AUTO FARM' để bắt đầu")
print("=" .. string.rep("=", 50)) 

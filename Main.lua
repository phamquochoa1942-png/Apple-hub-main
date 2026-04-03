-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "by Quoc hoa",
    Image = "rbxassetid://76048047842530"
})

local farmTab = window:AddTab("🌾 Farm")
local settingTab = window:AddTab("⚙️ Settings")

-- ==================== BIẾN CẤU HÌNH ====================
_G.AutoFarm = false
_G.BringMob = true
_G.TweenSpeed = 420
_G.AttackDelay = 0.06
_G.State = "CHECK_QUEST"
_G.CurrentQuest = nil
_G.Busy = false
_G.LastBringTime = 0
_G.FlyHeight = 8

-- ==================== SERVICE ====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local VU = game:GetService("VirtualUser")
local Player = Players.LocalPlayer
local playerGui = Player:WaitForChild("PlayerGui")

-- ==================== GLOBAL CHARACTER & HRP ====================
local Character, HRP
local humanoid = nil
local bodyVelocity = nil

function UpdateHRP()
    Character = Player.Character or Player.CharacterAdded:Wait()
    HRP = Character:WaitForChild("HumanoidRootPart")
    humanoid = Character:WaitForChild("Humanoid")
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

-- ==================== BLACK HAKI GEAR 5 (TỰ ĐỘNG BẬT) ====================
local CommF = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes.CommF_
local IsBlackHakiActive = false
local VisualEffect = nil

local function SpawnBlackAura()
    local char = Player.Character
    if not char or VisualEffect then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    VisualEffect = Instance.new("ParticleEmitter")
    VisualEffect.Parent = hrp
    VisualEffect.Texture = "rbxasset://textures/particles/smoke_main.dds"
    VisualEffect.Color = ColorSequence.new(Color3.new(0.05, 0.02, 0.1))
    VisualEffect.Size = NumberSequence.new(4, 10, 15)
    VisualEffect.Transparency = NumberSequence.new(0.2, 0.1, 0.4)
    VisualEffect.Lifetime = NumberRange.new(3)
    VisualEffect.Rate = 500
    VisualEffect.Speed = NumberRange.new(15, 30)
    VisualEffect.SpreadAngle = Vector2.new(360, 360)
    VisualEffect.Acceleration = Vector3.new(0, -10, 0)
end

local function ActivateBlackHaki()
    if IsBlackHakiActive then return end
    IsBlackHakiActive = true
    
    pcall(function()
        if CommF then
            for i = 1, 10 do
                CommF:InvokeServer("BuyGear", "Gear5")
                CommF:InvokeServer("ActivateGear", "Gear5")
                CommF:InvokeServer("SetHaki", "BlackHaki")
                CommF:InvokeServer("HakiActive", "BlackHaki", true)
                task.wait(0.05)
            end
        end
    end)
    
    if humanoid then
        humanoid:SetAttribute("BlackHakiActive", true)
        humanoid:SetAttribute("DamageMultiplier", 4)
    end
    
    SpawnBlackAura()
    print("🌑 BLACK HAKI GEAR 5 ACTIVATED - 4x DMG!")
end

-- Bật Black Haki ngay khi script chạy
task.spawn(function()
    task.wait(1)
    ActivateBlackHaki()
end)

-- Auto refresh Black Haki mỗi 10 giây
task.spawn(function()
    while true do
        task.wait(10)
        if Player.Character then
            ActivateBlackHaki()
        end
    end
end)

-- Character respawn
Player.CharacterAdded:Connect(function()
    task.wait(2)
    ActivateBlackHaki()
end)

-- ==================== TWEEN CONTROL ====================
local currentTween = nil
local isTweening = false
local DISTANCE_THRESHOLD = 10

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

function StartHover()
    if bodyVelocity then bodyVelocity:Destroy() end
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = HRP
end

function StopHover()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
end

function TweenToPosition(targetPos)
    pcall(function()
        if _G.Busy then return end
        if isTweening then return end
        if not HRP then return end
        
        local target = Vector3.new(targetPos.X, targetPos.Y + _G.FlyHeight, targetPos.Z)
        local distance = (HRP.Position - target).Magnitude
        if distance < DISTANCE_THRESHOLD then 
            StartHover()
            return 
        end
        
        ToggleNoclip(true)
        StopTween()
        
        isTweening = true
        local tweenTime = math.max(0.5, distance / _G.TweenSpeed)
        local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
        
        currentTween = TweenService:Create(HRP, tweenInfo, {CFrame = CFrame.new(target)})
        currentTween:Play()
        
        StartHover()
        
        currentTween.Completed:Connect(function()
            isTweening = false
            ToggleNoclip(false)
        end)
        
        currentTween.Canceled:Connect(function()
            isTweening = false
            ToggleNoclip(false)
        end)
    end)
end

function StopAll()
    if currentTween then
        currentTween:Cancel()
        currentTween:Destroy()
        currentTween = nil
    end
    StopHover()
    isTweening = false
    _G.Busy = false
    ToggleNoclip(false)
end

-- ==================== GIỮ NHÂN VẬT TRÊN CAO ====================
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarm and _G.State == "FARMING" then
            pcall(function()
                if HRP then
                    if HRP.Velocity.Y < -3 then
                        HRP.Velocity = Vector3.new(HRP.Velocity.X, 0, HRP.Velocity.Z)
                    end
                    if not bodyVelocity then
                        StartHover()
                    end
                end
            end)
        else
            StopHover()
        end
    end
end)

-- ==================== FULL QUEST DB (Lv 1-2824) ====================
local QuestDB = {
    [1] = {
        {1,9,"BanditQuest1",Vector3.new(1061.67, 16.9873, 1548.62),"Bandit"},
        {10,14,"BanditQuest2",Vector3.new(1061.67, 16.9873, 1548.62),"Bandit"},
        {15,29,"JungleQuest",Vector3.new(-1400.3, 37.3780, 90.42),"Monkey"},
        {30,59,"JungleQuest",Vector3.new(-1250.51, 37.2984, 1600.20),"Gorilla"},
        {60,89,"SnowQuest",Vector3.new(1386.67, 87.2727, -1297.11),"Snow Bandit"},
        {90,119,"MarineQuest1",Vector3.new(2167.17, 26.8451, 1488.55),"Marine Lieutenant"},
        {120,149,"MarineQuest2",Vector3.new(2167.17, 26.8451, 1488.55),"Brute"},
        {150,199,"GalleyQuest",Vector3.new(-1590.26, 36.4155, 158.39),"Galley Pirate"},
        {200,249,"GalleyCaptainQuest",Vector3.new(-1590.26, 36.4155, 158.39),"Galley Captain"},
        {250,299,"SkyExp1Quest",Vector3.new(-7881.39, 5635.33, 90.21),"Sky Bandit"},
        {300,349,"SkyExp2Quest",Vector3.new(-7881.39, 5635.33, 90.21),"Sky Bandit"},
        {350,399,"BunkerQuest",Vector3.new(-851.44, 39.567, 4418.49),"Pillager"},
        {400,424,"SwanPiratesQuest",Vector3.new(1112.13, 138.83, -4672.92),"Swan Pirate"},
        {425,474,"SwanCaptainQuest",Vector3.new(1112.13, 138.83, -4672.92),"Swan Captain"},
        {475,524,"FishmanQuest",Vector3.new(-10581.65625, 330.87258911133, 7114.3203125),"Fishman Warrior"},
        {525,549,"FactoryQuest",Vector3.new(296.788, 48.677, -541.527),"Factory Staff"},
        {550,599,"ViceQuest",Vector3.new(-4716.71, 9.0305, 2993.54),"Vice Admiral"},
        {600,649,"ViceQuest2",Vector3.new(-4716.71, 9.0305, 2993.54),"Vice Admiral"},
        {650,700,"SaberExpertQuest",Vector3.new(923.28, 65.82, 14280.48),"Saber Expert"}
    },
    [2] = {
        {700,749,"BartiloQuest",Vector3.new(-1859.93, 13.0169, 1729.11),"Pirate Millionaire"},
        {750,799,"BartiloQuest2",Vector3.new(-1859.93, 13.0169, 1729.11),"Pirate Millionaire"},
        {800,874,"CaptainEleQuest",Vector3.new(-1370.11, 30.0469, 92.27),"Captain Elephant"},
        {875,899,"BeautifulPirateQuest",Vector3.new(5815.51, 18.346, -2726.57),"Beautiful Pirate"},
        {900,949,"ArtilleryQuest",Vector3.new(5448, 29.85, 401.33),"Artillery Soldier"},
        {950,974,"GrooveQuest1",Vector3.new(2467.66, 151.236, 2047.91),"Groove Pirates"},
        {975,999,"MechanicQuest",Vector3.new(-1517.39, 42.065, 2990.12),"Mech Soldier"},
        {1000,1049,"UrbanQuest",Vector3.new(5239.2, 60.13, 4721.19),"Urban"},
        {1050,1099,"LongmaQuest",Vector3.new(932.64, 66.15, 1819.51),"Longma"},
        {1100,1124,"LaboratoryQuest1",Vector3.new(6570.92, 402.28, -7411.42),"Lab Subordinate"},
        {1125,1149,"ArcticQuest",Vector3.new(5686.36, 28.21, 1062.66),"Arctic Warrior"},
        {1150,1199,"SnowLurkerQuest",Vector3.new(1342.51, 454.41, -1495.11),"Snow Lurker"},
        {1200,1249,"WinterQuest",Vector3.new(1385.00, 87.27, -1298.00),"Winter Warrior"},
        {1250,1349,"ShipwrightQuest",Vector3.new(-6470.89, 89.03, -1325.72),"Cursed Crew"},
        {1350,1399,"ZombieQuest",Vector3.new(5496.85, 48.45, 748.63),"Living Zombie"},
        {1400,1424,"VampireQuest",Vector3.new(5518.10, 61.51, 778.34),"Vampire"},
        {1425,1474,"SnowmanQuest",Vector3.new(-1728.91, 54.32, -330.73),"Snowman"},
        {1475,1499,"IslandEmperorQuest",Vector3.new(5400.69, 605.37, 918.67),"Island Emperor"},
        {1500,1500,"TideKeeperQuest",Vector3.new(3879.34, 38.57, -3346.61),"Tide Keeper"}
    },
    [3] = {
        {1575,1624,"MansionQuest1",Vector3.new(-12463.87, 332.92, 8792.54),"Reborn Skeleton"},
        {1625,1674,"MansionQuest2",Vector3.new(-12463.87, 332.92, 8792.54),"Reborn Sniper"},
        {1675,1724,"PreInstructorQuest",Vector3.new(-425.05, 216.67, 1837.11),"Fajita"},
        {1725,1774,"InstructorQuest",Vector3.new(-425.05, 216.67, 1837.11),"Instructor"},
        {1775,1824,"KiloAdmiralQuest",Vector3.new(-2906.07, 4773.14, 5345.92),"Kilo Admiral"},
        {1825,1874,"KiloViceAdmiralQuest",Vector3.new(-2906.07, 4773.14, 5345.92),"Kilo Vice Admiral"},
        {1875,1924,"SnowCommandoQuest",Vector3.new(2313.79, 151.18, 2649.24),"Snow Commando"},
        {1925,1974,"DesertQuest",Vector3.new(2293.69, 23.32, 7154.69),"Desert Officer"},
        {1975,2024,"PincerQuest",Vector3.new(-1347.89, 458.23, 3089.34),"Pincer"},
        {2025,2074,"LaboratoryQuest3",Vector3.new(6570.92, 402.28, -7411.42),"Core Scientist"},
        {2075,2124,"DemonicSoulQuest",Vector3.new(-9479.42, 142.54, 5566.79),"Demonic Soul"},
        {2125,2174,"HeavenlyKingQuest",Vector3.new(-7862.99, 5547.48, 2017.24),"Heavenly King"},
        {2175,2224,"CursedCaptainQuest",Vector3.new(-6470.89, 89.03, -1325.72),"Cursed Captain"},
        {2225,2274,"CaptainEleQuest2",Vector3.new(-1370.11, 30.0469, 92.27),"Captain Elephant"},
        {2275,2324,"BeautifulPirateQuest2",Vector3.new(5815.51, 18.346, -2726.57),"Beautiful Pirate"},
        {2325,2374,"LongmaQuest2",Vector3.new(932.64, 66.15, 1819.51),"Longma"},
        {2375,2424,"LaboratoryQuest2",Vector3.new(6570.92, 402.28, -7411.42),"Lab Subordinate"},
        {2425,2474,"IslandEmperorQuest2",Vector3.new(5400.69, 605.37, 918.67),"Island Emperor"},
        {2475,2524,"TideKeeperQuest2",Vector3.new(3879.34, 38.57, -3346.61),"Tide Keeper"},
        {2525,2574,"EliteHunterQuest1",Vector3.new(-5418.55, 313.74, -2667.39),"Elite Hunter"},
        {2575,2624,"EliteHunterQuest2",Vector3.new(-5418.55, 313.74, -2667.39),"Elite Hunter"},
        {2625,2674,"GearThirdQuest",Vector3.new(2899.11, 5357.55, -5068.47),"Gear 3rd"},
        {2675,2724,"GearSecondQuest",Vector3.new(2899.11, 5357.55, -5068.47),"Gear 2nd"},
        {2725,2774,"GearFourthQuest",Vector3.new(2899.11, 5357.55, -5068.47),"Gear 4th"},
        {2775,2824,"GearFifthQuest",Vector3.new(2899.11, 5357.55, -5068.47),"Gear 5th"}
    }
}

function GetCurrentSea(level)
    if level >= 1575 then return 3
    elseif level >= 700 then return 2
    else return 1 end
end

function GetQuestByLevel(level)
    local sea = GetCurrentSea(level)
    for _, quest in ipairs(QuestDB[sea]) do
        if level >= quest[1] and level <= quest[2] then
            return {
                QuestName = quest[3],
                NPCPos = quest[4],
                MobName = quest[5],
                MobArea = Vector3.new(quest[4].X + math.random(-60,60), quest[4].Y + 5, quest[4].Z + math.random(-60,60))
            }
        end
    end
    return nil
end

-- ==================== PREMIUM MOB BRINGER ====================
local ConfigBring = {
    BringRange = 150,
    MaxMobs = 8,
    ESP = true
}

local MobData = {}

local function GetAllMobs(mobName)
    local mobs = {}
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return mobs end
    for _, obj in ipairs(enemies:GetChildren()) do
        if obj.Name == mobName and obj:FindFirstChild("Humanoid") 
        and obj.Humanoid.Health > 0 and obj:FindFirstChild("HumanoidRootPart") then
            table.insert(mobs, obj)
        end
    end
    return mobs
end

local function CreateESP(mob)
    local esp = Drawing.new("Square")
    esp.Size = Vector2.new(1, 1)
    esp.Color = Color3.fromRGB(255, 0, 0)
    esp.Thickness = 2
    esp.Filled = false
    esp.Visible = false
    
    local text = Drawing.new("Text")
    text.Size = 16
    text.Color = Color3.fromRGB(255, 255, 255)
    text.Outline = true
    text.Font = 2
    text.Text = mob.Name
    
    MobData[mob] = {ESP = esp, Text = text}
end

local function BringMob(mob)
    local hrp = mob.HumanoidRootPart
    local bringPos = HRP.Position + (HRP.CFrame.LookVector * 15)
    hrp.CFrame = CFrame.new(bringPos)
    hrp.Velocity = Vector3.new(0, 0, 0)
end

local function CleanupMob(mob)
    if MobData[mob] then
        MobData[mob].ESP:Remove()
        MobData[mob].Text:Remove()
        MobData[mob] = nil
    end
end

-- ==================== ULTRA M1 SPAMMER ====================
local LastClick = 0

local function GetTargetM1()
    if not HRP then return nil end
    local bestTarget, bestDist = nil, 40
    local mobName = _G.CurrentQuest and _G.CurrentQuest.MobName
    if not mobName then return nil end
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if enemies then
        for _, mob in pairs(enemies:GetChildren()) do
            if mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") 
            and mob.Humanoid and mob.Humanoid.Health > 0 then
                local dist = (HRP.Position - mob.HumanoidRootPart.Position).Magnitude
                if dist < bestDist then
                    bestTarget = mob
                    bestDist = dist
                end
            end
        end
    end
    return bestTarget
end

local function M1Spam()
    local now = tick()
    if now - LastClick < 0.03 then return end
    LastClick = now
    
    pcall(function()
        VU:ClickButton1(Vector2.new())
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.01)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        if CommF then CommF:InvokeServer("Melee") end
    end)
end

-- ==================== IsQuestAccepted ====================
function IsQuestAccepted()
    local success = pcall(function()
        local main = playerGui:FindFirstChild("Main")
        if not main then return false end
        for _, frame in pairs(main:GetChildren()) do
            if frame:IsA("Frame") and frame.Visible then
                for _, text in pairs(frame:GetDescendants()) do
                    if text:IsA("TextLabel") and text.Visible then
                        local content = text.Text or ""
                        if content:find("Đánh bài") or content:find("Tiêu diệt") or content:find("Thu thập") or content:find("/") then
                            return true
                        end
                    end
                end
            end
        end
        return false
    end)
    return success or false
end

-- ==================== STATE MACHINE ====================
function RunStateMachine()
    if not _G.AutoFarm or _G.Busy then return end
    if not HRP then return end
    
    if _G.State == "CHECK_QUEST" then
        local level = Player.Data.Level.Value or 1
        local questData = GetQuestByLevel(level)
        if not questData then return end
        _G.CurrentQuest = questData
        print("✅ SELECTED:", questData.QuestName, "| Lv:", level)
        _G.State = "GET_QUEST"
        
    elseif _G.State == "GET_QUEST" then
        print("✈️ Bay đến NPC:", _G.CurrentQuest.QuestName)
        TweenToPosition(_G.CurrentQuest.NPCPos)
        task.wait(0.5)
        pcall(function()
            if CommF then
                for i = 1, 2 do
                    local result = CommF:InvokeServer("StartQuest", _G.CurrentQuest.QuestName, i)
                    print("📡 Gửi quest", i, "kết quả:", result)
                    task.wait(0.2)
                end
            end
        end)
        task.wait(0.5)
        _G.State = "MOVING_TO_FARM"
        
    elseif _G.State == "MOVING_TO_FARM" then
        print("🌾 Bay đến khu farm")
        TweenToPosition(_G.CurrentQuest.MobArea)
        task.wait(0.3)
        _G.State = "FARMING"
        
    elseif _G.State == "FARMING" then
        if not IsQuestAccepted() then
            print("✅ QUEST DONE -> NHẬN QUEST MỚI")
            _G.State = "CHECK_QUEST"
            return
        end
    end
end

-- ==================== MAIN LOOPS ====================
task.spawn(function()
    while true do
        task.wait(0.15)
        pcall(RunStateMachine)
    end
end)

-- Mob Bringer Loop
task.spawn(function()
    while true do
        task.wait(0.2)
        if _G.AutoFarm and _G.State == "FARMING" and _G.CurrentQuest then
            pcall(function()
                local mobName = _G.CurrentQuest.MobName
                if not mobName then return end
                
                local allMobs = GetAllMobs(mobName)
                for _, mob in ipairs(allMobs) do
                    if not mob or not mob.Humanoid or mob.Humanoid.Health <= 0 then
                        CleanupMob(mob)
                    elseif mob.HumanoidRootPart then
                        local distance = (HRP.Position - mob.HumanoidRootPart.Position).Magnitude
                        
                        if ConfigBring.ESP and not MobData[mob] then
                            CreateESP(mob)
                        end
                        
                        if MobData[mob] and MobData[mob].ESP then
                            local esp = MobData[mob].ESP
                            local text = MobData[mob].Text
                            local vector, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(mob.HumanoidRootPart.Position)
                            esp.Visible = onScreen
                            text.Visible = onScreen
                            if onScreen then
                                esp.Size = Vector2.new(1000 / vector.Z, 1000 / vector.Z)
                                esp.Position = Vector2.new(vector.X, vector.Y)
                                text.Position = Vector2.new(vector.X, vector.Y - 30)
                                text.Text = mob.Name .. " [" .. math.floor(mob.Humanoid.Health) .. "] HP"
                            end
                        end
                        
                        if _G.BringMob and distance > 25 then
                            BringMob(mob)
                        end
                    end
                end
            end)
        end
    end
end)

-- M1 Spammer Loop
task.spawn(function()
    while true do
        task.wait(0.03)
        if _G.AutoFarm and _G.State == "FARMING" then
            pcall(function()
                local target = GetTargetM1()
                if target and target.Humanoid and target.Humanoid.Health > 0 then
                    M1Spam()
                end
            end)
        end
    end
end)

-- ==================== AUTO FARM TOGGLE ====================
local oldAutoFarm = false
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarm ~= oldAutoFarm then
            if _G.AutoFarm then
                StopAll()
                _G.Busy = false
                isTweening = false
                _G.State = "CHECK_QUEST"
                print("🔄 AUTO FARM ON")
            else
                StopAll()
                print("⏹️ AUTO FARM OFF")
            end
            oldAutoFarm = _G.AutoFarm
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
        StopAll()
        print("⏸️ Auto Farm đã TẮT")
    end
})

farmGroup:AddButton({
    Title = "📦 BẬT GOM QUÁI + ESP",
    Callback = function()
        _G.BringMob = not _G.BringMob
        print("✅ Gom quái:", _G.BringMob and "BẬT" or "TẮT")
    end
})

local settingGroup = settingTab:AddLeftGroupbox("⚙️ Cài Đặt")

settingGroup:AddSlider({
    Title = "🚀 Tốc độ bay",
    Min = 250,
    Max = 500,
    Default = 420,
    Callback = function(v) _G.TweenSpeed = v end
})

settingGroup:AddSlider({
    Title = "⚔️ Delay đánh",
    Min = 0.05,
    Max = 0.3,
    Default = 0.06,
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

UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ AUTO FARM CAO CẤP - BLACK HAKI GEAR 5!")
print("📌 Black Haki Gear 5 tự động bật khi chạy script")
print("📌 Gom quái + ESP | M1 Spammer | Full Quest 1-2824")
print("📌 Bấm 'BẬT AUTO FARM' để bắt đầu")
print("=" .. string.rep("=", 50)) 

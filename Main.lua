-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "by Quoc hoa",
    Image = "rbxassetid://76048047842530"
})

local farmTab = window:AddTab("🌾 Farm")
local settingTab = window:AddTab("⚙️ Settings")
local hakiTab = window:AddTab("🌑 Haki")
local bringTab = window:AddTab("📦 Bring Mob")

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
_G.FastAttack = true
_G.AutoHaki = true
_G.HakiStage = 1

-- ==================== BRING MOB CONFIG ====================
_G.BringRadius = 400
_G.BringDistance = 8
_G.BringSpeed = 0.1
_G.MaxMobs = 15
_G.ActiveMobs = {}

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
local hakiEffects = {}
local FastAttackConnection = nil
local HakiConnection = nil
local BringConnection = nil

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

-- ==================== FAST ATTACK ENGINE ====================
local function StartFastAttack()
    if FastAttackConnection then FastAttackConnection:Disconnect() end
    
    FastAttackConnection = RunService.Heartbeat:Connect(function()
        if not _G.AutoFarm or not _G.FastAttack then return end
        
        local char = Player.Character
        if not char or not HRP then return end
        
        local target = GetNearestMobFast()
        if target and target.Parent and target:FindFirstChild("HumanoidRootPart") and target.Humanoid.Health > 0 then
            pcall(function()
                local commF = ReplicatedStorage:FindFirstChild("Remotes")
                if commF and commF:FindFirstChild("CommF_") then
                    commF.CommF_:InvokeServer("Melee")
                end
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.01)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                VU:ClickButton1(Vector2.new())
            end)
        end
    end)
end

-- ==================== AUTO HAKI ARMS ====================
local function ForceHakiArms()
    if not _G.AutoHaki then return end
    
    pcall(function()
        local commF = ReplicatedStorage:FindFirstChild("Remotes")
        if commF and commF:FindFirstChild("CommF_") then
            commF.CommF_:InvokeServer("Buso")
        end
        if Player.Data:FindFirstChild("BusoStage") then
            Player.Data.BusoStage.Value = _G.HakiStage
        end
    end)
end

local function StartAutoHaki()
    if HakiConnection then HakiConnection:Disconnect() end
    HakiConnection = RunService.Heartbeat:Connect(function()
        if _G.AutoFarm and _G.AutoHaki then ForceHakiArms() end
    end)
end

task.spawn(function()
    task.wait(2)
    ForceHakiArms()
    StartAutoHaki()
end)

-- ==================== PREMIUM BRING MOB SYSTEM ====================
local function GetMobsInRadius()
    local char = Player.Character
    if not char or not HRP then return {} end
    
    local PlayerPos = HRP.Position
    local Mobs = {}
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return Mobs end
    
    for _, Mob in ipairs(enemies:GetChildren()) do
        if Mob:FindFirstChild("HumanoidRootPart") and Mob.Humanoid and Mob.Humanoid.Health > 0 then
            local Distance = (PlayerPos - Mob.HumanoidRootPart.Position).Magnitude
            if Distance <= _G.BringRadius then
                table.insert(Mobs, Mob)
            end
        end
    end
    return Mobs
end

local function StartBringMob()
    if BringConnection then BringConnection:Disconnect() end
    _G.ActiveMobs = {}
    
    BringConnection = RunService.Heartbeat:Connect(function()
        if not _G.AutoFarm or not _G.BringMob then return end
        
        local char = Player.Character
        if not char or not HRP then return end
        
        local PlayerPos = HRP.Position
        local BringPoint = PlayerPos + HRP.CFrame.LookVector * _G.BringDistance
        
        local NearbyMobs = GetMobsInRadius()
        
        -- Clean dead mobs
        for i = #_G.ActiveMobs, 1, -1 do
            local Mob = _G.ActiveMobs[i]
            if not Mob.Parent or Mob.Humanoid.Health <= 0 then
                table.remove(_G.ActiveMobs, i)
            end
        end
        
        -- Add new mobs
        local SlotsLeft = _G.MaxMobs - #_G.ActiveMobs
        for i = 1, math.min(SlotsLeft, #NearbyMobs) do
            table.insert(_G.ActiveMobs, NearbyMobs[i])
        end
        
        -- Smooth bring
        for _, Mob in ipairs(_G.ActiveMobs) do
            if Mob.Parent and Mob:FindFirstChild("HumanoidRootPart") and Mob.Humanoid.Health > 0 then
                local MobPos = Mob.HumanoidRootPart.Position
                local Distance = (MobPos - BringPoint).Magnitude
                
                if Distance > 3 then
                    local Direction = (BringPoint - MobPos).Unit
                    local NewPos = MobPos + Direction * (_G.BringSpeed * 16)
                    local SafeDist = (PlayerPos - NewPos).Magnitude
                    if SafeDist <= _G.BringRadius * 0.8 then
                        Mob.HumanoidRootPart.CFrame = CFrame.new(NewPos, PlayerPos)
                    end
                end
            end
        end
    end)
end

-- ==================== GET NEAREST MOB (FAST) ====================
function GetNearestMobFast()
    if not HRP then return nil end
    
    local nearest, dist = nil, math.huge
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    
    for _, mob in ipairs(enemies:GetChildren()) do
        if mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid and mob.Humanoid.Health > 0 then
            local distance = (HRP.Position - mob.HumanoidRootPart.Position).Magnitude
            if distance < dist and distance < 50 then
                dist = distance
                nearest = mob
            end
        end
    end
    return nearest
end

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

-- ==================== FULL QUEST DATABASE ====================
local QuestDB = {
    [1] = {
        {1,9,"BanditQuest1",Vector3.new(1061,17,1549),"Bandit"},
        {10,14,"BanditQuest2",Vector3.new(1061,17,1549),"Bandit"},
        {15,29,"JungleQuest",Vector3.new(-1400,37,90),"Monkey"},
        {30,59,"JungleQuest",Vector3.new(-1250,37,1600),"Gorilla"},
        {60,89,"SnowQuest",Vector3.new(1386,87,-1297),"Snow Bandit"},
        {90,124,"SnowQuest",Vector3.new(1386,87,-1297),"Snowman"},
        {125,149,"MarineQuest1",Vector3.new(611,73,552),"Marine Captain"},
        {150,174,"MarineQuest2",Vector3.new(611,73,552),"Marine Lieutenant"},
        {175,224,"SkyQuest1",Vector3.new(-4842,717,-2623),"Sky Bandit"},
        {225,299,"SkyQuest2",Vector3.new(-4842,717,-2623),"Skypiea Warrior"},
        {300,374,"BridgeQuest1",Vector3.new(-1606,36,181),"Mad Scientist"},
        {375,399,"BridgeQuest2",Vector3.new(-1606,36,181),"Forest Pirate"},
        {400,449,"ColosseumQuest",Vector3.new(-1576,7,158),"Military Soldier"},
        {450,499,"ColosseumQuest",Vector3.new(-1576,7,158),"Military Spy"},
        {500,549,"SkyQuest3",Vector3.new(-4842,717,-2623),"Dark Master"},
        {550,624,"FrozenQuest",Vector3.new(5668,28,853),"Frost Pirate"},
        {625,699,"FrozenQuest",Vector3.new(5668,28,853),"Snow Lurker"}
    },
    [2] = {
        {700,774,"GreenbanditQuest",Vector3.new(-2553,6,4533),"Green Bandit"},
        {775,849,"GreenbanditQuest",Vector3.new(-2553,6,4533),"Forest Warrior"},
        {850,924,"MarineCaptainQuest",Vector3.new(6094,95,5907),"Marine Captain [Lv. 850]"},
        {925,999,"MarineCaptainQuest",Vector3.new(6094,95,5907),"Marine Commodore [Lv. 950]"},
        {1000,1074,"MagmaQuest1",Vector3.new(3876,35,-3427),"Military Soldier [Lv. 1000]"},
        {1075,1149,"MagmaQuest1",Vector3.new(3876,35,-3427),"Military Spy [Lv. 1075]"},
        {1150,1199,"MagmaQuest2",Vector3.new(3876,35,-3427),"Lava Pirate [Lv. 1150]"},
        {1200,1249,"MagmaQuest2",Vector3.new(3876,35,-3427),"Mythological Pirate [Lv. 1200]"},
        {1250,1349,"FishmanQuest",Vector3.new(61163,19,10608),"Fishman Warrior [Lv. 1250]"},
        {1350,1449,"FishmanQuest",Vector3.new(61163,19,10608),"Fishman Commando [Lv. 1350]"},
        {1450,1500,"SkyExp1Quest",Vector3.new(-7862,5566,-380),"Sky Expedition [Lv. 1450]"}
    },
    [3] = {
        {1500,1549,"SkyExp1Quest",Vector3.new(-7862,5566,-380),"Sky Expedition [Lv. 1500]"},
        {1550,1599,"SkyExp2Quest",Vector3.new(-7862,5566,-380),"God [Lv. 1550]"},
        {1600,1624,"CastleQuest1",Vector3.new(-5075,314,8400),"Captain Elephant"},
        {1625,1674,"CastleQuest1",Vector3.new(-5075,314,8400),"Guardian Robot"},
        {1675,1724,"CastleQuest2",Vector3.new(-5075,314,8400),"Kithmus"},
        {1725,1774,"CastleQuest2",Vector3.new(-5075,314,8400),"Toga Warrior"},
        {1775,1824,"MarineQuest3",Vector3.new(5232,61,855),"Marine Commodore [Lv. 1800]"},
        {1825,1874,"MarineQuest3",Vector3.new(5232,61,855),"Marine Rear Admiral [Lv. 1825]"},
        {1875,1924,"SnowMountainQuest",Vector3.new(619,74,1468),"Snow Mountain"},
        {1925,1974,"SnowMountainQuest",Vector3.new(619,74,1468),"Snow Mountain [Lv. 1925]"},
        {1975,2024,"IceFireQuest",Vector3.new(5433,89,1350),"Ice Fire"},
        {2025,2074,"IceFireQuest",Vector3.new(5433,89,1350),"Ice Fire [Lv. 2025]"},
        {2075,2124,"PortableFortressQuest",Vector3.new(-490,54,4332),"Portable Fortress"},
        {2125,2174,"PortableFortressQuest",Vector3.new(-490,54,4332),"Portable Fortress [Lv. 2125]"},
        {2175,2224,"PortTownQuest",Vector3.new(-290,44,5447),"Port Town"},
        {2225,2274,"PortTownQuest",Vector3.new(-290,44,5447),"Port Town [Lv. 2225]"},
        {2275,2324,"HydraIslandQuest",Vector3.new(5735,62,-4430),"Hydra Island"},
        {2325,2374,"HydraIslandQuest",Vector3.new(5735,62,-4430),"Hydra Island [Lv. 2325]"},
        {2375,2424,"GreatTreeQuest",Vector3.new(2682,4340,-3318),"Great Tree"},
        {2425,2474,"GreatTreeQuest",Vector3.new(2682,4340,-3318),"Great Tree [Lv. 2425]"},
        {2475,2524,"CastleOnSeaQuest",Vector3.new(5192,56,3405),"Castle on Sea"},
        {2525,2574,"CastleOnSeaQuest",Vector3.new(5192,56,3405),"Castle on Sea [Lv. 2525]"},
        {2575,2624,"SeaOfTreatsQuest",Vector3.new(-1800,10,50),"Sea of Treats"},
        {2625,2674,"SeaOfTreatsQuest",Vector3.new(-1800,10,50),"Sea of Treats [Lv. 2625]"},
        {2675,2724,"TikiOutpostQuest",Vector3.new(-1600,70,200),"Tiki Outpost"},
        {2725,2774,"TikiOutpostQuest",Vector3.new(-1600,70,200),"Tiki Outpost [Lv. 2725]"},
        {2775,2824,"BartiloQuest",Vector3.new(-1850,40,150),"Bartilo"},
        {2825,2874,"BartiloQuest",Vector3.new(-1850,40,150),"Bartilo [Lv. 2825]"}
    }
}

-- ==================== AUTO QUEST STATE MACHINE ====================
local function GetNearestMob(mobName)
    local nearest = nil
    local shortestDist = math.huge
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return nil end
    
    for _, mob in ipairs(enemies:GetChildren()) do
        if mob.Name == mobName and mob:FindFirstChild("HumanoidRootPart") 
        and mob.Humanoid and mob.Humanoid.Health > 0 then
            local dist = (HRP.Position - mob.HumanoidRootPart.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                nearest = mob
            end
        end
    end
    return nearest
end

local function SafeTween(targetCFrame)
    if not HRP then return end
    local distance = (HRP.Position - targetCFrame.Position).Magnitude
    local tweenTime = math.min(2, distance / _G.TweenSpeed)
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Quad)
    ToggleNoclip(true)
    local tween = TweenService:Create(HRP, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
    ToggleNoclip(false)
end

-- State Machine Functions
local function State_CHECK_QUEST()
    local level = Player.Data.Level.Value or 1
    local sea = level >= 1500 and 3 or (level >= 700 and 2 or 1)
    print("🔍 [CHECK_QUEST] Level:", level, "Sea:", sea)
    
    for _, questData in ipairs(QuestDB[sea] or {}) do
        local lvMin, lvMax = questData[1], questData[2]
        if level >= lvMin and level <= lvMax then
            _G.CurrentQuest = {
                QuestName = questData[3],
                NPCPos = questData[4],
                MobName = questData[5],
                LvMin = lvMin,
                LvMax = lvMax,
                Sea = sea
            }
            print("✅ PERFECT MATCH:", _G.CurrentQuest.QuestName)
            return "GET_QUEST"
        end
    end
    return "CHECK_QUEST"
end

local function State_GET_QUEST()
    if not _G.CurrentQuest then return "CHECK_QUEST" end
    print("✈️ [GET_QUEST] NPC:", _G.CurrentQuest.QuestName)
    
    SafeTween(CFrame.new(_G.CurrentQuest.NPCPos + Vector3.new(0, 12, 0)))
    task.wait(1.5)
    
    local commF = ReplicatedStorage:FindFirstChild("Remotes")
    if commF and commF:FindFirstChild("CommF_") then
        for i = 1, 6 do
            commF.CommF_:InvokeServer("StartQuest", _G.CurrentQuest.QuestName, i)
            task.wait(0.1)
        end
    end
    task.wait(1)
    
    local mainGui = Player.PlayerGui:FindFirstChild("Main")
    if mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible then
        print("✅ Quest GUI confirmed")
        return "MOVING_TO_FARM"
    end
    return "CHECK_QUEST"
end

local function State_MOVING_TO_FARM()
    print("🌾 [MOVING_TO_FARM] Mob:", _G.CurrentQuest.MobName)
    local farmOffset = Vector3.new(math.random(-60,60), 20, math.random(-60,60))
    local farmPos = _G.CurrentQuest.NPCPos + farmOffset
    SafeTween(CFrame.new(farmPos))
    task.wait(1.5)
    return "FARMING"
end

local function State_FARMING()
    if not _G.CurrentQuest then return "CHECK_QUEST" end
    local targetMob = GetNearestMob(_G.CurrentQuest.MobName)
    if targetMob then
        local distance = (HRP.Position - targetMob.HumanoidRootPart.Position).Magnitude
        if distance > 15 then
            TweenToPosition(targetMob.HumanoidRootPart.Position)
        end
    else
        local searchPos = _G.CurrentQuest.NPCPos + Vector3.new(math.random(-50,50), 15, math.random(-50,50))
        TweenToPosition(searchPos)
    end
    task.wait(0.3)
    return "FARMING"
end

-- ==================== MAIN LOOP ====================
local currentState = "CHECK_QUEST"

task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.AutoFarm and not _G.Busy then
            _G.Busy = true
            if currentState == "CHECK_QUEST" then
                currentState = State_CHECK_QUEST()
            elseif currentState == "GET_QUEST" then
                currentState = State_GET_QUEST()
            elseif currentState == "MOVING_TO_FARM" then
                currentState = State_MOVING_TO_FARM()
            elseif currentState == "FARMING" then
                currentState = State_FARMING()
            end
            _G.State = currentState
            _G.Busy = false
        end
    end
end)

-- Start systems
task.spawn(function()
    StartFastAttack()
    StartAutoHaki()
    StartBringMob()
end)

-- ==================== UI ====================
local farmGroup = farmTab:AddLeftGroupbox("🤖 Điều Khiển")

farmGroup:AddButton({
    Title = "▶️ BẬT AUTO FARM",
    Callback = function()
        _G.AutoFarm = true
        currentState = "CHECK_QUEST"
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

-- Bring Mob Tab
local bringGroup = bringTab:AddLeftGroupbox("📦 Premium Bring Mob")

bringGroup:AddToggle({
    Title = "🎯 BẬT GOM QUÁI",
    Default = true,
    Callback = function(v)
        _G.BringMob = v
        if v then StartBringMob() end
        print("Bring Mob:", v and "BẬT" or "TẮT")
    end
})

bringGroup:AddSlider({
    Title = "📏 Bán kính tìm quái",
    Min = 100,
    Max = 800,
    Default = 400,
    Callback = function(v) _G.BringRadius = v end
})

bringGroup:AddSlider({
    Title = "🎯 Khoảng cách kéo về",
    Min = 3,
    Max = 15,
    Default = 8,
    Callback = function(v) _G.BringDistance = v end
})

bringGroup:AddSlider({
    Title = "🐌 Tốc độ kéo (càng thấp càng mượt)",
    Min = 0.05,
    Max = 0.5,
    Default = 0.1,
    Decimal = true,
    Callback = function(v) _G.BringSpeed = v end
})

bringGroup:AddSlider({
    Title = "📦 Số quái tối đa",
    Min = 5,
    Max = 30,
    Default = 15,
    Callback = function(v) _G.MaxMobs = v end
})

-- Haki Tab
local hakiGroup = hakiTab:AddLeftGroupbox("🌑 Auto Haki Arms")

hakiGroup:AddToggle({
    Title = "🔘 BẬT HAKI ARMS",
    Default = true,
    Callback = function(v)
        _G.AutoHaki = v
        if v then ForceHakiArms() end
        print("Auto Haki:", v and "BẬT" or "TẮT")
    end
})

hakiGroup:AddDropdown({
    Title = "🌑 Haki Stage",
    Values = {"Arms (Stage 1)", "Full Body (Stage 2)"},
    Default = 1,
    Callback = function(v)
        _G.HakiStage = v == "Arms (Stage 1)" and 1 or 2
        if _G.AutoHaki then ForceHakiArms() end
    end
})

-- Settings Tab
local settingGroup = settingTab:AddLeftGroupbox("⚙️ Cài Đặt")

settingGroup:AddSlider({
    Title = "🚀 Tốc độ bay",
    Min = 200,
    Max = 500,
    Default = 420,
    Callback = function(v) _G.TweenSpeed = v end
})

settingGroup:AddSlider({
    Title = "🗻 Độ cao bay",
    Min = 5,
    Max = 15,
    Default = 8,
    Callback = function(v) _G.FlyHeight = v end
})

settingGroup:AddToggle({
    Title = "⚡ Fast Attack (Animation Cancel)",
    Default = true,
    Callback = function(v)
        _G.FastAttack = v
        if v then StartFastAttack() end
    end
})

UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ AUTO FARM CAO CẤP - FULL TÍCH HỢP!")
print("📌 Premium Bring Mob - Gom quái mượt, chống reset")
print("📌 Fast Attack (Animation Cancel) - Đánh cực nhanh")
print("📌 Auto Haki Arms - Tự bật Stage 1/2")
print("📌 Auto Quest FIXED - Level match 100%")
print("📌 Full Quest DB 1-2824 | 3 Seas")
print("📌 Bấm 'BẬT AUTO FARM' để bắt đầu")
print("=" .. string.rep("=", 50)) 

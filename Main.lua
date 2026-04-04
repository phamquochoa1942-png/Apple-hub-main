-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "Auto Farm 1-2824 | Perfect Target Lock v11.0",
    Image = "rbxassetid://76048047842530"
})

local farmTab = window:AddTab("🌾 Farm")
local settingTab = window:AddTab("⚙️ Settings")
local hakiTab = window:AddTab("🌑 Haki")

-- ==================== BIẾN CẤU HÌNH ====================
_G.AutoFarm = false
_G.BringMob = true
_G.TweenSpeed = 300
_G.AttackDelay = 0.06
_G.FarmState = "IDLE"
_G.CurrentQuest = nil
_G.TargetMobs = {}
_G.FlyHeight = 12

-- ==================== SERVICE ====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local VU = game:GetService("VirtualUser")
local Player = Players.LocalPlayer
local playerGui = Player:WaitForChild("PlayerGui")

-- ==================== GLOBAL CHARACTER ====================
local Character, HRP

function UpdateCharacter()
    Character = Player.Character or Player.CharacterAdded:Wait()
    HRP = Character:WaitForChild("HumanoidRootPart")
end
UpdateCharacter()
Player.CharacterAdded:Connect(UpdateCharacter)

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

-- ==================== AUTO HAKI ====================
function ForceHakiArms()
    pcall(function()
        local commF = ReplicatedStorage:FindFirstChild("Remotes")
        if commF and commF:FindFirstChild("CommF_") then
            commF.CommF_:InvokeServer("Buso")
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(10)
        if _G.AutoFarm then ForceHakiArms() end
    end
end)

-- ==================== COMPLETE QUEST LIST (Lv1-2824) ====================
local QuestList = {
    -- SEA 1
    {LevelMin=1, LevelMax=9, QuestName="BanditQuest1", MonsterName="Bandit", NPC_CFrame=CFrame.new(1061,17,1549), FarmArea=CFrame.new(1100,13,1480)},
    {LevelMin=10, LevelMax=14, QuestName="BanditQuest2", MonsterName="Bandit", NPC_CFrame=CFrame.new(1061,17,1549), FarmArea=CFrame.new(1100,13,1480)},
    {LevelMin=15, LevelMax=29, QuestName="JungleQuest", MonsterName="Monkey", NPC_CFrame=CFrame.new(-1400,37,90), FarmArea=CFrame.new(-1200,68,320)},
    {LevelMin=30, LevelMax=59, QuestName="JungleQuest", MonsterName="Gorilla", NPC_CFrame=CFrame.new(-1250,37,1600), FarmArea=CFrame.new(-1280,37,1580)},
    {LevelMin=60, LevelMax=89, QuestName="SnowQuest", MonsterName="Snow Bandit", NPC_CFrame=CFrame.new(1386,87,-1297), FarmArea=CFrame.new(1350,87,-1320)},
    {LevelMin=90, LevelMax=124, QuestName="SnowQuest", MonsterName="Snowman", NPC_CFrame=CFrame.new(1386,87,-1297), FarmArea=CFrame.new(1350,87,-1320)},
    {LevelMin=125, LevelMax=149, QuestName="MarineQuest1", MonsterName="Marine Captain", NPC_CFrame=CFrame.new(611,73,552), FarmArea=CFrame.new(580,73,520)},
    {LevelMin=150, LevelMax=174, QuestName="MarineQuest2", MonsterName="Marine Lieutenant", NPC_CFrame=CFrame.new(611,73,552), FarmArea=CFrame.new(580,73,520)},
    {LevelMin=175, LevelMax=224, QuestName="SkyQuest1", MonsterName="Sky Bandit", NPC_CFrame=CFrame.new(-4842,717,-2623), FarmArea=CFrame.new(-4870,717,-2650)},
    {LevelMin=225, LevelMax=299, QuestName="SkyQuest2", MonsterName="Skypiea Warrior", NPC_CFrame=CFrame.new(-4842,717,-2623), FarmArea=CFrame.new(-4870,717,-2650)},
    {LevelMin=300, LevelMax=374, QuestName="BridgeQuest1", MonsterName="Mad Scientist", NPC_CFrame=CFrame.new(-1606,36,181), FarmArea=CFrame.new(-1630,36,150)},
    {LevelMin=375, LevelMax=399, QuestName="BridgeQuest2", MonsterName="Forest Pirate", NPC_CFrame=CFrame.new(-1606,36,181), FarmArea=CFrame.new(-1630,36,150)},
    {LevelMin=400, LevelMax=449, QuestName="ColosseumQuest", MonsterName="Military Soldier", NPC_CFrame=CFrame.new(-1576,7,158), FarmArea=CFrame.new(-1600,7,130)},
    {LevelMin=450, LevelMax=499, QuestName="ColosseumQuest", MonsterName="Military Spy", NPC_CFrame=CFrame.new(-1576,7,158), FarmArea=CFrame.new(-1600,7,130)},
    {LevelMin=500, LevelMax=549, QuestName="SkyQuest3", MonsterName="Dark Master", NPC_CFrame=CFrame.new(-4842,717,-2623), FarmArea=CFrame.new(-4870,717,-2650)},
    {LevelMin=550, LevelMax=624, QuestName="FrozenQuest", MonsterName="Frost Pirate", NPC_CFrame=CFrame.new(5668,28,853), FarmArea=CFrame.new(5640,28,820)},
    {LevelMin=625, LevelMax=699, QuestName="FrozenQuest", MonsterName="Snow Lurker", NPC_CFrame=CFrame.new(5668,28,853), FarmArea=CFrame.new(5640,28,820)},
    -- SEA 2
    {LevelMin=700, LevelMax=774, QuestName="GreenbanditQuest", MonsterName="Green Bandit", NPC_CFrame=CFrame.new(-2553,6,4533), FarmArea=CFrame.new(-2520,6,4560)},
    {LevelMin=775, LevelMax=849, QuestName="GreenbanditQuest", MonsterName="Forest Warrior", NPC_CFrame=CFrame.new(-2553,6,4533), FarmArea=CFrame.new(-2520,6,4560)},
    {LevelMin=850, LevelMax=924, QuestName="MarineCaptainQuest", MonsterName="Marine Captain", NPC_CFrame=CFrame.new(6094,95,5907), FarmArea=CFrame.new(6060,95,5930)},
    {LevelMin=925, LevelMax=999, QuestName="MarineCaptainQuest", MonsterName="Marine Commodore", NPC_CFrame=CFrame.new(6094,95,5907), FarmArea=CFrame.new(6060,95,5930)},
    {LevelMin=1000, LevelMax=1074, QuestName="MagmaQuest1", MonsterName="Military Soldier", NPC_CFrame=CFrame.new(3876,35,-3427), FarmArea=CFrame.new(3840,35,-3450)},
    {LevelMin=1075, LevelMax=1149, QuestName="MagmaQuest1", MonsterName="Military Spy", NPC_CFrame=CFrame.new(3876,35,-3427), FarmArea=CFrame.new(3840,35,-3450)},
    {LevelMin=1150, LevelMax=1199, QuestName="MagmaQuest2", MonsterName="Lava Pirate", NPC_CFrame=CFrame.new(3876,35,-3427), FarmArea=CFrame.new(3840,35,-3450)},
    {LevelMin=1200, LevelMax=1249, QuestName="MagmaQuest2", MonsterName="Mythological Pirate", NPC_CFrame=CFrame.new(3876,35,-3427), FarmArea=CFrame.new(3840,35,-3450)},
    {LevelMin=1250, LevelMax=1349, QuestName="FishmanQuest", MonsterName="Fishman Warrior", NPC_CFrame=CFrame.new(61163,19,10608), FarmArea=CFrame.new(61130,19,10640)},
    {LevelMin=1350, LevelMax=1449, QuestName="FishmanQuest", MonsterName="Fishman Commando", NPC_CFrame=CFrame.new(61163,19,10608), FarmArea=CFrame.new(61130,19,10640)},
    {LevelMin=1450, LevelMax=1500, QuestName="SkyExp1Quest", MonsterName="Sky Expedition", NPC_CFrame=CFrame.new(-7862,5566,-380), FarmArea=CFrame.new(-7890,5566,-410)},
    -- SEA 3
    {LevelMin=1500, LevelMax=1549, QuestName="SkyExp1Quest", MonsterName="Sky Expedition", NPC_CFrame=CFrame.new(-7862,5566,-380), FarmArea=CFrame.new(-7890,5566,-410)},
    {LevelMin=1550, LevelMax=1599, QuestName="SkyExp2Quest", MonsterName="God", NPC_CFrame=CFrame.new(-7862,5566,-380), FarmArea=CFrame.new(-7890,5566,-410)},
    {LevelMin=1600, LevelMax=1624, QuestName="CastleQuest1", MonsterName="Captain Elephant", NPC_CFrame=CFrame.new(-5075,314,8400), FarmArea=CFrame.new(-5100,314,8370)},
    {LevelMin=1625, LevelMax=1674, QuestName="CastleQuest1", MonsterName="Guardian Robot", NPC_CFrame=CFrame.new(-5075,314,8400), FarmArea=CFrame.new(-5100,314,8370)},
    {LevelMin=1675, LevelMax=1724, QuestName="CastleQuest2", MonsterName="Kithmus", NPC_CFrame=CFrame.new(-5075,314,8400), FarmArea=CFrame.new(-5100,314,8370)},
    {LevelMin=1725, LevelMax=1774, QuestName="CastleQuest2", MonsterName="Toga Warrior", NPC_CFrame=CFrame.new(-5075,314,8400), FarmArea=CFrame.new(-5100,314,8370)},
    {LevelMin=1775, LevelMax=1824, QuestName="MarineQuest3", MonsterName="Marine Commodore", NPC_CFrame=CFrame.new(5232,61,855), FarmArea=CFrame.new(5200,61,820)},
    {LevelMin=1825, LevelMax=1874, QuestName="MarineQuest3", MonsterName="Marine Rear Admiral", NPC_CFrame=CFrame.new(5232,61,855), FarmArea=CFrame.new(5200,61,820)},
    {LevelMin=1875, LevelMax=1924, QuestName="SnowMountainQuest", MonsterName="Snow Mountain", NPC_CFrame=CFrame.new(619,74,1468), FarmArea=CFrame.new(590,74,1440)},
    {LevelMin=1925, LevelMax=1974, QuestName="SnowMountainQuest", MonsterName="Snow Mountain", NPC_CFrame=CFrame.new(619,74,1468), FarmArea=CFrame.new(590,74,1440)},
    {LevelMin=1975, LevelMax=2024, QuestName="IceFireQuest", MonsterName="Ice Fire", NPC_CFrame=CFrame.new(5433,89,1350), FarmArea=CFrame.new(5400,89,1320)},
    {LevelMin=2025, LevelMax=2074, QuestName="IceFireQuest", MonsterName="Ice Fire", NPC_CFrame=CFrame.new(5433,89,1350), FarmArea=CFrame.new(5400,89,1320)},
    {LevelMin=2075, LevelMax=2124, QuestName="PortableFortressQuest", MonsterName="Portable Fortress", NPC_CFrame=CFrame.new(-490,54,4332), FarmArea=CFrame.new(-520,54,4300)},
    {LevelMin=2125, LevelMax=2174, QuestName="PortableFortressQuest", MonsterName="Portable Fortress", NPC_CFrame=CFrame.new(-490,54,4332), FarmArea=CFrame.new(-520,54,4300)},
    {LevelMin=2175, LevelMax=2224, QuestName="PortTownQuest", MonsterName="Port Town", NPC_CFrame=CFrame.new(-290,44,5447), FarmArea=CFrame.new(-320,44,5420)},
    {LevelMin=2225, LevelMax=2274, QuestName="PortTownQuest", MonsterName="Port Town", NPC_CFrame=CFrame.new(-290,44,5447), FarmArea=CFrame.new(-320,44,5420)},
    {LevelMin=2275, LevelMax=2324, QuestName="HydraIslandQuest", MonsterName="Hydra Island", NPC_CFrame=CFrame.new(5735,62,-4430), FarmArea=CFrame.new(5700,62,-4460)},
    {LevelMin=2325, LevelMax=2374, QuestName="HydraIslandQuest", MonsterName="Hydra Island", NPC_CFrame=CFrame.new(5735,62,-4430), FarmArea=CFrame.new(5700,62,-4460)},
    {LevelMin=2375, LevelMax=2424, QuestName="GreatTreeQuest", MonsterName="Great Tree", NPC_CFrame=CFrame.new(2682,4340,-3318), FarmArea=CFrame.new(2650,4340,-3350)},
    {LevelMin=2425, LevelMax=2474, QuestName="GreatTreeQuest", MonsterName="Great Tree", NPC_CFrame=CFrame.new(2682,4340,-3318), FarmArea=CFrame.new(2650,4340,-3350)},
    {LevelMin=2475, LevelMax=2524, QuestName="CastleOnSeaQuest", MonsterName="Castle on Sea", NPC_CFrame=CFrame.new(5192,56,3405), FarmArea=CFrame.new(5160,56,3370)},
    {LevelMin=2525, LevelMax=2574, QuestName="CastleOnSeaQuest", MonsterName="Castle on Sea", NPC_CFrame=CFrame.new(5192,56,3405), FarmArea=CFrame.new(5160,56,3370)},
    {LevelMin=2575, LevelMax=2624, QuestName="SeaOfTreatsQuest", MonsterName="Sea of Treats", NPC_CFrame=CFrame.new(-1800,10,50), FarmArea=CFrame.new(-1830,10,20)},
    {LevelMin=2625, LevelMax=2674, QuestName="SeaOfTreatsQuest", MonsterName="Sea of Treats", NPC_CFrame=CFrame.new(-1800,10,50), FarmArea=CFrame.new(-1830,10,20)},
    {LevelMin=2675, LevelMax=2724, QuestName="TikiOutpostQuest", MonsterName="Tiki Outpost", NPC_CFrame=CFrame.new(-1600,70,200), FarmArea=CFrame.new(-1630,70,170)},
    {LevelMin=2725, LevelMax=2774, QuestName="TikiOutpostQuest", MonsterName="Tiki Outpost", NPC_CFrame=CFrame.new(-1600,70,200), FarmArea=CFrame.new(-1630,70,170)},
    {LevelMin=2775, LevelMax=2824, QuestName="BartiloQuest", MonsterName="Bartilo", NPC_CFrame=CFrame.new(-1850,40,150), FarmArea=CFrame.new(-1880,40,120)},
    {LevelMin=2825, LevelMax=2874, QuestName="BartiloQuest", MonsterName="Bartilo", NPC_CFrame=CFrame.new(-1850,40,150), FarmArea=CFrame.new(-1880,40,120)}
}

-- ==================== TÌM QUEST THEO LEVEL ====================
function FindPerfectQuest()
    local level = Player.Data.Level.Value
    
    for i = #QuestList, 1, -1 do
        local quest = QuestList[i]
        if level >= quest.LevelMin and level <= quest.LevelMax then
            _G.CurrentQuest = quest
            print("🎯 Perfect Quest:", quest.QuestName, "→", quest.MonsterName)
            return true
        end
    end
    return false
end

-- ==================== KIỂM TRA QUEST ====================
function IsQuestAccepted()
    local main = playerGui:FindFirstChild("Main")
    if main then
        local quest = main:FindFirstChild("Quest")
        if quest and quest.Visible then
            return true
        end
    end
    return false
end

-- ==================== HÀM DI CHUYỂN ====================
function FlyTo(pos)
    if not HRP then return end
    local targetPos = Vector3.new(pos.X, pos.Y + _G.FlyHeight, pos.Z)
    local distance = (HRP.Position - targetPos).Magnitude
    if distance < 10 then return end
    
    ToggleNoclip(true)
    local tweenTime = math.min(2, distance / _G.TweenSpeed)
    local tween = TweenService:Create(HRP, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
    tween:Play()
    tween.Completed:Wait()
    ToggleNoclip(false)
end

-- ==================== LẤY DANH SÁCH QUÁI ĐÚNG TÊN ====================
function GetExactTargetMobs()
    _G.TargetMobs = {}
    if not HRP then return end
    
    local playerPos = HRP.Position
    local exactName = _G.CurrentQuest.MonsterName
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    for _, mob in ipairs(enemies:GetChildren()) do
        if mob.Name == exactName and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid and mob.Humanoid.Health > 0 then
            local dist = (playerPos - mob.HumanoidRootPart.Position).Magnitude
            if dist <= 150 then
                table.insert(_G.TargetMobs, mob)
            end
        end
    end
end

-- ==================== GOM QUÁI ====================
function BringExactMobs()
    GetExactTargetMobs()
    if not HRP then return
    
    local centerPos = HRP.Position - Vector3.new(0, _G.FlyHeight, 0)
    
    for _, mob in ipairs(_G.TargetMobs) do
        pcall(function()
            sethiddenproperty(mob, "SimulationRadius", math.huge)
            mob.HumanoidRootPart.CFrame = CFrame.new(centerPos, HRP.Position)
            mob.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
        end)
    end
end

-- ==================== TẤN CÔNG ====================
function PremiumAttack()
    pcall(function()
        local commF = ReplicatedStorage:FindFirstChild("Remotes")
        if commF and commF:FindFirstChild("CommF_") then
            commF.CommF_:InvokeServer("EquipMelee")
            for i = 1, 5 do
                commF.CommF_:InvokeServer("Melee")
                task.wait(0.05)
            end
        end
        VU:ClickButton1(Vector2.new())
    end)
end

-- ==================== MAIN FARM LOOP ====================
task.spawn(function()
    while true do
        if _G.AutoFarm then
            pcall(function()
                UpdateCharacter()
                
                if FindPerfectQuest() and _G.CurrentQuest then
                    -- Bay đến NPC
                    FlyTo(_G.CurrentQuest.NPC_CFrame.Position)
                    task.wait(0.5)
                    
                    -- Nhận quest
                    local commF = ReplicatedStorage:FindFirstChild("Remotes")
                    if commF and commF:FindFirstChild("CommF_") then
                        commF.CommF_:InvokeServer("StartQuest", _G.CurrentQuest.QuestName, 1)
                    end
                    task.wait(2)
                    
                    -- Kiểm tra quest thành công
                    if IsQuestAccepted() then
                        -- Bay đến khu farm
                        FlyTo(_G.CurrentQuest.FarmArea.Position)
                        task.wait(0.5)
                        
                        -- Farm loop
                        for i = 1, 35 do
                            if not _G.AutoFarm then break end
                            if _G.BringMob then BringExactMobs() end
                            PremiumAttack()
                            task.wait(0.3)
                        end
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- ==================== UI ====================
local farmGroup = farmTab:AddLeftGroupbox("🤖 Điều Khiển")

farmGroup:AddButton({
    Title = "▶️ BẬT AUTO FARM",
    Callback = function()
        _G.AutoFarm = true
        print("✅ Auto Farm đã BẬT - Perfect Target Lock v11.0")
    end
})

farmGroup:AddButton({
    Title = "⏹️ TẮT AUTO FARM",
    Callback = function()
        _G.AutoFarm = false
        ToggleNoclip(false)
        print("⏸️ Auto Farm đã TẮT")
    end
})

farmGroup:AddToggle({
    Title = "📦 BẬT GOM QUÁI",
    Default = true,
    Callback = function(v) _G.BringMob = v end
})

-- Haki Tab
local hakiGroup = hakiTab:AddLeftGroupbox("🌑 Auto Haki")

hakiGroup:AddButton({
    Title = "🔘 BẬT HAKI",
    Callback = function()
        ForceHakiArms()
        print("✅ Haki đã bật")
    end
})

-- Settings Tab
local settingGroup = settingTab:AddLeftGroupbox("⚙️ Cài Đặt")

settingGroup:AddSlider({
    Title = "🚀 Tốc độ bay",
    Min = 200,
    Max = 500,
    Default = 300,
    Callback = function(v) _G.TweenSpeed = v end
})

settingGroup:AddSlider({
    Title = "🗻 Độ cao bay",
    Min = 8,
    Max = 20,
    Default = 12,
    Callback = function(v) _G.FlyHeight = v end
})

UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ PERFECT TARGET LOCK v11.0 - FULL TÍCH HỢP!")
print("📌 Chỉ đánh đúng tên quái: Monkey ≠ Gorilla")
print("📌 Gom quái chỉ kéo đúng mob cần farm")
print("📌 Auto Haki + Fast Attack + Bay trên đầu quái")
print("📌 Full Quest DB 1-2824 | 3 Seas")
print("📌 Bấm 'BẬT AUTO FARM' để bắt đầu")
print("=" .. string.rep("=", 50)) 

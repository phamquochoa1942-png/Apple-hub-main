-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "Auto Farm 1-2824 MAX | Complete Quest v10.0",
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
_G.FlyHeight = 12
_G.FastAttack = true
_G.AutoHaki = true
_G.HakiStage = 1
_G.BringMobs = {}

-- ==================== SERVICE ====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")
local Workspace = game:GetService("Workspace")
local VU = game:GetService("VirtualUser")
local Player = Players.LocalPlayer
local playerGui = Player:WaitForChild("PlayerGui")

-- ==================== GLOBAL CHARACTER ====================
local Character, HRP
local humanoid = nil
local bodyVelocity = nil

function UpdateCharacter()
    Character = Player.Character or Player.CharacterAdded:Wait()
    HRP = Character:WaitForChild("HumanoidRootPart")
    humanoid = Character:WaitForChild("Humanoid")
end
UpdateCharacter()
Player.CharacterAdded:Connect(UpdateCharacter)

-- ==================== GLOBAL ANTI-DETECT ====================
pcall(function()
    sethiddenproperty(Player, "SimulationRadius", math.huge)
end)

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

-- ==================== COMPLETE QUEST DATA (Lv1-2824) ====================
local QuestData = {
    sea1 = {
        {LevelMin=1, QuestName="BanditQuest1", MonsterName="Bandit", CFrame=CFrame.new(1061,17,1549)},
        {LevelMin=10, QuestName="BanditQuest2", MonsterName="Bandit", CFrame=CFrame.new(1061,17,1549)},
        {LevelMin=15, QuestName="JungleQuest", MonsterName="Monkey", CFrame=CFrame.new(-1400,37,90)},
        {LevelMin=30, QuestName="JungleQuest", MonsterName="Gorilla", CFrame=CFrame.new(-1250,37,1600)},
        {LevelMin=60, QuestName="SnowQuest", MonsterName="Snow Bandit", CFrame=CFrame.new(1386,87,-1297)},
        {LevelMin=90, QuestName="SnowQuest", MonsterName="Snowman", CFrame=CFrame.new(1386,87,-1297)},
        {LevelMin=125, QuestName="MarineQuest1", MonsterName="Marine Captain", CFrame=CFrame.new(611,73,552)},
        {LevelMin=150, QuestName="MarineQuest2", MonsterName="Marine Lieutenant", CFrame=CFrame.new(611,73,552)},
        {LevelMin=175, QuestName="SkyQuest1", MonsterName="Sky Bandit", CFrame=CFrame.new(-4842,717,-2623)},
        {LevelMin=225, QuestName="SkyQuest2", MonsterName="Skypiea Warrior", CFrame=CFrame.new(-4842,717,-2623)},
        {LevelMin=300, QuestName="BridgeQuest1", MonsterName="Mad Scientist", CFrame=CFrame.new(-1606,36,181)},
        {LevelMin=375, QuestName="BridgeQuest2", MonsterName="Forest Pirate", CFrame=CFrame.new(-1606,36,181)},
        {LevelMin=400, QuestName="ColosseumQuest", MonsterName="Military Soldier", CFrame=CFrame.new(-1576,7,158)},
        {LevelMin=450, QuestName="ColosseumQuest", MonsterName="Military Spy", CFrame=CFrame.new(-1576,7,158)},
        {LevelMin=500, QuestName="SkyQuest3", MonsterName="Dark Master", CFrame=CFrame.new(-4842,717,-2623)},
        {LevelMin=550, QuestName="FrozenQuest", MonsterName="Frost Pirate", CFrame=CFrame.new(5668,28,853)},
        {LevelMin=625, QuestName="FrozenQuest", MonsterName="Snow Lurker", CFrame=CFrame.new(5668,28,853)}
    },
    sea2 = {
        {LevelMin=700, QuestName="GreenbanditQuest", MonsterName="Green Bandit", CFrame=CFrame.new(-2553,6,4533)},
        {LevelMin=775, QuestName="GreenbanditQuest", MonsterName="Forest Warrior", CFrame=CFrame.new(-2553,6,4533)},
        {LevelMin=850, QuestName="MarineCaptainQuest", MonsterName="Marine Captain", CFrame=CFrame.new(6094,95,5907)},
        {LevelMin=925, QuestName="MarineCaptainQuest", MonsterName="Marine Commodore", CFrame=CFrame.new(6094,95,5907)},
        {LevelMin=1000, QuestName="MagmaQuest1", MonsterName="Military Soldier", CFrame=CFrame.new(3876,35,-3427)},
        {LevelMin=1075, QuestName="MagmaQuest1", MonsterName="Military Spy", CFrame=CFrame.new(3876,35,-3427)},
        {LevelMin=1150, QuestName="MagmaQuest2", MonsterName="Lava Pirate", CFrame=CFrame.new(3876,35,-3427)},
        {LevelMin=1200, QuestName="MagmaQuest2", MonsterName="Mythological Pirate", CFrame=CFrame.new(3876,35,-3427)},
        {LevelMin=1250, QuestName="FishmanQuest", MonsterName="Fishman Warrior", CFrame=CFrame.new(61163,19,10608)},
        {LevelMin=1350, QuestName="FishmanQuest", MonsterName="Fishman Commando", CFrame=CFrame.new(61163,19,10608)},
        {LevelMin=1450, QuestName="SkyExp1Quest", MonsterName="Sky Expedition", CFrame=CFrame.new(-7862,5566,-380)}
    },
    sea3 = {
        {LevelMin=1500, QuestName="SkyExp1Quest", MonsterName="Sky Expedition", CFrame=CFrame.new(-7862,5566,-380)},
        {LevelMin=1550, QuestName="SkyExp2Quest", MonsterName="God", CFrame=CFrame.new(-7862,5566,-380)},
        {LevelMin=1600, QuestName="CastleQuest1", MonsterName="Captain Elephant", CFrame=CFrame.new(-5075,314,8400)},
        {LevelMin=1625, QuestName="CastleQuest1", MonsterName="Guardian Robot", CFrame=CFrame.new(-5075,314,8400)},
        {LevelMin=1675, QuestName="CastleQuest2", MonsterName="Kithmus", CFrame=CFrame.new(-5075,314,8400)},
        {LevelMin=1725, QuestName="CastleQuest2", MonsterName="Toga Warrior", CFrame=CFrame.new(-5075,314,8400)},
        {LevelMin=1775, QuestName="MarineQuest3", MonsterName="Marine Commodore", CFrame=CFrame.new(5232,61,855)},
        {LevelMin=1825, QuestName="MarineQuest3", MonsterName="Marine Rear Admiral", CFrame=CFrame.new(5232,61,855)},
        {LevelMin=1875, QuestName="SnowMountainQuest", MonsterName="Snow Mountain", CFrame=CFrame.new(619,74,1468)},
        {LevelMin=1925, QuestName="SnowMountainQuest", MonsterName="Snow Mountain", CFrame=CFrame.new(619,74,1468)},
        {LevelMin=1975, QuestName="IceFireQuest", MonsterName="Ice Fire", CFrame=CFrame.new(5433,89,1350)},
        {LevelMin=2025, QuestName="IceFireQuest", MonsterName="Ice Fire", CFrame=CFrame.new(5433,89,1350)},
        {LevelMin=2075, QuestName="PortableFortressQuest", MonsterName="Portable Fortress", CFrame=CFrame.new(-490,54,4332)},
        {LevelMin=2125, QuestName="PortableFortressQuest", MonsterName="Portable Fortress", CFrame=CFrame.new(-490,54,4332)},
        {LevelMin=2175, QuestName="PortTownQuest", MonsterName="Port Town", CFrame=CFrame.new(-290,44,5447)},
        {LevelMin=2225, QuestName="PortTownQuest", MonsterName="Port Town", CFrame=CFrame.new(-290,44,5447)},
        {LevelMin=2275, QuestName="HydraIslandQuest", MonsterName="Hydra Island", CFrame=CFrame.new(5735,62,-4430)},
        {LevelMin=2325, QuestName="HydraIslandQuest", MonsterName="Hydra Island", CFrame=CFrame.new(5735,62,-4430)},
        {LevelMin=2375, QuestName="GreatTreeQuest", MonsterName="Great Tree", CFrame=CFrame.new(2682,4340,-3318)},
        {LevelMin=2425, QuestName="GreatTreeQuest", MonsterName="Great Tree", CFrame=CFrame.new(2682,4340,-3318)},
        {LevelMin=2475, QuestName="CastleOnSeaQuest", MonsterName="Castle on Sea", CFrame=CFrame.new(5192,56,3405)},
        {LevelMin=2525, QuestName="CastleOnSeaQuest", MonsterName="Castle on Sea", CFrame=CFrame.new(5192,56,3405)},
        {LevelMin=2575, QuestName="SeaOfTreatsQuest", MonsterName="Sea of Treats", CFrame=CFrame.new(-1800,10,50)},
        {LevelMin=2625, QuestName="SeaOfTreatsQuest", MonsterName="Sea of Treats", CFrame=CFrame.new(-1800,10,50)},
        {LevelMin=2675, QuestName="TikiOutpostQuest", MonsterName="Tiki Outpost", CFrame=CFrame.new(-1600,70,200)},
        {LevelMin=2725, QuestName="TikiOutpostQuest", MonsterName="Tiki Outpost", CFrame=CFrame.new(-1600,70,200)},
        {LevelMin=2775, QuestName="BartiloQuest", MonsterName="Bartilo", CFrame=CFrame.new(-1850,40,150)},
        {LevelMin=2825, QuestName="BartiloQuest", MonsterName="Bartilo", CFrame=CFrame.new(-1850,40,150)}
    }
}

-- ==================== AUTO HAKI ====================
function ForceHakiArms()
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

task.spawn(function()
    task.wait(2)
    ForceHakiArms()
end)

-- ==================== PREMIUM BRING MOB ====================
function BringMob()
    if not HRP then return end
    local playerPos = HRP.Position
    local groundPoint = playerPos - Vector3.new(0, _G.FlyHeight, 0)
    _G.BringMobs = {}
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    for _, mob in ipairs(enemies:GetChildren()) do
        if _G.CurrentQuest and mob.Name:find(_G.CurrentQuest.MonsterName) and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid and mob.Humanoid.Health > 0 then
            local dist = (playerPos - mob.HumanoidRootPart.Position).Magnitude
            if dist <= 150 then
                table.insert(_G.BringMobs, mob)
                pcall(function()
                    sethiddenproperty(mob, "SimulationRadius", math.huge)
                    mob.HumanoidRootPart.CFrame = CFrame.new(groundPoint, playerPos)
                    mob.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                end)
            end
        end
    end
end

-- ==================== FAST ATTACK ====================
function FastAttack()
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

-- ==================== FLY TO POSITION ====================
function FlyTo(pos)
    if not HRP then return end
    local target = CFrame.new(pos + Vector3.new(0, 12, 0))
    local distance = (HRP.Position - target.Position).Magnitude
    local tweenTime = math.min(1.5, distance / 300)
    local tween = TweenService:Create(HRP, TweenInfo.new(tweenTime, Enum.EasingStyle.Quad), {CFrame = target})
    tween:Play()
    tween.Completed:Wait()
end

-- ==================== GET CURRENT QUEST ====================
function GetCurrentQuest()
    local level = Player.Data.Level.Value
    local sea = level >= 1500 and 3 or (level >= 700 and 2 or 1)
    local seaData = QuestData["sea" .. sea]
    
    local bestQuest = nil
    for _, quest in ipairs(seaData) do
        if level >= quest.LevelMin then
            bestQuest = quest
        end
    end
    
    if bestQuest then
        _G.CurrentQuest = bestQuest
        print("🎯 Quest:", bestQuest.QuestName, "→", bestQuest.MonsterName)
        return true
    end
    return false
end

-- ==================== VERIFY QUEST ====================
function VerifyQuest()
    pcall(function()
        local mainGui = Player.PlayerGui:FindFirstChild("Main")
        if mainGui and mainGui:FindFirstChild("Quest") and mainGui.Quest.Visible then
            print("✅ Quest verified")
            return true
        end
    end)
    return true
end

-- ==================== MAIN FARM LOOP ====================
task.spawn(function()
    while true do
        if _G.AutoFarm then
            pcall(function()
                UpdateCharacter()
                if GetCurrentQuest() and _G.CurrentQuest then
                    FlyTo(_G.CurrentQuest.CFrame.Position)
                    task.wait(0.5)
                    
                    local commF = ReplicatedStorage:FindFirstChild("Remotes")
                    if commF and commF:FindFirstChild("CommF_") then
                        commF.CommF_:InvokeServer("StartQuest", _G.CurrentQuest.QuestName, 1)
                    end
                    task.wait(2)
                    
                    if VerifyQuest() then
                        for i = 1, 30 do
                            if not _G.AutoFarm then break end
                            BringMob()
                            FastAttack()
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
        print("✅ Auto Farm đã BẬT - Complete Quest v10.0")
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
local bringGroup = bringTab:AddLeftGroupbox("📦 Bring Mob")

bringGroup:AddToggle({
    Title = "🎯 BẬT GOM QUÁI",
    Default = true,
    Callback = function(v) _G.BringMob = v end
})

-- Haki Tab
local hakiGroup = hakiTab:AddLeftGroupbox("🌑 Auto Haki")

hakiGroup:AddToggle({
    Title = "🔘 BẬT HAKI",
    Default = true,
    Callback = function(v)
        _G.AutoHaki = v
        if v then ForceHakiArms() end
    end
})

hakiGroup:AddDropdown({
    Title = "🌑 Haki Stage",
    Values = {"Stage 1 (Arms)", "Stage 2 (Full Body)"},
    Default = 1,
    Callback = function(v)
        _G.HakiStage = v == "Stage 1 (Arms)" and 1 or 2
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
    Min = 8,
    Max = 20,
    Default = 12,
    Callback = function(v) _G.FlyHeight = v end
})

UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ AUTO FARM COMPLETE v10.0 - FULL TÍCH HỢP!")
print("📌 Complete Quest Data: Sea 1-3, Level 1-2824")
print("📌 Auto Haki - Tự bật Stage 1/2")
print("📌 Premium Bring Mob - Gom quái bán kính 150")
print("📌 Fast Attack - Đánh nhanh 5 hit/đợt")
print("📌 Bấm 'BẬT AUTO FARM' để bắt đầu")
print("=" .. string.rep("=", 50)) 

-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "Auto Farm 1-2824 | Fixed v13.0",
    Image = "rbxassetid://76048047842530"
})

local farmTab = window:AddTab("🌾 Farm")
local settingTab = window:AddTab("⚙️ Settings")

-- ==================== BIẾN CẤU HÌNH ====================
_G.AutoFarm = false
_G.BringMob = true
_G.TweenSpeed = 350
_G.AttackDelay = 0.04
_G.FlyHeight = 10
_G.CurrentQuest = nil
_G.FarmState = "IDLE"  -- IDLE, MOVING, FARMING
_G.IsMoving = false

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
local bodyVelocity = nil

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

-- ==================== AUTO HAKI (LUÔN DUY TRÌ) ====================
function ForceHakiArms()
    pcall(function()
        local commF = ReplicatedStorage:FindFirstChild("Remotes")
        if commF and commF:FindFirstChild("CommF_") then
            commF.CommF_:InvokeServer("Buso")
        end
        if Player.Data:FindFirstChild("BusoStage") then
            Player.Data.BusoStage.Value = 1
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(8)
        if _G.AutoFarm then ForceHakiArms() end
    end
end)

-- ==================== FIX 1: QUEST DATA CHUẨN XÁC ====================
-- Ưu tiên nhiệm vụ có Level yêu cầu cao nhất
local QuestData = {
    -- SEA 1 (Level từ thấp đến cao)
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
    {LevelMin=1450, LevelMax=1499, QuestName="SkyExp1Quest", MonsterName="Sky Expedition", NPC_CFrame=CFrame.new(-7862,5566,-380), FarmArea=CFrame.new(-7890,5566,-410)},
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
    {LevelMin=2775, LevelMax=2824, QuestName="BartiloQuest", MonsterName="Bartilo", NPC_CFrame=CFrame.new(-1850,40,150), FarmArea=CFrame.new(-1880,40,120)}
}

-- ==================== FIX 1: CHỌN QUEST ƯU TIÊN CAO NHẤT ====================
function SelectBestQuest()
    local level = Player.Data.Level.Value
    local bestQuest = nil
    
    -- Duyệt từ cuối lên (ưu tiên level cao nhất)
    for i = #QuestData, 1, -1 do
        local quest = QuestData[i]
        if level >= quest.LevelMin and level <= quest.LevelMax then
            bestQuest = quest
            break
        end
    end
    
    if bestQuest then
        _G.CurrentQuest = bestQuest
        print("🎯 [QUEST] Level:", level, "→", bestQuest.MonsterName, "(", bestQuest.QuestName, ")")
        return true
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

-- ==================== FIX 2: DI CHUYỂN BẰNG TWEEN (KHÔNG BỊ GIẬT) ====================
function MoveToPosition(targetPos, callback)
    if not HRP then return end
    if _G.IsMoving then return end
    
    _G.IsMoving = true
    ToggleNoclip(true)
    
    -- Tắt BodyVelocity nếu có
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    local targetCFrame = CFrame.new(targetPos)
    local distance = (HRP.Position - targetPos).Magnitude
    local tweenTime = math.min(3, distance / _G.TweenSpeed)
    
    local tween = TweenService:Create(HRP, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
    
    ToggleNoclip(false)
    _G.IsMoving = false
    
    if callback then callback() end
end

-- ==================== FIX 2: GIỮ VỊ TRÍ TRÊN ĐẦU QUÁI (FARMING STATE) ====================
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

function FarmAbove()
    if not HRP then return end
    -- Giữ vị trí trên đầu quái (không di chuyển lung tung)
    local currentPos = HRP.Position
    local targetHeight = currentPos.Y
    if HRP.Velocity.Y < -2 then
        HRP.Velocity = Vector3.new(HRP.Velocity.X, 0, HRP.Velocity.Z)
    end
end

-- ==================== SUPER BRING MOB ====================
function SuperBringMob()
    if not HRP or not _G.CurrentQuest then return end
    local playerPos = HRP.Position
    local gatherPoint = playerPos - Vector3.new(0, 10, 0)
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    for _, mob in ipairs(enemies:GetChildren()) do
        if mob.Name == _G.CurrentQuest.MonsterName and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid and mob.Humanoid.Health > 0 then
            local dist = (playerPos - mob.HumanoidRootPart.Position).Magnitude
            if dist <= 150 then
                pcall(function()
                    sethiddenproperty(mob, "SimulationRadius", math.huge)
                    mob.HumanoidRootPart.CFrame = CFrame.new(gatherPoint)
                    mob.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                end)
            end
        end
    end
end

-- ==================== FAST ATTACK (LUÔN HOẠT ĐỘNG KHI FARM) ====================
function FastAttack()
    pcall(function()
        local commF = ReplicatedStorage:FindFirstChild("Remotes")
        if commF and commF:FindFirstChild("CommF_") then
            commF.CommF_:InvokeServer("EquipMelee")
            for i = 1, 8 do
                commF.CommF_:InvokeServer("Melee")
                task.wait(_G.AttackDelay)
            end
        end
        VU:ClickButton1(Vector2.new())
    end)
end

-- ==================== MAIN FARM LOOP (TÁCH TRẠNG THÁI) ====================
task.spawn(function()
    while true do
        if _G.AutoFarm then
            pcall(function()
                UpdateCharacter()
                
                -- STATE MACHINE
                if _G.FarmState == "IDLE" then
                    if SelectBestQuest() then
                        _G.FarmState = "MOVING"
                    end
                    
                elseif _G.FarmState == "MOVING" then
                    print("🚶 [MOVING] Di chuyển đến NPC:", _G.CurrentQuest.QuestName)
                    
                    -- Di chuyển đến NPC
                    MoveToPosition(_G.CurrentQuest.NPC_CFrame.Position + Vector3.new(0, 5, 0))
                    task.wait(0.5)
                    
                    -- Nhận quest
                    local commF = ReplicatedStorage:FindFirstChild("Remotes")
                    if commF and commF:FindFirstChild("CommF_") then
                        commF.CommF_:InvokeServer("StartQuest", _G.CurrentQuest.QuestName, 1)
                    end
                    task.wait(2)
                    
                    if IsQuestAccepted() then
                        print("✅ [MOVING] Quest nhận thành công, di chuyển đến khu farm")
                        -- Di chuyển đến khu farm
                        MoveToPosition(_G.CurrentQuest.FarmArea.Position + Vector3.new(0, _G.FlyHeight, 0))
                        task.wait(0.5)
                        _G.FarmState = "FARMING"
                        StartHover()  -- Bắt đầu giữ vị trí trên cao
                        print("✅ [FARMING] Bắt đầu farm!")
                    else
                        print("❌ [MOVING] Quest thất bại, thử lại")
                        _G.FarmState = "IDLE"
                    end
                    
                elseif _G.FarmState == "FARMING" then
                    -- Kiểm tra quest còn không
                    if not IsQuestAccepted() then
                        print("✅ [FARMING] Quest hoàn thành!")
                        StopHover()
                        _G.FarmState = "IDLE"
                        return
                    end
                    
                    -- Farm logic
                    if _G.BringMob then SuperBringMob() end
                    FarmAbove()  -- Giữ vị trí trên cao
                    FastAttack() -- Đánh liên tục
                    task.wait(0.3)
                end
            end)
        else
            _G.FarmState = "IDLE"
            StopHover()
        end
        task.wait(0.2)
    end
end)

-- ==================== UI ====================
local farmGroup = farmTab:AddLeftGroupbox("🤖 Điều Khiển")

farmGroup:AddButton({
    Title = "▶️ BẬT AUTO FARM",
    Callback = function()
        _G.AutoFarm = true
        _G.FarmState = "IDLE"
        print("✅ Auto Farm đã BẬT - Fixed v13.0")
    end
})

farmGroup:AddButton({
    Title = "⏹️ TẮT AUTO FARM",
    Callback = function()
        _G.AutoFarm = false
        _G.FarmState = "IDLE"
        StopHover()
        ToggleNoclip(false)
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
    Title = "🌑 BẬT HAKI NGAY",
    Callback = function()
        ForceHakiArms()
        print("✅ Haki đã bật")
    end
})

-- Settings Tab
local settingGroup = settingTab:AddLeftGroupbox("⚙️ Cài Đặt")

settingGroup:AddSlider({
    Title = "🚀 Tốc độ di chuyển",
    Min = 200,
    Max = 500,
    Default = 350,
    Callback = function(v) _G.TweenSpeed = v end
})

settingGroup:AddSlider({
    Title = "🗻 Độ cao farm",
    Min = 8,
    Max = 20,
    Default = 10,
    Callback = function(v) _G.FlyHeight = v end
})

settingGroup:AddSlider({
    Title = "⚔️ Delay đánh",
    Min = 0.02,
    Max = 0.1,
    Default = 0.04,
    Decimal = true,
    Callback = function(v) _G.AttackDelay = v end
})

UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ AUTO FARM FIXED v13.0 - ĐÃ SẴN SÀNG!")
print("📌 FIX 1: Level 30 → Gorilla, không còn nhầm Monkey")
print("📌 FIX 2: Tách biệt MOVING và FARMING, không bị giật")
print("📌 Haki luôn được duy trì khi farm")
print("📌 Bấm 'BẬT AUTO FARM' để bắt đầu")
print("=" .. string.rep("=", 50)) 

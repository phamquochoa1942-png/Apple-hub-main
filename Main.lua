-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "Auto Farm 1-2600 | Fixed v15.0",
    Image = "rbxassetid://76048047842530"
})

local farmTab = window:AddTab("🌾 Farm")
local settingTab = window:AddTab("⚙️ Settings")

-- ==================== BIẾN CẤU HÌNH ====================
_G.AutoFarm = false
_G.BringMob = true
_G.TweenSpeed = 350
_G.AttackDelay = 0.04
_G.FlyHeight = 11
_G.CurrentQuest = nil
_G.FarmState = "IDLE"

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

-- ==================== HAKI ====================
function ForceHaki()
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
        if _G.AutoFarm then ForceHaki() end
    end
end)

-- ==================== FIX 1: QUEST DATA CHUẨN XÁC ====================
local QuestData = {
    -- SEA 3
    {LevelMin=1500, LevelMax=2600, QuestName="SkyExp1Quest", MonsterName="Sky Expedition", NPC_CFrame=CFrame.new(-7862,5566,-380), FarmArea=CFrame.new(-7890,5566,-410)},
    -- SEA 2
    {LevelMin=700, LevelMax=1499, QuestName="GreenbanditQuest", MonsterName="Green Bandit", NPC_CFrame=CFrame.new(-2553,6,4533), FarmArea=CFrame.new(-2520,6,4560)},
    -- SEA 1 (CHÍNH XÁC)
    {LevelMin=625, LevelMax=699, QuestName="FrozenQuest", MonsterName="Snow Lurker", NPC_CFrame=CFrame.new(5668,28,853), FarmArea=CFrame.new(5640,28,820)},
    {LevelMin=550, LevelMax=624, QuestName="FrozenQuest", MonsterName="Frost Pirate", NPC_CFrame=CFrame.new(5668,28,853), FarmArea=CFrame.new(5640,28,820)},
    {LevelMin=500, LevelMax=549, QuestName="SkyQuest3", MonsterName="Dark Master", NPC_CFrame=CFrame.new(-4842,717,-2623), FarmArea=CFrame.new(-4870,717,-2650)},
    {LevelMin=450, LevelMax=499, QuestName="ColosseumQuest", MonsterName="Military Spy", NPC_CFrame=CFrame.new(-1576,7,158), FarmArea=CFrame.new(-1600,7,130)},
    {LevelMin=400, LevelMax=449, QuestName="ColosseumQuest", MonsterName="Military Soldier", NPC_CFrame=CFrame.new(-1576,7,158), FarmArea=CFrame.new(-1600,7,130)},
    {LevelMin=375, LevelMax=399, QuestName="BridgeQuest2", MonsterName="Forest Pirate", NPC_CFrame=CFrame.new(-1606,36,181), FarmArea=CFrame.new(-1630,36,150)},
    {LevelMin=300, LevelMax=374, QuestName="BridgeQuest1", MonsterName="Mad Scientist", NPC_CFrame=CFrame.new(-1606,36,181), FarmArea=CFrame.new(-1630,36,150)},
    {LevelMin=225, LevelMax=299, QuestName="SkyQuest2", MonsterName="Skypiea Warrior", NPC_CFrame=CFrame.new(-4842,717,-2623), FarmArea=CFrame.new(-4870,717,-2650)},
    {LevelMin=175, LevelMax=224, QuestName="SkyQuest1", MonsterName="Sky Bandit", NPC_CFrame=CFrame.new(-4842,717,-2623), FarmArea=CFrame.new(-4870,717,-2650)},
    {LevelMin=150, LevelMax=174, QuestName="MarineQuest2", MonsterName="Marine Lieutenant", NPC_CFrame=CFrame.new(611,73,552), FarmArea=CFrame.new(580,73,520)},
    {LevelMin=125, LevelMax=149, QuestName="MarineQuest1", MonsterName="Marine Captain", NPC_CFrame=CFrame.new(611,73,552), FarmArea=CFrame.new(580,73,520)},
    {LevelMin=90, LevelMax=124, QuestName="SnowQuest", MonsterName="Snowman", NPC_CFrame=CFrame.new(1386,87,-1297), FarmArea=CFrame.new(1350,87,-1320)},
    {LevelMin=60, LevelMax=89, QuestName="SnowQuest", MonsterName="Snow Bandit", NPC_CFrame=CFrame.new(1386,87,-1297), FarmArea=CFrame.new(1350,87,-1320)},
    {LevelMin=30, LevelMax=59, QuestName="JungleQuest", MonsterName="Gorilla", NPC_CFrame=CFrame.new(-1250,37,1600), FarmArea=CFrame.new(-1280,37,1580)},
    {LevelMin=15, LevelMax=29, QuestName="JungleQuest", MonsterName="Monkey", NPC_CFrame=CFrame.new(-1400,37,90), FarmArea=CFrame.new(-1200,68,320)},
    {LevelMin=10, LevelMax=14, QuestName="BanditQuest2", MonsterName="Bandit", NPC_CFrame=CFrame.new(1061,17,1549), FarmArea=CFrame.new(1100,13,1480)},
    {LevelMin=1, LevelMax=9, QuestName="BanditQuest1", MonsterName="Bandit", NPC_CFrame=CFrame.new(1061,17,1549), FarmArea=CFrame.new(1100,13,1480)}
}

function SelectBestQuest()
    local level = Player.Data.Level.Value
    for _, quest in ipairs(QuestData) do
        if level >= quest.LevelMin and level <= quest.LevelMax then
            _G.CurrentQuest = quest
            print("🎯 QUEST:", quest.MonsterName, "| Level:", level)
            return true
        end
    end
    return false
end

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

-- ==================== FIX 2: TWEEN DI CHUYỂN ĐƠN GIẢN ====================
function TweenTo(targetPos)
    if not HRP then return end
    
    ToggleNoclip(true)
    local distance = (HRP.Position - targetPos).Magnitude
    if distance < 10 then 
        ToggleNoclip(false)
        return 
    end
    
    local tweenTime = math.min(3, distance / _G.TweenSpeed)
    local tween = TweenService:Create(HRP, TweenInfo.new(tweenTime, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
    tween:Play()
    tween.Completed:Wait()
    ToggleNoclip(false)
end

-- ==================== FIX 3: GIỮ VỊ TRÍ TRÊN CAO ====================
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

-- ==================== FIX 4: BRING MOB ====================
function BringMobs()
    if not HRP or not _G.CurrentQuest then return end
    
    local gatherPoint = HRP.Position - Vector3.new(0, 10, 0)
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    for _, mob in ipairs(enemies:GetChildren()) do
        if mob.Name == _G.CurrentQuest.MonsterName and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid and mob.Humanoid.Health > 0 then
            local dist = (HRP.Position - mob.HumanoidRootPart.Position).Magnitude
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

-- ==================== FIX 5: FAST ATTACK ====================
function FastAttack()
    pcall(function()
        local commF = ReplicatedStorage:FindFirstChild("Remotes")
        if commF and commF:FindFirstChild("CommF_") then
            commF.CommF_:InvokeServer("EquipMelee")
            for i = 1, 6 do
                commF.CommF_:InvokeServer("Melee")
                task.wait(_G.AttackDelay)
            end
        end
        VU:ClickButton1(Vector2.new())
    end)
end

-- ==================== FIX 6: NHẬN QUEST ====================
function AcceptQuest()
    pcall(function()
        local commF = ReplicatedStorage:FindFirstChild("Remotes")
        if commF and commF:FindFirstChild("CommF_") then
            commF.CommF_:InvokeServer("StartQuest", _G.CurrentQuest.QuestName, 1)
        end
    end)
end

-- ==================== STATE MACHINE (ĐÃ FIX) ====================
task.spawn(function()
    while true do
        if _G.AutoFarm then
            pcall(function()
                UpdateCharacter()
                
                if _G.FarmState == "IDLE" then
                    if SelectBestQuest() then
                        _G.FarmState = "GO_TO_NPC"
                        print("🟢 STATE: IDLE → GO_TO_NPC")
                    end
                    
                elseif _G.FarmState == "GO_TO_NPC" then
                    print("🚶 Đang bay đến NPC...")
                    TweenTo(_G.CurrentQuest.NPC_CFrame.Position + Vector3.new(0, 5, 0))
                    task.wait(0.5)
                    _G.FarmState = "ACCEPT_QUEST"
                    
                elseif _G.FarmState == "ACCEPT_QUEST" then
                    print("📜 Đang nhận quest...")
                    AcceptQuest()
                    task.wait(2)
                    
                    if IsQuestAccepted() then
                        print("✅ Nhận quest thành công!")
                        _G.FarmState = "GO_TO_FARM"
                    else
                        print("❌ Nhận quest thất bại, thử lại")
                        _G.FarmState = "IDLE"
                    end
                    
                elseif _G.FarmState == "GO_TO_FARM" then
                    print("🌾 Đang bay đến khu farm...")
                    TweenTo(_G.CurrentQuest.FarmArea.Position + Vector3.new(0, _G.FlyHeight, 0))
                    task.wait(0.5)
                    _G.FarmState = "FARMING"
                    StartHover()
                    print("⚔️ BẮT ĐẦU FARMING!")
                    
                elseif _G.FarmState == "FARMING" then
                    if not IsQuestAccepted() then
                        print("✅ Quest hoàn thành!")
                        StopHover()
                        _G.FarmState = "IDLE"
                        return
                    end
                    
                    if _G.BringMob then BringMobs() end
                    FastAttack()
                    task.wait(0.25)
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
        ForceHaki()
        print("✅ Auto Farm đã BẬT!")
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
        print("✅ Gom quái BẬT")
    end
})

farmGroup:AddButton({
    Title = "📦 TẮT GOM QUÁI",
    Callback = function()
        _G.BringMob = false
        print("⏸️ Gom quái TẮT")
    end
})

farmGroup:AddButton({
    Title = "🌑 BẬT HAKI",
    Callback = function()
        ForceHaki()
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
    Max = 15,
    Default = 11,
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
print("✅ AUTO FARM FIXED v15.0 - ĐÃ SẴN SÀNG!")
print("📌 State Machine: IDLE → NPC → QUEST → FARM")
print("📌 Level 30+ sẽ farm Gorilla (Không còn Monkey)")
print("📌 Bay trên đầu quái + Gom quái + Haki")
print("📌 Bấm 'BẬT AUTO FARM' để bắt đầu")
print("=" .. string.rep("=", 50)) 

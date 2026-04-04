-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "Auto Farm 1-2824 MAX | Fixed Stuck After Quest",
    Image = "rbxassetid://76048047842530"
})

local farmTab = window:AddTab("🌾 Farm")
local settingTab = window:AddTab("⚙️ Settings")
local hakiTab = window:AddTab("🌑 Haki")
local bringTab = window:AddTab("📦 Bring Mob")

-- ==================== BIẾN CẤU HÌNH ====================
_G.AutoFarm = false
_G.BringMob = true
_G.TweenSpeed = 300
_G.AttackDelay = 0.06
_G.FarmState = "IDLE"        -- IDLE, GETTING_QUEST, MOVING, FARMING
_G.CurrentQuest = nil
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

-- ==================== NOCLIP (CHỐNG KẸT ĐỊA HÌNH) ====================
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

-- ==================== HÀM DI CHUYỂN TWEEN (FIX STUCK) ====================
function TweenTo(targetPos, callback)
    if not HRP then return end
    
    local distance = (HRP.Position - targetPos).Magnitude
    if distance < 10 then
        if callback then callback() end
        return
    end
    
    -- BẬT NOCLIP TRONG KHI BAY (TRÁNH KẸT)
    ToggleNoclip(true)
    
    local tweenTime = math.min(3, distance / _G.TweenSpeed)
    local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(HRP, tweenInfo, {CFrame = CFrame.new(targetPos)})
    
    tween:Play()
    tween.Completed:Wait()
    
    -- TẮT NOCLIP SAU KHI BAY XONG
    ToggleNoclip(false)
    
    if callback then callback() end
end

-- ==================== BAY ĐẾN NPC (CÓ TWEEN) ====================
function FlyToNPC(npcPos)
    if not npcPos then return end
    local targetPos = Vector3.new(npcPos.X, npcPos.Y + 12, npcPos.Z)
    TweenTo(targetPos)
end

-- ==================== BAY ĐẾN KHU FARM (TRÊN ĐẦU QUÁI) ====================
function FlyToFarmArea(farmPos)
    if not farmPos then return end
    local targetPos = Vector3.new(farmPos.X, farmPos.Y + _G.FlyHeight, farmPos.Z)
    TweenTo(targetPos)
end

-- ==================== KIỂM TRA QUEST ĐÃ NHẬN ====================
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

-- ==================== COMPLETE QUEST DATA ====================
local QuestData = {
    sea1 = {
        {LevelMin=1, QuestName="BanditQuest1", MonsterName="Bandit", CFrame=CFrame.new(1061,17,1549), FarmArea=CFrame.new(1100,13,1480)},
        {LevelMin=10, QuestName="BanditQuest2", MonsterName="Bandit", CFrame=CFrame.new(1061,17,1549), FarmArea=CFrame.new(1100,13,1480)},
        {LevelMin=15, QuestName="JungleQuest", MonsterName="Monkey", CFrame=CFrame.new(-1400,37,90), FarmArea=CFrame.new(-1200,68,320)},
        {LevelMin=30, QuestName="JungleQuest", MonsterName="Gorilla", CFrame=CFrame.new(-1250,37,1600), FarmArea=CFrame.new(-1280,37,1580)},
        {LevelMin=60, QuestName="SnowQuest", MonsterName="Snow Bandit", CFrame=CFrame.new(1386,87,-1297), FarmArea=CFrame.new(1350,87,-1320)},
    },
    sea2 = {
        {LevelMin=700, QuestName="GreenbanditQuest", MonsterName="Green Bandit", CFrame=CFrame.new(-2553,6,4533), FarmArea=CFrame.new(-2520,6,4560)},
        {LevelMin=775, QuestName="GreenbanditQuest", MonsterName="Forest Warrior", CFrame=CFrame.new(-2553,6,4533), FarmArea=CFrame.new(-2520,6,4560)},
        {LevelMin=850, QuestName="MarineCaptainQuest", MonsterName="Marine Captain", CFrame=CFrame.new(6094,95,5907), FarmArea=CFrame.new(6060,95,5930)},
    },
    sea3 = {
        {LevelMin=1500, QuestName="SkyExp1Quest", MonsterName="Sky Expedition", CFrame=CFrame.new(-7862,5566,-380), FarmArea=CFrame.new(-7890,5566,-410)},
        {LevelMin=1550, QuestName="SkyExp2Quest", MonsterName="God", CFrame=CFrame.new(-7862,5566,-380), FarmArea=CFrame.new(-7890,5566,-410)},
        {LevelMin=1600, QuestName="CastleQuest1", MonsterName="Captain Elephant", CFrame=CFrame.new(-5075,314,8400), FarmArea=CFrame.new(-5100,314,8370)},
    }
}

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
    return bestQuest
end

-- ==================== PREMIUM BRING MOB ====================
function BringMob()
    if not HRP then return end
    local playerPos = HRP.Position
    local groundPoint = playerPos - Vector3.new(0, _G.FlyHeight, 0)
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    for _, mob in ipairs(enemies:GetChildren()) do
        if _G.CurrentQuest and mob.Name:find(_G.CurrentQuest.MonsterName) and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid and mob.Humanoid.Health > 0 then
            local dist = (playerPos - mob.HumanoidRootPart.Position).Magnitude
            if dist <= 150 then
                pcall(function()
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
            commF.CommF_:InvokeServer("Melee")
        end
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.01)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        VU:ClickButton1(Vector2.new())
    end)
end

-- ==================== NHẬN QUEST (TÁCH LUỒNG) ====================
function StartGetQuest()
    task.spawn(function()
        if not _G.CurrentQuest then return end
        
        print("✈️ Đang bay đến NPC...")
        FlyToNPC(_G.CurrentQuest.CFrame.Position)
        task.wait(1)
        
        print("📡 Đang nhận quest:", _G.CurrentQuest.QuestName)
        local commF = ReplicatedStorage:FindFirstChild("Remotes")
        if commF and commF:FindFirstChild("CommF_") then
            for i = 1, 3 do
                commF.CommF_:InvokeServer("StartQuest", _G.CurrentQuest.QuestName, i)
                task.wait(0.2)
            end
        end
        
        task.wait(1.5)
        
        -- KIỂM TRA QUEST ĐÃ NHẬN THÀNH CÔNG
        if IsQuestAccepted() then
            print("✅ Đã nhận quest thành công! Chuyển sang MOVING...")
            _G.FarmState = "MOVING"
        else
            print("⚠️ Chưa thấy quest GUI, thử lại...")
            _G.FarmState = "GETTING_QUEST"
        end
    end)
end

-- ==================== MAIN FARM LOOP (FIX STUCK) ====================
task.spawn(function()
    while true do
        if _G.AutoFarm then
            pcall(function()
                UpdateCharacter()
                
                -- STATE MACHINE
                if _G.FarmState == "IDLE" then
                    _G.CurrentQuest = GetCurrentQuest()
                    if _G.CurrentQuest then
                        print("🔍 Tìm thấy quest:", _G.CurrentQuest.QuestName)
                        _G.FarmState = "GETTING_QUEST"
                    end
                    
                elseif _G.FarmState == "GETTING_QUEST" then
                    StartGetQuest()
                    
                elseif _G.FarmState == "MOVING" then
                    print("🚶 Đang di chuyển đến khu farm...")
                    FlyToFarmArea(_G.CurrentQuest.FarmArea.Position)
                    task.wait(1)
                    _G.FarmState = "FARMING"
                    print("✅ Đã đến khu farm, bắt đầu FARMING!")
                    
                elseif _G.FarmState == "FARMING" then
                    -- KIỂM TRA QUEST CÒN KHÔNG
                    if not IsQuestAccepted() then
                        print("✅ Quest hoàn thành! Chuyển về IDLE để nhận quest mới")
                        _G.FarmState = "IDLE"
                        return
                    end
                    
                    -- GOM QUÁI + ĐÁNH
                    BringMob()
                    FastAttack()
                    task.wait(0.3)
                end
            end)
        else
            _G.FarmState = "IDLE"
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
        print("✅ Auto Farm đã BẬT - Fixed Stuck After Quest")
    end
})

farmGroup:AddButton({
    Title = "⏹️ TẮT AUTO FARM",
    Callback = function()
        _G.AutoFarm = false
        _G.FarmState = "IDLE"
        ToggleNoclip(false)
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
    Title = "🗻 Độ cao bay (trên đầu quái)",
    Min = 8,
    Max = 20,
    Default = 12,
    Callback = function(v) _G.FlyHeight = v end
})

UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ AUTO FARM - FIXED STUCK AFTER QUEST!")
print("📌 State Machine: IDLE → GETTING_QUEST → MOVING → FARMING")
print("📌 Tách luồng nhận quest bằng task.spawn() - không bị treo")
print("📌 TweenTo có Noclip - tránh kẹt địa hình")
print("📌 Bấm 'BẬT AUTO FARM' để bắt đầu")
print("=" .. string.rep("=", 50)) 

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

-- ==================== HAKI ====================
function EnableHaki()
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote and remote:FindFirstChild("CommF_") then
            remote.CommF_:InvokeServer("Enhancement", true)
            print("✅ Haki đã bật")
        end
    end)
end

task.spawn(function()
    task.wait(2)
    EnableHaki()
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

-- ==================== AUTO ATTACK ====================
local lastAttack = 0

function DoAttack()
    local now = tick()
    if now - lastAttack >= _G.AttackDelay then
        lastAttack = now
        pcall(function()
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
            task.wait(0.01)
            VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            ContextActionService:PressButton("Attack")
        end)
    end
end

task.spawn(function()
    while true do
        task.wait(0.03)
        if _G.AutoFarm and not isTweening and _G.State == "FARMING" then
            DoAttack()
        end
    end
end)

-- ==================== BRING MOB ====================
function BringMobs()
    if not _G.AutoFarm or not _G.BringMob then return end
    if isTweening then return end
    if tick() - _G.LastBringTime < 0.35 then return end
    _G.LastBringTime = tick()
    
    pcall(function()
        if not HRP then return end
        
        local ray = Ray.new(HRP.Position, Vector3.new(0, -50, 0))
        local hit, groundPos = workspace:FindPartOnRay(ray, Character)
        local groundY = groundPos and groundPos.Y or (HRP.Position.Y - 8)
        
        local gatherPoint = HRP.Position + (HRP.CFrame.LookVector * 14)
        gatherPoint = Vector3.new(gatherPoint.X, groundY + 2.5, gatherPoint.Z)
        
        local enemies = workspace:FindFirstChild("Enemies")
        if not enemies then return end
        
        local broughtCount = 0
        for _, v in pairs(enemies:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                local enemyHum = v.Humanoid
                local enemyHrp = v.HumanoidRootPart
                local dist = (enemyHrp.Position - HRP.Position).Magnitude
                
                if enemyHum.Health > 0 and dist <= 50 and dist > 12 and broughtCount < 3 then
                    local mobTarget = Vector3.new(gatherPoint.X, groundY + 2.5, gatherPoint.Z)
                    enemyHrp.CFrame = CFrame.new(mobTarget)
                    enemyHrp.Velocity = Vector3.new(0, 0, 0)
                    
                    local mobVel = Instance.new("BodyVelocity")
                    mobVel.MaxForce = Vector3.new(5000, 5000, 5000)
                    mobVel.Velocity = Vector3.new(0, 0, 0)
                    mobVel.Parent = enemyHrp
                    task.spawn(function()
                        task.wait(3)
                        mobVel:Destroy()
                    end)
                    
                    broughtCount = broughtCount + 1
                end
            end
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.AutoFarm and _G.BringMob and _G.State == "FARMING" and not isTweening then
            BringMobs()
        end
    end
end)

-- ==================== QUEST DATABASE (THÊM TÊN TIẾNG VIỆT) ====================
local QuestDB = {
    [1] = {
        {LvMin=0, LvMax=10, QuestName="BanditQuest1", NPCNames={"Bandit", "Bạch Quẹt", "Cướp"}, MobName="Bandit", MobArea=Vector3.new(1100,13,1480)},
        {LvMin=11, LvMax=20, QuestName="MonkeyQuest1", NPCNames={"Monkey", "Khi", "Khỉ"}, MobName="Monkey", MobArea=Vector3.new(-1200,68,320)},
        {LvMin=21, LvMax=30, QuestName="PirateQuest1", NPCNames={"Pirate", "Hải Tặc"}, MobName="Pirate", MobArea=Vector3.new(2650,28,200)},
        {LvMin=31, LvMax=40, QuestName="BruteQuest1", NPCNames={"Brute", "Bạo Chúa"}, MobName="Brute", MobArea=Vector3.new(2840,29,510)},
        {LvMin=41, LvMax=50, QuestName="VikingQuest1", NPCNames={"Viking"}, MobName="Viking", MobArea=Vector3.new(220,51,460)},
        {LvMin=51, LvMax=70, QuestName="SnowTrooperQuest1", NPCNames={"SnowTrooper", "Lính Tuyết"}, MobName="SnowTrooper", MobArea=Vector3.new(850,114,-1290)},
        {LvMin=71, LvMax=85, QuestName="ChiefPettyOfficerQuest1", NPCNames={"ChiefPettyOfficer"}, MobName="ChiefPettyOfficer", MobArea=Vector3.new(-460,18,640)},
        {LvMin=86, LvMax=100, QuestName="SkyBanditQuest1", NPCNames={"SkyBandit", "Cướp Trời"}, MobName="SkyBandit", MobArea=Vector3.new(-4860,721,-2680)},
    },
    [2] = {
        {LvMin=701, LvMax=725, QuestName="RaiderQuest1", NPCNames={"Raider"}, MobName="Raider", MobArea=Vector3.new(750,31,1370)},
        {LvMin=726, LvMax=750, QuestName="MercenaryQuest1", NPCNames={"Mercenary"}, MobName="Mercenary", MobArea=Vector3.new(760,32,1190)},
    },
    [3] = {
        {LvMin=1526, LvMax=1575, QuestName="PirateQuest3", NPCNames={"Pirate"}, MobName="Pirate", MobArea=Vector3.new(-1130,12,3890)},
    }
}

function GetCurrentSea(level)
    if level >= 1526 then return 3
    elseif level >= 700 then return 2
    else return 1 end
end

-- ==================== TÌM NPC THEO TÊN ====================
function FindNPC(npcNames)
    for _, name in pairs(npcNames) do
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                if v.Name == name or v.Name:find(name) then
                    return v.HumanoidRootPart
                end
            end
        end
    end
    return nil
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
                        if content:find("Exp") or content:find("$") then
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

-- ==================== TÌM QUÁI ====================
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

-- ==================== STATE MACHINE ====================
function RunStateMachine()
    if not _G.AutoFarm or _G.Busy then return end
    if not HRP then return end
    
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
                print("✅ SELECTED:", quest.QuestName, "| Lv:", level)
                _G.State = "GET_QUEST"
                return
            end
        end
        
    elseif _G.State == "GET_QUEST" then
        print("✈️ Tìm NPC để nhận quest:", _G.CurrentQuest.QuestName)
        
        -- Tìm NPC
        local npc = FindNPC(_G.CurrentQuest.NPCNames)
        if npc then
            TweenToPosition(npc.Position)
            task.wait(0.5)
            
            -- Nhận quest
            pcall(function()
                local remote = ReplicatedStorage.Remotes.CommF_
                for i = 1, 2 do
                    local result = remote:InvokeServer("StartQuest", _G.CurrentQuest.QuestName, i)
                    print("📡 Gửi quest", i, "kết quả:", result)
                    task.wait(0.2)
                end
            end)
        else
            print("❌ Không tìm thấy NPC, dùng tọa độ mặc định")
            TweenToPosition(Vector3.new(-1177,68,292))
            task.wait(0.5)
            pcall(function()
                local remote = ReplicatedStorage.Remotes.CommF_
                remote:InvokeServer("StartQuest", _G.CurrentQuest.QuestName, 1)
            end)
        end
        
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
        local mob = GetNearestMob(_G.CurrentQuest.MobName)
        if mob then
            local mobPos = mob.HumanoidRootPart.Position
            if (HRP.Position - mobPos).Magnitude > 12 then
                TweenToPosition(mobPos)
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
            EnableHaki()
            print("🔄 AUTO FARM ON")
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
        task.wait(0.15)
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
print("✅ AUTO FARM - ĐÃ SỬA TÊN NPC TIẾNG VIỆT!")
print("📌 NPC Khỉ: Tìm theo tên 'Khi', 'Monkey', 'Khỉ'")
print("📌 Haki: Tự bật khi script chạy")
print("📌 Bấm 'BẬT AUTO FARM' để bắt đầu")
print("=" .. string.rep("=", 50)) 

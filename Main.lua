local success, err = 
pcall(function(

-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "Auto Farm 1-2800 | by Quoc Hoa",
    Image = "rbxassetid://76048047842530"
})

local farmTab = window:AddTab("🌾 Farming")
local settingTab = window:AddTab("⚙️ Settings")

-- ==================== SERVICE ====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local root = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- ==================== BIẾN TOÀN CỤC ====================
_G.AutoFarm = false
_G.BringMob = true
_G.AutoHaki = true
_G.TweenSpeed = 60
_G.AttackDelay = 0.3
_G.FlyHeight = 9
_G.GatherRadius = 22

-- ==================== CẤU HÌNH ====================
local Config = {
    FlyOffset = CFrame.new(0, _G.FlyHeight, 0),
    TweenSpeed = 60,
    GatherRadius = 22,
    AttackDelay = 0.3,
    LoopFPS = 15,
    CacheTime = 3
}

-- ==================== BẢNG QUEST (Dạng Dictionary) ====================
local QuestDB = {
    {Min=1, Max=10, NPC="Bandit", Mob="Bandit", Sea=1, NPCPos=Vector3.new(1120,13,1450), FarmPos=Vector3.new(1100,13,1480)},
    {Min=11, Max=20, NPC="Monkey", Mob="Monkey", Sea=1, NPCPos=Vector3.new(-1177,68,292), FarmPos=Vector3.new(-1200,68,320)},
    {Min=21, Max=30, NPC="Pirate", Mob="Pirate", Sea=1, NPCPos=Vector3.new(2677,28,180), FarmPos=Vector3.new(2650,28,200)},
    {Min=31, Max=40, NPC="Brute", Mob="Brute", Sea=1, NPCPos=Vector3.new(2865,29,482), FarmPos=Vector3.new(2840,29,510)},
    {Min=41, Max=50, NPC="Viking", Mob="Viking", Sea=1, NPCPos=Vector3.new(249,51,435), FarmPos=Vector3.new(220,51,460)},
    {Min=51, Max=70, NPC="SnowTrooper", Mob="SnowTrooper", Sea=1, NPCPos=Vector3.new(873,114,-1269), FarmPos=Vector3.new(850,114,-1290)},
    {Min=71, Max=85, NPC="ChiefPettyOfficer", Mob="ChiefPettyOfficer", Sea=1, NPCPos=Vector3.new(-438,18,618), FarmPos=Vector3.new(-460,18,640)},
    {Min=86, Max=100, NPC="SkyBandit", Mob="SkyBandit", Sea=1, NPCPos=Vector3.new(-4838,721,-2660), FarmPos=Vector3.new(-4860,721,-2680)},
    {Min=101, Max=120, NPC="DarkMaster", Mob="DarkMaster", Sea=1, NPCPos=Vector3.new(-5174,593,-2759), FarmPos=Vector3.new(-5200,593,-2780)},
    {Min=121, Max=140, NPC="Toga", Mob="Toga", Sea=1, NPCPos=Vector3.new(-5236,817,-3103), FarmPos=Vector3.new(-5260,817,-3120)},
    {Min=141, Max=160, NPC="Fishman", Mob="Fishman", Sea=1, NPCPos=Vector3.new(3928,10,-1032), FarmPos=Vector3.new(3900,10,-1050)},
    {Min=161, Max=180, NPC="FishmanCommander", Mob="FishmanCommander", Sea=1, NPCPos=Vector3.new(3904,12,-1408), FarmPos=Vector3.new(3880,12,-1430)},
    {Min=181, Max=210, NPC="GalleyPirate", Mob="GalleyPirate", Sea=1, NPCPos=Vector3.new(5598,13,700), FarmPos=Vector3.new(5570,13,720)},
    {Min=211, Max=240, NPC="GalleyCaptain", Mob="GalleyCaptain", Sea=1, NPCPos=Vector3.new(5697,14,686), FarmPos=Vector3.new(5670,14,710)},
    {Min=241, Max=270, NPC="Marine", Mob="Marine", Sea=1, NPCPos=Vector3.new(-2937,12,-2857), FarmPos=Vector3.new(-2960,12,-2880)},
    {Min=271, Max=300, NPC="MarineCaptain", Mob="MarineCaptain", Sea=1, NPCPos=Vector3.new(-2936,13,-2998), FarmPos=Vector3.new(-2960,13,-3020)},
    {Min=301, Max=330, NPC="Prisoner", Mob="Prisoner", Sea=1, NPCPos=Vector3.new(5308,18,42), FarmPos=Vector3.new(5280,18,60)},
    {Min=331, Max=360, NPC="DangerousPrisoner", Mob="DangerousPrisoner", Sea=1, NPCPos=Vector3.new(5310,16,137), FarmPos=Vector3.new(5280,16,160)},
    {Min=361, Max=400, NPC="MilitarySoldier", Mob="MilitarySoldier", Sea=1, NPCPos=Vector3.new(-2381,23,-2352), FarmPos=Vector3.new(-2400,23,-2370)},
    {Min=401, Max=450, NPC="MilitarySpy", Mob="MilitarySpy", Sea=1, NPCPos=Vector3.new(-2581,24,-2485), FarmPos=Vector3.new(-2600,24,-2500)},
    {Min=451, Max=500, NPC="SaberExpert", Mob="SaberExpert", Sea=1, NPCPos=Vector3.new(1432,11,26), FarmPos=Vector3.new(1410,11,50)},
    {Min=501, Max=550, NPC="GodHuman", Mob="GodHuman", Sea=1, NPCPos=Vector3.new(-4652,822,-3030), FarmPos=Vector3.new(-4670,822,-3050)},
    {Min=551, Max=600, NPC="CursedCaptain", Mob="CursedCaptain", Sea=1, NPCPos=Vector3.new(3637,17,-354), FarmPos=Vector3.new(3610,17,-370)},
    {Min=601, Max=650, NPC="IceAdmiral", Mob="IceAdmiral", Sea=1, NPCPos=Vector3.new(1562,13,433), FarmPos=Vector3.new(1540,13,450)},
    {Min=651, Max=700, NPC="MagmaNinja", Mob="MagmaNinja", Sea=1, NPCPos=Vector3.new(-5718,9,273), FarmPos=Vector3.new(-5740,9,290)},
    {Min=701, Max=725, NPC="Raider", Mob="Raider", Sea=2, NPCPos=Vector3.new(771,31,1351), FarmPos=Vector3.new(750,31,1370)},
    {Min=726, Max=750, NPC="Mercenary", Mob="Mercenary", Sea=2, NPCPos=Vector3.new(786,32,1172), FarmPos=Vector3.new(760,32,1190)},
    {Min=751, Max=775, NPC="SwanPirate", Mob="SwanPirate", Sea=2, NPCPos=Vector3.new(527,18,1406), FarmPos=Vector3.new(500,18,1420)},
    {Min=776, Max=800, NPC="FactoryStaff", Mob="FactoryStaff", Sea=2, NPCPos=Vector3.new(435,209,-376), FarmPos=Vector3.new(410,209,-390)},
    {Min=801, Max=850, NPC="MarineLieutenant", Mob="MarineLieutenant", Sea=2, NPCPos=Vector3.new(-2804,72,-3342), FarmPos=Vector3.new(-2820,72,-3360)},
    {Min=851, Max=900, NPC="MarineCaptain", Mob="MarineCaptain", Sea=2, NPCPos=Vector3.new(-2828,73,-3497), FarmPos=Vector3.new(-2850,73,-3510)},
    {Min=901, Max=950, NPC="Zombie", Mob="Zombie", Sea=2, NPCPos=Vector3.new(-546,34,-486), FarmPos=Vector3.new(-570,34,-500)},
    {Min=951, Max=1000, NPC="Vampire", Mob="Vampire", Sea=2, NPCPos=Vector3.new(-549,30,-609), FarmPos=Vector3.new(-570,30,-630)},
    {Min=1001, Max=1050, NPC="Snowman", Mob="Snowman", Sea=2, NPCPos=Vector3.new(529,154,-433), FarmPos=Vector3.new(500,154,-450)},
    {Min=1051, Max=1100, NPC="SnowTrooper", Mob="SnowTrooper", Sea=2, NPCPos=Vector3.new(705,158,-543), FarmPos=Vector3.new(680,158,-560)},
    {Min=1101, Max=1150, NPC="LabSubordinate", Mob="LabSubordinate", Sea=2, NPCPos=Vector3.new(-4117,345,-2661), FarmPos=Vector3.new(-4140,345,-2680)},
    {Min=1151, Max=1200, NPC="HornedMan", Mob="HornedMan", Sea=2, NPCPos=Vector3.new(-4183,343,-2788), FarmPos=Vector3.new(-4200,343,-2800)},
    {Min=1201, Max=1250, NPC="Diamond", Mob="Diamond", Sea=2, NPCPos=Vector3.new(-1665,243,85), FarmPos=Vector3.new(-1680,243,100)},
    {Min=1251, Max=1300, NPC="PirateMilitia", Mob="PirateMilitia", Sea=2, NPCPos=Vector3.new(-1266,73,967), FarmPos=Vector3.new(-1280,73,980)},
    {Min=1301, Max=1350, NPC="Gunslinger", Mob="Gunslinger", Sea=2, NPCPos=Vector3.new(-1393,64,990), FarmPos=Vector3.new(-1410,64,1010)},
    {Min=1351, Max=1400, NPC="Crewmate", Mob="Crewmate", Sea=2, NPCPos=Vector3.new(-285,44,1643), FarmPos=Vector3.new(-300,44,1660)},
    {Min=1401, Max=1450, NPC="Bentham", Mob="Bentham", Sea=2, NPCPos=Vector3.new(-138,46,1634), FarmPos=Vector3.new(-160,46,1650)},
    {Min=1451, Max=1525, NPC="DonSwan", Mob="DonSwan", Sea=2, NPCPos=Vector3.new(288,31,1629), FarmPos=Vector3.new(260,31,1650)},
    {Min=1526, Max=1575, NPC="Pirate", Mob="Pirate", Sea=3, NPCPos=Vector3.new(-1110,12,3870), FarmPos=Vector3.new(-1130,12,3890)},
    {Min=1576, Max=1625, NPC="Brute", Mob="Brute", Sea=3, NPCPos=Vector3.new(-1116,14,3966), FarmPos=Vector3.new(-1140,14,3980)},
    {Min=1626, Max=1675, NPC="Gladiator", Mob="Gladiator", Sea=3, NPCPos=Vector3.new(1364,25,1190), FarmPos=Vector3.new(1340,25,1210)},
    {Min=1676, Max=1725, NPC="MilitarySoldier", Mob="MilitarySoldier", Sea=3, NPCPos=Vector3.new(1322,24,1127), FarmPos=Vector3.new(1300,24,1140)},
    {Min=1726, Max=1775, NPC="Marine", Mob="Marine", Sea=3, NPCPos=Vector3.new(-2620,198,3199), FarmPos=Vector3.new(-2640,198,3220)},
    {Min=1776, Max=1825, NPC="MarineCaptain", Mob="MarineCaptain", Sea=3, NPCPos=Vector3.new(-2628,199,3316), FarmPos=Vector3.new(-2650,199,3330)},
    {Min=1826, Max=1875, NPC="Thug", Mob="Thug", Sea=3, NPCPos=Vector3.new(-3244,246,952), FarmPos=Vector3.new(-3260,246,970)},
    {Min=1876, Max=1925, NPC="Raider", Mob="Raider", Sea=3, NPCPos=Vector3.new(-3256,247,832), FarmPos=Vector3.new(-3280,247,850)},
    {Min=1926, Max=1975, NPC="GalleyPirate", Mob="GalleyPirate", Sea=3, NPCPos=Vector3.new(-456,77,-2960), FarmPos=Vector3.new(-480,77,-2980)},
    {Min=1976, Max=2025, NPC="GalleyCaptain", Mob="GalleyCaptain", Sea=3, NPCPos=Vector3.new(-444,78,-3088), FarmPos=Vector3.new(-470,78,-3100)},
    {Min=2026, Max=2075, NPC="Pirate", Mob="Pirate", Sea=3, NPCPos=Vector3.new(5694,613,-132), FarmPos=Vector3.new(5670,613,-150)},
    {Min=2076, Max=2125, NPC="Brute", Mob="Brute", Sea=3, NPCPos=Vector3.new(5782,614,-192), FarmPos=Vector3.new(5760,614,-210)},
    {Min=2126, Max=2175, NPC="Pirate", Mob="Pirate", Sea=3, NPCPos=Vector3.new(-1683,35,-5038), FarmPos=Vector3.new(-1700,35,-5060)},
    {Min=2176, Max=2225, NPC="Brute", Mob="Brute", Sea=3, NPCPos=Vector3.new(-1615,37,-5117), FarmPos=Vector3.new(-1640,37,-5140)},
    {Min=2226, Max=2275, NPC="Firefighter", Mob="Firefighter", Sea=3, NPCPos=Vector3.new(-134,445,-202), FarmPos=Vector3.new(-160,445,-220)},
    {Min=2276, Max=2325, NPC="Scientist", Mob="Scientist", Sea=3, NPCPos=Vector3.new(-76,444,-219), FarmPos=Vector3.new(-100,444,-240)},
    {Min=2326, Max=2375, NPC="Zombie", Mob="Zombie", Sea=3, NPCPos=Vector3.new(-2249,445,-815), FarmPos=Vector3.new(-2270,445,-830)},
    {Min=2376, Max=2425, NPC="Vampire", Mob="Vampire", Sea=3, NPCPos=Vector3.new(-2344,445,-934), FarmPos=Vector3.new(-2370,445,-950)},
    {Min=2426, Max=2475, NPC="Ghost", Mob="Ghost", Sea=3, NPCPos=Vector3.new(-4550,390,-3672), FarmPos=Vector3.new(-4570,390,-3690)},
    {Min=2476, Max=2525, NPC="Reaper", Mob="Reaper", Sea=3, NPCPos=Vector3.new(-4727,391,-3802), FarmPos=Vector3.new(-4750,391,-3820)},
    {Min=2526, Max=2600, NPC="DragonCrew", Mob="DragonCrew", Sea=3, NPCPos=Vector3.new(-5374,309,-5053), FarmPos=Vector3.new(-5400,309,-5070)},
    {Min=2601, Max=2675, NPC="EliteHunter", Mob="EliteHunter", Sea=3, NPCPos=Vector3.new(-5418,314,-2667), FarmPos=Vector3.new(-5440,314,-2690)},
    {Min=2676, Max=2750, NPC="EliteHunter", Mob="EliteHunter", Sea=3, NPCPos=Vector3.new(-5418,314,-2667), FarmPos=Vector3.new(-5440,314,-2690)},
    {Min=2751, Max=2800, NPC="Legendary", Mob="Legendary", Sea=3, NPCPos=Vector3.new(-5500,320,-2700), FarmPos=Vector3.new(-5520,320,-2720)},
}

-- ==================== NOCLIP ====================
local noclipConnection = nil

function Noclip(enable)
    if enable then
        if noclipConnection then noclipConnection:Disconnect() end
        noclipConnection = RunService.Stepped:Connect(function()
            if _G.AutoFarm then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
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

-- ==================== ANTI-FALL ====================
task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarm and root and root.AssemblyLinearVelocity and root.AssemblyLinearVelocity.Y < -30 then
            root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z)
        end
    end
end)

-- ==================== AUTO HAKI ====================
function EnableHaki()
    if not _G.AutoHaki then return end
    pcall(function()
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote and remote:FindFirstChild("CommF_") then
            remote.CommF_:InvokeServer("Enhancement", true)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(10)
        if _G.AutoFarm and _G.AutoHaki then
            EnableHaki()
        end
    end
end)

-- ==================== TWEEN DI CHUYỂN (FIX DEPRECATED API) ====================
function TweenMove(targetCFrame)
    if not root then return end
    
    local dist = (root.Position - targetCFrame.Position).Magnitude
    local duration = math.max(dist / _G.TweenSpeed, 0.2)
    
    local prevStand = humanoid.PlatformStand
    humanoid.PlatformStand = true
    Noclip(true)
    
    local tween = TweenService:Create(root, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
    tween:Play()
    tween.Completed:Wait()
    
    humanoid.PlatformStand = prevStand
    Noclip(false)
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
end

-- ==================== TẤN CÔNG ====================
function PerformAttack()
    pcall(function()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
        
        local remote = ReplicatedStorage:FindFirstChild("Remotes")
        if remote and remote:FindFirstChild("CommF_") then
            remote.CommF_:InvokeServer("Melee")
        end
    end)
end

-- ==================== CORE MODULE AUTO FARM ====================
local AutoFarm = {}
AutoFarm.__index = AutoFarm

function AutoFarm.New()
    local self = setmetatable({}, AutoFarm)
    self.running = false
    self.lastScan = 0
    self.enemyCache = {}
    self.npcCache = {}
    return self
end

function AutoFarm:GetLevel()
    local stats = player:FindFirstChild("leaderstats")
    return (stats and stats.Level and typeof(stats.Level.Value) == "number") and stats.Level.Value or 1
end

function AutoFarm:GetCurrentQuest()
    local q = player:FindFirstChild("Quest")
    return (q and q:IsA("StringValue") and q.Value ~= "") and q.Value or nil
end

function AutoFarm:AcceptQuest()
    if self:GetCurrentQuest() then return true end
    
    local level = self:GetLevel()
    local match = nil
    for _, data in ipairs(QuestDB) do
        if level >= data.Min and level <= data.Max then
            match = data
            break
        end
    end
    if not match then return false end

    -- Tìm NPC
    if tick() - self.lastScan > Config.CacheTime then
        self.npcCache = {}
        for _, folder in ipairs({Workspace:FindFirstChild("NPCs"), Workspace:FindFirstChild("QuestGivers"), Workspace}) do
            if folder then
                for _, obj in ipairs(folder:GetChildren()) do
                    table.insert(self.npcCache, obj)
                end
            end
        end
        self.lastScan = tick()
    end

    for _, npc in ipairs(self.npcCache) do
        if string.find(npc.Name, match.NPC) and npc:FindFirstChild("HumanoidRootPart") then
            TweenMove(npc.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5))
            task.wait(0.5)
            pcall(function()
                if npc:FindFirstChild("ClickDetector") then
                    fireclickdetector(npc.ClickDetector)
                end
            end)
            task.wait(1.2)
            return self:GetCurrentQuest() ~= nil
        end
    end
    return false
end

function AutoFarm:ScanMobs()
    if tick() - self.lastScan < Config.CacheTime and #self.enemyCache > 0 then
        return self.enemyCache
    end
    self.enemyCache = {}
    for _, fname in ipairs({"Enemies", "Mobs", "Bosses"}) do
        local f = Workspace:FindFirstChild(fname)
        if f then
            for _, mob in ipairs(f:GetChildren()) do
                if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                    table.insert(self.enemyCache, mob)
                end
            end
        end
    end
    self.lastScan = tick()
    return self.enemyCache
end

function AutoFarm:GatherMobs(mobs)
    if #mobs <= 1 then return end
    local center = root.Position + Vector3.new(0, -2, 0)
    for i = 1, 6 do
        local angle = (i / 6) * math.pi * 2
        local pos = center + Vector3.new(math.cos(angle) * _G.GatherRadius, 0, math.sin(angle) * _G.GatherRadius)
        TweenMove(CFrame.new(pos))
        task.wait(0.1)
    end
    TweenMove(CFrame.new(center))
end

function AutoFarm:Start()
    if self.running then return end
    self.running = true
    print("🚀 AutoFarm Started | Fixed Version")

    task.spawn(function()
        local lastAtk = 0
        while self.running and task.wait(1 / Config.LoopFPS) do
            pcall(function()
                if not self:AcceptQuest() then task.wait(3) return end
                
                local mobs = self:ScanMobs()
                local quest = self:GetCurrentQuest()
                local valid = {}
                for _, m in ipairs(mobs) do
                    if quest and string.find(m.Name, quest) then table.insert(valid, m) end
                end

                if #valid == 0 then task.wait(2) return end
                if #valid > 2 and _G.BringMob then 
                    self:GatherMobs(valid) 
                    task.wait(0.3) 
                end

                local target = valid[1]
                if target and target:FindFirstChild("HumanoidRootPart") then
                    TweenMove(target.HumanoidRootPart.CFrame * CFrame.new(0, _G.FlyHeight, 0))
                    if tick() - lastAtk > _G.AttackDelay then
                        PerformAttack()
                        lastAtk = tick()
                    end
                end
            end)
        end
        print("⏹ AutoFarm Stopped")
    end)
end

function AutoFarm:Stop() 
    self.running = false 
end

-- ==================== KHỞI TẠO VÀ ĐIỀU KHIỂN ====================
local farm = AutoFarm.New()

-- ==================== UI ====================
local farmGroup = farmTab:AddLeftGroupbox("🤖 Điều Khiển")

farmGroup:AddButton({
    Title = "▶️ BẬT AUTO FARM",
    Callback = function()
        _G.AutoFarm = true
        farm:Start()
        print("✅ Auto Farm đã BẬT")
    end
})

farmGroup:AddButton({
    Title = "⏹️ TẮT AUTO FARM",
    Callback = function()
        _G.AutoFarm = false
        farm:Stop()
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
    Title = "⚡ BẬT HAKI",
    Callback = function()
        _G.AutoHaki = true
        EnableHaki()
        print("✅ Haki đã BẬT")
    end
})

farmGroup:AddButton({
    Title = "⚡ TẮT HAKI",
    Callback = function()
        _G.AutoHaki = false
        print("⏸️ Haki đã TẮT")
    end
})

-- Settings Tab
local settingGroup = settingTab:AddLeftGroupbox("⚙️ Cài Đặt")

settingGroup:AddSlider({
    Title = "🚀 Tốc độ bay",
    Min = 40,
    Max = 100,
    Default = 60,
    Callback = function(v) _G.TweenSpeed = v end
})

settingGroup:AddSlider({
    Title = "⚔️ Delay đánh",
    Min = 0.1,
    Max = 0.5,
    Default = 0.3,
    Decimal = true,
    Callback = function(v) _G.AttackDelay = v end
})

settingGroup:AddSlider({
    Title = "🗻 Độ cao bay",
    Min = 5,
    Max = 15,
    Default = 9,
    Callback = function(v) _G.FlyHeight = v end
})

settingGroup:AddSlider({
    Title = "📏 Bán kính gom quái",
    Min = 10,
    Max = 40,
    Default = 22,
    Callback = function(v) _G.GatherRadius = v end
})

-- ==================== HIỂN THỊ UI ====================
UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ APPLE HUB PREMIUM - AUTO FARM 1-2800!")
print("📌 State Machine: IDLE → GET_QUEST → MOVE_TO_FARM → FARMING")
print("📌 Tối ưu cho mobile, chống lag, chống rơi")
print("📌 Bấm 'BẬT AUTO FARM' để bắt đầu")
print("=" .. string.rep("=", 50)) 
end)

-- kiểm tra kết quả ngay bên dưới
if not success then
   warn("lỗi rồi: " .. tostring(err))
   end 

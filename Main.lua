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
local UserInputService = game:GetService("UserInputService")
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

-- ==================== HAKI XỊN ====================
function IsHakiActive()
    local success = pcall(function()
        local playerGui = Player:FindFirstChild("PlayerGui")
        if playerGui then
            for _, v in pairs(playerGui:GetDescendants()) do
                if v:IsA("ImageLabel") and v.Name == "HakiIcon" and v.Visible then
                    return true
                end
            end
        end
        local char = Player.Character
        if char and char:FindFirstChild("HakiEffect") then return true end
    end)
    return success or false
end

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

task.spawn(function()
    while true do
        task.wait(10)
        if _G.AutoFarm and not IsHakiActive() then
            EnableHaki()
        end
    end
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
        
        local char = Player.Character
        if not char or not HRP then return end
        
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
            pcall(function()
                local remote = ReplicatedStorage:FindFirstChild("Remotes")
                if remote and remote:FindFirstChild("CommF_") then
                    remote.CommF_:InvokeServer("EquipTool", "Melee")
                end
            end)
            DoAttack()
        end
    end
end)

-- ==================== BRING MOB XỊN ====================
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

-- ==================== QUEST DATABASE (ĐÃ SỬA TÊN NPC) ====================
local QuestDB = {
    [1] = {
        {LvMin=0, LvMax=10, QuestName="BanditQuest1", NPCPos=Vector3.new(1120,13,1450), MobName="Bandit", MobArea=Vector3.new(1100,13,1480)},
        {LvMin=11, LvMax=20, QuestName="MonkeyQuest1", NPCPos=Vector3.new(-1177,68,292), MobName="Monkey", MobArea=Vector3.new(-1200,68,320)},
        {LvMin=21, LvMax=30, QuestName="PirateQuest1", NPCPos=Vector3.new(2677,28,180), MobName="Pirate", MobArea=Vector3.new(2650,28,200)},
        {LvMin=31, LvMax=40, QuestName="BruteQuest1", NPCPos=Vector3.new(2865,29,482), MobName="Brute", MobArea=Vector3.new(2840,29,510)},
        {LvMin=41, LvMax=50, QuestName="VikingQuest1", NPCPos=Vector3.new(249,51,435), MobName="Viking", MobArea=Vector3.new(220,51,460)},
        {LvMin=51, LvMax=70, QuestName="SnowTrooperQuest1", NPCPos=Vector3.new(873,114,-1269), MobName="SnowTrooper", MobArea=Vector3.new(850,114,-1290)},
        {LvMin=71, LvMax=85, QuestName="ChiefPettyOfficerQuest1", NPCPos=Vector3.new(-438,18,618), MobName="ChiefPettyOfficer", MobArea=Vector3.new(-460,18,640)},
        {LvMin=86, LvMax=100, QuestName="SkyBanditQuest1", NPCPos=Vector3.new(-4838,721,-2660), MobName="SkyBandit", MobArea=Vector3.new(-4860,721,-2680)},
        {LvMin=101, LvMax=120, QuestName="DarkMasterQuest1", NPCPos=Vector3.new(-5174,593,-2759), MobName="DarkMaster", MobArea=Vector3.new(-5200,593,-2780)},
        {LvMin=121, LvMax=140, QuestName="TogaQuest1", NPCPos=Vector3.new(-5236,817,-3103), MobName="Toga", MobArea=Vector3.new(-5260,817,-3120)},
        {LvMin=141, LvMax=160, QuestName="FishmanQuest1", NPCPos=Vector3.new(3928,10,-1032), MobName="Fishman", MobArea=Vector3.new(3900,10,-1050)},
        {LvMin=161, LvMax=180, QuestName="FishmanCommanderQuest1", NPCPos=Vector3.new(3904,12,-1408), MobName="FishmanCommander", MobArea=Vector3.new(3880,12,-1430)},
        {LvMin=181, LvMax=210, QuestName="GalleyPirateQuest1", NPCPos=Vector3.new(5598,13,700), MobName="GalleyPirate", MobArea=Vector3.new(5570,13,720)},
        {LvMin=211, LvMax=240, QuestName="GalleyCaptainQuest1", NPCPos=Vector3.new(5697,14,686), MobName="GalleyCaptain", MobArea=Vector3.new(5670,14,710)},
        {LvMin=241, LvMax=270, QuestName="MarineQuest1", NPCPos=Vector3.new(-2937,12,-2857), MobName="Marine", MobArea=Vector3.new(-2960,12,-2880)},
        {LvMin=271, LvMax=300, QuestName="MarineCaptainQuest1", NPCPos=Vector3.new(-2936,13,-2998), MobName="MarineCaptain", MobArea=Vector3.new(-2960,13,-3020)},
        {LvMin=301, LvMax=330, QuestName="PrisonerQuest1", NPCPos=Vector3.new(5308,18,42), MobName="Prisoner", MobArea=Vector3.new(5280,18,60)},
        {LvMin=331, LvMax=360, QuestName="DangerousPrisonerQuest1", NPCPos=Vector3.new(5310,16,137), MobName="DangerousPrisoner", MobArea=Vector3.new(5280,16,160)},
        {LvMin=361, LvMax=400, QuestName="MilitarySoldierQuest1", NPCPos=Vector3.new(-2381,23,-2352), MobName="MilitarySoldier", MobArea=Vector3.new(-2400,23,-2370)},
        {LvMin=401, LvMax=450, QuestName="MilitarySpyQuest1", NPCPos=Vector3.new(-2581,24,-2485), MobName="MilitarySpy", MobArea=Vector3.new(-2600,24,-2500)},
        {LvMin=451, LvMax=500, QuestName="SaberExpertQuest1", NPCPos=Vector3.new(1432,11,26), MobName="SaberExpert", MobArea=Vector3.new(1410,11,50)},
        {LvMin=501, LvMax=550, QuestName="GodHumanQuest1", NPCPos=Vector3.new(-4652,822,-3030), MobName="GodHuman", MobArea=Vector3.new(-4670,822,-3050)},
        {LvMin=551, LvMax=600, QuestName="CursedCaptainQuest1", NPCPos=Vector3.new(3637,17,-354), MobName="CursedCaptain", MobArea=Vector3.new(3610,17,-370)},
        {LvMin=601, LvMax=650, QuestName="IceAdmiralQuest1", NPCPos=Vector3.new(1562,13,433), MobName="IceAdmiral", MobArea=Vector3.new(1540,13,450)},
        {LvMin=651, LvMax=700, QuestName="MagmaNinjaQuest1", NPCPos=Vector3.new(-5718,9,273), MobName="MagmaNinja", MobArea=Vector3.new(-5740,9,290)},
    },
    [2] = {
        {LvMin=701, LvMax=725, QuestName="RaiderQuest1", NPCPos=Vector3.new(771,31,1351), MobName="Raider", MobArea=Vector3.new(750,31,1370)},
        {LvMin=726, LvMax=750, QuestName="MercenaryQuest1", NPCPos=Vector3.new(786,32,1172), MobName="Mercenary", MobArea=Vector3.new(760,32,1190)},
        {LvMin=751, LvMax=775, QuestName="SwanPirateQuest1", NPCPos=Vector3.new(527,18,1406), MobName="SwanPirate", MobArea=Vector3.new(500,18,1420)},
        {LvMin=776, LvMax=800, QuestName="FactoryStaffQuest1", NPCPos=Vector3.new(435,209,-376), MobName="FactoryStaff", MobArea=Vector3.new(410,209,-390)},
        {LvMin=801, LvMax=850, QuestName="MarineLieutenantQuest1", NPCPos=Vector3.new(-2804,72,-3342), MobName="MarineLieutenant", MobArea=Vector3.new(-2820,72,-3360)},
        {LvMin=851, LvMax=900, QuestName="MarineCaptainQuest2", NPCPos=Vector3.new(-2828,73,-3497), MobName="MarineCaptain", MobArea=Vector3.new(-2850,73,-3510)},
        {LvMin=901, LvMax=950, QuestName="ZombieQuest1", NPCPos=Vector3.new(-546,34,-486), MobName="Zombie", MobArea=Vector3.new(-570,34,-500)},
        {LvMin=951, LvMax=1000, QuestName="VampireQuest1", NPCPos=Vector3.new(-549,30,-609), MobName="Vampire", MobArea=Vector3.new(-570,30,-630)},
        {LvMin=1001, LvMax=1050, QuestName="SnowmanQuest1", NPCPos=Vector3.new(529,154,-433), MobName="Snowman", MobArea=Vector3.new(500,154,-450)},
        {LvMin=1051, LvMax=1100, QuestName="SnowTrooperQuest2", NPCPos=Vector3.new(705,158,-543), MobName="SnowTrooper", MobArea=Vector3.new(680,158,-560)},
        {LvMin=1101, LvMax=1150, QuestName="LabSubordinateQuest1", NPCPos=Vector3.new(-4117,345,-2661), MobName="LabSubordinate", MobArea=Vector3.new(-4140,345,-2680)},
        {LvMin=1151, LvMax=1200, QuestName="HornedManQuest1", NPCPos=Vector3.new(-4183,343,-2788), MobName="HornedMan", MobArea=Vector3.new(-4200,343,-2800)},
        {LvMin=1201, LvMax=1250, QuestName="DiamondQuest1", NPCPos=Vector3.new(-1665,243,85), MobName="Diamond", MobArea=Vector3.new(-1680,243,100)},
        {LvMin=1251, LvMax=1300, QuestName="PirateMilitiaQuest1", NPCPos=Vector3.new(-1266,73,967), MobName="PirateMilitia", MobArea=Vector3.new(-1280,73,980)},
        {LvMin=1301, LvMax=1350, QuestName="GunslingerQuest1", NPCPos=Vector3.new(-1393,64,990), MobName="Gunslinger", MobArea=Vector3.new(-1410,64,1010)},
        {LvMin=1351, LvMax=1400, QuestName="CrewmateQuest1", NPCPos=Vector3.new(-285,44,1643), MobName="Crewmate", MobArea=Vector3.new(-300,44,1660)},
        {LvMin=1401, LvMax=1450, QuestName="BenthamQuest1", NPCPos=Vector3.new(-138,46,1634), MobName="Bentham", MobArea=Vector3.new(-160,46,1650)},
        {LvMin=1451, LvMax=1525, QuestName="DonSwanQuest1", NPCPos=Vector3.new(288,31,1629), MobName="DonSwan", MobArea=Vector3.new(260,31,1650)},
    },
    [3] = {
        {LvMin=1526, LvMax=1575, QuestName="PirateQuest3", NPCPos=Vector3.new(-1110,12,3870), MobName="Pirate", MobArea=Vector3.new(-1130,12,3890)},
        {LvMin=1576, LvMax=1625, QuestName="BruteQuest3", NPCPos=Vector3.new(-1116,14,3966), MobName="Brute", MobArea=Vector3.new(-1140,14,3980)},
        {LvMin=1626, LvMax=1675, QuestName="GladiatorQuest1", NPCPos=Vector3.new(1364,25,1190), MobName="Gladiator", MobArea=Vector3.new(1340,25,1210)},
        {LvMin=1676, LvMax=1725, QuestName="MilitarySoldierQuest3", NPCPos=Vector3.new(1322,24,1127), MobName="MilitarySoldier", MobArea=Vector3.new(1300,24,1140)},
        {LvMin=1726, LvMax=1775, QuestName="MarineQuest3", NPCPos=Vector3.new(-2620,198,3199), MobName="Marine", MobArea=Vector3.new(-2640,198,3220)},
        {LvMin=1776, LvMax=1825, QuestName="MarineCaptainQuest3", NPCPos=Vector3.new(-2628,199,3316), MobName="MarineCaptain", MobArea=Vector3.new(-2650,199,3330)},
        {LvMin=1826, LvMax=1875, QuestName="ThugQuest1", NPCPos=Vector3.new(-3244,246,952), MobName="Thug", MobArea=Vector3.new(-3260,246,970)},
        {LvMin=1876, LvMax=1925, QuestName="RaiderQuest3", NPCPos=Vector3.new(-3256,247,832), MobName="Raider", MobArea=Vector3.new(-3280,247,850)},
        {LvMin=1926, LvMax=1975, QuestName="GalleyPirateQuest3", NPCPos=Vector3.new(-456,77,-2960), MobName="GalleyPirate", MobArea=Vector3.new(-480,77,-2980)},
        {LvMin=1976, LvMax=2025, QuestName="GalleyCaptainQuest3", NPCPos=Vector3.new(-444,78,-3088), MobName="GalleyCaptain", MobArea=Vector3.new(-470,78,-3100)},
        {LvMin=2026, LvMax=2075, QuestName="PirateQuest4", NPCPos=Vector3.new(5694,613,-132), MobName="Pirate", MobArea=Vector3.new(5670,613,-150)},
        {LvMin=2076, LvMax=2125, QuestName="BruteQuest4", NPCPos=Vector3.new(5782,614,-192), MobName="Brute", MobArea=Vector3.new(5760,614,-210)},
        {LvMin=2126, LvMax=2175, QuestName="PirateQuest5", NPCPos=Vector3.new(-1683,35,-5038), MobName="Pirate", MobArea=Vector3.new(-1700,35,-5060)},
        {LvMin=2176, LvMax=2225, QuestName="BruteQuest5", NPCPos=Vector3.new(-1615,37,-5117), MobName="Brute", MobArea=Vector3.new(-1640,37,-5140)},
        {LvMin=2226, LvMax=2275, QuestName="FirefighterQuest1", NPCPos=Vector3.new(-134,445,-202), MobName="Firefighter", MobArea=Vector3.new(-160,445,-220)},
        {LvMin=2276, LvMax=2325, QuestName="ScientistQuest1", NPCPos=Vector3.new(-76,444,-219), MobName="Scientist", MobArea=Vector3.new(-100,444,-240)},
        {LvMin=2326, LvMax=2375, QuestName="ZombieQuest3", NPCPos=Vector3.new(-2249,445,-815), MobName="Zombie", MobArea=Vector3.new(-2270,445,-830)},
        {LvMin=2376, LvMax=2425, QuestName="VampireQuest3", NPCPos=Vector3.new(-2344,445,-934), MobName="Vampire", MobArea=Vector3.new(-2370,445,-950)},
        {LvMin=2426, LvMax=2475, QuestName="GhostQuest1", NPCPos=Vector3.new(-4550,390,-3672), MobName="Ghost", MobArea=Vector3.new(-4570,390,-3690)},
        {LvMin=2476, LvMax=2525, QuestName="ReaperQuest1", NPCPos=Vector3.new(-4727,391,-3802), MobName="Reaper", MobArea=Vector3.new(-4750,391,-3820)},
        {LvMin=2526, LvMax=2600, QuestName="DragonCrewQuest1", NPCPos=Vector3.new(-5374,309,-5053), MobName="DragonCrew", MobArea=Vector3.new(-5400,309,-5070)},
    }
}

function GetCurrentSea(level)
    if level >= 1526 then return 3
    elseif level >= 700 then return 2
    else return 1 end
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

-- ==================== TÌM NPC ====================
function GetNearestNPC(npcName)
    local closest, closestDist = nil, math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v.Name:find(npcName) and v:FindFirstChild("HumanoidRootPart") then
            local dist = (HRP.Position - v.HumanoidRootPart.Position).Magnitude
            if dist < closestDist then
                closest = v
                closestDist = dist
            end
        end
    end
    return closest
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
        print("✈️ Bay đến NPC:", _G.CurrentQuest.QuestName)
        
        -- Tìm và bay đến NPC
        local npc = GetNearestNPC(_G.CurrentQuest.QuestName:gsub("Quest", ""))
        if npc then
            TweenToPosition(npc.HumanoidRootPart.Position)
        else
            TweenToPosition(_G.CurrentQuest.NPCPos)
        end
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
        
        task.wait(0.5)
        _G.State = "MOVING_TO_FARM"
        
    elseif _G.State == "MOVING_TO_FARM" then
        print("🌾 Bay đến khu farm")
        local mobArea = _G.CurrentQuest.MobArea
        TweenToPosition(mobArea)
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
print("✅ AUTO FARM CAO CẤP - ĐÃ SỬA QUEST KHỈ!")
print("📌 Quest Monkey: Tìm NPC theo tên thực tế trong game")
print("📌 Haki: Tự bật khi script chạy")
print("📌 Gom quái: Kéo 3 con/lần, giữ dưới đất")
print("📌 Bấm 'BẬT AUTO FARM' để bắt đầu")
print("=" .. string.rep("=", 50)) 

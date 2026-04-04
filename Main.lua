-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "Auto Farm 1-2800 MAX | by Quoc Hoa",
    Image = "rbxassetid://76048047842530"
})

local farmTab = window:AddTab("🌾 Farm")
local settingTab = window:AddTab("⚙️ Settings")

-- ==================== BIẾN CẤU HÌNH ====================
_G.AutoFarm = false
_G.BringMob = true
_G.AutoHaki = true
_G.TweenSpeed = 420
_G.AttackDelay = 0.06
_G.State = "CHECK_QUEST"
_G.CurrentQuest = nil
_G.Busy = false
_G.LastBringTime = 0
_G.FlyHeight = 9

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
            return 
        end
        
        ToggleNoclip(true)
        StopTween()
        
        isTweening = true
        local tweenTime = math.max(0.5, distance / _G.TweenSpeed)
        local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
        
        currentTween = TweenService:Create(HRP, tweenInfo, {CFrame = CFrame.new(target)})
        currentTween:Play()
        
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

-- ==================== TỰ ĐỘNG BẬT HAKI ====================
function EnableHaki()
    if not _G.AutoHaki then return end
    
    pcall(function()
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        if remote and remote:FindFirstChild("CommF_") then
            remote.CommF_:InvokeServer("Enhancement", true)
            print("✅ Đã bật Haki")
        end
    end)
end

task.spawn(function()
    task.wait(2)
    EnableHaki()
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
            
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton1(Vector2.new(0, 0))
        end)
    end
end

-- ==================== BRING MOB ====================
function BringMobs()
    if not _G.AutoFarm or not _G.BringMob then return end
    if isTweening then return end
    if tick() - _G.LastBringTime < 0.4 then return end
    _G.LastBringTime = tick()
    
    pcall(function()
        if not HRP then return end
        
        local gatherPoint = HRP.Position + (HRP.CFrame.LookVector * 14) + Vector3.new(0, 2, 0)
        local enemies = workspace:FindFirstChild("Enemies")
        
        if enemies then
            for _, v in pairs(enemies:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    local enemyHrp = v.HumanoidRootPart
                    local enemyHum = v.Humanoid
                    local dist = (enemyHrp.Position - HRP.Position).Magnitude
                    
                    if enemyHum.Health > 0 and dist <= 50 and dist > 8 then
                        enemyHrp.CFrame = CFrame.new(gatherPoint)
                        enemyHrp.Velocity = Vector3.new(0, 0, 0)
                    end
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

-- ==================== QUEST DATABASE ====================
local QuestDB = {
    [1] = {
        {LvMin=1, LvMax=10, QuestName="BanditQuest1", NPCPos=Vector3.new(1120, 13, 1450), MobArea=Vector3.new(1100, 13, 1480), npc="Bandit"},
        {LvMin=11, LvMax=20, QuestName="MonkeyQuest1", NPCPos=Vector3.new(-1177, 68, 292), MobArea=Vector3.new(-1200, 68, 320), npc="Monkey"},
        {LvMin=21, LvMax=30, QuestName="PirateQuest1", NPCPos=Vector3.new(2677, 28, 180), MobArea=Vector3.new(2650, 28, 200), npc="Pirate"},
        {LvMin=31, LvMax=40, QuestName="BruteQuest1", NPCPos=Vector3.new(2865, 29, 482), MobArea=Vector3.new(2840, 29, 510), npc="Brute"},
        {LvMin=41, LvMax=50, QuestName="VikingQuest1", NPCPos=Vector3.new(249, 51, 435), MobArea=Vector3.new(220, 51, 460), npc="Viking"},
        {LvMin=51, LvMax=70, QuestName="SnowTrooperQuest1", NPCPos=Vector3.new(873, 114, -1269), MobArea=Vector3.new(850, 114, -1290), npc="SnowTrooper"},
        {LvMin=71, LvMax=85, QuestName="ChiefPettyOfficerQuest1", NPCPos=Vector3.new(-438, 18, 618), MobArea=Vector3.new(-460, 18, 640), npc="ChiefPettyOfficer"},
        {LvMin=86, LvMax=100, QuestName="SkyBanditQuest1", NPCPos=Vector3.new(-4838, 721, -2660), MobArea=Vector3.new(-4860, 721, -2680), npc="SkyBandit"},
        {LvMin=101, LvMax=120, QuestName="DarkMasterQuest1", NPCPos=Vector3.new(-5174, 593, -2759), MobArea=Vector3.new(-5200, 593, -2780), npc="DarkMaster"},
        {LvMin=121, LvMax=140, QuestName="TogaQuest1", NPCPos=Vector3.new(-5236, 817, -3103), MobArea=Vector3.new(-5260, 817, -3120), npc="Toga"},
        {LvMin=141, LvMax=160, QuestName="FishmanQuest1", NPCPos=Vector3.new(3928, 10, -1032), MobArea=Vector3.new(3900, 10, -1050), npc="Fishman"},
        {LvMin=161, LvMax=180, QuestName="FishmanCommanderQuest1", NPCPos=Vector3.new(3904, 12, -1408), MobArea=Vector3.new(3880, 12, -1430), npc="FishmanCommander"},
        {LvMin=181, LvMax=210, QuestName="GalleyPirateQuest1", NPCPos=Vector3.new(5598, 13, 700), MobArea=Vector3.new(5570, 13, 720), npc="GalleyPirate"},
        {LvMin=211, LvMax=240, QuestName="GalleyCaptainQuest1", NPCPos=Vector3.new(5697, 14, 686), MobArea=Vector3.new(5670, 14, 710), npc="GalleyCaptain"},
        {LvMin=241, LvMax=270, QuestName="MarineQuest1", NPCPos=Vector3.new(-2937, 12, -2857), MobArea=Vector3.new(-2960, 12, -2880), npc="Marine"},
        {LvMin=271, LvMax=300, QuestName="MarineCaptainQuest1", NPCPos=Vector3.new(-2936, 13, -2998), MobArea=Vector3.new(-2960, 13, -3020), npc="MarineCaptain"},
        {LvMin=301, LvMax=330, QuestName="PrisonerQuest1", NPCPos=Vector3.new(5308, 18, 42), MobArea=Vector3.new(5280, 18, 60), npc="Prisoner"},
        {LvMin=331, LvMax=360, QuestName="DangerousPrisonerQuest1", NPCPos=Vector3.new(5310, 16, 137), MobArea=Vector3.new(5280, 16, 160), npc="DangerousPrisoner"},
        {LvMin=361, LvMax=400, QuestName="MilitarySoldierQuest1", NPCPos=Vector3.new(-2381, 23, -2352), MobArea=Vector3.new(-2400, 23, -2370), npc="MilitarySoldier"},
        {LvMin=401, LvMax=450, QuestName="MilitarySpyQuest1", NPCPos=Vector3.new(-2581, 24, -2485), MobArea=Vector3.new(-2600, 24, -2500), npc="MilitarySpy"},
        {LvMin=451, LvMax=500, QuestName="SaberExpertQuest1", NPCPos=Vector3.new(1432, 11, 26), MobArea=Vector3.new(1410, 11, 50), npc="SaberExpert"},
        {LvMin=501, LvMax=550, QuestName="GodHumanQuest1", NPCPos=Vector3.new(-4652, 822, -3030), MobArea=Vector3.new(-4670, 822, -3050), npc="GodHuman"},
        {LvMin=551, LvMax=600, QuestName="CursedCaptainQuest1", NPCPos=Vector3.new(3637, 17, -354), MobArea=Vector3.new(3610, 17, -370), npc="CursedCaptain"},
        {LvMin=601, LvMax=650, QuestName="IceAdmiralQuest1", NPCPos=Vector3.new(1562, 13, 433), MobArea=Vector3.new(1540, 13, 450), npc="IceAdmiral"},
        {LvMin=651, LvMax=700, QuestName="MagmaNinjaQuest1", NPCPos=Vector3.new(-5718, 9, 273), MobArea=Vector3.new(-5740, 9, 290), npc="MagmaNinja"},
    },
    [2] = {
        {LvMin=701, LvMax=725, QuestName="RaiderQuest1", NPCPos=Vector3.new(771, 31, 1351), MobArea=Vector3.new(750, 31, 1370), npc="Raider"},
        {LvMin=726, LvMax=750, QuestName="MercenaryQuest1", NPCPos=Vector3.new(786, 32, 1172), MobArea=Vector3.new(760, 32, 1190), npc="Mercenary"},
        {LvMin=751, LvMax=775, QuestName="SwanPirateQuest1", NPCPos=Vector3.new(527, 18, 1406), MobArea=Vector3.new(500, 18, 1420), npc="SwanPirate"},
        {LvMin=776, LvMax=800, QuestName="FactoryStaffQuest1", NPCPos=Vector3.new(435, 209, -376), MobArea=Vector3.new(410, 209, -390), npc="FactoryStaff"},
        {LvMin=801, LvMax=850, QuestName="MarineLieutenantQuest1", NPCPos=Vector3.new(-2804, 72, -3342), MobArea=Vector3.new(-2820, 72, -3360), npc="MarineLieutenant"},
        {LvMin=851, LvMax=900, QuestName="MarineCaptainQuest2", NPCPos=Vector3.new(-2828, 73, -3497), MobArea=Vector3.new(-2850, 73, -3510), npc="MarineCaptain"},
        {LvMin=901, LvMax=950, QuestName="ZombieQuest1", NPCPos=Vector3.new(-546, 34, -486), MobArea=Vector3.new(-570, 34, -500), npc="Zombie"},
        {LvMin=951, LvMax=1000, QuestName="VampireQuest1", NPCPos=Vector3.new(-549, 30, -609), MobArea=Vector3.new(-570, 30, -630), npc="Vampire"},
        {LvMin=1001, LvMax=1050, QuestName="SnowmanQuest1", NPCPos=Vector3.new(529, 154, -433), MobArea=Vector3.new(500, 154, -450), npc="Snowman"},
        {LvMin=1051, LvMax=1100, QuestName="SnowTrooperQuest2", NPCPos=Vector3.new(705, 158, -543), MobArea=Vector3.new(680, 158, -560), npc="SnowTrooper"},
        {LvMin=1101, LvMax=1150, QuestName="LabSubordinateQuest1", NPCPos=Vector3.new(-4117, 345, -2661), MobArea=Vector3.new(-4140, 345, -2680), npc="LabSubordinate"},
        {LvMin=1151, LvMax=1200, QuestName="HornedManQuest1", NPCPos=Vector3.new(-4183, 343, -2788), MobArea=Vector3.new(-4200, 343, -2800), npc="HornedMan"},
        {LvMin=1201, LvMax=1250, QuestName="DiamondQuest1", NPCPos=Vector3.new(-1665, 243, 85), MobArea=Vector3.new(-1680, 243, 100), npc="Diamond"},
        {LvMin=1251, LvMax=1300, QuestName="PirateMilitiaQuest1", NPCPos=Vector3.new(-1266, 73, 967), MobArea=Vector3.new(-1280, 73, 980), npc="PirateMilitia"},
        {LvMin=1301, LvMax=1350, QuestName="GunslingerQuest1", NPCPos=Vector3.new(-1393, 64, 990), MobArea=Vector3.new(-1410, 64, 1010), npc="Gunslinger"},
        {LvMin=1351, LvMax=1400, QuestName="CrewmateQuest1", NPCPos=Vector3.new(-285, 44, 1643), MobArea=Vector3.new(-300, 44, 1660), npc="Crewmate"},
        {LvMin=1401, LvMax=1450, QuestName="BenthamQuest1", NPCPos=Vector3.new(-138, 46, 1634), MobArea=Vector3.new(-160, 46, 1650), npc="Bentham"},
        {LvMin=1451, LvMax=1525, QuestName="DonSwanQuest1", NPCPos=Vector3.new(288, 31, 1629), MobArea=Vector3.new(260, 31, 1650), npc="DonSwan"},
    },
    [3] = {
        {LvMin=1526, LvMax=1575, QuestName="PirateQuest3", NPCPos=Vector3.new(-1110, 12, 3870), MobArea=Vector3.new(-1130, 12, 3890), npc="Pirate"},
        {LvMin=1576, LvMax=1625, QuestName="BruteQuest3", NPCPos=Vector3.new(-1116, 14, 3966), MobArea=Vector3.new(-1140, 14, 3980), npc="Brute"},
        {LvMin=1626, LvMax=1675, QuestName="GladiatorQuest1", NPCPos=Vector3.new(1364, 25, 1190), MobArea=Vector3.new(1340, 25, 1210), npc="Gladiator"},
        {LvMin=1676, LvMax=1725, QuestName="MilitarySoldierQuest3", NPCPos=Vector3.new(1322, 24, 1127), MobArea=Vector3.new(1300, 24, 1140), npc="MilitarySoldier"},
        {LvMin=1726, LvMax=1775, QuestName="MarineQuest3", NPCPos=Vector3.new(-2620, 198, 3199), MobArea=Vector3.new(-2640, 198, 3220), npc="Marine"},
        {LvMin=1776, LvMax=1825, QuestName="MarineCaptainQuest3", NPCPos=Vector3.new(-2628, 199, 3316), MobArea=Vector3.new(-2650, 199, 3330), npc="MarineCaptain"},
        {LvMin=1826, LvMax=1875, QuestName="ThugQuest1", NPCPos=Vector3.new(-3244, 246, 952), MobArea=Vector3.new(-3260, 246, 970), npc="Thug"},
        {LvMin=1876, LvMax=1925, QuestName="RaiderQuest3", NPCPos=Vector3.new(-3256, 247, 832), MobArea=Vector3.new(-3280, 247, 850), npc="Raider"},
        {LvMin=1926, LvMax=1975, QuestName="GalleyPirateQuest3", NPCPos=Vector3.new(-456, 77, -2960), MobArea=Vector3.new(-480, 77, -2980), npc="GalleyPirate"},
        {LvMin=1976, LvMax=2025, QuestName="GalleyCaptainQuest3", NPCPos=Vector3.new(-444, 78, -3088), MobArea=Vector3.new(-470, 78, -3100), npc="GalleyCaptain"},
        {LvMin=2026, LvMax=2075, QuestName="PirateQuest4", NPCPos=Vector3.new(5694, 613, -132), MobArea=Vector3.new(5670, 613, -150), npc="Pirate"},
        {LvMin=2076, LvMax=2125, QuestName="BruteQuest4", NPCPos=Vector3.new(5782, 614, -192), MobArea=Vector3.new(5760, 614, -210), npc="Brute"},
        {LvMin=2126, LvMax=2175, QuestName="PirateQuest5", NPCPos=Vector3.new(-1683, 35, -5038), MobArea=Vector3.new(-1700, 35, -5060), npc="Pirate"},
        {LvMin=2176, LvMax=2225, QuestName="BruteQuest5", NPCPos=Vector3.new(-1615, 37, -5117), MobArea=Vector3.new(-1640, 37, -5140), npc="Brute"},
        {LvMin=2226, LvMax=2275, QuestName="FirefighterQuest1", NPCPos=Vector3.new(-134, 445, -202), MobArea=Vector3.new(-160, 445, -220), npc="Firefighter"},
        {LvMin=2276, LvMax=2325, QuestName="ScientistQuest1", NPCPos=Vector3.new(-76, 444, -219), MobArea=Vector3.new(-100, 444, -240), npc="Scientist"},
        {LvMin=2326, LvMax=2375, QuestName="ZombieQuest3", NPCPos=Vector3.new(-2249, 445, -815), MobArea=Vector3.new(-2270, 445, -830), npc="Zombie"},
        {LvMin=2376, LvMax=2425, QuestName="VampireQuest3", NPCPos=Vector3.new(-2344, 445, -934), MobArea=Vector3.new(-2370, 445, -950), npc="Vampire"},
        {LvMin=2426, LvMax=2475, QuestName="GhostQuest1", NPCPos=Vector3.new(-4550, 390, -3672), MobArea=Vector3.new(-4570, 390, -3690), npc="Ghost"},
        {LvMin=2476, LvMax=2525, QuestName="ReaperQuest1", NPCPos=Vector3.new(-4727, 391, -3802), MobArea=Vector3.new(-4750, 391, -3820), npc="Reaper"},
        {LvMin=2526, LvMax=2600, QuestName="DragonCrewQuest1", NPCPos=Vector3.new(-5374, 309, -5053), MobArea=Vector3.new(-5400, 309, -5070), npc="DragonCrew"},
        {LvMin=2601, LvMax=2675, QuestName="EliteHunterQuest1", NPCPos=Vector3.new(-5418, 314, -2667), MobArea=Vector3.new(-5440, 314, -2690), npc="EliteHunter"},
        {LvMin=2676, LvMax=2750, QuestName="EliteHunterQuest2", NPCPos=Vector3.new(-5418, 314, -2667), MobArea=Vector3.new(-5440, 314, -2690), npc="EliteHunter"},
        {LvMin=2751, LvMax=2800, QuestName="LegendaryQuest1", NPCPos=Vector3.new(-5500, 320, -2700), MobArea=Vector3.new(-5520, 320, -2720), npc="Legendary"},
    }
}

-- ==================== CHỌN QUEST ĐÚNG THEO LEVEL ====================
function SelectQuestByLevel()
    local playerLevel = Player.Data.Level.Value
    print("📊 Level hiện tại:", playerLevel)
    
    for islandIndex = 1, 3 do
        local islandQuests = QuestDB[islandIndex]
        for _, quest in ipairs(islandQuests) do
            if playerLevel >= quest.LvMin and playerLevel <= quest.LvMax then
                print("✅ CHỌN QUEST:", quest.QuestName, "| NPC:", quest.npc)
                _G.CurrentQuest = quest
                _G.State = "GET_QUEST"
                return
            end
        end
    end
    
    print("❌ KHÔNG TÌM THẤY QUEST PHÙ HỢP!")
    _G.State = "CHECK_QUEST"
end

-- ==================== KIỂM TRA QUEST ĐÃ NHẬN ====================
function IsQuestAccepted()
    local success = pcall(function()
        local main = playerGui:FindFirstChild("Main")
        if main then
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
    local char = Player.Character
    if not char or not HRP then return end
    
    if _G.State == "CHECK_QUEST" then
        print("🔍 Đang chọn quest...")
        SelectQuestByLevel()
        task.wait(0.5)
        
    elseif _G.State == "GET_QUEST" then
        print("✈️ Bay đến NPC nhận quest:", _G.CurrentQuest.QuestName)
        print("📍 NPC Position:", _G.CurrentQuest.NPCPos)
        
        _G.Busy = true
        TweenToPosition(_G.CurrentQuest.NPCPos)
        task.wait(2)
        
        -- Gọi remote nhận quest
        pcall(function()
            local remote = ReplicatedStorage.Remotes.CommF_
            remote:InvokeServer("StartQuest", _G.CurrentQuest.QuestName)
            task.wait(0.5)
        end)
        
        -- Kiểm tra quest đã nhận chưa (chờ tối đa 3 giây)
        local questAccepted = false
        for i = 1, 6 do
            task.wait(0.5)
            if IsQuestAccepted() then
                questAccepted = true
                print("✅ QUEST NHẬN THÀNH CÔNG!")
                break
            end
        end
        
        if questAccepted then
            print("✅ CHUYỂN SANG FARM!")
            _G.State = "MOVING_TO_FARM"
        else
            print("❌ LỖI: Quest không được nhận, thử lại...")
            _G.State = "CHECK_QUEST"
        end
        
        _G.Busy = false
        
    elseif _G.State == "MOVING_TO_FARM" then
        print("🌾 Bay đến khu farm:", _G.CurrentQuest.MobArea)
        local mobArea = _G.CurrentQuest.MobArea
        
        _G.Busy = true
        TweenToPosition(mobArea)
        task.wait(2)
        
        task.wait(0.5)
        _G.State = "FARMING"
        StartHover()
        _G.Busy = false
        print("✅ BẮT ĐẦU FARMING!")
        
    elseif _G.State == "FARMING" then
        -- Giữ độ cao
        if HRP and HRP.Velocity.Y < -3 then
            HRP.Velocity = Vector3.new(HRP.Velocity.X, 0, HRP.Velocity.Z)
        end
        
        -- Kiểm tra quest hoàn thành
        if not IsQuestAccepted() then
            print("✅ QUEST HOÀN THÀNH!")
            StopHover()
            _G.State = "CHECK_QUEST"
            return
        end
        
        -- Tìm và đánh quái
        local mob = GetNearestMob(_G.CurrentQuest.npc)
        if mob then
            local mobPos = mob.HumanoidRootPart.Position
            local distanceToMob = (HRP.Position - mobPos).Magnitude
            if distanceToMob > 15 then
                TweenToPosition(mobPos)
            end
            DoAttack()
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
            print("🔄 AUTO FARM ON - FULL RESET")
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

farmGroup:AddButton({
    Title = "⚡ BẬT HAKI",
    Callback = function()
        _G.AutoHaki = true
        EnableHaki()
        print("✅ Haki đã BẬT")
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
    Min = 6,
    Max = 15,
    Default = 9,
    Callback = function(v) _G.FlyHeight = v end
})

UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ AUTO FARM 1-2800 - ĐÃ FIX HOÀN CHỈNH!")
print("📌 State Machine: CHECK_QUEST → GET_QUEST → MOVING_TO_FARM → FARMING")
print("📌 Có kiểm tra quest trước khi chuyển state")
print("📌 Tự động giữ độ cao khi farm")
print("📌 Gom quái + Haki + Fast Attack")
print("📌 Bấm 'BẬT AUTO FARM' để bắt đầu")
print("=" .. string.rep("=", 50)) 

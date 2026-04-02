-- Gọi UI Library từ GitHub của bạn
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

-- Tạo cửa sổ chính
local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "Auto Farm Blox Fruits | by Quoc Hoa",
    Image = "rbxassetid://76048047842530"
})

-- ==================== TẠO TAB ====================
local farmTab = window:AddTab("🌾 Farm")
local settingTab = window:AddTab("⚙️ Settings")

-- ==================== BIẾN CẤU HÌNH ====================
_G.AutoFarm = false
_G.BringMob = true
_G.TweenSpeed = 300
_G.AttackDelay = 0.2
_G.DistanceMob = 300

-- ==================== SERVICE ====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = Players.LocalPlayer

-- ==================== MỐC LEVEL 1-2600 ====================
local QuestLevels = {
    {min = 1, max = 10, npc = "Bandit", questName = "BanditQuest1", location = Vector3.new(1120, 13, 1450)},
    {min = 11, max = 20, npc = "Monkey", questName = "MonkeyQuest1", location = Vector3.new(-1177, 68, 292)},
    {min = 21, max = 30, npc = "Pirate", questName = "PirateQuest1", location = Vector3.new(2677, 28, 180)},
    {min = 31, max = 40, npc = "Brute", questName = "BruteQuest1", location = Vector3.new(2865, 29, 482)},
    {min = 41, max = 50, npc = "Viking", questName = "VikingQuest1", location = Vector3.new(249, 51, 435)},
    {min = 51, max = 70, npc = "SnowTrooper", questName = "SnowTrooperQuest1", location = Vector3.new(873, 114, -1269)},
    {min = 71, max = 85, npc = "ChiefPettyOfficer", questName = "ChiefPettyOfficerQuest1", location = Vector3.new(-438, 18, 618)},
    {min = 86, max = 100, npc = "SkyBandit", questName = "SkyBanditQuest1", location = Vector3.new(-4838, 721, -2660)},
    {min = 101, max = 120, npc = "DarkMaster", questName = "DarkMasterQuest1", location = Vector3.new(-5174, 593, -2759)},
    {min = 121, max = 140, npc = "Toga", questName = "TogaQuest1", location = Vector3.new(-5236, 817, -3103)},
    {min = 141, max = 160, npc = "Fishman", questName = "FishmanQuest1", location = Vector3.new(3928, 10, -1032)},
    {min = 161, max = 180, npc = "FishmanCommander", questName = "FishmanCommanderQuest1", location = Vector3.new(3904, 12, -1408)},
    {min = 181, max = 210, npc = "GalleyPirate", questName = "GalleyPirateQuest1", location = Vector3.new(5598, 13, 700)},
    {min = 211, max = 240, npc = "GalleyCaptain", questName = "GalleyCaptainQuest1", location = Vector3.new(5697, 14, 686)},
    {min = 241, max = 270, npc = "Marine", questName = "MarineQuest1", location = Vector3.new(-2937, 12, -2857)},
    {min = 271, max = 300, npc = "MarineCaptain", questName = "MarineCaptainQuest1", location = Vector3.new(-2936, 13, -2998)},
    {min = 301, max = 330, npc = "Prisoner", questName = "PrisonerQuest1", location = Vector3.new(5308, 18, 42)},
    {min = 331, max = 360, npc = "DangerousPrisoner", questName = "DangerousPrisonerQuest1", location = Vector3.new(5310, 16, 137)},
    {min = 361, max = 400, npc = "MilitarySoldier", questName = "MilitarySoldierQuest1", location = Vector3.new(-2381, 23, -2352)},
    {min = 401, max = 450, npc = "MilitarySpy", questName = "MilitarySpyQuest1", location = Vector3.new(-2581, 24, -2485)},
    {min = 451, max = 500, npc = "SaberExpert", questName = "SaberExpertQuest1", location = Vector3.new(1432, 11, 26)},
    {min = 501, max = 550, npc = "GodHuman", questName = "GodHumanQuest1", location = Vector3.new(-4652, 822, -3030)},
    {min = 551, max = 600, npc = "CursedCaptain", questName = "CursedCaptainQuest1", location = Vector3.new(3637, 17, -354)},
    {min = 601, max = 650, npc = "IceAdmiral", questName = "IceAdmiralQuest1", location = Vector3.new(1562, 13, 433)},
    {min = 651, max = 700, npc = "MagmaNinja", questName = "MagmaNinjaQuest1", location = Vector3.new(-5718, 9, 273)},
    {min = 701, max = 725, npc = "Raider", questName = "RaiderQuest1", location = Vector3.new(771, 31, 1351)},
    {min = 726, max = 750, npc = "Mercenary", questName = "MercenaryQuest1", location = Vector3.new(786, 32, 1172)},
    {min = 751, max = 775, npc = "SwanPirate", questName = "SwanPirateQuest1", location = Vector3.new(527, 18, 1406)},
    {min = 776, max = 800, npc = "FactoryStaff", questName = "FactoryStaffQuest1", location = Vector3.new(435, 209, -376)},
    {min = 801, max = 850, npc = "MarineLieutenant", questName = "MarineLieutenantQuest1", location = Vector3.new(-2804, 72, -3342)},
    {min = 851, max = 900, npc = "MarineCaptain", questName = "MarineCaptainQuest2", location = Vector3.new(-2828, 73, -3497)},
    {min = 901, max = 950, npc = "Zombie", questName = "ZombieQuest1", location = Vector3.new(-546, 34, -486)},
    {min = 951, max = 1000, npc = "Vampire", questName = "VampireQuest1", location = Vector3.new(-549, 30, -609)},
    {min = 1001, max = 1050, npc = "Snowman", questName = "SnowmanQuest1", location = Vector3.new(529, 154, -433)},
    {min = 1051, max = 1100, npc = "SnowTrooper", questName = "SnowTrooperQuest2", location = Vector3.new(705, 158, -543)},
    {min = 1101, max = 1150, npc = "LabSubordinate", questName = "LabSubordinateQuest1", location = Vector3.new(-4117, 345, -2661)},
    {min = 1151, max = 1200, npc = "HornedMan", questName = "HornedManQuest1", location = Vector3.new(-4183, 343, -2788)},
    {min = 1201, max = 1250, npc = "Diamond", questName = "DiamondQuest1", location = Vector3.new(-1665, 243, 85)},
    {min = 1251, max = 1300, npc = "PirateMilitia", questName = "PirateMilitiaQuest1", location = Vector3.new(-1266, 73, 967)},
    {min = 1301, max = 1350, npc = "Gunslinger", questName = "GunslingerQuest1", location = Vector3.new(-1393, 64, 990)},
    {min = 1351, max = 1400, npc = "Crewmate", questName = "CrewmateQuest1", location = Vector3.new(-285, 44, 1643)},
    {min = 1401, max = 1450, npc = "Bentham", questName = "BenthamQuest1", location = Vector3.new(-138, 46, 1634)},
    {min = 1451, max = 1525, npc = "DonSwan", questName = "DonSwanQuest1", location = Vector3.new(288, 31, 1629)},
    {min = 1526, max = 1575, npc = "Pirate", questName = "PirateQuest3", location = Vector3.new(-1110, 12, 3870)},
    {min = 1576, max = 1625, npc = "Brute", questName = "BruteQuest3", location = Vector3.new(-1116, 14, 3966)},
    {min = 1626, max = 1675, npc = "Gladiator", questName = "GladiatorQuest1", location = Vector3.new(1364, 25, 1190)},
    {min = 1676, max = 1725, npc = "MilitarySoldier", questName = "MilitarySoldierQuest3", location = Vector3.new(1322, 24, 1127)},
    {min = 1726, max = 1775, npc = "Marine", questName = "MarineQuest3", location = Vector3.new(-2620, 198, 3199)},
    {min = 1776, max = 1825, npc = "MarineCaptain", questName = "MarineCaptainQuest3", location = Vector3.new(-2628, 199, 3316)},
    {min = 1826, max = 1875, npc = "Thug", questName = "ThugQuest1", location = Vector3.new(-3244, 246, 952)},
    {min = 1876, max = 1925, npc = "Raider", questName = "RaiderQuest3", location = Vector3.new(-3256, 247, 832)},
    {min = 1926, max = 1975, npc = "GalleyPirate", questName = "GalleyPirateQuest3", location = Vector3.new(-456, 77, -2960)},
    {min = 1976, max = 2025, npc = "GalleyCaptain", questName = "GalleyCaptainQuest3", location = Vector3.new(-444, 78, -3088)},
    {min = 2026, max = 2075, npc = "Pirate", questName = "PirateQuest4", location = Vector3.new(5694, 613, -132)},
    {min = 2076, max = 2125, npc = "Brute", questName = "BruteQuest4", location = Vector3.new(5782, 614, -192)},
    {min = 2126, max = 2175, npc = "Pirate", questName = "PirateQuest5", location = Vector3.new(-1683, 35, -5038)},
    {min = 2176, max = 2225, npc = "Brute", questName = "BruteQuest5", location = Vector3.new(-1615, 37, -5117)},
    {min = 2226, max = 2275, npc = "Firefighter", questName = "FirefighterQuest1", location = Vector3.new(-134, 445, -202)},
    {min = 2276, max = 2325, npc = "Scientist", questName = "ScientistQuest1", location = Vector3.new(-76, 444, -219)},
    {min = 2326, max = 2375, npc = "Zombie", questName = "ZombieQuest3", location = Vector3.new(-2249, 445, -815)},
    {min = 2376, max = 2425, npc = "Vampire", questName = "VampireQuest3", location = Vector3.new(-2344, 445, -934)},
    {min = 2426, max = 2475, npc = "Ghost", questName = "GhostQuest1", location = Vector3.new(-4550, 390, -3672)},
    {min = 2476, max = 2525, npc = "Reaper", questName = "ReaperQuest1", location = Vector3.new(-4727, 391, -3802)},
    {min = 2526, max = 2600, npc = "DragonCrew", questName = "DragonCrewQuest1", location = Vector3.new(-5374, 309, -5053)},
}

-- ==================== HÀM TWEEN MOVE ====================
function TweenToPosition(Position)
    if not _G.AutoFarm then return end
    pcall(function()
        local char = Player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local distance = (hrp.Position - Position).Magnitude
        if distance < 5 then return end
        local tween = TweenService:Create(hrp, 
            TweenInfo.new(distance / _G.TweenSpeed, Enum.EasingStyle.Linear),
            {CFrame = CFrame.new(Position)}
        )
        tween:Play()
        tween.Completed:Wait()
    end)
end

-- ==================== NOCLIP & ANTI-FALL ====================
task.spawn(function()
    while true do
        task.wait(0.3)
        if _G.AutoFarm then
            pcall(function()
                local char = Player.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp.Velocity.Y < -50 then
                        hrp.Velocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
        end
    end
end)

-- ==================== AUTO QUEST ====================
function GetQuestByLevel(level)
    for _, q in pairs(QuestLevels) do
        if level >= q.min and level <= q.max then return q end
    end
    return QuestLevels[1]
end

function StartQuest(questData)
    pcall(function()
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("CommF_")
        remote:InvokeServer("StartQuest", {questData.npc, questData.questName})
    end)
end

-- ==================== BRING MOB ====================
task.spawn(function()
    while true do
        task.wait(0.15)
        if _G.AutoFarm and _G.BringMob then
            pcall(function()
                local char = Player.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                local TargetPos = hrp.Position + Vector3.new(0, -5, 0)
                for _, v in pairs(workspace:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                        local enemyHrp = v.HumanoidRootPart
                        local enemyHum = v.Humanoid
                        if enemyHum.Health > 0 and (enemyHrp.Position - hrp.Position).Magnitude <= _G.DistanceMob then
                            enemyHrp.CanCollide = false
                            enemyHrp.CFrame = CFrame.new(TargetPos)
                            enemyHrp.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== AUTO ATTACK ====================
task.spawn(function()
    while true do
        task.wait(_G.AttackDelay)
        if _G.AutoFarm then
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.05)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        end
    end
end)

-- ==================== MAIN LOOP FARM ====================
task.spawn(function()
    while true do
        task.wait(1)
        if _G.AutoFarm then
            pcall(function()
                local char = Player.Character
                if not char then return end
                local playerLevel = Player.Data.Level.Value
                local questData = GetQuestByLevel(playerLevel)
                TweenToPosition(questData.location)
                task.wait(0.5)
                StartQuest(questData)
                task.wait(1)
                local mobArea = questData.location + Vector3.new(0, 0, 50)
                TweenToPosition(mobArea)
            end)
        end
    end
end)

-- ==================== UI - TAB FARM (DÙNG BUTTON) ====================
local farmGroup = farmTab:AddLeftGroupbox("🤖 Auto Farm")

-- Nút bật/tắt Auto Farm (dạng toggle bằng button)
local autoFarmStatus = "🔴 TẮT"
farmGroup:AddButton({
    Title = "▶️ BẬT AUTO FARM",
    Callback = function()
        _G.AutoFarm = true
        autoFarmStatus = "🟢 ĐANG BẬT"
        print("✅ Auto Farm đã BẬT")
    end
})

farmGroup:AddButton({
    Title = "⏹️ TẮT AUTO FARM",
    Callback = function()
        _G.AutoFarm = false
        autoFarmStatus = "🔴 ĐANG TẮT"
        print("⏸️ Auto Farm đã TẮT")
    end
})

-- Nút bật/tắt Bring Mob
farmGroup:AddButton({
    Title = "📦 BẬT GOM QUÁI (Bring Mob)",
    Callback = function()
        _G.BringMob = true
        print("✅ Bring Mob đã BẬT")
    end
})

farmGroup:AddButton({
    Title = "📦 TẮT GOM QUÁI (Bring Mob)",
    Callback = function()
        _G.BringMob = false
        print("⏸️ Bring Mob đã TẮT")
    end
})

-- Hiển thị level
farmGroup:AddButton({
    Title = "📊 XEM LEVEL HIỆN TẠI",
    Callback = function()
        print("📊 Level hiện tại: " .. (Player.Data.Level.Value or 0))
    end
})

-- ==================== UI - TAB SETTINGS ====================
local settingGroup = settingTab:AddLeftGroupbox("⚙️ Cài Đặt (Dùng Slider)")

-- Lưu ý: Nếu Slider không hoạt động, thay bằng Button để tăng/giảm
settingGroup:AddSlider({
    Title = "🚀 Tốc độ di chuyển",
    Subtitle = "Tween Speed",
    Min = 100,
    Max = 500,
    Default = 300,
    Callback = function(value)
        _G.TweenSpeed = value
        print("Tốc độ: " .. value)
    end
})

settingGroup:AddSlider({
    Title = "⚔️ Delay đòn đánh",
    Subtitle = "Attack Delay (giây)",
    Min = 0.05,
    Max = 0.5,
    Default = 0.2,
    Decimal = true,
    Callback = function(value)
        _G.AttackDelay = value
        print("Delay đánh: " .. value)
    end
})

settingGroup:AddSlider({
    Title = "📏 Khoảng cách gom quái",
    Subtitle = "Distance Mob",
    Min = 100,
    Max = 500,
    Default = 300,
    Callback = function(value)
        _G.DistanceMob = value
        print("Khoảng cách gom: " .. value)
    end
})

-- ==================== HIỂN THỊ UI ====================
UI.ToggleUI()
print("Apple Hub Premium | by Quoc Hoa - Đã tải xong!")
print("📌 Cách dùng: Bấm 'BẬT AUTO FARM' để bắt đầu farm")

-- Gọi UI Library (CỦA BẠN)
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "Auto Farm 1-2824 | Expert v12.0",
    Image = "rbxassetid://76048047842530"
})

local farmTab = window:AddTab("🌾 Farm")
local settingTab = window:AddTab("⚙️ Settings")

-- ==================== BIẾN CẤU HÌNH ====================
_G.AutoFarm = false
_G.BringMob = true
_G.TweenSpeed = 300
_G.AttackDelay = 0.04
_G.FlyHeight = 12
_G.BigHitbox = true
_G.CurrentQuest = nil
_G.GatheredMobs = {}

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

-- ==================== GLOBAL ANTI-DETECT ====================
pcall(function()
    sethiddenproperty(Player, "SimulationRadius", math.huge)
end)

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
        if Player.Data:FindFirstChild("BusoStage") then
            Player.Data.BusoStage.Value = 1
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(10)
        if _G.AutoFarm then ForceHakiArms() end
    end
end)

-- ==================== QUEST DATABASE ====================
local QuestData = {
    {1,9,"BanditQuest1","Bandit",CFrame.new(1061,17,1549),CFrame.new(1100,13,1480)},
    {10,14,"BanditQuest2","Bandit",CFrame.new(1061,17,1549),CFrame.new(1100,13,1480)},
    {15,29,"JungleQuest","Monkey",CFrame.new(-1400,37,90),CFrame.new(-1200,68,320)},
    {30,59,"JungleQuest","Gorilla",CFrame.new(-1250,37,1600),CFrame.new(-1280,37,1580)},
    {60,89,"SnowQuest","Snow Bandit",CFrame.new(1386,87,-1297),CFrame.new(1350,87,-1320)},
    {90,124,"SnowQuest","Snowman",CFrame.new(1386,87,-1297),CFrame.new(1350,87,-1320)},
    {125,149,"MarineQuest1","Marine Captain",CFrame.new(611,73,552),CFrame.new(580,73,520)},
    {150,174,"MarineQuest2","Marine Lieutenant",CFrame.new(611,73,552),CFrame.new(580,73,520)},
    {175,224,"SkyQuest1","Sky Bandit",CFrame.new(-4842,717,-2623),CFrame.new(-4870,717,-2650)},
    {225,299,"SkyQuest2","Skypiea Warrior",CFrame.new(-4842,717,-2623),CFrame.new(-4870,717,-2650)},
    {300,374,"BridgeQuest1","Mad Scientist",CFrame.new(-1606,36,181),CFrame.new(-1630,36,150)},
    {375,399,"BridgeQuest2","Forest Pirate",CFrame.new(-1606,36,181),CFrame.new(-1630,36,150)},
    {400,449,"ColosseumQuest","Military Soldier",CFrame.new(-1576,7,158),CFrame.new(-1600,7,130)},
    {450,499,"ColosseumQuest","Military Spy",CFrame.new(-1576,7,158),CFrame.new(-1600,7,130)},
    {500,549,"SkyQuest3","Dark Master",CFrame.new(-4842,717,-2623),CFrame.new(-4870,717,-2650)},
    {550,624,"FrozenQuest","Frost Pirate",CFrame.new(5668,28,853),CFrame.new(5640,28,820)},
    {625,699,"FrozenQuest","Snow Lurker",CFrame.new(5668,28,853),CFrame.new(5640,28,820)},
    {700,774,"GreenbanditQuest","Green Bandit",CFrame.new(-2553,6,4533),CFrame.new(-2520,6,4560)},
    {775,849,"GreenbanditQuest","Forest Warrior",CFrame.new(-2553,6,4533),CFrame.new(-2520,6,4560)},
    {850,924,"MarineCaptainQuest","Marine Captain",CFrame.new(6094,95,5907),CFrame.new(6060,95,5930)},
    {925,999,"MarineCaptainQuest","Marine Commodore",CFrame.new(6094,95,5907),CFrame.new(6060,95,5930)},
    {1000,1074,"MagmaQuest1","Military Soldier",CFrame.new(3876,35,-3427),CFrame.new(3840,35,-3450)},
    {1075,1149,"MagmaQuest1","Military Spy",CFrame.new(3876,35,-3427),CFrame.new(3840,35,-3450)},
    {1150,1199,"MagmaQuest2","Lava Pirate",CFrame.new(3876,35,-3427),CFrame.new(3840,35,-3450)},
    {1200,1249,"MagmaQuest2","Mythological Pirate",CFrame.new(3876,35,-3427),CFrame.new(3840,35,-3450)},
    {1250,1349,"FishmanQuest","Fishman Warrior",CFrame.new(61163,19,10608),CFrame.new(61130,19,10640)},
    {1350,1449,"FishmanQuest","Fishman Commando",CFrame.new(61163,19,10608),CFrame.new(61130,19,10640)},
    {1450,1549,"SkyExp1Quest","Sky Expedition",CFrame.new(-7862,5566,-380),CFrame.new(-7890,5566,-410)},
    {1500,1549,"SkyExp1Quest","Sky Expedition",CFrame.new(-7862,5566,-380),CFrame.new(-7890,5566,-410)},
    {1550,1599,"SkyExp2Quest","God",CFrame.new(-7862,5566,-380),CFrame.new(-7890,5566,-410)},
    {1600,1624,"CastleQuest1","Captain Elephant",CFrame.new(-5075,314,8400),CFrame.new(-5100,314,8370)},
    {1625,1674,"CastleQuest1","Guardian Robot",CFrame.new(-5075,314,8400),CFrame.new(-5100,314,8370)},
    {1675,1724,"CastleQuest2","Kithmus",CFrame.new(-5075,314,8400),CFrame.new(-5100,314,8370)},
    {1725,1774,"CastleQuest2","Toga Warrior",CFrame.new(-5075,314,8400),CFrame.new(-5100,314,8370)},
    {1775,1824,"MarineQuest3","Marine Commodore",CFrame.new(5232,61,855),CFrame.new(5200,61,820)},
    {1825,1874,"MarineQuest3","Marine Rear Admiral",CFrame.new(5232,61,855),CFrame.new(5200,61,820)},
    {1875,1924,"SnowMountainQuest","Snow Mountain",CFrame.new(619,74,1468),CFrame.new(590,74,1440)},
    {1925,1974,"SnowMountainQuest","Snow Mountain",CFrame.new(619,74,1468),CFrame.new(590,74,1440)},
    {1975,2024,"IceFireQuest","Ice Fire",CFrame.new(5433,89,1350),CFrame.new(5400,89,1320)},
    {2025,2074,"IceFireQuest","Ice Fire",CFrame.new(5433,89,1350),CFrame.new(5400,89,1320)},
    {2075,2124,"PortableFortressQuest","Portable Fortress",CFrame.new(-490,54,4332),CFrame.new(-520,54,4300)},
    {2125,2174,"PortableFortressQuest","Portable Fortress",CFrame.new(-490,54,4332),CFrame.new(-520,54,4300)},
    {2175,2224,"PortTownQuest","Port Town",CFrame.new(-290,44,5447),CFrame.new(-320,44,5420)},
    {2225,2274,"PortTownQuest","Port Town",CFrame.new(-290,44,5447),CFrame.new(-320,44,5420)},
    {2275,2324,"HydraIslandQuest","Hydra Island",CFrame.new(5735,62,-4430),CFrame.new(5700,62,-4460)},
    {2325,2374,"HydraIslandQuest","Hydra Island",CFrame.new(5735,62,-4430),CFrame.new(5700,62,-4460)},
    {2375,2424,"GreatTreeQuest","Great Tree",CFrame.new(2682,4340,-3318),CFrame.new(2650,4340,-3350)},
    {2425,2474,"GreatTreeQuest","Great Tree",CFrame.new(2682,4340,-3318),CFrame.new(2650,4340,-3350)},
    {2475,2524,"CastleOnSeaQuest","Castle on Sea",CFrame.new(5192,56,3405),CFrame.new(5160,56,3370)},
    {2525,2574,"CastleOnSeaQuest","Castle on Sea",CFrame.new(5192,56,3405),CFrame.new(5160,56,3370)},
    {2575,2624,"SeaOfTreatsQuest","Sea of Treats",CFrame.new(-1800,10,50),CFrame.new(-1830,10,20)},
    {2625,2674,"SeaOfTreatsQuest","Sea of Treats",CFrame.new(-1800,10,50),CFrame.new(-1830,10,20)},
    {2675,2724,"TikiOutpostQuest","Tiki Outpost",CFrame.new(-1600,70,200),CFrame.new(-1630,70,170)},
    {2725,2774,"TikiOutpostQuest","Tiki Outpost",CFrame.new(-1600,70,200),CFrame.new(-1630,70,170)},
    {2775,2824,"BartiloQuest","Bartilo",CFrame.new(-1850,40,150),CFrame.new(-1880,40,120)}
}

-- ==================== TÌM QUEST ====================
function SelectQuest()
    local level = Player.Data.Level.Value
    for _, quest in ipairs(QuestData) do
        if level >= quest[1] and level <= quest[2] then
            _G.CurrentQuest = quest
            print("🎯 Quest:", quest[3], "→", quest[4])
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

-- ==================== FARM ABOVE ====================
function FarmAbove()
    if not HRP then return end
    local farmPos = HRP.Position + Vector3.new(math.random(-20,20), _G.FlyHeight, math.random(-20,20))
    HRP.CFrame = CFrame.new(farmPos)
end

-- ==================== SUPER BRING MOB ====================
function SuperBringMob()
    if not HRP then return end
    local playerPos = HRP.Position
    local gatherPoint = playerPos - Vector3.new(0, _G.FlyHeight, 0)
    
    _G.GatheredMobs = {}
    
    local enemies = Workspace:FindFirstChild("Enemies")
    if not enemies then return end
    
    for _, mob in ipairs(enemies:GetChildren()) do
        if mob.Name == _G.CurrentQuest[4] and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid and mob.Humanoid.Health > 0 then
            local dist = (playerPos - mob.HumanoidRootPart.Position).Magnitude
            if dist <= 200 then
                table.insert(_G.GatheredMobs, mob)
                pcall(function()
                    sethiddenproperty(mob, "SimulationRadius", math.huge)
                    mob.HumanoidRootPart.CFrame = CFrame.new(gatherPoint)
                    mob.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                    if _G.BigHitbox then
                        mob.HumanoidRootPart.Size = Vector3.new(8,8,8)
                    end
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
            for i = 1, 8 do
                commF.CommF_:InvokeServer("Melee")
                task.wait(_G.AttackDelay)
            end
        end
        VU:ClickButton1(Vector2.new())
    end)
end

-- ==================== MAIN LOOP ====================
task.spawn(function()
    while true do
        if _G.AutoFarm then
            pcall(function()
                UpdateCharacter()
                
                if SelectQuest() and _G.CurrentQuest then
                    -- Bay đến NPC
                    FlyTo(_G.CurrentQuest[5].Position)
                    task.wait(0.5)
                    
                    -- Nhận quest
                    local commF = ReplicatedStorage:FindFirstChild("Remotes")
                    if commF and commF:FindFirstChild("CommF_") then
                        commF.CommF_:InvokeServer("StartQuest", _G.CurrentQuest[3], 1)
                    end
                    task.wait(2)
                    
                    -- Kiểm tra quest thành công
                    if IsQuestAccepted() then
                        -- Bay đến khu farm
                        FlyTo(_G.CurrentQuest[6].Position)
                        task.wait(0.5)
                        
                        -- Farm cycle
                        for i = 1, 40 do
                            if not _G.AutoFarm then break end
                            FarmAbove()
                            if _G.BringMob then SuperBringMob() end
                            FastAttack()
                            
                            if i % 10 == 0 and HRP then
                                HRP.CFrame = HRP.CFrame + HRP.CFrame.LookVector * 5
                            end
                            task.wait(0.3)
                        end
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- ==================== UI (DÙNG BUTTON CỦA BẠN) ====================
local farmGroup = farmTab:AddLeftGroupbox("🤖 Điều Khiển")

farmGroup:AddButton({
    Title = "▶️ BẬT AUTO FARM",
    Callback = function()
        _G.AutoFarm = true
        print("✅ Auto Farm Expert v12.0 đã BẬT")
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
    Title = "💥 BẬT BIG HITBOX",
    Callback = function()
        _G.BigHitbox = true
        print("✅ Big Hitbox BẬT")
    end
})

farmGroup:AddButton({
    Title = "💥 TẮT BIG HITBOX",
    Callback = function()
        _G.BigHitbox = false
        print("⏸️ Big Hitbox TẮT")
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

settingGroup:AddSlider({
    Title = "⚔️ Delay đánh",
    Min = 0.02,
    Max = 0.1,
    Default = 0.04,
    Decimal = true,
    Callback = function(v) _G.AttackDelay = v end
})

-- ==================== HIỂN THỊ UI ====================
UI.ToggleUI()
print("=" .. string.rep("=", 50))
print("✅ EXPERT AUTO FARM v12.0 - ĐÃ SẴN SÀNG!")
print("📌 Farm Above - Bay trên đầu quái")
print("📌 Big Hitbox - Đánh rộng hơn")
print("📌 Super Bring Mob - Gom quái bán kính 200")
print("📌 Auto Haki + Fast Attack")
print("📌 Full Quest DB 1-2824")
print("📌 Bấm 'BẬT AUTO FARM' để bắt đầu")
print("=" .. string.rep("=", 50))

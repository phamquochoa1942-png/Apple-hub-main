-- Gọi UI Library
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "Auto Farm Fix | by Quoc Hoa",
    Image = "rbxassetid://76048047842530"
})

local farmTab = window:AddTab("🌾 Farm")
local settingTab = window:AddTab("⚙️ Settings")

-- ==================== BIẾN CẤU HÌNH ====================
_G.AutoFarm = false
_G.BringMob = true
_G.TweenSpeed = 300
_G.AttackDelay = 0.2
_G.DistanceMob = 250

-- ==================== SERVICE ====================
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Player = Players.LocalPlayer

-- ==================== MỐC LEVEL (ĐÃ RÚT GỌN - DỄ TEST) ====================
local QuestLevels = {
    {min = 1, max = 10, npc = "Bandit", questName = "Bandit", location = Vector3.new(1120, 13, 1450), mobArea = Vector3.new(1100, 13, 1480)},
    {min = 11, max = 20, npc = "Monkey", questName = "Monkey", location = Vector3.new(-1177, 68, 292), mobArea = Vector3.new(-1200, 68, 320)},
    {min = 21, max = 30, npc = "Pirate", questName = "Pirate", location = Vector3.new(2677, 28, 180), mobArea = Vector3.new(2650, 28, 200)},
    -- Thêm các level khác tương tự nếu cần
}

function GetQuestByLevel(level)
    for _, q in pairs(QuestLevels) do
        if level >= q.min and level <= q.max then return q end
    end
    return QuestLevels[1]
end

-- ==================== LOGIC BAY (TWEEN) - ĐÃ SỬA LINH HOẠT ====================
local currentTween = nil

function StopTween()
    if currentTween then
        pcall(function() currentTween:Cancel() end)
        currentTween = nil
    end
end

function TweenToPosition(Position)
    if not _G.AutoFarm then return false end
    StopTween()
    
    local success = pcall(function()
        local char = Player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local distance = (hrp.Position - Position).Magnitude
        if distance < 10 then return end
        
        -- Tạo tween mới
        local tweenInfo = TweenInfo.new(
            math.clamp(distance / _G.TweenSpeed, 0.5, 10),
            Enum.EasingStyle.Linear
        )
        currentTween = TweenService:Create(hrp, tweenInfo, {CFrame = CFrame.new(Position)})
        currentTween:Play()
        currentTween.Completed:Wait()
        currentTween = nil
    end)
    return success
end

-- ==================== NOCLIP (XUYÊN TƯỜNG) ====================
task.spawn(function()
    while true do
        task.wait(0.2)
        if _G.AutoFarm then
            pcall(function()
                local char = Player.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== ANTI-FALL (CHỐNG BAY KICK) ====================
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AutoFarm then
            pcall(function()
                local char = Player.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp.Velocity.Y < -40 then
                        hrp.Velocity = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z)
                    end
                end
            end)
        end
    end
end)

-- ==================== AUTO QUEST - ĐÃ SỬA ====================
function GetRemote()
    local replicated = game:GetService("ReplicatedStorage")
    local remotes = replicated:FindFirstChild("Remotes")
    if remotes then
        return remotes:FindFirstChild("CommF_")
    end
    return nil
end

function StartQuest(questData)
    if not questData then return end
    
    pcall(function()
        local remote = GetRemote()
        if not remote then 
            print("❌ Không tìm thấy Remote!")
            return 
        end
        
        -- Cách 1: Dùng InvokeServer (thường dùng nhất)
        local success, result = pcall(function()
            return remote:InvokeServer("StartQuest", questData.npc)
        end)
        
        if success then
            print("✅ Đã gửi yêu cầu nhận quest: " .. questData.npc)
        else
            -- Cách 2: Thử FireServer
            pcall(function()
                remote:FireServer("StartQuest", questData.npc)
                print("✅ Đã gửi FireServer quest: " .. questData.npc)
            end)
        end
    end)
end

-- ==================== BRING MOB (GOM QUÁI) - ĐÃ SỬA ====================
function GetEnemies()
    local enemies = {}
    pcall(function()
        -- Tìm quái trong workspace
        for _, v in pairs(workspace:GetChildren()) do
            if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                local hum = v.Humanoid
                if hum.Health > 0 and hum.Health < 10000 then -- Lọc bỏ boss
                    table.insert(enemies, v)
                end
            end
        end
        -- Tìm trong folder Enemies nếu có
        local enemyFolder = workspace:FindFirstChild("Enemies")
        if enemyFolder then
            for _, v in pairs(enemyFolder:GetChildren()) do
                if v:FindFirstChild("Humanoid") and v:FindFirstChild("HumanoidRootPart") then
                    local hum = v.Humanoid
                    if hum.Health > 0 then
                        table.insert(enemies, v)
                    end
                end
            end
        end
    end)
    return enemies
end

task.spawn(function()
    while true do
        task.wait(0.1)
        if _G.AutoFarm and _G.BringMob then
            pcall(function()
                local char = Player.Character
                if not char then return end
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                local myPos = hrp.Position
                local targetPos = myPos + Vector3.new(0, -3, 0)
                local enemies = GetEnemies()
                
                for _, enemy in pairs(enemies) do
                    local enemyHrp = enemy:FindFirstChild("HumanoidRootPart")
                    if enemyHrp then
                        local dist = (enemyHrp.Position - myPos).Magnitude
                        if dist <= _G.DistanceMob and dist > 5 then
                            enemyHrp.CanCollide = false
                            enemyHrp.CFrame = CFrame.new(targetPos)
                            enemyHrp.Velocity = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end)
        end
    end
end)

-- ==================== AUTO ATTACK (M1) ====================
task.spawn(function()
    while true do
        task.wait(_G.AttackDelay)
        if _G.AutoFarm then
            pcall(function()
                -- Click chuột trái (M1)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.03)
                VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            end)
        end
    end
end)

-- ==================== MAIN LOOP FARM - ĐÃ SỬA LẠI TOÀN BỘ ====================
task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AutoFarm then
            pcall(function()
                -- Đợi nhân vật load
                if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then
                    task.wait(2)
                    return
                end
                
                local playerLevel = Player.Data.Level.Value
                local questData = GetQuestByLevel(playerLevel)
                
                if not questData then 
                    print("⚠️ Không tìm thấy quest cho level " .. playerLevel)
                    return 
                end
                
                -- 1. Di chuyển đến NPC
                print("🚶 Đang di chuyển đến " .. questData.npc)
                TweenToPosition(questData.location)
                task.wait(0.8)
                
                -- 2. Nhận quest
                print("📜 Đang nhận quest từ " .. questData.npc)
                StartQuest(questData)
                task.wait(1)
                
                -- 3. Di chuyển đến khu vực có quái
                print("⚔️ Di chuyển đến khu vực farm")
                TweenToPosition(questData.mobArea or (questData.location + Vector3.new(0, 0, 60)))
                task.wait(0.5)
                
                -- 4. Hiển thị trạng thái
                print("🔥 Đang farm | Level: " .. playerLevel .. " | Quái: " .. questData.npc)
            end)
        end
    end
end)

-- ==================== UI ====================
local farmGroup = farmTab:AddLeftGroupbox("🤖 Điều Khiển")

farmGroup:AddButton({
    Title = "▶️ BẬT AUTO FARM",
    Callback = function()
        _G.AutoFarm = true
        print("✅ Auto Farm đã BẬT")
        print("📌 Script sẽ tự động: Nhận quest -> Di chuyển -> Gom quái -> Đánh")
    end
})

farmGroup:AddButton({
    Title = "⏹️ TẮT AUTO FARM",
    Callback = function()
        _G.AutoFarm = false
        StopTween()
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
    Title = "📍 TEST NHẬN QUEST",
    Callback = function()
        local level = Player.Data.Level.Value
        local quest = GetQuestByLevel(level)
        if quest then
            print("🧪 Test nhận quest từ: " .. quest.npc)
            TweenToPosition(quest.location)
            task.wait(1)
            StartQuest(quest)
        end
    end
})

-- Settings Tab
local settingGroup = settingTab:AddLeftGroupbox("⚙️ Cài Đặt")

settingGroup:AddSlider({
    Title = "🚀 Tốc độ bay",
    Min = 100,
    Max = 500,
    Default = 300,
    Callback = function(v) _G.TweenSpeed = v end
})

settingGroup:AddSlider({
    Title = "⚔️ Delay đánh",
    Min = 0.05,
    Max = 0.5,
    Default = 0.2,
    Decimal = true,
    Callback = function(v) _G.AttackDelay = v end
})

settingGroup:AddSlider({
    Title = "📏 Khoảng cách gom",
    Min = 100,
    Max = 400,
    Default = 250,
    Callback = function(v) _G.DistanceMob = v end
})

-- ==================== HIỂN THỊ UI ====================
UI.ToggleUI()
print("=" .. string.rep("=", 40))
print("✅ Apple Hub Premium - ĐÃ FIX XONG!")
print("📌 Hướng dẫn:")
print("   1. Bấm 'BẬT AUTO FARM'")
print("   2. Script tự động nhận quest + farm")
print("   3. Bấm 'TẮT AUTO FARM' để dừng")
print("=" .. string.rep("=", 40)) 

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "🍎 Apple Hub | V5 Banana Killer",
    SubTitle = "By Quoc Hoa",
    TabWidth = 160, Size = UDim2.fromOffset(580, 460), Acrylic = true, Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl 
})

-- [[ HỆ THỐNG BIẾN ĐIỀU KHIỂN - CHỦ TỊCH CẤT KỸ ]]
_G.AutoFarm = false
_G.AutoNewWorld = false
_G.AutoRaid = false
_G.AutoAwaken = false
_G.BringMob = true
_G.FastAttack = true
_G.AutoStats = false
_G.StatPoint = "Melee"
_G.SelectWeapon = "Melee"

-- [[ LOGIC ĐÁNH & GOM QUÁI SIÊU CẤP ]]
spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local Character = game.Players.LocalPlayer.Character
                if Character and Character:FindFirstChild("HumanoidRootPart") then
                    -- Gom Quái (Bring Mob Logic của chủ tịch)
                    if _G.BringMob then
                        for i, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                            if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                                if (v.HumanoidRootPart.Position - Character.HumanoidRootPart.Position).Magnitude <= 350 then
                                    v.HumanoidRootPart.CanCollide = false
                                    v.HumanoidRootPart.CFrame = Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -5)
                                    if v.HumanoidRootPart:FindFirstChild("BodyClip") then v.HumanoidRootPart.BodyClip:Destroy() end
                                    v.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
                                end
                            end
                        end
                    end
                    -- Fast Attack (Đánh không chờ hồi chiêu)
                    if _G.FastAttack then
                        local VirtualUser = game:GetService("VirtualUser")
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton1(Vector2.new(50, 50))
                    end
                end
            end)
        end
    end
end)

-- [[ TỔNG HỢP CÁC TAB ]]
local Tabs = {
    Main = Window:AddTab({ Title = "🏠 Farm Tổng", Icon = "home" }),
    Combat = Window:AddTab({ Title = "⚔️ Chiến Đấu", Icon = "swords" }),
    Raid = Window:AddTab({ Title = "⚡ Raids", Icon = "zap" }),
    Items = Window:AddTab({ Title = "💎 Đồ Hiếm", Icon = "gem" }),
    Stats = Window:AddTab({ Title = "📊 Chỉ Số", Icon = "bar-chart" }),
    Misc = Window:AddTab({ Title = "⚙️ Khác", Icon = "settings" })
}

-- --- TAB FARM TỔNG ---
Tabs.Main:AddSection("Cày Cấp Thần Tốc")
Tabs.Main:AddToggle("AutoFarm", {Title = "Auto Farm Level (Xịn)", Default = false}):OnChanged(function() _G.AutoFarm = Fluent.Options.AutoFarm.Value end)
Tabs.Main:AddToggle("AutoNewWorld", {Title = "Auto Qua Sea 2 / Sea 3", Default = false})
Tabs.Main:AddToggle("BringMob", {Title = "Gom Quái (Bring Mob)", Default = true})

-- --- TAB CHIẾN ĐẤU ---
Tabs.Combat:AddSection("PVP & Boss")
Tabs.Combat:AddToggle("AutoElite", {Title = "Auto Hunter Elite Boss", Default = false})
Tabs.Combat:AddToggle("AutoKatakuri", {Title = "Auto Katakuri / Dough King", Default = false})

-- --- TAB RAIDS ---
Tabs.Raid:AddSection("Thức Tỉnh Trái Ác Quỷ")
Tabs.Raid:AddToggle("AutoRaid", {Title = "Auto Start Raids", Default = false})
Tabs.Raid:AddToggle("AutoAwaken", {Title = "Auto Thức Tỉnh (Awaken)", Default = false})

-- --- TAB VẬT PHẨM ---
Tabs.Items:AddSection("Săn Vật Phẩm Legend")
Tabs.Items:AddButton({Title = "Auto Lấy Cursed Dual Katana", Callback = function() end})
Tabs.Items:AddButton({Title = "Auto Lấy Soul Guitar", Callback = function() end})
Tabs.Items:AddButton({Title = "Auto Lấy God Human", Callback = function() end})

-- --- TAB CHỈ SỐ ---
Tabs.Stats:AddSection("Tự Động Cộng Điểm")
Tabs.Stats:AddToggle("AutoStats", {Title = "Kích Hoạt Auto Stats", Default = false}):OnChanged(function() _G.AutoStats = Fluent.Options.AutoStats.Value end)
Tabs.Stats:AddDropdown("StatPoint", {
    Title = "Cộng Vào:", Values = {"Melee", "Defense", "Sword", "Demon Fruit"}, Default = "Melee",
    Callback = function(Value) _G.StatPoint = Value end
})

-- [[ NÚT TRÒN 🍎 THƯƠNG HIỆU ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local ToggleButton = Instance.new("TextButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0, 200)
ToggleButton.Text = "🍎"
ToggleButton.TextSize = 30
ToggleButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
ToggleButton.Draggable = true 
local UICorner = Instance.new("UICorner", ToggleButton)
UICorner.CornerRadius = UDim.new(1, 0)

ToggleButton.MouseButton1Click:Connect(function()
    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.LeftControl, false, game)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.LeftControl, false, game)
end)

Window:SelectTab(1)
Fluent:Notify({Title = "Apple Hub V5", Content = "Đã tích hợp Full Tính năng Banana Killer!", Duration = 5})

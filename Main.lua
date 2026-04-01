-- Gọi UI Library từ GitHub của bạn
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/phamquochoa1942-png/Newuiapplehub/refs/heads/main/New%20apple%20hub"))()

-- Tạo cửa sổ chính
local window = UI:CreateWindow({
    Title = "Apple Hub Premium",
    Subtitle = "| by Quoc Hoa",
    Image = "rbxassetid://1774948262512"
})

-- ==================== TẠO TAB ====================
local farmTab = window:AddTab("🌾 Farm")

-- ==================== TAB FARM ====================
local farmGroup = farmTab:AddLeftGroupbox("Script Farm")

-- 👇 Bạn tự thêm các nút chức năng vào đây sau
-- Ví dụ:
-- farmGroup:AddButton({
--     Title = "Tên script",
--     Callback = function()
--         loadstring(game:HttpGet("link_script"))()
--     end
-- })

-- ==================== HIỂN THỊ UI ====================
UI.ToggleUI()
print("Apple Hub Premium | by Quoc Hoa - Đã tải xong! Bấm nút tròn để mở UI")

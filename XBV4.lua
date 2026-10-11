-- 第1段
-- 小丙脚本 · 优雅横向 UI 框架（升级版）
local Players           = game:GetService("Players")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")
local LocalPlayer       = Players.LocalPlayer

-- 配色：深色玻璃质感 + 蓝紫渐变强调
local Theme = {
    Background   = Color3.fromRGB(18, 18, 26),
    Background2  = Color3.fromRGB(24, 24, 34),
    TitleBar     = Color3.fromRGB(26, 26, 38),
    TabBar       = Color3.fromRGB(22, 22, 32),
    TabActive    = Color3.fromRGB(52, 52, 78),
    TabIdle      = Color3.fromRGB(22, 22, 32),
    Text         = Color3.fromRGB(240, 240, 250),
    SubText      = Color3.fromRGB(150, 150, 172),
    Accent       = Color3.fromRGB(110, 140, 255),
    Accent2      = Color3.fromRGB(180, 110, 255),
    Button       = Color3.fromRGB(32, 32, 44),
    ButtonHover  = Color3.fromRGB(48, 48, 66),
    Stroke       = Color3.fromRGB(60, 60, 84),
    Close        = Color3.fromRGB(210, 70, 90),
    CloseHover   = Color3.fromRGB(235, 95, 115),
}-- 第2段
-- 获取一个能真正挂 ScreenGui 的父级
local function getGuiParent()
    if type(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and hui then
            local test = pcall(function()
                local t = Instance.new("ScreenGui")
                t.Parent = hui
                t:Destroy()
            end)
            if test then return hui end
        end
    end
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    if ok and core then
        local test = pcall(function()
            local t = Instance.new("ScreenGui")
            t.Parent = core
            t:Destroy()
        end)
        if test then return core end
    end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local guiParent = getGuiParent()
local old = guiParent:FindFirstChild("XB_UI")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XB_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999
ScreenGui.Parent = guiParent

-- 主窗口
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.Size = UDim2.new(0, 640, 0, 400)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.Active = true
Main.ClipsDescendants = true
Main.Parent = ScreenGui

local mainGradient = Instance.new("UIGradient")
mainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Theme.Background),
    ColorSequenceKeypoint.new(1, Theme.Background2),
})
mainGradient.Rotation = 135
mainGradient.Parent = Main

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 14)
mainCorner.Parent = Main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Theme.Stroke
mainStroke.Thickness = 1
mainStroke.Transparency = 0.2
mainStroke.Parent = Main-- 第3段
-- 标题栏（可拖动）
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 42)
TitleBar.BackgroundColor3 = Theme.TitleBar
TitleBar.BackgroundTransparency = 0.15
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 14)
titleCorner.Parent = TitleBar

-- 底部补丁，让标题栏下沿是直角
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 14)
titleFix.Position = UDim2.new(0, 0, 1, -14)
titleFix.BackgroundColor3 = Theme.TitleBar
titleFix.BackgroundTransparency = 0.15
titleFix.BorderSizePixel = 0
titleFix.Parent = TitleBar

-- 标题左边的小色块（装饰）
local TitleDot = Instance.new("Frame")
TitleDot.Size = UDim2.new(0, 10, 0, 10)
TitleDot.Position = UDim2.new(0, 16, 0.5, -5)
TitleDot.BackgroundColor3 = Theme.Accent
TitleDot.BorderSizePixel = 0
TitleDot.Parent = TitleBar

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = TitleDot

local dotGradient = Instance.new("UIGradient")
dotGradient.Color = ColorSequence.new(Theme.Accent, Theme.Accent2)
dotGradient.Parent = TitleDot

-- 标题文字
local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -120, 1, 0)
TitleText.Position = UDim2.new(0, 34, 0, 0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "小丙脚本"
TitleText.TextColor3 = Theme.Text
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 15
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 2
TitleText.Parent = TitleBar-- 第4段
-- 只保留一个关闭按钮
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -14)
CloseBtn.BackgroundColor3 = Theme.Close
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 3
CloseBtn.Parent = TitleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Theme.CloseHover
    }):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Theme.Close
    }):Play()
end)-- 第5段
-- 悬浮小图标（可拖动）
local OpenBtn = Instance.new("TextButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 52, 0, 52)
OpenBtn.Position = UDim2.new(0, 20, 0.5, -26)
OpenBtn.BackgroundColor3 = Theme.Accent
OpenBtn.BorderSizePixel = 0
OpenBtn.Text = "小丙"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 13
OpenBtn.AutoButtonColor = false
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Parent = ScreenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = OpenBtn

local openGradient = Instance.new("UIGradient")
openGradient.Color = ColorSequence.new(Theme.Accent, Theme.Accent2)
openGradient.Rotation = 45
openGradient.Parent = OpenBtn

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(255, 255, 255)
openStroke.Thickness = 1
openStroke.Transparency = 0.7
openStroke.Parent = OpenBtn

-- 悬浮图标的拖动逻辑
local iconDragging, iconStart, iconStartPos
local iconMoved = false

OpenBtn.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    iconDragging = true
    iconMoved = false
    iconStart = input.Position
    iconStartPos = OpenBtn.Position

    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            iconDragging = false
        end
    end)
end)

UserInputService.InputChanged:Connect(function(input)
    if not iconDragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
    and input.UserInputType ~= Enum.UserInputType.Touch then return end

    local delta = input.Position - iconStart
    if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
        iconMoved = true
    end
    OpenBtn.Position = UDim2.new(
        iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X,
        iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y
    )
end)

-- 点击（非拖动）才打开窗口
OpenBtn.MouseButton1Click:Connect(function()
    if iconMoved then return end
    Main.Visible = true
    OpenBtn.Visible = false
end)

-- 关闭按钮：隐藏窗口，显示图标
CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)-- 第6段
-- 主窗口拖动
local dragging, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    if input.Target and input.Target:IsA("TextButton") then return end

    dragging = true
    dragStart = input.Position
    startPos = Main.Position

    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
        end
    end)
end)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement
    and input.UserInputType ~= Enum.UserInputType.Touch then return end
    local delta = input.Position - dragStart
    Main.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end)-- 第7段
-- 标签栏
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Position = UDim2.new(0, 0, 0, 42)
TabBar.Size = UDim2.new(1, 0, 0, 42)
TabBar.BackgroundColor3 = Theme.TabBar
TabBar.BackgroundTransparency = 0.3
TabBar.BorderSizePixel = 0
TabBar.Parent = Main

local tabBarLayout = Instance.new("UIListLayout")
tabBarLayout.FillDirection = Enum.FillDirection.Horizontal
tabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabBarLayout.Padding = UDim.new(0, 4)
tabBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
tabBarLayout.Parent = TabBar

local tabBarPad = Instance.new("UIPadding")
tabBarPad.PaddingLeft = UDim.new(0, 10)
tabBarPad.PaddingRight = UDim.new(0, 10)
tabBarPad.Parent = TabBar

-- 标签栏底部细分割线
local tabDivider = Instance.new("Frame")
tabDivider.Size = UDim2.new(1, 0, 0, 1)
tabDivider.Position = UDim2.new(0, 0, 1, -1)
tabDivider.BackgroundColor3 = Theme.Stroke
tabDivider.BackgroundTransparency = 0.5
tabDivider.BorderSizePixel = 0
tabDivider.Parent = TabBar

-- 内容容器
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Position = UDim2.new(0, 0, 0, 84)
Content.Size = UDim2.new(1, 0, 1, -84)
Content.BackgroundTransparency = 1
Content.ClipsDescendants = true
Content.Parent = Main-- 第8段
-- 组件工厂：标签 / 按钮 / 段落
local function makeLabel(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 0, 22)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Theme.SubText
    lbl.Font = Enum.Font.Gotham
    lbl.TextSize = 14
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

local function makeButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Theme.Button
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    local s = Instance.new("UIStroke")
    s.Color = Theme.Stroke
    s.Thickness = 1
    s.Transparency = 0.5
    s.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Theme.ButtonHover
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = Theme.Button
        }):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        if callback then
            local ok, err = pcall(callback)
            if not ok then warn("[小丙脚本] 按钮回调出错: " .. tostring(err)) end
        end
    end)
    return btn
end

local function makeParagraph(parent, title, body)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 56)
    frame.BackgroundColor3 = Theme.Button
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = frame

    local s = Instance.new("UIStroke")
    s.Color = Theme.Stroke
    s.Thickness = 1
    s.Transparency = 0.5
    s.Parent = frame

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, -20, 0, 24)
    t.Position = UDim2.new(0, 12, 0, 6)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = Theme.Text
    t.Font = Enum.Font.GothamMedium
    t.TextSize = 14
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = frame

    local b = Instance.new("TextLabel")
    b.Size = UDim2.new(1, -20, 0, 20)
    b.Position = UDim2.new(0, 12, 0, 30)
    b.BackgroundTransparency = 1
    b.Text = body
    b.TextColor3 = Theme.SubText
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = frame

    return frame
end-- 第9段
-- 标签页系统（带滑动切换动画）
local Tabs = {}
local CurrentTab = nil

local function SelectTab(name)
    if CurrentTab == name then return end
    for n, tab in pairs(Tabs) do
        local active = (n == name)
        tab.Page.Visible = active

        TweenService:Create(tab.Button, TweenInfo.new(0.2), {
            BackgroundColor3 = active and Theme.TabActive or Theme.TabIdle
        }):Play()
        tab.Button.TextColor3 = active and Theme.Text or Theme.SubText

        -- 页面从右侧滑入
        if active then
            tab.Page.Position = UDim2.new(0, 30, 0, 0)
            TweenService:Create(tab.Page, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, 0)
            }):Play()
        end
    end
    CurrentTab = name
end

local Window = {}

function Window:MakeTab(config)
    config = config or {}
    local name = config.Name or "标签"

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 112, 0, 30)
    btn.BackgroundColor3 = Theme.TabIdle
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Theme.SubText
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Parent = TabBar

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 8)
    bc.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Position = UDim2.new(0, 0, 0, 0)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Theme.Accent
    page.ScrollBarImageTransparency = 0.4
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = Content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft = UDim.new(0, 16)
    pad.PaddingRight = UDim.new(0, 16)
    pad.PaddingTop = UDim.new(0, 14)
    pad.PaddingBottom = UDim.new(0, 14)
    pad.Parent = page

    local tab = { Name = name, Button = btn, Page = page }

    function tab:AddLabel(text) return makeLabel(self.Page, text) end
    function tab:AddButton(text, callback) return makeButton(self.Page, text, callback) end
    function tab:AddParagraph(title, body) return makeParagraph(self.Page, title, body) end

    Tabs[name] = tab
    btn.MouseButton1Click:Connect(function() SelectTab(name) end)
    if not CurrentTab then SelectTab(name) end
    return tab
end-- 第9.5段：Highlight 透视核心（来自恐脚本通用）
local espEnabled = false

local function enableESP(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    if not char:FindFirstChild("EspHighlight") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "EspHighlight"
        highlight.Parent = char
        highlight.FillTransparency = 1
        highlight.OutlineColor = Color3.new(1, 0, 0)
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    end
end

local function disableESP(player)
    local char = player.Character
    if char and char:FindFirstChild("EspHighlight") then
        char.EspHighlight:Destroy()
    end
end

RunService.RenderStepped:Connect(function()
    if not espEnabled then return end
    for _, player in ipairs(Players:GetPlayers()) do
        enableESP(player)
    end
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(char)
        char:WaitForChild("HumanoidRootPart")
        if espEnabled then enableESP(player) end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    disableESP(player)
end)-- 第10段
-- 信息页
local TabInfo = Window:MakeTab({ Name = "信息" })
TabInfo:AddParagraph("作者", "小丙")
TabInfo:AddParagraph("当前玩家", LocalPlayer.Name)
TabInfo:AddParagraph("版本", "优雅 UI · 升级版")
TabInfo:AddButton("示例按钮", function()
    print("[小丙脚本] 示例按钮被点击")
end)

-- 功能一（透视）
local TabFeature1 = Window:MakeTab({ Name = "功能一" })
local espBtn
espBtn = TabFeature1:AddButton("透视：关", function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "透视：开" or "透视：关"
    for _, p in ipairs(Players:GetPlayers()) do
        if espEnabled then
            enableESP(p)
        else
            disableESP(p)
        end
    end
end)

-- 功能二
local TabFeature2 = Window:MakeTab({ Name = "功能二" })
TabFeature2:AddLabel("这里是空的")

-- 设置页
local TabSettings = Window:MakeTab({ Name = "设置" })
TabSettings:AddButton("隐藏界面", function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

print("[小丙脚本] 优雅 UI 已加载")
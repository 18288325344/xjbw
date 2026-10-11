-- 第1段
-- 小丙脚本 · 横向 UI 框架（无功能）
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local Theme = {
    Background = Color3.fromRGB(22,22,28),
    TitleBar = Color3.fromRGB(30,30,38),
    TabBar = Color3.fromRGB(26,26,33),
    TabActive = Color3.fromRGB(45,45,58),
    TabIdle = Color3.fromRGB(26,26,33),
    Text = Color3.fromRGB(235,235,245),
    SubText = Color3.fromRGB(145,145,162),
    Accent = Color3.fromRGB(88,130,255),
    Button = Color3.fromRGB(38,38,48),
    ButtonHover = Color3.fromRGB(52,52,66),
}-- 第2段
local function getGuiParent()
    if type(gethui) == "function" then
        local ok, hui = pcall(gethui)
        if ok and hui then return hui end
    end
    local ok, core = pcall(function() return game:GetService("CoreGui") end)
    if ok and core then return core end
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

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.AnchorPoint = Vector2.new(0.5,0.5)
Main.Position = UDim2.new(0.5,0,0.5,0)
Main.Size = UDim2.new(0,620,0,380)
Main.BackgroundColor3 = Theme.Background
Main.BorderSizePixel = 0
Main.Active = true
Main.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0,10)
mainCorner.Parent = Main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(58,58,74)
mainStroke.Thickness = 1
mainStroke.Parent = Main-- 第3段
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1,0,0,38)
TitleBar.BackgroundColor3 = Theme.TitleBar
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0,10)
titleCorner.Parent = TitleBar

local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1,0,0,12)
titleFix.Position = UDim2.new(0,0,1,-12)
titleFix.BackgroundColor3 = Theme.TitleBar
titleFix.BorderSizePixel = 0
titleFix.Parent = TitleBar

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1,-90,1,0)
TitleText.Position = UDim2.new(0,14,0,0)
TitleText.BackgroundTransparency = 1
TitleText.Text = "小丙脚本"
TitleText.TextColor3 = Theme.Text
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 15
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.ZIndex = 2
TitleText.Parent = TitleBar-- 第4段
local function makeTitleButton(text, color, offsetX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,26,0,26)
    btn.Position = UDim2.new(1,offsetX,0.5,-13)
    btn.BackgroundColor3 = color
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.ZIndex = 3
    btn.Parent = TitleBar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,6)
    c.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3 = color:Lerp(Color3.new(1,1,1),0.18)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3 = color}):Play()
    end)
    return btn
end

local CloseBtn = makeTitleButton("×", Color3.fromRGB(196,62,62), -34)
local MinimizeBtn = makeTitleButton("—", Color3.fromRGB(70,70,88), -66)-- 第5段
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0,48,0,48)
OpenBtn.Position = UDim2.new(0,16,0.5,-24)
OpenBtn.BackgroundColor3 = Theme.Accent
OpenBtn.BorderSizePixel = 0
OpenBtn.Text = "小丙"
OpenBtn.TextColor3 = Color3.fromRGB(255,255,255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 13
OpenBtn.AutoButtonColor = false
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(0,24)
openCorner.Parent = OpenBtn

OpenBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    OpenBtn.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

MinimizeBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    OpenBtn.Visible = true
end)-- 第6段
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
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Position = UDim2.new(0,0,0,38)
TabBar.Size = UDim2.new(1,0,0,38)
TabBar.BackgroundColor3 = Theme.TabBar
TabBar.BorderSizePixel = 0
TabBar.Parent = Main

local tabBarLayout = Instance.new("UIListLayout")
tabBarLayout.FillDirection = Enum.FillDirection.Horizontal
tabBarLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabBarLayout.Padding = UDim.new(0,2)
tabBarLayout.Parent = TabBar

local tabBarPad = Instance.new("UIPadding")
tabBarPad.PaddingLeft = UDim.new(0,8)
tabBarPad.PaddingRight = UDim.new(0,8)
tabBarPad.Parent = TabBar

local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Position = UDim2.new(0,0,0,76)
Content.Size = UDim2.new(1,0,1,-76)
Content.BackgroundTransparency = 1
Content.Parent = Main-- 第8段
local function makeLabel(parent, text)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1,0,0,22)
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
    btn.Size = UDim2.new(1,0,0,34)
    btn.BackgroundColor3 = Theme.Button
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Theme.Text
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,6)
    c.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3 = Theme.ButtonHover}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn,TweenInfo.new(0.12),{BackgroundColor3 = Theme.Button}):Play()
    end)

    btn.MouseButton1Click:Connect(function()
        if callback then
            local ok, err = pcall(callback)
            if not ok then warn("[小丙脚本] 按钮回调出错: "..tostring(err)) end
        end
    end)
    return btn
end

local function makeParagraph(parent, title, body)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1,0,0,52)
    frame.BackgroundColor3 = Theme.Button
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0,6)
    c.Parent = frame

    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1,-20,0,22)
    t.Position = UDim2.new(0,10,0,4)
    t.BackgroundTransparency = 1
    t.Text = title
    t.TextColor3 = Theme.Text
    t.Font = Enum.Font.GothamMedium
    t.TextSize = 14
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.Parent = frame

    local b = Instance.new("TextLabel")
    b.Size = UDim2.new(1,-20,0,20)
    b.Position = UDim2.new(0,10,0,26)
    b.BackgroundTransparency = 1
    b.Text = body
    b.TextColor3 = Theme.SubText
    b.Font = Enum.Font.Gotham
    b.TextSize = 13
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.Parent = frame

    return frame
end-- 第9段
local Tabs = {}
local CurrentTab = nil

local function SelectTab(name)
    if CurrentTab == name then return end
    for n, tab in pairs(Tabs) do
        local active = (n == name)
        tab.Page.Visible = active
        TweenService:Create(tab.Button,TweenInfo.new(0.15),{
            BackgroundColor3 = active and Theme.TabActive or Theme.TabIdle
        }):Play()
        tab.Button.TextColor3 = active and Theme.Text or Theme.SubText
    end
    CurrentTab = name
end

local Window = {}

function Window:MakeTab(config)
    config = config or {}
    local name = config.Name or "标签"

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,108,1,-8)
    btn.Position = UDim2.new(0,0,0,4)
    btn.BackgroundColor3 = Theme.TabIdle
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.TextColor3 = Theme.SubText
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Parent = TabBar

    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0,6)
    bc.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Position = UDim2.new(0,12,0,10)
    page.Size = UDim2.new(1,-24,1,-20)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 4
    page.ScrollBarImageColor3 = Color3.fromRGB(70,70,88)
    page.CanvasSize = UDim2.new(0,0,0,0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Visible = false
    page.Parent = Content

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0,8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local pad = Instance.new("UIPadding")
    pad.PaddingRight = UDim.new(0,8)
    pad.PaddingBottom = UDim.new(0,12)
    pad.Parent = page

    local tab = { Name = name, Button = btn, Page = page }

    function tab:AddLabel(text) return makeLabel(self.Page, text) end
    function tab:AddButton(text, callback) return makeButton(self.Page, text, callback) end
    function tab:AddParagraph(title, body) return makeParagraph(self.Page, title, body) end

    Tabs[name] = tab
    btn.MouseButton1Click:Connect(function() SelectTab(name) end)
    if not CurrentTab then SelectTab(name) end
    return tab
end-- 第10段
local TabInfo = Window:MakeTab({ Name = "信息" })
TabInfo:AddParagraph("作者", "小丙")
TabInfo:AddParagraph("当前玩家", LocalPlayer.Name)
TabInfo:AddParagraph("版本", "UI 框架 · 空白版")
TabInfo:AddButton("示例按钮", function()
    print("[小丙脚本] 示例按钮被点击")
end)

local TabFeature1 = Window:MakeTab({ Name = "功能一" })
TabFeature1:AddLabel("这里是空的，往里面加组件吧")

local TabFeature2 = Window:MakeTab({ Name = "功能二" })
TabFeature2:AddLabel("这里是空的")

local TabSettings = Window:MakeTab({ Name = "设置" })
TabSettings:AddButton("隐藏界面", function()
    Main.Visible = false
    OpenBtn.Visible = true
end)

print("[小丙脚本] UI 框架已加载")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local oldGui = CoreGui:FindFirstChild("LegenlyTrollHub_Ultimate") or LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("LegenlyTrollHub_Ultimate")
if oldGui then 
    oldGui:Destroy() 
end

if _G.LegenlyConnections then
    for _, conn in ipairs(_G.LegenlyConnections) do
        if conn then pcall(function() conn:Disconnect() end) end
    end
end
_G.LegenlyConnections = {}

local Themes = {
    Red = {Accent = Color3.fromRGB(255, 60, 60), Name = "Ruby Red"},
    Blue = {Accent = Color3.fromRGB(60, 150, 255), Name = "Deep Blue"},
    Purple = {Accent = Color3.fromRGB(180, 60, 255), Name = "Amethyst Purple"},
    Green = {Accent = Color3.fromRGB(60, 255, 120), Name = "Acid Green"},
    Gold = {Accent = Color3.fromRGB(255, 190, 60), Name = "Luxury Gold"}
}

local CurrentTheme = Themes.Red
local RecolorQueue = {}

local function RegisterForRecolor(element, property, checkActiveState)
    table.insert(RecolorQueue, function(newColor)
        if not element or not element.Parent then
            return false
        end
        pcall(function()
            if checkActiveState then
                if element:GetAttribute("IsActiveTab") then
                    element[property] = newColor
                end
            else
                element[property] = newColor
            end
        end)
        return true
    end)
end

local function ApplyTheme(themeKey)
    local theme = Themes[themeKey]
    if theme then
        CurrentTheme = theme
        local cleanQueue = {}
        for _, recolorFn in ipairs(RecolorQueue) do
            local success, keep = pcall(recolorFn, theme.Accent)
            if success and keep ~= false then
                table.insert(cleanQueue, recolorFn)
            end
        end
        RecolorQueue = cleanQueue
    end
end

local TrollState = {
    EgorSpeed = false,
    FakeLagFPS = false,
    LagFPSValue = 10,
    FakeLagNet = false,
    Spin = false,
    SpinSpeed = 10,
    SelectedTarget = nil,
    AttachTarget = nil,
    AttachMode = "",
    FlingActive = false,
    OriginalShoulderC0 = nil,
    ActiveFX = {},
    FreezeTarget = nil,
    FreezePos = nil,
    SpinTarget = nil,
    KillAura = false,
    KillAuraRange = 15,
    ChatSpam = false,
    ChatSpamText = "Legenly on top!",
    GodMode = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    LoopKill = false,
    LoopKillTarget = nil,
    RageQuitActive = false,
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LegenlyTrollHub_Ultimate"
ScreenGui.ResetOnSpawn = false

local parentSuccess = pcall(function() 
    ScreenGui.Parent = CoreGui 
end)
if not parentSuccess or not ScreenGui.Parent then 
    pcall(function()
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") 
    end)
end

local function Notify(title, message, color)
    color = color or CurrentTheme.Accent
    local NotifFrame = Instance.new("Frame", ScreenGui)
    NotifFrame.Size = UDim2.new(0, 240, 0, 65)
    NotifFrame.Position = UDim2.new(1, -250, 1, -75)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    NotifFrame.BorderSizePixel = 0
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 8)

    local AccentLine = Instance.new("Frame", NotifFrame)
    AccentLine.Size = UDim2.new(0, 4, 1, 0)
    AccentLine.BorderSizePixel = 0
    AccentLine.BackgroundColor3 = color
    Instance.new("UICorner", AccentLine).CornerRadius = UDim.new(0, 8)
    RegisterForRecolor(AccentLine, "BackgroundColor3")

    local TxtTitle = Instance.new("TextLabel", NotifFrame)
    TxtTitle.BackgroundTransparency = 1
    TxtTitle.Position = UDim2.new(0, 15, 0, 8)
    TxtTitle.Size = UDim2.new(1, -20, 0, 20)
    TxtTitle.Font = Enum.Font.GothamBold
    TxtTitle.Text = title
    TxtTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    TxtTitle.TextSize = 13
    TxtTitle.TextXAlignment = Enum.TextXAlignment.Left

    local TxtMsg = Instance.new("TextLabel", NotifFrame)
    TxtMsg.BackgroundTransparency = 1
    TxtMsg.Position = UDim2.new(0, 15, 0, 28)
    TxtMsg.Size = UDim2.new(1, -20, 0, 30)
    TxtMsg.Font = Enum.Font.Gotham
    TxtMsg.Text = message
    TxtMsg.TextColor3 = Color3.fromRGB(180, 180, 180)
    TxtMsg.TextSize = 11
    TxtMsg.TextWrapped = true
    TxtMsg.TextXAlignment = Enum.TextXAlignment.Left

    local activeNotifs = 0
    for _, child in pairs(ScreenGui:GetChildren()) do
        if child.Name == "Frame" and child ~= NotifFrame then
            activeNotifs = activeNotifs + 1
            child:TweenPosition(UDim2.new(1, -250, 1, -75 - (activeNotifs * 75)), "Out", "Quad", 0.25, true)
        end
    end

    task.delay(3, function()
        for i = 0, 10 do
            if not NotifFrame or not NotifFrame.Parent then break end
            local transp = i/10
            NotifFrame.BackgroundTransparency = transp
            TxtTitle.TextTransparency = transp
            TxtMsg.TextTransparency = transp
            AccentLine.BackgroundTransparency = transp
            task.wait(0.02)
        end
        if NotifFrame and NotifFrame.Parent then NotifFrame:Destroy() end
    end)
end

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.ClipsDescendants = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Name = "TitleBar"
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BorderSizePixel = 0

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.Size = UDim2.new(1, -60, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.Text = "HUB - Troll & Universal | By Legenly"
TitleText.TextColor3 = CurrentTheme.Accent
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
RegisterForRecolor(TitleText, "TextColor3")

local MinimizeBtn = Instance.new("TextButton", TitleBar)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Position = UDim2.new(1, -35, 0, 0)
MinimizeBtn.Size = UDim2.new(0, 35, 1, 0)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20

local IslandFrame = Instance.new("Frame", ScreenGui)
IslandFrame.Name = "IslandFrame"
IslandFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
IslandFrame.Position = UDim2.new(0.5, -55, 0, 20)
IslandFrame.Size = UDim2.new(0, 110, 0, 36)
IslandFrame.Visible = false
IslandFrame.BorderSizePixel = 0
Instance.new("UICorner", IslandFrame).CornerRadius = UDim.new(1, 0)

local IslandClicker = Instance.new("TextButton", IslandFrame)
IslandClicker.Size = UDim2.new(1, 0, 1, 0)
IslandClicker.BackgroundTransparency = 1
IslandClicker.Text = ""

local IslandText = Instance.new("TextLabel", IslandFrame)
IslandText.BackgroundTransparency = 1
IslandText.Position = UDim2.new(0, 15, 0, 0)
IslandText.Size = UDim2.new(1, -35, 1, 0)
IslandText.Font = Enum.Font.GothamBold
IslandText.Text = "Troll"
IslandText.TextColor3 = Color3.fromRGB(255, 255, 255)
IslandText.TextSize = 14
IslandText.TextXAlignment = Enum.TextXAlignment.Left

local IslandDot = Instance.new("Frame", IslandFrame)
IslandDot.Size = UDim2.new(0, 6, 0, 6)
IslandDot.Position = UDim2.new(1, -18, 0.5, -3)
IslandDot.BorderSizePixel = 0
IslandDot.BackgroundColor3 = CurrentTheme.Accent
Instance.new("UICorner", IslandDot).CornerRadius = UDim.new(1, 0)
RegisterForRecolor(IslandDot, "BackgroundColor3")

local function MakeDraggable(dragArea, frameToMove)
    local dragging, dragStart, startPos
    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frameToMove.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frameToMove.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X, 
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end

MakeDraggable(TitleBar, MainFrame)
MakeDraggable(IslandClicker, IslandFrame)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    IslandFrame.Visible = true
    Notify("Интерфейс свернут", "Нажми на островок 'Troll', чтобы развернуть.", CurrentTheme.Accent)
end)
IslandClicker.MouseButton1Click:Connect(function()
    IslandFrame.Visible = false
    MainFrame.Visible = true
end)

local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Name = "Sidebar"
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.Size = UDim2.new(0, 140, 1, -35)
Sidebar.BorderSizePixel = 0

local Pages = Instance.new("Frame", MainFrame)
Pages.Name = "Pages"
Pages.BackgroundTransparency = 1
Pages.Position = UDim2.new(0, 150, 0, 45)
Pages.Size = UDim2.new(1, -160, 1, -55)

local MainPage = Instance.new("ScrollingFrame", Pages)
MainPage.Name = "MainPage"
MainPage.BackgroundTransparency = 1
MainPage.Size = UDim2.new(1, 0, 1, 0)
MainPage.ScrollBarThickness = 4
MainPage.BorderSizePixel = 0

local InfoPage = Instance.new("ScrollingFrame", Pages)
InfoPage.Name = "InfoPage"
InfoPage.BackgroundTransparency = 1
InfoPage.Size = UDim2.new(1, 0, 1, 0)
InfoPage.ScrollBarThickness = 4
InfoPage.Visible = false
InfoPage.BorderSizePixel = 0

local UIListLayoutMain = Instance.new("UIListLayout", MainPage)
UIListLayoutMain.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutMain.Padding = UDim.new(0, 8)
UIListLayoutMain:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    MainPage.CanvasSize = UDim2.new(0, 0, 0, UIListLayoutMain.AbsoluteContentSize.Y + 20)
end)

local UIListLayoutInfo = Instance.new("UIListLayout", InfoPage)
UIListLayoutInfo.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayoutInfo.Padding = UDim.new(0, 8)
UIListLayoutInfo:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    InfoPage.CanvasSize = UDim2.new(0, 0, 0, UIListLayoutInfo.AbsoluteContentSize.Y + 20)
end)

local function CreateTabButton(name, targetPage, posY)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Btn.BorderSizePixel = 0
    Btn.Position = UDim2.new(0, 10, 0, posY)
    Btn.Size = UDim2.new(1, -20, 0, 35)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.Text = name
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.TextSize = 13
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn:SetAttribute("IsActiveTab", false)

    Btn.MouseButton1Click:Connect(function()
        MainPage.Visible = (targetPage == MainPage)
        InfoPage.Visible = (targetPage == InfoPage)
        for _, child in pairs(Sidebar:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
                child.TextColor3 = Color3.fromRGB(180, 180, 180)
                child:SetAttribute("IsActiveTab", false)
            end
        end
        Btn.BackgroundColor3 = CurrentTheme.Accent
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Btn:SetAttribute("IsActiveTab", true)
    end)

    RegisterForRecolor(Btn, "BackgroundColor3", true)
    return Btn
end

local TabMain = CreateTabButton("Main", MainPage, 15)
local TabInfo = CreateTabButton("Info", InfoPage, 60)
TabMain.BackgroundColor3 = CurrentTheme.Accent
TabMain.TextColor3 = Color3.fromRGB(255, 255, 255)
TabMain:SetAttribute("IsActiveTab", true)

local function CreateSection(parent, text)
    local Lbl = Instance.new("TextLabel", parent)
    Lbl.BackgroundTransparency = 1
    Lbl.Size = UDim2.new(1, 0, 0, 25)
    Lbl.Font = Enum.Font.GothamBold
    Lbl.Text = "- " .. text .. " -"
    Lbl.TextColor3 = CurrentTheme.Accent
    Lbl.TextSize = 13
    RegisterForRecolor(Lbl, "TextColor3")
end

local function CreateToggle(parent, text, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.BackgroundTransparency = 1
    Lbl.Position = UDim2.new(0, 10, 0, 0)
    Lbl.Size = UDim2.new(1, -50, 1, 0)
    Lbl.Font = Enum.Font.Gotham
    Lbl.Text = text
    Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local Btn = Instance.new("TextButton", Frame)
    Btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
    Btn.Position = UDim2.new(1, -35, 0.5, -10)
    Btn.Size = UDim2.new(0, 25, 0, 20)
    Btn.Text = ""
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    local state = false
    Btn.MouseButton1Click:Connect(function()
        state = not state
        Btn.BackgroundColor3 = state and CurrentTheme.Accent or Color3.fromRGB(45, 45, 50)
        callback(state)
    end)

    table.insert(RecolorQueue, function(newColor)
        if state then Btn.BackgroundColor3 = newColor end
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.BackgroundTransparency = 1
    Lbl.Position = UDim2.new(0, 10, 0, 5)
    Lbl.Size = UDim2.new(1, -20, 0, 20)
    Lbl.Font = Enum.Font.Gotham
    Lbl.Text = text .. ": " .. default
    Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local Bar = Instance.new("TextButton", Frame)
    Bar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Bar.Position = UDim2.new(0, 10, 0, 30)
    Bar.Size = UDim2.new(1, -20, 0, 10)
    Bar.Text = ""
    Bar.AutoButtonColor = false
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Bar)
    Fill.BackgroundColor3 = CurrentTheme.Accent
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)
    RegisterForRecolor(Fill, "BackgroundColor3")

    local isDragging = false
    
    local function UpdateSliderValue(input)
        local barWidth = Bar.AbsoluteSize.X
        if barWidth == 0 then barWidth = 1 end
        local pos = math.clamp(input.Position.X - Bar.AbsolutePosition.X, 0, barWidth)
        local percent = pos / barWidth
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        local value = math.floor(min + ((max - min) * percent))
        Lbl.Text = text .. ": " .. value
        callback(value)
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            isDragging = true 
            UpdateSliderValue(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            isDragging = false 
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSliderValue(input)
        end
    end)
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 13
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        Btn.BackgroundColor3 = CurrentTheme.Accent
        task.wait(0.12)
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        callback()
    end)
    return Btn
end

local function CreateTextBox(parent, placeholder, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Box = Instance.new("TextBox", Frame)
    Box.BackgroundTransparency = 1
    Box.Size = UDim2.new(1, -20, 1, 0)
    Box.Position = UDim2.new(0, 10, 0, 0)
    Box.Font = Enum.Font.Gotham
    Box.PlaceholderText = placeholder
    Box.Text = ""
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.TextSize = 12
    Box.TextXAlignment = Enum.TextXAlignment.Left

    Box.FocusLost:Connect(function() callback(Box.Text) end)
end

local function CreateInfoLabel(parent, text)
    local Lbl = Instance.new("TextLabel", parent)
    Lbl.BackgroundTransparency = 1
    Lbl.Size = UDim2.new(1, -10, 0, 20)
    Lbl.Font = Enum.Font.Gotham
    Lbl.Text = text
    Lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
    Lbl.TextSize = 13
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.TextWrapped = true
end

local DropdownFrame = nil

local function CreatePlayerDropdown(parent, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Size = UDim2.new(1, 0, 1, 0)
    MainBtn.Font = Enum.Font.GothamSemibold
    MainBtn.Text = "Выбрать игрока: (Никто)"
    MainBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    MainBtn.TextSize = 12

    MainBtn.MouseButton1Click:Connect(function()
        if DropdownFrame then DropdownFrame:Destroy() DropdownFrame = nil return end

        DropdownFrame = Instance.new("Frame", ScreenGui)
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        DropdownFrame.BorderSizePixel = 1
        DropdownFrame.BorderColor3 = CurrentTheme.Accent
        DropdownFrame.Size = UDim2.new(0, 200, 0, 150)
        
        local screenPos = MainBtn.AbsolutePosition
        DropdownFrame.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y + 38)
        Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 6)

        local Scroll = Instance.new("ScrollingFrame", DropdownFrame)
        Scroll.BackgroundTransparency = 1
        Scroll.Size = UDim2.new(1, 0, 1, 0)
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        Scroll.ScrollBarThickness = 4

        local ListLayout = Instance.new("UIListLayout", Scroll)
        ListLayout.Padding = UDim.new(0, 2)
        ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
        end)

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local PBtn = Instance.new("TextButton", Scroll)
                PBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                PBtn.BorderSizePixel = 0
                PBtn.Size = UDim2.new(1, 0, 0, 25)
                PBtn.Font = Enum.Font.Gotham
                PBtn.Text = player.DisplayName .. " (@" .. player.Name .. ")"
                PBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                PBtn.TextSize = 11

                PBtn.MouseButton1Click:Connect(function()
                    TrollState.SelectedTarget = player
                    MainBtn.Text = "Выбран: " .. player.DisplayName
                    DropdownFrame:Destroy()
                    DropdownFrame = nil
                    callback(player)
                end)
            end
        end
    end)
end

local ThemeDropdownFrame = nil

local function CreateThemeDropdown(parent)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Size = UDim2.new(1, 0, 1, 0)
    MainBtn.Font = Enum.Font.GothamBold
    MainBtn.Text = "Сменить тему хаба"
    MainBtn.TextColor3 = CurrentTheme.Accent
    MainBtn.TextSize = 12
    RegisterForRecolor(MainBtn, "TextColor3")

    MainBtn.MouseButton1Click:Connect(function()
        if ThemeDropdownFrame then ThemeDropdownFrame:Destroy() ThemeDropdownFrame = nil return end

        ThemeDropdownFrame = Instance.new("Frame", ScreenGui)
        ThemeDropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        ThemeDropdownFrame.BorderSizePixel = 1
        ThemeDropdownFrame.BorderColor3 = CurrentTheme.Accent
        ThemeDropdownFrame.Size = UDim2.new(0, 180, 0, 130)

        local screenPos = MainBtn.AbsolutePosition
        ThemeDropdownFrame.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y - 135)
        Instance.new("UICorner", ThemeDropdownFrame).CornerRadius = UDim.new(0, 6)

        local Scroll = Instance.new("ScrollingFrame", ThemeDropdownFrame)
        Scroll.BackgroundTransparency = 1
        Scroll.Size = UDim2.new(1, 0, 1, 0)
        Scroll.CanvasSize = UDim2.new(0, 0, 0, 150)
        Scroll.ScrollBarThickness = 4

        local ListLayout = Instance.new("UIListLayout", Scroll)
        ListLayout.Padding = UDim.new(0, 2)

        for key, theme in pairs(Themes) do
            local TBtn = Instance.new("TextButton", Scroll)
            TBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
            TBtn.BorderSizePixel = 0
            TBtn.Size = UDim2.new(1, 0, 0, 25)
            TBtn.Font = Enum.Font.GothamBold
            TBtn.Text = theme.Name
            TBtn.TextColor3 = theme.Accent
            TBtn.TextSize = 11

            TBtn.MouseButton1Click:Connect(function()
                ApplyTheme(key)
                Notify("Тема изменена", "Установлен цвет " .. theme.Name, theme.Accent)
                ThemeDropdownFrame:Destroy()
                ThemeDropdownFrame = nil
            end)
        end
    end)
end

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if DropdownFrame then
            local pos = input.Position
            local fPos = DropdownFrame.AbsolutePosition
            local fSize = DropdownFrame.AbsoluteSize
            if pos.X < fPos.X or pos.X > fPos.X + fSize.X or pos.Y < fPos.Y or pos.Y > fPos.Y + fSize.Y then
                DropdownFrame:Destroy()
                DropdownFrame = nil
            end
        end
        if ThemeDropdownFrame then
            local pos = input.Position
            local fPos = ThemeDropdownFrame.AbsolutePosition
            local fSize = ThemeDropdownFrame.AbsoluteSize
            if pos.X < fPos.X or pos.X > fPos.X + fSize.X or pos.Y < fPos.Y or pos.Y > fPos.Y + fSize.Y then
                ThemeDropdownFrame:Destroy()
                ThemeDropdownFrame = nil
            end
        end
    end
end)

local function ApplyEjaculationFX()
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local pe = Instance.new("ParticleEmitter")
        pe.Name = "SpermFX"
        pe.Texture = "rbxassetid://243132757"
        pe.Rate = 45
        pe.Speed = NumberRange.new(10, 20)
        pe.VelocitySpread = 35
        pe.Lifetime = NumberRange.new(0.5, 1.0)
        pe.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.45), NumberSequenceKeypoint.new(1, 0.05)})
        pe.EmissionDirection = Enum.NormalId.Front
        pe.Parent = hrp
        table.insert(TrollState.ActiveFX, pe)

        local sound = Instance.new("Sound")
        sound.Name = "SpermSound"
        sound.SoundId = "rbxassetid://9114223190"
        sound.Volume = 3.5
        sound.Looped = true
        sound.PlaybackSpeed = 1.05
        sound.Parent = hrp
        sound:Play()
        table.insert(TrollState.ActiveFX, sound)
    end)
end

local function UseWeaponOnTarget(targetChar)
    pcall(function()
        if not targetChar then return end
        local char = LocalPlayer.Character
        if not char then return end
        
        local tool = char:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        if tool then
            if tool.Parent ~= char then
                tool.Parent = char
            end
            
            local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
            if handle then
                local firetouch = firetouchinterest or (syn and syn.firetouchinterest)
                if firetouch then
                    firetouch(handle, targetChar:FindFirstChildWhichIsA("BasePart"), 0)
                    firetouch(handle, targetChar:FindFirstChildWhichIsA("BasePart"), 1)
                else
                    local rightGrip = char:FindFirstChild("RightGrip", true) or (char:FindFirstChild("Right Arm") and char["Right Arm"]:FindFirstChild("RightGrip")) or (char:FindFirstChild("RightHand") and char.RightHand:FindFirstChild("RightGrip"))
                    if rightGrip then
                        rightGrip:Destroy()
                    end
                    handle.CFrame = targetChar:GetPivot()
                end
            end
        end
    end)
end

local function StopAllActions()
    TrollState.AttachTarget = nil
    TrollState.AttachMode = ""
    TrollState.FlingActive = false
    TrollState.RageQuitActive = false

    for _, fx in ipairs(TrollState.ActiveFX) do
        if fx then pcall(function() fx:Destroy() end) end
    end
    TrollState.ActiveFX = {}

    pcall(function()
        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = hrp:FindFirstChild("FlyVelocity")
            local bg = hrp:FindFirstChild("FlyGyro")
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            
            for _, obj in ipairs(hrp:GetChildren()) do
                if obj.Name == "FlingVelocity" or obj.Name == "FlingAngular" or obj.Name == "FlingForce" or obj.Name == "ServerSpinForce" then
                    obj:Destroy()
                end
            end
        end
    end)

    pcall(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hum then 
            hum.PlatformStand = false 
            hum.AutoRotate = true
        end
        if hrp then
            hrp.Anchored = false
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
    end)

    pcall(function()
        local char = LocalPlayer.Character
        if char then
            for _, limb in ipairs(char:GetChildren()) do
                local s = limb:FindFirstChildWhichIsA("Motor6D")
                if s and TrollState.OriginalShoulderC0 then
                    s.C0 = TrollState.OriginalShoulderC0
                end
            end
            TrollState.OriginalShoulderC0 = nil
        end
    end)
end

local function RunOrbitFling(target)
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local targetChar = target.Character
    local targetHrp = targetChar and (targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("UpperTorso"))

    if not (myHrp and targetHrp and myHum) then
        Notify("Ошибка", "Персонажи не загружены!", Color3.fromRGB(255, 0, 0))
        return
    end

    local oldPos = myHrp.CFrame
    TrollState.FlingActive = true
    
    Notify("FE Fling", "Аннигиляция физики: " .. target.DisplayName, CurrentTheme.Accent)

    task.spawn(function()
        local partsToDisable = {}
        for _, part in pairs(myChar:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                table.insert(partsToDisable, part)
            end
        end

        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlingVelocity"
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(999998, 999998, 999998)
        bodyVelocity.Parent = myHrp

        local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.Name = "FlingAngular"
        bodyAngularVelocity.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bodyAngularVelocity.AngularVelocity = Vector3.new(999998, 999998, 999998)
        bodyAngularVelocity.Parent = myHrp

        myHum.PlatformStand = true
        myHum.AutoRotate = false

        local steppedConn
        steppedConn = RunService.Stepped:Connect(function()
            pcall(function()
                for _, part in ipairs(partsToDisable) do
                    if part and part.Parent then
                        part.CanCollide = false
                    end
                end
                myHrp.CanCollide = not myHrp.CanCollide
            end)
        end)
        table.insert(_G.LegenlyConnections, steppedConn)

        local startTime = os.clock()
        while os.clock() - startTime < 3.5 and TrollState.FlingActive do
            RunService.Heartbeat:Wait()
            if not targetChar or not targetHrp or not myHrp or not myChar then break end

            local angle = os.clock() * 320
            local offset = Vector3.new(math.cos(angle) * 1.2, -0.2, math.sin(angle) * 1.2)
            
            myHrp.CFrame = targetHrp.CFrame * CFrame.new(offset) * CFrame.Angles(math.rad(math.random(-180,180)), math.rad(math.random(-180,180)), math.rad(math.random(-180,180)))
            
            local pushImpulse = Vector3.new(math.random(-99999, 99999), 999998, math.random(-99999, 99999))
            myHrp.AssemblyLinearVelocity = pushImpulse
            bodyVelocity.Velocity = pushImpulse
            myHrp.AssemblyAngularVelocity = Vector3.new(0, 999998, 0)
        end

        TrollState.FlingActive = false
        if steppedConn then steppedConn:Disconnect() end
        
        bodyVelocity:Destroy()
        bodyAngularVelocity:Destroy()

        pcall(function()
            myHrp.AssemblyLinearVelocity = Vector3.zero
            myHrp.AssemblyAngularVelocity = Vector3.zero
            myHrp.CFrame = oldPos
            myHum.PlatformStand = false
            myHum.AutoRotate = true
            myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
        
        for _, part in ipairs(partsToDisable) do
            if part and part.Parent then
                part.CanCollide = true
            end
        end
        Notify("Fling завершен", "Физика тела восстановлена.", CurrentTheme.Accent)
    end)
end

local toxicPhrases = {
    "удали роблокс и иди погуляй,",
    "почему ты до сих пор не вышел с сервера,",
    "не позорься, ливни прямо сейчас,",
    "твоя камера теперь принадлежит мне,",
    "у тебя пинг в мозгу завис,",
    "убегай отсюда, тебе здесь не рады,",
    "все смотрят как ты позоришься, ливай,"
}

local function SendMessage(text)
    pcall(function()
        if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local config = TextChatService:FindFirstChild("ChatInputBarConfiguration")
            local targetChannel = config and config.TargetTextChannel
            local generalChannel = targetChannel or (TextChatService:FindFirstChild("TextChannels") and (TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:GetChildren()[1]))
            if generalChannel then 
                generalChannel:SendAsync(text) 
            end
        else
            local remote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
            if remote then 
                remote:FireServer(text, "All") 
            end
        end
    end)
end

task.spawn(function()
    while task.wait(1.8) do
        if TrollState.RageQuitActive and TrollState.SelectedTarget then
            local target = TrollState.SelectedTarget
            local phrase = toxicPhrases[math.random(1, #toxicPhrases)]
            local formattedMessage = string.format("%s, %s!", target.DisplayName, phrase)
            SendMessage(formattedMessage)
        end
    end
end)

-- Обновление сетевого вращения (Репликация через физический крутящий момент)
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local spinForce = hrp:FindFirstChild("ServerSpinForce")
                if TrollState.Spin then
                    if not spinForce then
                        spinForce = Instance.new("BodyAngularVelocity")
                        spinForce.Name = "ServerSpinForce"
                        spinForce.MaxTorque = Vector3.new(0, math.huge, 0)
                        spinForce.Parent = hrp
                    end
                    spinForce.AngularVelocity = Vector3.new(0, TrollState.SpinSpeed * 2, 0)
                else
                    if spinForce then spinForce:Destroy() end
                end
            end
        end)
    end
end)

local stepConn = RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")

        -- ГАРАНТИРОВАННЫЙ СЕТЕВОЙ NOCLIP (No-Collision State Machine)
        if TrollState.Noclip then
            hum:ChangeState(Enum.HumanoidStateType.Swimming)
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end

        if (TrollState.AttachTarget or TrollState.FlingActive or TrollState.RageQuitActive) and not TrollState.Noclip then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if TrollState.FlingActive and part.Name == "HumanoidRootPart" then
                    else
                        part.CanCollide = false
                    end
                end
            end
        end

        if TrollState.RageQuitActive and TrollState.SelectedTarget and hrp and hum then
            local targetChar = TrollState.SelectedTarget.Character
            if targetChar then
                local tHrp = targetChar:FindFirstChild("HumanoidRootPart")
                local tHum = targetChar:FindFirstChildOfClass("Humanoid")
                if tHrp and tHum then
                    hum.PlatformStand = true
                    
                    local faceDir = tHrp.CFrame.LookVector
                    local blockPosition = tHrp.CFrame.Position + (faceDir * 1.5) + Vector3.new(0, 0.4, 0)
                    
                    hrp.CFrame = CFrame.new(blockPosition, tHrp.CFrame.Position)
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                else
                    StopAllActions()
                end
            else
                StopAllActions()
            end
        end

        if TrollState.AttachTarget and TrollState.AttachMode ~= "" and hrp and hum then
            local targetChar = TrollState.AttachTarget.Character
            if targetChar then
                local thrp = targetChar:FindFirstChild("HumanoidRootPart")
                if thrp then
                    hum.PlatformStand = true
                    
                    local speedMultiplier = 25
                    local thrust = (math.sin(os.clock() * speedMultiplier) + 1) / 2
                    local offset
                    
                    if TrollState.AttachMode == "Back" then
                        offset = 1.25 - (thrust * 0.8)
                        hrp.CFrame = thrp.CFrame * CFrame.new(0, -0.2, offset) * CFrame.Angles(math.rad(10 + (thrust * 15)), 0, 0)
                    elseif TrollState.AttachMode == "Front" then
                        offset = -1.2 + (thrust * 0.75)
                        hrp.CFrame = thrp.CFrame * CFrame.new(0, 1.1, offset) * CFrame.Angles(math.rad(-30 + (thrust * 20)), math.rad(180), 0)
                    elseif TrollState.AttachMode == "Victim" then
                        offset = 0.5 - (thrust * 0.4)
                        hrp.CFrame = thrp.CFrame * CFrame.new(0, -1.2, offset) * CFrame.Angles(math.rad(-90), 0, 0)
                    end
                    
                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                else StopAllActions() end
            else StopAllActions() end
        end

        if TrollState.FreezeTarget and TrollState.FreezeTarget.Character then
            local tHrp = TrollState.FreezeTarget.Character:FindFirstChild("HumanoidRootPart")
            if tHrp then
                if not TrollState.FreezePos then TrollState.FreezePos = tHrp.CFrame end
                tHrp.CFrame = TrollState.FreezePos
                tHrp.AssemblyLinearVelocity = Vector3.zero
            end
        end

        if TrollState.SpinTarget and TrollState.SpinTarget.Character then
            local tHrp = TrollState.SpinTarget.Character:FindFirstChild("HumanoidRootPart")
            if tHrp then
                tHrp.CFrame = tHrp.CFrame * CFrame.Angles(0, math.rad(18), 0)
            end
        end
    end)
end)
table.insert(_G.LegenlyConnections, stepConn)

local renderConn = RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")

        if hum then
            if TrollState.EgorSpeed then
                hum.WalkSpeed = 3.5
                local animator = hum:FindFirstChildOfClass("Animator")
                local tracks = animator and animator:GetPlayingAnimationTracks() or hum:GetPlayingAnimationTracks()
                for _, track in pairs(tracks) do
                    if track.IsPlaying then pcall(function() track:AdjustSpeed(6.0) end) end
                end
            else
                if hum.WalkSpeed == 3.5 then hum.WalkSpeed = 16 end
            end
        end
    end)
end)
table.insert(_G.LegenlyConnections, renderConn)

local function ApplySmoothFly()
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        local bv = hrp:FindFirstChild("FlyVelocity") or Instance.new("BodyVelocity")
        bv.Name = "FlyVelocity"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        
        local bg = hrp:FindFirstChild("FlyGyro") or Instance.new("BodyGyro")
        bg.Name = "FlyGyro"
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)

        if TrollState.Fly then
            hum.PlatformStand = true
            bv.Parent = hrp
            bg.Parent = hrp
            
            local cameraCFrame = workspace.CurrentCamera.CFrame
            local moveDir = hum.MoveDirection
            local flyVec = Vector3.zero
            
            if moveDir.Magnitude > 0 then
                local pitch = cameraCFrame.LookVector.Y
                flyVec = moveDir + Vector3.new(0, pitch * 1.25, 0)
                if flyVec.Magnitude > 0 then flyVec = flyVec.Unit end
                bv.Velocity = flyVec * TrollState.FlySpeed
            else
                bv.Velocity = Vector3.zero
            end
            
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                bv.Velocity = bv.Velocity + Vector3.new(0, TrollState.FlySpeed, 0)
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                bv.Velocity = bv.Velocity - Vector3.new(0, TrollState.FlySpeed, 0)
            end
            
            bg.CFrame = cameraCFrame
        else
            if hrp:FindFirstChild("FlyVelocity") then hrp.FlyVelocity:Destroy() end
            if hrp:FindFirstChild("FlyGyro") then hrp.FlyGyro:Destroy() end
            hum.PlatformStand = false
        end
    end)
end

local heartConn = RunService.Heartbeat:Connect(function()
    if TrollState.Fly then ApplySmoothFly() end
end)
table.insert(_G.LegenlyConnections, heartConn)

task.spawn(function()
    while task.wait() do
        pcall(function()
            local char = LocalPlayer.Character
            if not char then return end
            if TrollState.FakeLagFPS or TrollState.FakeLagNet then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Anchored = true
                    task.wait(TrollState.LagFPSValue / 100)
                    hrp.Anchored = false
                    task.wait(0.04)
                end
            end
        end)
    end
end)

local originalHumanoid = nil
task.spawn(function()
    while task.wait(0.1) do
        pcall(function()
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if TrollState.GodMode and hum then
                if hum.ClassName == "Humanoid" and hum ~= originalHumanoid then
                    originalHumanoid = hum
                    local newHum = hum:Clone()
                    newHum.Parent = char
                    workspace.CurrentCamera.CameraSubject = newHum
                    hum:Destroy()
                    
                    if char:FindFirstChild("Animate") then
                        char.Animate.Disabled = true
                        task.wait(0.05)
                        char.Animate.Disabled = false
                    end
                    Notify("God Mode", "Бессмертие активировано (FE)!", CurrentTheme.Accent)
                end
            end
            
            if hrp and hrp.Position.Y < -450 then
                hrp.CFrame = CFrame.new(hrp.Position.X, 100, hrp.Position.Z)
                hrp.AssemblyLinearVelocity = Vector3.zero
                Notify("Void Saver", "Вы спасены от падения в бездну!", CurrentTheme.Accent)
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if TrollState.KillAura then
            pcall(function()
                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not myHrp then return end
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local tHrp = p.Character:FindFirstChild("HumanoidRootPart")
                        if tHrp and (myHrp.Position - tHrp.Position).Magnitude <= TrollState.KillAuraRange then
                            UseWeaponOnTarget(p.Character)
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        if TrollState.ChatSpam then
            SendMessage(TrollState.ChatSpamText)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if TrollState.LoopKill and TrollState.LoopKillTarget and TrollState.LoopKillTarget.Character then
            UseWeaponOnTarget(TrollState.LoopKillTarget.Character)
        end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    StopAllActions()
    TrollState.FreezeTarget = nil
    TrollState.FreezePos = nil
    TrollState.SpinTarget = nil
    TrollState.LoopKillTarget = nil
    originalHumanoid = nil
end)

CreateSection(MainPage, "Движение & Лаги")
CreateToggle(MainPage, "Скорость Роблокс Егора", function(state) TrollState.EgorSpeed = state end)
CreateToggle(MainPage, "Фейк лаги [ФПС]", function(state) TrollState.FakeLagFPS = state end)
CreateSlider(MainPage, "Настройка лагов [ФПС]", 1, 100, 10, function(val) TrollState.LagFPSValue = val end)
CreateToggle(MainPage, "Фейк лаги [Интернет]", function(state) TrollState.FakeLagNet = state end)

CreateSection(MainPage, "Троллинг")
CreateToggle(MainPage, "Вращение (Сетевое для всех)", function(state) TrollState.Spin = state end)
CreateSlider(MainPage, "Скорость вращения", 1, 100, 10, function(val) TrollState.SpinSpeed = val end)

CreateSection(MainPage, "Уничтожение Игроков")

CreatePlayerDropdown(MainPage, function(player)
end)

CreateButton(MainPage, "FLING BY", function()
    StopAllActions()
    local target = TrollState.SelectedTarget
    if target then 
        RunOrbitFling(target) 
    else 
        Notify("Ошибка", "Сначала выберите игрока из списка выше!", Color3.fromRGB(255, 0, 0)) 
    end
end)

CreateToggle(MainPage, "RAGE QUIT (Токсичный Преследователь)", function(state)
    StopAllActions()
    local target = TrollState.SelectedTarget
    if target then
        TrollState.RageQuitActive = state
        if state then
            Notify("Rage Quit", "Токсичное преследование цели начато!", Color3.fromRGB(255, 60, 60))
        end
    else
        Notify("Ошибка", "Сначала выберите игрока из списка выше!", Color3.fromRGB(255, 0, 0))
    end
end)

CreateButton(MainPage, "Freeze Target", function()
    local target = TrollState.SelectedTarget
    if target then
        TrollState.FreezeTarget = target
        TrollState.FreezePos = nil
        Notify("Freeze", target.DisplayName .. " заморожен на экране!", CurrentTheme.Accent)
    else Notify("Ошибка", "Игрок не выбран!", Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "Spin Target", function()
    local target = TrollState.SelectedTarget
    if target then
        TrollState.SpinTarget = target
        Notify("Spin", target.DisplayName .. " закручен на экране!", CurrentTheme.Accent)
    else Notify("Ошибка", "Игрок не выбран!", Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "Teleport to Target", function()
    local target = TrollState.SelectedTarget
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
            Notify("Teleport", "Вы телепортированы к " .. target.DisplayName, CurrentTheme.Accent)
        end
    else Notify("Ошибка", "Игрок не выбран или не загружен!", Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "Loop Kill Target", function()
    local target = TrollState.SelectedTarget
    if target then
        TrollState.LoopKillTarget = target
        TrollState.LoopKill = true
        Notify("Loop Kill", "Запущен бесконечный килл " .. target.DisplayName .. " (нужно оружие!)", Color3.fromRGB(255, 0, 0))
    else Notify("Ошибка", "Игрок не выбран!", Color3.fromRGB(255, 0, 0)) end
end)

CreateSection(MainPage, "Gang Bang (18+ Троллинг)")

CreateButton(MainPage, "Трахнуть (Сзади + Фрикции)", function()
    StopAllActions()
    local target = TrollState.SelectedTarget
    if target then
        TrollState.AttachTarget = target
        TrollState.AttachMode = "Back"
        ApplyEjaculationFX()
        Notify("Успех", "Прикрепились к " .. target.DisplayName .. " сзади", Color3.fromRGB(255, 50, 150))
    else Notify("Ошибка", "Игрок не выбран!", Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "Выехать в рот (Спереди + Фрикции)", function()
    StopAllActions()
    local target = TrollState.SelectedTarget
    if target then
        TrollState.AttachTarget = target
        TrollState.AttachMode = "Front"
        ApplyEjaculationFX()
        Notify("Успех", "Прикрепились к " .. target.DisplayName .. " спереди", Color3.fromRGB(255, 50, 150))
    else Notify("Ошибка", "Игрок не выбран!", Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "Стать жертвой насилия (Фрикции под целью)", function()
    StopAllActions()
    local target = TrollState.SelectedTarget
    if target then
        TrollState.AttachTarget = target
        TrollState.AttachMode = "Victim"
        ApplyEjaculationFX()
        Notify("Режим Жертвы", "Прикрепились снизу к " .. target.DisplayName, Color3.fromRGB(255, 120, 0))
    else
        Notify("Ошибка", "Сначала выберите игрока из списка!", Color3.fromRGB(255, 0, 0))
    end
end)

CreateSection(MainPage, "Собственные функции")

CreateToggle(MainPage, "God Mode (Бессмертие)", function(state) 
    TrollState.GodMode = state 
    if not state then
        Notify("God Mode", "Возродитесь для полного сброса бессмертия.", CurrentTheme.Accent)
    end
end)
CreateToggle(MainPage, "Noclip (Прохождение сквозь стены)", function(state) TrollState.Noclip = state end)
CreateToggle(MainPage, "Fly", function(state) 
    TrollState.Fly = state 
    if not state then
        pcall(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local bv = hrp:FindFirstChild("FlyVelocity")
                local bg = hrp:FindFirstChild("FlyGyro")
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
            end
            local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.PlatformStand = false end
        end)
    end
end)
CreateSlider(MainPage, "Скорость полета", 20, 200, 50, function(val) TrollState.FlySpeed = val end)

CreateToggle(MainPage, "Kill Aura", function(state) TrollState.KillAura = state end)
CreateSlider(MainPage, "Радиус Kill Aura", 5, 50, 15, function(val) TrollState.KillAuraRange = val end)

CreateToggle(MainPage, "Chat Spammer", function(state) TrollState.ChatSpam = state end)
CreateTextBox(MainPage, "Текст для спама", function(text) TrollState.ChatSpamText = text end)

CreateButton(MainPage, "ОСТАНОВИТЬ ВСЕ ДЕЙСТВИЯ", function()
    StopAllActions()
    TrollState.FreezeTarget = nil
    TrollState.FreezePos = nil
    TrollState.SpinTarget = nil
    TrollState.LoopKill = false
    TrollState.LoopKillTarget = nil
    TrollState.KillAura = false
    TrollState.ChatSpam = false
    Notify("Остановлено", "Все действия и таргеты сброшены.", Color3.fromRGB(255, 255, 255))
end)

CreateSection(MainPage, "Оформление Хаба")
CreateThemeDropdown(MainPage)

CreateInfoLabel(InfoPage, "Автор и разработчик HUB: Legenly")
CreateInfoLabel(InfoPage, "Название проекта: HUB - Troll & Universal")
CreateInfoLabel(InfoPage, "--------------------------------------------------")
CreateInfoLabel(InfoPage, "Скрипт полностью переработан и исправлен под FE.")
CreateInfoLabel(InfoPage, "Все функции работают корректно и безопасно.")
CreateInfoLabel(InfoPage, "Добавлены: Freeze, Spin, Teleport, Loop Kill,")
CreateInfoLabel(InfoPage, "God Mode, Noclip, Fly, Kill Aura, Chat Spam.")
CreateInfoLabel(InfoPage, "")
CreateInfoLabel(InfoPage, "Управление Сворачиванием:")
CreateInfoLabel(InfoPage, "Свернуть интерфейс можно кликом на [-].")
CreateInfoLabel(InfoPage, "Островок перетаскивается мышкой/пальцем.") 

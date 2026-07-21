--[[
    HUB - Troll & Universal
    Разработчик: Legenly
    Версия: Hardcore Premium Edition v9.0 (Multi-Lang, Mobile Fly Fix, Island Fix)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ==========================================
-- ТЕМЫ И ОФОРМЛЕНИЕ
-- ==========================================
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
        if not element or not element.Parent then return false end
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

-- ==========================================
-- МУЛЬТИЯЗЫЧНОСТЬ (TRANSLATIONS)
-- ==========================================
local CurrentLang = "RU"
local TextElements = {}

local Translations = {
    RU = {
        Title = "HUB - Troll & Universal",
        TabMain = "Главная",
        TabInfo = "Инфо",
        SecMove = "Движение & Лаги",
        EgorSpeed = "Скорость Роблокс Егора",
        FakeLagFPS = "Фейк лаги [ФПС]",
        SetLagFPS = "Настройка лагов [ФПС]",
        FakeLagNet = "Фейк лаги [Интернет]",
        SecTroll = "Троллинг",
        Spin = "Вращение",
        SpinSpeed = "Скорость вращения",
        SpamSword = "Точить шпагу (Дрочка 18+)",
        ArmSpeed = "Скорость руки",
        SecTarget = "Выбор Жертвы",
        SelectPlr = "  Цель: Выберите игрока...",
        SecDestroy = "Уничтожение Игроков",
        OrbitFling = "ORBIT FLING (Уничтожить цель)",
        VoidFling = "VOID FLING (Под текстуры)",
        Freeze = "Заморозить цель",
        SpinTarget = "Закрутить цель",
        TPTarget = "Телепорт к цели",
        LoopKill = "Зацикленный килл цели",
        SecGang = "Gang Bang (18+ Троллинг)",
        FuckBack = "Трахнуть (Сзади + Фрикции)",
        FuckFront = "Выехать в рот (Спереди + Фрикции)",
        Victim = "Стать жертвой насилия (Лечь)",
        SecSelf = "Собственные функции",
        GodMode = "God Mode (Бессмертие)",
        Noclip = "Noclip (Сквозь стены)",
        Fly = "Fly (Полет)",
        FlySpeed = "Скорость полета",
        KillAura = "Kill Aura (Аура убийства)",
        AuraRange = "Радиус Kill Aura",
        ChatSpam = "Спамер в чат",
        StopAll = "ОСТАНОВИТЬ ВСЕ ДЕЙСТВИЯ",
        SecTheme = "Оформление Хаба",
        DiscordBtn = "Скопировать ссылку на Discord",
        InfoDev = "Автор и разработчик: Legenly",
        InfoName = "Проект: HUB - Troll & Universal",
        InfoDisc = "Discord канал с обновлениями:",
        NotifSwitched = "Язык изменен на Русский",
        PlrSelected = "выбран в качестве цели!"
    },
    EN = {
        Title = "HUB - Troll & Universal",
        TabMain = "Main",
        TabInfo = "Info",
        SecMove = "Movement & Lag",
        EgorSpeed = "Roblox Egor Speed",
        FakeLagFPS = "Fake Lag [FPS]",
        SetLagFPS = "Lag Delay [FPS]",
        FakeLagNet = "Fake Lag [Network]",
        SecTroll = "Troll Features",
        Spin = "Character Spin",
        SpinSpeed = "Spin Speed",
        SpamSword = "Sharpen Sword (18+ Action)",
        ArmSpeed = "Hand Speed",
        SecTarget = "Select Target",
        SelectPlr = "  Target: Select player...",
        SecDestroy = "Destroy Players",
        OrbitFling = "ORBIT FLING (Destroy Target)",
        VoidFling = "VOID FLING (Under Map)",
        Freeze = "Freeze Target",
        SpinTarget = "Spin Target",
        TPTarget = "Teleport to Target",
        LoopKill = "Loop Kill Target",
        SecGang = "Gang Bang (18+ Trolling)",
        FuckBack = "Fuck (Behind + Thrusts)",
        FuckFront = "Face Fuck (Front + Thrusts)",
        Victim = "Become Victim (Lay down)",
        SecSelf = "Self Utility",
        GodMode = "God Mode (Invincible)",
        Noclip = "Noclip (Walk Through)",
        Fly = "Fly Mode",
        FlySpeed = "Fly Speed",
        KillAura = "Kill Aura",
        AuraRange = "Kill Aura Range",
        ChatSpam = "Chat Spammer",
        StopAll = "STOP ALL ACTIONS",
        SecTheme = "Hub Appearance",
        DiscordBtn = "Copy Discord Link",
        InfoDev = "Author & Developer: Legenly",
        InfoName = "Project: HUB - Troll & Universal",
        InfoDisc = "Discord Server for Updates:",
        NotifSwitched = "Language switched to English",
        PlrSelected = "selected as target!"
    }
}

local function RegisterText(element, key)
    table.insert(TextElements, {Element = element, Key = key})
    pcall(function()
        element.Text = Translations[CurrentLang][key] or element.Text
    end)
end

local function SwitchLanguage(lang)
    CurrentLang = lang
    for _, item in ipairs(TextElements) do
        if item.Element and item.Element.Parent then
            pcall(function()
                local txt = Translations[CurrentLang][item.Key]
                if txt then item.Element.Text = txt end
            end)
        end
    end
end

-- ==========================================
-- СОСТОЯНИЕ СКРИПТА
-- ==========================================
local TrollState = {
    EgorSpeed = false,
    FakeLagFPS = false,
    LagFPSValue = 10,
    FakeLagNet = false,
    Spin = false,
    SpinSpeed = 10,
    SpamSword = false,
    SpamSwordSpeed = 20,
    TargetPlayer = nil,
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
}

-- ==========================================
-- ИНИЦИАЛИЗАЦИЯ ИНТЕРФЕЙСА
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LegenlyTrollHub_Ultimate"
ScreenGui.ResetOnSpawn = false

local success, _ = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

-- Кастомные уведомления
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

-- Главное окно
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Name = "MainFrame"
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -200)
MainFrame.Size = UDim2.new(0, 550, 0, 400)
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Шапка
local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Name = "TitleBar"
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BorderSizePixel = 0

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.BackgroundTransparency = 1
TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.Size = UDim2.new(1, -120, 1, 0)
TitleText.Font = Enum.Font.GothamBold
TitleText.TextColor3 = CurrentTheme.Accent
TitleText.TextSize = 14
TitleText.TextXAlignment = Enum.TextXAlignment.Left
RegisterText(TitleText, "Title")
RegisterForRecolor(TitleText, "TextColor3")

-- Кнопка смены языка [RU / EN]
local LangBtn = Instance.new("TextButton", TitleBar)
LangBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
LangBtn.Position = UDim2.new(1, -100, 0.5, -12)
LangBtn.Size = UDim2.new(0, 55, 0, 24)
LangBtn.Font = Enum.Font.GothamBold
LangBtn.Text = "RU / EN"
LangBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
LangBtn.TextSize = 11
Instance.new("UICorner", LangBtn).CornerRadius = UDim.new(0, 5)

LangBtn.MouseButton1Click:Connect(function()
    if CurrentLang == "RU" then
        SwitchLanguage("EN")
        Notify("Language", Translations.EN.NotifSwitched, CurrentTheme.Accent)
    else
        SwitchLanguage("RU")
        Notify("Язык", Translations.RU.NotifSwitched, CurrentTheme.Accent)
    end
end)

-- Кнопка сворачивания [-]
local MinimizeBtn = Instance.new("TextButton", TitleBar)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Position = UDim2.new(1, -35, 0, 0)
MinimizeBtn.Size = UDim2.new(0, 35, 1, 0)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20

-- Островок (Dynamic Island)
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

-- ==========================================
-- УНИВЕРСАЛЬНАЯ СИСТЕМА ДРАГА (БЕЗ ФАЛЬШИВЫХ КЛИКОВ)
-- ==========================================
local function MakeDraggable(dragArea, frameToMove, isIsland)
    local dragging = false
    local dragStart, startPos
    local hasMoved = false

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            hasMoved = false
            dragStart = input.Position
            startPos = frameToMove.Position
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            if delta.Magnitude > 3 then
                hasMoved = true
            end
            frameToMove.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X, 
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    dragArea.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if isIsland and not hasMoved then
                IslandFrame.Visible = false
                MainFrame.Visible = true
            end
        end
    end)
end

MakeDraggable(TitleBar, MainFrame, false)
MakeDraggable(IslandClicker, IslandFrame, true)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    IslandFrame.Visible = true
    Notify("Troll Hub", Translations[CurrentLang].NotifSwitched, CurrentTheme.Accent)
end)

-- Боковая панель
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Name = "Sidebar"
Sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Sidebar.Position = UDim2.new(0, 0, 0, 35)
Sidebar.Size = UDim2.new(0, 140, 1, -35)
Sidebar.BorderSizePixel = 0

-- Контейнер страниц
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

-- Вкладки
local function CreateTabButton(nameKey, targetPage, posY)
    local Btn = Instance.new("TextButton", Sidebar)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Btn.BorderSizePixel = 0
    Btn.Position = UDim2.new(0, 10, 0, posY)
    Btn.Size = UDim2.new(1, -20, 0, 35)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    Btn.TextSize = 13
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn:SetAttribute("IsActiveTab", false)
    RegisterText(Btn, nameKey)

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

local TabMain = CreateTabButton("TabMain", MainPage, 15)
local TabInfo = CreateTabButton("TabInfo", InfoPage, 60)
TabMain.BackgroundColor3 = CurrentTheme.Accent
TabMain.TextColor3 = Color3.fromRGB(255, 255, 255)
TabMain:SetAttribute("IsActiveTab", true)

-- ==========================================
-- КОНСТРУКТОРЫ ЭЛЕМЕНТОВ ИНТЕРФЕЙСА
-- ==========================================
local function CreateSection(parent, textKey)
    local Lbl = Instance.new("TextLabel", parent)
    Lbl.BackgroundTransparency = 1
    Lbl.Size = UDim2.new(1, 0, 0, 25)
    Lbl.Font = Enum.Font.GothamBold
    Lbl.TextColor3 = CurrentTheme.Accent
    Lbl.TextSize = 13
    RegisterText(Lbl, textKey)
    RegisterForRecolor(Lbl, "TextColor3")
end

local function CreateToggle(parent, textKey, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.BackgroundTransparency = 1
    Lbl.Position = UDim2.new(0, 10, 0, 0)
    Lbl.Size = UDim2.new(1, -50, 1, 0)
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    RegisterText(Lbl, textKey)

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

local function CreateSlider(parent, textKey, min, max, default, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.Size = UDim2.new(1, -10, 0, 50)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.BackgroundTransparency = 1
    Lbl.Position = UDim2.new(0, 10, 0, 5)
    Lbl.Size = UDim2.new(1, -20, 0, 20)
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local function UpdateLabelText(val)
        local baseText = Translations[CurrentLang][textKey] or textKey
        Lbl.Text = baseText .. ": " .. tostring(val)
    end
    UpdateLabelText(default)
    table.insert(TextElements, {Element = {Text = ""}, Key = textKey}) -- Регистрируем
    
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
    local currentValue = default

    local function UpdateSliderValue(input)
        local barWidth = Bar.AbsoluteSize.X
        if barWidth == 0 then barWidth = 1 end
        local pos = math.clamp(input.Position.X - Bar.AbsolutePosition.X, 0, barWidth)
        local percent = pos / barWidth
        Fill.Size = UDim2.new(percent, 0, 1, 0)
        currentValue = math.floor(min + ((max - min) * percent))
        UpdateLabelText(currentValue)
        callback(currentValue)
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

local function CreateButton(parent, textKey, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 13
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    RegisterText(Btn, textKey)

    Btn.MouseButton1Click:Connect(function()
        Btn.BackgroundColor3 = CurrentTheme.Accent
        task.wait(0.12)
        Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        callback()
    end)
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

-- ==========================================
-- УМНЫЙ ВЫПАДАЮЩИЙ СПИСОК ЖЕРТВЫ (DROPDOWN)
-- ==========================================
local function CreatePlayerDropdown(parent)
    local DropFrame = Instance.new("Frame", parent)
    DropFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    DropFrame.Size = UDim2.new(1, -10, 0, 35)
    DropFrame.ClipsDescendants = true
    Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 6)

    local MainBtn = Instance.new("TextButton", DropFrame)
    MainBtn.Size = UDim2.new(1, 0, 0, 35)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Font = Enum.Font.GothamBold
    MainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MainBtn.TextSize = 12
    MainBtn.TextXAlignment = Enum.TextXAlignment.Left
    RegisterText(MainBtn, "SelectPlr")

    local Arrow = Instance.new("TextLabel", MainBtn)
    Arrow.Size = UDim2.new(0, 30, 1, 0)
    Arrow.Position = UDim2.new(1, -30, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Font = Enum.Font.GothamBold
    Arrow.Text = "▼"
    Arrow.TextColor3 = Color3.fromRGB(200, 200, 200)
    Arrow.TextSize = 12

    local Scroll = Instance.new("ScrollingFrame", DropFrame)
    Scroll.Position = UDim2.new(0, 5, 0, 35)
    Scroll.Size = UDim2.new(1, -10, 0, 110)
    Scroll.BackgroundTransparency = 1
    Scroll.ScrollBarThickness = 3
    Scroll.BorderSizePixel = 0

    local ListLayout = Instance.new("UIListLayout", Scroll)
    ListLayout.Padding = UDim.new(0, 4)

    local isOpen = false

    local function RefreshPlayers()
        for _, child in pairs(Scroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end

        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                local PlrBtn = Instance.new("TextButton", Scroll)
                PlrBtn.Size = UDim2.new(1, -5, 0, 25)
                PlrBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
                PlrBtn.Font = Enum.Font.Gotham
                PlrBtn.Text = "  " .. plr.DisplayName .. " (@" .. plr.Name .. ")"
                PlrBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
                PlrBtn.TextSize = 11
                PlrBtn.TextXAlignment = Enum.TextXAlignment.Left
                Instance.new("UICorner", PlrBtn).CornerRadius = UDim.new(0, 4)

                PlrBtn.MouseButton1Click:Connect(function()
                    TrollState.TargetPlayer = plr
                    MainBtn.Text = "  " .. plr.DisplayName
                    isOpen = false
                    DropFrame.Size = UDim2.new(1, -10, 0, 35)
                    Arrow.Text = "▼"
                    Notify("Target", plr.DisplayName .. " " .. Translations[CurrentLang].PlrSelected, CurrentTheme.Accent)
                end)
            end
        end
        Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
    end

    MainBtn.MouseButton1Click:Connect(function()
        isOpen = not isOpen
        if isOpen then
            RefreshPlayers()
            DropFrame.Size = UDim2.new(1, -10, 0, 150)
            Arrow.Text = "▲"
        else
            DropFrame.Size = UDim2.new(1, -10, 0, 35)
            Arrow.Text = "▼"
        end
    end)

    Players.PlayerAdded:Connect(RefreshPlayers)
    Players.PlayerRemoving:Connect(RefreshPlayers)
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

-- ==========================================
-- ЛОГИКА ТРОЛЛИНГА И ЭФФЕКТОВ
-- ==========================================

local function ApplyEjaculationFX()
    pcall(function()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local tool = char:FindFirstChildOfClass("Tool") or LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
        local parentObj = hrp
        if tool and tool:FindFirstChild("Handle") then
            if tool.Parent ~= char then tool.Parent = char end
            parentObj = tool.Handle
        end

        local pe = Instance.new("ParticleEmitter")
        pe.Name = "SpermFX"
        pe.Texture = "rbxassetid://243132757"
        pe.Rate = 50
        pe.Speed = NumberRange.new(12, 22)
        pe.VelocitySpread = 35
        pe.Lifetime = NumberRange.new(0.6, 1.2)
        pe.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
        pe.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 0.05)})
        pe.EmissionDirection = Enum.NormalId.Front
        pe.Parent = parentObj
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
            if tool.Parent ~= char then tool.Parent = char end
            local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
            if handle then
                local firetouch = firetouchinterest or (syn and syn.firetouchinterest)
                if firetouch then
                    for _, part in pairs(targetChar:GetDescendants()) do
                        if part:IsA("BasePart") then
                            firetouch(handle, part, 0)
                            firetouch(handle, part, 1)
                        end
                    end
                else
                    handle.CFrame = targetChar:GetPivot()
                end
            end
        end
    end)
end

local function StopAllActions()
    TrollState.SpamSword = false
    TrollState.AttachTarget = nil
    TrollState.AttachMode = ""
    TrollState.FlingActive = false

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
                if obj.Name == "FlingVelocity" or obj.Name == "FlingAngular" or obj.Name == "FlingForce" then
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
            local ru = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            local rs = (ru and ru:FindFirstChild("RightShoulder")) or (torso and torso:FindFirstChild("Right Shoulder"))
            if rs and rs:IsA("Motor6D") and TrollState.OriginalShoulderC0 then
                rs.C0 = TrollState.OriginalShoulderC0
                TrollState.OriginalShoulderC0 = nil
            end
        end
    end)
end

-- ==========================================
-- FE ORBIT / VOID FLING BYPASS
-- ==========================================
local function RunOrbitFling(target, isVoidMode)
    local myChar = LocalPlayer.Character
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")
    local targetChar = target and target.Character
    local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

    if not (myHrp and targetHrp and myHum) then
        Notify("Error", "Character not loaded!", Color3.fromRGB(255, 0, 0))
        return
    end

    local oldPos = myHrp.CFrame
    TrollState.FlingActive = true

    Notify(isVoidMode and "Void Fling" or "Orbit Fling", "Flinging: " .. target.DisplayName, CurrentTheme.Accent)

    task.spawn(function()
        local partsToDisable = {}
        for _, part in pairs(myChar:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                table.insert(partsToDisable, part)
            end
        end

        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Name = "FlingVelocity"
        bodyVelocity.MaxForce = Vector3.new(1e8, 1e8, 1e8)
        bodyVelocity.Velocity = Vector3.new(99999, 99999, 99999)
        bodyVelocity.Parent = myHrp

        local bodyAngularVelocity = Instance.new("BodyAngularVelocity")
        bodyAngularVelocity.Name = "FlingAngular"
        bodyAngularVelocity.MaxTorque = Vector3.new(1e8, 1e8, 1e8)
        bodyAngularVelocity.AngularVelocity = Vector3.new(0, 99999, 0)
        bodyAngularVelocity.Parent = myHrp

        myHum.PlatformStand = true
        myHum.AutoRotate = false

        local steppedConn
        steppedConn = RunService.Stepped:Connect(function()
            pcall(function()
                for _, part in ipairs(partsToDisable) do
                    if part and part.Parent then part.CanCollide = false end
                end
                myHrp.CanCollide = not myHrp.CanCollide
                if targetHrp then targetHrp.CanCollide = true end
            end)
        end)

        local startTime = os.clock()
        while os.clock() - startTime < 4.5 and TrollState.FlingActive do
            RunService.Heartbeat:Wait()
            if not targetChar or not targetHrp or not myHrp or not myChar then break end

            local jitter = Vector3.new(math.random(-8, 8) / 10, math.random(-5, 5) / 10, math.random(-8, 8) / 10)
            myHrp.AssemblyAngularVelocity = Vector3.new(0, 999999, 0)

            if isVoidMode then
                myHrp.CFrame = targetHrp.CFrame * CFrame.new(0, -3.2, 0)
                myHrp.AssemblyLinearVelocity = Vector3.new(0, -999999, 0)
                bodyVelocity.Velocity = Vector3.new(0, -999999, 0)
            else
                local angle = os.clock() * 250
                local offset = Vector3.new(math.cos(angle) * 1.15, -0.15, math.sin(angle) * 1.15)
                myHrp.CFrame = targetHrp.CFrame * CFrame.new(offset + jitter)
                local pushImpulse = Vector3.new(math.random(-50000, 50000), 99999, math.random(-50000, 50000))
                myHrp.AssemblyLinearVelocity = pushImpulse
                bodyVelocity.Velocity = pushImpulse
            end

            if targetHrp.AssemblyLinearVelocity.Magnitude > 250 or targetHrp.Position.Y < -200 or targetHrp.Position.Y > 2000 then
                Notify("Success!", "Target physically launched!", Color3.fromRGB(0, 255, 120))
                break
            end
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
            if part and part.Parent then part.CanCollide = true end
        end
        Notify("Fling Done", "Body physics restored.", CurrentTheme.Accent)
    end)
end

-- ==========================================
-- ОСНОВНОЙ ЦИКЛ ФИЗИКИ И NOCLIP
-- ==========================================
RunService.Stepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")

        -- ПОЛНЫЙ ГАРАНТИРОВАННЫЙ NOCLIP
        if TrollState.Noclip or TrollState.AttachTarget or TrollState.FlingActive then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if not (TrollState.FlingActive and part.Name == "HumanoidRootPart") then
                        part.CanCollide = false
                        part.CanQuery = false
                    end
                end
            end
        end

        -- ==========================================
        -- ДРОЧКА / ТОЧИТЬ ШПАГУ (ПОЧИНЕННАЯ РУКА R6 & R15)
        -- ==========================================
        if TrollState.SpamSword and hum and hrp and not TrollState.AttachTarget then
            local rightUpperArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
            local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
            local rs = (rightUpperArm and rightUpperArm:FindFirstChild("RightShoulder")) or (torso and torso:FindFirstChild("Right Shoulder"))

            local speedMultiplier = TrollState.SpamSwordSpeed
            local rub = math.cos(os.clock() * speedMultiplier)

            if rs and rs:IsA("Motor6D") then
                if not TrollState.OriginalShoulderC0 then
                    TrollState.OriginalShoulderC0 = rs.C0
                end
                rs.C0 = TrollState.OriginalShoulderC0 * CFrame.new(-0.35, rub * 0.45, -0.2) * CFrame.Angles(math.rad(85 + (rub * 12)), math.rad(-15), 0)
            end
        end

        -- ==========================================
        -- НАМЕРТВО ЛИПКАЯ ПРИВЯЗКА (GANG BANG)
        -- ==========================================
        if TrollState.AttachTarget and TrollState.AttachMode ~= "" and hrp and hum then
            local targetChar = TrollState.AttachTarget.Character
            if targetChar then
                local thrp = targetChar:FindFirstChild("HumanoidRootPart")
                if thrp then
                    hum.PlatformStand = true

                    local speedMultiplier = TrollState.SpamSword and TrollState.SpamSwordSpeed or 25
                    local thrust = (math.sin(os.clock() * speedMultiplier) + 1) / 2
                    local offset, tilt

                    local rightUpperArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                    local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
                    local rs = (rightUpperArm and rightUpperArm:FindFirstChild("RightShoulder")) or (torso and torso:FindFirstChild("Right Shoulder"))
                    if rs and rs:IsA("Motor6D") and TrollState.SpamSword then
                        if not TrollState.OriginalShoulderC0 then TrollState.OriginalShoulderC0 = rs.C0 end
                        rs.C0 = TrollState.OriginalShoulderC0 * CFrame.new(0, math.cos(os.clock() * speedMultiplier) * 0.35, -0.1) * CFrame.Angles(math.rad(80), 0, 0)
                    end

                    if TrollState.AttachMode == "Back" then
                        offset = 1.25 - (thrust * 0.85)
                        tilt = math.rad(10 + (thrust * 15))
                        hrp.CFrame = thrp.CFrame * CFrame.new(0, -0.2, offset) * CFrame.Angles(tilt, 0, 0)
                    elseif TrollState.AttachMode == "Front" then
                        offset = -1.2 + (thrust * 0.8)
                        tilt = math.rad(-30 + (thrust * 20))
                        hrp.CFrame = thrp.CFrame * CFrame.new(0, 1.1, offset) * CFrame.Angles(tilt, math.rad(180), 0)
                    end

                    hrp.AssemblyLinearVelocity = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                else StopAllActions() end
            else StopAllActions() end
        end

        -- Freeze & Spin
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

RunService.RenderStepped:Connect(function()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")

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
        if hrp and TrollState.Spin then
            hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(TrollState.SpinSpeed), 0)
        end
    end)
end)

-- ==========================================
-- ИСПРАВЛЕННЫЙ ПОЛЕТ (FLY) С ПРАВИЛЬНЫМ ВЕКТОРНЫМ НАПРАВЛЕНИЕМ
-- ==========================================
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

            local camera = workspace.CurrentCamera
            local cameraCFrame = camera.CFrame
            local moveDir = hum.MoveDirection

            if moveDir.Magnitude > 0 then
                -- Использование MoveDirection напрямую гарантирует корректное направление джойстика
                local flyDir = Vector3.new(moveDir.X, cameraCFrame.LookVector.Y * (moveDir.Magnitude), moveDir.Z)
                if flyDir.Magnitude > 0 then flyDir = flyDir.Unit end
                bv.Velocity = flyDir * TrollState.FlySpeed
            else
                bv.Velocity = Vector3.zero
            end

            -- Вывод по высоте (Прыжок/Спуск)
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

RunService.Heartbeat:Connect(function()
    if TrollState.Fly then ApplySmoothFly() end
end)

-- Фейклаги
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

-- FE God Mode & Void Saver
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
                    Notify("God Mode", "God Mode Activated (FE)!", CurrentTheme.Accent)
                end
            end

            if hrp and hrp.Position.Y < -450 then
                hrp.CFrame = CFrame.new(hrp.Position.X, 100, hrp.Position.Z)
                hrp.AssemblyLinearVelocity = Vector3.zero
                Notify("Void Saver", "Saved from void fall!", CurrentTheme.Accent)
            end
        end)
    end
end)

-- FE Kill Aura
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

-- FE Chat Spam
task.spawn(function()
    while task.wait(2) do
        if TrollState.ChatSpam then
            pcall(function()
                if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
                    local config = TextChatService:FindFirstChild("ChatInputBarConfiguration")
                    local targetChannel = config and config.TargetTextChannel
                    local generalChannel = targetChannel or (TextChatService:FindFirstChild("TextChannels") and (TextChatService.TextChannels:FindFirstChild("RBXGeneral") or TextChatService.TextChannels:GetChildren()[1]))
                    if generalChannel then generalChannel:SendAsync(TrollState.ChatSpamText) end
                else
                    local remote = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") and ReplicatedStorage.DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
                    if remote then remote:FireServer(TrollState.ChatSpamText, "All") end
                end
            end)
        end
    end
end)

-- FE Loop Kill
task.spawn(function()
    while task.wait(0.1) do
        if TrollState.LoopKill and TrollState.LoopKillTarget and TrollState.LoopKillTarget.Character then
            UseWeaponOnTarget(TrollState.LoopKillTarget.Character)
        end
    end
end)

-- Сброс при респавне
LocalPlayer.CharacterAdded:Connect(function()
    StopAllActions()
    TrollState.FreezeTarget = nil
    TrollState.FreezePos = nil
    TrollState.SpinTarget = nil
    TrollState.LoopKillTarget = nil
    originalHumanoid = nil
end)

-- ==========================================
-- ЗАПОЛНЕНИЕ ВКЛАДКИ MAIN
-- ==========================================

CreateSection(MainPage, "SecMove")
CreateToggle(MainPage, "EgorSpeed", function(state) TrollState.EgorSpeed = state end)
CreateToggle(MainPage, "FakeLagFPS", function(state) TrollState.FakeLagFPS = state end)
CreateSlider(MainPage, "SetLagFPS", 1, 100, 10, function(val) TrollState.LagFPSValue = val end)
CreateToggle(MainPage, "FakeLagNet", function(state) TrollState.FakeLagNet = state end)

CreateSection(MainPage, "SecTroll")
CreateToggle(MainPage, "Spin", function(state) TrollState.Spin = state end)
CreateSlider(MainPage, "SpinSpeed", 1, 100, 10, function(val) TrollState.SpinSpeed = val end)

CreateToggle(MainPage, "SpamSword", function(state)
    StopAllActions()
    TrollState.SpamSword = state
    if state then
        ApplyEjaculationFX()
        Notify("18+ Action", "Mode Activated!", Color3.fromRGB(255, 100, 180))
    end
end)
CreateSlider(MainPage, "ArmSpeed", 5, 45, 20, function(val) TrollState.SpamSwordSpeed = val end)

CreateSection(MainPage, "SecTarget")
CreatePlayerDropdown(MainPage)

CreateSection(MainPage, "SecDestroy")

CreateButton(MainPage, "OrbitFling", function()
    StopAllActions()
    if TrollState.TargetPlayer then 
        RunOrbitFling(TrollState.TargetPlayer, false) 
    else 
        Notify("Error", "Select a target first!", Color3.fromRGB(255, 0, 0)) 
    end
end)

CreateButton(MainPage, "VoidFling", function()
    StopAllActions()
    if TrollState.TargetPlayer then 
        RunOrbitFling(TrollState.TargetPlayer, true) 
    else 
        Notify("Error", "Select a target first!", Color3.fromRGB(255, 0, 0)) 
    end
end)

CreateButton(MainPage, "Freeze", function()
    if TrollState.TargetPlayer then
        TrollState.FreezeTarget = TrollState.TargetPlayer
        TrollState.FreezePos = nil
        Notify("Freeze", TrollState.TargetPlayer.DisplayName, CurrentTheme.Accent)
    else Notify("Error", "Select a target first!", Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "SpinTarget", function()
    if TrollState.TargetPlayer then
        TrollState.SpinTarget = TrollState.TargetPlayer
        Notify("Spin", TrollState.TargetPlayer.DisplayName, CurrentTheme.Accent)
    else Notify("Error", "Select a target first!", Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "TPTarget", function()
    if TrollState.TargetPlayer and TrollState.TargetPlayer.Character and TrollState.TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            myChar.HumanoidRootPart.CFrame = TrollState.TargetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
            Notify("Teleport", "Teleported to " .. TrollState.TargetPlayer.DisplayName, CurrentTheme.Accent)
        end
    else Notify("Error", "Cannot teleport!", Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "LoopKill", function()
    if TrollState.TargetPlayer then
        TrollState.LoopKillTarget = TrollState.TargetPlayer
        TrollState.LoopKill = true
        Notify("Loop Kill", "Loop killing " .. TrollState.TargetPlayer.DisplayName, Color3.fromRGB(255, 0, 0))
    else Notify("Error", "Select a target first!", Color3.fromRGB(255, 0, 0)) end
end)

CreateSection(MainPage, "SecGang")

CreateButton(MainPage, "FuckBack", function()
    StopAllActions()
    if TrollState.TargetPlayer then
        TrollState.AttachTarget = TrollState.TargetPlayer
        TrollState.AttachMode = "Back"
        ApplyEjaculationFX()
        Notify("Success", "Attached to " .. TrollState.TargetPlayer.DisplayName, Color3.fromRGB(255, 50, 150))
    else Notify("Error", "Select a target first!", Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "FuckFront", function()
    StopAllActions()
    if TrollState.TargetPlayer then
        TrollState.AttachTarget = TrollState.TargetPlayer
        TrollState.AttachMode = "Front"
        ApplyEjaculationFX()
        Notify("Success", "Attached to " .. TrollState.TargetPlayer.DisplayName, Color3.fromRGB(255, 50, 150))
    else Notify("Error", "Select a target first!", Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "Victim", function()
    StopAllActions()
    pcall(function()
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.PlatformStand = true end
        hrp.CFrame = CFrame.new(hrp.Position - Vector3.new(0, 1.35, 0)) * CFrame.Angles(math.rad(90), 0, 0)
        hrp.Anchored = true
        Notify("Victim Mode", "Locked to floor.", Color3.fromRGB(255, 120, 0))
    end)
end)

CreateSection(MainPage, "SecSelf")

CreateToggle(MainPage, "GodMode", function(state) 
    TrollState.GodMode = state 
    if not state then Notify("God Mode", "Reset to clear.", CurrentTheme.Accent) end
end)
CreateToggle(MainPage, "Noclip", function(state) TrollState.Noclip = state end)
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
CreateSlider(MainPage, "FlySpeed", 20, 200, 50, function(val) TrollState.FlySpeed = val end)

CreateToggle(MainPage, "KillAura", function(state) TrollState.KillAura = state end)
CreateSlider(MainPage, "AuraRange", 5, 50, 15, function(val) TrollState.KillAuraRange = val end)

CreateToggle(MainPage, "ChatSpam", function(state) TrollState.ChatSpam = state end)
CreateTextBox(MainPage, "Spam text...", function(text) TrollState.ChatSpamText = text end)

CreateButton(MainPage, "StopAll", function()
    StopAllActions()
    TrollState.FreezeTarget = nil
    TrollState.FreezePos = nil
    TrollState.SpinTarget = nil
    TrollState.LoopKill = false
    TrollState.LoopKillTarget = nil
    TrollState.KillAura = false
    TrollState.ChatSpam = false
    Notify("Stopped", "All targets and actions cleared.", Color3.fromRGB(255, 255, 255))
end)

CreateSection(MainPage, "SecTheme")

local function CreateThemeBtn(key)
    local btn = Instance.new("TextButton", MainPage)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    btn.Size = UDim2.new(1, -10, 0, 30)
    btn.Font = Enum.Font.GothamBold
    btn.Text = "Theme: " .. Themes[key].Name
    btn.TextColor3 = Themes[key].Accent
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseButton1Click:Connect(function()
        ApplyTheme(key)
        Notify("Theme", Themes[key].Name, Themes[key].Accent)
    end)
end

CreateThemeBtn("Red")
CreateThemeBtn("Blue")
CreateThemeBtn("Purple")
CreateThemeBtn("Green")
CreateThemeBtn("Gold")

-- ==========================================
-- ВКЛАДКА INFO (С ДИСКОРДОМ И АВТОРСТВОМ)
-- ==========================================
local InfoDevLabel = Instance.new("TextLabel", InfoPage)
InfoDevLabel.BackgroundTransparency = 1
InfoDevLabel.Size = UDim2.new(1, -10, 0, 20)
InfoDevLabel.Font = Enum.Font.GothamBold
InfoDevLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
InfoDevLabel.TextSize = 13
InfoDevLabel.TextXAlignment = Enum.TextXAlignment.Left
RegisterText(InfoDevLabel, "InfoDev")

local InfoNameLabel = Instance.new("TextLabel", InfoPage)
InfoNameLabel.BackgroundTransparency = 1
InfoNameLabel.Size = UDim2.new(1, -10, 0, 20)
InfoNameLabel.Font = Enum.Font.Gotham
InfoNameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoNameLabel.TextSize = 12
InfoNameLabel.TextXAlignment = Enum.TextXAlignment.Left
RegisterText(InfoNameLabel, "InfoName")

CreateInfoLabel(InfoPage, "--------------------------------------------------")

local InfoDiscLabel = Instance.new("TextLabel", InfoPage)
InfoDiscLabel.BackgroundTransparency = 1
InfoDiscLabel.Size = UDim2.new(1, -10, 0, 20)
InfoDiscLabel.Font = Enum.Font.GothamBold
InfoDiscLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
InfoDiscLabel.TextSize = 12
InfoDiscLabel.TextXAlignment = Enum.TextXAlignment.Left
RegisterText(InfoDiscLabel, "InfoDisc")

-- Кнопка копирования Discord
local CopyDiscBtn = Instance.new("TextButton", InfoPage)
CopyDiscBtn.BackgroundColor3 = Color3.fromRGB(40, 45, 60)
CopyDiscBtn.Size = UDim2.new(1, -10, 0, 35)
CopyDiscBtn.Font = Enum.Font.GothamBold
CopyDiscBtn.Text = "https://discord.gg/vpfFGGjg9"
CopyDiscBtn.TextColor3 = Color3.fromRGB(120, 180, 255)
CopyDiscBtn.TextSize = 12
Instance.new("UICorner", CopyDiscBtn).CornerRadius = UDim.new(0, 6)

CopyDiscBtn.MouseButton1Click:Connect(function()
    local link = "https://discord.gg/vpfFGGjg9"
    if setclipboard or (syn and syn.write_clipboard) then
        (setclipboard or syn.write_clipboard)(link)
        Notify("Discord", "Ссылка скопирована в буфер обмена!", Color3.fromRGB(100, 200, 255))
    else
        Notify("Discord", link, Color3.fromRGB(100, 200, 255))
    end
end)

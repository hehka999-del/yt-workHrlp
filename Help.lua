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
local Language = "RU"
local ScaleFactor = 1.0

local Translations = {
    RU = {
        Title = "HUB - Troll & Universal",
        Subtitle = "by Legenly",
        NotifyMinimizeTitle = "Интерфейс свернут",
        NotifyMinimizeDesc = "Нажми на островок 'Troll', чтобы развернуть.",
        NotifyThemeTitle = "Тема изменена",
        NotifyThemeDesc = "Установлен цвет ",
        NotifyTargetErr = "Ошибка: Сначала выберите игрока из списка выше!",
        NotifyTargetSelectErr = "Ошибка: Игрок не выбран!",
        NotifyTeleportErr = "Ошибка: Игрок не выбран или не загружен!",
        NotifyTeleportOk = "Вы телепортированы к ",
        NotifyStop = "Все действия и таргеты сброшены.",
        NotifyStopTitle = "Остановлено",
        TabMain = "Главная",
        TabInfo = "Инфо",
        SecMovement = "Движение & Лаги",
        SecTroll = "Троллинг",
        SecDestroy = "Уничтожение Игроков",
        Sec18 = "Gang Bang (18+ Троллинг)",
        SecOwn = "Собственные функции",
        SecVisual = "Оформление Хаба",
        OptEgor = "Скорость Роблокс Егора",
        OptLagFPS = "Фейк лаги [ФПС]",
        OptLagFPSVal = "Настройка лагов [ФПС]",
        OptLagNet = "Фейк лаги [Интернет]",
        OptSpin = "Вращение (Сетевое для всех)",
        OptSpinSpeed = "Скорость вращения",
        OptSelect = "Выбрать игрока: (Никто)",
        OptSelected = "Выбран: ",
        BtnFling = "FLING BY",
        ToggleRage = "RAGE QUIT (Токсичный Преследователь)",
        BtnFreeze = "Freeze Target",
        BtnSpinTarget = "Spin Target",
        BtnTp = "Teleport to Target",
        BtnLoopKill = "Loop Kill Target",
        BtnSexBack = "Трахнуть (Сзади + Фрикции)",
        BtnSexFront = "Выехать в рот (Спереди + Фрикции)",
        BtnVictim = "Стать жертвой насилия (Фрикции под целью)",
        OptGod = "God Mode (Бессмертие)",
        OptNoclip = "Noclip (Прохождение сквозь стены)",
        OptFly = "Fly (Полет)",
        OptFlySpeed = "Скорость полета",
        OptAura = "Kill Aura",
        OptAuraRange = "Радиус Kill Aura",
        OptSpam = "Chat Spammer",
        OptSpamTxt = "Текст для спама",
        BtnStopAll = "ОСТАНОВИТЬ ВСЕ ДЕЙСТВИЯ",
        OptScale = "Размер интерфейса (Масштаб)",
        OptDropdownTheme = "Сменить тему хаба",
        InfoAuthor = "Автор и разработчик HUB: Legenly",
        InfoName = "Название проекта: HUB - Troll & Universal",
        InfoLine1 = "Скрипт полностью переработан и исправлен под FE.",
        InfoLine2 = "Все функции работают корректно и безопасно.",
        InfoLine3 = "Добавлены: Freeze, Spin, Teleport, Loop Kill,",
        InfoLine4 = "God Mode, Noclip, Fly, Kill Aura, Chat Spam.",
        InfoLine5 = "Управление Сворачиванием:",
        InfoLine6 = "Свернуть интерфейс можно кликом на [-].",
        InfoLine7 = "Островок перетаскивается мышкой/пальцем.",
        NotifySexBack = "Прикрепились к %s сзади",
        NotifySexFront = "Прикрепились к %s спереди",
        NotifySexVictim = "Прикрепились снизу к %s",
        NotifyRageActive = "Токсичное преследование цели начато!",
        NotifyFreeze = "%s заморожен на экране!",
        NotifySpin = "%s закручен на экране!",
        NotifyLoopKill = "Запущен бесконечный килл %s (нужно оружие!)",
        NotifyGodMode = "Бессмертие активировано (FE)!",
        NotifyGodModeOff = "Возродитесь для полного сброса бессмертия.",
        NotifyFlingStart = "Аннигиляция физики: %s",
        NotifyFlingEnd = "Физика тела восстановлена.",
        NotifyFlingTitle = "Fling завершен",
        PlaceholderSpam = "Введи текст...",
        PlayerEmpty = "(Никто)"
    },
    ENG = {
        Title = "HUB - Troll & Universal",
        Subtitle = "by Legenly",
        NotifyMinimizeTitle = "GUI Minimized",
        NotifyMinimizeDesc = "Click on the 'Troll' island to restore.",
        NotifyThemeTitle = "Theme Changed",
        NotifyThemeDesc = "Color set to ",
        NotifyTargetErr = "Error: Select a player from the list above first!",
        NotifyTargetSelectErr = "Error: Player not selected!",
        NotifyTeleportErr = "Error: Player not selected or not loaded!",
        NotifyTeleportOk = "You have been teleported to ",
        NotifyStop = "All actions and targets have been reset.",
        NotifyStopTitle = "Stopped",
        TabMain = "Main",
        TabInfo = "Info",
        SecMovement = "Movement & Lags",
        SecTroll = "Trolling",
        SecDestroy = "Destroy Players",
        Sec18 = "Gang Bang (18+ Trolling)",
        SecOwn = "Own Features",
        SecVisual = "Theme Customization",
        OptEgor = "Egor Roblox Speed",
        OptLagFPS = "Fake Lag [FPS]",
        OptLagFPSVal = "Lag Value [FPS]",
        OptLagNet = "Fake Lag [Net]",
        OptSpin = "Spin (Replicated for all)",
        OptSpinSpeed = "Spin Speed",
        OptSelect = "Select Player: (None)",
        OptSelected = "Selected: ",
        BtnFling = "FLING BY",
        ToggleRage = "RAGE QUIT (Toxic Stalker)",
        BtnFreeze = "Freeze Target",
        BtnSpinTarget = "Spin Target",
        BtnTp = "Teleport to Target",
        BtnLoopKill = "Loop Kill Target",
        BtnSexBack = "Fuck (Behind + Friction)",
        BtnSexFront = "Head (Front + Friction)",
        BtnVictim = "Become Victim (Friction under target)",
        OptGod = "God Mode (Invincibility)",
        OptNoclip = "Noclip (Walk Through Walls)",
        OptFly = "Fly",
        OptFlySpeed = "Fly Speed",
        OptAura = "Kill Aura",
        OptAuraRange = "Kill Aura Range",
        OptSpam = "Chat Spammer",
        OptSpamTxt = "Spam Text",
        BtnStopAll = "STOP ALL ACTIONS",
        OptScale = "Interface Size (Scale)",
        OptDropdownTheme = "Change Hub Theme",
        InfoAuthor = "HUB Author & Developer: Legenly",
        InfoName = "Project Name: HUB - Troll & Universal",
        InfoLine1 = "Script completely rewritten and patched for FE.",
        InfoLine2 = "All features work correctly and safely.",
        InfoLine3 = "Added: Freeze, Spin, Teleport, Loop Kill,",
        InfoLine4 = "God Mode, Noclip, Fly, Kill Aura, Chat Spam.",
        InfoLine5 = "Minimize Controls:",
        InfoLine6 = "Minimize the interface by clicking [-].",
        InfoLine7 = "Drag the island using mouse/finger.",
        NotifySexBack = "Attached to %s from behind",
        NotifySexFront = "Attached to %s in front",
        NotifySexVictim = "Attached under %s",
        NotifyRageActive = "Toxic stalking started!",
        NotifyFreeze = "%s frozen on screen!",
        NotifySpin = "%s spun on screen!",
        NotifyLoopKill = "Infinite kill loop started for %s (weapon required!)",
        NotifyGodMode = "Invincibility enabled (FE)!",
        NotifyGodModeOff = "Reset character to fully disable God Mode.",
        NotifyFlingStart = "Annihilating physics of: %s",
        NotifyFlingEnd = "Character physics restored.",
        NotifyFlingTitle = "Fling Completed",
        PlaceholderSpam = "Enter text...",
        PlayerEmpty = "(None)"
    }
}

local function GetText(key)
    return Translations[Language][key] or key
end

local TextObjects = {}

local function RegisterForTranslation(element, key, isPlaceholder)
    TextObjects[element] = {Key = key, IsPlaceholder = isPlaceholder}
    pcall(function()
        if isPlaceholder then
            element.PlaceholderText = GetText(key)
        else
            element.Text = GetText(key)
        end
    end)
end

local function TranslateAll()
    for element, data in pairs(TextObjects) do
        pcall(function()
            if element and element.Parent then
                if data.IsPlaceholder then
                    element.PlaceholderText = GetText(data.Key)
                else
                    if data.Key == "OptSelected" then
                        element.Text = GetText("OptSelected") .. (TrollState.SelectedTarget and TrollState.SelectedTarget.DisplayName or GetText("PlayerEmpty"))
                    else
                        element.Text = GetText(data.Key)
                    end
                end
            end
        end)
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
TitleText.Position = UDim2.new(0, 15, 0, 3)
TitleText.Size = UDim2.new(1, -120, 0, 18)
TitleText.Font = Enum.Font.GothamBold
RegisterForTranslation(TitleText, "Title")
TitleText.TextColor3 = CurrentTheme.Accent
TitleText.TextSize = 13
TitleText.TextXAlignment = Enum.TextXAlignment.Left
RegisterForRecolor(TitleText, "TextColor3")

local SubTitleText = Instance.new("TextLabel", TitleBar)
SubTitleText.BackgroundTransparency = 1
SubTitleText.Position = UDim2.new(0, 15, 0, 18)
SubTitleText.Size = UDim2.new(1, -120, 0, 15)
SubTitleText.Font = Enum.Font.GothamSemibold
RegisterForTranslation(SubTitleText, "Subtitle")
SubTitleText.TextColor3 = Color3.fromRGB(140, 140, 145)
SubTitleText.TextSize = 10
SubTitleText.TextXAlignment = Enum.TextXAlignment.Left

local LangBtn = Instance.new("TextButton", TitleBar)
LangBtn.Name = "LangBtn"
LangBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
LangBtn.Size = UDim2.new(0, 35, 0, 22)
LangBtn.Position = UDim2.new(1, -75, 0.5, -11)
LangBtn.Font = Enum.Font.GothamBold
LangBtn.Text = "ENG"
LangBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
LangBtn.TextSize = 10
Instance.new("UICorner", LangBtn).CornerRadius = UDim.new(0, 5)

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

local function MakeDraggable(dragArea, frameToMove, isIsland)
    local dragging, dragStart, startPos
    local totalDragDistance = 0

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frameToMove.Position
            totalDragDistance = 0
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            totalDragDistance = totalDragDistance + delta.Magnitude
            frameToMove.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X, 
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
            if isIsland and totalDragDistance < 5 then
                IslandFrame.Visible = false
                MainFrame.Position = UDim2.new(
                    0, IslandFrame.AbsolutePosition.X - 100, 
                    0, IslandFrame.AbsolutePosition.Y - 150
                )
                MainFrame.Visible = true
            end
        end
    end)
end

MakeDraggable(TitleBar, MainFrame, false)
MakeDraggable(IslandClicker, IslandFrame, true)

MinimizeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    IslandFrame.Position = UDim2.new(
        0, MainFrame.AbsolutePosition.X + 220, 
        0, MainFrame.AbsolutePosition.Y + 180
    )
    IslandFrame.Visible = true
    Notify(GetText("NotifyMinimizeTitle"), GetText("NotifyMinimizeDesc"), CurrentTheme.Accent)
end)

LangBtn.MouseButton1Click:Connect(function()
    if Language == "RU" then
        Language = "ENG"
        LangBtn.Text = "RU"
    else
        Language = "RU"
        LangBtn.Text = "ENG"
    end
    TranslateAll()
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

local TabMainBtn = CreateTabButton("", MainPage, 15)
RegisterForTranslation(TabMainBtn, "TabMain")
local TabInfoBtn = CreateTabButton("", InfoPage, 60)
RegisterForTranslation(TabInfoBtn, "TabInfo")

local function CreateSection(parent, textKey)
    local Lbl = Instance.new("TextLabel", parent)
    Lbl.BackgroundTransparency = 1
    Lbl.Size = UDim2.new(1, 0, 0, 25)
    Lbl.Font = Enum.Font.GothamBold
    RegisterForTranslation(Lbl, textKey)
    Lbl.TextColor3 = CurrentTheme.Accent
    Lbl.TextSize = 13
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
    RegisterForTranslation(Lbl, textKey)
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
    Lbl.Text = GetText(textKey) .. ": " .. default
    Lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    Lbl.TextSize = 12
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    table.insert(RecolorQueue, function()
        pcall(function()
            local currentVal = string.match(Lbl.Text, "%d+$") or default
            Lbl.Text = GetText(textKey) .. ": " .. currentVal
        end)
    end)

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
        Lbl.Text = GetText(textKey) .. ": " .. value
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

local function CreateButton(parent, textKey, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.Font = Enum.Font.GothamBold
    RegisterForTranslation(Btn, textKey)
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

local function CreateTextBox(parent, placeholderKey, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local Box = Instance.new("TextBox", Frame)
    Box.BackgroundTransparency = 1
    Box.Size = UDim2.new(1, -20, 1, 0)
    Box.Position = UDim2.new(0, 10, 0, 0)
    Box.Font = Enum.Font.Gotham
    RegisterForTranslation(Box, placeholderKey, true)
    Box.Text = ""
    Box.TextColor3 = Color3.fromRGB(255, 255, 255)
    Box.TextSize = 12
    Box.TextXAlignment = Enum.TextXAlignment.Left

    Box.FocusLost:Connect(function() callback(Box.Text) end)
end

local function ApplyUIPositionAndScale()
    pcall(function()
        local Scale = Instance.new("UIScale", ScreenGui)
        Scale.Scale = ScaleFactor
    end)
end

local function CreatePlayerDropdown(parent, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Size = UDim2.new(1, 0, 1, 0)
    MainBtn.Font = Enum.Font.GothamSemibold
    MainBtn.Text = GetText("OptSelect")
    MainBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    MainBtn.TextSize = 12
    RegisterForTranslation(MainBtn, "OptSelected")

    MainBtn.MouseButton1Click:Connect(function()
        if DropdownFrame then DropdownFrame:Destroy() DropdownFrame = nil return end

        DropdownFrame = Instance.new("Frame", ScreenGui)
        DropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        DropdownFrame.BorderSizePixel = 1
        DropdownFrame.BorderColor3 = CurrentTheme.Accent
        DropdownFrame.Size = UDim2.new(0, 200 * ScaleFactor, 0, 150 * ScaleFactor)
        
        local screenPos = MainBtn.AbsolutePosition
        DropdownFrame.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y + (38 * ScaleFactor))
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
                    MainBtn.Text = GetText("OptSelected") .. player.DisplayName
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
    MainBtn.Text = GetText("OptDropdownTheme")
    MainBtn.TextColor3 = CurrentTheme.Accent
    MainBtn.TextSize = 12
    RegisterForTranslation(MainBtn, "OptDropdownTheme")
    RegisterForRecolor(MainBtn, "TextColor3")

    MainBtn.MouseButton1Click:Connect(function()
        if ThemeDropdownFrame then ThemeDropdownFrame:Destroy() ThemeDropdownFrame = nil return end

        ThemeDropdownFrame = Instance.new("Frame", ScreenGui)
        ThemeDropdownFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
        ThemeDropdownFrame.BorderSizePixel = 1
        ThemeDropdownFrame.BorderColor3 = CurrentTheme.Accent
        ThemeDropdownFrame.Size = UDim2.new(0, 180 * ScaleFactor, 0, 130 * ScaleFactor)

        local screenPos = MainBtn.AbsolutePosition
        ThemeDropdownFrame.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y - (135 * ScaleFactor))
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
                Notify(GetText("NotifyThemeTitle"), GetText("NotifyThemeDesc") .. theme.Name, theme.Accent)
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
        Notify(GetText("NotifyMinimizeTitle"), GetText("NotifyTargetErr"), Color3.fromRGB(255, 0, 0))
        return
    end

    local oldPos = myHrp.CFrame
    TrollState.FlingActive = true
    
    Notify("FE Fling", string.format(GetText("NotifyFlingStart"), target.DisplayName), CurrentTheme.Accent)

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
        Notify(GetText("NotifyFlingTitle"), GetText("NotifyFlingEnd"), CurrentTheme.Accent)
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
                    hrp.AssemblyLinearVelocity = tHrp.AssemblyLinearVelocity
                    hrp.AssemblyAngularVelocity = tHrp.AssemblyAngularVelocity
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
                        hrp.CFrame = thrp.CFrame * CFrame.new(0, 0.15, offset) * CFrame.Angles(math.rad(10 + (thrust * 15)), 0, 0)
                    elseif TrollState.AttachMode == "Front" then
                        offset = -1.2 + (thrust * 0.75)
                        hrp.CFrame = thrp.CFrame * CFrame.new(0, 1.55, offset) * CFrame.Angles(math.rad(-30 + (thrust * 20)), math.rad(180), 0)
                    elseif TrollState.AttachMode == "Victim" then
                        offset = 0.5 - (thrust * 0.4)
                        hrp.CFrame = thrp.CFrame * CFrame.new(0, -1.2, offset) * CFrame.Angles(math.rad(-90), 0, 0)
                    end
                    
                    hrp.AssemblyLinearVelocity = thrp.AssemblyLinearVelocity
                    hrp.AssemblyAngularVelocity = thrp.AssemblyAngularVelocity
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
                    Notify("God Mode", GetText("NotifyGodMode"), CurrentTheme.Accent)
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

CreateSection(MainPage, "SecMovement")
CreateToggle(MainPage, "OptEgor", function(state) TrollState.EgorSpeed = state end)
CreateToggle(MainPage, "OptLagFPS", function(state) TrollState.FakeLagFPS = state end)
CreateSlider(MainPage, "OptLagFPSVal", 1, 100, 10, function(val) TrollState.LagFPSValue = val end)
CreateToggle(MainPage, "OptLagNet", function(state) TrollState.FakeLagNet = state end)

CreateSection(MainPage, "SecTroll")
CreateToggle(MainPage, "OptSpin", function(state) TrollState.Spin = state end)
CreateSlider(MainPage, "OptSpinSpeed", 1, 100, 10, function(val) TrollState.SpinSpeed = val end)

CreateSection(MainPage, "SecDestroy")

CreatePlayerDropdown(MainPage, function(player)
    TranslateAll()
end)

CreateButton(MainPage, "BtnFling", function()
    StopAllActions()
    local target = TrollState.SelectedTarget
    if target then 
        RunOrbitFling(target) 
    else 
        Notify(GetText("NotifyStopTitle"), GetText("NotifyTargetErr"), Color3.fromRGB(255, 0, 0)) 
    end
end)

CreateToggle(MainPage, "ToggleRage", function(state)
    StopAllActions()
    local target = TrollState.SelectedTarget
    if target then
        TrollState.RageQuitActive = state
        if state then
            Notify("Rage Quit", GetText("NotifyRageActive"), Color3.fromRGB(255, 60, 60))
        end
    else
        Notify(GetText("NotifyStopTitle"), GetText("NotifyTargetErr"), Color3.fromRGB(255, 0, 0))
    end
end)

CreateButton(MainPage, "BtnFreeze", function()
    local target = TrollState.SelectedTarget
    if target then
        TrollState.FreezeTarget = target
        TrollState.FreezePos = nil
        Notify("Freeze", string.format(GetText("NotifyFreeze"), target.DisplayName), CurrentTheme.Accent)
    else Notify(GetText("NotifyStopTitle"), GetText("NotifyTargetSelectErr"), Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "BtnSpinTarget", function()
    local target = TrollState.SelectedTarget
    if target then
        TrollState.SpinTarget = target
        Notify("Spin", string.format(GetText("NotifySpin"), target.DisplayName), CurrentTheme.Accent)
    else Notify(GetText("NotifyStopTitle"), GetText("NotifyTargetSelectErr"), Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "BtnTp", function()
    local target = TrollState.SelectedTarget
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
            Notify("Teleport", GetText("NotifyTeleportOk") .. target.DisplayName, CurrentTheme.Accent)
        end
    else Notify(GetText("NotifyStopTitle"), GetText("NotifyTeleportErr"), Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "BtnLoopKill", function()
    local target = TrollState.SelectedTarget
    if target then
        TrollState.LoopKillTarget = target
        TrollState.LoopKill = true
        Notify("Loop Kill", string.format(GetText("NotifyLoopKill"), target.DisplayName), Color3.fromRGB(255, 0, 0))
    else Notify(GetText("NotifyStopTitle"), GetText("NotifyTargetSelectErr"), Color3.fromRGB(255, 0, 0)) end
end)

CreateSection(MainPage, "Sec18")

CreateButton(MainPage, "BtnSexBack", function()
    StopAllActions()
    local target = TrollState.SelectedTarget
    if target then
        TrollState.AttachTarget = target
        TrollState.AttachMode = "Back"
        ApplyEjaculationFX()
        Notify("Sex", string.format(GetText("NotifySexBack"), target.DisplayName), Color3.fromRGB(255, 50, 150))
    else Notify(GetText("NotifyStopTitle"), GetText("NotifyTargetSelectErr"), Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "BtnSexFront", function()
    StopAllActions()
    local target = TrollState.SelectedTarget
    if target then
        TrollState.AttachTarget = target
        TrollState.AttachMode = "Front"
        ApplyEjaculationFX()
        Notify("Head", string.format(GetText("NotifySexFront"), target.DisplayName), Color3.fromRGB(255, 50, 150))
    else Notify(GetText("NotifyStopTitle"), GetText("NotifyTargetSelectErr"), Color3.fromRGB(255, 0, 0)) end
end)

CreateButton(MainPage, "BtnVictim", function()
    StopAllActions()
    local target = TrollState.SelectedTarget
    if target then
        TrollState.AttachTarget = target
        TrollState.AttachMode = "Victim"
        ApplyEjaculationFX()
        Notify("Victim", string.format(GetText("NotifySexVictim"), target.DisplayName), Color3.fromRGB(255, 120, 0))
    else
        Notify(GetText("NotifyStopTitle"), GetText("NotifyTargetSelectErr"), Color3.fromRGB(255, 0, 0))
    end
end)

CreateSection(MainPage, "SecOwn")

CreateToggle(MainPage, "OptGod", function(state) 
    TrollState.GodMode = state 
    if not state then
        Notify("God Mode", GetText("NotifyGodModeOff"), CurrentTheme.Accent)
    end
end)
CreateToggle(MainPage, "OptNoclip", function(state) TrollState.Noclip = state end)
CreateToggle(MainPage, "OptFly", function(state) 
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
CreateSlider(MainPage, "OptFlySpeed", 20, 200, 50, function(val) TrollState.FlySpeed = val end)

CreateToggle(MainPage, "OptAura", function(state) TrollState.KillAura = state end)
CreateSlider(MainPage, "OptAuraRange", 5, 50, 15, function(val) TrollState.KillAuraRange = val end)

CreateToggle(MainPage, "OptSpam", function(state) TrollState.ChatSpam = state end)
CreateTextBox(MainPage, "PlaceholderSpam", function(text) TrollState.ChatSpamText = text end)

CreateButton(MainPage, "BtnStopAll", function()
    StopAllActions()
    TrollState.FreezeTarget = nil
    TrollState.FreezePos = nil
    TrollState.SpinTarget = nil
    TrollState.LoopKill = false
    TrollState.LoopKillTarget = nil
    TrollState.KillAura = false
    TrollState.ChatSpam = false
    Notify(GetText("NotifyStopTitle"), GetText("NotifyStop"), Color3.fromRGB(255, 255, 255))
end)

CreateSection(MainPage, "SecVisual")
CreateSlider(MainPage, "OptScale", 5, 15, 10, function(val)
    ScaleFactor = val / 10
    ApplyUIPositionAndScale()
end)
CreateThemeDropdown(MainPage)

local InfoLabels = {
    "InfoAuthor", "InfoName", "InfoLine1", "InfoLine2", "InfoLine3", "InfoLine4", "InfoLine5", "InfoLine6", "InfoLine7"
}

for _, labelKey in ipairs(InfoLabels) do
    local label = Instance.new("TextLabel", InfoPage)
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, -10, 0, 20)
    label.Font = Enum.Font.Gotham
    RegisterForTranslation(label, labelKey)
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
end

TranslateAll()
ApplyUIPositionAndScale()

--[[ HUB - MM2 & MMV (V3.5 STRICT ULTIMATE - MOBILE & PC ULTRA FIXED) ]]

-- Предотвращение дублирования GUI (удаляем прошлую запущенную копию скрипта)
if game:GetService("CoreGui"):FindFirstChild("HUB_GUI_STRICT") then
    game:GetService("CoreGui").HUB_GUI_STRICT:Destroy()
end

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer

-- Глобальные переменные темы
local accentColor = Color3.fromRGB(255, 215, 0)
local isRGBMode = false

-- Базовая инициализация GUI
local gui = Instance.new("ScreenGui") 
gui.Name = "HUB_GUI_STRICT" 
gui.ResetOnSpawn = false 
gui.Parent = (gethui and gethui()) or CoreGui

-- ==========================================
-- СИСТЕМА ДРАГГИНГА (АДАПТИРОВАНА ПОД СЕНСОР И МЫШЬ)
-- ==========================================
local function makeDraggable(handle, target)
    target = target or handle
    local dragToggle = false
    local dragStart, startPos
    
    handle.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = target.Position
            
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                    connection:Disconnect()
                end
            end)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- ==========================================
-- СТАРТОВЫЙ ЭКРАН ВЫБОРА ТЕМЫ
-- ==========================================
local startupFrame = Instance.new("Frame")
startupFrame.Size = UDim2.new(0, 300, 0, 150)
startupFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
startupFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
startupFrame.Parent = gui
Instance.new("UICorner", startupFrame).CornerRadius = UDim.new(0, 8)
local startupStroke = Instance.new("UIStroke", startupFrame)
startupStroke.Color = Color3.fromRGB(255, 215, 0)
startupStroke.Thickness = 1.5

local startupTitle = Instance.new("TextLabel")
startupTitle.Size = UDim2.new(1, 0, 0, 40)
startupTitle.BackgroundTransparency = 1
startupTitle.Text = "SELECT MM2 & MMV THEME"
startupTitle.TextColor3 = Color3.fromRGB(255, 215, 0)
startupTitle.Font = Enum.Font.GothamBold
startupTitle.TextSize = 13
startupTitle.Parent = startupFrame

local btnYellow = Instance.new("TextButton")
btnYellow.Size = UDim2.new(0.8, 0, 0, 35)
btnYellow.Position = UDim2.new(0.1, 0, 0, 50)
btnYellow.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
btnYellow.Text = "Signature (Yellow/Black)"
btnYellow.TextColor3 = Color3.fromRGB(255, 215, 0)
btnYellow.Font = Enum.Font.GothamBold
btnYellow.TextSize = 12
btnYellow.Parent = startupFrame
Instance.new("UICorner", btnYellow).CornerRadius = UDim.new(0, 4)

local btnRGB = Instance.new("TextButton")
btnRGB.Size = UDim2.new(0.8, 0, 0, 35)
btnRGB.Position = UDim2.new(0.1, 0, 0, 95)
btnRGB.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
btnRGB.Text = "Chroma (RGB Mode)"
btnRGB.TextColor3 = Color3.fromRGB(200, 200, 200)
btnRGB.Font = Enum.Font.GothamBold
btnRGB.TextSize = 12
btnRGB.Parent = startupFrame
Instance.new("UICorner", btnRGB).CornerRadius = UDim.new(0, 4)

makeDraggable(startupFrame)

-- ==========================================
-- ОСНОВНЫЕ ЭЛЕМЕНТЫ ИНТЕРФЕЙСА
-- ==========================================
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 540, 0, 430) 
main.Position = UDim2.new(0.5, -270, 0.5, -215) 
main.BackgroundColor3 = Color3.fromRGB(15,15,18) 
main.ClipsDescendants = true 
main.Visible = false 
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,8) 
local mainStroke = Instance.new("UIStroke", main) 
mainStroke.Color = accentColor 
mainStroke.Thickness = 1.5

-- Dynamic Island (Кнопка сворачивания)
local island = Instance.new("TextButton")
island.Size = UDim2.new(0, 160, 0, 35) 
island.Position = UDim2.new(0.5, -80, 0, 15) 
island.BackgroundColor3 = Color3.fromRGB(10,10,12) 
island.Text = "" 
island.Visible = false 
island.ClipsDescendants = true 
island.Parent = gui
Instance.new("UICorner", island).CornerRadius = UDim.new(1,0)
local islandStroke = Instance.new("UIStroke", island) 
islandStroke.Color = accentColor 
islandStroke.Thickness = 1.5
local islandText = Instance.new("TextLabel") 
islandText.Size = UDim2.new(1,0,1,0) 
islandText.BackgroundTransparency = 1 
islandText.Text = "HUB Active" 
islandText.TextColor3 = Color3.new(1,1,1) 
islandText.Font = Enum.Font.GothamBold 
islandText.TextSize = 12 
islandText.Parent = island

makeDraggable(island)

btnYellow.MouseButton1Click:Connect(function() isRGBMode=false accentColor=Color3.fromRGB(255,215,0) startupFrame:Destroy() main.Visible=true end)
btnRGB.MouseButton1Click:Connect(function() isRGBMode=true startupFrame:Destroy() main.Visible=true end)

-- Шапка
local header = Instance.new("Frame") 
header.Size = UDim2.new(1,0,0,35) 
header.BackgroundColor3 = Color3.fromRGB(20,20,25) 
header.Parent = main
makeDraggable(header, main)

local title = Instance.new("TextLabel") 
title.Size = UDim2.new(1,-100,1,0) 
title.Position = UDim2.new(0,15,0,0) 
title.BackgroundTransparency = 1 
title.Text = "HUB - MM2 & MMV" 
title.TextColor3 = accentColor 
title.TextSize = 14 
title.Font = Enum.Font.GothamBold 
title.TextXAlignment = Enum.TextXAlignment.Left 
title.Parent = header

local minimizeBtn = Instance.new("TextButton") minimizeBtn.Size=UDim2.new(0,35,1,0) minimizeBtn.Position=UDim2.new(1,-70,0,0) minimizeBtn.BackgroundTransparency=1 minimizeBtn.Text="M" minimizeBtn.TextColor3=Color3.fromRGB(200,200,200) minimizeBtn.TextSize=14 minimizeBtn.Font=Enum.Font.GothamBold minimizeBtn.Parent=header
local closeBtn = Instance.new("TextButton") closeBtn.Size=UDim2.new(0,35,1,0) closeBtn.Position=UDim2.new(1,-35,0,0) closeBtn.BackgroundTransparency=1 closeBtn.Text="X" closeBtn.TextColor3=Color3.fromRGB(255,50,50) closeBtn.TextSize=14 closeBtn.Font=Enum.Font.GothamBold closeBtn.Parent=header

minimizeBtn.MouseButton1Click:Connect(function() TweenService:Create(main,TweenInfo.new(0.3,Enum.EasingStyle.Back,Enum.EasingDirection.In),{Size=UDim2.new(0,0,0,0)}):Play() task.wait(0.2) main.Visible=false island.Visible=true island.Size=UDim2.new(0,0,0,35) TweenService:Create(island,TweenInfo.new(0.4,Enum.EasingStyle.Bounce),{Size=UDim2.new(0,160,0,35)}):Play() end)
island.MouseButton1Click:Connect(function() TweenService:Create(island,TweenInfo.new(0.2),{Size=UDim2.new(0,0,0,35)}):Play() task.wait(0.15) island.Visible=false main.Visible=true TweenService:Create(main,TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,540,0,430)}):Play() end)
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Система вкладок (Tabs)
local tabBtns = Instance.new("ScrollingFrame") tabBtns.Size=UDim2.new(0,140,1,-35) tabBtns.Position=UDim2.new(0,0,0,35) tabBtns.BackgroundColor3=Color3.fromRGB(18,18,22) tabBtns.ScrollBarThickness=2 tabBtns.Parent=main Instance.new("UIListLayout", tabBtns)
local content = Instance.new("Frame") content.Size=UDim2.new(1,-140,1,-35) content.Position=UDim2.new(0,140,0,35) content.BackgroundTransparency=1 content.Parent=main
local tabs = {}
local rgbElements = { Text = {}, Background = {}, Stroke = {mainStroke, islandStroke, title, islandText} }

local function createTab(name)
    local btn = Instance.new("TextButton") btn.Size=UDim2.new(1,0,0,35) btn.BackgroundTransparency=1 btn.Text="  "..name btn.TextColor3=Color3.fromRGB(150,150,150) btn.TextSize=12 btn.Font=Enum.Font.GothamBold btn.TextXAlignment=Enum.TextXAlignment.Left btn.Parent=tabBtns
    local page = Instance.new("ScrollingFrame") page.Size=UDim2.new(1,-10,1,-10) page.Position=UDim2.new(0,5,0,5) page.BackgroundTransparency=1 page.ScrollBarThickness=2 page.Visible=false page.Parent=content
    local list = Instance.new("UIListLayout") list.Parent=page list.Padding=UDim.new(0,5) list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() page.CanvasSize=UDim2.new(0,0,0,list.AbsoluteContentSize.Y+10) end)
    table.insert(tabs, {Btn=btn, Page=page})
    btn.MouseButton1Click:Connect(function() for _,t in pairs(tabs) do t.Page.Visible=false t.Btn.TextColor3=Color3.fromRGB(150,150,150) end page.Visible=true btn.TextColor3=accentColor end)
    table.insert(rgbElements.Text, btn)
    return page
end

-- Вспомогательные элементы UI (Helpers)
local function addLabel(parent, text)
    local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,0,0,20) lbl.BackgroundTransparency=1 lbl.Text=text lbl.TextColor3=accentColor lbl.TextSize=12 lbl.Font=Enum.Font.GothamBold lbl.TextXAlignment=Enum.TextXAlignment.Center lbl.Parent=parent
    table.insert(rgbElements.Text, lbl)
    return lbl
end

local function addStaticColoredLabel(parent, text, color)
    local lbl = Instance.new("TextLabel") lbl.Size=UDim2.new(1,0,0,25) lbl.BackgroundTransparency=1 lbl.Text=text lbl.TextColor3=color lbl.TextSize=13 lbl.Font=Enum.Font.GothamBlack lbl.TextXAlignment=Enum.TextXAlignment.Center lbl.Parent=parent
    return lbl
end

local function addButton(parent, text, cb)
    local btn = Instance.new("TextButton") btn.Size=UDim2.new(1,0,0,32) btn.BackgroundColor3=Color3.fromRGB(25,25,30) btn.Text=text btn.TextColor3=Color3.fromRGB(220,220,220) btn.TextSize=12 btn.Font=Enum.Font.Gotham btn.Parent=parent
    Instance.new("UICorner", btn).CornerRadius=UDim.new(0,4) btn.MouseButton1Click:Connect(function() pcall(cb) end) return btn
end

local function addToggle(parent, text, default, cb)
    local frame = Instance.new("Frame") frame.Size=UDim2.new(1,0,0,30) frame.BackgroundTransparency=1 frame.Parent=parent
    local btn = Instance.new("TextButton") btn.Size=UDim2.new(0,24,0,24) btn.Position=UDim2.new(0,5,0,3) btn.BackgroundColor3=default and accentColor or Color3.fromRGB(40,40,45) btn.Text="" btn.Parent=frame Instance.new("UICorner", btn).CornerRadius=UDim.new(0,4)
    local label = Instance.new("TextLabel") label.Size=UDim2.new(1,-40,1,0) label.Position=UDim2.new(0,35,0,0) label.BackgroundTransparency=1 label.Text=text label.TextColor3=Color3.fromRGB(200,200,200) label.TextSize=12 label.Font=Enum.Font.Gotham label.TextXAlignment=Enum.TextXAlignment.Left label.Parent=frame
    local enabled = default
    table.insert(rgbElements.Background, btn)
    btn.MouseButton1Click:Connect(function() enabled=not enabled btn.BackgroundColor3=enabled and accentColor or Color3.fromRGB(40,40,45) cb(enabled) end)
    if default then task.spawn(function() cb(true) end) end
    return function() return enabled end
end

local function addSlider(parent, text, min, max, default, cb)
    local frame = Instance.new("Frame") frame.Size=UDim2.new(1,0,0,40) frame.BackgroundTransparency=1 frame.Parent=parent
    local label = Instance.new("TextLabel") label.Size=UDim2.new(1,0,0,16) label.BackgroundTransparency=1 label.Text=text..": "..default label.TextColor3=Color3.fromRGB(200,200,200) label.TextSize=11 label.Font=Enum.Font.Gotham label.TextXAlignment=Enum.TextXAlignment.Left label.Parent=frame
    local track = Instance.new("Frame") track.Size=UDim2.new(1,0,0,6) track.Position=UDim2.new(0,0,0,20) track.BackgroundColor3=Color3.fromRGB(40,40,45) track.Parent=frame Instance.new("UICorner", track).CornerRadius=UDim.new(0,3)
    local fill = Instance.new("Frame") fill.Size=UDim2.new((default-min)/(max-min),0,1,0) fill.BackgroundColor3=accentColor fill.Parent=track Instance.new("UICorner", fill).CornerRadius=UDim.new(0,3)
    table.insert(rgbElements.Background, fill)
    local dragging = false
    local function update(val) val=math.clamp(math.floor(val*10)/10,min,max) fill.Size=UDim2.new((val-min)/(max-min),0,1,0) label.Text=text..": "..val cb(val) end
    track.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=true local pos=(i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X update(min+(max-min)*pos) end end)
    UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end)
    UserInputService.InputChanged:Connect(function(i) if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local pos=math.clamp((i.Position.X-track.AbsolutePosition.X)/track.AbsoluteSize.X,0,1) update(min+(max-min)*pos) end end)
    cb(default)
end

local function addTextBox(parent, placeholder, cb)
    local box = Instance.new("TextBox") box.Size=UDim2.new(1,0,0,32) box.BackgroundColor3=Color3.fromRGB(25,25,30) box.PlaceholderText=placeholder box.Text="" box.TextColor3=Color3.fromRGB(200,200,200) box.TextSize=12 box.Font=Enum.Font.Gotham box.Parent=parent
    Instance.new("UICorner", box).CornerRadius=UDim.new(0,4)
    box.FocusLost:Connect(function(ep) if ep then cb(box.Text) end end) return box
end

-- Цикл изменения цвета в режиме Chroma (RGB Mode)
RunService.RenderStepped:Connect(function()
    if isRGBMode then
        local hue = tick() % 5 / 5
        accentColor = Color3.fromHSV(hue, 1, 1)
        for _, obj in pairs(rgbElements.Stroke) do if obj and obj.Parent then if obj:IsA("UIStroke") then obj.Color = accentColor elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then obj.TextColor3 = accentColor end end end
        for _, obj in pairs(rgbElements.Background) do if obj and obj.Parent and obj.BackgroundColor3 ~= Color3.fromRGB(40,40,45) then obj.BackgroundColor3 = accentColor end end
        for _, obj in pairs(tabs) do if obj.Page.Visible then obj.Btn.TextColor3 = accentColor end end
    elseif not isRGBMode and accentColor ~= Color3.fromRGB(255, 215, 0) then
        accentColor = Color3.fromRGB(255, 215, 0)
        for _, obj in pairs(rgbElements.Stroke) do if obj and obj.Parent then if obj:IsA("UIStroke") then obj.Color = accentColor elseif obj:IsA("TextLabel") or obj:IsA("TextButton") then obj.TextColor3 = accentColor end end end
        for _, obj in pairs(rgbElements.Background) do if obj and obj.Parent and obj.BackgroundColor3 ~= Color3.fromRGB(40,40,45) then obj.BackgroundColor3 = accentColor end end
        for _, obj in pairs(tabs) do if obj.Page.Visible then obj.Btn.TextColor3 = accentColor end end
    end
end)

-- Кастомные локальные оповещения (Notifications)
local function notify(ttl,msg,dur)
    dur = dur or 3
    local ng = Instance.new("ScreenGui") ng.Parent=CoreGui
    local f = Instance.new("Frame") f.Size=UDim2.new(0,220,0,55) f.Position=UDim2.new(1,10,1,-70) f.BackgroundColor3=Color3.fromRGB(20,20,25) f.Parent=ng Instance.new("UICorner",f).CornerRadius=UDim.new(0,6)
    local s = Instance.new("UIStroke",f) s.Color=accentColor s.Thickness=1.5
    local t = Instance.new("TextLabel") t.Size=UDim2.new(1,-10,0,20) t.Position=UDim2.new(0,5,0,5) t.BackgroundTransparency=1 t.Text=ttl t.TextColor3=accentColor t.TextSize=12 t.Font=Enum.Font.GothamBold t.Parent=f
    local d = Instance.new("TextLabel") d.Size=UDim2.new(1,-10,0,25) d.Position=UDim2.new(0,5,0,25) d.BackgroundTransparency=1 d.Text=msg d.TextColor3=Color3.fromRGB(180,180,180) d.TextSize=11 d.TextWrapped=true d.Font=Enum.Font.Gotham d.Parent=f
    TweenService:Create(f, TweenInfo.new(0.3), {Position=UDim2.new(1,-230,1,-70)}):Play()
    task.delay(dur, function() TweenService:Create(f, TweenInfo.new(0.3), {Position=UDim2.new(1,10,1,-70)}):Play() task.wait(0.3) ng:Destroy() end)
    if isRGBMode then table.insert(rgbElements.Stroke, s) table.insert(rgbElements.Stroke, t) end
end

-- ==========================================
-- ИГРОВАЯ ЛОГИКА И ОПРЕДЕЛЕНИЕ РОЛЕЙ
-- ==========================================

local function getRole(player)
    if not player or not player.Character then return "Innocent" end
    local hasKnife = player.Character:FindFirstChild("Knife") or (player.Backpack and player.Backpack:FindFirstChild("Knife"))
    local hasGun = player.Character:FindFirstChild("Gun") or (player.Backpack and player.Backpack:FindFirstChild("Gun"))
    if hasKnife then return "Murderer" elseif hasGun then return "Sheriff" else return "Innocent" end
end

local function getPlayer(name)
    name = name:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower():sub(1, #name) == name or (p.DisplayName and p.DisplayName:lower():sub(1, #name) == name) then return p end
    end return nil
end

-- Панель быстрого действия при нажатии на интерактивный круг
local quickMenu = Instance.new("Frame")
quickMenu.Size = UDim2.new(0, 180, 0, 110)
quickMenu.Position = UDim2.new(0.5, -90, 0.4, -55)
quickMenu.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
quickMenu.Visible = false
quickMenu.Parent = gui
Instance.new("UICorner", quickMenu).CornerRadius = UDim.new(0, 6)
local qStroke = Instance.new("UIStroke", quickMenu)
qStroke.Color = accentColor
qStroke.Thickness = 1.5
table.insert(rgbElements.Stroke, qStroke)

local qTitle = Instance.new("TextLabel")
qTitle.Size = UDim2.new(1, 0, 0, 25)
qTitle.BackgroundTransparency = 1
qTitle.Text = "PLAYER ACTIONS"
qTitle.TextColor3 = Color3.fromRGB(230, 230, 230)
qTitle.Font = Enum.Font.GothamBold
qTitle.TextSize = 11
qTitle.Parent = quickMenu

local qClose = Instance.new("TextButton")
qClose.Size = UDim2.new(0, 25, 0, 25)
qClose.Position = UDim2.new(1, -25, 0, 0)
qClose.BackgroundTransparency = 1
qClose.Text = "×"
qClose.TextColor3 = Color3.fromRGB(255, 50, 50)
qClose.TextSize = 16
qClose.Font = Enum.Font.GothamBold
qClose.Parent = quickMenu
qClose.MouseButton1Click:Connect(function() quickMenu.Visible = false end)

local qFling = Instance.new("TextButton")
qFling.Size = UDim2.new(0.9, 0, 0, 30)
qFling.Position = UDim2.new(0.05, 0, 0, 32)
qFling.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
qFling.Text = "Fling Player"
qFling.TextColor3 = Color3.fromRGB(220, 220, 220)
qFling.Font = Enum.Font.Gotham
qFling.TextSize = 11
qFling.Parent = quickMenu
Instance.new("UICorner", qFling).CornerRadius = UDim.new(0, 4)

local qKillM = Instance.new("TextButton")
qKillM.Size = UDim2.new(0.9, 0, 0, 30)
qKillM.Position = UDim2.new(0.05, 0, 0, 68)
qKillM.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
qKillM.Text = "Kill Murderer Instantly"
qKillM.TextColor3 = Color3.fromRGB(255, 100, 100)
qKillM.Font = Enum.Font.GothamBold
qKillM.TextSize = 11
qKillM.Parent = quickMenu
Instance.new("UICorner", qKillM).CornerRadius = UDim.new(0, 4)

local actionTargetPlayer = nil
local doFling -- Декларируем метод флинга

-- ==========================================
-- TABS & FEATURES
-- ==========================================

-- 1. Вкладка ESP
local espTab = createTab("ESP Visuals")
local espData = {master=false, outlines=true, names=true, tracers=false, gunDrop=true, interactiveCircles=false}
addLabel(espTab, "Player ESP Settings")
addToggle(espTab, "Master Switch (Players)", false, function(v) espData.master=v end)
addToggle(espTab, "Highlight (Outlines)", true, function(v) espData.outlines=v end)
addToggle(espTab, "Nicknames and Roles", true, function(v) espData.names=v end)
addToggle(espTab, "Tracers (Lines)", false, function(v) espData.tracers=v end)
addToggle(espTab, "Gun Drop ESP", true, function(v) espData.gunDrop=v end)
addToggle(espTab, "Interactive Action Circles", false, function(v) espData.interactiveCircles=v end)

-- Стабильный кэш рендера ESP
local espFolder = Instance.new("Folder") espFolder.Name = "HUB_ESP" espFolder.Parent = CoreGui
local activeHighlights = {}

RunService.RenderStepped:Connect(function()
    pcall(function()
        if not espData.master and not espData.tracers and not espData.gunDrop and not espData.interactiveCircles then
            espFolder:ClearAllChildren()
            table.clear(activeHighlights)
            return
        end
        
        local cam = Workspace.CurrentCamera
        
        -- Очистка невалидных хитбоксов и обводок в кэше
        for player, hl in pairs(activeHighlights) do
            if not player or not player.Parent or not player.Character or not player.Character.Parent then
                if hl then hl:Destroy() end
                activeHighlights[player] = nil
            end
        end

        -- Сверхстабильный поиск и рендер Gun Drop ESP
        if espData.gunDrop then
            local gunDrop = nil
            -- Глубокий рекурсивный поиск во избежание сброса объекта MM2
            for _, desc in ipairs(Workspace:GetDescendants()) do
                if desc:IsA("Model") and (desc.Name == "GunDrop" or desc.Name == "Pickup_Gun") then
                    gunDrop = desc
                    break
                elseif desc:IsA("BasePart") and desc.Name == "GunDrop" then
                    gunDrop = desc
                    break
                end
            end

            if gunDrop then
                local gHl = espFolder:FindFirstChild("GunDrop_HL")
                if not gHl then
                    gHl = Instance.new("Highlight")
                    gHl.Name = "GunDrop_HL"
                    gHl.Adornee = gunDrop
                    gHl.FillColor = Color3.fromRGB(0, 255, 255)
                    gHl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    gHl.FillTransparency = 0.3
                    gHl.OutlineTransparency = 0
                    gHl.Parent = espFolder
                else
                    gHl.Adornee = gunDrop
                end

                local gBill = espFolder:FindFirstChild("GunDrop_Bill")
                local targetAdornee = gunDrop:IsA("Model") and (gunDrop:FindFirstChildOfClass("MeshPart") or gunDrop:FindFirstChildOfClass("Part") or gunDrop.PrimaryPart) or gunDrop
                if targetAdornee and not gBill then
                    gBill = Instance.new("BillboardGui")
                    gBill.Name = "GunDrop_Bill"
                    gBill.AlwaysOnTop = true
                    gBill.Size = UDim2.new(0, 150, 0, 30)
                    gBill.Adornee = targetAdornee
                    local lbl = Instance.new("TextLabel")
                    lbl.Size = UDim2.new(1,0,1,0)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = "🔫 [GUN DROPPED]"
                    lbl.TextColor3 = Color3.fromRGB(0, 255, 255)
                    lbl.Font = Enum.Font.GothamBold
                    lbl.TextSize = 12
                    lbl.TextStrokeTransparency = 0
                    lbl.Parent = gBill
                    gBill.Parent = espFolder
                elseif gBill and targetAdornee then
                    gBill.Adornee = targetAdornee
                end
            else
                if espFolder:FindFirstChild("GunDrop_HL") then espFolder.GunDrop_HL:Destroy() end
                if espFolder:FindFirstChild("GunDrop_Bill") then espFolder.GunDrop_Bill:Destroy() end
            end
        else
            if espFolder:FindFirstChild("GunDrop_HL") then espFolder.GunDrop_HL:Destroy() end
            if espFolder:FindFirstChild("GunDrop_Bill") then espFolder.GunDrop_Bill:Destroy() end
        end

        -- Отрисовка игроков
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local char = p.Character
                local role = getRole(p)
                local color = role == "Murderer" and Color3.new(1,0,0) or (role == "Sheriff" and Color3.new(0,0,1) or Color3.new(0,1,0))
                
                -- Highlight (Обводка)
                if espData.master and espData.outlines then
                    local hl = activeHighlights[p]
                    if not hl or hl.Parent == nil or hl.Adornee ~= char then
                        if hl then hl:Destroy() end
                        hl = Instance.new("Highlight")
                        hl.Adornee = char
                        hl.Parent = espFolder
                        activeHighlights[p] = hl
                    end
                    hl.FillColor = color
                    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                else
                    if activeHighlights[p] then
                        activeHighlights[p]:Destroy()
                        activeHighlights[p] = nil
                    end
                end
                
                -- Billboard Nicknames (Имена)
                local billboardName = "ESP_Bill_"..p.Name
                local existingBill = espFolder:FindFirstChild(billboardName)
                if espData.master and espData.names and char:FindFirstChild("Head") then
                    if not existingBill or existingBill.Adornee ~= char.Head then
                        if existingBill then existingBill:Destroy() end
                        local bg = Instance.new("BillboardGui")
                        bg.Name = billboardName
                        bg.AlwaysOnTop = true
                        bg.Size = UDim2.new(0, 200, 0, 30)
                        bg.Adornee = char.Head
                        bg.ExtentsOffset = Vector3.new(0, 2.5, 0)
                        
                        local lbl = Instance.new("TextLabel")
                        lbl.Size = UDim2.new(1, 0, 1, 0)
                        lbl.BackgroundTransparency = 1
                        lbl.Text = p.DisplayName.." (@"..p.Name..") ["..string.sub(role, 1, 1).."]"
                        lbl.TextColor3 = color
                        lbl.TextStrokeTransparency = 0
                        lbl.Font = Enum.Font.GothamBold
                        lbl.TextSize = 11
                        lbl.Parent = bg
                        bg.Parent = espFolder
                    else
                        existingBill.TextLabel.Text = p.DisplayName.." ["..string.sub(role, 1, 1).."]"
                        existingBill.TextLabel.TextColor3 = color
                    end
                else
                    if existingBill then existingBill:Destroy() end
                end

                -- Интерактивные кружки (⚡) с полным фиксом мобильных тапов
                local circleName = "Circle_"..p.Name
                local existingCircle = espFolder:FindFirstChild(circleName)
                if espData.interactiveCircles and char:FindFirstChild("Head") then
                    if not existingCircle or existingCircle.Adornee ~= char.Head then
                        if existingCircle then existingCircle:Destroy() end
                        local bg = Instance.new("BillboardGui")
                        bg.Name = circleName
                        bg.AlwaysOnTop = true
                        bg.Size = UDim2.new(0, 28, 0, 28)
                        bg.Adornee = char.Head
                        bg.ExtentsOffset = Vector3.new(0, 4.2, 0)
                        
                        local btn = Instance.new("TextButton")
                        btn.Size = UDim2.new(1, 0, 1, 0)
                        btn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
                        btn.Text = "⚡"
                        btn.TextColor3 = accentColor
                        btn.Font = Enum.Font.GothamBold
                        btn.TextSize = 12
                        btn.Active = true
                        btn.Selectable = true
                        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
                        local s = Instance.new("UIStroke", btn)
                        s.Color = accentColor
                        s.Thickness = 1.3
                        btn.Parent = bg
                        bg.Parent = espFolder
                        
                        -- Полная мультиплатформенная поддержка кликов/тапов
                        local function openActionMenu()
                            actionTargetPlayer = p
                            qTitle.Text = "ACTIONS: " .. p.DisplayName:upper()
                            quickMenu.Visible = true
                        end
                        btn.MouseButton1Down:Connect(openActionMenu)
                        btn.TouchTap:Connect(openActionMenu)
                        
                        if isRGBMode then table.insert(rgbElements.Text, btn) table.insert(rgbElements.Stroke, s) end
                    end
                else
                    if existingCircle then existingCircle:Destroy() end
                end
                
                -- Tracers (Трейсеры)
                if espData.tracers then
                    local screenPos, onScreen = cam:WorldToViewportPoint(char.HumanoidRootPart.Position)
                    if onScreen then
                        local line = Drawing.new("Line")
                        line.Visible = true
                        line.Color = color
                        line.Thickness = 1.5
                        line.Transparency = 0.8
                        line.From = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y)
                        line.To = Vector2.new(screenPos.X, screenPos.Y)
                        task.delay(0, function() RunService.RenderStepped:Wait() line:Remove() end)
                    end
                end
            end
        end
    end)
end)

-- 2. Вкладка COMBAT
local cTab = createTab("Combat")
local cData = {
    auraRange=15, 
    dodgeDist=25, 
    auraActive=false, 
    auraSession=0,
    hitboxSize=15, 
    hitboxTarget="All", 
    silentAimActive=false, 
    silentAimSession=0,
    hitboxColor=Color3.fromRGB(255, 170, 0), 
    hitboxTransparency=0.6,
    autoGrabActive=false,
    autoGrabSession=0,
    dodgeEnabled=false,
    dodgeSession=0
}

-- MURDERER SECTION
addStaticColoredLabel(cTab, "--- MURDERER ---", Color3.fromRGB(255, 60, 60))

addToggle(cTab, "Kill Aura", false, function(v)
    cData.auraActive = v
    cData.auraSession = cData.auraSession + 1
    local currentSession = cData.auraSession
    
    if v then 
        local initCheck = LP.Character:FindFirstChild("Knife") or (LP.Backpack and LP.Backpack:FindFirstChild("Knife"))
        if not initCheck then notify("Warning", "Equip or have Knife in Backpack", 3) end
        
        task.spawn(function() 
            while cData.auraActive and cData.auraSession == currentSession do
                task.wait(0.05)
                pcall(function()
                    if not LP.Character or not LP.Character:FindFirstChild("HumanoidRootPart") then return end
                    local knife = LP.Character:FindFirstChild("Knife") or (LP.Backpack and LP.Backpack:FindFirstChild("Knife"))
                    if knife then
                        for _, p in ipairs(Players:GetPlayers()) do 
                            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                local dist = (LP.Character.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                                if dist <= cData.auraRange then
                                    if knife.Parent == LP.Backpack then 
                                        LP.Character.Humanoid:EquipTool(knife) 
                                    end
                                    knife:Activate()
                                end
                            end 
                        end
                    end
                end)
            end 
        end) 
    end
end)
addSlider(cTab, "Kill Aura Range", 5, 50, 15, function(v) cData.auraRange=v end)

addButton(cTab, "Kill All (Teleport)", function()
    pcall(function()
        local knife = LP.Character:FindFirstChild("Knife") or (LP.Backpack and LP.Backpack:FindFirstChild("Knife"))
        if not knife then notify("Access Denied", "Murderer weapon not found!", 3) return end
        
        for _,p in ipairs(Players:GetPlayers()) do 
            if p~=LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and getRole(p) ~= "Murderer" then
                if knife.Parent == LP.Backpack then LP.Character.Humanoid:EquipTool(knife) end 
                LP.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.2) 
                task.wait(0.12) 
                knife:Activate() 
            end 
        end
    end)
end)

-- HITBOX EXPANDER (БЕЗУПРЕЧНЫЙ КАДРОВЫЙ СБРОС)
addStaticColoredLabel(cTab, "--- HITBOX SETTINGS ---", Color3.fromRGB(240, 240, 240))
addSlider(cTab, "Hitbox Size", 2, 40, 15, function(v) cData.hitboxSize = v end)
addSlider(cTab, "Hitbox Transparency", 0, 10, 6, function(v) cData.hitboxTransparency = v / 10 end)

addButton(cTab, "Color: Orange (Signature)", function() cData.hitboxColor = Color3.fromRGB(255, 170, 0) end)
addButton(cTab, "Color: Intense Red", function() cData.hitboxColor = Color3.fromRGB(255, 30, 30) end)
addButton(cTab, "Color: Neon Cyan Blue", function() cData.hitboxColor = Color3.fromRGB(0, 220, 255) end)

local hitboxEnabled = false
addToggle(cTab, "Hitbox Expander (Active)", false, function(v)
    hitboxEnabled = v
    if not v then
        -- Мгновенная принудительная очистка и сброс размеров при деактивации
        pcall(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    p.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                    p.Character.HumanoidRootPart.Transparency = 1
                    p.Character.HumanoidRootPart.CanCollide = true
                end
            end
        end)
    end
end)

RunService.Stepped:Connect(function()
    if not hitboxEnabled then return end
    pcall(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local role = getRole(p)
                local shouldExpand = false
                
                if cData.hitboxTarget == "All" then
                    shouldExpand = true
                elseif cData.hitboxTarget == "Murderer" and role == "Murderer" then
                    shouldExpand = true
                elseif cData.hitboxTarget == "Sheriff" and role == "Sheriff" then
                    shouldExpand = true
                end
                
                local hrp = p.Character.HumanoidRootPart
                if shouldExpand then
                    hrp.Size = Vector3.new(cData.hitboxSize, cData.hitboxSize, cData.hitboxSize)
                    hrp.Transparency = cData.hitboxTransparency
                    hrp.Color = cData.hitboxColor
                    hrp.Material = Enum.Material.ForceField
                    hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.CanCollide = true
                end
            end
        end
    end)
end)

addButton(cTab, "Hitboxes: Targets [All]", function() cData.hitboxTarget = "All" notify("Hitbox Target", "Targeting All Players", 2) end)
addButton(cTab, "Hitboxes: Targets [Murderer Only]", function() cData.hitboxTarget = "Murderer" notify("Hitbox Target", "Targeting Murderer Only", 2) end)
addButton(cTab, "Hitboxes: Targets [Sheriff Only]", function() cData.hitboxTarget = "Sheriff" notify("Hitbox Target", "Targeting Sheriff Only", 2) end)

-- SHERIFF SECTION
addStaticColoredLabel(cTab, "--- SHERIFF & UTILS ---", Color3.fromRGB(50, 120, 255))

addToggle(cTab, "Silent Aim (Target Murderer)", false, function(v)
    cData.silentAimActive = v
    cData.silentAimSession = cData.silentAimSession + 1
    local currentSession = cData.silentAimSession
    
    if v then
        task.spawn(function()
            while cData.silentAimActive and cData.silentAimSession == currentSession do
                task.wait(0.01)
                pcall(function()
                    local char = LP.Character
                    if char and char:FindFirstChild("Gun") then
                        local target = nil
                        for _, p in ipairs(Players:GetPlayers()) do
                            if getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                target = p.Character.HumanoidRootPart
                                break
                            end
                        end
                        if target then
                            local cam = Workspace.CurrentCamera
                            cam.CFrame = CFrame.new(cam.CFrame.Position, target.Position)
                        end
                    end
                end)
            end
        end)
    end
end)

addToggle(cTab, "Auto Grab Dropped Gun", false, function(v)
    cData.autoGrabActive = v
    cData.autoGrabSession = cData.autoGrabSession + 1
    local currentSession = cData.autoGrabSession
    
    if v then
        task.spawn(function()
            while cData.autoGrabActive and cData.autoGrabSession == currentSession do
                task.wait(0.1)
                pcall(function()
                    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and getRole(LP) == "Innocent" then
                        local gunDrop = Workspace:FindFirstChild("GunDrop") or Workspace:FindFirstChild("Pickup_Gun")
                        if not gunDrop then
                            for _, obj in ipairs(Workspace:GetDescendants()) do
                                if obj:IsA("Model") and (obj.Name == "GunDrop" or obj.Name:match("Gun")) and obj:FindFirstChild("HumanoidRootPart") then
                                    gunDrop = obj
                                    break
                                end
                            end
                        end
                        
                        if gunDrop then
                            local root = LP.Character.HumanoidRootPart
                            local oldPos = root.CFrame
                            root.CFrame = gunDrop:GetPivot()
                            task.wait(0.1)
                            root.CFrame = oldPos
                            notify("Auto Grab", "Successfully picked up the Gun!", 2)
                            task.wait(2.5)
                        end
                    end
                end)
            end
        end)
    end
end)

addLabel(cTab, "Defense")

addToggle(cTab, "Auto Dodge (Run From Murderer)", false, function(v)
    cData.dodgeEnabled = v
    cData.dodgeSession = cData.dodgeSession + 1
    local currentSession = cData.dodgeSession
    
    if v then 
        task.spawn(function() 
            while cData.dodgeEnabled and cData.dodgeSession == currentSession do
                task.wait(0.05)
                pcall(function()
                    if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
                        for _, p in ipairs(Players:GetPlayers()) do 
                            if p ~= LP and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                local mRoot = p.Character.HumanoidRootPart
                                local myRoot = LP.Character.HumanoidRootPart
                                local dist = (myRoot.Position - mRoot.Position).Magnitude
                                if dist < cData.dodgeDist then
                                    local escapeDirection = (myRoot.Position - mRoot.Position).Unit
                                    myRoot.CFrame = myRoot.CFrame + (escapeDirection * 15)
                                    notify("System", "Evaded Murderer!", 1.5) 
                                    task.wait(1.2)
                                end
                            end 
                        end
                    end
                end)
            end 
        end) 
    end
end)
addSlider(cTab, "Dodge Distance", 10, 50, 25, function(v) cData.dodgeDist=v end)


-- 3. Вкладка TROLL & FLING
local trollTab = createTab("Troll & Fling")
addLabel(trollTab, "Target Logic")

local trollTarget = ""
addTextBox(trollTab, "Player Name", function(t) trollTarget=t end)

-- POWERFUL FIXED FLING METHOD (SAFE FROM OUT OF BOUNDS & KNIFE KILLPROOF)
local isFlinging = false
doFling = function(target)
    if isFlinging then notify("Fling", "Wait for previous fling to finish!", 2) return end
    if not target or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") then 
        notify("Fling", "Target not found or dead", 2)
        return 
    end
    local char = LP.Character 
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local hrp = char.HumanoidRootPart
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    
    isFlinging = true
    local oldPos = hrp.CFrame
    notify("Fling", "Flinging: "..target.Name, 2)
    
    local noclipLoop = RunService.Stepped:Connect(function()
        pcall(function()
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    end)
    
    local bg = Instance.new("BodyGyro")
    bg.P = 9e9
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = hrp.CFrame
    bg.Parent = hrp
    
    local bv = Instance.new("BodyAngularVelocity") 
    bv.MaxTorque = Vector3.new(1e9,1e9,1e9) 
    bv.AngularVelocity = Vector3.new(0, 7500, 0)
    bv.Parent = hrp
    
    hum.PlatformStand = true
    
    local startTime = tick()
    local conn
    conn = RunService.Heartbeat:Connect(function()
        pcall(function()
            if tick() - startTime > 2.5 or not target.Character or not target.Character:FindFirstChild("HumanoidRootPart") or not char or not char.Parent then 
                conn:Disconnect() 
                noclipLoop:Disconnect()
                bv:Destroy() 
                bg:Destroy()
                if char and hrp then
                    hrp.CFrame = oldPos 
                    hrp.AssemblyLinearVelocity = Vector3.new(0,0,0) 
                    hrp.AssemblyAngularVelocity = Vector3.new(0,0,0) 
                end
                if hum then hum.PlatformStand = false end
                isFlinging = false
                notify("Fling", "Fling finished", 2)
                return 
            end
            
            local targetRoot = target.Character.HumanoidRootPart
            local isMurd = getRole(target) == "Murderer"
            
            -- Защищенная слепая зона: атакуем маньяка строго сверху во избежание резки ножом
            if isMurd then
                hrp.CFrame = targetRoot.CFrame * CFrame.new(0, 3.2, 0.3)
            else
                hrp.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 0.1)
            end
            hrp.AssemblyLinearVelocity = Vector3.new(600, 600, 600)
        end)
    end)
end

addButton(trollTab, "Fling Target", function() local t=getPlayer(trollTarget) if t then doFling(t) else notify("Status","Player not found") end end)

-- ======================================================================
-- РАСШИРЕННАЯ СИСТЕМА 18+ С АНИМАЦИЯМИ И СЛАЙДЕРАМИ (SEX TROLL)
-- ======================================================================
addStaticColoredLabel(trollTab, "--- 18+ SEX TROLL ---", Color3.fromRGB(255, 100, 200))

local sexMode = "Hump"
local sexSpeed = 15
local sexBanging = false
local sexBangingSession = 0

addToggle(trollTab, "Active 18+ Animation", false, function(v)
    sexBanging = v
    sexBangingSession = sexBangingSession + 1
    local currentSession = sexBangingSession
    
    if v then
        task.spawn(function()
            while sexBanging and sexBangingSession == currentSession do
                task.wait(0.01)
                pcall(function()
                    local t = getPlayer(trollTarget)
                    local char = LP.Character
                    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and char and char:FindFirstChild("HumanoidRootPart") then
                        local tHrp = t.Character.HumanoidRootPart
                        local myHrp = char.HumanoidRootPart
                        local myHum = char:FindFirstChildOfClass("Humanoid")
                        
                        -- Полная блокировка внутренней физики Roblox коллизий на время анимации
                        for _, part in ipairs(char:GetDescendants()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                        if myHum then myHum.PlatformStand = true end
                        
                        local animTime = tick() * sexSpeed
                        
                        if sexMode == "Hump" then
                            -- Классическая долбёжка сзади
                            local offset = math.sin(animTime) * 0.8 - 0.9
                            myHrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, offset)
                            
                        elseif sexMode == "Suck" then
                            -- Сосание на коленях (позиция спереди)
                            local headBob = math.sin(animTime) * 0.4 - 1.8
                            myHrp.CFrame = tHrp.CFrame * CFrame.new(0, headBob, -1.2) * CFrame.Angles(0, math.rad(180), 0)
                            
                        elseif sexMode == "Spank" then
                            -- Шлепки сзади со случайными визуальными звуками шлепков
                            local cycle = math.sin(animTime) * 0.4 - 0.8
                            myHrp.CFrame = tHrp.CFrame * CFrame.new(0.3, 0, cycle)
                            
                            -- Генерация визуального текста шлепков над головой цели
                            if math.floor(animTime) % 6 == 0 then
                                local textList = {"*SLAP!*", "*AHH~*", "*OHH!*", "*SPANKED!*"}
                                local selectedText = textList[math.random(1, #textList)]
                                pcall(function()
                                    local popup = Instance.new("BillboardGui")
                                    popup.Size = UDim2.new(0, 100, 0, 30)
                                    popup.Adornee = t.Character:FindFirstChild("Head") or tHrp
                                    popup.AlwaysOnTop = true
                                    popup.ExtentsOffset = Vector3.new(math.random(-2,2), 3, math.random(-2,2))
                                    local lbl = Instance.new("TextLabel")
                                    lbl.Size = UDim2.new(1,0,1,0)
                                    lbl.BackgroundTransparency = 1
                                    lbl.Text = selectedText
                                    lbl.TextColor3 = Color3.fromRGB(255, 50, 150)
                                    lbl.Font = Enum.Font.GothamBold
                                    lbl.TextSize = 13
                                    lbl.Parent = popup
                                    popup.Parent = espFolder
                                    task.delay(0.6, function() popup:Destroy() end)
                                end)
                            end
                            
                        elseif sexMode == "LapDance" then
                            -- Плавные трения по кругу на коленях жертвы
                            local circleX = math.cos(animTime) * 0.5
                            local circleZ = math.sin(animTime) * 0.5
                            myHrp.CFrame = tHrp.CFrame * CFrame.new(circleX, -0.5, circleZ) * CFrame.Angles(math.rad(15), 0, 0)
                        end
                    end
                end)
            end
            
            -- Плавный возврат персонажа в исходную нормальную физику по завершении
            pcall(function()
                local char = LP.Character
                if char then
                    local myHum = char:FindFirstChildOfClass("Humanoid")
                    if myHum then myHum.PlatformStand = false end
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end
            end)
        end) 
    end
end)

addButton(trollTab, "Sex: [Hump / Bang]", function() sexMode = "Hump" notify("Sex System", "Mode: Hump (Bang)", 2) end)
addButton(trollTab, "Sex: [Suck / BJ]", function() sexMode = "Suck" notify("Sex System", "Mode: Suck (BJ)", 2) end)
addButton(trollTab, "Sex: [Spank / Slap]", function() sexMode = "Spank" notify("Sex System", "Mode: Spank & Slap", 2) end)
addButton(trollTab, "Sex: [Lap Dance]", function() sexMode = "LapDance" notify("Sex System", "Mode: Lap Dance", 2) end)

addSlider(trollTab, "Sex Animation Speed", 5, 40, 15, function(v) sexSpeed = v end)

addLabel(trollTab, "Role Based Fling")
addButton(trollTab, "Fling Murderer", function() for _,p in ipairs(Players:GetPlayers()) do if getRole(p)=="Murderer" then doFling(p) return end end notify("Status","Murderer not found") end)
addButton(trollTab, "Fling Sheriff", function() for _,p in ipairs(Players:GetPlayers()) do if getRole(p)=="Sheriff" then doFling(p) return end end notify("Status","Sheriff not found") end)


-- 4. Вкладка MOVEMENT
local mTab = createTab("Movement")
local mData = {speed=16, jump=50, fSpeed=50}

addLabel(mTab, "Physics Overrides")
addSlider(mTab, "WalkSpeed", 16, 200, 16, function(v) mData.speed=v if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.WalkSpeed=v end end)
addSlider(mTab, "JumpPower", 50, 300, 50, function(v) mData.jump=v if LP.Character and LP.Character:FindFirstChild("Humanoid") then LP.Character.Humanoid.UseJumpPower=true LP.Character.Humanoid.JumpPower=v end end)

-- Loop Speed & Jump (БЕЗУПРЕЧНЫЙ КАДРОВЫЙ ОБХОД СБРОСОВ)
local loopMovementActive = false
addToggle(mTab, "Loop WalkSpeed and Jump", false, function(v)
    loopMovementActive = v
    if not v then
        -- Мгновенно возвращаем скорость при выключении во избежание зависаний
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                LP.Character.Humanoid.WalkSpeed = 16
                LP.Character.Humanoid.JumpPower = 50
            end
        end)
    end
end)

RunService.Heartbeat:Connect(function()
    if loopMovementActive then
        pcall(function()
            if LP.Character and LP.Character:FindFirstChild("Humanoid") then
                local hum = LP.Character.Humanoid
                if hum.WalkSpeed ~= mData.speed then hum.WalkSpeed = mData.speed end
                if hum.JumpPower ~= mData.jump then hum.JumpPower = mData.jump end
                if not hum.UseJumpPower then hum.UseJumpPower = true end
            end
        end)
    end
end)

addToggle(mTab, "Infinite Jump", false, function(v)
    if v then 
        _G.InfJumpConn = UserInputService.JumpRequest:Connect(function() 
            pcall(function()
                if LP.Character and LP.Character:FindFirstChild("Humanoid") then 
                    LP.Character.Humanoid:ChangeState("Jumping") 
                end 
            end)
        end) 
    else
        if _G.InfJumpConn then 
            _G.InfJumpConn:Disconnect() 
            _G.InfJumpConn = nil 
        end
    end
end)

-- NO-CLIP (СТАБИЛЬНЫЙ С КАДРОВЫМ ВЫКЛЮЧЕНИЕМ)
local noclip = false
local noclipConnection = nil
addToggle(mTab, "Noclip (Walk Through Walls)", false, function(v) 
    noclip = v 
    if v then
        noclipConnection = RunService.Stepped:Connect(function()
            if noclip and LP.Character then
                pcall(function()
                    for _, part in ipairs(LP.Character:GetDescendants()) do
                        if part:IsA("BasePart") then 
                            part.CanCollide = false 
                        end
                    end
                end)
            end
        end)
    else
        if noclipConnection then 
            noclipConnection:Disconnect() 
            noclipConnection = nil 
        end
        pcall(function()
            if LP.Character then
                for _, part in ipairs(LP.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then 
                        part.CanCollide = true 
                    end
                end
            end
        end)
    end
end)

-- Fly Mode (Адаптирован под сенсорные экраны Mobile и ПК)
local flying = false
local flySession = 0
addToggle(mTab, "Fly Mode (Joystick & Camera)", false, function(v)
    flying = v
    flySession = flySession + 1
    local currentSession = flySession
    
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChild("Humanoid")
    if not hrp or not hum then return end
    
    if v then
        local bg = Instance.new("BodyGyro", hrp)
        bg.P = 9e4 bg.maxTorque = Vector3.new(9e9, 9e9, 9e9) bg.cframe = hrp.CFrame
        local bv = Instance.new("BodyVelocity", hrp)
        bv.velocity = Vector3.new(0,0,0) bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
        
        task.spawn(function()
            while flying and flySession == currentSession and char and hrp and char.Parent do
                pcall(function()
                    hum.PlatformStand = true
                    local cam = Workspace.CurrentCamera
                    bg.cframe = cam.CFrame
                    
                    local dir = Vector3.new(0,0,0)
                    
                    if hum.MoveDirection.Magnitude > 0 then
                        dir = hum.MoveDirection
                    else
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Vector3.new(0,0,-1) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir + Vector3.new(0,0,1) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir + Vector3.new(-1,0,0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Vector3.new(1,0,0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir + Vector3.new(0,-1,0) end
                    end
                    
                    if dir.Magnitude > 0 then
                        if hum.MoveDirection.Magnitude > 0 then
                            bv.velocity = dir * mData.fSpeed
                        else
                            bv.velocity = cam.CFrame:VectorToWorldSpace(dir.Unit) * mData.fSpeed
                        end
                    else
                        bv.velocity = Vector3.new(0,0,0)
                    end
                end)
                task.wait()
            end
            pcall(function()
                if bg then bg:Destroy() end
                if bv then bv:Destroy() end
                if hum then hum.PlatformStand = false end
            end)
        end)
    end
end)
addSlider(mTab, "Fly Speed", 10, 200, 50, function(v) mData.fSpeed=v end)


-- 5. Вкладка Settings (WORLD TAB)
local wTab = createTab("Settings")

addLabel(wTab, "World Control")
addSlider(wTab, "Field of View (FOV)", 70, 120, 70, function(v) Workspace.CurrentCamera.FieldOfView = v end)
addToggle(wTab, "Fullbright", false, function(v)
    pcall(function()
        Lighting.Brightness = v and 3 or 1 Lighting.GlobalShadows = not v Lighting.FogEnd = v and 100000 or 1000
    end)
end)

-- Notify Roles on Start
local autoShowActive = false
local autoShowSession = 0
addToggle(wTab, "Notify Roles on Start", false, function(v)
    autoShowActive = v
    autoShowSession = autoShowSession + 1
    local currentSession = autoShowSession
    
    if v then
        task.spawn(function()
            while autoShowActive and autoShowSession == currentSession do
                task.wait(5)
                pcall(function()
                    local m, s = nil, nil
                    for _, p in ipairs(Players:GetPlayers()) do
                        local role = getRole(p)
                        if role == "Murderer" then m = p
                        elseif role == "Sheriff" then s = p end
                    end
                    if m or s then
                        local text = "[HUB]: "
                        if m then text = text .. "Murderer: " .. m.DisplayName .. " | " end
                        if s then text = text .. "Sheriff: " .. s.DisplayName end
                        notify("Roles Detected", text, 5)
                        task.wait(25)
                    end
                end)
            end
        end)
    end
end)

addLabel(wTab, "UI Settings")
addButton(wTab, "Destroy UI", function() gui:Destroy() end)

-- FLOATING ACTIONS PANEL LOGIC CONNECTIONS
qFling.MouseButton1Click:Connect(function()
    pcall(function()
        if actionTargetPlayer then 
            doFling(actionTargetPlayer) 
            quickMenu.Visible = false 
        end
    end)
end)

qKillM.MouseButton1Click:Connect(function()
    pcall(function()
        quickMenu.Visible = false
        local murd = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if getRole(p) == "Murderer" then murd = p break end
        end
        if not murd then notify("Action Failed", "Murderer not found!", 3) return end
        
        local weapon = LP.Character:FindFirstChild("Gun") or (LP.Backpack and LP.Backpack:FindFirstChild("Gun")) or 
                       LP.Character:FindFirstChild("Knife") or (LP.Backpack and LP.Backpack:FindFirstChild("Knife"))
                       
        if not weapon then 
            notify("Action Denied", "You need a Gun or Knife!", 3) 
            return 
        end
        
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") and murd.Character and murd.Character:FindFirstChild("HumanoidRootPart") then
            local root = LP.Character.HumanoidRootPart
            local oldCFrame = root.CFrame
            if weapon.Parent == LP.Backpack then LP.Character.Humanoid:EquipTool(weapon) end
            
            root.CFrame = murd.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 1.3)
            task.wait(0.12)
            weapon:Activate()
            task.wait(0.12)
            root.CFrame = oldCFrame
            notify("Instant Kill", "Executed tactical stab/shot on Murderer!", 2)
        end
    end)
end)

-- Авто-выбор первой вкладки при старте
if tabs[1] then tabs[1].Page.Visible=true tabs[1].Btn.TextColor3=accentColor end

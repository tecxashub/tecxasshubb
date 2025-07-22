-- Tecxas Hub inspirado no Chilli.lua (Tien Khanh)
-- Para "Roube um Brainot"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()
local UserInputService = game:GetService("UserInputService")

local TweenService = game:GetService("TweenService")

local function CreateMainFrame()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "TecxasHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = player:WaitForChild("PlayerGui")

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 450, 0, 500)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -250)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = ScreenGui
    mainFrame.Active = true
    mainFrame.Draggable = true

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    titleBar.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Tecxas Hub"
    titleLabel.TextColor3 = Color3.new(1,1,1)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 24
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 1, 0)
    closeBtn.Position = UDim2.new(1, -40, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    closeBtn.TextColor3 = Color3.new(1,1,1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 24
    closeBtn.Text = "X"
    closeBtn.Parent = titleBar

    closeBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Sidebar for categories
    local sidebar = Instance.new("Frame")
    sidebar.Size = UDim2.new(0, 120, 1, -40)
    sidebar.Position = UDim2.new(0, 0, 0, 40)
    sidebar.BackgroundColor3 = Color3.fromRGB(40,40,40)
    sidebar.Parent = mainFrame

    local uiList = Instance.new("UIListLayout")
    uiList.Parent = sidebar
    uiList.Padding = UDim.new(0, 5)
    uiList.FillDirection = Enum.FillDirection.Vertical
    uiList.SortOrder = Enum.SortOrder.LayoutOrder

    -- Content area
    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -120, 1, -40)
    content.Position = UDim2.new(0, 120, 0, 40)
    content.BackgroundColor3 = Color3.fromRGB(35,35,35)
    content.Parent = mainFrame

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Parent = content
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

    -- Helper para criar botão lateral
    local function createSidebarButton(text)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -10, 0, 40)
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 18
        btn.Text = text
        btn.AutoButtonColor = false

        local uicorner = Instance.new("UICorner")
        uicorner.CornerRadius = UDim.new(0, 6)
        uicorner.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(90,90,90)}):Play()
        end)

        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60,60,60)}):Play()
        end)

        btn.Parent = sidebar
        return btn
    end

    -- Limpa conteúdo do painel de conteúdo
    local function clearContent()
        for _,v in pairs(content:GetChildren()) do
            if not v:IsA("UIListLayout") then
                v:Destroy()
            end
        end
    end

    -- Cria toggle simples no painel de conteúdo
    local function createToggle(name, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -20, 0, 40)
        frame.BackgroundTransparency = 1
        frame.Parent = content

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.7, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Color3.new(1,1,1)
        label.Font = Enum.Font.Gotham
        label.TextSize = 16
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = frame

        local btnToggle = Instance.new("TextButton")
        btnToggle.Size = UDim2.new(0.25, 0, 0.6, 0)
        btnToggle.Position = UDim2.new(0.7, 0, 0.2, 0)
        btnToggle.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80,80,80)
        btnToggle.Text = ""
        btnToggle.Parent = frame

        local toggled = default

        btnToggle.MouseButton1Click:Connect(function()
            toggled = not toggled
            btnToggle.BackgroundColor3 = toggled and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(80,80,80)
            callback(toggled)
        end)
    end

    -- Funções das abas

    local function setupPlayer()
        clearContent()
        createToggle("Speed Boost", false, function(enabled)
            local char = player.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                if enabled then
                    char.Humanoid.WalkSpeed = 50
                else
                    char.Humanoid.WalkSpeed = 16
                end
            end
        end)

        createToggle("Infinite Jump", false, function(enabled)
            if enabled then
                local conn
                conn = UserInputService.JumpRequest:Connect(function()
                    local char = player.Character
                    if char and char:FindFirstChildOfClass("Humanoid") then
                        char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end)
                frameData.infiniteJumpConnection = conn
            else
                if frameData.infiniteJumpConnection then
                    frameData.infiniteJumpConnection:Disconnect()
                    frameData.infiniteJumpConnection = nil
                end
            end
        end)

        createToggle("Anti AFK", false, function(enabled)
            if enabled then
                local conn
                conn = game:GetService("Players").LocalPlayer.Idled:Connect(function()
                    local VirtualUser = game:GetService("VirtualUser")
                    VirtualUser:ClickButton2(Vector2.new())
                end)
                frameData.antiAfkConnection = conn
            else
                if frameData.antiAfkConnection then
                    frameData.antiAfkConnection:Disconnect()
                    frameData.antiAfkConnection = nil
                end
            end
        end)
    end

    local function setupVisual()
        clearContent()
        createToggle("ESP Players", false, function(enabled)
            -- Aqui você pode implementar ESP para jogadores
            print("ESP Players: ", enabled)
        end)
        createToggle("ESP Brainots", false, function(enabled)
            -- Aqui você pode implementar ESP para brainots
            print("ESP Brainots: ", enabled)
        end)
        createToggle("ESP Base", false, function(enabled)
            -- Aqui você pode implementar ESP para base
            print("ESP Base: ", enabled)
        end)
    end

    local function setupBrainot()
        clearContent()
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 40)
        label.BackgroundTransparency = 1
        label.Text = "Opções Brainot não implementadas ainda."
        label.TextColor3 = Color3.new(1,1,1)
        label.Font = Enum.Font.Gotham
        label.TextSize = 18
        label.Parent = content
    end

    local function setupScript()
        clearContent()
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -20, 0, 40)
        label.BackgroundTransparency = 1
        label.Text = "Opções Script não implementadas ainda."
        label.TextColor3 = Color3.new(1,1,1)
        label.Font = Enum.Font.Gotham
        label.TextSize = 18
        label.Parent = content
    end

    -- Guarda conexões para desconectar ao desativar
    local frameData = {}

    -- Cria botões da sidebar
    local btnPlayer = createSidebarButton("Player")
    local btnVisual = createSidebarButton("Visual")
    local btnBrainot = createSidebarButton("Brainot")
    local btnScript = createSidebarButton("Script")

    -- Conecta os botões
    btnPlayer.MouseButton1Click:Connect(setupPlayer)
    btnVisual.MouseButton1Click:Connect(setupVisual)
    btnBrainot.MouseButton1Click:Connect(setupBrainot)
    btnScript.MouseButton1Click:Connect(setupScript)

    -- Começa com Player aberto
    setupPlayer()
end

CreateMainFrame()

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CRONOS|ANTIAFK"
screenGui.ResetOnSpawn = false
screenGui.Parent = game:GetService("CoreGui")
local PADDING = 20
local visiblePos  = UDim2.new(1, -PADDING, 1, -PADDING)
local hiddenPos   = UDim2.new(1, 140, 1, -PADDING)
local function createFrame(size, position, anchor)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position
    frame.AnchorPoint = anchor
    frame.BackgroundColor3 = Color3.fromRGB(85, 107, 47)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0

    local gradient = Instance.new("UIGradient", frame)
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(107, 142, 35)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 80, 20)),
    })
    gradient.Rotation = 45

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(154, 205, 50)
    stroke.Thickness = 2
    stroke.Transparency = 0.3

    local shadow = Instance.new("ImageLabel", frame)
    shadow.Name = "Shadow"
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.new(-0.15, 0, -0.15, 0)
    shadow.Size = UDim2.new(1.3, 0, 1.3, 0)
    shadow.ZIndex = -1
    shadow.Image = "rbxassetid://9637602897"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.5

    return frame
end
local counter = createFrame(
    UDim2.new(0, 140, 0, 120),
    hiddenPos,
    Vector2.new(1, 1)
)
counter.Name = "Counter"
counter.Parent = screenGui
counter.Visible = true
local function makeLabel(parent, size, position, text)
    local label = Instance.new("TextLabel")
    label.Parent = parent
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.FredokaOne
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextScaled = true
    label.TextWrapped = true
    label.BorderSizePixel = 0
    return label
end
local titleLabel = makeLabel(counter,
    UDim2.new(0.9, 0, 0.25, 0),
    UDim2.new(0.05, 0, 0.05, 0),
    "CRONOS|ANTIAFK"
)
local timerLabel = makeLabel(counter,
    UDim2.new(0.45, 0, 0.2, 0),
    UDim2.new(0.05, 0, 0.35, 0),
    "00:00:00"
)
local fpsLabel = makeLabel(counter,
    UDim2.new(0.45, 0, 0.2, 0),
    UDim2.new(0.05, 0, 0.55, 0),
    "FPS: 0"
)
local pingLabel = makeLabel(counter,
    UDim2.new(0.45, 0, 0.2, 0),
    UDim2.new(0.05, 0, 0.75, 0),
    "Ping: 0 ms"
)
local icon = Instance.new("ImageLabel")
icon.Parent = counter
icon.Position = UDim2.new(0.55, 0, 0.35, 0)
icon.Size = UDim2.new(0.4, 0, 0.6, 0)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://1083501283"
icon.ImageColor3 = Color3.fromRGB(173, 255, 47)
icon.BorderSizePixel = 0
local aspectConstraint = Instance.new("UIAspectRatioConstraint", icon)
aspectConstraint.AspectRatio = 1
spawn(function()
    local seconds = 0
    while true do
        wait(1)
        seconds = seconds + 1
        local h = math.floor(seconds / 3600)
        local m = math.floor(seconds % 3600 / 60)
        local s = seconds % 60
        timerLabel.Text = string.format("%02d:%02d:%02d", h, m, s)
    end
end)
spawn(function()
    local lastTick = tick()
    while true do
        RunService.Heartbeat:Wait()
        local now = tick()
        local delta = now - lastTick
        lastTick = now
        if delta > 0 then
            fpsLabel.Text = string.format("FPS: %d", math.floor(1 / delta))
        end
    end
end)
spawn(function()
    while true do
        wait(1)
        local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)
        pingLabel.Text = string.format("Ping: %d ms", ping)
    end
end)
LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local function setVisible(visible)
    if visible then
        counter.Visible = true
        local tween = TweenService:Create(counter, tweenInfo, { Position = visiblePos })
        tween:Play()
    else
        local tween = TweenService:Create(counter, tweenInfo, { Position = hiddenPos })
        tween:Play()
        tween.Completed:Connect(function()
            counter.Visible = false
        end)
    end
end
setVisible(true)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightControl then
        setVisible(not counter.Visible)
    end
end)

--====================================
-- SORU HOLD UI (REAL DRAG / PC + MOBILE)
-- fruits battleground
-- by pond
--====================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local lp = Players.LocalPlayer
local Replicator = ReplicatedStorage:WaitForChild("Replicator")

-- CONFIG
local COOLDOWN = 0.08

-- STATE
local Holding = false
local Dragging = false
local DragInput
local DragStart
local StartPos

--====================================
-- UI
--====================================
local gui = Instance.new("ScreenGui")
gui.Name = "SoruHoldUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = lp:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 130, 0, 45) -- สี่เหลี่ยมผืนผ้า แนวนอน
frame.Position = UDim2.new(0.5, -65, 0.75, 0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = frame

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, 0, 1, 0)
btn.BackgroundTransparency = 1
btn.Text = "⚡  S O R U"
btn.Font = Enum.Font.GothamBold
btn.TextSize = 16
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Parent = frame

--====================================
-- DRAG SYSTEM (STABLE METHOD)
--====================================
local function update(input)
    local delta = input.Position - DragStart
    frame.Position = UDim2.new(
        StartPos.X.Scale,
        StartPos.X.Offset + delta.X,
        StartPos.Y.Scale,
        StartPos.Y.Offset + delta.Y
    )
end

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        Dragging = true
        DragStart = input.Position
        StartPos = frame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch then
        DragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        update(input)
    end
end)

--====================================
-- HOLD DETECT
--====================================
btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        Holding = true
    end
end)

btn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        Holding = false
    end
end)

--====================================
-- LOOP SORU
--====================================
task.spawn(function()
    while true do
        if Holding then
            pcall(function()
                Replicator:InvokeServer("Core","Soru",{})
            end)
            task.wait(COOLDOWN)
        else
            task.wait()
        end
    end
end)

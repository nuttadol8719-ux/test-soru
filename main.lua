--====================================
-- MOBILE MINI SORU UI (DRAG BAR + HOLD)
-- fruits battleground
--====================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
local Rep = RS:WaitForChild("ReplicatorNoYield")

-- STATE
local holding = false
local dragging = false
local dragStart, startPos

-- UI
local gui = Instance.new("ScreenGui")
gui.Name = "MiniSoruUI"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(120, 52)
frame.Position = UDim2.fromScale(0.5, 0.75)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = frame

--==============================
-- DRAG BAR (ตัวนี้แหละที่ลาก)
--==============================
local dragBar = Instance.new("Frame")
dragBar.Size = UDim2.new(1, 0, 0, 14)
dragBar.BackgroundColor3 = Color3.fromRGB(40,40,40)
dragBar.BorderSizePixel = 0
dragBar.Parent = frame

local dragCorner = Instance.new("UICorner")
dragCorner.CornerRadius = UDim.new(0, 10)
dragCorner.Parent = dragBar

local dragText = Instance.new("TextLabel")
dragText.Size = UDim2.fromScale(1,1)
dragText.BackgroundTransparency = 1
dragText.Text = "≡"
dragText.TextScaled = true
dragText.Font = Enum.Font.GothamBold
dragText.TextColor3 = Color3.fromRGB(180,180,180)
dragText.Parent = dragBar

--==============================
-- SORU BUTTON
--==============================
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, 0, 1, -14)
btn.Position = UDim2.fromOffset(0, 14)
btn.BackgroundTransparency = 1
btn.Text = "⚡ SORU"
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Parent = frame

--==============================
-- DRAG SYSTEM (MOBILE จริง)
--==============================
dragBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)

dragBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

--==============================
-- HOLD = SORU รัว
--==============================
btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        holding = true
    end
end)

btn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        holding = false
    end
end)

task.spawn(function()
    while true do
        if holding then
            pcall(function()
                Rep:FireServer("Core","Soru",{})
            end)
            task.wait() -- ไม่มีคูลดาวน์
        else
            task.wait()
        end
    end
end)

--====================================
-- END
--====================================

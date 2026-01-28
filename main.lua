--====================================
-- SORU HOLD UI (REAL DRAG FIX)
-- PC + MOBILE (NO BUG)
-- fruits battleground
-- by pond
--====================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local lp = Players.LocalPlayer
local Replicator = ReplicatedStorage:WaitForChild("Replicator")

--====================================
-- CONFIG
--====================================
local COOLDOWN = 0
local KEYBIND = Enum.KeyCode.Q
local WaitingForKey = false

--====================================
-- STATE
--====================================
local Holding = false
local HoldingKey = false

--====================================
-- UI
--====================================
local gui = Instance.new("ScreenGui")
gui.Name = "SoruHoldUI"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.fromOffset(120, 55)
frame.Position = UDim2.fromScale(0.5, 0.6)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 18)

--====================================
-- 🔥 DRAG DETECTOR (ลากได้ชัวร์)
--====================================
local drag = Instance.new("UIDragDetector")
drag.Parent = frame

--====================================
-- SORU BUTTON
--====================================
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -12, 0, 85)
btn.Position = UDim2.fromOffset(6,6)
btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
btn.BorderSizePixel = 0
btn.Text = "⚡\nSORU"
btn.TextScaled = true
btn.Font = Enum.Font.GothamBold
btn.TextColor3 = Color3.new(1,1,1)
btn.Parent = frame

local btnCorner = Instance.new("UICorner", btn)
btnCorner.CornerRadius = UDim.new(0, 14)

--====================================
-- KEYBIND BUTTON
--====================================
local keyBtn = Instance.new("TextButton")
keyBtn.Size = UDim2.new(1, -12, 0, 45)
keyBtn.Position = UDim2.fromOffset(6, 100)
keyBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
keyBtn.BorderSizePixel = 0
keyBtn.Text = "KEY : "..KEYBIND.Name
keyBtn.TextScaled = true
keyBtn.Font = Enum.Font.Gotham
keyBtn.TextColor3 = Color3.fromRGB(200,200,200)
keyBtn.Parent = frame

local keyCorner = Instance.new("UICorner", keyBtn)
keyCorner.CornerRadius = UDim.new(0, 12)

--====================================
-- HOLD (BUTTON)
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
-- KEYBIND SET
--====================================
keyBtn.MouseButton1Click:Connect(function()
    WaitingForKey = true
    keyBtn.Text = "กดปุ่ม..."
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end

    if WaitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
        KEYBIND = input.KeyCode
        keyBtn.Text = "KEY : "..KEYBIND.Name
        WaitingForKey = false
        return
    end

    if input.KeyCode == KEYBIND then
        HoldingKey = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == KEYBIND then
        HoldingKey = false
    end
end)

--====================================
-- SORU LOOP
--====================================
task.spawn(function()
    while true do
        if Holding or HoldingKey then
            pcall(function()
                Replicator:InvokeServer("Core","Soru",{})
            end)
            task.wait(COOLDOWN)
        else
            task.wait()
        end
    end
end)

--====================================
-- END
--====================================

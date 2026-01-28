--====================================
-- SORU HOLD UI (PC + MOBILE + KEYBIND UI)
-- fruits battleground
-- by pond
--====================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local lp = Players.LocalPlayer
local Replicator = ReplicatedStorage:WaitForChild("Replicator")

--====================================
-- CONFIG
--====================================
local COOLDOWN = 0.08 -- ปรับความรัวได้
local KEYBIND = Enum.KeyCode.Q -- ปุ่มเริ่มต้น
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
frame.Size = UDim2.fromOffset(90, 130)
frame.Position = UDim2.fromScale(0.5, 0.7)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BackgroundTransparency = 0.1
frame.BorderSizePixel = 0
frame.Parent = gui
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 18)

--====================================
-- SORU BUTTON
--====================================
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, 0, 0.65, 0)
btn.BackgroundTransparency = 1
btn.Text = "⚡\nSORU"
btn.TextScaled = true
btn.Font = Enum.Font.GothamBold
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Parent = frame

--====================================
-- KEYBIND BUTTON
--====================================
local keyBtn = Instance.new("TextButton")
keyBtn.Size = UDim2.new(1, 0, 0.35, 0)
keyBtn.Position = UDim2.new(0, 0, 0.65, 0)
keyBtn.BackgroundColor3 = Color3.fromRGB(30,30,30)
keyBtn.BorderSizePixel = 0
keyBtn.Text = "KEY : "..KEYBIND.Name
keyBtn.TextScaled = true
keyBtn.Font = Enum.Font.Gotham
keyBtn.TextColor3 = Color3.fromRGB(200,200,200)
keyBtn.Parent = frame

local keyCorner = Instance.new("UICorner", keyBtn)
keyCorner.CornerRadius = UDim.new(0, 12)

--====================================
-- HOLD DETECT (BUTTON PC + MOBILE)
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
-- KEYBIND SET UI
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
end)

--====================================
-- HOLD DETECT (KEYBOARD)
--====================================
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
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
-- LOOP SORU
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

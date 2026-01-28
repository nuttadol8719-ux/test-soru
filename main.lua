--====================================
-- SORU UI + DRAG TAB (REAL)
-- fruits battleground
--====================================

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
local Rep = RS:WaitForChild("ReplicatorNoYield")

-- STATE
local Holding = false
local Dragging = false
local DragStart
local StartPos

--====================
-- UI ROOT
--====================
local gui = Instance.new("ScreenGui")
gui.Name = "SoruDragUI"
gui.ResetOnSpawn = false
gui.Parent = lp:WaitForChild("PlayerGui")

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(160, 70)
main.Position = UDim2.fromScale(0.5, 0.8)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(30,30,30)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 12)

--====================
-- DRAG TAB (แถบลาก)
--====================
local dragTab = Instance.new("Frame")
dragTab.Size = UDim2.new(1, 0, 0, 22)
dragTab.BackgroundColor3 = Color3.fromRGB(45,45,45)
dragTab.BorderSizePixel = 0
dragTab.Active = true
dragTab.Parent = main

local tabCorner = Instance.new("UICorner", dragTab)
tabCorner.CornerRadius = UDim.new(0, 12)

local tabText = Instance.new("TextLabel")
tabText.Size = UDim2.fromScale(1,1)
tabText.BackgroundTransparency = 1
tabText.Text = "≡ DRAG"
tabText.Font = Enum.Font.GothamBold
tabText.TextScaled = true
tabText.TextColor3 = Color3.fromRGB(200,200,200)
tabText.Parent = dragTab

--====================
-- SORU BUTTON
--====================
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -10, 0, 38)
btn.Position = UDim2.new(0, 5, 0, 27)
btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
btn.BorderSizePixel = 0
btn.Text = "⚡ S O R U"
btn.Font = Enum.Font.GothamBold
btn.TextScaled = true
btn.TextColor3 = Color3.fromRGB(255,255,255)
btn.Parent = main

local btnCorner = Instance.new("UICorner", btn)
btnCorner.CornerRadius = UDim.new(0, 10)

--====================
-- DRAG SYSTEM
--====================
dragTab.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        StartPos = main.Position
    end
end)

dragTab.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if Dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - DragStart
        main.Position = UDim2.new(
            StartPos.X.Scale,
            StartPos.X.Offset + delta.X,
            StartPos.Y.Scale,
            StartPos.Y.Offset + delta.Y
        )
    end
end)

--====================
-- HOLD = SORU (NO COOLDOWN)
--====================
btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        Holding = true
    end
end)

btn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        Holding = false
    end
end)

task.spawn(function()
    while true do
        if Holding then
            pcall(function()
                Rep:FireServer("Core","Soru",{})
            end)
            task.wait()
        else
            task.wait()
        end
    end
end)

--====================================
-- END
--====================================

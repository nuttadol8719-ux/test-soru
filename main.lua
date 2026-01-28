--====================================
-- MOBILE DASH -> SORU (NO COOLDOWN)
-- fruits battleground
--====================================

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Replicator = ReplicatedStorage:WaitForChild("Replicator")
local RepNoYield = ReplicatedStorage:WaitForChild("ReplicatorNoYield")

-- ป้องกัน hook ซ้ำ
if _G.SORU_DASH_HOOK then return end
_G.SORU_DASH_HOOK = true

local mt = getrawmetatable(game)
setreadonly(mt,false)

local old = mt.__namecall

mt.__namecall = newcclosure(function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    -- ดักเฉพาะ Remote ของเกม
    if (self == Replicator or self == RepNoYield)
    and (method == "FireServer" or method == "InvokeServer")
    and typeof(args[1]) == "string"
    and typeof(args[2]) == "string" then

        local category = args[1]
        local action = args[2]

        -- ถ้าเป็นการกดแดชของเกม
        if category == "Core" and (action == "Dash" or action == "Soru") then
            -- ยิง Soru แทนแบบไม่มีคูลดาวน์
            pcall(function()
                RepNoYield:FireServer("Core","Soru",{})
            end)

            -- ❌ ไม่ให้ของเดิมทำงาน
            return
        end
    end

    return old(self, ...)
end)

setreadonly(mt,true)

-- Memastikan versi lama dihapus
if game:GetService("CoreGui"):FindFirstChild("Forge_Specialist") then
    game:GetService("CoreGui").Forge_Specialist:Destroy()
end

local Library = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local MultiInput = Instance.new("TextBox")
local SpeedToggle = Instance.new("TextButton")
local FPSBtn = Instance.new("TextButton")
local HyperV2 = Instance.new("TextButton") 
local ESPBtn = Instance.new("TextButton")
local ForgeToggle = Instance.new("TextButton") -- Fitur Auto Forge
local CloseBtn = Instance.new("TextButton")
local OpenBtn = Instance.new("TextButton")

_G.MultiHitValue = 1
_G.SpeedValue = 40 
local sOn, fOn, v2On, eOn, forgeOn = false, false, false, false, false

Library.Name = "Forge_Specialist"
Library.Parent = game:GetService("CoreGui")
Library.ResetOnSpawn = false

local function round(obj, res)
    local uic = Instance.new("UICorner")
    uic.CornerRadius = UDim.new(0, res)
    uic.Parent = obj
end

-- Tombol OPEN
OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = Library
OpenBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
OpenBtn.Position = UDim2.new(0, 5, 0.45, 0)
OpenBtn.Size = UDim2.new(0, 45, 0, 20)
OpenBtn.Text = "FORGE"
OpenBtn.Visible = false
OpenBtn.Draggable = true 
round(OpenBtn, 4)

-- Main Frame (Slim & Compact)
MainFrame.Name = "MainFrame"
MainFrame.Parent = Library
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Position = UDim2.new(0.05, 0, 0.25, 0)
MainFrame.Size = UDim2.new(0, 135, 0, 280)
MainFrame.Active = true
MainFrame.Draggable = true 
round(MainFrame, 10)

Title.Text = "FORGE v1.5"
Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 10

CloseBtn.Text = "X"
CloseBtn.Parent = MainFrame
CloseBtn.Size = UDim2.new(0, 20, 0, 20)
CloseBtn.Position = UDim2.new(1, -22, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
round(CloseBtn, 4)

local function createBtn(btn, text, pos, color)
    btn.Parent = MainFrame
    btn.Text = text
    btn.Size = UDim2.new(0.9, 0, 0, 28)
    btn.Position = pos
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 9
    round(btn, 6)
end

-- Layout Menu
MultiInput.Parent = MainFrame
MultiInput.PlaceholderText = "Multi: 1-15"
MultiInput.Size = UDim2.new(0.9, 0, 0, 20)
MultiInput.Position = UDim2.new(0.05, 0, 0.11, 0)
MultiInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MultiInput.TextColor3 = Color3.new(1, 1, 1)
round(MultiInput, 4)

createBtn(HyperV2, "INSANE ATTACK", UDim2.new(0.05, 0, 0.22, 0), Color3.fromRGB(215, 80, 0))
createBtn(ForgeToggle, "AUTO FORGE", UDim2.new(0.05, 0, 0.35, 0), Color3.fromRGB(0, 150, 200))
createBtn(ESPBtn, "ORE ESP", UDim2.new(0.05, 0, 0.48, 0), Color3.fromRGB(142, 68, 173))
createBtn(SpeedToggle, "Speed Hack", UDim2.new(0.05, 0, 0.61, 0))
createBtn(FPSBtn, "Clean Lag", UDim2.new(0.05, 0, 0.85, 0))

-- LOGIKA AUTO FORGE
task.spawn(function()
    while true do
        if forgeOn then
            pcall(function()
                local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
                -- Mencari tombol Forge di UI game secara otomatis
                for _, v in pairs(playerGui:GetDescendants()) do
                    if v:IsA("TextButton") and (v.Text:lower():find("forge") or v.Name:lower():find("forge")) and v.Visible then
                        -- Mengirim sinyal klik virtual
                        firesignal(v.MouseButton1Click)
                    end
                end
            end)
            task.wait(0.1)
        else
            task.wait(0.5)
        end
    end
end)

-- LOGIKA INTERAKSI
ForgeToggle.MouseButton1Click:Connect(function()
    forgeOn = not forgeOn
    ForgeToggle.BackgroundColor3 = forgeOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(0, 150, 200)
end)

MultiInput.FocusLost:Connect(function()
    _G.MultiHitValue = tonumber(MultiInput.Text) or 1
    MultiInput.Text = "Multi: " .. _G.MultiHitValue .. "x"
end)

HyperV2.MouseButton1Click:Connect(function()
    v2On = not v2On
    HyperV2.BackgroundColor3 = v2On and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(215, 80, 0)
end)

ESPBtn.MouseButton1Click:Connect(function()
    eOn = not eOn
    ESPBtn.BackgroundColor3 = eOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(142, 68, 173)
    for _, ore in pairs(workspace:GetDescendants()) do
        if ore:IsA("BasePart") and (ore.Name:find("Ore") or ore.Name:find("Vein")) then
            if eOn then
                local h = Instance.new("Highlight", ore)
                h.Name = "OreH"
                h.FillColor = Color3.new(1,1,0)
            elseif ore:FindFirstChild("OreH") then
                ore.OreH:Destroy()
            end
        end
    end
end)

SpeedToggle.MouseButton1Click:Connect(function()
    sOn = not sOn
    SpeedToggle.BackgroundColor3 = sOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 40, 40)
end)

FPSBtn.MouseButton1Click:Connect(function()
    fOn = not fOn
    FPSBtn.BackgroundColor3 = fOn and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(40, 40, 40)
    if fOn then
        game:GetService("Lighting").GlobalShadows = false
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("BasePart") then v.Material = Enum.Material.Plastic end
        end
    end
end)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenBtn.Visible = false end)

-- ATTACK & SPEED LOOP
task.spawn(function()
    while true do
        local tool = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if v2On and tool then
            for i = 1, _G.MultiHitValue do tool:Activate() end
            task.wait() 
        else task.wait(0.2) end
    end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if sOn then pcall(function() game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.SpeedValue end) end
end)

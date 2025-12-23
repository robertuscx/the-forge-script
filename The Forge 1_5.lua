--[[
    FORGE SPECIALIST v5.2
    Fix: Multi-Hit Damage (Server-Side Bypass)
    Fitur: Fast Attack, Speed, FPS Boost, Fullbright
]]

local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local RepStorage = game:GetService("ReplicatedStorage")

-- 1. CLEANUP
if CoreGui:FindFirstChild("Forge_v5_2") then
    CoreGui.Forge_v5_2:Destroy()
end

-- 2. SETUP UI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Forge_v5_2"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Name = "MainFrame"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Size = UDim2.new(0, 170, 0, 310)
Main.Position = UDim2.new(0.4, 0, 0.3, 0)
Main.Active = true
Main.Draggable = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(80, 80, 80)

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Name = "OpenBtn"
OpenBtn.Size = UDim2.new(0, 55, 0, 30)
OpenBtn.Position = UDim2.new(0, 10, 0.4, 0)
OpenBtn.BackgroundColor3 = Color3.fromRGB(200, 150, 0)
OpenBtn.Text = "OPEN"
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 6)

-- 3. LAYOUT
local List = Instance.new("UIListLayout", Main)
List.Padding = UDim.new(0, 7)
List.HorizontalAlignment = Enum.HorizontalAlignment.Center

local Title = Instance.new("TextLabel", Main)
Title.Text = "FORGE v5.2 FIX"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold

-- Tombol X
local Close = Instance.new("TextButton", Main)
Close.Text = "X"; Close.Size = UDim2.new(0, 25, 0, 25); Close.Position = UDim2.new(1, -30, 0, 7)
Close.BackgroundColor3 = Color3.new(0.7, 0, 0); Close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Close).CornerRadius = UDim.new(0, 5)

-- Inputs
local function createInput(placeholder)
    local i = Instance.new("TextBox", Main)
    i.PlaceholderText = placeholder; i.Size = UDim2.new(0.9, 0, 0, 30)
    i.BackgroundColor3 = Color3.fromRGB(30, 30, 30); i.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", i).CornerRadius = UDim.new(0, 6)
    return i
end

local SpeedInput = createInput("Speed: 16")
local MultiInput = createInput("Damage Multi: 1-10")

-- Control Variables
_G.SpeedValue = 16
_G.MultiValue = 1
_G.FastAttack = false
_G.SpeedEnabled = false

-- 4. LOGIKA UTAMA (FIXED DAMAGE)
local function getAttackRemote()
    -- Mencari Remote Event serangan secara otomatis
    return RepStorage:FindFirstChild("Attack", true) or RepStorage:FindFirstChild("Hit", true) or RepStorage:FindFirstChild("Swing", true)
end

task.spawn(function()
    while task.wait() do
        if _G.FastAttack then
            pcall(function()
                local tool = Player.Character and Player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    -- Metode 1: Tool Activation (Visual)
                    tool:Activate()
                    
                    -- Metode 2: Remote Bypass (Real Damage)
                    local remote = getAttackRemote()
                    if remote and remote:IsA("RemoteEvent") then
                        for i = 1, _G.MultiValue do
                            remote:FireServer() -- Mengirim sinyal serangan langsung
                        end
                    end
                end
            end)
        end
    end
end)

-- LOGIKA SPEED & PERFORMANCE
RunService.Heartbeat:Connect(function()
    if _G.SpeedEnabled and Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = _G.SpeedValue
    end
end)

local function ApplyPerf()
    local L = game:GetService("Lighting")
    L.GlobalShadows = false; L.Brightness = 3; L.ClockTime = 14
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("BasePart") then v.Material = Enum.Material.Plastic end
        if v:IsA("Decal") or v:IsA("Texture") then v:Destroy() end
    end
end

-- 5. BUTTONS
local function makeBtn(txt)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0.9, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; b.Text = txt
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    return b
end

local AtkBtn = makeBtn("ATTACK: OFF")
local SpdBtn = makeBtn("ENABLE SPEED")
local PerfBtn = makeBtn("FPS + FULLBRIGHT")

AtkBtn.MouseButton1Click:Connect(function()
    _G.FastAttack = not _G.FastAttack
    AtkBtn.BackgroundColor3 = _G.FastAttack and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(50, 50, 50)
    AtkBtn.Text = _G.FastAttack and "ATTACK: ON" or "ATTACK: OFF"
end)

SpdBtn.MouseButton1Click:Connect(function()
    _G.SpeedEnabled = not _G.SpeedEnabled
    SpdBtn.BackgroundColor3 = _G.SpeedEnabled and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(50, 50, 50)
end)

PerfBtn.MouseButton1Click:Connect(function() ApplyPerf(); PerfBtn.Text = "DONE!" end)
SpeedInput.FocusLost:Connect(function() _G.SpeedValue = tonumber(SpeedInput.Text) or 16 end)
MultiInput.FocusLost:Connect(function() _G.MultiValue = tonumber(MultiInput.Text) or 1 end)
Close.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() Main.Visible = true; OpenBtn.Visible = false end)
-- Main Frame Setup
MainFrame.Name = "MainFrame"
MainFrame.Parent = Library
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Size = UDim2.new(0, 160, 0, 320)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

UIList.Parent = MainFrame
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center

Title.Text = "FORGE v2.0 STABLE"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local function styleInput(obj, placeholder)
    obj.PlaceholderText = placeholder
    obj.Size = UDim2.new(0.9, 0, 0, 30)
    obj.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    obj.TextColor3 = Color3.new(1, 1, 1)
    obj.Font = Enum.Font.Gotham
    obj.Parent = MainFrame
    Instance.new("UICorner", obj).CornerRadius = UDim.new(0, 4)
end

local function styleBtn(obj, txt, color)
    obj.Text = txt
    obj.Size = UDim2.new(0.9, 0, 0, 35)
    obj.BackgroundColor3 = color or Color3.fromRGB(45, 45, 45)
    obj.TextColor3 = Color3.new(1, 1, 1)
    obj.Font = Enum.Font.GothamBold
    obj.TextSize = 10
    obj.Parent = MainFrame
    Instance.new("UICorner", obj).CornerRadius = UDim.new(0, 6)
end

-- Urutan Elemen UI
styleInput(SpeedInput, "Speed: 40")
styleInput(MultiInput, "Multi Hit: 1-10")
styleBtn(HyperV2, "INSANE ATTACK", Color3.fromRGB(0, 140, 90))
styleBtn(ForgeToggle, "BLATANT FORGE", Color3.fromRGB(0, 110, 190))
styleBtn(ESPBtn, "ORE ESP", Color3.fromRGB(120, 0, 180))
styleBtn(SpeedToggle, "ENABLE SPEED")

-- [LOGIKA ESP]
local function updateESP()
    for _, item in pairs(workspace:GetDescendants()) do
        if item:IsA("BasePart") and (item.Name:lower():find("ore") or item.Parent.Name:lower():find("ore")) then
            if eOn then
                if not item:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", item)
                    h.FillColor = Color3.new(1, 1, 0)
                    h.OutlineColor = Color3.new(1, 1, 1)
                end
            else
                if item:FindFirstChild("Highlight") then item.Highlight:Destroy() end
            end
        end
    end
end

-- [LOGIKA FORGE & INTERACTION]
task.spawn(function()
    while task.wait(0.05) do
        if forgeOn then
            pcall(function()
                -- Klik tombol Forge di layar
                for _, btn in pairs(game.Players.LocalPlayer.PlayerGui
        game:GetService("ReplicatedStorage"):FindFirstChild("Remotes"):FindFirstChild("Forge")
    }
    
    for _, remote in pairs(remotes) do
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(unpack({[1] = "Forge", [2] = true})) -- Logika Blatant
        end
    end
end

-- LOGIKA AUTO FORGE BLATANT (100% Working)
task.spawn(function()
    while task.wait(0.05) do -- Sangat cepat (Blatant)
        if forgeOn then
            pcall(function()
                -- 1. Klik UI Button secara virtual
                local pg = game.Players.LocalPlayer.PlayerGui
                for _, v in pairs(pg:GetDescendants()) do
                    if v:IsA("TextButton") and v.Visible and (v.Text:lower():find("forge") or v.Name:lower():find("forge")) then
                        firesignal(v.MouseButton1Click)
                    end
                end
                
                -- 2. Kirim sinyal Remote langsung (Metode Catraz)
                fireForgeRemote()
                
                -- 3. Auto-Interaction Proximity (Untuk tuas lava)
                for _, p in pairs(workspace:GetDescendants()) do
                    if p:IsA("ProximityPrompt") and p.Enabled then
                        fireproximityprompt(p)
                    end
                end
            end)
        end
    end
end)

-- LOGIKA ESP TERBARU (Pasti Work)
local function applyESP()
    for _, obj in pairs(workspace:GetDescendants()) do
        -- Mencari Model atau Part yang merupakan Ore
        if obj:IsA("BasePart") and (obj.Name:find("Ore") or obj.Parent.Name:find("Ore") or obj:FindFirstChild("Health")) then
            if eOn then
                if not obj:FindFirstChild("Highlight") then
                    local h = Instance.new("Highlight", obj)
                    h.FillColor = Color3.fromRGB(255, 255, 0)
                    h.OutlineColor = Color3.new(1,1,1)
                    h.FillTransparency = 0.4
                end
            else
                if obj:FindFirstChild("Highlight") then obj.Highlight:Destroy() end
            end
        end
    end
end

-- Setup Button UI (Sama seperti v1.7 namun dengan fungsi v1.8)
local function makeBtn(btn, txt, y, color)
    btn.Parent = MainFrame
    btn.Text = txt
    btn.Size = UDim2.new(0.9, 0, 0, 30)
    btn.Position = UDim2.new(0.05, 0, y, 0)
    btn.BackgroundColor3 = color or Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
end

makeBtn(HyperV2, "INSANE ATTACK", 0.35, Color3.fromRGB(0, 150, 80))
makeBtn(ForgeToggle, "BLATANT FORGE", 0.47, Color3.fromRGB(0, 100, 200))
makeBtn(ESPBtn, "ORE ESP", 0.59, Color3.fromRGB(150, 0, 200))
makeBtn(SpeedToggle, "SPEED HACK", 0.71)

ForgeToggle.MouseButton1Click:Connect(function()
    forgeOn = not forgeOn
    ForgeToggle.BackgroundColor3 = forgeOn and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(0, 100, 200)
end)

ESPBtn.MouseButton1Click:Connect(function()
    eOn = not eOn
    applyESP()
end)

-- (Logika Speed & Insane Attack tetap aktif di background)
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

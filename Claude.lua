--[[
    🥚 Steal and Hatch a Brainrot Egg Script
    Created for しゅう様
    Rayfield UI Implementation
]]

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local RemoteEvent = ReplicatedStorage:WaitForChild("RemoteEvent")
local Map = Workspace:WaitForChild("Map")

-- Settings
local Settings = {
    AutoRebirth = false,
    AutoFlip = false,
    AutoBuyGear = false,
    AutoHatchEgg = false,
    SelectedEggCategory = "Normal",
    TeleportLocation = "Spawn"
}

-- Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = Rayfield:CreateWindow({
    Name = "🥚 Brainrot Egg Script | しゅう様専用",
    LoadingTitle = "Brainrot Egg Script",
    LoadingSubtitle = "by しゅう様",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "BrainrotEggScript",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- Tabs
local MainTab = Window:CreateTab("🏠 Main", 4483362458)
local RebirthTab = Window:CreateTab("🔄 Rebirth", 4483362458)
local EggTab = Window:CreateTab("🥚 Eggs", 4483362458)
local GearTab = Window:CreateTab("⚔️ Gear", 4483362458)
local TeleportTab = Window:CreateTab("📍 Teleport", 4483362458)
local MiscTab = Window:CreateTab("⚙️ Misc", 4483362458)

-- Main Tab
local PlayerSection = MainTab:CreateSection("Player Info")

local PlayerLabel = MainTab:CreateLabel("Player: " .. LocalPlayer.Name)
local RebirthsLabel = MainTab:CreateLabel("Rebirths: Loading...")
local CoinsLabel = MainTab:CreateLabel("Coins: Loading...")

-- Update Player Stats
task.spawn(function()
    while wait(1) do
        pcall(function()
            local rebirths = LocalPlayer:GetAttribute("Rebirths") or 0
            local coins = LocalPlayer:GetAttribute("Coins") or 0
            RebirthsLabel:Set("Rebirths: " .. rebirths)
            CoinsLabel:Set("Coins: " .. coins)
        end)
    end
end)

-- Rebirth Tab
local RebirthSection = RebirthTab:CreateSection("Auto Rebirth")

local AutoRebirthToggle = RebirthTab:CreateToggle({
    Name = "Auto Rebirth",
    CurrentValue = false,
    Flag = "AutoRebirth",
    Callback = function(Value)
        Settings.AutoRebirth = Value
    end,
})

local RebirthButton = RebirthTab:CreateButton({
    Name = "Rebirth Once",
    Callback = function()
        RemoteEvent:FireServer({"Rebirth_Request"})
        Rayfield:Notify({
            Title = "Rebirth",
            Content = "Rebirth request sent!",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

-- Auto Rebirth Loop
task.spawn(function()
    while wait(0.5) do
        if Settings.AutoRebirth then
            pcall(function()
                RemoteEvent:FireServer({"Rebirth_Request"})
            end)
        end
    end
end)

-- Egg Tab
local EggSection = EggTab:CreateSection("Auto Hatch Eggs")

local EggCategoryDropdown = EggTab:CreateDropdown({
    Name = "Select Egg Category",
    Options = {"Normal", "Gold", "Diamond", "Bloodmoon", "YinYang"},
    CurrentOption = "Normal",
    Flag = "EggCategory",
    Callback = function(Option)
        Settings.SelectedEggCategory = Option
    end,
})

local AutoHatchToggle = EggTab:CreateToggle({
    Name = "Auto Hatch Eggs",
    CurrentValue = false,
    Flag = "AutoHatch",
    Callback = function(Value)
        Settings.AutoHatchEgg = Value
    end,
})

-- Auto Hatch Loop (需要根据实际游戏机制调整)
task.spawn(function()
    while wait(1) do
        if Settings.AutoHatchEgg then
            pcall(function()
                -- 卵孵化逻辑需要根据游戏实际机制实现
                -- 这里仅为示例框架
                local eggLocation = Map:FindFirstChild(Settings.SelectedEggCategory .. "Eggs")
                if eggLocation then
                    -- 实际孵化逻辑
                end
            end)
        end
    end
end)

-- Gear Tab
local GearSection = GearTab:CreateSection("Auto Buy Gear")

local AutoBuyGearToggle = GearTab:CreateToggle({
    Name = "Auto Buy All Gears",
    CurrentValue = false,
    Flag = "AutoBuyGear",
    Callback = function(Value)
        Settings.AutoBuyGear = Value
    end,
})

-- Common Gear Names (需要根据游戏实际装备名称调整)
local GearList = {
    "Gear1", "Gear2", "Gear3", "Gear4", "Gear5",
    "Gear6", "Gear7", "Gear8", "Gear9", "Gear10"
}

-- Auto Buy Gear Loop
task.spawn(function()
    while wait(2) do
        if Settings.AutoBuyGear then
            for _, gearName in ipairs(GearList) do
                pcall(function()
                    RemoteEvent:FireServer({"BuyGear_Request", gearName})
                end)
                wait(0.1)
            end
        end
    end
end)

-- Manual Gear Buttons
for i, gearName in ipairs(GearList) do
    GearTab:CreateButton({
        Name = "Buy " .. gearName,
        Callback = function()
            RemoteEvent:FireServer({"BuyGear_Request", gearName})
            Rayfield:Notify({
                Title = "Gear Purchase",
                Content = "Attempted to buy " .. gearName,
                Duration = 2,
                Image = 4483362458,
            })
        end,
    })
end

-- Teleport Tab
local TeleportSection = TeleportTab:CreateSection("Teleport Locations")

local TeleportLocations = {
    ["Spawn"] = CFrame.new(0, 5, 0),
    ["Shop"] = CFrame.new(100, 5, 0),
    ["Egg Area"] = CFrame.new(-100, 5, 0),
    ["Rebirth Area"] = CFrame.new(0, 5, 100),
}

for locationName, cframe in pairs(TeleportLocations) do
    TeleportTab:CreateButton({
        Name = "Teleport to " .. locationName,
        Callback = function()
            pcall(function()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
                    Rayfield:Notify({
                        Title = "Teleport",
                        Content = "Teleported to " .. locationName,
                        Duration = 2,
                        Image = 4483362458,
                    })
                end
            end)
        end,
    })
end

-- Misc Tab
local MiscSection = MiscTab:CreateSection("Miscellaneous")

local AutoFlipToggle = MiscTab:CreateToggle({
    Name = "Auto Flip",
    CurrentValue = false,
    Flag = "AutoFlip",
    Callback = function(Value)
        Settings.AutoFlip = Value
    end,
})

-- Auto Flip Loop
task.spawn(function()
    while wait(0.1) do
        if Settings.AutoFlip then
            pcall(function()
                RemoteEvent:FireServer({"Flip_Request"})
            end)
        end
    end
end)

local WalkSpeedSlider = MiscTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = Value
            end
        end)
    end,
})

local JumpPowerSlider = MiscTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 300},
    Increment = 1,
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.JumpPower = Value
            end
        end)
    end,
})

-- Character Added Event
LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1)
    pcall(function()
        if Settings.WalkSpeed then
            character:WaitForChild("Humanoid").WalkSpeed = Settings.WalkSpeed
        end
        if Settings.JumpPower then
            character:WaitForChild("Humanoid").JumpPower = Settings.JumpPower
        end
    end)
end)

-- Final Notification
Rayfield:Notify({
    Title = "Script Loaded",
    Content = "🥚 Brainrot Egg Script loaded successfully, しゅう様!",
    Duration = 5,
    Image = 4483362458,
})

print("🥚 Brainrot Egg Script loaded for しゅう様")

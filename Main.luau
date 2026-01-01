local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "AverageSpoofer Plus",
    LoadingTitle = "hello my friend",
    LoadingSubtitle = "by flexOwner",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AverageSpooferPro",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvite",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "AverageSpoofer Plus",
        Subtitle = "Enter Key",
        Note = "Key: in description",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"nowFree"}
    }
})

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local OriginalUserId = LocalPlayer.UserId
local IsSpoofed = false
local IsReverseSpoofed = false
local HasReset = false

local Flying = false
local FlySpeed = 50
local Noclipping = false
local OriginalWalkSpeed = 16
local ESPEnabled = false
local ESPBoxes = {}

local MainTab = Window:CreateTab("ID Spoofing", 6023426915)
MainTab:CreateSection("Spoofing")

local function GetOwnerId()
    if game.CreatorType == Enum.CreatorType.User then
        return game.CreatorId
    end
    return 0
end

MainTab:CreateButton({
    Name = "spoof to owner",
    Callback = function()
        if IsSpoofed then return end
        local ownerId = GetOwnerId()
        if ownerId > 0 then
            LocalPlayer.UserId = ownerId
            IsSpoofed = true
            IsReverseSpoofed = false
            Rayfield:Notify({
                Title = "success",
                Content = "spoofed to Owner ID: " .. ownerId,
                Duration = 3
            })
        end
    end,
})

MainTab:CreateButton({
    Name = "reverse spoof",
    Callback = function()
        if IsReverseSpoofed then return end
        local reversedId = -OriginalUserId
        LocalPlayer.UserId = reversedId
        IsReverseSpoofed = true
        IsSpoofed = false
        Rayfield:Notify({
            Title = "Success",
            Content = "spoofed to Reverse ID: " .. reversedId,
            Duration = 3
        })
    end,
})

MainTab:CreateButton({
    Name = "reset spoof",
    Callback = function()
        LocalPlayer.UserId = OriginalUserId
        IsSpoofed = false
        IsReverseSpoofed = false
        HasReset = false
        Rayfield:Notify({
            Title = "success",
            Content = "reset to Original ID",
            Duration = 3
        })
    end,
})

MainTab:CreateLabel("original id: " .. tostring(OriginalUserId))

local MovementTab = Window:CreateTab("Movement", 6023426926)
MovementTab:CreateSection("speed")

local WalkSpeedSlider = MovementTab:CreateSlider({
    Name = "walk speed",
    Range = {16, 200},
    Increment = 1,
    Suffix = " studs/s",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
            OriginalWalkSpeed = Value
        end
    end,
})

MovementTab:CreateSection("fly")

local FlyToggle = MovementTab:CreateToggle({
    Name = "toggle flight",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        Flying = Value
        if Flying then
            Rayfield:Notify({
                Title = "Flight",
                Content = "Flight Enabled - Use W/A/S/D to fly",
                Duration = 3
            })
        end
    end,
})

local FlySpeedSlider = MovementTab:CreateSlider({
    Name = "flight speed",
    Range = {10, 300},
    Increment = 5,
    Suffix = " studs/s",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        FlySpeed = Value
    end,
})

RunService.Heartbeat:Connect(function()
    if Flying and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local HRP = LocalPlayer.Character.HumanoidRootPart
        local Humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        
        local Velocity = Vector3.new(0, 0, 0)
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            Velocity = Velocity + (HRP.CFrame.LookVector * FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            Velocity = Velocity - (HRP.CFrame.LookVector * FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            Velocity = Velocity - (HRP.CFrame.RightVector * FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            Velocity = Velocity + (HRP.CFrame.RightVector * FlySpeed)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            Velocity = Velocity + Vector3.new(0, FlySpeed, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            Velocity = Velocity - Vector3.new(0, FlySpeed, 0)
        end
        
        HRP.Velocity = Velocity
        if Humanoid then
            Humanoid.PlatformStand = true
        end
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.PlatformStand = false
    end
end)

MovementTab:CreateSection("noclip")

local NoclipToggle = MovementTab:CreateToggle({
    Name = "toggle noclip",
    CurrentValue = false,
    Flag = "NocliplToggle",
    Callback = function(Value)
        Noclipping = Value
    end,
})

RunService.Stepped:Connect(function()
    if Noclipping and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

MovementTab:CreateSection("jump")

local JumpPowerSlider = MovementTab:CreateSlider({
    Name = "jump power",
    Range = {50, 300},
    Increment = 5,
    Suffix = " power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = Value
        end
    end,
})

local VisualTab = Window:CreateTab("Visuals", 6023426933)
VisualTab:CreateSection("esp")

local function CreateESP(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    
    local Box = Instance.new("BoxHandleAdornment")
    Box.Size = Vector3.new(4, 6, 1)
    Box.Color3 = Color3.fromRGB(255, 0, 0)
    Box.Transparency = 0.5
    Box.AlwaysOnTop = true
    Box.Adornee = player.Character:FindFirstChild("HumanoidRootPart")
    Box.ZIndex = 5
    Box.Parent = game:GetService("CoreGui")
    
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(0, 100, 0, 20)
    NameLabel.BackgroundTransparency = 1
    NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameLabel.TextSize = 14
    NameLabel.Text = player.Name
    NameLabel.Font = Enum.Font.GothamBold
    NameLabel.Parent = Box
    
    ESPBoxes[player] = Box
    
    player.CharacterAdded:Connect(function()
        if ESPBoxes[player] then
            ESPBoxes[player]:Destroy()
            ESPBoxes[player] = nil
        end
        if ESPEnabled then
            task.wait(1)
            CreateESP(player)
        end
    end)
end

local function RemoveESP(player)
    if ESPBoxes[player] then
        ESPBoxes[player]:Destroy()
        ESPBoxes[player] = nil
    end
end

VisualTab:CreateToggle({
    Name = "player esp",
    CurrentValue = false,
    Flag = "PlayerESP",
    Callback = function(Value)
        ESPEnabled = Value
        
        if ESPEnabled then
            for _, player in pairs(Players:GetPlayers()) do
                CreateESP(player)
            end
            
            Players.PlayerAdded:Connect(function(player)
                CreateESP(player)
            end)
        else
            for _, player in pairs(Players:GetPlayers()) do
                RemoveESP(player)
            end
        end
    end,
})

VisualTab:CreateSection("world")

VisualTab:CreateButton({
    Name = "fullbright",
    Callback = function()
        local Lighting = game:GetService("Lighting")
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Rayfield:Notify({
            Title = "Fullbright",
            Content = "Fullbright Enabled",
            Duration = 3
        })
    end,
})

VisualTab:CreateToggle({
    Name = "chams",
    CurrentValue = false,
    Flag = "ChamsToggle",
    Callback = function(Value)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.Transparency = Value and 0.3 or 0
                        part.Material = Value and Enum.Material.ForceField or Enum.Material.Plastic
                    end
                end
            end
        end
    end,
})

local SettingsTab = Window:CreateTab("Settings", 6023426941)
SettingsTab:CreateSection("info")

SettingsTab:CreateLabel("AverageSpoofer Pro v2.0")
SettingsTab:CreateLabel("player:" .. LocalPlayer.Name)
SettingsTab:CreateLabel("id:" .. tostring(OriginalUserId))

SettingsTab:CreateSection("utils")

SettingsTab:CreateButton({
    Name = "rejoin server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end,
})

SettingsTab:CreateButton({
    Name = "server hop",
    Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        
        pcall(function()
            local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            
            if Servers and Servers.data then
                for _, server in pairs(Servers.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        TPS:TeleportToPlaceInstance(game.PlaceId, server.id)
                        return
                    end
                end
            end
            Rayfield:Notify({
                Title = "Error",
                Content = "No suitable servers found",
                Duration = 3
            })
        end)
    end,
})

SettingsTab:CreateButton({
    Name = "destroy gui",
    Callback = function()
        Rayfield:Destroy()
    end,
})

LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    if OriginalWalkSpeed ~= 16 and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = OriginalWalkSpeed
    end
end)

Rayfield:Notify({
    Title = "Loaded",
    Content = "averageSpoofer byy flexowner",
    Duration = 2
})

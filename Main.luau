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
local HttpService = game:GetService("HttpService")

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

local MainTab = Window:CreateTab("ID Spoofing", 4483345998)
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
        if IsSpoofed then 
            Rayfield:Notify({
                Title = "Already Spoofed",
                Content = "Already spoofed! Reset first.",
                Duration = 3
            })
            return 
        end
        
        local success, result = pcall(function()
            local ownerId = GetOwnerId()
            if ownerId > 0 then
                local oldId = LocalPlayer.UserId
                LocalPlayer.UserId = ownerId
                
                IsSpoofed = true
                IsReverseSpoofed = false
                
                Rayfield:Notify({
                    Title = "Success",
                    Content = "Spoofed from " .. oldId .. " to Owner ID: " .. ownerId,
                    Duration = 5
                })
                return true
            else
                return false
            end
        end)
        
        if not success then
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to spoof: " .. tostring(result),
                Duration = 5
            })
        elseif not result then
            Rayfield:Notify({
                Title = "Error",
                Content = "Could not find owner ID",
                Duration = 3
            })
        end
    end,
})

MainTab:CreateButton({
    Name = "reverse spoof",
    Callback = function()
        if IsReverseSpoofed then 
            Rayfield:Notify({
                Title = "Already Reversed",
                Content = "Already reverse spoofed! Reset first.",
                Duration = 3
            })
            return 
        end
        
        local success, result = pcall(function()
            local reversedId = -OriginalUserId
            local oldId = LocalPlayer.UserId
            LocalPlayer.UserId = reversedId
            
            IsReverseSpoofed = true
            IsSpoofed = false
            
            Rayfield:Notify({
                Title = "Success",
                Content = "Spoofed from " .. oldId .. " to Reverse ID: " .. reversedId,
                Duration = 5
            })
            return true
        end)
        
        if not success then
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to reverse spoof: " .. tostring(result),
                Duration = 5
            })
        end
    end,
})

MainTab:CreateButton({
    Name = "reset spoof",
    Callback = function()
        local success, result = pcall(function()
            LocalPlayer.UserId = OriginalUserId
            IsSpoofed = false
            IsReverseSpoofed = false
            HasReset = false
            
            Rayfield:Notify({
                Title = "Success",
                Content = "Reset to Original ID: " .. OriginalUserId,
                Duration = 5
            })
            return true
        end)
        
        if not success then
            Rayfield:Notify({
                Title = "Error",
                Content = "Failed to reset: " .. tostring(result),
                Duration = 5
            })
        end
    end,
})

MainTab:CreateLabel("original id: " .. tostring(OriginalUserId))

local MovementTab = Window:CreateTab("Movement", 7733765391)
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

local VisualTab = Window:CreateTab("Visuals", 6031304473)
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

local SettingsTab = Window:CreateTab("Settings", 6031280882)
SettingsTab:CreateSection("info")

SettingsTab:CreateLabel("AverageSpoofer Pro v2.0")
SettingsTab:CreateLabel("Player: " .. LocalPlayer.Name)
SettingsTab:CreateLabel("User ID: " .. tostring(OriginalUserId))
SettingsTab:CreateLabel("Account Age: " .. tostring(LocalPlayer.AccountAge) .. " days")
SettingsTab:CreateLabel("Game ID: " .. game.PlaceId)
SettingsTab:CreateLabel("Job ID: " .. game.JobId)
SettingsTab:CreateLabel("FPS: " .. tostring(math.floor(1/RunService.RenderStepped:Wait())))

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
    Name = "copy game link",
    Callback = function()
        local link = "https://www.roblox.com/games/" .. game.PlaceId .. "/"
        setclipboard(link)
        Rayfield:Notify({
            Title = "Copied",
            Content = "Game link copied to clipboard",
            Duration = 3
        })
    end,
})

SettingsTab:CreateButton({
    Name = "copy job id",
    Callback = function()
        setclipboard(game.JobId)
        Rayfield:Notify({
            Title = "Copied",
            Content = "Job ID copied to clipboard",
            Duration = 3
        })
    end,
})

SettingsTab:CreateButton({
    Name = "copy player list",
    Callback = function()
        local playersText = ""
        for _, player in pairs(Players:GetPlayers()) do
            playersText = playersText .. player.Name .. " (" .. player.UserId .. ")\n"
        end
        setclipboard(playersText)
        Rayfield:Notify({
            Title = "Copied",
            Content = "Player list copied to clipboard",
            Duration = 3
        })
    end,
})

SettingsTab:CreateButton({
    Name = "anti afk",
    Callback = function()
        local GC = getconnections or get_signal_cons
        if GC then
            for _, v in pairs(GC(LocalPlayer.Idled)) do
                v:Disable()
            end
        end
        Rayfield:Notify({
            Title = "Anti-AFK",
            Content = "Anti-AFK Enabled",
            Duration = 3
        })
    end,
})

SettingsTab:CreateButton({
    Name = "reset character",
    Callback = function()
        if LocalPlayer.Character then
            LocalPlayer.Character:BreakJoints()
        end
    end,
})

SettingsTab:CreateButton({
    Name = "infinite yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
})

SettingsTab:CreateButton({
    Name = "chat spy",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/FilteringEnabled/FE-Chat-Spy/main/main.lua"))()
    end,
})

SettingsTab:CreateToggle({
    Name = "auto respawn",
    CurrentValue = false,
    Flag = "AutoRespawn",
    Callback = function(Value)
        if Value then
            LocalPlayer.CharacterAdded:Connect(function()
                task.wait(0.5)
                if OriginalWalkSpeed ~= 16 and LocalPlayer.Character:FindFirstChild("Humanoid") then
                    LocalPlayer.Character.Humanoid.WalkSpeed = OriginalWalkSpeed
                end
            end)
        end
    end,
})

SettingsTab:CreateSlider({
    Name = "fov changer",
    Range = {70, 120},
    Increment = 1,
    Suffix = " FOV",
    CurrentValue = 70,
    Flag = "FOVSlider",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.CameraOffset = Vector3.new(0, 0, 0)
            workspace.CurrentCamera.FieldOfView = Value
        end
    end,
})

SettingsTab:CreateButton({
    Name = "hide gui",
    Callback = function()
        Rayfield:Toggle()
    end,
})

SettingsTab:CreateButton({
    Name = "destroy gui",
    Callback = function()
        Rayfield:Destroy()
    end,
})

SettingsTab:CreateSection("performance")

SettingsTab:CreateButton({
    Name = "low graphics",
    Callback = function()
        local settings = game:GetService("UserGameSettings")
        settings.SavedQualityLevel = Enum.QualityLevel.Level01
        settings:SetQualityLevel(Enum.QualityLevel.Level01)
        
        local Lighting = game:GetService("Lighting")
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 100000
        
        Rayfield:Notify({
            Title = "Graphics",
            Content = "Set to Low Graphics",
            Duration = 3
        })
    end,
})

SettingsTab:CreateButton({
    Name = "unlock fps",
    Callback = function()
        setfpscap(999)
        Rayfield:Notify({
            Title = "FPS",
            Content = "FPS Unlocked",
            Duration = 3
        })
    end,
})

LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    if OriginalWalkSpeed ~= 16 and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = OriginalWalkSpeed
    end
end)

-- FPS Counter
spawn(function()
    while task.wait(1) do
        if SettingsTab then
            local fps = tostring(math.floor(1/RunService.RenderStepped:Wait()))
            for _, element in pairs(SettingsTab:GetElements()) do
                if element.Name and element.Name:find("FPS:") then
                    element:Set("FPS: " .. fps)
                    break
                end
            end
        end
    end
end)

Rayfield:Notify({
    Title = "Loaded",
    Content = "averageSpoofer byy flexowner",
    Duration = 2
})

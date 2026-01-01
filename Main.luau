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

-- ============================================
-- MAIN TAB - ID SPOOFING (IMPROVED FROM PRO VERSION)
-- ============================================
local MainTab = Window:CreateTab("ID Spoofing", 4483362458)
MainTab:CreateSection("Spoofing")

local function GetOwnerId()
    if game.CreatorType == Enum.CreatorType.User then
        return game.CreatorId
    end
    
    if game.CreatorType == Enum.CreatorType.Group then
        local success, result = pcall(function()
            return game:GetService("GroupService"):GetGroupInfoAsync(game.CreatorId).Owner.Id
        end)
        if success then
            return result
        end
    end
    
    return 0
end

local function SpoofToOwner()
    if IsSpoofed then 
        Rayfield:Notify({
           Title = "⚠️ Already Spoofed",
           Content = "You're already spoofed as owner",
           Duration = 3,
           Image = 4483362458,
        })
        return 
    end
    
    local ownerId = GetOwnerId()
    if ownerId <= 0 then
        Rayfield:Notify({
           Title = "❌ Error",
           Content = "Failed to retrieve owner ID",
           Duration = 3,
           Image = 4483362458,
        })
        return
    end
    
    local oldId = LocalPlayer.UserId
    LocalPlayer.UserId = ownerId
    IsSpoofed = true
    IsReverseSpoofed = false
    
    Rayfield:Notify({
       Title = "✅ Spoofed Successfully",
       Content = "Spoofed from " .. oldId .. " to Owner ID: " .. ownerId,
       Duration = 5,
       Image = 4483362458,
    })
end

local function ReverseSpoof()
    if IsReverseSpoofed then 
        Rayfield:Notify({
           Title = "⚠️ Already Active",
           Content = "Reverse spoof is already running",
           Duration = 3,
           Image = 4483362458,
        })
        return 
    end
    
    local ownerId = GetOwnerId()
    if ownerId <= 0 then
        Rayfield:Notify({
           Title = "❌ Error",
           Content = "Failed to retrieve owner ID",
           Duration = 3,
           Image = 4483362458,
        })
        return
    end
    
    LocalPlayer.UserId = ownerId
    task.wait(0.1)
    
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
        LocalPlayer.Character.Head:Destroy()
    end
    
    IsReverseSpoofed = true
    HasReset = false
    
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    char:WaitForChild("Humanoid").Died:Connect(function()
        if not HasReset then
            HasReset = true
        else
            task.wait(0.1)
            LocalPlayer.UserId = OriginalUserId
            IsReverseSpoofed = false
            Rayfield:Notify({
               Title = "🔄 Restored",
               Content = "ID restored to original",
               Duration = 3,
               Image = 4483362458,
            })
        end
    end)
    
    Rayfield:Notify({
       Title = "🔀 Reverse Spoofed",
       Content = "Owner now sees you as themselves",
       Duration = 5,
       Image = 4483362458,
    })
end

local function ResetSpoof()
    LocalPlayer.UserId = OriginalUserId
    IsSpoofed = false
    IsReverseSpoofed = false
    HasReset = false
    
    Rayfield:Notify({
       Title = "🔄 Reset Complete",
       Content = "ID restored to original value: " .. OriginalUserId,
       Duration = 5,
       Image = 4483362458,
    })
end

MainTab:CreateButton({
    Name = "spoof to owner",
    Callback = SpoofToOwner,
})

MainTab:CreateButton({
    Name = "reverse spoof",
    Callback = ReverseSpoof,
})

MainTab:CreateButton({
    Name = "reset spoof",
    Callback = ResetSpoof,
})

MainTab:CreateLabel("original id: " .. tostring(OriginalUserId))

local MovementTab = Window:CreateTab("Movement", 4483362458)
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

MovementTab:CreateButton({
   Name = "🔄 Reset Walk Speed",
   Callback = function()
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.WalkSpeed = 16
           OriginalWalkSpeed = 16
           WalkSpeedSlider:Set(16)
           Rayfield:Notify({
              Title = "✅ Reset",
              Content = "Walk speed reset to default",
              Duration = 2,
              Image = 4483362458,
           })
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
               Title = "✈️ Flight Enabled",
               Content = "Use WASD/mobile controls to fly",
               Duration = 3,
               Image = 4483362458,
            })
        else
            Rayfield:Notify({
               Title = "✅ Flight Disabled",
               Content = "You are no longer flying",
               Duration = 2,
               Image = 4483362458,
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
        local Camera = workspace.CurrentCamera
        
        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Flying)
        end
        
        local MoveDirection = Vector3.new()
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            MoveDirection = MoveDirection + Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            MoveDirection = MoveDirection - Camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            MoveDirection = MoveDirection - Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            MoveDirection = MoveDirection + Camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            MoveDirection = MoveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
            MoveDirection = MoveDirection - Vector3.new(0, 1, 0)
        end
        
        if Humanoid and Humanoid.MoveDirection.Magnitude > 0 then
            MoveDirection = MoveDirection + Camera.CFrame.LookVector * Humanoid.MoveDirection.Z
            MoveDirection = MoveDirection + Camera.CFrame.RightVector * Humanoid.MoveDirection.X
        end
        
        if MoveDirection.Magnitude > 0 then
            HRP.Velocity = MoveDirection.Unit * FlySpeed
        else
            HRP.Velocity = Vector3.new(0, 0, 0)
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
        if Noclipping then
            Rayfield:Notify({
               Title = "👻 Noclip Enabled",
               Content = "Walk through walls freely",
               Duration = 3,
               Image = 4483362458,
            })
        else
            Rayfield:Notify({
               Title = "✅ Noclip Disabled",
               Content = "Collisions restored",
               Duration = 2,
               Image = 4483362458,
            })
        end
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

MovementTab:CreateButton({
   Name = "🔄 Reset Jump Power",
   Callback = function()
       if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
           LocalPlayer.Character.Humanoid.JumpPower = 50
           JumpPowerSlider:Set(50)
           Rayfield:Notify({
              Title = "✅ Reset",
              Content = "Jump power reset to default",
              Duration = 2,
              Image = 4483362458,
           })
       end
   end,
})

local VisualTab = Window:CreateTab("Visuals", 4483362458)
VisualTab:CreateSection("esp")

local function CreateESP(player)
    if player == LocalPlayer then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerESP"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Enabled = ESPEnabled
    
    local function onCharacterAdded(character)
        highlight.Parent = character
        highlight.Adornee = character
    end
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
    player.CharacterAdded:Connect(onCharacterAdded)
    
    ESPBoxes[player] = highlight
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
                if ESPEnabled then
                    CreateESP(player)
                end
            end)
            
            Rayfield:Notify({
               Title = "👁️ ESP Enabled",
               Content = "All players are now visible",
               Duration = 3,
               Image = 4483362458,
            })
        else
            for player, _ in pairs(ESPBoxes) do
                RemoveESP(player)
            end
            
            Rayfield:Notify({
               Title = "✅ ESP Disabled",
               Content = "ESP has been turned off",
               Duration = 2,
               Image = 4483362458,
            })
        end
        
        for _, highlight in pairs(ESPBoxes) do
            if highlight then
                highlight.Enabled = Value
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
        Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        
        Rayfield:Notify({
           Title = "🌞 Fullbright Active",
           Content = "Maximum visibility enabled",
           Duration = 3,
           Image = 4483362458,
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

local SettingsTab = Window:CreateTab("Settings", 4483362458)
SettingsTab:CreateSection("info")

SettingsTab:CreateLabel("AverageSpoofer Pro v2.0")
SettingsTab:CreateLabel("player:" .. LocalPlayer.Name)
SettingsTab:CreateLabel("id:" .. tostring(OriginalUserId))
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
   Title = "AverageSpoofer Plus",
   Content = "Successfully loaded!",
   Duration = 5,
   Image = 4483362458,
})

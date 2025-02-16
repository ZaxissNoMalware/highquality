getgenv().Aimbot = {
    Status = true,
    Keybind  = 'C',
    M2 = true,
    Hitpart = 'HumanoidRootPart',
   -- Toggle = false,
    Predictioning = false,
    ['Prediction'] = {
        X = 0.165,
        Y = 0.1,
    },
    Smoothing = 0.9,
    --TeamCheck = false,
}

 
if getgenv().AimbotRan then
    return
else
    getgenv().AimbotRan = true
end

 
local RunService = game:GetService('RunService')
local Workspace = game:GetService('Workspace')
local Players = game:GetService('Players')
local UserInputService = game:GetService("UserInputService") 
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()
 
local Player = nil
 
 
local GetClosestPlayer = function()
    local ClosestDistance, ClosestPlayer = 10000, nil
    for _, Player : Player in pairs(Players:GetPlayers()) do
        if Player.Name ~= LocalPlayer.Name and Player.Character and Player.Character:FindFirstChild('HumanoidRootPart') then
            local Root, Visible = Camera:WorldToScreenPoint(Player.Character.HumanoidRootPart.Position)
            if not Visible then
                continue
            end
            Root = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(Root.X, Root.Y)).Magnitude
            if Root < ClosestDistance then
                ClosestPlayer = Player
                ClosestDistance = Root
            end
        end
    end
    return ClosestPlayer
end
 

Mouse.Button2Down:Connect(function()
    if Aimbot.M2 then
        Player = not Player and GetClosestPlayer() or nil
    end
    
end)

Mouse.Button2Up:Connect(function()
    if Aimbot.M2 then
        Player = nil
        if Animation then
            Animation:Cancel()
        end
     end
end)

Mouse.KeyDown:Connect(function(key)
 if key == Aimbot.Keybind:lower() and Aimbot.M2 == false then
     Player = not Player and GetClosestPlayer() or nil
    end
end)

Mouse.KeyUp:Connect(function(key)
    if key == Aimbot.Keybind:lower() and toggle == false and Aimbot.M2 == false then
     Player = nil
     if Animation then
        Animation:Cancel()
    end
    end
end)



 
RunService.RenderStepped:Connect(function()
    if not Player then
        return
    end
    if not Aimbot.Status then
        return
    end
    local Hitpart = Player.Character:FindFirstChild(Aimbot.Hitpart)
    if not Hitpart then
        return
    end
    if Aimbot.Predictioning == true then
        if Aimbot.Smoothing == 0 then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Hitpart.Position + Hitpart.Velocity * Vector3.new(Aimbot.Prediction.X, Aimbot.Prediction.Y, Aimbot.Prediction.X))
        else
            Animation = TweenService:Create(Camera, TweenInfo.new(Aimbot.Smoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, Hitpart.Position + Hitpart.Velocity * Vector3.new(Aimbot.Prediction.X, Aimbot.Prediction.Y, Aimbot.Prediction.X))})
			Animation:Play()
        end
        
    else
        if Aimbot.Smoothing == 0 then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, Hitpart.Position)
        else
            Animation = TweenService:Create(Camera, TweenInfo.new(Aimbot.Smoothing, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, Hitpart.Position)})
			Animation:Play()
        end
    end
    

end)

if getgenv().AimbotRan then
    return
else
    getgenv().AimbotRan = true
end

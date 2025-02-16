local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()

loadstring(game:HttpGet("https://raw.githubusercontent.com/ZaxissNoMalware/highquality/refs/heads/main/AIMBOT.lua"))()



local Window = Fluent:CreateWindow({
    Title = "highquality",
    SubTitle = "by Zaxiss",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = false, -- The blur may be detectable, setting this to false disables blur entirely
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.Insert -- Used when theres no MinimizeKeybind
})

local Tabs = {
    Aimbot = Window:AddTab({ Title = "Aimbot", Icon = "circle-plus"}),
    Visuals = Window:AddTab({ Title = "Visuals", Icon = "eye "}),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings"}),
}

local Options = Fluent.Options

-----------------------------------------------------------------------------------


-----------------------------------------------------------------------------------



local Workspace, RunService, Players, CoreGui, Lighting = cloneref(game:GetService("Workspace")), cloneref(game:GetService("RunService")), cloneref(game:GetService("Players")), game:GetService("CoreGui"), cloneref(game:GetService("Lighting"))

local ESP = {
    Enabled = true,
    TeamCheck = true,
    MaxDistance = 200,
    FontSize = 10,
    FadeOut = {
        OnDistance = true,
        OnDeath = true,
        OnLeave = false,
    },
    Options = { 
        Teamcheck = false, TeamcheckRGB = Color3.fromRGB(0, 255, 0),
        Friendcheck = true, FriendcheckRGB = Color3.fromRGB(0, 255, 0),
        Highlight = false, HighlightRGB = Color3.fromRGB(255, 0, 0),
    },
    Drawing = {
        Chams = {
            Enabled  = false,
            Thermal = false,
            FillRGB = Color3.fromRGB(230, 230, 230),
            Fill_Transparency = 100,
            OutlineRGB = Color3.fromRGB(255,255,255),
            Outline_Transparency = 100,
            VisibleCheck = true,
        },
        Names = {
            Enabled = false,
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Flags = {
            Enabled = false,
        },
        Distances = {
            Enabled = false, 
            Position = "Text",
            RGB = Color3.fromRGB(255, 255, 255),
        },
        Weapons = {
            Enabled = false, WeaponTextRGB = Color3.fromRGB(255,255,255),
            Outlined = false,
            Gradient = false,
            GradientRGB1 = Color3.fromRGB(255, 255, 255), GradientRGB2 = Color3.fromRGB(210,210,210),
        },
        Healthbar = {
            Enabled = false,  
            HealthText = false, Lerp = false, HealthTextRGB = Color3.fromRGB(255,255,255),
            Width = 2.5,
            Gradient = true, GradientRGB1 = Color3.fromRGB(200, 0, 0), GradientRGB2 = Color3.fromRGB(255, 200, 0), GradientRGB3 = Color3.fromRGB(38, 255, 0), 
        },
        Boxes = {
            Animate = false,
            RotationSpeed = 300,
            Gradient = true, GradientRGB1 = Color3.fromRGB(255,255,255), GradientRGB2 = Color3.fromRGB(0, 0, 0), 
            GradientFill = true, GradientFillRGB1 = Color3.fromRGB(255,255,255), GradientFillRGB2 = Color3.fromRGB(0, 0, 0), 
            Filled = {
                Enabled = false,
                Transparency = 0.75,
                RGB = Color3.fromRGB(0, 0, 0),
            },
            Full = {
                Enabled = false,
                RGB = Color3.fromRGB(255, 255, 255),
            },
            Corner = {
                Enabled = false,
                RGB = Color3.fromRGB(255, 255, 255),
            },
        };
    };
    Connections = {
        RunService = RunService;
    };
    Fonts = {};
}

-- Def & Vars
local Euphoria = ESP.Connections;
local lplayer = Players.LocalPlayer;
local camera = game.Workspace.CurrentCamera;
local Cam = Workspace.CurrentCamera;
local RotationAngle, Tick = -45, tick();

-- Weapon Images
local Weapon_Icons = {
    ["Wooden Bow"] = "http://www.roblox.com/asset/?id=17677465400",
    ["Crossbow"] = "http://www.roblox.com/asset/?id=17677473017",
    ["Salvaged SMG"] = "http://www.roblox.com/asset/?id=17677463033",
    ["Salvaged AK47"] = "http://www.roblox.com/asset/?id=17677455113",
    ["Salvaged AK74u"] = "http://www.roblox.com/asset/?id=17677442346",
    ["Salvaged M14"] = "http://www.roblox.com/asset/?id=17677444642",
    ["Salvaged Python"] = "http://www.roblox.com/asset/?id=17677451737",
    ["Military PKM"] = "http://www.roblox.com/asset/?id=17677449448",
    ["Military M4A1"] = "http://www.roblox.com/asset/?id=17677479536",
    ["Bruno's M4A1"] = "http://www.roblox.com/asset/?id=17677471185",
    ["Military Barrett"] = "http://www.roblox.com/asset/?id=17677482998",
    ["Salvaged Skorpion"] = "http://www.roblox.com/asset/?id=17677459658",
    ["Salvaged Pump Action"] = "http://www.roblox.com/asset/?id=17677457186",
    ["Military AA12"] = "http://www.roblox.com/asset/?id=17677475227",
    ["Salvaged Break Action"] = "http://www.roblox.com/asset/?id=17677468751",
    ["Salvaged Pipe Rifle"] = "http://www.roblox.com/asset/?id=17677468751",
    ["Salvaged P250"] = "http://www.roblox.com/asset/?id=17677447257",
    ["Nail Gun"] = "http://www.roblox.com/asset/?id=17677484756"
};

-- Functions
local Functions = {}
do
    function Functions:Create(Class, Properties)
        local _Instance = typeof(Class) == 'string' and Instance.new(Class) or Class
        for Property, Value in pairs(Properties) do
            _Instance[Property] = Value
        end
        return _Instance;
    end
    --
    function Functions:FadeOutOnDist(element, distance)
        local transparency = math.max(0.1, 1 - (distance / ESP.MaxDistance))
        if element:IsA("TextLabel") then
            element.TextTransparency = 1 - transparency
        elseif element:IsA("ImageLabel") then
            element.ImageTransparency = 1 - transparency
        elseif element:IsA("UIStroke") then
            element.Transparency = 1 - transparency
        elseif element:IsA("Frame") and (element == Healthbar or element == BehindHealthbar) then
            element.BackgroundTransparency = 1 - transparency
        elseif element:IsA("Frame") then
            element.BackgroundTransparency = 1 - transparency
        elseif element:IsA("Highlight") then
            element.FillTransparency = 1 - transparency
            element.OutlineTransparency = 1 - transparency
        end;
    end;  
end;

do -- Initalize
    local ScreenGui = Functions:Create("ScreenGui", {
        Parent = CoreGui,
        Name = "ESPHolder",
    });

    local DupeCheck = function(plr)
        if ScreenGui:FindFirstChild(plr.Name) then
            ScreenGui[plr.Name]:Destroy()
        end
    end

    local ESP = function(plr)
        coroutine.wrap(DupeCheck)(plr) -- Dupecheck
        local Name = Functions:Create("TextLabel", {Parent = ScreenGui, Name = "NameText", Position = UDim2.new(0.5, 0, 0, -11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = ESP.Drawing.Names.RGB, Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local Distance = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 11), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local Weapon = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0), RichText = true})
        local Box = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.75, BorderSizePixel = 0})
        local Gradient1 = Functions:Create("UIGradient", {Parent = Box, Enabled = ESP.Drawing.Boxes.GradientFill, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientFillRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientFillRGB2)}})
        local Outline = Functions:Create("UIStroke", {Parent = Box, Enabled = ESP.Drawing.Boxes.Gradient, Transparency = 0, Color = Color3.fromRGB(255, 255, 255), LineJoinMode = Enum.LineJoinMode.Miter})
        local Gradient2 = Functions:Create("UIGradient", {Parent = Outline, Enabled = ESP.Drawing.Boxes.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Boxes.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Boxes.GradientRGB2)}})
        local Healthbar = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0})
        local BehindHealthbar = Functions:Create("Frame", {Parent = ScreenGui, ZIndex = -1, BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0})
        local HealthbarGradient = Functions:Create("UIGradient", {Parent = Healthbar, Enabled = ESP.Drawing.Healthbar.Gradient, Rotation = -90, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Healthbar.GradientRGB1), ColorSequenceKeypoint.new(0.5, ESP.Drawing.Healthbar.GradientRGB2), ColorSequenceKeypoint.new(1, ESP.Drawing.Healthbar.GradientRGB3)}})
        local HealthText = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(0.5, 0, 0, 31), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        local Chams = Functions:Create("Highlight", {Parent = ScreenGui, FillTransparency = 1, OutlineTransparency = 0, OutlineColor = Color3.fromRGB(119, 120, 255), DepthMode = "AlwaysOnTop"})
        local WeaponIcon = Functions:Create("ImageLabel", {Parent = ScreenGui, BackgroundTransparency = 1, BorderColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Size = UDim2.new(0, 40, 0, 40)})
        local Gradient3 = Functions:Create("UIGradient", {Parent = WeaponIcon, Rotation = -90, Enabled = ESP.Drawing.Weapons.Gradient, Color = ColorSequence.new{ColorSequenceKeypoint.new(0, ESP.Drawing.Weapons.GradientRGB1), ColorSequenceKeypoint.new(1, ESP.Drawing.Weapons.GradientRGB2)}})
        local LeftTop = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local LeftSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local RightTop = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local RightSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomDown = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomRightSide = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local BottomRightDown = Functions:Create("Frame", {Parent = ScreenGui, BackgroundColor3 = ESP.Drawing.Boxes.Corner.RGB, Position = UDim2.new(0, 0, 0, 0)})
        local Flag1 = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        local Flag2 = Functions:Create("TextLabel", {Parent = ScreenGui, Position = UDim2.new(1, 0, 0, 0), Size = UDim2.new(0, 100, 0, 20), AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        --local DroppedItems = Functions:Create("TextLabel", {Parent = ScreenGui, AnchorPoint = Vector2.new(0.5, 0.5), BackgroundTransparency = 1, TextColor3 = Color3.fromRGB(255, 255, 255), Font = Enum.Font.Code, TextSize = ESP.FontSize, TextStrokeTransparency = 0, TextStrokeColor3 = Color3.fromRGB(0, 0, 0)})
        --
        local Updater = function()
            local Connection;
            local function HideESP()
                Box.Visible = false;
                Name.Visible = false;
                Distance.Visible = false;
                Weapon.Visible = false;
                Healthbar.Visible = false;
                BehindHealthbar.Visible = false;
                HealthText.Visible = false;
                WeaponIcon.Visible = false;
                LeftTop.Visible = false;
                LeftSide.Visible = false;
                BottomSide.Visible = false;
                BottomDown.Visible = false;
                RightTop.Visible = false;
                RightSide.Visible = false;
                BottomRightSide.Visible = false;
                BottomRightDown.Visible = false;
                Flag1.Visible = false;
                Chams.Enabled = false;
                Flag2.Visible = false;
                if not plr then
                    ScreenGui:Destroy();
                    Connection:Disconnect();
                end
            end
            --
            Connection = Euphoria.RunService.RenderStepped:Connect(function()
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local HRP = plr.Character.HumanoidRootPart
                    local Humanoid = plr.Character:WaitForChild("Humanoid");
                    local Pos, OnScreen = Cam:WorldToScreenPoint(HRP.Position)
                    local Dist = (Cam.CFrame.Position - HRP.Position).Magnitude / 3.5714285714
                    
                    if OnScreen and Dist <= ESP.MaxDistance then
                        local Size = HRP.Size.Y
                        local scaleFactor = (Size * Cam.ViewportSize.Y) / (Pos.Z * 2)
                        local w, h = 3 * scaleFactor, 4.5 * scaleFactor

                        -- Fade-out effect --
                        if ESP.FadeOut.OnDistance then
                            Functions:FadeOutOnDist(Box, Dist)
                            Functions:FadeOutOnDist(Outline, Dist)
                            Functions:FadeOutOnDist(Name, Dist)
                            Functions:FadeOutOnDist(Distance, Dist)
                            Functions:FadeOutOnDist(Weapon, Dist)
                            Functions:FadeOutOnDist(Healthbar, Dist)
                            Functions:FadeOutOnDist(BehindHealthbar, Dist)
                            Functions:FadeOutOnDist(HealthText, Dist)
                            Functions:FadeOutOnDist(WeaponIcon, Dist)
                            Functions:FadeOutOnDist(LeftTop, Dist)
                            Functions:FadeOutOnDist(LeftSide, Dist)
                            Functions:FadeOutOnDist(BottomSide, Dist)
                            Functions:FadeOutOnDist(BottomDown, Dist)
                            Functions:FadeOutOnDist(RightTop, Dist)
                            Functions:FadeOutOnDist(RightSide, Dist)
                            Functions:FadeOutOnDist(BottomRightSide, Dist)
                            Functions:FadeOutOnDist(BottomRightDown, Dist)
                            Functions:FadeOutOnDist(Chams, Dist)
                            Functions:FadeOutOnDist(Flag1, Dist)
                            Functions:FadeOutOnDist(Flag2, Dist)
                        end

                        -- Teamcheck
                        if ESP.TeamCheck and plr ~= lplayer and ((lplayer.Team ~= plr.Team and plr.Team) or (not lplayer.Team and not plr.Team)) and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") then

                            do -- Chams
                                Chams.Adornee = plr.Character
                                Chams.Enabled = ESP.Drawing.Chams.Enabled
                                Chams.FillColor = ESP.Drawing.Chams.FillRGB
                                Chams.OutlineColor = ESP.Drawing.Chams.OutlineRGB
                                do -- Breathe
                                    if ESP.Drawing.Chams.Thermal then
                                        local breathe_effect = math.atan(math.sin(tick() * 2)) * 2 / math.pi
                                        Chams.FillTransparency = ESP.Drawing.Chams.Fill_Transparency * breathe_effect * 0.01
                                        Chams.OutlineTransparency = ESP.Drawing.Chams.Outline_Transparency * breathe_effect * 0.01
                                    end
                                end
                                if ESP.Drawing.Chams.VisibleCheck then
                                    Chams.DepthMode = "Occluded"
                                else
                                    Chams.DepthMode = "AlwaysOnTop"
                                end
                            end;

                            do -- Corner Boxes
                                LeftTop.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                LeftTop.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                LeftTop.Size = UDim2.new(0, w / 5, 0, 1)
                                
                                LeftSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                LeftSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                LeftSide.Size = UDim2.new(0, 1, 0, h / 5)
                                
                                BottomSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                BottomSide.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                BottomSide.Size = UDim2.new(0, 1, 0, h / 5)
                                BottomSide.AnchorPoint = Vector2.new(0, 5)
                                
                                BottomDown.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                BottomDown.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y + h / 2)
                                BottomDown.Size = UDim2.new(0, w / 5, 0, 1)
                                BottomDown.AnchorPoint = Vector2.new(0, 1)
                                
                                RightTop.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                RightTop.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y - h / 2)
                                RightTop.Size = UDim2.new(0, w / 5, 0, 1)
                                RightTop.AnchorPoint = Vector2.new(1, 0)
                                
                                RightSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                RightSide.Position = UDim2.new(0, Pos.X + w / 2 - 1, 0, Pos.Y - h / 2)
                                RightSide.Size = UDim2.new(0, 1, 0, h / 5)
                                RightSide.AnchorPoint = Vector2.new(0, 0)
                                
                                BottomRightSide.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                BottomRightSide.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                BottomRightSide.Size = UDim2.new(0, 1, 0, h / 5)
                                BottomRightSide.AnchorPoint = Vector2.new(1, 1)
                                
                                BottomRightDown.Visible = ESP.Drawing.Boxes.Corner.Enabled
                                BottomRightDown.Position = UDim2.new(0, Pos.X + w / 2, 0, Pos.Y + h / 2)
                                BottomRightDown.Size = UDim2.new(0, w / 5, 0, 1)
                                BottomRightDown.AnchorPoint = Vector2.new(1, 1)                                                            
                            end

                            do -- Boxes
                                Box.Position = UDim2.new(0, Pos.X - w / 2, 0, Pos.Y - h / 2)
                                Box.Size = UDim2.new(0, w, 0, h)
                                Box.Visible = ESP.Drawing.Boxes.Full.Enabled;

                                -- Gradient
                                if ESP.Drawing.Boxes.Filled.Enabled then
                                    Box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                                    if ESP.Drawing.Boxes.GradientFill then
                                        Box.BackgroundTransparency = ESP.Drawing.Boxes.Filled.Transparency;
                                    else
                                        Box.BackgroundTransparency = 1
                                    end
                                    Box.BorderSizePixel = 1
                                else
                                    Box.BackgroundTransparency = 1
                                end
                                -- Animation
                                RotationAngle = RotationAngle + (tick() - Tick) * ESP.Drawing.Boxes.RotationSpeed * math.cos(math.pi / 4 * tick() - math.pi / 2)
                                if ESP.Drawing.Boxes.Animate then
                                    Gradient1.Rotation = RotationAngle
                                    Gradient2.Rotation = RotationAngle
                                else
                                    Gradient1.Rotation = -45
                                    Gradient2.Rotation = -45
                                end
                                Tick = tick()
                            end

                            -- Healthbar
                            do  
                                local health = Humanoid.Health / Humanoid.MaxHealth;
                                Healthbar.Visible = ESP.Drawing.Healthbar.Enabled;
                                Healthbar.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - health))  
                                Healthbar.Size = UDim2.new(0, ESP.Drawing.Healthbar.Width, 0, h * health)  
                                --
                                BehindHealthbar.Visible = ESP.Drawing.Healthbar.Enabled;
                                BehindHealthbar.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2)  
                                BehindHealthbar.Size = UDim2.new(0, ESP.Drawing.Healthbar.Width, 0, h)
                                -- Health Text
                                do
                                    if ESP.Drawing.Healthbar.HealthText then
                                        local healthPercentage = math.floor(Humanoid.Health / Humanoid.MaxHealth * 100)
                                        HealthText.Position = UDim2.new(0, Pos.X - w / 2 - 6, 0, Pos.Y - h / 2 + h * (1 - healthPercentage / 100) + 3)
                                        HealthText.Text = tostring(healthPercentage)
                                        HealthText.Visible = Humanoid.Health < Humanoid.MaxHealth
                                        if ESP.Drawing.Healthbar.Lerp then
                                            local color = health >= 0.75 and Color3.fromRGB(0, 255, 0) or health >= 0.5 and Color3.fromRGB(255, 255, 0) or health >= 0.25 and Color3.fromRGB(255, 170, 0) or Color3.fromRGB(255, 0, 0)
                                            HealthText.TextColor3 = color
                                        else
                                            HealthText.TextColor3 = ESP.Drawing.Healthbar.HealthTextRGB
                                        end
                                    end                        
                                end
                            end

                            do -- Names
                                Name.Visible = ESP.Drawing.Names.Enabled
                                if ESP.Options.Friendcheck and lplayer:IsFriendsWith(plr.UserId) then
                                    Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s', ESP.Options.FriendcheckRGB.R * 255, ESP.Options.FriendcheckRGB.G * 255, ESP.Options.FriendcheckRGB.B * 255, plr.Name)
                                else
                                    Name.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s', 255, 0, 0, plr.Name)
                                end
                                Name.Position = UDim2.new(0, Pos.X, 0, Pos.Y - h / 2 - 9)
                            end
                            
                            do -- Distance
                                if ESP.Drawing.Distances.Enabled then
                                    if ESP.Drawing.Distances.Position == "Bottom" then
                                        Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 18)
                                        WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 15);
                                        Distance.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 7)
                                        Distance.Text = string.format("%d meters", math.floor(Dist))
                                        Distance.Visible = true
                                    elseif ESP.Drawing.Distances.Position == "Text" then
                                        Weapon.Position = UDim2.new(0, Pos.X, 0, Pos.Y + h / 2 + 8)
                                        WeaponIcon.Position = UDim2.new(0, Pos.X - 21, 0, Pos.Y + h / 2 + 5);
                                        Distance.Visible = false
                                        if ESP.Options.Friendcheck and lplayer:IsFriendsWith(plr.UserId) then
                                            Name.Text = string.format('(<font color="rgb(%d, %d, %d)">F</font>) %s [%d]', ESP.Options.FriendcheckRGB.R * 255, ESP.Options.FriendcheckRGB.G * 255, ESP.Options.FriendcheckRGB.B * 255, plr.Name, math.floor(Dist))
                                        else
                                            Name.Text = string.format('(<font color="rgb(%d, %d, %d)">E</font>) %s [%d]', 255, 0, 0, plr.Name, math.floor(Dist))
                                        end
                                        Name.Visible = ESP.Drawing.Names.Enabled
                                    end
                                end
                            end

                            do -- Weapons
                                Weapon.Text = "none"
                                Weapon.Visible = ESP.Drawing.Weapons.Enabled
                            end                            
                        else
                            HideESP();
                        end
                    else
                        HideESP();
                    end
                else
                    HideESP();
                end
            end)
        end
        coroutine.wrap(Updater)();
    end
    do -- Update ESP
        --

        for _, v in pairs(game:GetService("Players"):GetPlayers()) do
            if v.Name ~= lplayer.Name then
                coroutine.wrap(ESP)(v)
            end
        end      

       

        game:GetService("Players").PlayerAdded:Connect(function(v)
            coroutine.wrap(ESP)(v)
        end);
    end;
end;

----------------------------------------------------------------------------------

do
    local ESPNames = Tabs.Visuals:AddToggle("ESPNames", {Title = "Names", Default = false })

    ESPNames:OnChanged(function()
        ESP.Drawing.Names.Enabled = Options.ESPNames.Value
    end)

    local ESPHealth = Tabs.Visuals:AddToggle("ESPHealth", {Title = "Health Bar", Default = false })

    ESPHealth:OnChanged(function()
        ESP.Drawing.Healthbar.Enabled = Options.ESPHealth.Value
    end)

    local ESPHealthWidth = Tabs.Visuals:AddSlider("ESPHealthWidth", {
        Title = "Health Bar Width",
        Description = "",
        Default = 2.5,
        Min = 0.1,
        Max = 10,
        Rounding = 1,
        Callback = function(Value)
            ESP.Drawing.Healthbar.Width = Value
        end
    })

    local ESPBox = Tabs.Visuals:AddDropdown("ESPBox", {
        Title = "Box",
        Values = {"None", "Corner", "Full"},
        Multi = false,
        Default = 1,
    })

    ESPBox:OnChanged(function(Value)
        if Value == "None" then
            ESP.Drawing.Boxes.Corner.Enabled = false
            ESP.Drawing.Boxes.Full.Enabled = false
        elseif Value == "Corner" then
            ESP.Drawing.Boxes.Corner.Enabled = true
            ESP.Drawing.Boxes.Full.Enabled = false
        else
            ESP.Drawing.Boxes.Corner.Enabled = false
            ESP.Drawing.Boxes.Full.Enabled = true
        end
    end)

    local ESPBoxAnimate = Tabs.Visuals:AddToggle("ESPBoxAnimate", {Title = "Box Animate (Full only)", Default = false })

    ESPBoxAnimate:OnChanged(function()
        ESP.Drawing.Boxes.Animate = Options.ESPBoxAnimate.Value
    end)

    local ESPChams = Tabs.Visuals:AddToggle("ESPChams", {Title = "Chams", Default = false })

    ESPChams:OnChanged(function()
        ESP.Drawing.Chams.Enabled = Options.ESPChams.Value
    end)

    local ESPChamsThermal = Tabs.Visuals:AddToggle("ESPChamsThermal", {Title = "Chams Thermal", Default = false })

    ESPChamsThermal:OnChanged(function()
        ESP.Drawing.Chams.Thermal = Options.ESPChamsThermal.Value
    end)

--------------------


    local AIMToggle = Tabs.Aimbot:AddToggle("AIMToggle", {Title = "Aimbot On/Off", Default = false })

    AIMToggle:OnChanged(function()
        getgenv().Aimbot.Status = Options.AIMToggle.Value
    end)

    local AIMSmoothing = Tabs.Aimbot:AddSlider("AIMSmoothing", {
        Title = "Smoothing",
        Description = "",
        Default = 0,
        Min = 0,
        Max = 1,
        Rounding = 1,
        Callback = function(Value)
            getgenv().Aimbot.Smoothing = Value
        end
    })

    local AIMTeamCheck = Tabs.Aimbot:AddToggle("AIMTeamCheck", {Title = "Team Check", Default = false })

    AIMTeamCheck:OnChanged(function()
        getgenv().Aimbot.TeamCheck = Options.AIMTeamCheck.Value
    end)

    --[[local AIMToggleOnly = Tabs.Aimbot:AddToggle("AIMToggleOnly", {Title = "Keybind Toggle", Default = false })

    AIMToggleOnly:OnChanged(function()                                                          -- хуета не нужная
        getgenv().Aimbot.Toggle = Options.AIMToggleOnly.Value
    end)--]]                                                            

    local AIMKey = Tabs.Aimbot:AddDropdown("AIMKey", {
        Title = "Keybind",
        Values = {"C", "F", "E", "V", "M2"},
        Multi = false,
        Default = 1,
    })


    AIMKey:OnChanged(function(Value)
        if Value == "C" then
            getgenv().Aimbot.Keybind = 'C'
            getgenv().Aimbot.M2 = false
        elseif Value == "F" then
            getgenv().Aimbot.Keybind = 'F'
            getgenv().Aimbot.M2 = false
        elseif Value == "E" then
            getgenv().Aimbot.Keybind = 'E'
            getgenv().Aimbot.M2 = false
        elseif Value == "V" then
            getgenv().Aimbot.Keybind = 'V'
            getgenv().Aimbot.M2 = false
        else
            getgenv().Aimbot.M2 = true
        end
    end)

    local AIMHitPart = Tabs.Aimbot:AddDropdown("AIMHitPart", {
        Title = "Hit Part",
        Values = {"Torso", "Head"},
        Multi = false,
        Default = 1,
    })

    AIMHitPart:OnChanged(function(Value)
        if Value == "Torso" then
            getgenv().Aimbot.Hitpart = 'HumanoidRootPart'
        else
            getgenv().Aimbot.Hitpart = 'Head'
        end
    end)

    local AIMPrediction = Tabs.Aimbot:AddToggle("AIMPrediction", {Title = "Prediction", Default = false })

    AIMPrediction:OnChanged(function()
        getgenv().Aimbot.Predictioning = Options.AIMPrediction.Value
    end)

    local AIMPredictionX = Tabs.Aimbot:AddSlider("AIMPredictionX", {
        Title = "Predict X",
        Description = "Change it only if u know what you doing",
        Default = 0.165,
        Min = 0.05,
        Max = 1,
        Rounding = 3,
        Callback = function(Value)
            getgenv().Aimbot.Prediction.X = Value
        end
    })

    local AIMPredictionY = Tabs.Aimbot:AddSlider("AIMPredictionY", {
        Title = "Predict Y",
        Description = "Change it only if u know what you doing",
        Default = 0.1,
        Min = 0.05,
        Max = 1,
        Rounding = 3,
        Callback = function(Value)
            getgenv().Aimbot.Prediction.Y = Value
        end
    })


end

--[[ PlayersTab:AddToggle('ESPNames', {
    Text = 'Names',
    Default = false, -- Default value (true / false)
    Tooltip = '', -- Information shown when you hover over the toggle

    Callback = function(Value)
        ESP.Drawing.Names.Enabled = Value
        --UpdateESP()
    end
})

PlayersTab:AddToggle('ESPHealth', {
    Text = 'Health Bar',
    Default = false, -- Default value (true / false)
    Tooltip = '', -- Information shown when you hover over the toggle

    Callback = function(Value)
        ESP.Drawing.Healthbar.Enabled = Value
        --UpdateESP()
    end
})

PlayersTab:AddSlider('ESPHealthWidth', {
    Text = 'Health Bar Width',
    Default = 0.25,
    Min = 0.1,
    Max = 10,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        ESP.Drawing.Healthbar.Width = Value
        --UpdateESP()
    end
})


PlayersTab:AddDropdown('ESPBox', {
    Values = { 'None', 'Corner', 'Full'},
    Default = 'None', -- number index of the value / string
    Multi = false, -- true / false, allows multiple choices to be selected

    Text = 'Box',
    Tooltip = '', -- Information shown when you hover over the dropdown

    Callback = function(Value)
        if Value == 'None' then
            ESP.Drawing.Boxes.Corner.Enabled = false
            ESP.Drawing.Boxes.Full.Enabled = false
            ESP.Drawing.Boxes.Filled.Enabled = false
            task.wait()
            --UpdateESP()
        elseif Value == 'Corner' then
            ESP.Drawing.Boxes.Corner.Enabled = true
            ESP.Drawing.Boxes.Full.Enabled = false
            ESP.Drawing.Boxes.Filled.Enabled = false
            task.wait()
            --UpdateESP()
        elseif Value == 'Full' then
            ESP.Drawing.Boxes.Corner.Enabled = false
            ESP.Drawing.Boxes.Full.Enabled = true
            ESP.Drawing.Boxes.Filled.Enabled = false
            task.wait()
            --UpdateESP()
        end
    end
})

PlayersTab:AddToggle('ESPBoxAnimate', {
    Text = 'Box Animate',
    Default = false, -- Default value (true / false)
    Tooltip = '', -- Information shown when you hover over the toggle

    Callback = function(Value)
        ESP.Drawing.Boxes.Animate = Value
        --UpdateESP()
    end
})

PlayersTab:AddToggle('ESPChams', {
    Text = 'Chams',
    Default = false, -- Default value (true / false)
    Tooltip = '', -- Information shown when you hover over the toggle

    Callback = function(Value)
        ESP.Drawing.Chams.Enabled = Value
        --UpdateESP()
    end
})

PlayersTab:AddToggle('ESPChamsThermal', {
    Text = 'Chams Thermal',
    Default = false, -- Default value (true / false)
    Tooltip = '', -- Information shown when you hover over the toggle

    Callback = function(Value)
        ESP.Drawing.Chams.Thermal = Value
       -- UpdateESP()
    end
})

ColorsTab:AddLabel('NamesColor'):AddColorPicker('ColorNames', {
    Default = Color3.new(1, 1, 1),
    Title = 'Names', -- Optional. Allows you to have a custom color picker title (when you open it)
    Transparency = nil, -- Optional. Enables transparency changing for this color picker (leave as nil to disable)

    Callback = function(Value)
        ESP.Drawing.Names.RGB = Value
    end
})



A_MainTab:AddToggle('AimbotToggle', {
    Text = 'Aimbot Toggle',
    Default = false, -- Default value (true / false)
    Tooltip = 'Toggles aimbot on/off', -- Information shown when you hover over the toggle

    Callback = function(Value)
        getgenv().Aimbot.Settings.Enabled = Value
        getgenv().Aimbot.FOVSettings.Enabled = Value
    end
})

A_MainTab:AddSlider('AimbotSmoothing', {
    Text = 'Smoothing',
    Default = 0.2,
    Min = 0,
    Max = 1,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        getgenv().Aimbot.Settings.Sensitivity = Value
    end
})

A_MainTab:AddSlider('AimbotFOV', {
    Text = 'FOV',
    Default = 90,
    Min = 1,
    Max = 400,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
        getgenv().Aimbot.FOVSettings.Amount = Value
    end
}) --]]







---------------------------


SaveManager:SetIgnoreIndexes({})
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetFolder("highquality/Configs")
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)


SaveManager:LoadAutoloadConfig()

--[[

 Section1:Button({
    Title = "Kill All",
    ButtonName = "KILL!!",
    Description = "kills everyone",
    }, function(value)
    print(value)
end)

Section1:Toggle({
    Title = "Auto Farm Coins",
    Description = "Optional Description here",
    Default = false
    }, function(value)
    print(value)
end)

Section1:Slider({
    Title = "Walkspeed",
    Description = "",
    Default = 16,
    Min = 0,
    Max = 120
    }, function(value)
    print(value)
end)

Section1:ColorPicker({
    Title = "Colorpicker",
    Description = "",
    Default = Color3.new(255,0,0),
    }, function(value)
    print(value)
end)

Section1:Textbox({
    Title = "Damage Multiplier",
    Description = "",
    Default = "",
    }, function(value)
    print(value)
end)

Section1:Keybind({
    Title = "Kill All",
    Description = "",
    Default = Enum.KeyCode.Q,
    }, function(value)
    print(value)
end)


--]]

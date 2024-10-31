local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Splix"))()
local Sense = loadstring(game:HttpGet('https://sirius.menu/sense'))()
local notificationLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/xaxas-notification/src.lua"))();
 
loadstring(game:HttpGet("https://raw.githubusercontent.com/Exunys/Aimbot-V2/main/Resources/Scripts/Raw%20Main.lua"))()

local Aimbot = getgenv().Aimbot
local Settings, FOVSettings, Functions = Aimbot.Settings, Aimbot.FOVSettings, Aimbot.Functions

Aimbot.Settings.Enabled = false
Aimbot.Settings.SaveSettings = false
Aimbot.Settings.TeamCheck = true


Aimbot.FOVSettings.Enabled = true
Aimbot.FOVSettings.Amount = 110
Aimbot.FOVSettings.Visible = false


local window = library:new({textsize = 17.5,font = Enum.Font.RobotoMono,name = "highquality | Work In Progress",color = Color3.fromRGB(255,5,5)})

local VisualsTab = window:page({name = "Visuals"})
local Visuals_PlayersTab = VisualsTab:section({name = "Players",side = "left",size = 350})
local Visuals_Items = VisualsTab:section({name = "Items",side = "left",size = 350})

local AimbotTab = window:page({Name = "Aimbot"})
local Aimbot_MainTab = AimbotTab:section({name = "Main Tab",side = "left",size = 350})
local Aimbot_FovTab = AimbotTab:section({name = "FOV Tab",side = "left",size = 350})

local MiscTab = window:page({Name = "Misc"})
local Misc_MainTab = MiscTab:section({name = "Misc",side = "left",size = 350})

local notifications = notificationLibrary.new({            
    NotificationLifetime = 3, 
    NotificationPosition = "Top",
    
    TextFont = Enum.Font.Code,
    TextColor = Color3.fromRGB(255, 255, 255),
    TextSize = 15,
    
    TextStrokeTransparency = 0, 
    TextStrokeColor = Color3.fromRGB(0, 0, 0)
});

local Resolution = 1

Sense.teamSettings.enemy.enabled = true
Sense.teamSettings.enemy.box = false
Sense.teamSettings.enemy.healthBar = false
Sense.teamSettings.enemy.name = false
Sense.teamSettings.enemy.tracer = false
Sense.teamSettings.enemy.tracerOrigin = "Bottom"
Sense.teamSettings.enemy.tracerColor = { Color3.new(1, 1, 1), 1 }
Sense.teamSettings.enemy.offScreenArrow = false
Sense.teamSettings.enemy.offScreenArrowColor = { Color3.new(1,1,1), 1 }
Sense.teamSettings.enemy.offScreenArrowSize = 15
Sense.teamSettings.enemy.offScreenArrowRadius = 150
Sense.teamSettings.enemy.chams = false
Sense.teamSettings.enemy.chamsVisibleOnly = true
Sense.teamSettings.enemy.chamsFillColor = { Color3.new(1, 1, 1), 0.5 }
Sense.teamSettings.enemy.chamsOutlineColor = { Color3.new(0, 0, 0), 1 }

Sense.sharedSettings.limitDistance = false
Sense.sharedSettings.maxDistance = 100

Sense.teamSettings.enemy.name = false
Sense.teamSettings.enemy.boxColor[1] = Color3.new(1, 1, 1)

Sense.Load()

local Camera = workspace.CurrentCamera
Misc_MainTab:slider({Name = "Field Of View", def = 70, max = 120,min = 10,rounding = true,ticking = false,measuring = "",callback = function(value)
    Camera.FieldOfView = value
 end})

Aimbot_FovTab:toggle({Name = "FOV Visible", def = false, callback = function(value)
    tog = value
    if tog then
        Aimbot.FOVSettings.Visible = true
    else
        Aimbot.FOVSettings.Visible = false
    end
end})

Aimbot_FovTab:slider({Name = "FOV Radius", def = 110, max = 500,min = 5,rounding = true,ticking = false,measuring = "",callback = function(value)
    Aimbot.FOVSettings.Amount = value
 end})



Aimbot_MainTab:toggle({Name = "Aimbot On/Off", def = false ,callback = function(value)
    Aimbot.Settings.Enabled = value  
end})

Aimbot_MainTab:dropdown({Name = "Keybind", def = "MouseButton2", options = {"MouseButton2","Q","E"}, callback = function(chosen)
    if chosen == "MouseButton2" then
        Aimbot.Settings.TriggerKey = "MouseButton2"
    elseif chosen == "Q" then
        Aimbot.Settings.TriggerKey = "Q"
    elseif chosen == "E" then
        Aimbot.Settings.TriggerKey = "E"
    end
 end})

Aimbot_MainTab:toggle({Name = "Keybind Toggle", def = false ,callback = function(value)
    Aimbot.Settings.Enabled = value  
end})

Aimbot_MainTab:toggle({name = "If visible only",def = false,callback = function(value)
    tog = value
    if tog then
        Aimbot.Settings.WallCheck = true
    else
        Aimbot.Settings.WallCheck = false
    end
  end})

Aimbot_MainTab:slider({name = "Aimbot Smoothing",def = 0, max = 10,min = 0,rounding = true,ticking = false,measuring = "",callback = function(value)
    Aimbot.Settings.Sensitivity = value / 10
 end})

Aimbot_MainTab:dropdown({name = "Aimbot Position",def = "Head",max = 2,options = {"Head","Torso"},callback = function(chosen)
    if chosen == "Head" then
        Aimbot.Settings.LockPart = "Head"
    elseif chosen == "Torso" then
        Aimbot.Settings.LockPart = "Torso"
    end
 end})


Visuals_PlayersTab:toggle({name = "Box",def = false,callback = function(value)
    tog = value
    if tog then
        Sense.teamSettings.enemy.box = true
    else
        Sense.teamSettings.enemy.box = false
    end
  end})

Visuals_PlayersTab:toggle({name = "Names",def = false,callback = function(value)
    tog = value
    if tog then
        Sense.teamSettings.enemy.name = true
    else
        Sense.teamSettings.enemy.name = false
    end
  end})

Visuals_PlayersTab:toggle({name = "Tracers",def = false,callback = function(value)
    tog = value
    if tog then
        Sense.teamSettings.enemy.tracer = true
    else
        Sense.teamSettings.enemy.tracer = false
    end
  end})

Visuals_PlayersTab:dropdown({name = "Tracers Position",def = "Bottom",max = 3,options = {"Bottom","Middle","Top"},callback = function(chosen)
    if chosen == "Bottom" then
        Sense.teamSettings.enemy.tracerOrigin = "Bottom"
    elseif chosen == "Middle" then
        Sense.teamSettings.enemy.tracerOrigin = "Middle"
    elseif chosen == "Top" then
        Sense.teamSettings.enemy.tracerOrigin = "Top"
    end
 end})

Visuals_PlayersTab:toggle({name = "Health Bar ",def = false,callback = function(value)
    tog = value
    if tog then
        Sense.teamSettings.enemy.healthBar = true
    else
        Sense.teamSettings.enemy.healthBar = false
    end
  end})

Visuals_PlayersTab:toggle({name = "Arrows",def = false,callback = function(value)
    tog = value
    if tog then
        Sense.teamSettings.enemy.offScreenArrow = true
    else
        Sense.teamSettings.enemy.offScreenArrow = false
    end
  end})

Visuals_PlayersTab:slider({name = "Arrows Radius",def = 150, max = 350,min = 50,rounding = true,ticking = false,measuring = "",callback = function(value)
    Sense.teamSettings.enemy.offScreenArrowRadius = value
 end})

Visuals_PlayersTab:toggle({name = "Chams",def = false,callback = function(value)
    tog = value
    if tog then
        Sense.teamSettings.enemy.chams = true
    else
        Sense.teamSettings.enemy.chams = false
    end
  end})

Visuals_PlayersTab:toggle({name = "See chams through walls",def = false,callback = function(value)
    tog = value
    if tog then
        Sense.teamSettings.enemy.chamsVisibleOnly = false
    else
        Sense.teamSettings.enemy.chamsVisibleOnly = true
    end
  end})

Visuals_PlayersTab:slider({name = "Chams Transparency",def = 50, max = 100,min = 0,rounding = true,ticking = false,measuring = "",callback = function(value)
    Sense.teamSettings.enemy.chamsFillColor = { Color3.new(1, 1, 1), value / 100 }
 end})


Visuals_PlayersTab:toggle({name = "Limited ESP Distance",def = false,callback = function(value)
    tog = value
    if tog then
        Sense.sharedSettings.limitDistance = true
    else
        Sense.sharedSettings.limitDistance = false
    end
  end})

Visuals_PlayersTab:slider({name = "ESP Distance",def = 100, max = 2500,min = 1,rounding = true,ticking = false,measuring = "",callback = function(value)
    Sense.sharedSettings.maxDistance = value
 end})


notifications:BuildNotificationUI();
notifications:Notify("highquality fully loaded! Have fun :)");


--[[ 

section1:toggle({name = "toggle",def = false,callback = function(value)
  tog = value
  print(tog)
end})

section1:button({name = "button",callback = function()
   print('hot ui lib')
end})

section1:slider({name = "rate ui lib 1-100",def = 1, max = 100,min = 1,rounding = true,ticking = false,measuring = "",callback = function(value)
   print(value)
end})

section1:dropdown({name = "dropdown",def = "",max = 10,options = {"1","2","3","4","5","6","7","8","9","10"},callback = function(chosen)
   print(chosen)
end})
-- for dropdowns put max to the number of items u have in the opions

section1:buttonbox({name = "buttonbox",def = "",max = 4, options = {"yoyoyo","yo2","yo3","yo4"},callback = function(value)
   print(value)
end})


section1:multibox({name = "multibox",def = {}, max = 4,options = {"1","2","3","4"},callback = function(value)
   print(value)
end})

section1:textbox({name = "textbox",def = "default text",placeholder = "Enter WalkSpeed",callback = function(value)
   print(value)
end})

section1:keybind({name = "set ui keybind",def = nil,callback = function(key)
   window.key = key
end})

local picker = section1:colorpicker({name = "color",cpname = nil,def = Color3.fromRGB(255,255,255),callback = function(value)
   color = value
end}) 

--]]

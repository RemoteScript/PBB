game.Players.LocalPlayer.CameraMaxZoomDistance = 150
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/RemoteScript/Library/main/SynLibrary"))()

_G.SkipChat = false

function GetMainData()
    for i, v in pairs(debug.getregistry()) do
        if typeof(v) == "function" then
            for a, b in pairs(debug.getupvalues(v)) do
                if typeof(b) == "table" and rawget(b, "Fishing") then
                    return b
                end
            end
        end
    end
end
Data = GetMainData()
AuthKey = debug.getupvalue(Data["Network"]["getAuthKey"], 1)

local SF = {}
SF["Fish"] = Data["Fishing"]["Fish"]
SF["Fly"] = Data["Menu"]["map"]["fly"]

local Window = Library:AddWindow("Shitty Pokemon GUI", {
		main_color = Color3.fromRGB(41, 74, 122),
		min_size = Vector2.new(360, 380),
		toggle_key = Enum.KeyCode.RightShift,
		can_resize = false,
	})
	
local PokemonPage = Window:AddTab("Pokemon")

PokemonPage:AddSwitch("<---Loop Heal Pokemon", function(HealFarm)
   HealFarming = HealFarm
    while HealFarming do wait(3)
	pcall(function()
	game:GetService("ReplicatedStorage").GET:InvokeServer(AuthKey, "PDS", "getPartyPokeBalls")
	end)
    end
end)

PokemonPage:AddButton("Heal All Pokemon", function(Heal)
game:GetService("ReplicatedStorage").GET:InvokeServer(AuthKey, "PDS", "getPartyPokeBalls")
end)

PokemonPage:AddButton("Poke Fly", SF["Fly"])

local TPPage = Window:AddTab("Teleportations")

TPPage:AddLabel("TP 2 Battle Trainer:")

local Battles = TPPage:AddDropdown("Select A Trainer", function(Tp2Battle)
for i,v in pairs(game.Workspace:GetDescendants()) do
if v.Name == Tp2Battle and v:FindFirstChild("#Battle") then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
end
end
end)

for i,v in pairs(game.Workspace:GetDescendants()) do
if v:FindFirstChild("#Battle") then
    Battles:Add(v.Name)
end
end

TPPage:AddLabel("TP 2 Area:")
_G.Doors = TPPage:AddDropdown("Select An Area", function(Tp2Door)
for i,v in pairs(game.Workspace:GetDescendants()) do
if v.Name == "Door" and v:FindFirstChild("Main") and v.id.Value == Tp2Door then
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Main.CFrame
end
end
end)

for i,v in pairs(game.Workspace:GetDescendants()) do
if v.Name == "Door" and v:FindFirstChild("Main") then
    _G.Doors:Add(v.id.Value)
	end
	end

TPPage:AddLabel("TP 2 Item:")
_G.Items = TPPage:AddDropdown("Select An Item", function(Tp2Item)
for i,v in pairs(game.Workspace:GetDescendants()) do
if v.Name == "#Item" and v:FindFirstChild("Top") then
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Top.CFrame
end
end
end)

for i,v in pairs(game.Workspace:GetDescendants()) do
if v.Name == "#Item" and v:FindFirstChild("Top") then
    _G.Items:Add(v.Name)
	end
	end

local MiscPage = Window:AddTab("Misc")

local OldWait;
OldWait = hookfunction(Data["NPCChat"]["AdvanceSignal"]["wait"], function(...)
if _G.SkipChat then
return
end
OldWait(...)
end)
local Old;
Old = hookfunction(Data["NPCChat"]["say"], function(...)
    local Args = {...}
if _G.SkipChat then
for i = 3, #Args do
if typeof(Args[i]) == "string" then
Args[i] = "."
end
end
end
    return Old(unpack(Args))
end)

local Skipping = MiscPage:AddSwitch("Skip All Chat", function(Skipped)
if Skipped == true then
_G.SkipChat = true
else if Skipped == false then
_G.SkipChat = false
end
end
end)

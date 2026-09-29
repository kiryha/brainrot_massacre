--!strict

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.DestructionConfig)

local STATE_READY = "Ready"
local STATE_BUSY = "Busy"

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local remotes = ReplicatedStorage:WaitForChild(Config.RemotesFolderName)
local requestRemote = remotes:WaitForChild(Config.RequestRemoteName) :: RemoteEvent
local stateRemote = remotes:WaitForChild(Config.StateRemoteName) :: RemoteEvent

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TemporaryDestructionGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local button = Instance.new("ImageButton")
button.Name = "DestroyButton"
button.AnchorPoint = Vector2.new(1, 1)
button.Position = UDim2.new(1, -28, 1, -28)
button.Size = UDim2.fromOffset(104, 104)
button.BackgroundTransparency = 1
button.Image = "rbxassetid://122695532828355"
button.ScaleType = Enum.ScaleType.Fit
button.AutoButtonColor = false
button.Active = false
button.Parent = screenGui

local currentState = "Unavailable"

local function setButtonAppearance(color: Color3, transparency: number)
	button.ImageColor3 = color
	button.ImageTransparency = transparency
end

local function renderState(nextState: string)
	currentState = nextState

	if nextState == STATE_READY then
		setButtonAppearance(Color3.new(1, 1, 1), 0.18)
		button.AutoButtonColor = true
		button.Active = true
	elseif nextState == STATE_BUSY then
		setButtonAppearance(Color3.fromRGB(150, 150, 150), 0.42)
		button.AutoButtonColor = false
		button.Active = false
	else
		setButtonAppearance(Color3.fromRGB(120, 120, 120), 0.55)
		button.AutoButtonColor = false
		button.Active = false
	end
end

button.Activated:Connect(function()
	if currentState ~= STATE_READY then
		return
	end

	renderState(STATE_BUSY)
	requestRemote:FireServer()
end)

stateRemote.OnClientEvent:Connect(renderState)

local initialState = stateRemote:GetAttribute("State")
if typeof(initialState) == "string" then
	renderState(initialState)
end

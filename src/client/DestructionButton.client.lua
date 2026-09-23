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

local button = Instance.new("TextButton")
button.Name = "DestroyButton"
button.AnchorPoint = Vector2.new(0.5, 1)
button.Position = UDim2.fromScale(0.5, 0.94)
button.Size = UDim2.fromOffset(220, 56)
button.BackgroundColor3 = Color3.fromRGB(213, 62, 62)
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 22
button.Font = Enum.Font.GothamBold
button.Text = "Waiting for server..."
button.AutoButtonColor = false
button.Active = false
button.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = button

local currentState = "Unavailable"

local function renderState(nextState: string)
	currentState = nextState

	if nextState == STATE_READY then
		button.Text = "DESTROY"
		button.BackgroundColor3 = Color3.fromRGB(213, 62, 62)
		button.AutoButtonColor = true
		button.Active = true
	elseif nextState == STATE_BUSY then
		button.Text = "DESTROYING..."
		button.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
		button.AutoButtonColor = false
		button.Active = false
	else
		button.Text = "ASSET UNAVAILABLE"
		button.BackgroundColor3 = Color3.fromRGB(95, 95, 95)
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

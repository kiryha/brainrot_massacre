--!strict

local PhysicsService = game:GetService("PhysicsService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.DestructionConfig)
local CharacterSpawner = require(script.Parent.CharacterSpawner)

local STATE_READY = "Ready"
local STATE_BUSY = "Busy"
local STATE_DESTROYED = "Destroyed"
local STATE_UNAVAILABLE = "Unavailable"

local function getOrCreateFolder(parent: Instance, name: string): Folder
	local existing = parent:FindFirstChild(name)
	if existing then
		assert(existing:IsA("Folder"), string.format("%s.%s must be a Folder", parent:GetFullName(), name))
		return existing
	end

	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent
	return folder
end

local function getOrCreateRemote(parent: Instance, name: string): RemoteEvent
	local existing = parent:FindFirstChild(name)
	if existing then
		assert(existing:IsA("RemoteEvent"), string.format("%s.%s must be a RemoteEvent", parent:GetFullName(), name))
		return existing
	end

	local remote = Instance.new("RemoteEvent")
	remote.Name = name
	remote.Parent = parent
	return remote
end

local function ensureCollisionGroup(name: string)
	if not PhysicsService:IsCollisionGroupRegistered(name) then
		PhysicsService:RegisterCollisionGroup(name)
	end
end

ensureCollisionGroup(Config.FragmentCollisionGroup)
ensureCollisionGroup(Config.PlayerCollisionGroup)
PhysicsService:CollisionGroupSetCollidable(Config.FragmentCollisionGroup, Config.FragmentCollisionGroup, false)
PhysicsService:CollisionGroupSetCollidable(Config.FragmentCollisionGroup, Config.PlayerCollisionGroup, false)
PhysicsService:CollisionGroupSetCollidable(Config.FragmentCollisionGroup, "Default", true)

local remotes = getOrCreateFolder(ReplicatedStorage, Config.RemotesFolderName)
local requestRemote = getOrCreateRemote(remotes, Config.RequestRemoteName)
local stateRemote = getOrCreateRemote(remotes, Config.StateRemoteName)

local state = STATE_UNAVAILABLE
local activeIntact: Model? = nil
local lastRequestByPlayer: { [Player]: number } = {}

local function setState(nextState: string)
	state = nextState
	stateRemote:SetAttribute("State", nextState)
	stateRemote:FireAllClients(nextState)
end

local function assignPlayerPart(part: Instance)
	if part:IsA("BasePart") then
		part.CollisionGroup = Config.PlayerCollisionGroup
	end
end

local function configurePlayerCharacter(character: Model)
	for _, descendant in character:GetDescendants() do
		assignPlayerPart(descendant)
	end

	character.DescendantAdded:Connect(assignPlayerPart)
end

local function configurePlayer(player: Player)
	if player.Character then
		configurePlayerCharacter(player.Character)
	end

	player.CharacterAdded:Connect(configurePlayerCharacter)
end

local function randomUnitVector(random: Random): Vector3
	local candidate = Vector3.zero

	repeat
		candidate = Vector3.new(
			random:NextNumber(-1, 1),
			random:NextNumber(-1, 1),
			random:NextNumber(-1, 1)
		)
	until candidate.Magnitude > 0.001

	return candidate.Unit
end

local function releaseFragments(fractured: Model, parts: { BasePart })
	local boundingCFrame = fractured:GetBoundingBox()
	local center = boundingCFrame.Position
	local timeScale = Config.SlowMotionTimeScale
	local gravityScale = timeScale * timeScale
	local random = if Config.UseDebugRandomSeed
		then Random.new(Config.DebugRandomSeed)
		else Random.new()

	for _, part in parts do
		part.CollisionGroup = Config.FragmentCollisionGroup
		part.CanCollide = true
		part.CanTouch = false
		part.Anchored = false
		part.CustomPhysicalProperties = PhysicalProperties.new(
			Config.FragmentDensity,
			Config.FragmentFriction,
			Config.FragmentElasticity,
			1,
			1
		)

		local canSetOwnership = part:CanSetNetworkOwnership()
		if canSetOwnership then
			part:SetNetworkOwner(nil)
		end

		local offset = part.Position - center
		local outward = Vector3.new(offset.X, 0, offset.Z)
		if outward.Magnitude <= 0.001 then
			outward = Vector3.new(
				random:NextNumber(-1, 1),
				0,
				random:NextNumber(-1, 1)
			)
		end

		if outward.Magnitude <= 0.001 then
			outward = Vector3.xAxis
		end

		local lateral = Vector3.new(
			random:NextNumber(-1, 1),
			0,
			random:NextNumber(-1, 1)
		) * Config.LateralSpeed
		local velocity = outward.Unit * random:NextNumber(Config.OutwardSpeedMin, Config.OutwardSpeedMax)
			+ Vector3.yAxis * random:NextNumber(Config.UpwardSpeedMin, Config.UpwardSpeedMax)
			+ lateral

		local assemblyMass = part.AssemblyMass
		local gravityCompensation = Instance.new("VectorForce")
		gravityCompensation.Name = "SlowMotionGravity"
		gravityCompensation.ApplyAtCenterOfMass = true
		gravityCompensation.RelativeTo = Enum.ActuatorRelativeTo.World
		gravityCompensation.Force = Vector3.yAxis * workspace.Gravity * assemblyMass * (1 - gravityScale)

		local forceAttachment = Instance.new("Attachment")
		forceAttachment.Name = "SlowMotionGravityAttachment"
		forceAttachment.Parent = part
		gravityCompensation.Attachment0 = forceAttachment
		gravityCompensation.Parent = part

		part:ApplyImpulse(velocity * timeScale * assemblyMass)
		part:ApplyAngularImpulse(
			randomUnitVector(random) * Config.AngularImpulseStrength * timeScale * assemblyMass
		)
	end
end

local function spawnIntact(pivot: CFrame): boolean
	local success, result = pcall(CharacterSpawner.spawnIntact, pivot)
	if not success then
		warn(string.format("Could not spawn intact character: %s", tostring(result)))
		activeIntact = nil
		setState(STATE_UNAVAILABLE)
		return false
	end

	activeIntact = result :: Model
	setState(STATE_READY)
	return true
end

local function recoverFromFailure(pivot: CFrame, fractured: Model?, message: string)
	warn(message)

	if fractured then
		fractured:Destroy()
	end

	if activeIntact and activeIntact.Parent then
		setState(STATE_READY)
	else
		spawnIntact(pivot)
	end
end

local function destroyCharacter()
	if not activeIntact or not activeIntact.Parent then
		setState(STATE_UNAVAILABLE)
		return
	end

	local intact = activeIntact
	setState(STATE_BUSY)
	local capturedPivot = intact:GetPivot()
	local preparedFractured: Model? = nil

	local success, failure = xpcall(function()
		local fractured, parts = CharacterSpawner.prepareFractured(capturedPivot)
		preparedFractured = fractured

		for _, part in parts do
			part.CollisionGroup = Config.FragmentCollisionGroup
			part.CanCollide = true
			part.CanTouch = false
		end

		CharacterSpawner.activatePrepared(fractured)

		intact:Destroy()
		activeIntact = nil
		releaseFragments(fractured, parts)
	end, debug.traceback)

	if not success then
		recoverFromFailure(
			capturedPivot,
			preparedFractured,
			string.format("Destruction failed: %s", tostring(failure))
		)
		return
	end

	setState(STATE_DESTROYED)
end

requestRemote.OnServerEvent:Connect(function(player: Player)
	if player.Parent ~= Players or state ~= STATE_READY then
		return
	end

	local now = os.clock()
	local lastRequest = lastRequestByPlayer[player]
	if lastRequest and now - lastRequest < Config.RequestCooldownSeconds then
		return
	end

	lastRequestByPlayer[player] = now
	destroyCharacter()
end)

Players.PlayerAdded:Connect(function(player)
	configurePlayer(player)
	stateRemote:FireClient(player, state)
end)

Players.PlayerRemoving:Connect(function(player)
	lastRequestByPlayer[player] = nil
end)

for _, player in Players:GetPlayers() do
	configurePlayer(player)
end

CharacterSpawner.clearRuntime()
spawnIntact(CharacterSpawner.getSpawnPivot())

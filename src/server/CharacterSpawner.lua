--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local Config = require(ReplicatedStorage.Shared.DestructionConfig)

local CharacterSpawner = {}

local function getAssetsFolder(): Folder
	local folder = ServerStorage:FindFirstChild(Config.AssetsFolderName)
	assert(folder and folder:IsA("Folder"), string.format(
		"ServerStorage.%s must be a Folder",
		Config.AssetsFolderName
	))

	return folder
end

local function getTemplate(templateName: string): Model
	local template = getAssetsFolder():FindFirstChild(templateName)
	assert(template and template:IsA("Model"), string.format(
		"ServerStorage.%s.%s must be a Model",
		Config.AssetsFolderName,
		templateName
	))

	return template
end

local function collectParts(model: Model): { BasePart }
	local parts = {}

	for _, descendant in model:GetDescendants() do
		if descendant:IsA("BasePart") then
			table.insert(parts, descendant)
		end
	end

	return parts
end

local function getRuntimeFolder(): Folder
	local existing = Workspace:FindFirstChild(Config.RuntimeFolderName)
	if existing then
		assert(existing:IsA("Folder"), string.format(
			"Workspace.%s must be a Folder",
			Config.RuntimeFolderName
		))
		return existing
	end

	local folder = Instance.new("Folder")
	folder.Name = Config.RuntimeFolderName
	folder.Parent = Workspace
	return folder
end

function CharacterSpawner.clearRuntime()
	getRuntimeFolder():ClearAllChildren()
end

function CharacterSpawner.spawnIntact(pivot: CFrame): Model
	local clone = getTemplate(Config.IntactTemplateName):Clone()
	local parts = collectParts(clone)
	assert(#parts > 0, "The intact template contains no BaseParts")

	for _, part in parts do
		part.Anchored = true
	end

	clone:PivotTo(pivot)
	clone.Parent = getRuntimeFolder()
	return clone
end

function CharacterSpawner.prepareFractured(pivot: CFrame): (Model, { BasePart })
	local clone = getTemplate(Config.FracturedTemplateName):Clone()
	local parts = collectParts(clone)
	assert(#parts >= Config.MinimumFragmentCount, string.format(
		"The fractured template needs at least %d BaseParts; found %d",
		Config.MinimumFragmentCount,
		#parts
	))

	for _, part in parts do
		part.Anchored = true
	end

	clone:PivotTo(pivot)
	return clone, parts
end

function CharacterSpawner.activatePrepared(model: Model)
	model.Parent = getRuntimeFolder()
end

return CharacterSpawner

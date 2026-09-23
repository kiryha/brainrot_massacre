--!strict

return {
	AssetsFolderName = "CharacterAssets",
	IntactTemplateName = "TralaleroTralala_Intact",
	FracturedTemplateName = "TralaleroTralala_Fractured",
	RuntimeFolderName = "BrainrotCharacters",

	RemotesFolderName = "Remotes",
	RequestRemoteName = "RequestDestruction",
	StateRemoteName = "DestructionState",

	FragmentCollisionGroup = "DestructionFragments",
	PlayerCollisionGroup = "Players",

	SpawnPivot = CFrame.new(),
	MinimumFragmentCount = 2,
	RequestCooldownSeconds = 0.75,
	FragmentLifetimeSeconds = 6,
	RespawnDelaySeconds = 2,

	OutwardSpeedMin = 18,
	OutwardSpeedMax = 28,
	UpwardSpeedMin = 12,
	UpwardSpeedMax = 18,
	LateralSpeed = 4,
	AngularImpulseStrength = 8,
	UseDebugRandomSeed = false,
	DebugRandomSeed = 12345,
}

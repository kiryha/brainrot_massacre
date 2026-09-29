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
	-- Time until debris is removed, the intact character returns, and the button reactivates.
	RespawnDelaySeconds = 4,

	-- Scales fragment velocity, spin, and gravity without slowing the player.
	-- 1 is real time; 0.3 is approximately 30% speed.
	SlowMotionTimeScale = 0.3,
	OutwardSpeedMin = 18,
	OutwardSpeedMax = 28,
	UpwardSpeedMin = 12,
	UpwardSpeedMax = 18,
	LateralSpeed = 4,
	AngularImpulseStrength = 8,
	FragmentDensity = 4,
	FragmentFriction = 0.65,
	FragmentElasticity = 0.05,
	UseDebugRandomSeed = false,
	DebugRandomSeed = 12345,
}

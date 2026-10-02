--!strict

return {
	AssetsFolderName = "CharacterAssets",
	IntactTemplateName = "TralaleroTralala_Intact",
	FracturedTemplateName = "TralaleroTralala_Fractured",
	RuntimeFolderName = "BrainrotCharacters",
	SpawnMarkerName = "SpawnTralaleroTralala",

	RemotesFolderName = "Remotes",
	RequestRemoteName = "RequestDestruction",
	StateRemoteName = "DestructionState",

	FragmentCollisionGroup = "DestructionFragments",
	PlayerCollisionGroup = "Players",

	-- Used only when Workspace does not contain SpawnMarkerName.
	SpawnPivot = CFrame.new(),
	MinimumFragmentCount = 2,
	RequestCooldownSeconds = 0.75,

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

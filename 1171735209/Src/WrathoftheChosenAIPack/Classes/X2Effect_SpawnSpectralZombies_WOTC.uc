class X2Effect_SpawnSpectralZombies_WOTC extends X2Effect_SpawnSpectralZombies;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetUnitState;
	local int i;
	local int FocusLevel;

	TargetUnitState = XComGameState_Unit(kNewTargetState);
	`assert(TargetUnitState != none);

	// Loop over the num chosen level which starts at 1
	FocusLevel = TargetUnitState.GetTemplarFocusLevel() + 1; // Minimum of 2 units, +1 hence.
	for (i = 1; i <= FocusLevel; ++i)
	{
		TriggerSpawnEvent(ApplyEffectParameters, TargetUnitState, NewGameState, NewEffectState);
	}
}
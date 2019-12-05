class X2Effect_SilentKill extends X2Effect_Persistent;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	//local XComGameState_Unit UnitState;
	//
	//UnitState = XComGameState_Unit(kNewTargetState);
	//
	//if (UnitState != none)
	//{
	//	UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
	//	UnitState.SetUnitFloatValue('StealthOverhaul', 1, eCleanup_BeginTactical);
	//}
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}
//
//simulated function OnEffectRemoved(const out EffectAppliedData ApplyEffectParameters, XComGameState NewGameState, bool bCleansed, XComGameState_Effect RemovedEffectState)
//{
//	local XComGameState_Unit UnitState;
//	
//	UnitState = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
//	if (UnitState != none)
//	{
//		UnitState = XComGameState_Unit(NewGameState.ModifyStateObject(UnitState.Class, UnitState.ObjectID));
//		UnitState.SetUnitFloatValue('StealthOverhaul', 0);
//	}
//}

defaultproperties
{
	EffectName = "SilentKillEffect"
}
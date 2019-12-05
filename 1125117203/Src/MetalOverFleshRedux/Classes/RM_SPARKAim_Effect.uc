class RM_SPARKAim_Effect extends X2Effect_ModifyStats;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit SourceUnit;

	SourceUnit = XComGameState_Unit(NewGameState.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	if (SourceUnit == none)
		SourceUnit = XComGameState_Unit(`XCOMHISTORY.GetGameStateForObjectID(ApplyEffectParameters.SourceStateObjectRef.ObjectID));
	`assert(SourceUnit != none);

	CalculateAimStats(SourceUnit, XComGameState_Unit(kNewTargetState), NewEffectState);
	
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}

simulated protected function CalculateAimStats(XComGameState_Unit SourceUnit, XComGameState_Unit TargetUnit, XComGameState_Effect EffectState)
{

	local StatChange Camaraderie;

	// Mobility

		Camaraderie.StatType = eStat_Offense;
		Camaraderie.StatAmount = class'RM_SPARKTechs_Helpers'.default.AIM_POINTS;
		EffectState.StatChanges.AddItem(Camaraderie);

}

function bool IsEffectCurrentlyRelevant(XComGameState_Effect EffectGameState, XComGameState_Unit TargetUnit)
{
	//  Only relevant if we successfully rolled any stat changes
	return EffectGameState.StatChanges.Length > 0;
}

DefaultProperties
{
	EffectName = "SPARKAim"
	DuplicateResponse = eDupe_Ignore
}
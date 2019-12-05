class SeqAct_ResistanceRedAlert extends SequenceAction;

event Activated()
{
	local XComGameStateHistory History;
	local XComGameState_Unit Unit;

	History = `XCOMHISTORY;

	foreach History.IterateByClassType(class'XComGameState_Unit', Unit)
	{
		if(Unit.GetTeam() == eTeam_Resistance && !Unit.IsDead())
		{
			Unit.ApplyAlertAbilityForNewAlertData(eAC_TakingFire);
			Unit.GetGroupMembership().InitiateReflexMoveActivate(Unit, eAC_SeesSpottedUnit);
		}
	}
}

defaultproperties
{
	ObjCategory="Gameplay"
	ObjName="Resistance Red Alert"
	bConvertedForReplaySystem=true
	bCanBeUsedForGameplaySequence=true

	VariableLinks.Empty
}
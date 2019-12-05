class RM_RevivalCondition extends X2Condition;

event name CallMeetsCondition(XComGameState_BaseObject kTarget)
{
	local XComGameState_Unit TargetUnit;

	TargetUnit = XComGameState_Unit(kTarget);
	if (TargetUnit == none)
		return 'AA_NotAUnit';

	if (!TargetUnit.GetMyTemplate().bCanBeRevived || TargetUnit.IsBeingCarried() )
		return 'AA_UnitIsImmune';

	if (TargetUnit.IsPanicked() || TargetUnit.IsUnconscious() || TargetUnit.IsDisoriented() || TargetUnit.IsStunned() || TargetUnit.IsDazed())
		return 'AA_Success';

	return 'AA_UnitIsNotImpaired';
}

event name CallMeetsConditionWithSource(XComGameState_BaseObject kTarget, XComGameState_BaseObject kSource)
{
	local XComGameState_Unit SourceUnit, TargetUnit;
	local XComGameState_Player SourceTeam, TargetTeam;

	SourceUnit = XComGameState_Unit(kSource);
	TargetUnit = XComGameState_Unit(kTarget);

	SourceTeam = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(SourceUnit.GetAssociatedPlayerID()));
	TargetTeam = XComGameState_Player(`XCOMHISTORY.GetGameStateForObjectID(TargetUnit.GetAssociatedPlayerID()));

	if (SourceUnit == none || TargetUnit == none)
		return 'AA_NotAUnit';

	if (!SourceTeam.IsEnemyPlayer(TargetTeam)) //this will catch eTeam_Resistance in addition to XCOM
		return 'AA_Success';

	return 'AA_UnitIsHostile';
}
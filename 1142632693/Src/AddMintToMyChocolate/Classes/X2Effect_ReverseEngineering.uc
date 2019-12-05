class X2Effect_ReverseEngineering extends X2Effect;

var int MaxBonus;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit TargetState;
	local UnitValue CountValue;
	local int Bonus;

	TargetState = XComGameState_Unit(kNewTargetState);
	if (TargetState == none)
		return;

	TargetState.GetUnitValue('ReverseEngineeringCount', CountValue);
	Bonus = `SYNC_RAND(MaxBonus) + 1;

	if(TargetState.HasSoldierAbility('AptitudeGREMLIN', true))
		Bonus += 2;

	TargetState = XComGameState_Unit(NewGameState.CreateStateObject(TargetState.class, TargetState.ObjectID));
	NewGameState.AddStateObject(TargetState);

	TargetState.SetBaseMaxStat(eStat_Hacking, TargetState.GetBaseStat(eStat_Hacking) + Bonus);
	TargetState.SetUnitFloatValue('ReverseEngineeringCount', CountValue.fValue + 1, eCleanup_Never);
}
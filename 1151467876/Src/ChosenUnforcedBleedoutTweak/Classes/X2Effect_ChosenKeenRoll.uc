class X2Effect_ChosenKeenRoll extends X2Effect_Persistent config(ChosenBleedout);

var config int ForceBleedoutChance;

function bool ForcesBleedoutWhenDamageSource(XComGameState NewGameState, XComGameState_Unit UnitState, XComGameState_Effect EffectState)
{
	local int roll;
	Roll = `SYNC_RAND(100);
	if(Roll <= default.ForceBleedoutChance)
		return UnitState.CanBleedOut();
	else
		return false;
}

defaultproperties
{
	EffectName="ChosenKeenRoll"
}
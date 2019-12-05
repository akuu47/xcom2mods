class X2Effect_IRI_FirstAid extends X2Effect config(FirstAid);

var config int EXTEND_BLEEDOUT_TIMER_BY_TURNS;

simulated protected function OnEffectAdded(const out EffectAppliedData ApplyEffectParameters, XComGameState_BaseObject kNewTargetState, XComGameState NewGameState, XComGameState_Effect NewEffectState)
{
	local XComGameState_Unit UnitState;
	local XComGameState_Effect BleedOutEffect;

	UnitState = XComGameState_Unit(kNewTargetState);

	if (UnitState != none)
	{
		BleedOutEffect = UnitState.GetUnitAffectedByEffectState(class'X2StatusEffects'.default.BleedingOutName);
		if (BleedOutEffect != none)
		{
			BleedOutEffect.iTurnsRemaining += default.EXTEND_BLEEDOUT_TIMER_BY_TURNS;
		}
	}
	super.OnEffectAdded(ApplyEffectParameters, kNewTargetState, NewGameState, NewEffectState);
}
/*
simulated function int GetBleedingOutTurnsRemaining()
{
	

	if( IsBleedingOut() )
	{
		BleedOutEffect = GetUnitAffectedByEffectState(class'X2StatusEffects'.default.BleedingOutName);
		if( BleedOutEffect != none )
		{
			return BleedOutEffect.iTurnsRemaining;
		}
	}
	return 0;
}

*/
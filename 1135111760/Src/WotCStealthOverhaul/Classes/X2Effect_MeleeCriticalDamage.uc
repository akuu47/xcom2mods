class X2Effect_MeleeCriticalDamage extends X2Effect_Persistent;

var int BonusDamage;

function bool AllowCritOverride() { return true; }
function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit TargetUnit;
	
	TargetUnit = XComGameState_Unit(TargetDamageable);
	if (AbilityState.IsMeleeAbility() && TargetUnit != None)
	{
		if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
		{
			return BonusDamage;
		}
	}
	return 0;
}
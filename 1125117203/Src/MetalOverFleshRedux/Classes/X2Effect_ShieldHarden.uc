class X2Effect_ShieldHarden extends X2Effect_BonusArmor;

function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	if ( XComGameState_Unit(TargetDamageable).GetCurrentStat(eStat_ShieldHP) < CurrentDamage && XComGameState_Unit(TargetDamageable).GetCurrentStat(eStat_ShieldHP) != 0 )
	{
		return -int(float(CurrentDamage) - XComGameState_Unit(TargetDamageable).GetCurrentStat(eStat_ShieldHP) ); //floating is used here because we want to avoid rounding until we have the final result
	}
	else
	{
		return 0;
	}
}
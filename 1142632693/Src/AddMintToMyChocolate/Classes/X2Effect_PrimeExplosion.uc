class X2Effect_PrimeExplosion extends X2Effect_ApplyWeaponDamage config(GameData_SoldierSkills);

function WeaponDamageValue GetBonusEffectDamageValue(XComGameState_Ability AbilityState, XComGameState_Unit SourceUnit, XComGameState_Item SourceWeapon, StateObjectReference TargetRef)
{
	local WeaponDamageValue MineDamage;

	if (SourceUnit.HasSoldierAbility('MNT_SystemUplink'))
	{
		MineDamage = class'X2Ability_ReaperAbilitySet'.default.HomingShrapnelDamage;
	}
	else
	{
		MineDamage = class'X2Ability_ReaperAbilitySet'.default.HomingShrapnelDamage;
	}
	
	return MineDamage;
}

DefaultProperties
{
	bExplosiveDamage = true
	bIgnoreBaseDamage = true
}
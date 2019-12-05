class RM_X2Effect_DamageControl extends X2Effect_BonusArmor;

function int GetArmorChance(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    return 100;
}

function int GetArmorMitigation(XComGameState_Effect EffectState, XComGameState_Unit UnitState)
{
    return class'RM_SPARKTechs_Helpers'.default.NanoArmour;
}


function int GetDefendingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, X2Effect_ApplyWeaponDamage WeaponDamageEffect, optional XComGameState NewGameState)
{
	local int DamageMod;
	DamageMod = 0; 
	// -(class'RM_SPARKTechs_Helpers'.default.NanoArmour)
	//zero'd out for now
	//XCOMUnit = XComGameState_Unit(TargetDamageable);
//
	//if(XComUnit != none && XComUnit.HasSoldierAbility('DamageControl'))
		//DamageMod = 0; //this is to prevent SPARKs from being ubertanks with Damage Control stacked ontop of this.
//
	//if(CurrentDamage < class'RM_SPARKTechs_Helpers'.default.NanoArmour)
		//DamageMod = 0; //this is to prevent shots from accidentally healing the SPARK
//

	return DamageMod;
}
//---------------------------------------------------------------------------------------
//  FILE:    X2Effect_HEATGrenades.uc
//  AUTHOR:  Amineri (Pavonis Interactive)
//  PURPOSE: Grants grenades the ability to pierce armor
//---------------------------------------------------------------------------------------
class X2Effect_HEATGrenades extends X2Effect_Persistent;

var int ShredMod;
var int PierceMod;

function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate;

	SourceWeapon = AbilityState.GetSourceWeapon();
	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	
	if(WeaponTemplate == none)
		return 0;

	// make sure the weapon is either a grenade or a grenade launcher
	if(X2GrenadeTemplate(WeaponTemplate) != none || X2GrenadeLauncherTemplate(WeaponTemplate) != none)
	{
		return PierceMod;
	}
	return 0;
}

function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate,SourceWeaponAmmoTemplate;

	SourceWeapon = AbilityState.GetSourceWeapon();
	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	
	if(WeaponTemplate == none)
		return 0;

	// make sure the weapon is either a grenade or a grenade launcher
	if(X2GrenadeTemplate(WeaponTemplate) != none || X2GrenadeLauncherTemplate(WeaponTemplate) != none)
	{
		// make sure it already shreds
		if (WeaponTemplate.BaseDamage.Shred > 0)
		{
			return ShredMod;
		}
		SourceWeaponAmmoTemplate = X2WeaponTemplate(SourceWeapon.GetLoadedAmmoTemplate(AbilityState));
		if (SourceWeaponAmmoTemplate.BaseDamage.Shred > 0)
		{
			return ShredMod;
		}
	}
	return 0;
}

DefaultProperties
{
	EffectName="MNT_HEATGrenades"
	DuplicateResponse = eDupe_Ignore
}

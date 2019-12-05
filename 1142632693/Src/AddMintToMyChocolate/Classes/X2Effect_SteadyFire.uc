class X2Effect_SteadyFire extends X2Effect_Persistent;

var int ShredMod;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {

	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate;

	SourceWeapon = AbilityState.GetSourceWeapon();
	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	
	if(WeaponTemplate == none)
		return 0;

	if(WeaponTemplate.WeaponCat != 'cannon')
		return 0;

	switch (WeaponTemplate.WeaponTech)
		{
			case 'conventional':
			case 'laser':
				return 1;
				break;
			case 'magnetic':
			case 'coil':
				return 2;
				break;
			case 'beam':
				return 3;
			default:
				break;
		}
	return 0;

}

function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate;

	SourceWeapon = AbilityState.GetSourceWeapon();
	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	
	if(WeaponTemplate == none)
		return 0;

	if(WeaponTemplate.WeaponCat != 'cannon')
		return 0;

	return ShredMod;
}

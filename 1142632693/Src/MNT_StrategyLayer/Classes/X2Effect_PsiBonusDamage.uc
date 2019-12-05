class X2Effect_PsiBonusDamage extends X2Effect_Persistent config (Mint_StrategyOverhaul);

var config float AMP_BIO;
var config float PSI_PER_DAMAGE;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
		
	local float BonusDamage;
	local XComGameState_Unit TargetUnit;
	local XComGameState_Item SourceWeapon;
	local X2WeaponTemplate WeaponTemplate;

	SourceWeapon = AbilityState.GetSourceWeapon();
	WeaponTemplate = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	
	if(WeaponTemplate == none)
		return 0;

	if(WeaponTemplate.WeaponCat != 'psiamp' && WeaponTemplate.InventorySlot != eInvSlot_Utility)
		return 0;

	TargetUnit = XComGameState_Unit(TargetDamageable);
	
	BonusDamage = Attacker.GetCurrentStat(eStat_PsiOffense) / default.PSI_PER_DAMAGE;
	
	if(TargetUnit != none && !TargetUnit.IsRobotic())
	{
		BonusDamage += CurrentDamage * default.AMP_BIO;
	}
	return int(BonusDamage);
}
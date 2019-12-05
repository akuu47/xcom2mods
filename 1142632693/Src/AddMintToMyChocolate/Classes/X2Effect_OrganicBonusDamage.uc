class X2Effect_OrganicBonusDamage extends X2Effect_Persistent;

var float DamageMultiplier;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
		
	local XComGameState_Unit TargetUnit;
	local XComGameState_Item SourceWeapon;


	if (AppliedData.AbilityResultContext.HitResult == eHit_Success)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		//  make sure the ammo that created this effect is loaded into the weapon
		if (SourceWeapon != none && SourceWeapon.LoadedAmmo.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
		{
				TargetUnit = XComGameState_Unit(TargetDamageable);

				if(TargetUnit != none && !TargetUnit.IsRobotic())
				{
					if(TargetUnit.GetCurrentStat(eStat_ArmorMitigation) <= 0 && TargetUnit.GetCurrentStat(eStat_ShieldHP) <= 0)
						return CurrentDamage * DamageMultiplier;
				}
		}
	}
	return 0;
}

defaultproperties
{
	EffectName = "FlechetteRounds";
}
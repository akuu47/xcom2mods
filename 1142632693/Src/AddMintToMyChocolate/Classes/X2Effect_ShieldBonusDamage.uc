class X2Effect_ShieldBonusDamage extends X2Effect_Persistent;

var float BreakMultiplier;

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState) {
		
	local float BonusDamage;
	local XComGameState_Unit TargetUnit;
	local XComGameState_Item SourceWeapon;
	local int Shields;
	
	if (AppliedData.AbilityResultContext.HitResult == eHit_Success)
	{
		SourceWeapon = AbilityState.GetSourceWeapon();
		//  make sure the ammo that created this effect is loaded into the weapon
		if (SourceWeapon != none && SourceWeapon.LoadedAmmo.ObjectID == EffectState.ApplyEffectParameters.ItemStateObjectRef.ObjectID)
		{
				TargetUnit = XComGameState_Unit(TargetDamageable);

				if(TargetUnit != none)
				{
					Shields = TargetUnit.GetCurrentStat(eStat_ShieldHP);

					if(Shields > 0 && CurrentDamage < Shields)
					{
						BonusDamage = CurrentDamage * BreakMultiplier;

						//Doesn't do overkill damage
						if((CurrentDamage + BonusDamage) > Shields)
							BonusDamage = Shields - CurrentDamage;

						return BonusDamage;
					}
				}
		}
	}
	return 0;
}

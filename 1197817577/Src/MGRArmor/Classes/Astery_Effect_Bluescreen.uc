class Astery_Effect_Bluescreen extends X2Effect_Persistent;

struct ConditionalDamageModifier
{
	var X2Condition         TargetCondition;
	var WeaponDamageValue   DamageValue;
};

var array<X2Effect>     TargetEffects;
var array<ConditionalDamageModifier>   DamageModifiers;

static function Astery_Effect_Bluescreen CreateBluescreenEffect(int RobticDamage, int OrganicDamage)
{
	local X2Condition_UnitProperty Condition_UnitProperty;
	local WeaponDamageValue DamageValue;
	local Astery_Effect_Bluescreen Effect;

	Effect = new class'Astery_Effect_Bluescreen';

	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeRobotic = true;
	DamageValue.DamageType = 'Electrical';
	DamageValue.Damage = OrganicDamage;
	Effect.AddConditionalDamageModifier(Condition_UnitProperty, DamageValue);
	
	Condition_UnitProperty = new class'X2Condition_UnitProperty';
	Condition_UnitProperty.ExcludeOrganic = true;
	Condition_UnitProperty.IncludeWeakAgainstTechLikeRobot = true;
	Condition_UnitProperty.TreatMindControlledSquadmateAsHostile = true;
	DamageValue.Damage = RobticDamage;
	Effect.AddConditionalDamageModifier(Condition_UnitProperty, DamageValue);
		
	Effect.BuildPersistentEffect(1, true, false, true, eGameRule_PlayerTurnBegin);
	Effect.SetDisplayInfo(ePerkBuff_Passive, "Bluescreen", "Bluescreen Desc", "");
	Effect.bUseSourcePlayerState = true;
	Effect.bRemoveWhenTargetDies = false;

	return Effect;
}

function AddConditionalDamageModifier(X2Condition Condition, WeaponDamageValue DamageValue)
{
	local ConditionalDamageModifier Modifier;

	Modifier.DamageValue = DamageValue;
	Modifier.TargetCondition = Condition;
	DamageModifiers.AddItem(Modifier);
}

function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local int i, BonusDamage;
	local XComGameState_Unit SourceState, TargetState;
	local XComGameState_Item SourceWeapon;

	SourceState = Attacker;
	TargetState = XComGameState_Unit(TargetDamageable);


	SourceWeapon = AbilityState.GetSourceWeapon();
	if (SourceWeapon == none || SourceWeapon.InventorySlot != eInvSlot_SecondaryWeapon)
	{
		return 0;
	}

	for (i = 0; i < DamageModifiers.Length; ++i)
	{
		if (TargetDamageable.IsImmuneToDamage(DamageModifiers[i].DamageValue.DamageType))
			continue;
		if (DamageModifiers[i].TargetCondition != none)
		{
			if (DamageModifiers[i].TargetCondition.MeetsCondition(TargetState) != 'AA_Success')
				continue;
			if (DamageModifiers[i].TargetCondition.MeetsConditionWithSource(TargetState, SourceState) != 'AA_Success')
				continue;
		}

		BonusDamage += DamageModifiers[i].DamageValue.Damage;

	}

	return BonusDamage;
}
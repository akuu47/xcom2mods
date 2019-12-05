class TemplateEdits_Abilities extends X2DownloadableContentInfo config(GameData_SoldierSkills);

static event OnPostTemplatesCreated()
{
	UpdatePassives();
	UpdateGrenades();
	UpdateGREMLINs();
	UpdateShots();
	UpdateRestrictions();
}

//Miscellanious edits to some skills
static function UpdatePassives()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('MeditationPreparation', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_meditation";
	}
	AbilityManager.FindAbilityTemplateAllDifficulties('Parkour', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		Template.IconImage = "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_parkour";
	}

}

//Edits to basic attacks since it seems XMB_DoNotConsumeAll isn't working...
static function UpdateShots()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost						Cost;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Effect_GrantActionPoints		RefundEffect;
	local X2AbilityToHitCalc_StandardAim	ToHitCalc;
	local X2AbilityTrigger_EventListener	EventListener;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('StandardShot', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		foreach Template.AbilityCosts(Cost)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(Cost);
			if (ActionPointCost != None)
			{
				//ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('LightEmUp');
				ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('MNT_Marauder');
				ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('MNT_LightEmUp');
				ActionPointCost.DoNotConsumeAllEffects.AddItem('MNT_BulletTime');
			}
		}

		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('MNT_MasterOfArms');

		WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
		WeaponDamageEffect.bIgnoreBaseDamage = true;
		WeaponDamageEffect.bIgnoreArmor = true;		
		WeaponDamageEffect.EffectDamageValue = class'X2Ability_SkirmisherPerks'.default.MASTER_OF_ARMS_DMG;
		WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);

	}
	AbilityManager.FindAbilityTemplateAllDifficulties('SniperStandardFire', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		foreach Template.AbilityCosts(Cost)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(Cost);
			if (ActionPointCost != None)
			{
				ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('MNT_Bracing');
				ActionPointCost.DoNotConsumeAllEffects.AddItem('MNT_BulletTime');
			}
		}

		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('MNT_Bracing');

		RefundEffect = new class'X2Effect_GrantActionPoints';
		RefundEffect.NumActionPoints = 1;
		RefundEffect.PointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
		RefundEffect.TargetConditions.AddItem(AbilityCondition);

		Template.AddShooterEffect(RefundEffect);

	}
	AbilityManager.FindAbilityTemplateAllDifficulties('PistolStandardShot', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		foreach Template.AbilityCosts(Cost)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(Cost);
			if (ActionPointCost != None)
			{
				ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('MNT_Fastdraw');
				ActionPointCost.DoNotConsumeAllEffects.AddItem('MNT_BulletTime');
			}
		}
	}

	AbilityManager.FindAbilityTemplateAllDifficulties('ArcThrowerStun', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		foreach Template.AbilityCosts(Cost)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(Cost);
			if (ActionPointCost != None)
			{
				ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('MNT_Fastdraw');
				ActionPointCost.DoNotConsumeAllEffects.AddItem('MNT_BulletTime');
			}
		}
	}

	AbilityManager.FindAbilityTemplateAllDifficulties('PointBlank', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		foreach Template.AbilityCosts(Cost)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(Cost);
			if (ActionPointCost != None)
			{
				ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('MNT_Fastdraw');
				ActionPointCost.DoNotConsumeAllEffects.AddItem('MNT_BulletTime');
			}
		}
	}

	AbilityManager.FindAbilityTemplateAllDifficulties('BothBarrels', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		foreach Template.AbilityCosts(Cost)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(Cost);
			if (ActionPointCost != None)
			{
				ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('MNT_Fastdraw');
				ActionPointCost.DoNotConsumeAllEffects.AddItem('MNT_BulletTime');
			}
		}
	}

	AbilityManager.FindAbilityTemplateAllDifficulties('SwordSlice', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		foreach Template.AbilityCosts(Cost)
		{
			ActionPointCost = X2AbilityCost_ActionPoints(Cost);
			if (ActionPointCost != None)
			{
				ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('MNT_SwiftStrike');
			}
		}
	}

	AbilityManager.FindAbilityTemplateAllDifficulties('Demolition', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
		ToHitCalc.bGuaranteedHit = true;
		ToHitCalc.bAllowCrit = false;
		Template.AbilityToHitCalc = ToHitCalc;
	}
}

//Updating all grenade-throwing skills
static function UpdateGrenades()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Condition_UnitInventory			UnitInventoryCondition;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2AbilityCost_GrenadeActionPoints	ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityMultiTarget_Radius		RadiusMultiTarget;
	
	local X2Effect_Stunned					StunnedEffect;
	local X2Effect_HoloTarget				HoloEffect;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
	AbilityManager.FindAbilityTemplateAllDifficulties('LaunchGrenade', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		//Switching to GrenadeActionPoints
		Template.AbilityCosts.Length = 0;

		AmmoCost = new class'X2AbilityCost_Ammo';
		AmmoCost.iAmmo = 1;
		AmmoCost.UseLoadedAmmo = true;
		Template.AbilityCosts.AddItem(AmmoCost);
	
		ActionPointCost = new class'X2AbilityCost_GrenadeActionPoints';
		ActionPointCost.iNumPoints = 1;
		ActionPointCost.bConsumeAllPoints = true;
		ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Salvo');
		ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('TotalCombat');
		Template.AbilityCosts.AddItem(ActionPointCost);

		//stuns foes with Shock and Awe
		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('ShockAndAwe');
	
		StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, class'X2Ability_ItemPerks'.default.ShockAndAwe_Shock);
		StunnedEffect.bRemoveWhenSourceDies = false;
		StunnedEffect.TargetConditions.AddItem(AbilityCondition);

		Template.AddMultiTargetEffect(StunnedEffect);

		//Holotargets with VPS
		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('MNT_VitalPointScan');

		UnitPropertyCondition = new class'X2Condition_UnitProperty';
		UnitPropertyCondition.ExcludeDead = true;
		UnitPropertyCondition.ExcludeFriendlyToSource = true;
		UnitPropertyCondition.FailOnNonUnits = true;

		HoloEffect = class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect();
		HoloEffect.TargetConditions.AddItem(UnitPropertyCondition);
		HoloEffect.TargetConditions.AddItem(AbilityCondition);
		
		Template.AddMultiTargetEffect(HoloEffect);

		RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
		RadiusMultiTarget.bUseWeaponRadius = true;
		RadiusMultiTarget.bUseWeaponBlockingCoverFlag = true;
		RadiusMultiTarget.AddAbilityBonusRadius('MNT_DangerZone', 2);
		Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	}

	AbilityManager.FindAbilityTemplateAllDifficulties('ThrowGrenade', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		//Switching to GrenadeActionPoints
		Template.AbilityCosts.Length = 0;

		AmmoCost = new class'X2AbilityCost_Ammo';
		AmmoCost.iAmmo = 1;
		Template.AbilityCosts.AddItem(AmmoCost);
	
		ActionPointCost = new class'X2AbilityCost_GrenadeActionPoints';
		ActionPointCost.iNumPoints = 1;
		ActionPointCost.bConsumeAllPoints = true;
		ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('Salvo');
		ActionPointCost.DoNotConsumeAllSoldierAbilities.AddItem('TotalCombat');
		Template.AbilityCosts.AddItem(ActionPointCost);
		
		//Hide throw grenade for primary grenade launchers as well
		UnitInventoryCondition = new class'X2Condition_UnitInventory';
		UnitInventoryCondition.RelevantSlot = eInvSlot_PrimaryWeapon;
		UnitInventoryCondition.ExcludeWeaponCategory = 'grenade_launcher';
		Template.AbilityShooterConditions.AddItem(UnitInventoryCondition);

		//Holotargets with VPS
		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('MNT_VitalPointScan');

		UnitPropertyCondition = new class'X2Condition_UnitProperty';
		UnitPropertyCondition.ExcludeDead = true;
		UnitPropertyCondition.ExcludeFriendlyToSource = true;
		UnitPropertyCondition.FailOnNonUnits = true;

		HoloEffect = class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect();
		HoloEffect.TargetConditions.AddItem(UnitPropertyCondition);
		HoloEffect.TargetConditions.AddItem(AbilityCondition);
		
		Template.AddMultiTargetEffect(HoloEffect);

		RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
		RadiusMultiTarget.bUseWeaponRadius = true;
		RadiusMultiTarget.bUseWeaponBlockingCoverFlag = true;
		RadiusMultiTarget.AddAbilityBonusRadius('MNT_DangerZone', 2);
		Template.AbilityMultiTargetStyle = RadiusMultiTarget;
	}
}

//Updating all GREMLIN skills
static function UpdateGREMLINs()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Condition_UnitProperty          UnitCondition;

	local X2Effect_Squadsight				SquadsightEffect;
	local X2Effect_HoloTarget				HoloEffect;
	local X2Effect_DisableWeapon			DisableEffect;
	local X2Effect_Stunned					StunnedEffect;
	local X2Effect_Knockback				KnockbackEffect;
	local XMBEffect_AddAbility				AddHoloEffect;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityManager.FindAbilityTemplateAllDifficulties('AidProtocol', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		//extended effects
		UnitCondition = new class'X2Condition_UnitProperty';
		UnitCondition.ExcludeHostileToSource = true;
		UnitCondition.ExcludeFriendlyToSource = false;

		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('MNT_SystemUplink');
				
		//  adds squadsight w/ Targeting Assist
		SquadsightEffect = new class'X2Effect_Squadsight';
		SquadsightEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
		SquadsightEffect.TargetConditions.AddItem(UnitCondition);
		SquadsightEffect.TargetConditions.AddItem(AbilityCondition);
		Template.AddTargetEffect(SquadsightEffect);

		// adds holo-targeting to all attacks w/ VPS (as opposed to holotargeting this unit for the enemies)
		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('HoloTargeting');

		AddHoloEffect = new class'XMBEffect_AddAbility';
		AddHoloEffect.AbilityName = 'HoloTargeting';
		AddHoloEffect.BuildPersistentEffect(1, false, false, false, eGameRule_PlayerTurnBegin);
		AddHoloEffect.TargetConditions.AddItem(UnitCondition);
		AddHoloEffect.TargetConditions.AddItem(AbilityCondition);
	}

	AbilityManager.FindAbilityTemplateAllDifficulties('ScanningProtocol', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		UnitCondition = new class'X2Condition_UnitProperty';
		UnitCondition.ExcludeHostileToSource = true;
		UnitCondition.ExcludeFriendlyToSource = false;

		// adds holo-targeting to all scanned w/ VPS
		HoloEffect = class'X2Ability_GREMLINPerks'.static.AddHolotargeting();
		HoloEffect.TargetConditions.AddItem(UnitCondition);
		Template.AddMultiTargetEffect(HoloEffect);
	}

	AbilityManager.FindAbilityTemplateAllDifficulties('CombatProtocol', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('MNT_CircuitAmp');

		DisableEffect = new class'X2Effect_DisableWeapon';
		DisableEffect.ApplyChance = 100;
		DisableEffect.TargetConditions.AddItem(AbilityCondition);
		Template.AddTargetEffect(DisableEffect);
	
		StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 50);
		StunnedEffect.bRemoveWhenSourceDies = false;
		StunnedEffect.TargetConditions.AddItem(AbilityCondition);
		Template.AddTargetEffect(StunnedEffect);

		KnockbackEffect = new class'X2Effect_Knockback';
		KnockbackEffect.KnockbackDistance = 2;
		KnockbackEffect.OnlyOnDeath = false; 
		KnockbackEffect.TargetConditions.AddItem(AbilityCondition);
		Template.AddTargetEffect(KnockbackEffect);

		Template.AddTargetEffect(class'X2Ability_GREMLINPerks'.static.AddHolotargeting());
	}

	AbilityManager.FindAbilityTemplateAllDifficulties('CapacitorDischarge', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('MNT_CircuitAmp');

		DisableEffect = new class'X2Effect_DisableWeapon';
		DisableEffect.ApplyChance = 100;
		DisableEffect.TargetConditions.AddItem(AbilityCondition);
		Template.AddTargetEffect(DisableEffect);
	
		StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 50);
		StunnedEffect.bRemoveWhenSourceDies = false;
		StunnedEffect.TargetConditions.AddItem(AbilityCondition);
		Template.AddTargetEffect(StunnedEffect);

		KnockbackEffect = new class'X2Effect_Knockback';
		KnockbackEffect.KnockbackDistance = 2;
		KnockbackEffect.OnlyOnDeath = false; 
		KnockbackEffect.TargetConditions.AddItem(AbilityCondition);
		Template.AddTargetEffect(KnockbackEffect);

		Template.AddTargetEffect(class'X2Ability_GREMLINPerks'.static.AddHolotargeting());
	}
}


// Skirmisher update
static function UpdateSkirmisher()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;
	local X2AbilityTemplate					Template;
	local X2Condition_AbilityProperty		AbilityCondition;
	local X2Effect_Stunned					StunnedEffect;
	local X2AbilityCooldown				    Cooldown;
	local X2AbilityCooldown_Bonus           Cooldown_B;
	local X2Effect_ApplyWeaponDamage		WeaponDamageEffect;
	local X2Condition_UnitProperty			UnitPropertyCondition;
	local X2Effect_GrantActionPoints		Effect;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	AbilityManager.FindAbilityTemplateAllDifficulties('SkirmisherMelee', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		//Add 100% single-action stun effect
		StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(1, 100);
		StunnedEffect.bRemoveWhenSourceDies = false;
		Template.AddTargetEffect(StunnedEffect);

		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('MNT_MasterOfArms');

		WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
		WeaponDamageEffect.bIgnoreBaseDamage = true;
		WeaponDamageEffect.bIgnoreArmor = true;		
		WeaponDamageEffect.EffectDamageValue = class'X2Ability_SkirmisherPerks'.default.MASTER_OF_ARMS_DMG;
		WeaponDamageEffect.TargetConditions.AddItem(AbilityCondition);


	}

	AbilityManager.FindAbilityTemplateAllDifficulties('SkirmisherGrapple', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		Cooldown_B = new class'X2AbilityCooldown_Bonus';
		Cooldown_B.ModifierAbility='MNT_RapidRappel';
		Cooldown_B.iModifier=1;
		Template.AbilityCooldown = Cooldown_B;
		
		AbilityCondition = new class'X2Condition_AbilityProperty';
		AbilityCondition.OwnerHasSoldierAbilities.AddItem('MNT_RapidRappel');

		Effect = new class'X2Effect_GrantActionPoints';
		Effect.NumActionPoints = 1;
		Effect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;
		Effect.TargetConditions.AddItem(AbilityCondition);
		Template.AddTargetEffect(Effect);
	}

	AbilityManager.FindAbilityTemplateAllDifficulties('Whiplash', TemplateAllDifficulties);
	foreach TemplateAllDifficulties(Template)
	{
		Cooldown = new class'X2AbilityCooldown';
		Cooldown.iNumTurns = 2;
		Template.AbilityCooldown = Cooldown;
		
		Template.AbilityTargetEffects.Length = 0;

		// Stuns biological
		StunnedEffect = class'X2StatusEffects'.static.CreateStunnedStatusEffect(2, 100);
		StunnedEffect.bRemoveWhenSourceDies = false;
		UnitPropertyCondition = new class'X2Condition_UnitProperty';
		UnitPropertyCondition.ExcludeRobotic = true;
		UnitPropertyCondition.ExcludeOrganic = false;
		StunnedEffect.TargetConditions.AddItem(UnitPropertyCondition);
		Template.AddTargetEffect(StunnedEffect);	

		// Damages robotics
		WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
		WeaponDamageEffect.bIgnoreArmor = true;		//	armor was applied the first time, don't let it be applied the second time as well -jbouscher
		WeaponDamageEffect.EffectDamageValue = class'X2Ability_SkirmisherAbilitySet'.default.WHIPLASH_BASEDAMAGE;
		UnitPropertyCondition = new class'X2Condition_UnitProperty';
		UnitPropertyCondition.ExcludeRobotic = false;
		UnitPropertyCondition.ExcludeOrganic = true;
		WeaponDamageEffect.TargetConditions.AddItem(UnitPropertyCondition);
		Template.AddTargetEffect(WeaponDamageEffect);
	}
}







//Updating all Weapon Restrictions (for non-Gremlins)
static function UpdateRestrictions()
{
	local X2AbilityTemplateManager			AbilityManager;
	local array<X2AbilityTemplate>			TemplateAllDifficulties;

	AbilityManager = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

	//PRIMARIES
	AbilityManager.FindAbilityTemplateAllDifficulties('SaturationFire', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'dual-rc', false);	

	// PISTOL
	AbilityManager.FindAbilityTemplateAllDifficulties('Faceoff', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'pistol', false);		
	
	AbilityManager.FindAbilityTemplateAllDifficulties('Fanfire', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'pistol', false);	

	AbilityManager.FindAbilityTemplateAllDifficulties('ReturnFire', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'pistol', false);	

	// SWORD
	AbilityManager.FindAbilityTemplateAllDifficulties('Bladestorm', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'sword', false);	

	AbilityManager.FindAbilityTemplateAllDifficulties('Reaper', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'blade', false);	

	// SAWN-OFF
	AbilityManager.FindAbilityTemplateAllDifficulties('PumpAction', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'sawnoffshotgun', false);

	// COMBAT KNIFE
	AbilityManager.FindAbilityTemplateAllDifficulties('Combatives', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'combatknife', false);

	// HOLOTARGETER
	AbilityManager.FindAbilityTemplateAllDifficulties('RapidTargeting', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'holotargeter', false);

	AbilityManager.FindAbilityTemplateAllDifficulties('MultiTargeting', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'holotargeter', false);

	AbilityManager.FindAbilityTemplateAllDifficulties('VitalPointTargeting', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'holotargeter', false);

	AbilityManager.FindAbilityTemplateAllDifficulties('HDHolo', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'holotargeter', false);

	AbilityManager.FindAbilityTemplateAllDifficulties('IndependentTracking', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'holotargeter', false);

	// ARC THROWER
	AbilityManager.FindAbilityTemplateAllDifficulties('EMPulser', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'arcthrower', false);

	AbilityManager.FindAbilityTemplateAllDifficulties('StunGunner', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'arcthrower', false);

	AbilityManager.FindAbilityTemplateAllDifficulties('Electroshock', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'arcthrower', false);

	AbilityManager.FindAbilityTemplateAllDifficulties('ChainLightning', TemplateAllDifficulties);
	AddRestriction(TemplateAllDifficulties, 'arcthrower', false);

}

static function AddRestriction(array<X2AbilityTemplate>	TemplateAllDifficulties, name WeaponCat, optional bool bPrimary=true){

	local X2Condition_ValidWeapon			ValidWeapon;
	local X2AbilityTemplate					Template;

	ValidWeapon = new class'X2Condition_ValidWeapon';

	if(WeaponCat == 'pistol'){
		ValidWeapon.AllowedWeaponCategories.AddItem('pistol');
		ValidWeapon.AllowedWeaponCategories.AddItem('sidearm');
	}
	else if(WeaponCat == 'sidearm'){
		ValidWeapon.AllowedWeaponCategories.AddItem('pistol');
		ValidWeapon.AllowedWeaponCategories.AddItem('sidearm');
		ValidWeapon.AllowedWeaponCategories.AddItem('arcthrower');
		ValidWeapon.AllowedWeaponCategories.AddItem('sawnoffshotgun');
	}
	else if(WeaponCat == 'blade'){
		ValidWeapon.AllowedWeaponCategories.AddItem('sword');
		ValidWeapon.AllowedWeaponCategories.AddItem('gauntlet');
		ValidWeapon.AllowedWeaponCategories.AddItem('combatknife');
	}
	//rifle+cannon
	else if(WeaponCat == 'dual-rc'){
		ValidWeapon.AllowedWeaponCategories.AddItem('rifle');
		ValidWeapon.AllowedWeaponCategories.AddItem('cannon');
	}
	//shotgun+sniper
	else if(WeaponCat == 'dual-ss'){
		ValidWeapon.AllowedWeaponCategories.AddItem('sniper_rifle');
		ValidWeapon.AllowedWeaponCategories.AddItem('shotgun');
	}
	else
		ValidWeapon.AllowedWeaponCategories.AddItem(WeaponCat);

	foreach TemplateAllDifficulties(Template){
		Template.AbilityShooterConditions.AddItem(ValidWeapon);

		if(Template.eAbilityIconBehaviorHUD == eAbilityIconBehavior_NeverShow)
		{
			Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
			Template.HideErrors.AddItem('AA_WeaponIncompatible');
		}
	}
}


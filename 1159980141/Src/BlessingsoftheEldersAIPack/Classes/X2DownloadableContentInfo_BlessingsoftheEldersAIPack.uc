class X2DownloadableContentInfo_BlessingsoftheEldersAIPack extends X2DownloadableContentInfo;

static event OnPostTemplatesCreated() {
   local X2AbilityTemplateManager	  AllAbilities;
   local X2AbilityTemplate            CurrentAbility;
   local X2ItemTemplateManager        AllItems;
   local X2WeaponTemplate             CurrentWeapon;
   local X2AbilityCooldown            Cooldown;
   local X2Condition_UnitProperty     UnitCondition;
   local X2Condition_UnitValue        UnitValue;
   local X2Condition_UnitEffects      ExcludeEffects;
   local X2AbilityCost_ActionPoints   APCost;
	local X2CharacterTemplateManager	  AllCharacters;
   local X2CharacterTemplate		     CurrentUnit;
   local X2DataTemplate					  DifficultyTemplate;
	local array<X2DataTemplate>		  DifficultyTemplates;
   local X2Condition_Visibility	     TargetVisibilityCondition;
   local X2Condition_UnitProperty     TargetPropertyCondition;
   local X2Effect                     TempEffect;
   local X2Effect_DamageImmunity      DamageImmunityEffect;
	local X2Condition_UnitValue	IsOpen;
	local X2Effect_TurnStartActionPoints ThreeActionPoints;

   AllCharacters = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
   AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
   AllItems     = class'X2ItemTemplateManager'.static.GetItemTemplateManager();  
   
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // MINDSPIN HAS A PROPER COOLDOWN SAME AS INSANITY
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   CurrentAbility = AllAbilities.FindAbilityTemplate('MindSpin');
   Cooldown = CreateCooldown(class'X2Ability_PsiOperativeAbilitySet'.default.INSANITY_COOLDOWN);
   CurrentAbility.AbilityCooldown = Cooldown;

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// PSI REANIMATION MAX RANGE 17 TILES + MUST BE IN LOS
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	CurrentAbility = AllAbilities.FindAbilityTemplate('PsiReanimation');
	// FIX RANGE
	CurrentAbility.AbilityTargetConditions.Length = 0;
	// This ability is only valid if the target has not yet been turned into a zombie
	UnitValue = new class'X2Condition_UnitValue';
	UnitValue.AddCheckValue(class'X2Effect_SpawnPsiZombie'.default.TurnedZombieName, 1, eCheck_LessThan);
	CurrentAbility.AbilityTargetConditions.AddItem(UnitValue);

	ExcludeEffects = new class'X2Condition_UnitEffects';
	ExcludeEffects.AddExcludeEffect(class'X2Ability_CarryUnit'.default.CarryUnitEffectName, 'AA_UnitIsImmune');
	ExcludeEffects.AddExcludeEffect(class'X2AbilityTemplateManager'.default.BeingCarriedEffectName, 'AA_UnitIsImmune');
	CurrentAbility.AbilityTargetConditions.AddItem(ExcludeEffects);

   Cooldown = CreateCooldown(5);
   CurrentAbility.AbilityCooldown = Cooldown;

   // PSI Reanimation doesnt end the turn.
   CurrentAbility.AbilityCosts.Length = 0;
   APCost = new class'X2AbilityCost_ActionPoints';
   APCost.iNumPoints = 1;
   APCost.bConsumeAllPoints = false;
   CurrentAbility.AbilityCosts.AddItem(APCost);

	// The unit must be organic, dead, and not an alien
	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeDead = false;
	UnitCondition.ExcludeAlive = true;
	UnitCondition.ExcludeRobotic = true;
	UnitCondition.ExcludeOrganic = false;
	UnitCondition.ExcludeAlien = true;
	UnitCondition.ExcludeCivilian = false;
	UnitCondition.ExcludeCosmetic = true;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeHostileToSource = false;
	UnitCondition.FailOnNonUnits = true;
	UnitCondition.RequireWithinRange = true;
	UnitCondition.WithinRange = 17 * 144; // Conversion into Unreal units, 17 tiles the same as the range of a rifle
	CurrentAbility.AbilityTargetConditions.AddItem(UnitCondition);

	// Must be able to see the dead unit to reanimate it
	TargetVisibilityCondition = new class'X2Condition_Visibility';	
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireLOS = true;
	CurrentAbility.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

   CurrentAbility = AllAbilities.FindAbilityTemplate('Ability_AshRaiseDead');
   if ( CurrentAbility != none ) {
	   CurrentAbility.AbilityTargetConditions.Length = 0;
	   CurrentAbility.AbilityTargetConditions.AddItem(UnitValue);
	   CurrentAbility.AbilityTargetConditions.AddItem(ExcludeEffects);
       CurrentAbility.AbilityCosts.AddItem(APCost);
	   CurrentAbility.AbilityTargetConditions.AddItem(UnitCondition);
	   CurrentAbility.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
       CurrentAbility.AbilityCooldown = Cooldown;
   }

   CurrentAbility = AllAbilities.FindAbilityTemplate('XCOMPsiReanimation');
   if ( CurrentAbility != none ) {
	   CurrentAbility.AbilityTargetConditions.Length = 0;
	   CurrentAbility.AbilityTargetConditions.AddItem(UnitValue);
	   CurrentAbility.AbilityTargetConditions.AddItem(ExcludeEffects);
       CurrentAbility.AbilityCosts.AddItem(APCost);
	   CurrentAbility.AbilityTargetConditions.AddItem(UnitCondition);
	   CurrentAbility.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
       CurrentAbility.AbilityCooldown = Cooldown;
   }

   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // VIPER TONGUE PULL HAS A SMALL COOLDOWN
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   CurrentAbility = AllAbilities.FindAbilityTemplate('GetOverHere');
   Cooldown = CreateCooldown(3);
   CurrentAbility.AbilityCooldown = Cooldown;

   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // POISON SPIT COOLDOWN
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   CurrentAbility = AllAbilities.FindAbilityTemplate('PoisonSpit');
   Cooldown = CreateCooldown(4);
   CurrentAbility.AbilityCooldown = Cooldown;

   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // GATEKEEPER
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   CurrentAbility = AllAbilities.FindAbilityTemplate('AnimaConsume');
   Cooldown = CreateCooldown(3);
   CurrentAbility.AbilityCooldown = Cooldown;
   // ANIMA CONSUME CANNOT BE USED CLOSED
   IsOpen = new class'X2Condition_UnitValue';
   IsOpen.AddCheckValue(class'X2Ability_Gatekeeper'.default.OpenCloseAbilityName, 1, eCheck_Exact, , , 'AA_GatekeeperClosed');
   CurrentAbility.AbilityShooterConditions.AddItem(IsOpen);

   // GATEKEEPER 3 AP
   CurrentAbility = AllAbilities.FindAbilityTemplate('GatekeeperInitialState');
   ThreeActionPoints = new class'X2Effect_TurnStartActionPoints';
   ThreeActionPoints.ActionPointType = class'X2CharacterTemplateManager'.default.StandardActionPoint;
   ThreeActionPoints.NumActionPoints = 1;
   ThreeActionPoints.bInfiniteDuration = true;
   CurrentAbility.AddTargetEffect(ThreeActionPoints);
   // DONT AUTOCLOSE
   CurrentAbility.AdditionalAbilities.RemoveItem('GatekeeperCloseMoveBegin');

   // GATEKEEPER OPEN/CLOSE 1 AP, DOESNT END TURN
   CurrentAbility = AllAbilities.FindAbilityTemplate('GatekeeperOpen');
   CurrentAbility.AbilityCosts.Length = 0;
   APCost = new class'X2AbilityCost_ActionPoints';
   APCost.iNumPoints = 1;
   APCost.bConsumeAllPoints = false;
   APCost.bFreeCost = true;
   CurrentAbility.AbilityCosts.AddItem(APCost);

   CurrentAbility = AllAbilities.FindAbilityTemplate('GatekeeperClose');
   CurrentAbility.AbilityCosts.Length = 0;
   APCost = new class'X2AbilityCost_ActionPoints';
   APCost.iNumPoints = 1;
   APCost.bConsumeAllPoints = false;
   APCost.bFreeCost = true;
   CurrentAbility.AbilityCosts.AddItem(APCost);

   // ANIMA CONSUME EXCLUDE ALLIES
   CurrentAbility = AllAbilities.FindAbilityTemplate('AnimaConsume');

	TargetPropertyCondition = new class'X2Condition_UnitProperty';	
	TargetPropertyCondition.ExcludeDead = true;
	TargetPropertyCondition.ExcludeFriendlyToSource = true;
	CurrentAbility.AbilityTargetConditions.AddItem(TargetPropertyCondition);

	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bVisibleToAnyAlly = true;
	CurrentAbility.AbilityTargetConditions.AddItem(TargetVisibilityCondition); 

   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // MUTON
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   AllAbilities.AddAbilityTemplate( ( class'X2Ability'.static.PurePassive('BayonetMasterPassive', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_bendingreed") ), true);
   AllAbilities.AddAbilityTemplate( class'X2Ability_Muton_Clever'.static.CreateBayonetMaster('BayonetMaster'), true);

   CurrentAbility = AllAbilities.FindAbilityTemplate('Bayonet');
   CurrentAbility.PostActivationEvents.AddItem('BayonetActivated');

   CurrentUnit = AllCharacters.FindCharacterTemplate('Muton');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('Muton', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
               CurrentUnit.Abilities.AddItem('BayonetMaster');
   		   }
         }
	   } else {
         // Same as above but only for one difficulty
         CurrentUnit.Abilities.AddItem('BayonetMaster');      
      }
   }

   //////////////////////////////////////////////////////////////////////////////////////
   // BERSERKER RESTRICTED TO MELEE TO HIT, NO RUNNING
   //////////////////////////////////////////////////////////////////////////////////////
   CurrentAbility = AllAbilities.FindAbilityTemplate('DevastatingPunch');
   CurrentAbility.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
   CurrentAbility.TargetingMethod = class'X2TargetingMethod_MeleePath';
   CurrentAbility.AbilityTargetConditions.Length = 0;

   TargetPropertyCondition = new class'X2Condition_UnitProperty';	
   TargetPropertyCondition.ExcludeDead = true;
   TargetPropertyCondition.ExcludeFriendlyToSource = true;
   TargetPropertyCondition.RequireWithinRange = true;
   TargetPropertyCondition.WithinRange = 144; // 1.5 tiles (96/tile)
   CurrentAbility.AbilityTargetConditions.AddItem(TargetPropertyCondition);

   TargetVisibilityCondition = new class'X2Condition_Visibility';
   TargetVisibilityCondition.bRequireGameplayVisible = true;
   CurrentAbility.AbilityTargetConditions.AddItem(TargetVisibilityCondition);   
   
   CurrentAbility.AbilityTargetConditions.AddItem(new class'X2Condition_BerserkerDevastatingPunch');		

   CurrentAbility.bSkipMoveStop = true;

   // DEVASTATING PUNCH NO LONGER ENDS THE TURN
   CurrentAbility.AbilityCosts.Length = 0;
   APCost = new class'X2AbilityCost_ActionPoints';
   APCost.iNumPoints = 1;
   APCost.bConsumeAllPoints = false;
   CurrentAbility.AbilityCosts.AddItem(APCost);

   //////////////////////////////////////////////////////////////////////////////////////
   // ARCHON CAN MOVE AND MELEE
   //////////////////////////////////////////////////////////////////////////////////////
   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('ArchonStaff'));
   if ( CurrentWeapon != none ) {
	   if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) {
		   AllItems.FindDataTemplateAllDifficulties('ArchonStaff', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			   if ( CurrentWeapon != none ) {
               CurrentWeapon.Abilities.RemoveItem('StandardMelee');
               CurrentWeapon.Abilities.AddItem('StandardMovingMelee');
     		   }
         }
	   } else {
         // Same as above but only for one difficulty
         CurrentWeapon.Abilities.RemoveItem('StandardMelee');
         CurrentWeapon.Abilities.AddItem('StandardMovingMelee');
      }
   }

   //////////////////////////////////////////////////////////////////////////////////////
   // GATEKEEPER SHOOTS WITH A STANDARD WEAPON, RANGE FIX
   //////////////////////////////////////////////////////////////////////////////////////
   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('Gatekeeper_WPN'));
   CurrentWeapon.iSoundRange = 36;
   CurrentWeapon.iEnvironmentDamage = 15;
   CurrentWeapon.iIdealRange = 10;
   CurrentWeapon.iClipSize = 1; // Force GK to reload sometimes with one of its 3 APs, practically like having unlimited ammo anyway
   CurrentWeapon.Aim = 10; // Small bonus for Gatekeeper for not being able to fire 3 times per round
   CurrentWeapon.CritChance = 20; // Small bonus for Gatekeeper for not being able to fire 3 times per round
   CurrentWeapon.InventorySlot = eInvSlot_PrimaryWeapon;
   CurrentWeapon.SetAnimationNameForAbility('StandardShot', 'FF_AnimaGate');
   CurrentWeapon.DamageTypeTemplateName = 'Projectile_BeamAlien';
   CurrentWeapon.bIsLargeWeapon = true;
   CurrentWeapon.bCanBeDodged = false; // Small bonus for Gatekeeper for not being able to fire 3 times per round
   CurrentWeapon.iPhysicsImpulse = 5;

   if ( CurrentWeapon.RangeAccuracy.Length == 0 ) {
      CurrentWeapon.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_BEAM_RANGE;
   }

   CurrentWeapon.Abilities.AddItem('StandardShot');
   CurrentWeapon.Abilities.AddItem('Reload');
   CurrentWeapon.Abilities.AddItem('HotLoadAmmo');
   CurrentUnit = AllCharacters.FindCharacterTemplate('Gatekeeper');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('Gatekeeper', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
                  CurrentUnit.Abilities.RemoveItem('AnimaGate');
   		   }
         }
	   } else {
         // Same as above but only for one difficulty
         CurrentUnit.Abilities.RemoveItem('AnimaGate');
      }
   }

   //////////////////////////////////////////////////////////////////////////////////////
   // ANDROMEDON
   //////////////////////////////////////////////////////////////////////////////////////
   AllAbilities.AddAbilityTemplate( ( class'X2Ability'.static.PurePassive('RelocationPassive', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_bendingreed") ), true);
   AllAbilities.AddAbilityTemplate( class'X2Ability_Andromedon_Tact'.static.CreateRelocation('Relocation'), true);

   CurrentAbility = AllAbilities.FindAbilityTemplate('BigDamnPunch');
   CurrentAbility.PostActivationEvents.AddItem('RelocationActivated');

   CurrentUnit = AllCharacters.FindCharacterTemplate('Andromedon');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('Andromedon', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
               CurrentUnit.Abilities.AddItem('Relocation');
   		   }
         }
	   } else {
         // Same as above but only for one difficulty
         CurrentUnit.Abilities.AddItem('Relocation');      
      }
   }

   //////////////////////////////////////////////////////////////////////////////////////
   // ACID IMMUNITY INJECTED INTO CHRYSSALID IMMUNITIES ABILITY
   //////////////////////////////////////////////////////////////////////////////////////
   CurrentAbility = AllAbilities.FindAbilityTemplate('ChryssalidImmunities');
   foreach CurrentAbility.AbilityTargetEffects( TempEffect ) {
      if ( TempEffect != none ) {
         if ( TempEffect.IsA('X2Effect_DamageImmunity') ) {
            DamageImmunityEffect = X2Effect_DamageImmunity(TempEffect);
            DamageImmunityEffect.ImmuneTypes.AddItem('Acid');
         }
      }
   }

   //////////////////////////////////////////////////////////////////////////////////////
   // COCOON: IMMUNE TO ACID, MENTAL
   //////////////////////////////////////////////////////////////////////////////////////
   CurrentAbility = AllAbilities.FindAbilityTemplate('CocoonGestationTimeStage1');
   foreach CurrentAbility.AbilityTargetEffects( TempEffect ) {
      if ( TempEffect != none ) {
         if ( TempEffect.IsA('X2Effect_DamageImmunity') ) {
            DamageImmunityEffect = X2Effect_DamageImmunity(TempEffect);
            DamageImmunityEffect.ImmuneTypes.AddItem('Acid');
            DamageImmunityEffect.ImmuneTypes.AddItem('Mental');
         }
      }
   }
   
   //////////////////////////////////////////////////////////////////////////////////////
   // -BURROW, -UNBURROW, +IMPLACABLE
   //////////////////////////////////////////////////////////////////////////////////////
   CurrentUnit = AllCharacters.FindCharacterTemplate('Chryssalid');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('Chryssalid', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
               CurrentUnit.Abilities.RemoveItem('ChryssalidBurrow');
			      CurrentUnit.Abilities.RemoveItem('ChryssalidUnburrow');
               CurrentUnit.Abilities.RemoveItem('BurrowedAttack');
               CurrentUnit.Abilities.RemoveItem('UnburrowSawEnemy');
               CurrentUnit.Abilities.AddItem('Implacable');
   		   }
         }
	   } else {
         // Same as above but only for one difficulty
         CurrentUnit.Abilities.RemoveItem('ChryssalidBurrow');
		   CurrentUnit.Abilities.RemoveItem('ChryssalidUnburrow');
         CurrentUnit.Abilities.RemoveItem('BurrowedAttack');
         CurrentUnit.Abilities.RemoveItem('UnburrowSawEnemy');
         CurrentUnit.Abilities.AddItem('Implacable');
      }
   }

   // -BURROW, -UNBURROW, +IMPLACABLE TLE SUPPORT
   CurrentUnit = AllCharacters.FindCharacterTemplate('NeonateChryssalid');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('NeonateChryssalid', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
               CurrentUnit.Abilities.RemoveItem('ChryssalidBurrow');
			      CurrentUnit.Abilities.RemoveItem('ChryssalidUnburrow');
               CurrentUnit.Abilities.RemoveItem('BurrowedAttack');
               CurrentUnit.Abilities.RemoveItem('UnburrowSawEnemy');
               CurrentUnit.Abilities.AddItem('Implacable');
   		   }
         }
	   } else {
         // Same as above but only for one difficulty
         CurrentUnit.Abilities.RemoveItem('ChryssalidBurrow');
		   CurrentUnit.Abilities.RemoveItem('ChryssalidUnburrow');
         CurrentUnit.Abilities.RemoveItem('BurrowedAttack');
         CurrentUnit.Abilities.RemoveItem('UnburrowSawEnemy');
         CurrentUnit.Abilities.AddItem('Implacable');
      }
   }

   //////////////////////////////////////////////////////////////////////////////////////
   // HORROR NO LONGER ENDS THE TURN
   //////////////////////////////////////////////////////////////////////////////////////
   CurrentAbility = AllAbilities.FindAbilityTemplate('Horror');
   CurrentAbility.AbilityCosts.Length = 0;
   APCost = new class'X2AbilityCost_ActionPoints';
   APCost.iNumPoints = 1;
   APCost.bConsumeAllPoints = false;
   CurrentAbility.AbilityCosts.AddItem(APCost);
}

///////////////////////////////////////////////////////////////////////////////////////////////
// HELPERS - CREATE COOLDOWN
///////////////////////////////////////////////////////////////////////////////////////////////
static function X2AbilityCooldown CreateCooldown( int iNewCooldown ) {
   local X2AbilityCooldown Cooldown;
   Cooldown = new class'X2AbilityCooldown';

   if (iNewCooldown <= 0)
	  return none;

   if (iNewCooldown > 9)
      iNewCooldown = 9;

   Cooldown.iNumTurns = iNewCooldown;

   return Cooldown;
}


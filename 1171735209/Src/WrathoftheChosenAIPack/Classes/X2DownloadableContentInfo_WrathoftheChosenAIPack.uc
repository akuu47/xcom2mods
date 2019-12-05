class X2DownloadableContentInfo_WrathoftheChosenAIPack extends X2DownloadableContentInfo config(SniperCrybabies);

static event OnPostTemplatesCreated() {
   local X2AbilityTemplateManager	       AllAbilities;
   local X2AbilityTemplate                 CurrentAbility;
   local X2AbilityCost_ActionPoints        APCost;
   local X2AbilityToHitCalc_StandardMelee  StandardMelee;
   local X2ItemTemplateManager             AllItems;
   local X2WeaponTemplate                  CurrentWeapon;
   local X2DataTemplate					   DifficultyTemplate;
   local array<X2DataTemplate>		       DifficultyTemplates; 
   local X2AbilityTarget_Single MeleeTarget;
   local X2Condition_Visibility TargetVisibilityCondition;

   AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
   AllItems     = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

   // This makes the Chosen Hunter dangerous when not engaged. You want to close in ASAP.
   AddPerk( 'ChosenSniper',       'CoolUnderPressure');
   AddPerk( 'ChosenSniperM2',     'CoolUnderPressure');
   AddPerk( 'ChosenSniperM3',     'CoolUnderPressure');
   AddPerk( 'ChosenSniperM4',     'CoolUnderPressure');

   AddPerk( 'ChosenSniper',       'Sentinel');
   AddPerk( 'ChosenSniperM2',     'Sentinel');
   AddPerk( 'ChosenSniperM3',     'Sentinel');
   AddPerk( 'ChosenSniperM4',     'Sentinel');

   // Firing the Assassin Shotgun doesnt end the turn.
   AddPerk( 'ChosenAssassin',     'SkirmisherStrike');
   AddPerk( 'ChosenAssassinM2',   'SkirmisherStrike');
   AddPerk( 'ChosenAssassinM3',   'SkirmisherStrike');
   AddPerk( 'ChosenAssassinM4',   'SkirmisherStrike');

   // Firing the massive Warlock Rifle doesnt end the turn.
   AddPerk( 'ChosenWarlock',      'SkirmisherStrike');
   AddPerk( 'ChosenWarlockM2',    'SkirmisherStrike');
   AddPerk( 'ChosenWarlockM3',    'SkirmisherStrike');
   AddPerk( 'ChosenWarlockM4',    'SkirmisherStrike');

   // Honestly if you get shot by the Warlock's Overwatch shot, you're just dumb and need to be punished.
   AddPerk( 'ChosenWarlock',       'CoolUnderPressure');
   AddPerk( 'ChosenWarlockM2',     'CoolUnderPressure');
   AddPerk( 'ChosenWarlockM3',     'CoolUnderPressure');
   AddPerk( 'ChosenWarlockM4',     'CoolUnderPressure');

   AddPerk( 'ChosenWarlock',       'Sentinel');
   AddPerk( 'ChosenWarlockM2',     'Sentinel');
   AddPerk( 'ChosenWarlockM3',     'Sentinel');
   AddPerk( 'ChosenWarlockM4',     'Sentinel');       
     
   // ALL CHOSEN GET 3 AP EXCEPT THE FIRST VERSIONS FOR EARLY GAME
   AddPerk( 'ChosenSniperM2',     'Chosen3APAbilityPassive');
   AddPerk( 'ChosenSniperM3',     'Chosen3APAbilityPassive');
   AddPerk( 'ChosenSniperM4',     'Chosen3APAbilityPassive');
   AddPerk( 'ChosenAssassinM2',   'Chosen3APAbilityPassive');
   AddPerk( 'ChosenAssassinM3',   'Chosen3APAbilityPassive');
   AddPerk( 'ChosenAssassinM4',   'Chosen3APAbilityPassive');   
   AddPerk( 'ChosenWarlockM2',    'Chosen3APAbilityPassive');
   AddPerk( 'ChosenWarlockM3',    'Chosen3APAbilityPassive');
   AddPerk( 'ChosenWarlockM4',    'Chosen3APAbilityPassive');       

   FixScamperChosen('ChosenSniper');
   FixScamperChosen('ChosenSniperM2');
   FixScamperChosen('ChosenSniperM3');
   FixScamperChosen('ChosenSniperM4');
   FixScamperChosen('ChosenWarlock');
   FixScamperChosen('ChosenWarlockM2');
   FixScamperChosen('ChosenWarlockM3');
   FixScamperChosen('ChosenWarlockM4');
   FixScamperChosenVanish('ChosenAssassin');
   FixScamperChosenVanish('ChosenAssassinM2');
   FixScamperChosenVanish('ChosenAssassinM3');
   FixScamperChosenVanish('ChosenAssassinM4');

   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // PARTING SILK CAN MISS
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // This is so you can dodge, increase defense and the like.
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

   CurrentAbility = AllAbilities.FindAbilityTemplate('PartingSilk');
	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	StandardMelee.bGuaranteedHit      = false;
   StandardMelee.BuiltInHitMod       = 10;
   StandardMelee.bIgnoreCoverBonus   = true;
   StandardMelee.bMeleeAttack        = true;
	CurrentAbility.AbilityToHitCalc = StandardMelee;
   // COOLDOWN FIX
   CurrentAbility.AbilityCooldown = CreateCooldown(1);

   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // HUNTER GRAPPLE COOLDOWN (2)
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   CurrentAbility = AllAbilities.FindAbilityTemplate('HunterGrapple');
	// New cooldown
	CurrentAbility.AbilityCooldown = CreateCooldown(2);

   // FARSIGHT ICON FIX : Only applies if you place Chosen as friendlies in TEST mode, otherwise the player cant see it.
   CurrentAbility = AllAbilities.FindAbilityTemplate('Farsight');
  	CurrentAbility.IconImage = "img:///UILibrary_PerkIcons.UIPerk_overwatch";

   // REMOVING THE GARBAGE - PLAYER WILL NOT SEE THIS, ONLY IN TEST MODE TQL, REMOVE TRACKING SHOT, MARK AND KILLZONE BUGGED
   RemovePerk( 'ChosenSniper',         'HunterKillzone');
   RemovePerk( 'ChosenSniper',         'TrackingShot');
   RemovePerk( 'ChosenSniper',         'TrackingShotMark');
   RemovePerk( 'ChosenSniperM2',       'HunterKillzone');
   RemovePerk( 'ChosenSniperM2',       'TrackingShot');
   RemovePerk( 'ChosenSniperM2',       'TrackingShotMark');
   RemovePerk( 'ChosenSniperM3',       'HunterKillzone');
   RemovePerk( 'ChosenSniperM3',       'TrackingShot');
   RemovePerk( 'ChosenSniperM3',       'TrackingShotMark');
   RemovePerk( 'ChosenSniperM4',       'HunterKillzone');
   RemovePerk( 'ChosenSniperM4',       'TrackingShot');
   RemovePerk( 'ChosenSniperM4',       'TrackingShotMark');

   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('ChosenSniperRifle_CV'));
   if ( CurrentWeapon != none ) {
	   if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) {
		   AllItems.FindDataTemplateAllDifficulties('ChosenSniperRifle_CV', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			   if ( CurrentWeapon != none ) {
               CurrentWeapon.Abilities.RemoveItem('HunterKillzone');
               CurrentWeapon.Abilities.RemoveItem('TrackingShot');
               CurrentWeapon.Abilities.RemoveItem('TrackingShotMark');
     		   }
         }
	   } else {
         // Same as above but only for one difficulty
         CurrentWeapon.Abilities.RemoveItem('HunterKillzone');
         CurrentWeapon.Abilities.RemoveItem('TrackingShot');
         CurrentWeapon.Abilities.RemoveItem('TrackingShotMark');
      }
   }
   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('ChosenSniperRifle_MG'));
   if ( CurrentWeapon != none ) {
	   if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) {
		   AllItems.FindDataTemplateAllDifficulties('ChosenSniperRifle_MG', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			   if ( CurrentWeapon != none ) {
               CurrentWeapon.Abilities.RemoveItem('HunterKillzone');
               CurrentWeapon.Abilities.RemoveItem('TrackingShot');
               CurrentWeapon.Abilities.RemoveItem('TrackingShotMark');
     		   }
         }
	   } else {
         // Same as above but only for one difficulty
         CurrentWeapon.Abilities.RemoveItem('HunterKillzone');
         CurrentWeapon.Abilities.RemoveItem('TrackingShot');
         CurrentWeapon.Abilities.RemoveItem('TrackingShotMark');
      }
   }
   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('ChosenSniperRifle_BM'));
   if ( CurrentWeapon != none ) {
	   if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) {
		   AllItems.FindDataTemplateAllDifficulties('ChosenSniperRifle_BM', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			   if ( CurrentWeapon != none ) {
               CurrentWeapon.Abilities.RemoveItem('HunterKillzone');
               CurrentWeapon.Abilities.RemoveItem('TrackingShot');
               CurrentWeapon.Abilities.RemoveItem('TrackingShotMark');
     		   }
         }
	   } else {
         // Same as above but only for one difficulty
         CurrentWeapon.Abilities.RemoveItem('HunterKillzone');
         CurrentWeapon.Abilities.RemoveItem('TrackingShot');
         CurrentWeapon.Abilities.RemoveItem('TrackingShotMark');
      }
   }
   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('ChosenSniperRifle_T4'));
   if ( CurrentWeapon != none ) {
	   if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) {
		   AllItems.FindDataTemplateAllDifficulties('ChosenSniperRifle_T4', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			   if ( CurrentWeapon != none ) {
               CurrentWeapon.Abilities.RemoveItem('HunterKillzone');
               CurrentWeapon.Abilities.RemoveItem('TrackingShot');
               CurrentWeapon.Abilities.RemoveItem('TrackingShotMark');
     		   }
         }
	   } else {
         // Same as above but only for one difficulty
         CurrentWeapon.Abilities.RemoveItem('HunterKillzone');
         CurrentWeapon.Abilities.RemoveItem('TrackingShot');
         CurrentWeapon.Abilities.RemoveItem('TrackingShotMark');
      }
   }

   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // TRANQ SHOT IS A QUICKDRAW ACTION
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // Note: Hunter as-is does not have Quickdraw. This has no effect without other mods.
   CurrentAbility = AllAbilities.FindAbilityTemplate('LethalDose');
   CurrentAbility.AbilityCosts.Length = 0;
	APCost = new class'X2AbilityCost_QuickdrawActionPoints';
	APCost.iNumPoints = 1;
	APCost.bConsumeAllPoints = true;
	CurrentAbility.AbilityCosts.AddItem(APCost);

   // FORCE HUNTER PISTOL TO 17 TILES MAXIMUM (NORMAL FIREARM MAX RANGE)
   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('ChosenSniperPistol_CV'));
   if ( CurrentWeapon != none ) {
	   if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) {
		   AllItems.FindDataTemplateAllDifficulties('ChosenSniperPistol_CV', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			   if ( CurrentWeapon != none ) {
               CurrentWeapon.iRange = 17;
     		   }
         }
	   } else {
         CurrentWeapon.iRange = 17;
         // Same as above but only for one difficulty
      }
   }
   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('ChosenSniperPistol_MG'));
   if ( CurrentWeapon != none ) {
	   if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) {
		   AllItems.FindDataTemplateAllDifficulties('ChosenSniperPistol_MG', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			   if ( CurrentWeapon != none ) {
               CurrentWeapon.iRange = 17;
     		   }
         }
	   } else {
         CurrentWeapon.iRange = 17;
         // Same as above but only for one difficulty
      }
   }
   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('ChosenSniperPistol_BM'));
   if ( CurrentWeapon != none ) {
	   if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) {
		   AllItems.FindDataTemplateAllDifficulties('ChosenSniperPistol_BM', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			   if ( CurrentWeapon != none ) {
               CurrentWeapon.iRange = 17;
     		   }
         }
	   } else {
         CurrentWeapon.iRange = 17;
         // Same as above but only for one difficulty
      }
   }
   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('ChosenSniperPistol_T4'));
   if ( CurrentWeapon != none ) {
	   if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) {
		   AllItems.FindDataTemplateAllDifficulties('ChosenSniperPistol_T4', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			   if ( CurrentWeapon != none ) {
               CurrentWeapon.iRange = 17;
     		   }
         }
	   } else {
         CurrentWeapon.iRange = 17;
         // Same as above but only for one difficulty
      }
   }
   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('ChosenSniperPistol_XCOM'));
   if ( CurrentWeapon != none ) {
	   if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) {
		   AllItems.FindDataTemplateAllDifficulties('ChosenSniperPistol_XCOM', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			   if ( CurrentWeapon != none ) {
               CurrentWeapon.iRange = 17;
     		   }
         }
	   } else {
         CurrentWeapon.iRange = 17;
         // Same as above but only for one difficulty
      }
   }

   // OVERWRITE SPECTRAL ARMY TO MAKE IT MINIMUM 2 UNITS
   AllAbilities.AddAbilityTemplate(X2AbilityTemplate(class'X2Ability_ChosenWarlock_WOTC'.static.CreateSpectralArmy('SpectralArmy',   'SpectralStunLancerM1')),true);
   AllAbilities.AddAbilityTemplate(X2AbilityTemplate(class'X2Ability_ChosenWarlock_WOTC'.static.CreateSpectralArmy('SpectralArmyM2', 'SpectralStunLancerM2')),true);
   AllAbilities.AddAbilityTemplate(X2AbilityTemplate(class'X2Ability_ChosenWarlock_WOTC'.static.CreateSpectralArmy('SpectralArmyM3', 'SpectralStunLancerM3')),true);
   AllAbilities.AddAbilityTemplate(X2AbilityTemplate(class'X2Ability_ChosenWarlock_WOTC'.static.CreateSpectralArmy('SpectralArmyM4', 'SpectralStunLancerM4')),true);

   AllAbilities.AddAbilityTemplate(X2AbilityTemplate(class'X2Ability_ChosenWarlock_WOTC'.static.CreateCorress('Corress',   'SpectralZombieM1')),true);
   AllAbilities.AddAbilityTemplate(X2AbilityTemplate(class'X2Ability_ChosenWarlock_WOTC'.static.CreateCorress('CorressM2', 'SpectralZombieM2')),true);
   AllAbilities.AddAbilityTemplate(X2AbilityTemplate(class'X2Ability_ChosenWarlock_WOTC'.static.CreateCorress('CorressM3', 'SpectralZombieM3')),true);
   AllAbilities.AddAbilityTemplate(X2AbilityTemplate(class'X2Ability_ChosenWarlock_WOTC'.static.CreateCorress('CorressM4', 'SpectralZombieM4')),true);
   
   CurrentAbility = AllAbilities.FindAbilityTemplate('SpectralStunLance');
	MeleeTarget = new class'X2AbilityTarget_Single';
	MeleeTarget.bAllowDestructibleObjects=true;
	MeleeTarget.OnlyIncludeTargetsInsideWeaponRange=true;
	CurrentAbility.AbilityTargetStyle = MeleeTarget;
	CurrentAbility.TargetingMethod = class'X2TargetingMethod_MeleePath';

   // TELEPORT ALLY SOURCE MUST BE VISIBLE TO WARLOCK
   CurrentAbility = AllAbilities.FindAbilityTemplate('TeleportAlly');
   // New visibility conditions Squadsight
   TargetVisibilityCondition = new class'X2Condition_Visibility';
   TargetVisibilityCondition.bRequireGameplayVisible = true;
   TargetVisibilityCondition.bAllowSquadsight = true; 
   CurrentAbility.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

   // CHOSEN SUMMON COSTS 1 AP, DOESNT END TURN
   CurrentAbility = AllAbilities.FindAbilityTemplate('ChosenSummonFollowers');
   APCost = new class'X2AbilityCost_ActionPoints';
   APCost.iNumPoints = 1;
   APCost.bConsumeAllPoints = false;
   CurrentAbility.AbilityCosts.AddItem(APCost);
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static function FixScamperChosen( name ChosenTemplateName ) {
   local X2DataTemplate					  DifficultyTemplate;
	local array<X2DataTemplate>		  DifficultyTemplates;
	local X2CharacterTemplateManager	  AllCharacters;
   local X2CharacterTemplate		     CurrentUnit;
         
   AllCharacters = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

   CurrentUnit = AllCharacters.FindCharacterTemplate(ChosenTemplateName);
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties(ChosenTemplateName, DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
               CurrentUnit.strScamperBT = "GenericScamperRoot";
   		   }
         }
	   } else {
         CurrentUnit.strScamperBT = "GenericScamperRoot";
         // Same as above but only for one difficulty
      }
   }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
static function FixScamperChosenVanish( name ChosenTemplateName ) {
   local X2DataTemplate					  DifficultyTemplate;
	local array<X2DataTemplate>		  DifficultyTemplates;
	local X2CharacterTemplateManager	  AllCharacters;
   local X2CharacterTemplate		     CurrentUnit;
         
   AllCharacters = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

   CurrentUnit = AllCharacters.FindCharacterTemplate(ChosenTemplateName);
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties(ChosenTemplateName, DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
               CurrentUnit.strScamperBT = "DoVanishingWindScamper";
   		   }
         }
	   } else {
         CurrentUnit.strScamperBT = "DoVanishingWindScamper";
         // Same as above but only for one difficulty
      }
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////
// AP Cost
///////////////////////////////////////////////////////////////////////////////////////////////
static function X2AbilityCost_ActionPoints CreateAPCost( int iNewAPCost, bool bNewConsumeAllPoints, optional bool bFreeCost ) {
	local X2AbilityCost_ActionPoints APCost;
	APCost = new class'X2AbilityCost_ActionPoints';

	if ( bFreeCost == true ) {
	   APCost.iNumPoints = iNewAPCost;
	   APCost.bConsumeAllPoints = bNewConsumeAllPoints;
	   APCost.bFreeCost = true;
	   return APCost;
	}

	if ( iNewAPCost < 0 )
	   iNewAPCost = 0;

	if ( iNewAPCost > 2 )
	   iNewAPCost = 2;

	if ( iNewAPCost == 0 ) {
		APCost.iNumPoints = 1;
		APCost.bFreeCost = true;
		APCost.bConsumeAllPoints = bNewConsumeAllPoints;
	} else {
		APCost.iNumPoints = iNewAPCost;
		APCost.bConsumeAllPoints = bNewConsumeAllPoints;
	}

	return APCost;
}

///////////////////////////////////////////////////////////////////////////////////////////////
// Create Cooldown
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

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
static function AddPerk( name nEnemyName, name nPerkName ) {
	local X2CharacterTemplateManager				AllCharacters;
	local X2CharacterTemplate					   CurrentUnit;
	local X2DataTemplate					         DifficultyTemplate;
	local array<X2DataTemplate>				   DifficultyTemplates;

   if ( nPerkName == '' ) {
      `RedScreen("Enemy Perk add called with no perk name.");
      return;
   }

   if ( nEnemyName == '' ) {
      `RedScreen("Enemy Perk add called with no unit name.");
      return;
   }

	AllCharacters = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	AllCharacters.FindDataTemplateAllDifficulties(nEnemyName, DifficultyTemplates);

   CurrentUnit = AllCharacters.FindCharacterTemplate(nEnemyName);

	if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		AllCharacters.FindDataTemplateAllDifficulties(nEnemyName, DifficultyTemplates);
		foreach DifficultyTemplates(DifficultyTemplate) {
			CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			if ( CurrentUnit != none ) {
            CurrentUnit.Abilities.RemoveItem(nPerkName); // Prevents duplication
            CurrentUnit.Abilities.AddItem(nPerkName);
   		}
      }
	} else {
      // Same as above but only for one difficulty
      CurrentUnit.Abilities.RemoveItem(nPerkName); // Prevents duplication
      CurrentUnit.Abilities.AddItem(nPerkName);
   }
}

///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////
static function RemovePerk( name nEnemyName, name nPerkName ) {
	local X2CharacterTemplateManager				AllCharacters;
	local X2CharacterTemplate					   CurrentUnit;
	local X2DataTemplate					         DifficultyTemplate;
	local array<X2DataTemplate>				   DifficultyTemplates;

   if ( nPerkName == '' ) {
      `RedScreen("Enemy Perk add called with no perk name.");
      return;
   }

   if ( nEnemyName == '' ) {
      `RedScreen("Enemy Perk add called with no unit name.");
      return;
   }

	AllCharacters = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
	AllCharacters.FindDataTemplateAllDifficulties(nEnemyName, DifficultyTemplates);

   CurrentUnit = AllCharacters.FindCharacterTemplate(nEnemyName);

	if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		AllCharacters.FindDataTemplateAllDifficulties(nEnemyName, DifficultyTemplates);
		foreach DifficultyTemplates(DifficultyTemplate) {
			CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			if ( CurrentUnit != none ) {
            CurrentUnit.Abilities.RemoveItem(nPerkName);
   		}
      }
	} else {
      // Same as above but only for one difficulty
      CurrentUnit.Abilities.RemoveItem(nPerkName);
   }
}


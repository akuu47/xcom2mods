class X2DownloadableContentInfo_ADVENTFutureCompleteAIPack extends X2DownloadableContentInfo config(ADVENTFutureConfig);

var config WeaponDamageValue ADVPURIFIER_FLAMETHROWER_BASEDAMAGE_MK2;
var config WeaponDamageValue ADVPURIFIER_FLAMETHROWER_BASEDAMAGE_MK3;

static event OnPostTemplatesCreated() {
   local X2AbilityTemplateManager	  AllAbilities;
   local X2AbilityTemplate            CurrentAbility;
   local X2ItemTemplateManager        AllItems;
   local X2WeaponTemplate             CurrentWeapon;
   local X2DataTemplate					  DifficultyTemplate;
	local array<X2DataTemplate>		  DifficultyTemplates;
	local X2CharacterTemplateManager	  AllCharacters;
   local X2CharacterTemplate		     CurrentUnit;
	local X2AbilityTarget_Single       MeleeTarget;
	local X2Effect_PersistentStatChange ShieldedEffect;
	local X2Condition_UnitProperty          TargetPropertyCondition;
	local X2Condition_Visibility            VisibilityCondition;
   local X2AbilityMultiTarget_Radius RadiusMultiTarget;
   local X2AbilityTarget_Self TargetStyle;
   local X2Condition TempCondition;	         
   local X2Condition_UnitProperty UnitCondition;
local X2Effect_PersistentStatChange				DisorientEffect;

   AllCharacters = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
   AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();
   AllItems     = class'X2ItemTemplateManager'.static.GetItemTemplateManager();  
   
   CurrentAbility = AllAbilities.FindAbilityTemplate('SectopodLightningField');
   ShieldedEffect = class'X2Ability_AdventShieldBearer'.static.CreateShieldedEffect("Lightning Field", "Shields the unit with a kinetic absorption field.", 10);
   CurrentAbility.AbilityConfirmSound = "TacticalUI_ActivateAbility";
   CurrentAbility.AddShooterEffect(ShieldedEffect);

   CurrentAbility = AllAbilities.FindAbilityTemplate(class'X2Ability_Sectopod'.default.WrathCannonStage1AbilityName);
   CurrentAbility.AbilityConfirmSound = "TacticalUI_ActivateAbility";

   // Zombie Melee move
   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('PsiZombie_MeleeAttack'));
   if ( CurrentWeapon != none ) {
	   if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) {
		   AllItems.FindDataTemplateAllDifficulties('PsiZombie_MeleeAttack', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			   if ( CurrentWeapon != none ) {
               CurrentWeapon.Abilities.RemoveItem('StandardMelee');
               CurrentWeapon.Abilities.AddItem('StandardMovingMelee');
               CurrentWeapon.iRange = 1;
     		   }
         }
	   } else {
         // Same as above but only for one difficulty
         CurrentWeapon.Abilities.RemoveItem('StandardMelee');
         CurrentWeapon.Abilities.AddItem('StandardMovingMelee');
         CurrentWeapon.iRange = 1;
      }
   }

   CurrentUnit = AllCharacters.FindCharacterTemplate('CivilianMilitia');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('CivilianMilitia', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
               CurrentUnit.strScamperBT = "ScamperRoot_Soldier";
   		   }
         }
	   } else {
         CurrentUnit.strScamperBT = "ScamperRoot_Soldier";
         // Same as above but only for one difficulty
      }
   }
   CurrentUnit = AllCharacters.FindCharacterTemplate('CivilianMilitiaM2');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('CivilianMilitiaM2', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
               CurrentUnit.strScamperBT = "ScamperRoot_Soldier";
   		   }
         }
	   } else {
         CurrentUnit.strScamperBT = "ScamperRoot_Soldier";
         // Same as above but only for one difficulty
      }
   }
   CurrentUnit = AllCharacters.FindCharacterTemplate('CivilianMilitiaM3');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('CivilianMilitiaM3', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
               CurrentUnit.strScamperBT = "ScamperRoot_Soldier";
   		   }
         }
	   } else {
         CurrentUnit.strScamperBT = "ScamperRoot_Soldier";
         // Same as above but only for one difficulty
      }
   }

   CurrentUnit = AllCharacters.FindCharacterTemplate('VolunteerArmyMilitia');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('VolunteerArmyMilitia', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
               CurrentUnit.strScamperBT = "ScamperRoot_Soldier";
   		   }
         }
	   } else {
         CurrentUnit.strScamperBT = "ScamperRoot_Soldier";
         // Same as above but only for one difficulty
      }
   }
   CurrentUnit = AllCharacters.FindCharacterTemplate('VolunteerArmyMilitiaM2');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('VolunteerArmyMilitiaM2', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
               CurrentUnit.strScamperBT = "ScamperRoot_Soldier";
   		   }
         }
	   } else {
         CurrentUnit.strScamperBT = "ScamperRoot_Soldier";
         // Same as above but only for one difficulty
      }
   }
   CurrentUnit = AllCharacters.FindCharacterTemplate('VolunteerArmyMilitiaM3');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('VolunteerArmyMilitiaM3', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
               CurrentUnit.strScamperBT = "ScamperRoot_Soldier";
   		   }
         }
	   } else {
         CurrentUnit.strScamperBT = "ScamperRoot_Soldier";
         // Same as above but only for one difficulty
      }
   }

   // ADVENT MEC : OVERWATCH ROOT
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvMEC_M1');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('AdvMEC_M1', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
               CurrentUnit.strScamperBT = "ScamperRoot_Overwatch";
   		   }
         }
	   } else {
         CurrentUnit.strScamperBT = "ScamperRoot_Overwatch";
         // Same as above but only for one difficulty
      }
   }
   // ADVENT MEC 2 : OVERWATCH ROOT
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvMEC_M2');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('AdvMEC_M2', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
               CurrentUnit.strScamperBT = "ScamperRoot_Overwatch";
   		   }
         }
	   } else {
         CurrentUnit.strScamperBT = "ScamperRoot_Overwatch";
         // Same as above but only for one difficulty
      }
   }

   // PROTOTYPE SECTOPOD CANNOT LIGHTNING FIELD
   // REMOVAL OF 3 AP IS DONE IN INIT ABILITY
   CurrentUnit = AllCharacters.FindCharacterTemplate('PrototypeSectopod');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('PrototypeSectopod', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
                  CurrentUnit.Abilities.RemoveItem('SectopodLightningField');
				  CurrentUnit.Abilities.RemoveItem('SectopodInitialState');
				  CurrentUnit.Abilities.RemoveItem('PrototypeSectopodInitialState');
				  CurrentUnit.Abilities.AddItem('PrototypeSectopodInitialState');
   		       }
            }
	   } else {
            CurrentUnit.Abilities.RemoveItem('SectopodLightningField');
			CurrentUnit.Abilities.RemoveItem('SectopodInitialState');
			CurrentUnit.Abilities.RemoveItem('PrototypeSectopodInitialState');
			CurrentUnit.Abilities.AddItem('PrototypeSectopodInitialState');
	        // Same as above but only for one difficulty
      }
   }

   ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // Cannot run and Stunlance in the same round.
   ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   CurrentAbility = AllAbilities.FindAbilityTemplate('StunLance');

   CurrentAbility.AbilityTargetConditions.Length = 0;
   TargetPropertyCondition = new class'X2Condition_UnitProperty';	
   TargetPropertyCondition.RequireWithinRange = true;
   TargetPropertyCondition.WithinRange = 144; // 1.5 tiles (96/tile)
   TargetPropertyCondition.ExcludeDead = true;
   TargetPropertyCondition.ExcludeFriendlyToSource = true;
   CurrentAbility.AbilityTargetConditions.AddItem(TargetPropertyCondition);

   VisibilityCondition = new class'X2Condition_Visibility';
   VisibilityCondition.bRequireGameplayVisible = true;
   CurrentAbility.AbilityTargetConditions.AddItem(VisibilityCondition);

   CurrentAbility.bSkipMoveStop = true;

   // FERAL MEC SELF DESTRUCT NOT 100% FREE
   CurrentAbility = AllAbilities.FindAbilityTemplate('EngageSelfDestruct');
   CurrentAbility.AbilityCosts.Length = 0;
   CurrentAbility.AbilityCosts.AddItem(CreateAPCost( 1, false, false )); 

   ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // PURIFIER IDEAL RANGE
   // Make the Purifier aggressive, move Ideal range to 4.
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('AdvPurifierFlamethrower'));
   if ( CurrentWeapon != none ) {
	   if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) {
		   AllItems.FindDataTemplateAllDifficulties('AdvPurifierFlamethrower', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			   if ( CurrentWeapon != none ) {
               CurrentWeapon.iIdealRange = 4;
     		   }
         }
	   } else {
         // Same as above but only for one difficulty
         CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('AdvPurifierFlamethrower'));
         CurrentWeapon.iIdealRange = 4;
      }
   }

   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('AdvPurifierFlamethrowerMK2'));
   if ( CurrentWeapon != none ) {
	   if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) {
		   AllItems.FindDataTemplateAllDifficulties('AdvPurifierFlamethrowerMK2', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			   if ( CurrentWeapon != none ) {
                  CurrentWeapon.BaseDamage = default.ADVPURIFIER_FLAMETHROWER_BASEDAMAGE_MK2;
     		   }
         }
	   } else {
         // Same as above but only for one difficulty
         CurrentWeapon.BaseDamage = default.ADVPURIFIER_FLAMETHROWER_BASEDAMAGE_MK2;
      }
   }

   CurrentWeapon = X2WeaponTemplate(AllItems.FindItemTemplate('AdvPurifierFlamethrowerMK3'));
   if ( CurrentWeapon != none ) {
	   if ( CurrentWeapon.bShouldCreateDifficultyVariants == true ) {
		   AllItems.FindDataTemplateAllDifficulties('AdvPurifierFlamethrowerMK2', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentWeapon = X2WeaponTemplate(DifficultyTemplate);
			   if ( CurrentWeapon != none ) {
                  CurrentWeapon.BaseDamage = default.ADVPURIFIER_FLAMETHROWER_BASEDAMAGE_MK3;
     		   }
         }
	   } else {
         // Same as above but only for one difficulty
         CurrentWeapon.BaseDamage = default.ADVPURIFIER_FLAMETHROWER_BASEDAMAGE_MK3;
      }
   }

   // ADVENT CAPTAIN AMMO OUT FIX, WHY DOES THIS COST AMMO?
   CurrentAbility = AllAbilities.FindAbilityTemplate('LightningHands');
   CurrentAbility.AbilityCosts.Length = 0;
   CurrentAbility.AbilityCosts.AddItem(CreateAPCost( 1, false, true ));

   // FAN FIRE AMMO FIX
   CurrentAbility = AllAbilities.FindAbilityTemplate('FanFire');
   CurrentAbility.AbilityCosts.Length = 0;
   CurrentAbility.AbilityCosts.AddItem(CreateAPCost( 1, true, false ));

   // VOLUNTEER ARMY LOADOUT FIX - SAME AS MILITIA, NOT ROOKIES
   CurrentUnit = AllCharacters.FindCharacterTemplate('VolunteerArmyMilitia');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('VolunteerArmyMilitia', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
                   CurrentUnit.DefaultLoadout = 'CivilianMilitiaLoadout';
   		       }
         }
	   } else {
         CurrentUnit.DefaultLoadout = 'CivilianMilitiaLoadout';
      }
   }
   CurrentUnit = AllCharacters.FindCharacterTemplate('VolunteerArmyMilitiaM2');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('VolunteerArmyMilitiaM2', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
                   CurrentUnit.DefaultLoadout = 'CivilianMilitiaLoadoutM2';
   		       }
         }
	   } else {
         CurrentUnit.DefaultLoadout = 'CivilianMilitiaLoadoutM2';
      }
   }
   CurrentUnit = AllCharacters.FindCharacterTemplate('VolunteerArmyMilitiaM3');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('VolunteerArmyMilitiaM3', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
                   CurrentUnit.DefaultLoadout = 'CivilianMilitiaLoadoutM3';
   		       }
         }
	   } else {
         CurrentUnit.DefaultLoadout = 'CivilianMilitiaLoadoutM3';
      }
   }

   // DARK EVENT LIGHTNING REFLEXES ADJUSTMENT
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvCaptainM1');
   CurrentUnit.Abilities.RemoveItem('DarkEventAbility_LightningReflexes');
   CurrentUnit.Abilities.AddItem('DarkEventAbility_LightningReflexes');
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvCaptainM2');
   CurrentUnit.Abilities.RemoveItem('DarkEventAbility_LightningReflexes');
   CurrentUnit.Abilities.AddItem('DarkEventAbility_LightningReflexes');
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvCaptainM3');
   CurrentUnit.Abilities.RemoveItem('DarkEventAbility_LightningReflexes');
   CurrentUnit.Abilities.AddItem('DarkEventAbility_LightningReflexes');

   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvGeneralM1');
   CurrentUnit.Abilities.RemoveItem('DarkEventAbility_LightningReflexes');
   CurrentUnit.Abilities.AddItem('DarkEventAbility_LightningReflexes');
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvGeneralM2');
   CurrentUnit.Abilities.RemoveItem('DarkEventAbility_LightningReflexes');
   CurrentUnit.Abilities.AddItem('DarkEventAbility_LightningReflexes');
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvGeneralM3');
   CurrentUnit.Abilities.RemoveItem('DarkEventAbility_LightningReflexes');
   CurrentUnit.Abilities.AddItem('DarkEventAbility_LightningReflexes');

   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvStunlancerM1');
   CurrentUnit.Abilities.RemoveItem('DarkEventAbility_LightningReflexes');
   CurrentUnit.Abilities.AddItem('DarkEventAbility_LightningReflexes');
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvStunlancerM2');
   CurrentUnit.Abilities.RemoveItem('DarkEventAbility_LightningReflexes');
   CurrentUnit.Abilities.AddItem('DarkEventAbility_LightningReflexes');
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvStunlancerM3');
   CurrentUnit.Abilities.RemoveItem('DarkEventAbility_LightningReflexes');
   CurrentUnit.Abilities.AddItem('DarkEventAbility_LightningReflexes');

   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvTrooperM1');
   CurrentUnit.Abilities.RemoveItem('DarkEventAbility_LightningReflexes');
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvTrooperM2');
   CurrentUnit.Abilities.RemoveItem('DarkEventAbility_LightningReflexes');
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvTrooperM3');
   CurrentUnit.Abilities.RemoveItem('DarkEventAbility_LightningReflexes');

   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvPurifierM1');
   CurrentUnit.Abilities.RemoveItem('AdventStilettoRounds');
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvPurifierM2');
   CurrentUnit.Abilities.RemoveItem('AdventStilettoRounds');
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvPurifierM3');
   CurrentUnit.Abilities.RemoveItem('AdventStilettoRounds');

   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   // GENERAL ADD MISSING DARK EVENTS
   /////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvGeneralM1');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('AdvGeneralM1', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
   	              CurrentUnit.Abilities.AddItem('AdventStilettoRounds');
   		       }
           }
	   } else {
         // Same as above but only for one difficulty
   	      CurrentUnit.Abilities.AddItem('AdventStilettoRounds');
      }
   }

   // GENERAL ADD MISSING DARK EVENTS
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvGeneralM2');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('AdvGeneralM2', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
   	              CurrentUnit.Abilities.AddItem('AdventStilettoRounds');
   		       }
           }
	   } else {
         // Same as above but only for one difficulty
   	      CurrentUnit.Abilities.AddItem('AdventStilettoRounds');
      }
   }

   // GENERAL ADD MISSING DARK EVENTS
   CurrentUnit = AllCharacters.FindCharacterTemplate('AdvGeneralM3');
   if ( CurrentUnit != none ) {
	   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
		   AllCharacters.FindDataTemplateAllDifficulties('AdvGeneralM3', DifficultyTemplates);
		   foreach DifficultyTemplates(DifficultyTemplate) {
			   CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
			   if ( CurrentUnit != none ) {
   	              CurrentUnit.Abilities.AddItem('AdventStilettoRounds');
   		       }
           }
	   } else {
         // Same as above but only for one difficulty
   	      CurrentUnit.Abilities.AddItem('AdventStilettoRounds');
      }
   }

   // Sectopod Lightning Field ignores cover.
   CurrentAbility = AllAbilities.FindAbilityTemplate('SectopodLightningField');
   TargetStyle = new class'X2AbilityTarget_Self';
   CurrentAbility.AbilityTargetStyle = TargetStyle;
   RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
   RadiusMultiTarget.fTargetRadius = class'X2Ability_Sectopod'.default.LIGHTNINGFIELD_TILE_RADIUS * class'XComWorldData'.const.WORLD_StepSize * class'XComWorldData'.const.WORLD_UNITS_TO_METERS_MULTIPLIER;
   RadiusMultiTarget.bIgnoreBlockingCover = true;
   RadiusMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
   CurrentAbility.AbilityMultiTargetStyle = RadiusMultiTarget;
   
   // Sectopod Lightning Field affects enemies, so if you Hack one it works against opponents. It also disorients.
   CurrentAbility = AllAbilities.FindAbilityTemplate('SectopodLightningField');
   CurrentAbility.AbilityConfirmSound = "TacticalUI_ActivateAbility";

   foreach CurrentAbility.AbilityMultiTargetConditions( TempCondition ) {
      if ( TempCondition != none ) {
	     if ( TempCondition.IsA( 'X2Condition_UnitProperty' )) {
		    UnitCondition = X2Condition_UnitProperty(TempCondition);
	        UnitCondition.ExcludeFriendlyToSource = false;
	        UnitCondition.ExcludeHostileToSource = false;
		 }
	  }
   }
   DisorientEffect = class'X2StatusEffects'.static.CreateDisorientedStatusEffect();
   CurrentAbility.AddMultiTargetEffect(DisorientEffect);

   RemoveEasyToHitAbility('Civilian');
   RemoveEasyToHitAbility('HostileCivilian');
   RemoveEasyToHitAbility('Soldier_VIP');
   RemoveEasyToHitAbility('Scientist_VIP');
   RemoveEasyToHitAbility('Engineer_VIP');
   RemoveEasyToHitAbility('FriendlyVIPCivilian');

   RemoveEasyToHitAbility('CivilianMilitia');
   RemoveEasyToHitAbility('CivilianMilitiaM2');
   RemoveEasyToHitAbility('CivilianMilitiaM3');
   RemoveEasyToHitAbility('VolunteerMilitia');
   RemoveEasyToHitAbility('VolunteerMilitiaM2');
   RemoveEasyToHitAbility('VolunteerMilitiaM3');
}

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

static function bool RemoveEasyToHitAbility( name nTemplateName ) {
   local X2CharacterTemplateManager	          AllCharacters;
   local X2CharacterTemplate		          CurrentUnit;
   local X2DataTemplate					      DifficultyTemplate;
   local array<X2DataTemplate>		          DifficultyTemplates; 

   AllCharacters    = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();
  
   if ( nTemplateName == '' )
      return false;

   CurrentUnit = AllCharacters.FindCharacterTemplate(nTemplateName);

   if ( CurrentUnit == none )
      return false;

   if ( CurrentUnit.bShouldCreateDifficultyVariants == true ) {
      AllCharacters.FindDataTemplateAllDifficulties(nTemplateName, DifficultyTemplates);
      foreach DifficultyTemplates(DifficultyTemplate) {
         CurrentUnit = X2CharacterTemplate(DifficultyTemplate);
         CurrentUnit.Abilities.RemoveItem('CivilianEasyToHit');
      }
   } else {
      // Same as above but only for one difficulty
      CurrentUnit.Abilities.RemoveItem('CivilianEasyToHit');
   }

   return true;
}
class X2DownloadableContentInfo_SectopodStanceBonusesWOTC extends X2DownloadableContentInfo config(SectopodStanceConfig);

var config bool LIGHTNING_FIELD_NO_LONGER_ENDS_TURN;
var config int  WRATH_TILE_WIDTH_EXTENSION;
var config int  WRATH_FIXED_ABILITY_RANGE;

var config bool NEW_WRATH_TARGETING;
var config int  WRATH_CONE_END_DIAMETER;
var config int  WRATH_CONE_LENGTH;

var config bool WRATH_CANNON_ALLOW_CANNON_CUSTOMIZATION;

static event OnPostTemplatesCreated() {
   local X2AbilityTemplateManager              AllAbilities;
   local X2AbilityTemplate                     CurrentAbility;
   local X2Effect_PersistentStatChange         LowStanceEffect;
   local X2AbilityCost_ActionPoints            APCost;

   local X2AbilityMultiTarget_Line LineMultiTarget;
   local X2AbilityMultiTarget_Cone ConeMultiTarget;
   local X2AbilityTarget_Cursor CursorTarget;

   AllAbilities = class'X2AbilityTemplateManager'.static.GetAbilityTemplateManager();

   if ( default.WRATH_CANNON_ALLOW_CANNON_CUSTOMIZATION == true ) {
      // PATCH WRATH RANGE
      if ( default.NEW_WRATH_TARGETING == false ) {
         // STAGE 1 - LINE
         CurrentAbility = AllAbilities.FindAbilityTemplate('WrathCannonStage1');

         CurrentAbility.TargetingMethod = class'X2TargetingMethod_Line'; 
	      CursorTarget = new class'X2AbilityTarget_Cursor';
	      CursorTarget.FixedAbilityRange = default.WRATH_FIXED_ABILITY_RANGE;
	      CurrentAbility.AbilityTargetStyle = CursorTarget;
         LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	      LineMultiTarget.TileWidthExtension = default.WRATH_TILE_WIDTH_EXTENSION;
	      CurrentAbility.AbilityMultiTargetStyle = LineMultiTarget;

         // STAGE 2 - LINE
	      CursorTarget = new class'X2AbilityTarget_Cursor';
	      CursorTarget.FixedAbilityRange = default.WRATH_FIXED_ABILITY_RANGE;
	      CurrentAbility.AbilityTargetStyle = CursorTarget;
         CurrentAbility = AllAbilities.FindAbilityTemplate('WrathCannonStage2');
         LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	      LineMultiTarget.TileWidthExtension = default.WRATH_TILE_WIDTH_EXTENSION;
	      CurrentAbility.AbilityMultiTargetStyle = LineMultiTarget;
      } else {
         // STAGE 1 - CONE
         CurrentAbility = AllAbilities.FindAbilityTemplate('WrathCannonStage1');

         CurrentAbility.TargetingMethod = class'X2TargetingMethod_Cone';
	      CursorTarget = new class'X2AbilityTarget_Cursor';
	      CursorTarget.FixedAbilityRange = default.WRATH_CONE_LENGTH;
   	   CurrentAbility.AbilityTargetStyle = CursorTarget;
         ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
         ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	      ConeMultiTarget.ConeEndDiameter = default.WRATH_CONE_END_DIAMETER * class'XComWorldData'.const.WORLD_StepSize;
	      ConeMultiTarget.ConeLength = default.WRATH_CONE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	      CurrentAbility.AbilityMultiTargetStyle = ConeMultiTarget;

         // STAGE 2 - CONE
         CurrentAbility = AllAbilities.FindAbilityTemplate('WrathCannonStage2');
	      CursorTarget = new class'X2AbilityTarget_Cursor';
	      CursorTarget.FixedAbilityRange = default.WRATH_CONE_LENGTH;
   	   CurrentAbility.AbilityTargetStyle = CursorTarget;
         ConeMultiTarget = new class'X2AbilityMultiTarget_Cone';
         ConeMultiTarget.bExcludeSelfAsTargetIfWithinRadius = true;
	      ConeMultiTarget.ConeEndDiameter = default.WRATH_CONE_END_DIAMETER * class'XComWorldData'.const.WORLD_StepSize;
	      ConeMultiTarget.ConeLength = default.WRATH_CONE_LENGTH * class'XComWorldData'.const.WORLD_StepSize;
	      CurrentAbility.AbilityMultiTargetStyle = ConeMultiTarget;
      }
   }

   // WE NEED TO INJECT A LOW EFFECT IN SECTOPOD INITIAL STATE
   CurrentAbility = AllAbilities.FindAbilityTemplate('SectopodInitialState');

   LowStanceEffect = new class'X2Effect_PersistentStatChange';
   LowStanceEffect.EffectName = 'SectopodLowStance';
   LowStanceEffect.DuplicateResponse = eDupe_Ignore;
   LowStanceEffect.SetDisplayInfo(ePerkBuff_Bonus, "Low Stance", "Sectopod is crouching. Defense bonus, Mobility penalty.", "img:///UILibrary_PerkIcons.UIPerk_sectopod_lowstance");
	if ( class'X2Ability_Sectopod_StanceEffects'.default.LOW_STANCE_DEFENSE_ADJUSTMENT != 0 ) {
      LowStanceEffect.AddPersistentStatChange(eStat_Defense, class'X2Ability_Sectopod_StanceEffects'.default.LOW_STANCE_DEFENSE_ADJUSTMENT); // Bonus
   }
   if ( class'X2Ability_Sectopod_StanceEffects'.default.LOW_STANCE_MOBILITY_ADJUSTMENT != 0 ) {
	   LowStanceEffect.AddPersistentStatChange(eStat_Mobility, class'X2Ability_Sectopod_StanceEffects'.default.LOW_STANCE_MOBILITY_ADJUSTMENT); // Bonus
   }
   LowStanceEffect.BuildPersistentEffect( 1, true, false );

   CurrentAbility.AddTargetEffect( LowStanceEffect );
   
   CurrentAbility = AllAbilities.FindAbilityTemplate('PrototypeSectopodInitialState');
   CurrentAbility.AddTargetEffect( LowStanceEffect );

   // REBUILD SECTOPOD HIGH/LOW
   CurrentAbility = class'X2Ability_Sectopod_StanceEffects'.static.CreateSectopodHighAbility();
   AllAbilities.AddAbilityTemplate(CurrentAbility, true); // Overwrite the base template.
   CurrentAbility = class'X2Ability_Sectopod_StanceEffects'.static.CreateSectopodLowAbility();
   AllAbilities.AddAbilityTemplate(CurrentAbility, true); // Overwrite the base template.
}

// AP Cost
///////////////////////////////////////////////////////////////////////////////////////////////
static function X2AbilityCost_ActionPoints SSB_CreateAPCost( int iNewAPCost, bool bNewConsumeAllPoints, optional bool bFreeCost ) {
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
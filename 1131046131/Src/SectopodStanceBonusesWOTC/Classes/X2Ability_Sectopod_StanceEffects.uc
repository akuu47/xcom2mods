class X2Ability_Sectopod_StanceEffects extends X2Ability_Sectopod config(SectopodStanceConfig);

var config bool STANCE_SWITCH_FREE_ACTION;

var config int  HIGH_STANCE_AIM_ADJUSTMENT;
var config int  HIGH_STANCE_MOBILITY_ADJUSTMENT;

var config int  LOW_STANCE_DEFENSE_ADJUSTMENT;
var config int  LOW_STANCE_MOBILITY_ADJUSTMENT;

static function X2AbilityTemplate CreateSectopodHighAbility()
{
	local X2AbilityTemplate                Template;
	local X2AbilityCost_ActionPoints       ActionPointCost;
	local X2AbilityTrigger_PlayerInput     InputTrigger;
	local X2Effect_SetUnitValue				SetHighValue;
	local X2Condition_UnitValue				IsLow;
	local X2Condition_UnitValue				IsNotImmobilized;
	local X2Effect_RemoveEffects			   RemoveEffect;
	local X2Effect_PersistentStatChange    HighStanceEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SectopodHigh');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectopod_heightchange"; // TODO: This needs to be changed
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Neutral;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
   if ( default.STANCE_SWITCH_FREE_ACTION == true ) {
      ActionPointCost.bFreeCost = true;
   }
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	// Set up conditions for Low check.
	IsLow = new class'X2Condition_UnitValue';
	IsLow.AddCheckValue(default.HighLowValueName, SECTOPOD_LOW_VALUE, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsLow);

	IsNotImmobilized = new class'X2Condition_UnitValue';
	IsNotImmobilized.AddCheckValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 0);
	Template.AbilityShooterConditions.AddItem(IsNotImmobilized);

	Template.AbilityShooterConditions.AddItem( default.LivingShooterProperty );

	// ------------
	// High effect.  
	// Set value to High.
	SetHighValue = new class'X2Effect_SetUnitValue';
	SetHighValue.UnitName = default.HighLowValueName;
	SetHighValue.NewValueToSet = SECTOPOD_HIGH_VALUE;
	SetHighValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetHighValue);

   // SWITCH EFFECTS
	HighStanceEffect = new class'X2Effect_PersistentStatChange';
	HighStanceEffect.EffectName = 'SectopodHighStance';
	HighStanceEffect.DuplicateResponse = eDupe_Ignore;
   HighStanceEffect.SetDisplayInfo(ePerkBuff_Bonus, "High Stance", "Sectopod is standing. Aim bonus, height advantage and better Wrath Cannon positioning.", "img:///UILibrary_PerkIcons.UIPerk_sectopod_heightchange");
   if ( default.HIGH_STANCE_AIM_ADJUSTMENT != 0 ) {
	   HighStanceEffect.AddPersistentStatChange(eStat_Offense, default.HIGH_STANCE_AIM_ADJUSTMENT);
   }
   if ( default.HIGH_STANCE_MOBILITY_ADJUSTMENT != 0 ) {
	   HighStanceEffect.AddPersistentStatChange(eStat_Mobility, default.HIGH_STANCE_MOBILITY_ADJUSTMENT);
   }
	HighStanceEffect.BuildPersistentEffect( 1, true, false );
	HighStanceEffect.EffectAddedFn = StandUpEffectAdded;
	HighStanceEffect.EffectRemovedFn = StandUpEffectRemoved;

	Template.AddTargetEffect( HighStanceEffect );

   RemoveEffect = new class'X2Effect_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem( 'SectopodLowStance' );
	Template.AddTargetEffect( RemoveEffect );

	Template.BuildNewGameStateFn = SectopodHigh_BuildGameState;
	Template.BuildVisualizationFn = SectopodHighLow_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.CinescriptCameraType = "Sectopod_HighStance";

	return Template;
}

static function X2AbilityTemplate CreateSectopodLowAbility()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityTrigger_PlayerInput      InputTrigger;
	local X2Effect_SetUnitValue			 	 SetLowValue;
	local X2Condition_UnitValue				 IsHigh;
	local X2Condition_UnitValue				 IsNotImmobilized;
	local X2Effect_RemoveEffects			    RemoveEffect;
	local X2Effect_PersistentStatChange     LowStanceEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SectopodLow');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_sectopod_lowstance";
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.Hostility = eHostility_Neutral;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
   if ( default.STANCE_SWITCH_FREE_ACTION == true ) {
      ActionPointCost.bFreeCost = true;
   }
	Template.AbilityCosts.AddItem(ActionPointCost);

 	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;

	InputTrigger = new class'X2AbilityTrigger_PlayerInput';
	Template.AbilityTriggers.AddItem(InputTrigger);

	// Set up conditions for High check.
	IsHigh = new class'X2Condition_UnitValue';
	IsHigh.AddCheckValue(default.HighLowValueName, SECTOPOD_HIGH_VALUE, eCheck_Exact);
	Template.AbilityShooterConditions.AddItem(IsHigh);

	IsNotImmobilized = new class'X2Condition_UnitValue';
	IsNotImmobilized.AddCheckValue(class'X2Ability_DefaultAbilitySet'.default.ImmobilizedValueName, 0);
	Template.AbilityShooterConditions.AddItem(IsNotImmobilized);

	Template.AbilityShooterConditions.AddItem( default.LivingShooterProperty );

	// ------------
	// Low effects.  
	// Set value to Low.
	SetLowValue = new class'X2Effect_SetUnitValue';
	SetLowValue.UnitName = default.HighLowValueName;
	SetLowValue.NewValueToSet = SECTOPOD_LOW_VALUE;
	SetLowValue.CleanupType = eCleanup_BeginTactical;
	Template.AddTargetEffect(SetLowValue);

   // SWITCH EFFECTS
 	LowStanceEffect = new class'X2Effect_PersistentStatChange';
	LowStanceEffect.EffectName = 'SectopodLowStance';
	LowStanceEffect.DuplicateResponse = eDupe_Ignore;
   LowStanceEffect.SetDisplayInfo(ePerkBuff_Bonus, "Low Stance", "Sectopod is crouching. Defense bonus, Mobility penalty.", "img:///UILibrary_PerkIcons.UIPerk_sectopod_lowstance");
	if ( default.LOW_STANCE_DEFENSE_ADJUSTMENT != 0 ) {
      LowStanceEffect.AddPersistentStatChange(eStat_Defense, default.LOW_STANCE_DEFENSE_ADJUSTMENT); // Bonus
   }
   if ( default.LOW_STANCE_MOBILITY_ADJUSTMENT != 0 ) {
	   LowStanceEffect.AddPersistentStatChange(eStat_Mobility, default.LOW_STANCE_MOBILITY_ADJUSTMENT); // Penalty
   }
	LowStanceEffect.BuildPersistentEffect( 1, true, false );

	Template.AddTargetEffect( LowStanceEffect );

	RemoveEffect = new class'X2Effect_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem( 'SectopodHighStance' );
	Template.AddTargetEffect( RemoveEffect );

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = SectopodHighLow_BuildVisualization;
	Template.bSkipFireAction = true;
	
	return Template;
}
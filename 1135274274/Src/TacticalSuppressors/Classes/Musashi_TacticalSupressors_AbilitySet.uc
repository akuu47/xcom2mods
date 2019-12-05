class Musashi_TacticalSupressors_AbilitySet extends X2Ability_DefaultAbilitySet config(TacticalSuppressors);

var name AmbushActionPoint;
var name AmbushEffectName;
var name AmbushedTargetEffectName;
var name AmbushShotAbilityName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(Ambush());
	Templates.AddItem(AmbushShot());
	
	return Templates;
}

//---------------------------------------------------------------------------------------------------
// Ambush
//---------------------------------------------------------------------------------------------------
static function X2AbilityTemplate Ambush()
{
	local X2AbilityTemplate					Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ReserveActionPoints      ReserveActionPointsEffect;
	local array<name>                       SkipExclusions;
	local X2Condition_Visibility            VisibilityCondition;
	local X2Effect_CoveringFire             CoveringFireEffect;
	local X2Effect_ModifyReactionFire		ModifyReactionFireEffect;
	local X2Condition_UnitProperty          ConcealedCondition;
	local X2Effect_SetUnitValue             UnitValueEffect;
	local X2Effect_Persistent				CoverTargetEffect;
	local X2Condition_UnitEffects           SuppressedCondition;
	local Musashi_ConditionConcealed		ShooterConcealedCondition;
	local Musashi_ConditionInvSlot			InventorySlotPrimaryCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MusashiAmbushSilencer');
	
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_CannotAfford_ActionPoints');
	Template.HideErrors.AddItem('AA_NoTargets');
	Template.IconImage = "img:///TacticalSuppressorsMod.UIPerk_ambush";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";
	Template.Hostility = eHostility_Neutral;

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;                  //  ammo is consumed by the shot, not by this, but this should verify ammo is available
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityShooterConditions.AddItem(new class'Musashi_ConditionSniper');

	ShooterConcealedCondition = new class'Musashi_ConditionConcealed';
	Template.AbilityShooterConditions.AddItem(ShooterConcealedCondition);


	InventorySlotPrimaryCondition = new class'Musashi_ConditionInvSlot';
	Template.AbilityShooterConditions.AddItem(InventorySlotPrimaryCondition);
	
	VisibilityCondition = new class'X2Condition_Visibility';
	VisibilityCondition.bRequireGameplayVisible = true;
	VisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(VisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	ReserveActionPointsEffect = new class'X2Effect_ReserveActionPoints';
	ReserveActionPointsEffect.ReserveType = default.AmbushActionPoint;
	Template.AddShooterEffect(ReserveActionPointsEffect);

	// Activates the shot if the target attacks
	CoveringFireEffect = new class'X2Effect_CoveringFire';
	CoveringFireEffect.AbilityToActivate = default.AmbushShotAbilityName;
	CoveringFireEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	Template.AddShooterEffect(CoveringFireEffect);

	// Allows crit on the shot
	ModifyReactionFireEffect = new class'X2Effect_ModifyReactionFire';
	ModifyReactionFireEffect.EffectName = default.AmbushEffectName;
	ModifyReactionFireEffect.bAllowCrit = true;
	Template.AddShooterEffect(ModifyReactionFireEffect);

	// Removes reaction fire penalties if we fire from concealment
	ConcealedCondition = new class'X2Condition_UnitProperty';
	ConcealedCondition.ExcludeFriendlyToSource = false;
	ConcealedCondition.IsConcealed = true;
	UnitValueEffect = new class'X2Effect_SetUnitValue';
	UnitValueEffect.UnitName = class'X2Ability_DefaultAbilitySet'.default.ConcealedOverwatchTurn;
	UnitValueEffect.CleanupType = eCleanup_BeginTurn;
	UnitValueEffect.NewValueToSet = 1;
	UnitValueEffect.TargetConditions.AddItem(ConcealedCondition);
	Template.AddShooterEffect(UnitValueEffect);

	// Allows the shot at the target
	CoverTargetEffect = new class'X2Effect_Persistent';
	CoverTargetEffect.EffectName = default.AmbushedTargetEffectName;
	CoverTargetEffect.BuildPersistentEffect(1, false,,, eGameRule_PlayerTurnBegin);
	CoverTargetEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,,Template.AbilitySourceName);
	CoverTargetEffect.bUseSourcePlayerState = true;
	Template.AddTargetEffect(CoverTargetEffect);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);


	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_DefaultAbilitySet'.static.OverwatchAbility_BuildVisualization;
	Template.CinescriptCameraType = "Overwatch";

	Template.AdditionalAbilities.AddItem(default.AmbushShotAbilityName);
	
	Template.bCrossClassEligible = true;
	
	return Template;	
}

static function X2AbilityTemplate AmbushShot()
{
	local X2AbilityTemplate							Template;	
	local X2AbilityCost_Ammo						AmmoCost;
	local X2AbilityCost_ReserveActionPoints			ReserveActionPointCost;
	local X2AbilityToHitCalc_StandardAim			StandardAim;
	local X2AbilityTarget_Single					SingleTarget;
	local X2AbilityTrigger_Event					Trigger;
	local array<name>								SkipExclusions;
	local X2Condition_Visibility					TargetVisibilityCondition;
	local X2Condition_UnitEffectsWithAbilitySource	RequiredEffects;
	local X2Effect_RemoveEffects					RemoveEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, default.AmbushShotAbilityName);

	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = 1;	
	Template.AbilityCosts.AddItem(AmmoCost);
	
	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.AllowedTypes.AddItem(default.AmbushActionPoint);
	Template.AbilityCosts.AddItem(ReserveActionPointCost);
	
	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bReactionFire = true;
	Template.AbilityToHitCalc = StandardAim;
	Template.AbilityToHitOwnerOnMissCalc = StandardAim;

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(new class'X2Condition_EverVigilant');
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());
	Template.Hostility = eHostility_Offensive;

	RequiredEffects = new class'X2Condition_UnitEffectsWithAbilitySource';
	RequiredEffects.AddRequireEffect(default.AmbushedTargetEffectName, 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(RequiredEffects);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	

	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName);
	Template.AddShooterEffectExclusions(SkipExclusions);
	Template.bAllowAmmoEffects = true;
	
	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityTargetStyle = SingleTarget;

	// Trigger on movement - interrupt the move
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary.UIPerk_unknown";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.OVERWATCH_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.DisplayTargetHitChance = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bAllowFreeFireWeaponUpgrade = false;

	// Remove the Cover Target effect on the shooter (which allows the crit)
	RemoveEffect = new class'X2Effect_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem(default.AmbushEffectName);
	Template.AddShooterEffect(RemoveEffect);

	// Remove the Cover Target effect on the target (which allows the shot)
	RemoveEffect = new class'X2Effect_RemoveEffects';
	RemoveEffect.EffectNamesToRemove.AddItem(default.AmbushedTargetEffectName);
	Template.AddTargetEffect(RemoveEffect);

	//  Put holo target effect first because if the target dies from this shot, it will be too late to notify the effect.
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	// Damage Effect
	//
	Template.AddTargetEffect(default.WeaponUpgradeMissDamage);
	
	return Template;	
}

DefaultProperties
{
	AmbushActionPoint="MusashiAmbushSilencerAP"
	AmbushEffectName="MusashiAmbushSilencer"
	AmbushedTargetEffectName="MusashiAmbushedTargetSilencer"
	AmbushShotAbilityName="MusashiAmbushTargetShotSilencer"
}
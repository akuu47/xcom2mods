class X2Ability_SparkAbilitySet_MWBE extends X2Ability
	dependson(XComGameStateContext_Ability) config(BeagleEdition);
	
var config int REPAIRKIT_HEAL;
var config int REPAIRKIT_COOLDOWN;
var config int REPAIRKIT_ACTIONPOINTS;
var config bool REPAIRKIT_TURNENDING;
var config bool REPAIRKIT_REGENARMOR;

var config int NANOREPAIRKIT_HEAL;
var config int NANOREPAIRKIT_COOLDOWN;
var config int NANOREPAIRKIT_ACTIONPOINTS;
var config bool NANOREPAIRKIT_TURNENDING;
var config bool NANOREPAIRKIT_REGENARMOR;

var config int KS_COOLDOWN;
var config int KS_ACTIONPOINTS;
var config bool KS_TURNENDING;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(RepairKit_T1());
	Templates.AddItem(RepairKit_T2());
	Templates.AddItem(KineticStrike_Beagle());
	Templates.AddItem(BrawlerProtocol_Beagle());
	Templates.AddItem(BrawlerTrigger_Beagle());

	return Templates;
}

static function X2AbilityTemplate RepairKit_T1()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_Ammo					AmmoCost;
	local X2AbilityCost_ActionPoints            ActionPointCost;
	local X2AbilityCooldown						Cooldown;
	local X2Effect_ApplyRepairHeal				HealEffect;
	local X2Effect_RepairArmor					ArmorEffect;
	local X2Condition_UnitProperty              UnitCondition;
	local X2Effect_RemoveEffectsByDamageType	RemoveEffects;
	local X2AbilityTarget_Single				SingleTarget;
	local X2AbilityPassiveAOE_SelfRadius		PassiveAOEStyle;
	local name HealType;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RepairKit_T1');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_repair";
	
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.bReturnChargesError = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.REPAIRKIT_ACTIONPOINTS;
	ActionPointCost.bConsumeAllPoints = default.REPAIRKIT_TURNENDING;

	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.REPAIRKIT_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	HealEffect = new class'X2Effect_ApplyRepairHeal';
	HealEffect.PerUseHP = default.REPAIRKIT_HEAL;
	Template.AddTargetEffect(HealEffect);

	if(default.REPAIRKIT_REGENARMOR)
	{
		ArmorEffect = new class'X2Effect_RepairArmor';
		Template.AddTargetEffect(ArmorEffect);
	}

	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
	foreach class'X2Ability_DefaultAbilitySet'.default.MedikitHealEffectTypes(HealType)
	{
		RemoveEffects.DamageTypesToRemove.AddItem(HealType);
	}
	Template.AddTargetEffect(RemoveEffects);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeHostileToSource = true;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeFullHealth = true;
	UnitCondition.ExcludeOrganic = true;
	Template.AbilityTargetConditions.AddItem(UnitCondition);
	
	Template.AbilityToHitCalc = default.DeadEye;

	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	SingleTarget.bIncludeSelf = true;
	SingleTarget.bShowAOE = true;
	Template.AbilityTargetStyle = SingleTarget;

	PassiveAOEStyle = new class'X2AbilityPassiveAOE_SelfRadius';
	PassiveAOEStyle.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityPassiveAOEStyle = PassiveAOEStyle;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.MEDIKIT_HEAL_PRIORITY;
	Template.bUseAmmoAsChargesForHUD = true;
	Template.Hostility = eHostility_Defensive;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.ActivationSpeech = 'HealingAlly';

	Template.CustomSelfFireAnim = 'FF_FireMedkitSelf';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate RepairKit_T2()
{
	local X2AbilityTemplate						Template;
	local X2AbilityCost_Ammo					AmmoCost;
	local X2AbilityCost_ActionPoints            ActionPointCost;
	local X2AbilityCooldown						Cooldown;
	local X2Effect_ApplyRepairHeal				HealEffect;
	local X2Effect_RepairArmor					ArmorEffect;
	local X2Condition_UnitProperty              UnitCondition;
	local X2Effect_RemoveEffectsByDamageType	RemoveEffects;
	local X2AbilityTarget_Single				SingleTarget;
	local X2AbilityPassiveAOE_SelfRadius		PassiveAOEStyle;
	local name HealType;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'RepairKit_T2');
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer);

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_repair";
	
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.bReturnChargesError = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.NANOREPAIRKIT_ACTIONPOINTS;
	ActionPointCost.bConsumeAllPoints = default.NANOREPAIRKIT_TURNENDING;

	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.NANOREPAIRKIT_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	HealEffect = new class'X2Effect_ApplyRepairHeal';
	HealEffect.PerUseHP = default.NANOREPAIRKIT_HEAL;
	Template.AddTargetEffect(HealEffect);
	
	if(default.NANOREPAIRKIT_REGENARMOR)
	{
		ArmorEffect = new class'X2Effect_RepairArmor';
		Template.AddTargetEffect(ArmorEffect);
	}

	RemoveEffects = new class'X2Effect_RemoveEffectsByDamageType';
	foreach class'X2Ability_DefaultAbilitySet'.default.MedikitHealEffectTypes(HealType)
	{
		RemoveEffects.DamageTypesToRemove.AddItem(HealType);
	}
	Template.AddTargetEffect(RemoveEffects);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	UnitCondition = new class'X2Condition_UnitProperty';
	UnitCondition.ExcludeDead = true;
	UnitCondition.ExcludeHostileToSource = true;
	UnitCondition.ExcludeFriendlyToSource = false;
	UnitCondition.ExcludeFullHealth = true;
	UnitCondition.ExcludeOrganic = true;
	Template.AbilityTargetConditions.AddItem(UnitCondition);
	
	Template.AbilityToHitCalc = default.DeadEye;

	SingleTarget = new class'X2AbilityTarget_Single';
	SingleTarget.OnlyIncludeTargetsInsideWeaponRange = true;
	SingleTarget.bIncludeSelf = true;
	SingleTarget.bShowAOE = true;
	Template.AbilityTargetStyle = SingleTarget;

	PassiveAOEStyle = new class'X2AbilityPassiveAOE_SelfRadius';
	PassiveAOEStyle.OnlyIncludeTargetsInsideWeaponRange = true;
	Template.AbilityPassiveAOEStyle = PassiveAOEStyle;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.MEDIKIT_HEAL_PRIORITY;
	Template.bUseAmmoAsChargesForHUD = true;
	Template.Hostility = eHostility_Defensive;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;
	Template.ActivationSpeech = 'HealingAlly';

	Template.CustomSelfFireAnim = 'FF_FireMedkitSelf';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate KineticStrike_Beagle()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
	local X2Effect_DLC_3StrikeDamage		WeaponDamageEffect;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_Knockback				KnockbackEffect;
	local X2AbilityMultiTarget_Cone			RadiusMultiTarget;
	local X2Condition_UnitProperty			HostileCondition;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'KineticStrike_Beagle');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;		
	Template.IconImage = "img:///UILibrary_DLC3Images.UIPerk_spark_strike";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.ARMOR_ACTIVE_PRIORITY + 1;
	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
	Template.MeleePuckMeshPath = "Materials_DLC3.MovePuck_Strike";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.KS_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';	
	ActionPointCost.iNumPoints = default.KS_ACTIONPOINTS;
	ActionPointCost.bConsumeAllPoints = default.KS_TURNENDING;
	Template.AbilityCosts.AddItem(ActionPointCost);

	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
	Template.AbilityToHitCalc = StandardMelee;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_Cursor';
	Template.TargetingMethod = class'X2TargetingMethod_Cone';

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// Shooter Conditions
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_DLC_3StrikeDamage';
	WeaponDamageEffect.EnvironmentalDamageAmount = 20;
	WeaponDamageEffect.TargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	Template.bAllowBonusWeaponEffects = true;
	Template.CustomFireAnim = 'FF_Melee';

	KnockbackEffect = new class'X2Effect_Knockback';
	KnockbackEffect.KnockbackDistance = 8;
	KnockbackEffect.DefaultDamage = 20;
	KnockbackEffect.bKnockbackDestroysNonFragile = true;
	HostileCondition = new class'X2Condition_UnitProperty';
	HostileCondition.ExcludeAlive=false;
	HostileCondition.ExcludeDead=false;
	HostileCondition.ExcludeFriendlyToSource=true;
	HostileCondition.ExcludeHostileToSource=false;
	HostileCondition.TreatMindControlledSquadmateAsHostile=true;
	KnockbackEffect.TargetConditions.AddItem(HostileCondition);
	Template.AddMultiTargetEffect(KnockbackEffect);
	Template.bOverrideMeleeDeath = true;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Cone';
	RadiusMultiTarget.ConeLength = class'XComWorldData'.const.WORLD_StepSize;
	RadiusMultiTarget.ConeEndDiameter = class'XComWorldData'.const.WORLD_StepSize;
	RadiusMultiTarget.bUseWeaponRangeForLength = false;
	RadiusMultiTarget.bUseWeaponRadius = false;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	// Voice events
	Template.SourceMissSpeech = 'SwordMiss';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "Spark_Strike";

	return Template;
}

static function X2AbilityTemplate BrawlerProtocol_Beagle()
{
	local X2AbilityTemplate                 Template;

	Template = PurePassive('BrawlerProtocol_Beagle', "img:///UILibrary_MW.UIPerk_counterstrike", false, 'eAbilitySource_Perk');
	Template.AdditionalAbilities.AddItem('BrawlerTrigger_Beagle');

	return Template;
}

static function X2AbilityTemplate BrawlerTrigger_Beagle()
{
	local X2AbilityTemplate							Template;
	local X2AbilityToHitCalc_StandardMelee			ToHitCalc;
	local X2AbilityTrigger_Event					Trigger;
	local X2Effect_Persistent						BrawlerTargetEffect;
	local X2Condition_UnitEffectsWithAbilitySource	BrawlerTargetCondition;
	local X2AbilityTrigger_EventListener			EventListener;
	local X2Condition_UnitProperty					SourceNotConcealedCondition;
	local X2Condition_Visibility					TargetVisibilityCondition;
	local X2Effect_DLC_3StrikeDamage				DamageEffect;
	local X2Condition_PunchRange					RangeCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'BrawlerTrigger_Beagle');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_MW.UIPerk_counterstrike";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardMelee';
	ToHitCalc.bReactionFire = true;
	ToHitCalc.BuiltInHitMod = 10;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityTargetStyle = default.SimpleSingleMeleeTarget;

	// trigger on movement
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	// trigger on movement in the postbuild
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_MovementObserver';
	Trigger.MethodName = 'PostBuildGameState';
	Template.AbilityTriggers.AddItem(Trigger);
	// trigger on an attack
	Trigger = new class'X2AbilityTrigger_Event';
	Trigger.EventObserverClass = class'X2TacticalGameRuleset_AttackObserver';
	Trigger.MethodName = 'InterruptGameState';
	Template.AbilityTriggers.AddItem(Trigger);

	// it may be the case that enemy movement caused a concealment break, which made Brawler applicable - attempt to trigger afterwards
	EventListener = new class'X2AbilityTrigger_EventListener';
	EventListener.ListenerData.Deferral = ELD_OnStateSubmitted;
	EventListener.ListenerData.EventID = 'UnitConcealmentBroken';
	EventListener.ListenerData.Filter = eFilter_Unit;
	EventListener.ListenerData.EventFn = BrawlerConcealmentListener_Beagle;
	EventListener.ListenerData.Priority = 55;
	Template.AbilityTriggers.AddItem(EventListener);
	
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bRequireBasicVisibility = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true; //Don't use peek tiles for overwatch shots	
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(class'X2Ability_DefaultAbilitySet'.static.OverwatchTargetEffectsCondition());

	//Ensure the attack only triggers in melee range
	RangeCondition = new class'X2Condition_PunchRange';
	Template.AbilityTargetConditions.AddItem(RangeCondition);

	//Ensure the caster isn't dead
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);	
	Template.AddShooterEffectExclusions();

	// Don't trigger when the source is concealed
	SourceNotConcealedCondition = new class'X2Condition_UnitProperty';
	SourceNotConcealedCondition.ExcludeConcealed = true;
	SourceNotConcealedCondition.RequireWithinRange = true;

	// Require that the target is next to the source
	SourceNotConcealedCondition.WithinRange = `TILESTOUNITS(1);
	Template.AbilityShooterConditions.AddItem(SourceNotConcealedCondition);

	Template.bAllowBonusWeaponEffects = true;
	
	DamageEffect = new class'X2Effect_DLC_3StrikeDamage';
	DamageEffect.EnvironmentalDamageAmount = 20;
	Template.AddTargetEffect(DamageEffect);

	//Prevent repeatedly hammering on a unit with Brawler triggers.
	//(This effect does nothing, but enables many-to-many marking of which Brawler attacks have already occurred each turn.)
	BrawlerTargetEffect = new class'X2Effect_Persistent';
	BrawlerTargetEffect.BuildPersistentEffect(1, false, true, true, eGameRule_PlayerTurnEnd);
	BrawlerTargetEffect.EffectName = 'BrawlerTarget';
	BrawlerTargetEffect.bApplyOnMiss = true; //Only one chance, even if you miss (prevents crazy flailing counter-attack chains with a Muton, for example)
	Template.AddTargetEffect(BrawlerTargetEffect);
	
	BrawlerTargetCondition = new class'X2Condition_UnitEffectsWithAbilitySource';
	BrawlerTargetCondition.AddExcludeEffect('BrawlerTarget', 'AA_DuplicateEffectIgnored');
	Template.AbilityTargetConditions.AddItem(BrawlerTargetCondition);

	Template.CustomFireAnim = 'FF_Melee';

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = Brawler_BuildVisualization_Beagle;
	Template.bShowActivation = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NormalChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.MeleeLostSpawnIncreasePerUse;
	Template.bFrameEvenWhenUnitIsHidden = true;

	return Template;
}

//Must be static, because it will be called with a different object (an XComGameState_Ability)
//Used to trigger Brawler when the source's concealment is broken by a unit in melee range (the regular movement triggers get called too soon)
static function EventListenerReturn BrawlerConcealmentListener_Beagle(Object EventData, Object EventSource, XComGameState GameState, Name Event, Object CallbackData)
{
	local XComGameStateContext_Ability AbilityContext;
	local XComGameState_Unit ConcealmentBrokenUnit;
	local StateObjectReference BrawlerRef;
	local XComGameState_Ability BrawlerState;
	local XComGameStateHistory History;

	History = `XCOMHISTORY;

	ConcealmentBrokenUnit = XComGameState_Unit(EventSource);	
	if (ConcealmentBrokenUnit == None)
		return ELR_NoInterrupt;

	//Do not trigger if the Brawler SPARK himself moved to cause the concealment break - only when an enemy moved and caused it.
	AbilityContext = XComGameStateContext_Ability(GameState.GetContext().GetFirstStateInEventChain().GetContext());
	if (AbilityContext != None && AbilityContext.InputContext.SourceObject != ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef)
		return ELR_NoInterrupt;

	BrawlerRef = ConcealmentBrokenUnit.FindAbility('BrawlerTrigger');
	if (BrawlerRef.ObjectID == 0)
		return ELR_NoInterrupt;

	BrawlerState = XComGameState_Ability(History.GetGameStateForObjectID(BrawlerRef.ObjectID));
	if (BrawlerState == None)
		return ELR_NoInterrupt;
	
	BrawlerState.AbilityTriggerAgainstSingleTarget(ConcealmentBrokenUnit.ConcealmentBrokenByUnitRef, false);
	return ELR_NoInterrupt;
}

simulated function Brawler_BuildVisualization_Beagle(XComGameState VisualizeGameState)
{
	// Build the first shot of Brawler's visualization
	TypicalAbility_BuildVisualization(VisualizeGameState);
}

// Ridiculous hacks required for OPTC to work correctly
// Why Firaxis, why?

static function X2AbilityTarget_Single GetSSMT()
{
	return default.SimpleSingleMeleeTarget;
}

static function X2AbilityTrigger_PlayerInput GetPIT()
{
	return default.PlayerInputTrigger;
}

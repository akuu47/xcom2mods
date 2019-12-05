class X2Ability_GREMLINPerks extends XMBAbility config(GameData_SoldierSkills);

var config int ReverseEngineeringBonus;
var config int Warden_CV, Warden_MG, Warden_BM, Warden_Taunt;
var config float Warden_Block;
var config int ECM_HackModifier;
var config int Medical_Dodge;
var config int SystemUplink_Aim;
var config int Decompile_Hack;
var config int Illusion_Charges, Adrenaline_Charges, Refraction_Charges, Ignition_Cooldown;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	//GREMLIN STANDARD
	Templates.AddItem(ReverseEngineering());

	//ACTIVE MODULES
	Templates.AddItem(WardenProtocol());
	Templates.AddItem(ECM());
	Templates.AddItem(MedicalSuite_Dodge());
	Templates.AddItem(UplinkProtocol());
	Templates.AddItem(Overclock());
	Templates.AddItem(NemesisProtocol());	
	Templates.AddItem(PrimeDetonation());
	Templates.AddItem(IllusionProtocol());
	Templates.AddItem(AdrenalineProtocol());
	Templates.AddItem(IgnitionProtocol());
	Templates.AddItem(RefractionProtocol());
	
	//PASSIVE MODULES
	Templates.AddItem(SystemUplink());
	Templates.AddItem(Decompile());
	Templates.AddItem(Interdiction());

	//Boost - Combat Protocol
	Templates.AddItem(PurePassive('MNT_CircuitAmp', "img:///XPerkIconPack.UIPerk_hack_crit"));

	//UNUSED ATM
	Templates.AddItem(ParticleCannon());

	return Templates;
}

// DEFAULT GREMLIN ABILITY
// #######################################################################################

// Reverse Engineering - Successful hacks permanently increase hack stat
static function X2AbilityTemplate ReverseEngineering()
{
	local X2Effect_ReverseEngineering Effect;
	local XMBCondition_AbilityName Condition;
	local X2AbilityTemplate Template;

	Effect = new class'X2Effect_ReverseEngineering';
	Effect.MaxBonus = default.ReverseEngineeringBonus;

	Template = SelfTargetTrigger('MNT_ReverseEngineering', "img:///XPerkIconPack.UIPerk_hack_plus", false, Effect, 'AbilityActivated');
	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('FinalizeIntrusion');
	Condition.IncludeAbilityNames.AddItem('FinalizeHaywire');
	Condition.IncludeAbilityNames.AddItem('FinalizeSKULLMINE');
	Condition.IncludeAbilityNames.AddItem('FinalizeSKULLJACK');

	AddTriggerTargetCondition(Template, Condition);

	Template.AdditionalAbilities.AddItem('IntrusionProtocolFix');
	return Template;
}

// PROTOCOLS
// #######################################################################################

// Taunt Protocol - grants shields to an ally that you're reducing the defense of.
static function X2AbilityTemplate WardenProtocol()
{
	local X2AbilityTemplate                     Template;
	local X2Condition_UnitProperty              TargetProperty;
	local X2Condition_UnitEffects               EffectsCondition;
	local X2Effect_WardenProtocol				BarrierEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_WardenProtocol');

	Template.IconImage = "img:///XPerkIconPack.UIPerk_gremlin_circle";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Defensive;
	Template.bLimitTargetIcons = true;
	Template.DisplayTargetHitChance = false;
	Template.ShotHUDPriority = class'XMBAbility'.default.AUTO_PRIORITY;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SingleTargetWithSelf;

	Template.AbilityCosts.AddItem(ActionPointCost(eCost_Single));

	AddCharges(Template, 2);
	
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetProperty = new class'X2Condition_UnitProperty';
	TargetProperty.ExcludeDead = true;
	TargetProperty.ExcludeHostileToSource = true;
	TargetProperty.ExcludeFriendlyToSource = false;
	TargetProperty.RequireSquadmates = true;
	Template.AbilityTargetConditions.AddItem(TargetProperty);

	EffectsCondition = new class'X2Condition_UnitEffects';
	EffectsCondition.AddExcludeEffect('WardenProtocol', 'AA_UnitIsImmune');
	Template.AbilityTargetConditions.AddItem(EffectsCondition);

	BarrierEffect = new class'X2Effect_WardenProtocol';
	BarrierEffect.Shields_CV = default.Warden_CV;
	BarrierEffect.Shields_MG = default.Warden_MG;
	BarrierEffect.Shields_BM = default.Warden_BM;
	BarrierEffect.DamageReduction = default.Warden_Block;
	BarrierEffect.TauntMod = default.Warden_Taunt;
	BarrierEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	BarrierEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.LocLongDescription, "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield", true);

	Template.AddTargetEffect(BarrierEffect);

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bStationaryWeapon = true;
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.bSkipPerkActivationActions = true;
	Template.bShowActivation = true;
	Template.PostActivationEvents.AddItem('ItemRecalled');

	Template.CustomSelfFireAnim = 'NO_DefenseProtocolA';

	Template.bCrossClassEligible = false;

	return Template;
}

static function X2AbilityTemplate ECM()
{
	local X2AbilityTemplate          Template;
	local X2Effect_ECM               Effect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_ECM');

	Template.IconImage = "img:///XPerkIconPack.UIPerk_hack_move";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	Template.AbilityMultiTargetStyle = new class'X2AbilityMultiTarget_AllAllies';

	Effect = new class'X2Effect_ECM';
	Effect.HackFactor = default.ECM_HackModifier;
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, true,, Template.AbilitySourceName);
	Template.AddMultiTargetEffect(Effect);

	AddIconPassive(Template);

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

// Dodge + 15 for Medical Suite
static function X2AbilityTemplate MedicalSuite_Dodge()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_MedicalSuite_Dodge');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;
	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);
		
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.Medical_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

// Uplink Protocol - Squadsight for everyone
static function X2AbilityTemplate UplinkProtocol()
{
	local X2Effect_Squadsight				Effect;
	local X2AbilityTemplate					Template;
	local X2AbilityMultiTarget_AllAllies	MultiTargetingStyle;
	local X2Condition_UnitProperty			TargetCondition;

	Template = SelfTargetActivated('MNT_UplinkProtocol', "img:///XPerkIconPack.UIPerk_gremlin_sniper", false, none);

	Effect = new class'X2Effect_Squadsight';
	Template.AddMultiTargetEffect(Effect);

	MultiTargetingStyle = new class'X2AbilityMultiTarget_AllAllies';
	MultiTargetingStyle.bAllowSameTarget = true;
	MultiTargetingStyle.NumTargetsRequired = 1; //At least someone must need healing
	Template.AbilityMultiTargetStyle = MultiTargetingStyle;

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeHostileToSource = true;
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.RequireSquadmates = true;                                                                                                                                                 
	Template.AbilityMultiTargetConditions.AddItem(TargetCondition);

	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.SendGremlinToOwnerLocation_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinScanningProtocol_BuildVisualization;
	Template.CinescriptCameraType = "Specialist_ScanningProtocol";

	AddCharges(Template, 1);

	return Template;
}


//Overclock - refunds all gremlin abilities this turn and grants bonus hack. Next turn, hack is dropped significantly though.
static function X2AbilityTemplate Overclock()
{
	local X2AbilityTemplate					Template;
	local XMBEffect_AbilityCostRefund		OverclockEffect;
	local XMBCondition_AbilityName			NameCondition;
	local X2Effect_PersistentStatChange		HackPlus, HackMinus;

	// List of drone skills that overclock works on
	OverclockEffect = new class'XMBEffect_AbilityCostRefund';
	OverclockEffect.EffectName = 'Overclock';
	OverclockEffect.TriggeredEvent = 'Overclock';

	NameCondition = new class 'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('CombatProtocol');
	NameCondition.IncludeAbilityNames.AddItem('MedicalProtocol');
	NameCondition.IncludeAbilityNames.AddItem('AidProtocol');
	NameCondition.IncludeAbilityNames.AddItem('ScanningProtocol');
	NameCondition.IncludeAbilityNames.AddItem('RevivalProtocol');
	NameCondition.IncludeAbilityNames.AddItem('MNT_IgnitionProtocol');
	NameCondition.IncludeAbilityNames.AddItem('MNT_AdrenalineProtocol');
	NameCondition.IncludeAbilityNames.AddItem('MNT_RefractionProtocol');
	NameCondition.IncludeAbilityNames.AddItem('MNT_WardenProtocol');
	NameCondition.IncludeAbilityNames.AddItem('MNT_IllusionProtocol');
	NameCondition.IncludeAbilityNames.AddItem('MNT_NemesisProtocol');
	NameCondition.IncludeAbilityNames.AddItem('CapacitorDischarge');
	NameCondition.IncludeAbilityNames.AddItem('FinalizeIntrusion');
	NameCondition.IncludeAbilityNames.AddItem('FinalizeHaywire');

	OverclockEffect.AbilityTargetConditions.AddItem(NameCondition);
	OverclockEffect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);
	Template = SelfTargetActivated('MNT_Overclock', "img:///XPerkIconPack.UIPerk_gremlin_cycle", true, OverclockEffect, class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY, eCost_Free);

	// Add a cooldown. The internal cooldown numbers include the turn the cooldown is applied, so
	// this is actually a 3 turn cooldown.
	AddCharges(Template, 1);

	// Don't allow multiple ability-refunding abilities to be used in the same turn (e.g. Slam Fire and Serial)
	class'X2Ability_RangerAbilitySet'.static.SuperKillRestrictions(Template, 'Serial_SuperKillCheck');

	// Grants +20 now, -20 next turn
	HackPlus = new class 'X2Effect_PersistentStatChange'; 
	HackPlus.BuildPersistentEffect(1,false,true,,eGameRule_PlayerTurnBegin);
	HackPlus.AddPersistentStatChange(eStat_Hacking, 40);

	HackMinus = new class 'X2Effect_PersistentStatChange'; 
	HackMinus.BuildPersistentEffect(2,false,true,,eGameRule_PlayerTurnBegin);
	HackMinus.AddPersistentStatChange(eStat_Hacking, -20);

	AddSecondaryEffect(Template, HackPlus);
	AddSecondaryEffect(Template, HackMinus);

	return Template;
}

//Nemesis Protocol - Homing Mine + Amplify in an AOE because why not
static function X2AbilityTemplate NemesisProtocol()
{
	local X2AbilityTemplate							Template;
	local X2Effect_Primed							PrimeEffect;
	local X2AbilityCost_ActionPoints				ActionPointCost;
	local X2AbilityCost_Charges						ChargeCost;
	local X2AbilityCharges							Charges;
	local X2AbilityMultiTarget_Radius	            RadiusMultiTarget;	//	purely for visualization of the AOE
	local X2Condition_UnitEffects					EffectCondition;
	local X2AbilityTarget_Cursor					CursorTarget;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_NemesisProtocol');
	Template.IconImage = "img:///XPerkIconPack.UIPerk_gremlin_blossom";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 24;            //  meters
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.fTargetRadius = 5;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	ChargeCost = new class'X2AbilityCost_Charges';
	Template.AbilityCosts.AddItem(ChargeCost);

	Charges = new class'X2AbilityCharges';
	Charges.InitialCharges = 1;
	Template.AbilityCharges = Charges;

	Template.AddShooterEffectExclusions();
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddExcludeEffect(class'X2Effect_HomingMine'.default.EffectName, 'AA_UnitHasHomingMine');
	EffectCondition.AddExcludeEffect(class'X2Effect_Primed'.default.EffectName, 'AA_UnitHasHomingMine');
	Template.AbilityTargetConditions.AddItem(EffectCondition);

	PrimeEffect = new class'X2Effect_Primed';
	PrimeEffect.BuildPersistentEffect(1, true, false);
	PrimeEffect.SetDisplayInfo(ePerkBuff_Penalty, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, true);
	PrimeEffect.AbilityToTrigger = 'PrimeDetonation';
	Template.AddMultiTargetEffect(PrimeEffect);

	Template.TargetingMethod = class'X2TargetingMethod_GremlinAOE';
	Template.bSkipPerkActivationActions = false;
	Template.bHideWeaponDuringFire = false;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	Template.ActivationSpeech = 'SaturationFire';

	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.SendGremlinToLocation_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.CapacitorDischarge_BuildVisualization;
	Template.AdditionalAbilities.AddItem('PrimeDetonation');

	return Template;
}

static function X2AbilityTemplate PrimeDetonation()
{
	local X2AbilityTemplate							Template;
	local X2AbilityToHitCalc_StandardAim			ToHit;
	local X2AbilityMultiTarget_Radius	            RadiusMultiTarget;
	local X2Condition_UnitProperty					UnitPropertyCondition;
	local X2Effect_PrimeExplosion					PrimeDamage;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_PrimeDetonation');
	Template.IconImage = "img:///XPerkIconPack.UIPerk_gremlin_blossom";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	ToHit = new class'X2AbilityToHitCalc_StandardAim';
	ToHit.bIndirectFire = true;
	Template.AbilityToHitCalc = ToHit;

	Template.AbilityTargetStyle = new class'X2AbilityTarget_Single';

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = false;
	RadiusMultiTarget.bAddPrimaryTargetAsMultiTarget = true;
	RadiusMultiTarget.fTargetRadius =  class'X2Ability_ReaperAbilitySet'.default.HomingMineRadius;
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	UnitPropertyCondition.ExcludeHostileToSource = false;
	UnitPropertyCondition.FailOnNonUnits = false; //The grenade can affect interactive objects, others
	Template.AbilityMultiTargetConditions.AddItem(UnitPropertyCondition);

	//	special damage effect handles shrapnel vs regular damage
	PrimeDamage = new class'X2Effect_PrimeExplosion';
	PrimeDamage.EnvironmentalDamageAmount = class'X2Ability_ReaperAbilitySet'.default.HomingMineEnvironmentDamage;
	Template.AddMultiTargetEffect(PrimeDamage);

	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_Placeholder');

	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_ReaperAbilitySet'.static.HomingMineDetonation_BuildVisualization;
	Template.MergeVisualizationFn = class'X2Ability_ReaperAbilitySet'.static.HomingMineDetonation_MergeVisualization;
	Template.PostActivationEvents.AddItem('HomingMineDetonated');

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.GrenadeLostSpawnIncreasePerUse;

	return Template;
}

// Spawns a mimic beacon, ANYWHERE basically.
static function X2AbilityTemplate IllusionProtocol()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2AbilityCharges              Charges;
	local X2AbilityCost_Charges         ChargeCost;
	local X2AbilityTarget_Cursor        CursorTarget;
	local X2AbilityMultiTarget_Radius   RadiusMultiTarget;
	local X2Effect_SpawnMimicBeacon     SpawnMimicBeacon;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_IllusionProtocol');

	Template.IconImage = "img:///XPerkIconPack.UIPerk_enemy_gremlin";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.bHideWeaponDuringFire = true;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Charges = new class 'X2AbilityCharges';
	Charges.InitialCharges = default.Illusion_Charges;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	CursorTarget = new class'X2AbilityTarget_Cursor';
	Template.AbilityTargetStyle = CursorTarget;

	RadiusMultiTarget = new class'X2AbilityMultiTarget_Radius';
	RadiusMultiTarget.bUseWeaponRadius = true;
	RadiusMultiTarget.bIgnoreBlockingCover = true; // we don't need this, the squad viewer will do the appropriate things once thrown
	Template.AbilityMultiTargetStyle = RadiusMultiTarget;

	Template.TargetingMethod = class'X2TargetingMethod_Pillar';
	Template.SkipRenderOfTargetingTemplate = true;

	SpawnMimicBeacon = new class'X2Effect_SpawnMimicBeacon';
	SpawnMimicBeacon.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	Template.AddShooterEffect(SpawnMimicBeacon);
	Template.AddShooterEffect(new class'X2Effect_BreakUnitConcealment');

	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_ItemGrantedAbilitySet'.static.MimicBeacon_BuildVisualization;
	Template.PostActivationEvents.AddItem('ItemRecalled');

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
		
	return Template;
}

// Reusable stims
static function X2AbilityTemplate AdrenalineProtocol()
{
	local X2AbilityTemplate             Template;
	local X2Effect_CombatStims          StimEffect;
	local X2Effect_PersistentStatChange StatEffect;

	StatEffect = new class'X2Effect_PersistentStatChange';
	StatEffect.EffectName = 'StimStats';
	StatEffect.DuplicateResponse = eDupe_Refresh;
	StatEffect.BuildPersistentEffect(class'X2Ability_ItemGrantedAbilitySet'.default.COMBAT_STIM_DURATION, false, true, false, eGameRule_PlayerTurnEnd);
	StatEffect.SetDisplayInfo(ePerkBuff_Bonus, class'X2Ability_ItemGrantedAbilitySet'.default.CombatStimBonusName, class'X2Ability_ItemGrantedAbilitySet'.default.CombatStimBonusDesc, "img:///XPerkIconPack.UIPerk_stim_gremlin", false);
	StatEffect.AddPersistentStatChange(eStat_Mobility, class'X2Ability_ItemGrantedAbilitySet'.default.COMBAT_STIM_MOBILITY_MOD, MODOP_Multiplication);
	
	StimEffect = new class'X2Effect_CombatStims';
	StimEffect.BuildPersistentEffect(class'X2Ability_ItemGrantedAbilitySet'.default.COMBAT_STIM_DURATION, false, true, false, eGameRule_PlayerTurnEnd);
	
	Template = TargetedBuff('MNT_AdrenalineProtocol', "img:///XPerkIconPack.UIPerk_stim_gremlin", false, StatEffect);
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.ActivationSpeech = 'CombatStim';
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	AddCharges(Template, default.Adrenaline_Charges);
	AddSecondaryEffect(Template, StimEffect);
	
	return Template;
}

//Ignition Protocol - Cooldown! based burn
static function X2AbilityTemplate IgnitionProtocol()
{
	local X2AbilityTemplate             Template;
	local X2Effect_Burning              BurningEffect;

	BurningEffect = class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 0);
	BurningEffect.ApplyChance = 100;

	Template = TargetedDebuff('MNT_IgnitionProtocol', "img:///XPerkIconPack.UIPerk_gremlin_blaze", false, BurningEffect);
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.ActivationSpeech = 'CombatProtocol';

	AddCooldown(Template, default.Ignition_Cooldown);
	AddSecondaryEffect(Template, AddHolotargeting());
	
	return Template;
}

// Stealthy protocols!
static function X2AbilityTemplate RefractionProtocol()
{
	local X2AbilityTemplate             Template;
	local X2Effect_RangerStealth		StealthEffect;

	StealthEffect = new class'X2Effect_RangerStealth';
	StealthEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnEnd);
	StealthEffect.bRemoveWhenTargetConcealmentBroken = true;

	Template = TargetedBuff('MNT_RefractionProtocol', "img:///XPerkIconPack.UIPerk_gremlin_stealth", false, StealthEffect);
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.AttachGremlinToTarget_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinSingleTarget_BuildVisualization;
	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.ActivationSpeech = 'ActivateConcealment';
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	AddCharges(Template, default.Refraction_Charges);
	AddSecondaryEffect(Template, class'X2Effect_Spotted'.static.CreateUnspottedEffect());
	
	return Template;
}

// MODULE ABILITIES
// #######################################################################################

//	System Uplink - grants +5 crit for entire squad on all visible enemies, not stackable
static function X2AbilityTemplate SystemUplink()
{
	local X2Effect_SystemUplink Effect;

	Effect = new class'X2Effect_SystemUplink';
	Effect.EffectName = 'MNT_SystemUplink';
	Effect.DuplicateResponse = eDupe_Ignore;
	Effect.AddToHitModifier(default.SystemUplink_Aim, eHit_Success);
	Effect.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	return SquadPassive('MNT_SystemUplink', "img:///XPerkIconPack.UIPerk_hack_circle", false, Effect);
}

//Shorthand for adding holo effect to many abilities - called from other classes
static function X2Effect_HoloTarget AddHolotargeting()
{
	local X2Effect_HoloTarget           Effect;
	local X2Condition_AbilityProperty   AbilityCondition;

	Effect = class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect();

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('Holotargeting');
	Effect.TargetConditions.AddItem(AbilityCondition);

	return Effect;
}

// Decompile - add 1 to hack whenever robots are killed
static function X2AbilityTemplate Decompile()
{
	local XMBEffect_PermanentStatChange Effect;
	local X2AbilityTemplate Template;
	local X2Condition_UnitProperty Condition;

	Effect = new class'XMBEffect_PermanentStatChange';
	Effect.AddStatChange(eStat_Hacking, default.Decompile_Hack);

	Template = SelfTargetTrigger('MNT_Decompilation', "img:///XPerkIconPack.UIPerk_hack_plus", false, Effect, 'KillMail');
	
	Condition = new class'X2Condition_UnitProperty';
	Condition.ExcludeOrganic = true;
	Condition.ExcludeDead = false;
	Condition.ExcludeFriendlyToSource = true;
	Condition.ExcludeHostileToSource = false;
	AddTriggerTargetCondition(Template, Condition);

	return Template;
}

//Interdiction - GREMLIN CCS
static function X2AbilityTemplate Interdiction()
{

	local X2AbilityTemplate                     Template;
	local X2Condition_Visibility                VisCondition;
	local X2Effect_ApplyWeaponDamage			Intercept;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_Interdiction');

	Template.IconImage = "img:///XPerkIconPack.UIPerk_gremlin_overwatch";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Offensive;
	Template.bLimitTargetIcons = true;
	Template.DisplayTargetHitChance = false;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_SHOT_PRIORITY;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	Template.AbilityTriggers.Length = 0;
	AddMovementTrigger(Template);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(TargetWithinTiles(5));
	AddPerTargetCooldown(Template, 1);

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitOnlyProperty);
	VisCondition = new class'X2Condition_Visibility';
	VisCondition.bRequireGameplayVisible = true;
	VisCondition.bActAsSquadsight = false;
	Template.AbilityTargetConditions.AddItem(VisCondition);

	Intercept = new class'X2Effect_ApplyWeaponDamage';
	Intercept.bIgnoreBaseDamage = true;
	Intercept.DamageTag = 'Interdiction';
	Template.AddTargetEffect(Intercept);

	Template.PostActivationEvents.AddItem('ItemRecalled');
	Template.BuildNewGameStateFn = class'X2Ability_SpecialistAbilitySet'.static.SendGremlinToOwnerLocation_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SpecialistAbilitySet'.static.GremlinScanningProtocol_BuildVisualization;
	
	Template.CustomSelfFireAnim = 'NO_MedicalProtocol';
	
	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;

	return Template;
}

static function X2AbilityTemplate DroneMaster()
{
	local XMBEffect_ConditionalBonus		Effect;

	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.AddDamageModifier(2);
	Effect.AbilityTargetConditions.AddItem(default.MatchingWeaponCondition);
	Effect.AbilityShooterConditions.AddItem(default.IsGREMLIN);

	// Restrict to the weapon matching this ability
	return Passive('MNT_DroneMaster', "img:///XPerkIconPack.UIPerk_gremlin_plus", false, Effect);
}


// UNUSED
// #######################################################################################

static function X2AbilityTemplate ParticleCannon()
{
	local X2AbilityTemplate					Template;
	local X2AbilityTarget_Cursor			CursorTarget;
	local X2AbilityMultiTarget_Line			LineMultiTarget;
	local X2Condition_UnitProperty          TargetCondition;
	local X2AbilityCost_ActionPoints        ActionCost;
	local X2Effect_ApplyWeaponDamage        DamageEffect;
	local X2AbilityCooldown					Cooldown;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ParticleCannon');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.Hostility = eHostility_Offensive;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_nulllance";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;

	ActionCost = new class'X2AbilityCost_ActionPoints';
	ActionCost.iNumPoints = 1;   // Updated 8/18/15 to 1 action point only per Jake request.  
	ActionCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 99;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);	
	Template.AbilityToHitCalc = default.DeadEye;

	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = 20;
	Template.AbilityTargetStyle = CursorTarget;

	LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	Template.AbilityMultiTargetStyle = LineMultiTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	TargetCondition = new class'X2Condition_UnitProperty';
	TargetCondition.ExcludeFriendlyToSource = false;
	TargetCondition.ExcludeDead = true;
	Template.AbilityMultiTargetConditions.AddItem(TargetCondition);

	DamageEffect = new class'X2Effect_ApplyWeaponDamage';
	DamageEffect.bIgnoreBaseDamage = true;
	DamageEffect.DamageTag = 'ParticleCannon';
	DamageEffect.bIgnoreArmor = true;
	Template.AddMultiTargetEffect(DamageEffect);

	Template.TargetingMethod = class'X2TargetingMethod_Line_Extend';
	Template.CinescriptCameraType = "Psionic_FireAtLocation";

	Template.ActivationSpeech = 'NullLance';

	Template.bOverrideAim = true;
	Template.bUseSourceLocationZToAim = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'NullLance'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
//END AUTOGENERATED CODE: Template Overrides 'NullLance'

	Template.CustomFireAnim = 'FF_ParticleCannonFire';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	return Template;
}


// VISUALIZATION
// #######################################################################################


simulated function GremlinInterdiction_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local X2AbilityTemplate             AbilityTemplate;
	local StateObjectReference          InteractingUnitRef;
	local XComGameState_Item			GremlinItem;
	local XComGameState_Unit			GremlinUnitState, ShooterState;
	local XComGameState_Ability         AbilityState;
	local array<PathPoint> Path;

	local VisualizationActionMetadata        EmptyTrack;
	local VisualizationActionMetadata        ActionMetadata;
	local X2Action_WaitForAbilityEffect DelayAction;

	local int EffectIndex, MultiTargetIndex;
	local PathingInputData              PathData;
	local PathingResultData				ResultData;
	local X2Action_RevealArea			RevealAreaAction;
	local TTile TargetTile;
	local vector TargetPos;

	local X2Action_PlayAnimation PlayAnimation;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	AbilityState = XComGameState_Ability(History.GetGameStateForObjectID(Context.InputContext.AbilityRef.ObjectID, , VisualizeGameState.HistoryIndex));
	AbilityTemplate = AbilityState.GetMyTemplate();

	GremlinItem = XComGameState_Item(History.GetGameStateForObjectID(Context.InputContext.ItemObject.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1));
	GremlinUnitState = XComGameState_Unit(History.GetGameStateForObjectID(GremlinItem.CosmeticUnitRef.ObjectID, , VisualizeGameState.HistoryIndex - 1));

	//Configure the visualization track for the shooter
	//****************************************************************************************

	//****************************************************************************************
	InteractingUnitRef = Context.InputContext.SourceObject;
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);
	ShooterState = XComGameState_Unit(ActionMetadata.StateObject_NewState);

	class'X2Action_IntrusionProtocolSoldier'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	/*for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityShooterEffects.Length; ++EffectIndex)
	{
		AbilityTemplate.AbilityShooterEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.FindShooterEffectApplyResult(AbilityTemplate.AbilityShooterEffects[EffectIndex]));
	}*/

	
	//Configure the visualization track for the gremlin
	//****************************************************************************************
	InteractingUnitRef = GremlinUnitState.GetReference();

	ActionMetadata = EmptyTrack;
	History.GetCurrentAndPreviousGameStatesForObjectID(GremlinUnitState.ObjectID, ActionMetadata.StateObject_OldState, ActionMetadata.StateObject_NewState, , VisualizeGameState.HistoryIndex);
	ActionMetadata.VisualizeActor = GremlinUnitState.GetVisualizer();

	class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	// Given the target location, we want to generate the movement data.  
	TargetTile = ShooterState.TileLocation;
	TargetPos = `XWORLD.GetPositionFromTileCoordinates(TargetTile);

	class'X2PathSolver'.static.BuildPath(GremlinUnitState, GremlinUnitState.TileLocation, TargetTile, PathData.MovementTiles);
	class'X2PathSolver'.static.GetPathPointsFromPath(GremlinUnitState, PathData.MovementTiles, Path);
	class'XComPath'.static.PerformStringPulling(XGUnitNativeBase(ActionMetadata.VisualizeActor), Path);
	PathData.MovingUnitRef = GremlinUnitState.GetReference();
	PathData.MovementData = Path;
	Context.InputContext.MovementPaths.AddItem(PathData);
	class'X2TacticalVisibilityHelpers'.static.FillPathTileData(PathData.MovingUnitRef.ObjectID,	PathData.MovementTiles,	ResultData.PathTileData);
	Context.ResultContext.PathResults.AddItem(ResultData);
	class'X2VisualizerHelpers'.static.ParsePath(Context, ActionMetadata);
	class'X2Action_AbilityPerkStart'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);

	RevealAreaAction = X2Action_RevealArea(class'X2Action_RevealArea'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	RevealAreaAction.TargetLocation = TargetPos;
	RevealAreaAction.ScanningRadius = GremlinItem.GetItemRadius(AbilityState) * class'XComWorldData'.const.WORLD_METERS_TO_UNITS_MULTIPLIER / class'XComWorldData'.const.WORLD_StepSize;
	
	PlayAnimation = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	PlayAnimation.Params.AnimName = 'NO_CapacitorDischarge';
	
	DelayAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	DelayAction.ChangeTimeoutLength(class'X2Ability_SpecialistAbilitySet'.default.GREMLIN_PERK_EFFECT_WINDOW);

	class'X2Action_AbilityPerkEnd'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded);
	//****************************************************************************************

	//Configure the visualization track for the target
	//****************************************************************************************
	for (MultiTargetIndex = 0; MultiTargetIndex < Context.InputContext.MultiTargets.Length; ++MultiTargetIndex)
	{
		InteractingUnitRef = Context.InputContext.MultiTargets[MultiTargetIndex];
		ActionMetadata = EmptyTrack;
		ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
		ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
		ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

		DelayAction = X2Action_WaitForAbilityEffect(class'X2Action_WaitForAbilityEffect'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
		DelayAction.ChangeTimeoutLength(class'X2Ability_SpecialistAbilitySet'.default.GREMLIN_ARRIVAL_TIMEOUT);       //  give the gremlin plenty of time to show up

		for (EffectIndex = 0; EffectIndex < AbilityTemplate.AbilityMultiTargetEffects.Length; ++EffectIndex)
		{
			AbilityTemplate.AbilityMultiTargetEffects[EffectIndex].AddX2ActionsForVisualization(VisualizeGameState, ActionMetadata, Context.FindMultiTargetEffectApplyResult(AbilityTemplate.AbilityMultiTargetEffects[EffectIndex], MultiTargetIndex));
		}

	}
	//****************************************************************************************
}
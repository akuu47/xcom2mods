class X2Ability_WeaponPerks extends XMBAbility dependson (XComGameStateContext_Ability) config (GameData_SoldierSkills);

var config int Heavy_Penalty, HeavyPlus_Penalty, Light_Bonus;
var config int HoB_Bonus, HoB_Ammo, HoB_Cooldown;
var config int Buckshot_Ammo, Buckshot_Cooldown, Buckshot_Trade;
var config int SteadyFire_Shred;
var config int Ordnance_Grenades;
var config int Fusillade_MinAmmo, Fusillade_Cooldown;
var config int Eyes_Cooldown;
var config int CCS_Range;
var config int BunkerShot_Ammo, BunkerShot_Cooldown, BunkerShot_AimMod, BunkerShot_EnvDmgChance, BunkerShot_Range;
var config int BunkerShot_MobilityPenalty, BunkerShot_DefensePenalty, BunkerShot_DodgeBonus, BunkerShot_ArmorBonus;
var config int DoubleTap_Cooldown, DoubleTap_AimMod;

static function array<X2DataTemplate> CreateTemplates() 
{
	local array<X2DataTemplate> Templates;

	//Weapon Stats
	Templates.AddItem(WeaponEffect_Heavy());
	Templates.AddItem(WeaponEffect_Heavy_Really());
	Templates.AddItem(WeaponEffect_Light());

	//Weapon Uniques
	Templates.AddItem(HailOfBullets());
	Templates.AddItem(HailBonuses());
	Templates.AddItem(Buckshot());
	Templates.AddItem(BuckshotBonuses());
	Templates.AddItem(DepthPerceptionEffect());
	Templates.AddItem(SteadyFire());
	Templates.AddItem(PurePassive('MNT_Marauder', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_strike", true, 'eAbilitySource_Perk'));
	Templates.AddItem(Ordnance());
	Templates.AddItem(IntrusionFix());
	Templates.AddItem(LaunchFix());
	Templates.AddItem(AutoPistolshot());
	Templates.AddItem(SwordMomentum());

	//SMG
	Templates.AddItem(Strafe());

	//Weapon Masteries
	Templates.AddItem(Fusillade());
	Templates.AddItem(CloseCombatSpecialist());
	Templates.AddItem(EyesInTheSky());
	Templates.AddItem(EyesInTheSkyShot());
	Templates.AddItem(BunkerShot());
	Templates.AddItem(DoubleTap());
	Templates.AddItem(DoubleTap2());

	return Templates;
}


// #######################################################################################
// Weapon Unique abilities
// #######################################################################################

//Lowered Mobility for snipers, cannons, grenade launchers
static function X2AbilityTemplate WeaponEffect_Heavy()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	local X2Condition_AbilityProperty		AbilityCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_WeaponEffect_Heavy');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.Heavy_Penalty);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	
	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MNT_Unburdened');

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, -default.Heavy_Penalty);
	PersistentStatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate WeaponEffect_Heavy_Really()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	local X2Condition_AbilityProperty		AbilityCondition;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_WeaponEffect_Heavy_Really');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.HeavyPlus_Penalty);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	AbilityCondition = new class'X2Condition_AbilityProperty';
	AbilityCondition.OwnerHasSoldierAbilities.AddItem('MNT_Unburdened');

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, -default.HeavyPlus_Penalty);
	PersistentStatChangeEffect.TargetConditions.AddItem(AbilityCondition);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

//Increased movement for shotguns and bullpups
static function X2AbilityTemplate WeaponEffect_Light()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_WeaponEffect_Light');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.Light_Bonus);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

//AR - Hail of Bullets: +Aim, 2-ammo attack
static function X2AbilityTemplate HailOfBullets()
{
	local X2AbilityTemplate Template;

	// Create the template using a helper function
	Template = Attack('MNT_HailOfBullets', "img:///UILibrary_PerkIcons.UIPerk_HailOfBullets", true, none, class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY, eCost_WeaponConsumeAll, default.HoB_Ammo);
	
	AddCooldown(Template, default.HoB_Cooldown);
	AddSecondaryAbility(Template, HailBonuses());

	return Template;
}

static function X2AbilityTemplate HailBonuses()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;
	local XMBCondition_AbilityName Condition;

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'MNT_HailBonuses';

	// The bonus adds +10 aim/tier
	Effect.AddToHitModifier(default.HoB_Bonus, eHit_Success, 'conventional');
	Effect.AddToHitModifier(default.HoB_Bonus * 2, eHit_Success, 'magnetic');
	Effect.AddToHitModifier(default.HoB_Bonus * 3, eHit_Success, 'beam');

	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('MNT_HailOfBullets');

	Effect.AbilityTargetConditions.AddItem(Condition);

	Template = Passive('HailBonuses', "img:///UILibrary_PerkIcons.UIPerk_HailOfBullets", false, Effect);
	HidePerkIcon(Template);

	return Template;
}

//Shotguns - Buckshot: Trade aim for crit chance
static function X2AbilityTemplate Buckshot()
{
	local X2AbilityTemplate Template;

	// Create the template using a helper function
	Template = Attack('MNT_Buckshot', "img:///UILibrary_PerkIcons.UIPerk_spreadshot", true, none, class'UIUtilities_Tactical'.const.CLASS_CORPORAL_PRIORITY, eCost_WeaponConsumeAll, default.Buckshot_Ammo);
	AddCooldown(Template, default.Buckshot_Cooldown);
	AddSecondaryAbility(Template, BuckShotBonuses());

	return Template;
}

static function X2AbilityTemplate BuckShotBonuses()
{
	local X2AbilityTemplate Template;
	local XMBEffect_ConditionalBonus Effect;
	local XMBCondition_AbilityName Condition;

	// Create a conditional bonus effect
	Effect = new class'XMBEffect_ConditionalBonus';
	Effect.EffectName = 'MNT_BuckShotBonuses';

	// The bonus adds +20% Crit Damage but -20 accuracy
	Effect.AddToHitModifier(-default.Buckshot_Trade, eHit_Success);
	Effect.AddPercentDamageModifier(default.Buckshot_Trade, eHit_Crit);

	Condition = new class'XMBCondition_AbilityName';
	Condition.IncludeAbilityNames.AddItem('MNT_Buckshot');

	Effect.AbilityTargetConditions.AddItem(Condition);

	Template = Passive('MNT_BuckShotBonuses', "img:///UILibrary_PerkIcons.UIPerk_spreadshot", false, Effect);
	HidePerkIcon(Template);

	return Template;
}

//Snipers/Vektors - Elevated shots are undodgeable, +crit for snipers
static function X2AbilityTemplate DepthPerceptionEffect()
{
	local X2Effect_DepthPerception				AttackBonus;

	AttackBonus = new class 'X2Effect_DepthPerception';
	
	return Passive('MNT_DepthPerception', "img:///UILibrary_PerkIcons.UIPerk_DepthPerception", true, AttackBonus);

}

//Cannons get +damage and shredding if didn't move
static function X2AbilityTemplate SteadyFire()
{
	local X2AbilityTemplate							Template;
	local X2Effect_Persistent						PersistentEffect;
	local X2Effect_SteadyFire						Effect;
	local X2Condition_UnitValue						ValueCondition;
	local X2Condition_PlayerTurns					TurnsCondition;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_SteadyFire');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_ShotFocused";
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	//  this effect stays on the unit indefinitely
	PersistentEffect = new class'X2Effect_Persistent';
	PersistentEffect.EffectName = 'SteadyFire';
	PersistentEffect.BuildPersistentEffect(1, true, true, false, eGameRule_PlayerTurnBegin);
	PersistentEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, true,,Template.AbilitySourceName);

	// Create a conditional bonus that lasts ONE TURN.
	Effect = new class'X2Effect_SteadyFire';
	Effect.EffectName = 'MNT_SteadyFire';
	Effect.ShredMod = default.SteadyFire_Shred;
	Effect.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnEnd);

	//  this condition check guarantees the unit did not move last turn before allowing the bonus to be applied
	ValueCondition = new class'X2Condition_UnitValue';
	ValueCondition.AddCheckValue('MovesLastTurn', 0, eCheck_Exact);
	Effect.TargetConditions.AddItem(ValueCondition);
	
	//  this condition guarantees the player has started more than 1 turn. the first turn of the game does not count for steady hands, as there was no "previous" turn.
	TurnsCondition = new class'X2Condition_PlayerTurns';
	TurnsCondition.NumTurnsCheck.CheckType = eCheck_GreaterThan;
	TurnsCondition.NumTurnsCheck.Value = 1;
	Effect.TargetConditions.AddItem(TurnsCondition);

	PersistentEffect.ApplyOnTick.AddItem(Effect);
	Template.AddShooterEffect(PersistentEffect);

	Template.bCrossClassEligible = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//Bullpup - Marauder: Shots are not turn-ending and shred a point of armor
static function X2AbilityTemplate Marauder()
{
	local XMBEffect_ConditionalBonus Effect;

	Effect = new class'XMBEffect_ConditionalBonus';

	// Create the template using a helper function
	return Passive('MNT_Marauder', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_strike", false, Effect);
}

//Heavy Ordnance - provide frags when equipped with grenade launcher
static function X2AbilityTemplate Ordnance()
{
	local X2AbilityTemplate					Template;
	local XMBEffect_AddUtilityItem			Stocked;
	
	Stocked = new class 'XMBEffect_AddUtilityItem';
	Stocked.DataName = 'FragGrenade';
	Stocked.BaseCharges = default.Ordnance_Grenades;

	Template = Passive('MNT_Ordnance', "img:///XPerkIconPack.UIPerk_grenade_box", false, Stocked);
	
	Template.AdditionalAbilities.AddItem('LaunchGrenadeFix');

	return Template;
}


//For whatever reason, Launch Grenade doesn't friggin show up if not assigned to the soldier directly.
//from SPECTRUM GREEN
static function X2AbilityTemplate LaunchFix()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ShowLaunchGrenade		GrenadeFixEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'LaunchGrenadeFix');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.bDisplayInUITacticalText = false;

	GrenadeFixEffect = new class'X2Effect_ShowLaunchGrenade';
	GrenadeFixEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	GrenadeFixEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(GrenadeFixEffect);

	Template.OverrideAbilities.AddItem('ThrowGrenade');

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

//IntrusionProtocol isn't properly overriding objective hacks
static function X2AbilityTemplate IntrusionFix()
{
	local X2AbilityTemplate					Template;
	local X2Effect_ShowIntrusionProtocol	IntrusionProtocolEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IntrusionProtocolFix');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Template.bDisplayInUITacticalText = false;

	IntrusionProtocolEffect = new class'X2Effect_ShowIntrusionProtocol';
	IntrusionProtocolEffect.BuildPersistentEffect(1, false, false, , eGameRule_PlayerTurnBegin); 
	IntrusionProtocolEffect.DuplicateResponse = eDupe_Allow;
	Template.AddTargetEffect(IntrusionProtocolEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}


// Strafe - Gain movement after attacking, no matter what.
static function X2AbilityTemplate SwordMomentum()
{
	local X2Effect_GrantActionPoints Effect;
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityName NameCondition;

	// Add a single movement-only action point to the unit
	Effect = new class'X2Effect_GrantActionPoints';
	Effect.NumActionPoints = 1;
	Effect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;

	// Create a triggered ability that will activate whenever the unit uses an ability that meets the condition
	Template = SelfTargetTrigger('MNT_SwordMomentum', "img:///UILibrary_XPACK_Common.PerkIcons.UIPerk_Momentum", false, Effect, 'AbilityActivated');

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	// Regular attack
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('SwordSlice');
	NameCondition.IncludeAbilityNames.AddItem('KnifeFighter');
	AddTriggerTargetCondition(Template, NameCondition);

	// Show a flyover when Hit and Run is activated
	Template.bShowActivation = true;
		
	return Template;
}

//Nerfed version of fan fire for autopistols that can't apply ammo effects and has a 1 turn cooldown.
static function X2AbilityTemplate AutoPistolShot()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
	local X2AbilityMultiTarget_BurstFire    BurstFireMultiTarget;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;

	// Macro to do localisation and stuffs
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_AutopistolShot');

	// Icon Properties
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_fanfire";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STANDARD_PISTOL_SHOT_PRIORITY;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.DisplayTargetHitChance = true;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";
	
	// Activated by a button press; additionally, tells the AI this is an activatable
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	// *** VALIDITY CHECKS *** //
	Template.AddShooterEffectExclusions();

	// Targeting Details
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	// Action Point
	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);	

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = 1;
	Template.AbilityCooldown = Cooldown;

	// Damage Effect
	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
	Template.AddTargetEffect(WeaponDamageEffect);
	Template.AddMultiTargetEffect(WeaponDamageEffect);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	BurstFireMultiTarget = new class'X2AbilityMultiTarget_BurstFire';
	BurstFireMultiTarget.NumExtraShots = 2;
	Template.AbilityMultiTargetStyle = BurstFireMultiTarget;
		
	// Targeting Method
	Template.TargetingMethod = class'X2TargetingMethod_OverTheShoulder';
	Template.CinescriptCameraType = "StandardGunFiring";

	// Voice events
	Template.ActivationSpeech = 'FanFire';

	// MAKE IT LIVE!
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'FanFire'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'FanFire'

	return Template;	
}

// Strafe - Gain movement after attacking, no matter what.
static function X2AbilityTemplate Strafe()
{
	local X2Effect_GrantActionPoints Effect;
	local X2AbilityTemplate Template;
	local XMBCondition_AbilityName NameCondition;

	// Add a single movement-only action point to the unit
	Effect = new class'X2Effect_GrantActionPoints';
	Effect.NumActionPoints = 1;
	Effect.PointType = class'X2CharacterTemplateManager'.default.MoveActionPoint;

	// Create a triggered ability that will activate whenever the unit uses an ability that meets the condition
	Template = SelfTargetTrigger('MNT_Strafe', "img:///XPerkIconPack.UIPerk_move_rifle", false, Effect, 'AbilityActivated');

	// Trigger abilities don't appear as passives. Add a passive ability icon.
	AddIconPassive(Template);

	// Regular attack
	NameCondition = new class'XMBCondition_AbilityName';
	NameCondition.IncludeAbilityNames.AddItem('StandardShot');
	AddTriggerTargetCondition(Template, NameCondition);

	// Show a flyover when Hit and Run is activated
	Template.bShowActivation = true;
		
	return Template;
}

// #######################################################################################
// -------------------- WEAPON MASTERIES--------------------------------------------------
// #######################################################################################


// Fusillade - AR: Faceoff
static function X2AbilityTemplate Fusillade()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCooldown                 Cooldown;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityMultiTarget_AllUnits		MultiTargetUnits;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2Condition_UnitInventory			InventoryCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_Fusillade');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_faceoff";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.Hostility = eHostility_Offensive;
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Fusillade_Cooldown;
	Template.AbilityCooldown = Cooldown;

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.bOnlyMultiHitWithSuccess = false;
	Template.AbilityToHitCalc = ToHitCalc;

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	// Ammo
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = default.Fusillade_MinAmmo;
	AmmoCost.bConsumeAllAmmo = true;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	Template.bAllowAmmoEffects = true; // 	
	Template.bAllowBonusWeaponEffects = true;

	InventoryCondition = new class'X2Condition_UnitInventory';
	InventoryCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition.RequireWeaponCategory = 'rifle';
	Template.AbilityShooterConditions.AddItem(InventoryCondition);

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');

	Template.AbilityTargetStyle = default.SimpleSingleTarget;
	MultiTargetUnits = new class'X2AbilityMultiTarget_AllUnits';
	MultiTargetUnits.bUseAbilitySourceAsPrimaryTarget = true;
	MultiTargetUnits.bAcceptEnemyUnits = true;
	Template.AbilityMultiTargetStyle = MultiTargetUnits;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);
	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);

	Template.AddTargetEffect(new class'X2Effect_ApplyWeaponDamage');
	Template.AddMultiTargetEffect(new class'X2Effect_ApplyWeaponDamage');

	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = class'X2Ability_SharpshooterAbilitySet'.static.Faceoff_BuildVisualization;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'Faceoff'
	Template.bFrameEvenWhenUnitIsHidden = true;
	Template.ActivationSpeech = 'Faceoff';
//END AUTOGENERATED CODE: Template Overrides 'Faceoff'

	return Template;
}

// CCS - Reaction fire against enemies in close range [XMB]
static function X2AbilityTemplate CloseCombatSpecialist()
{
	local X2AbilityTemplate Template;
	local X2AbilityToHitCalc_StandardAim ToHit;
	local X2Condition_UnitInventory	InventoryCondition;

	Template = Attack('MNT_CloseCombatSpecialist', "img:///UILibrary_PerkIcons.UIPerk_closecombatspecialist", false, none, class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY, eCost_None);

	InventoryCondition = new class'X2Condition_UnitInventory';
	InventoryCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition.RequireWeaponCategory = 'shotgun';
	Template.AbilityShooterConditions.AddItem(InventoryCondition);

	HidePerkIcon(Template);
	AddIconPassive(Template);
	ToHit = new class'X2AbilityToHitCalc_StandardAim';
	ToHit.bReactionFire = true;
	Template.AbilityToHitCalc = ToHit;
	Template.AbilityTriggers.Length = 0;
	AddMovementTrigger(Template);
	Template.AbilityTargetConditions.AddItem(TargetWithinTiles(default.CCS_Range));
	AddPerTargetCooldown(Template, 1);

	return Template;
}

// Eyes in the Sky - Activate to overwatch everything in sight
static function X2AbilityTemplate EyesInTheSky()
{
	local X2AbilityTemplate             Template;
	local X2AbilityCooldown             Cooldown;
	local X2AbilityCost_Ammo            AmmoCost;
	local X2AbilityCost_ActionPoints    ActionPointCost;
	local X2Effect_ReserveActionPoints  ReservePointsEffect;
	local X2Condition_UnitEffects       SuppressedCondition;
	local X2Condition_UnitInventory		InventoryCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_EyesInTheSky');

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;   //  this will guarantee the unit has at least 1 action point
	ActionPointCost.bFreeCost = true;           //  ReserveActionPoints effect will take all action points away
	ActionPointCost.DoNotConsumeAllEffects.Length = 0;
	ActionPointCost.DoNotConsumeAllSoldierAbilities.Length = 0;
	ActionPointCost.AllowedTypes.RemoveItem(class'X2CharacterTemplateManager'.default.SkirmisherInterruptActionPoint);
	Template.AbilityCosts.AddItem(ActionPointCost);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');

	InventoryCondition = new class'X2Condition_UnitInventory';
	InventoryCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition.RequireWeaponCategory = 'sniper_rifle';
	Template.AbilityShooterConditions.AddItem(InventoryCondition);

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();
	SuppressedCondition = new class'X2Condition_UnitEffects';
	SuppressedCondition.AddExcludeEffect(class'X2Effect_Suppression'.default.EffectName, 'AA_UnitIsSuppressed');
	SuppressedCondition.AddExcludeEffect(class'X2Effect_SkirmisherInterrupt'.default.EffectName, 'AA_AbilityUnavailable');
	Template.AbilityShooterConditions.AddItem(SuppressedCondition);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.Eyes_Cooldown;
	Template.AbilityCooldown = Cooldown;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	ReservePointsEffect = new class'X2Effect_ReserveActionPoints';
	ReservePointsEffect.ReserveType = 'EyesInTheSky';
	Template.AddShooterEffect(ReservePointsEffect);

	Template.AdditionalAbilities.AddItem('EyesInTheSkyShot');
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.bSkipFireAction = true;
	Template.bShowActivation = true;

	Template.AbilityTargetStyle = default.SelfTarget;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aimcover";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_MAJOR_PRIORITY;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.Hostility = eHostility_Defensive;
	Template.AbilityConfirmSound = "Unreal2DSounds_OverWatch";

	Template.ActivationSpeech = 'KillZone';
	
	Template.bCrossClassEligible = true;
	
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;
	
	return Template;
}

// The actual shot
static function X2AbilityTemplate EyesInTheSkyShot()
{
	local X2AbilityTemplate							Template;
	local X2AbilityToHitCalc_StandardAim			ToHit;
	local X2AbilityCost_ReserveActionPoints			ReserveActionPointCost;
	local X2AbilityCost_Ammo						AmmoCost;
	local X2Condition_Visibility					TargetVisibilityCondition;

	Template = Attack('EyesInTheSkyShot', "img:///UILibrary_PerkIcons.UIPerk_aimcover", false, none, class'UIUtilities_Tactical'.const.CLASS_SERGEANT_PRIORITY, eCost_None);
	
	Template.AbilityCosts.Length = 0;

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ReserveActionPointCost = new class'X2AbilityCost_ReserveActionPoints';
	ReserveActionPointCost.iNumPoints = 1;
	ReserveActionPointCost.bFreeCost = true;
	ReserveActionPointCost.AllowedTypes.AddItem('EyesInTheSky');
	Template.AbilityCosts.AddItem(ReserveActionPointCost);

	Template.AbilityTargetConditions.AddItem(default.LivingHostileUnitDisallowMindControlProperty);
	TargetVisibilityCondition = new class'X2Condition_Visibility';
	TargetVisibilityCondition.bRequireGameplayVisible = true;
	TargetVisibilityCondition.bDisablePeeksOnMovement = true;
	TargetVisibilityCondition.bAllowSquadsight = true;
	Template.AbilityTargetConditions.AddItem(TargetVisibilityCondition);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());

	HidePerkIcon(Template);
	AddIconPassive(Template);

	ToHit = new class'X2AbilityToHitCalc_StandardAim';
	ToHit.bReactionFire = true;
	Template.AbilityToHitCalc = ToHit;
	Template.AbilityTriggers.Length = 0;
	AddMovementTrigger(Template);
	AddPerTargetCooldown(Template, 1);

	return Template;
}

// Bunker Shot - Shoot everything in front of you with immense aim penalty. Stat effect afterwards.
static function X2AbilityTemplate BunkerShot()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityCost_Ammo                AmmoCost;
	local X2AbilityTarget_Cursor            CursorTarget;
	local X2AbilityMultiTarget_Line         LineMultiTarget;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2AbilityToHitCalc_StandardAim    StandardAim;
	local X2AbilityCooldown                 Cooldown;
	local X2Effect_ApplyDirectionalWorldDamage WorldDamage;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	local X2Condition_UnitInventory			InventoryCondition;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_BunkerShot');
	
	AmmoCost = new class'X2AbilityCost_Ammo';	
	AmmoCost.iAmmo = default.BunkerShot_Ammo;
	Template.AbilityCosts.AddItem(AmmoCost);
	
	Template.AbilityCosts.AddItem(default.WeaponActionTurnEnding);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.BunkerShot_Cooldown;
	Template.AbilityCooldown = Cooldown;
	
	InventoryCondition = new class'X2Condition_UnitInventory';
	InventoryCondition.RelevantSlot=eInvSlot_PrimaryWeapon;
	InventoryCondition.RequireWeaponCategory = 'cannon';
	Template.AbilityShooterConditions.AddItem(InventoryCondition);

	StandardAim = new class'X2AbilityToHitCalc_StandardAim';
	StandardAim.bMultiTargetOnly = true;
	StandardAim.BuiltInHitMod = -default.BunkerShot_AimMod;
	Template.AbilityToHitCalc = StandardAim;
	
	Template.AddMultiTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bOverrideAim = true;

	WorldDamage = new class'X2Effect_ApplyDirectionalWorldDamage';
	WorldDamage.bUseWeaponDamageType = true;
	WorldDamage.bUseWeaponEnvironmentalDamage = false;
	WorldDamage.EnvironmentalDamageAmount = 30;
	WorldDamage.bApplyOnHit = true;
	WorldDamage.bApplyOnMiss = true;
	WorldDamage.bApplyToWorldOnHit = true;
	WorldDamage.bApplyToWorldOnMiss = true;
	WorldDamage.bHitAdjacentDestructibles = true;
	WorldDamage.PlusNumZTiles = 1;
	WorldDamage.bHitTargetTile = true;
	WorldDamage.ApplyChance = default.BunkerShot_EnvDmgChance;
	Template.AddMultiTargetEffect(WorldDamage);
	
	CursorTarget = new class'X2AbilityTarget_Cursor';
	CursorTarget.FixedAbilityRange = default.BunkerShot_Range;
	Template.AbilityTargetStyle = CursorTarget;	

	LineMultiTarget = new class'X2AbilityMultiTarget_Line';
	Template.AbilityMultiTargetStyle = LineMultiTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(2,false,true,,eGameRule_PlayerTurnBegin);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.BunkerShot_MobilityPenalty);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Defense, default.BunkerShot_DefensePenalty);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.BunkerShot_DodgeBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.BunkerShot_ArmorBonus);
	Template.AddShooterEffect(PersistentStatChangeEffect);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventmec_minigun";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.ActionFireClass = class'X2Action_Fire_SaturationFire';

	Template.TargetingMethod = class'X2TargetingMethod_Line_Extend';

	Template.ActivationSpeech = 'SaturationFire';
	Template.CinescriptCameraType = "Grenadier_SaturationFire";
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;


	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'SaturationFire'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'SaturationFire'

	return Template;	
}

// Rapidfire except less sucky
static function X2AbilityTemplate DoubleTap()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityCooldown					Cooldown;
	local X2Condition_ValidWeapon			ValidWeapon;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_DoubleTap');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 0;
	ActionPointCost.bAddWeaponTypicalCost = true;
	ActionPointCost.bConsumeAllPoints = true;
	Template.AbilityCosts.AddItem(ActionPointCost);

	//  require 2 ammo to be present so that both shots can be taken
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 2;
	AmmoCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(AmmoCost);
	//  actually charge 1 ammo for this shot. the 2nd shot will charge the extra ammo.
	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.DoubleTap_Cooldown;
	Template.AbilityCooldown = Cooldown;

	ValidWeapon = new class'X2Condition_ValidWeapon';
	ValidWeapon.AllowedWeaponCategories.AddItem('shotgun');
	ValidWeapon.AllowedWeaponCategories.AddItem('sniper_rifle');
	Template.AbilityShooterConditions.AddItem(ValidWeapon);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	ToHitCalc.BuiltInHitMod = default.DoubleTap_AimMod;
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
	Template.AbilityTargetConditions.AddItem(default.GameplayVisibilityCondition);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_HideSpecificErrors;
	Template.HideErrors.AddItem('AA_WeaponIncompatible');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_DoubleTap";
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.BuildInterruptGameStateFn = TypicalAbility_BuildInterruptGameState;

	Template.AdditionalAbilities.AddItem('DoubleTap2');
	Template.PostActivationEvents.AddItem('DoubleTap2');

	Template.bCrossClassEligible = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'DoubleTap'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'DoubleTap'

	return Template;
}

static function X2AbilityTemplate DoubleTap2()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_Ammo				AmmoCost;
	local X2AbilityToHitCalc_StandardAim    ToHitCalc;
	local X2AbilityTrigger_EventListener    Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'DoubleTap2');

	AmmoCost = new class'X2AbilityCost_Ammo';
	AmmoCost.iAmmo = 1;
	Template.AbilityCosts.AddItem(AmmoCost);

	ToHitCalc = new class'X2AbilityToHitCalc_StandardAim';
	Template.AbilityToHitCalc = ToHitCalc;
	Template.AbilityToHitOwnerOnMissCalc = ToHitCalc;

	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);

	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.HoloTargetEffect());
	Template.AssociatedPassives.AddItem('HoloTargeting');
	Template.AddTargetEffect(class'X2Ability_GrenadierAbilitySet'.static.ShredderDamageEffect());
	Template.bAllowAmmoEffects = true;
	Template.bAllowBonusWeaponEffects = true;

	Trigger = new class'X2AbilityTrigger_EventListener';
	Trigger.ListenerData.Deferral = ELD_OnStateSubmitted;
	Trigger.ListenerData.EventID = 'DoubleTap2';
	Trigger.ListenerData.Filter = eFilter_Unit;
	Trigger.ListenerData.EventFn = class'XComGameState_Ability'.static.AbilityTriggerEventListener_OriginalTarget;
	Template.AbilityTriggers.AddItem(Trigger);

	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_COLONEL_PRIORITY;
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_DoubleTap";

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.MergeVisualizationFn = SequentialShot_MergeVisualization;
	
	Template.bShowActivation = true;

	Template.SuperConcealmentLoss = class'X2AbilityTemplateManager'.default.SuperConcealmentStandardShotLoss;
	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotChosenActivationIncreasePerUse;
	Template.LostSpawnIncreasePerUse = class'X2AbilityTemplateManager'.default.StandardShotLostSpawnIncreasePerUse;
//BEGIN AUTOGENERATED CODE: Template Overrides 'DoubleTap2'
	Template.bFrameEvenWhenUnitIsHidden = true;
//END AUTOGENERATED CODE: Template Overrides 'DoubleTap2'

	return Template;
}
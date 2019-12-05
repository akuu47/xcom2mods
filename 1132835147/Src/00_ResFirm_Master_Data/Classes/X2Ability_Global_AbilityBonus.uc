//  FILE:   X2Ability_Global_AbilityBonus.uc
//  AUTHOR: Krakah

class X2Ability_Global_AbilityBonus extends X2Ability dependson(XComGameStateContext_Ability, X2CVWPDataStructures) config(_GlobalMobilityBonus);

var config CVWP_AbilityBonus CVWPdata_1_Bonus;
var config CVWP_AbilityBonus CVWPdata_2_Bonus;
var config CVWP_AbilityBonus CVWPdata_3_Bonus;

var config CVWP_AbilityBonus CVWPdata_Assault_1_Bonus;
var config CVWP_AbilityBonus CVWPdata_Assault_2_Bonus;
var config CVWP_AbilityBonus CVWPdata_Assault_3_Bonus;

var config CVWP_AbilityBonus CVWPdata_Shotgun_1_Bonus;
var config CVWP_AbilityBonus CVWPdata_Shotgun_2_Bonus;
var config CVWP_AbilityBonus CVWPdata_Shotgun_3_Bonus;

var config CVWP_AbilityBonus CVWPdata_Sniper_1_Bonus;
var config CVWP_AbilityBonus CVWPdata_Sniper_2_Bonus;
var config CVWP_AbilityBonus CVWPdata_Sniper_3_Bonus;

var config CVWP_AbilityBonus CVWPdata_Cannon_1_Bonus;
var config CVWP_AbilityBonus CVWPdata_Cannon_2_Bonus;
var config CVWP_AbilityBonus CVWPdata_Cannon_3_Bonus;

var config CVWP_AbilityBonus CVWPdata_Pistol_1_Bonus;
var config CVWP_AbilityBonus CVWPdata_Pistol_2_Bonus;
var config CVWP_AbilityBonus CVWPdata_Pistol_3_Bonus;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CVWPdata_1_AbilityBonus());
	Templates.AddItem(CVWPdata_2_AbilityBonus());
	Templates.AddItem(CVWPdata_3_AbilityBonus());

	Templates.AddItem(CVWPdata_Assault_1_AbilityBonus());
	Templates.AddItem(CVWPdata_Assault_2_AbilityBonus());
	Templates.AddItem(CVWPdata_Assault_3_AbilityBonus());

	Templates.AddItem(CVWPdata_Shotgun_1_AbilityBonus());
	Templates.AddItem(CVWPdata_Shotgun_2_AbilityBonus());
	Templates.AddItem(CVWPdata_Shotgun_3_AbilityBonus());

	Templates.AddItem(CVWPdata_Sniper_1_AbilityBonus());
	Templates.AddItem(CVWPdata_Sniper_2_AbilityBonus());
	Templates.AddItem(CVWPdata_Sniper_3_AbilityBonus());

	Templates.AddItem(CVWPdata_Cannon_1_AbilityBonus());
	Templates.AddItem(CVWPdata_Cannon_2_AbilityBonus());
	Templates.AddItem(CVWPdata_Cannon_3_AbilityBonus());

	Templates.AddItem(CVWPdata_Pistol_1_AbilityBonus());
	Templates.AddItem(CVWPdata_Pistol_2_AbilityBonus());
	Templates.AddItem(CVWPdata_Pistol_3_AbilityBonus());
	return Templates;
}

//
// Global
//
//##############################################################################################################
//################################################### Tier 1 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_1_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_1_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_1_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_1_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//##############################################################################################################
//################################################### Tier 2 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_2_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_2_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_2_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_2_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//##############################################################################################################
//################################################### Tier 3 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_3_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_3_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_3_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_3_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//
// Assault Rifle
//
//##############################################################################################################
//################################################### Tier 1 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Assault_1_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Assault_1_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Assault_1_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Assault_1_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//##############################################################################################################
//################################################### Tier 2 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Assault_2_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Assault_2_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Assault_2_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Assault_2_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//##############################################################################################################
//################################################### Tier 3 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Assault_3_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Assault_3_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Assault_3_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Assault_3_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//
// Shotgun
//
//##############################################################################################################
//################################################### Tier 1 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Shotgun_1_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Shotgun_1_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Shotgun_1_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Shotgun_1_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//##############################################################################################################
//################################################### Tier 2 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Shotgun_2_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Shotgun_2_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Shotgun_2_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Shotgun_2_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//##############################################################################################################
//################################################### Tier 3 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Shotgun_3_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Shotgun_3_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Shotgun_3_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Shotgun_3_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//
// Sniper
//
//##############################################################################################################
//################################################### Tier 1 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Sniper_1_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Sniper_1_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Sniper_1_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Sniper_1_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//##############################################################################################################
//################################################### Tier 2 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Sniper_2_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Sniper_2_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Sniper_2_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Sniper_2_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//##############################################################################################################
//################################################### Tier 3 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Sniper_3_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Sniper_3_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Sniper_3_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Sniper_3_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}


//
// Cannon
//
//##############################################################################################################
//################################################### Tier 1 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Cannon_1_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Cannon_1_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Cannon_1_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Cannon_1_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//##############################################################################################################
//################################################### Tier 2 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Cannon_2_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Cannon_2_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Cannon_2_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Cannon_2_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//##############################################################################################################
//################################################### Tier 3 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Cannon_3_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Cannon_3_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Cannon_3_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Cannon_3_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;
	}	
//
// Pistol
//
//##############################################################################################################
//################################################### Tier 1 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Pistol_1_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Pistol_1_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Pistol_1_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Pistol_1_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//##############################################################################################################
//################################################### Tier 2 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Pistol_2_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Pistol_2_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Pistol_2_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Pistol_2_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}

//##############################################################################################################
//################################################### Tier 3 ###################################################
//##############################################################################################################
static function X2AbilityTemplate CVWPdata_Pistol_3_AbilityBonus() {
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;
	`CREATE_X2ABILITY_TEMPLATE(Template, default.CVWPdata_Pistol_3_Bonus.AbilityTemplate);
	// Template.IconImage = no icon needed for stats bonus
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	// Bonus to Mobility and DetectionRange stat effects
	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, "", "", "", false,,Template.AbilitySourceName);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.CVWPdata_Pistol_3_Bonus.MobilityBonus);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_DetectionModifier, default.CVWPdata_Pistol_3_Bonus.DetectionRadius);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	return Template;	
}
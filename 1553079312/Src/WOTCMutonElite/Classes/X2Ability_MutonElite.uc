class X2Ability_MutonElite extends X2Ability config(MutonElite);

var config int PERSONAL_SHIELD_COOLDOWN;
var config int PERSONAL_SHIELD_DURATION;
var config int PERSONAL_SHIELD_HP;
var config int PERSONAL_SHIELD_ACTION_COST;

var config int PERSONAL_SHIELD_XCOM_DURATION;
var config int PERSONAL_SHIELD_XCOM_HP;


var config string PERSONAL_SHIELD_NAME;
var config string PERSONAL_SHIELD_DESCRIPTION;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateMutonElite_PersonalShieldAbility());
	Templates.AddItem(CreateMutonElite_PersonalShield_XcomAbility());
	Templates.AddItem(CreateMutonElite_ShieldPasive_Xcom());

	return Templates;
}


static function X2DataTemplate CreateMutonElite_PersonalShieldAbility()
{
	local X2AbilityTemplate							Template;
	local X2AbilityCooldown							Cooldown;
	local X2AbilityCost_ActionPoints				ActionPointCost;
	local array<name>								SkipExclusions;
	local X2Effect_EnergyShield						PersonalShieldEffect;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'MutonElite_PersonalShield');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield"; 

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Defensive;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = true;
	Template.DisplayTargetHitChance = false;

	//Template.bSkipFireAction = true;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions(SkipExclusions);

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = default.PERSONAL_SHIELD_ACTION_COST;
	ActionPointCost.bConsumeAllPoints = false;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Cooldown = new class'X2AbilityCooldown';
	Cooldown.iNumTurns = default.PERSONAL_SHIELD_COOLDOWN;
	Template.AbilityCooldown = Cooldown;

	PersonalShieldEffect = new class'X2Effect_EnergyShield';
	PersonalShieldEffect.BuildPersistentEffect(default.PERSONAL_SHIELD_DURATION, false, true, false, eGameRule_PlayerTurnEnd);

	PersonalShieldEffect.SetDisplayInfo (ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);


	PersonalShieldEffect.AddPersistentStatChange(eStat_ShieldHP, default.PERSONAL_SHIELD_HP);
	PersonalShieldEffect.EffectName='PersonalShield';
	Template.AddTargetEffect(PersonalShieldEffect);

	Template.CustomFireAnim = 'HL_SignalPositive';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
	Template.CinescriptCameraType = "AdvShieldBearer_EnergyShieldArmor"; //??

	return Template;
}

static function X2AbilityTemplate CreateMutonElite_ShieldPasive_Xcom()
{
	local X2AbilityTemplate						Template;
	local X2Effect_PersistentStatChange         PersistentStatChangeEffect;
	local X2Effect_DamageImmunity               ImmunityEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ShieldPasive_Xcom');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield"; 

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
	PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_HP, 2);
	Template.AddTargetEffect(PersistentStatChangeEffect);
	

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}

static function X2DataTemplate CreateMutonElite_PersonalShield_XcomAbility()
{
	local X2AbilityTemplate							Template;
	local X2AbilityCooldown							Cooldown;
	local X2AbilityCost_ActionPoints				ActionPointCost;
	local array<name>								SkipExclusions;
	local X2Effect_EnergyShield						PersonalShieldEffect;
	local X2AbilityCost_Ammo						AmmoCost;
	local X2AbilityCharges							Charges;
	local X2AbilityCost_Charges						ChargeCost;

	`CREATE_X2ABILITY_TEMPLATE (Template, 'PersonalShield_Xcom');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adventshieldbearer_energyshield"; 

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.Hostility = eHostility_Defensive;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;

	Template.AbilityToHitCalc = default.DeadEye;
    Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
	Template.bCrossClassEligible = false;
	Template.bDisplayInUITooltip = true;
	Template.bDisplayInUITacticalText = true;
	Template.bShowActivation = true;
	Template.DisplayTargetHitChance = false;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	SkipExclusions.AddItem(class'X2AbilityTemplateManager'.default.DisorientedName); //okay when disoriented
	Template.AddShooterEffectExclusions(SkipExclusions);

	Template.AbilityCosts.AddItem(default.FreeActionCost);


	Charges = new class 'X2AbilityCharges';
	Charges.InitialCharges = 2;
	Template.AbilityCharges = Charges;

	ChargeCost = new class'X2AbilityCost_Charges';
	ChargeCost.NumCharges = 1;
	Template.AbilityCosts.AddItem(ChargeCost);

	PersonalShieldEffect = new class'X2Effect_EnergyShield';
	PersonalShieldEffect.BuildPersistentEffect(default.PERSONAL_SHIELD_XCOM_DURATION, false, true, false, eGameRule_PlayerTurnBegin);
	//eGameRule_PlayerTurnBegin
	PersonalShieldEffect.SetDisplayInfo (ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage,,, Template.AbilitySourceName);


	PersonalShieldEffect.AddPersistentStatChange(eStat_ShieldHP, default.PERSONAL_SHIELD_XCOM_HP);
	PersonalShieldEffect.EffectName='PersonalShield';
	Template.AddTargetEffect(PersonalShieldEffect);

	Template.CustomFireAnim = 'HL_SignalPositive';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = PersonalShield_BuildVisualization;
	//Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.CinescriptCameraType = "AdvShieldBearer_EnergyShieldArmor"; //??

	return Template;
}


simulated function PersonalShield_BuildVisualization(XComGameState VisualizeGameState)
{
	local XComGameStateHistory History;
	local XComGameStateContext_Ability  Context;
	local StateObjectReference InteractingUnitRef;
	local VisualizationActionMetadata EmptyTrack;
	local VisualizationActionMetadata ActionMetadata;
	local X2Action_PlayAnimation PlayAnimationAction;

	History = `XCOMHISTORY;

	Context = XComGameStateContext_Ability(VisualizeGameState.GetContext());
	InteractingUnitRef = Context.InputContext.SourceObject;

	//Configure the visualization track for the shooter
	//****************************************************************************************
	ActionMetadata = EmptyTrack;
	ActionMetadata.StateObject_OldState = History.GetGameStateForObjectID(InteractingUnitRef.ObjectID, eReturnType_Reference, VisualizeGameState.HistoryIndex - 1);
	ActionMetadata.StateObject_NewState = VisualizeGameState.GetGameStateForObjectID(InteractingUnitRef.ObjectID);
	ActionMetadata.VisualizeActor = History.GetVisualizer(InteractingUnitRef.ObjectID);

	PlayAnimationAction = X2Action_PlayAnimation(class'X2Action_PlayAnimation'.static.AddToVisualizationTree(ActionMetadata, Context, false, ActionMetadata.LastActionAdded));
	PlayAnimationAction.Params.AnimName = 'HL_SignalHalt';

	}
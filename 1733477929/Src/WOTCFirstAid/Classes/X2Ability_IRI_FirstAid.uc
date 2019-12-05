class X2Ability_IRI_FirstAid extends X2Ability config(FirstAid);

var config bool FIRST_AID_ENDS_TURN;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(IRI_FirstAid());	

	return Templates;
}


static function X2AbilityTemplate IRI_FirstAid()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityCost_ActionPoints        ActionPointCost;
	local X2Condition_UnitProperty          UnitPropertyCondition;
	local X2Condition_UnitEffects			EffectCondition;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'IRI_FirstAid');

	ActionPointCost = new class'X2AbilityCost_ActionPoints';
	ActionPointCost.iNumPoints = 1;
	ActionPointCost.bConsumeAllPoints = default.FIRST_AID_ENDS_TURN;
	Template.AbilityCosts.AddItem(ActionPointCost);
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SimpleSingleTarget;

	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = true;
	Template.AbilityShooterConditions.AddItem(UnitPropertyCondition);

	Template.AddShooterEffectExclusions();
	
	UnitPropertyCondition = new class'X2Condition_UnitProperty';
	UnitPropertyCondition.ExcludeDead = false;
	UnitPropertyCondition.ExcludeAlive = false;
	UnitPropertyCondition.ExcludeHostileToSource = true;
	UnitPropertyCondition.ExcludeFriendlyToSource = false;
	//UnitPropertyCondition.IsBleedingOut = true;	//	doesn't work for some reason
	UnitPropertyCondition.RequireWithinRange = true;
	UnitPropertyCondition.RequireSquadmates = true;
	UnitPropertyCondition.FailOnNonUnits = true;	//how do you even first aid a claymore, wtf
	UnitPropertyCondition.WithinRange = class'X2Ability_CarryUnit'.default.CARRY_UNIT_RANGE;
	Template.AbilityTargetConditions.AddItem(UnitPropertyCondition);
	
	EffectCondition = new class'X2Condition_UnitEffects';
	EffectCondition.AddRequireEffect(class'X2StatusEffects'.default.BleedingOutName, 'AA_MissingRequiredEffect');
	Template.AbilityTargetConditions.AddItem(EffectCondition);

	Template.AddTargetEffect(new class'X2Effect_IRI_FirstAid');

	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.IconImage = "img:///IRI_FirstAid.IRI_FirstAid";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.STABILIZE_PRIORITY;
	Template.Hostility = eHostility_Defensive;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.bDisplayInUITooltip = false;
	Template.bDisplayInUITacticalText = false;
	Template.bDontDisplayInAbilitySummary = true;
	//Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
	Template.bDisplayInUITooltip = false;
	Template.bLimitTargetIcons = true;

	Template.ActivationSpeech = 'StabilizingAlly';
	Template.CustomFireAnim = 'HL_Revive';
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	Template.ChosenActivationIncreasePerUse = class'X2AbilityTemplateManager'.default.NonAggressiveChosenActivationIncreasePerUse;

	return Template;
}
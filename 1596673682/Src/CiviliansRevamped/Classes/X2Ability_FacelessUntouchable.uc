//-----------------------------------------------------------
//	Class:	X2Ability_FacelessUntouchable
//	Author: Mr. Nice
//	
//-----------------------------------------------------------


class X2Ability_FacelessUntouchable extends X2Ability;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(FacelessUntouchable());

	return Templates;
}

static function X2AbilityTemplate FacelessUntouchable()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_FacelessUntouchable           FacelessUntouchableEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'FacelessUntouchable');

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_evasion"; //Mr. Nice should never *see* the ability anywhere, but whatever

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	FacelessUntouchableEffect = new class'X2Effect_FacelessUntouchable';
	FacelessUntouchableEffect.BuildPersistentEffect(1, true);
	Template.AddTargetEffect(FacelessUntouchableEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}
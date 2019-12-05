class X2Ability_SuppressionFlankPenalty extends X2Ability;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(AddSuppressionFlankPenaltyAbility());

	return Templates;
}

static function X2AbilityTemplate AddSuppressionFlankPenaltyAbility()
{
	local X2AbilityTemplate						Template;
	local X2Effect_SuppressionNoFlank           DamageEffect;

	// Icon Properties
	`CREATE_X2ABILITY_TEMPLATE(Template, 'SuppressionFlankPenalty');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_supression";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	DamageEffect = new class'X2Effect_SuppressionNoFlank';
	DamageEffect.BuildPersistentEffect(1, true, false, false);
	DamageEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false,,Template.AbilitySourceName);
	DamageEffect.Reason = "Suppression";
	DamageEffect.EffectName = 'SuppressionAimMod';
	Template.AddTargetEffect(DamageEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}
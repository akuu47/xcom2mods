class X2Ability_ChosenKeenRoll extends X2Ability;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	Templates.AddItem(CreateKeenRoll());
	return Templates;
}

static function X2DataTemplate CreateKeenRoll()
{
	local X2AbilityTemplate Template;
	local X2Effect_ChosenKeenRoll KeenEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'ChosenKeenRoll');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_keen";
	Template.Hostility = eHostility_Neutral;
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_NeverShow;
	Template.bDontDisplayInAbilitySummary = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	KeenEffect = new class'X2Effect_ChosenKeenRoll';
	KeenEffect.BuildPersistentEffect(1, true, true, true);
	KeenEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
	Template.AddTargetEffect(KeenEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}
class X2Ability_AlwaysProvideCover extends X2Ability
	config(Cover);

var config array<name> HighCover;
var config array<name> LowCover;

var name HighCoverAbilityName;
var name LowCoverAbilityName;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	Templates.AddItem(CreateCoverAbility(default.HighCoverAbilityName, CoverForce_High));
	Templates.AddItem(CreateCoverAbility(default.LowCoverAbilityName, CoverForce_Low));
	return Templates;
}

static function X2DataTemplate CreateCoverAbility(name AbilityName, ECoverForceFlag CoverType)
{
	local X2AbilityTemplate Template;
	local X2Effect_GenerateCover CoverEffect;
	
	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shieldwall";
	Template.AbilitySourceName = 'eAbilitySource_Standard';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	CoverEffect = new class'X2Effect_GenerateCover';
	CoverEffect.CoverType = CoverType;
	// turrets aren't supposed to move but I guess if we want to give this to Sectopods or whoever
	CoverEffect.bRemoveWhenMoved = false;
	CoverEffect.bRemoveOnOtherActivation = false;
	CoverEffect.BuildPersistentEffect(1, true, false, false, eGameRule_TacticalGameStart);
	CoverEffect.SetDisplayInfo(ePerkBuff_Bonus, Template.LocFriendlyName, Template.GetMyHelpText(), Template.IconImage, false);
	Template.AddShooterEffect(CoverEffect);

	if(CoverType == CoverForce_High)
	{
		Template.OverrideAbilities.AddItem(default.LowCoverAbilityName);
	}

	Template.bShowActivation = false;
	Template.bSkipFireAction = true;
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

defaultproperties
{
	HighCoverAbilityName="ConstantHighCover"
	LowCoverAbilityName="ConstantLowCover"
}

class X2Ability_AdditionalPerks extends X2Ability dependson (XComGameStateContext_Ability);

static function array<X2DataTemplate> CreateTemplates() 
{
	local array<X2DataTemplate> Templates;
	local array<SpecializationConfig> Specs;
	local SpecializationConfig Specialization;

	Templates.AddItem(TheGift());
	Templates.AddItem(ExtraPerkLoader());

	Specs = class'MNT_Utility'.static.GetSpecializations();

	foreach Specs(Specialization){
		`LOG("Adding new specialization perk: " $ Specialization.Spec);

		Templates.AddItem(Specialize(Specialization.Spec, Specialization.Icon));
	}

	return Templates;
}

static function X2AbilityTemplate ExtraPerkLoader()
{
	local X2AbilityTemplate                 Template;
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_LoadExtraAbilities		LoadPerks;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'MNT_PerkLoader');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.bDisplayInUITacticalText = false;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;
	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);
		
	LoadPerks = new class 'X2Effect_LoadExtraAbilities';
	LoadPerks.bDisplayInUI = false;
	Template.AddTargetEffect(LoadPerks);
	
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	

}

static function X2AbilityTemplate TheGift()
{
	local X2AbilityTemplate					Template;
	local X2Effect_PsiBonusDamage			PsiDamage;

	Template = PurePassive('TheGift', "img:///UILibrary_PerkIcons.UIPerk_psi_drain", true, 'eAbilitySource_Psionic');

	PsiDamage = new class 'X2Effect_PsiBonusDamage';
	Template.AddTargetEffect(PsiDamage);

	return Template;
}


static function X2AbilityTemplate Specialize(name SpecName, string Icon)
{
	local X2AbilityTemplate					Template;
	local string							InternalName, DisplayName, Description;

	InternalName = "Specialization_" $ SpecName;
	DisplayName = "<font color='#BF1E2E'>" $ SpecName $ "</font>";
	Description = "Specialization: This soldier has been trained as a " $ SpecName $ " specialist.";

	Template = PurePassive(name(InternalName), Icon, true, 'eAbilitySource_Psionic');
	Template.LocFriendlyName = DisplayName;
	Template.LocLongDescription = Description;
	Template.LocHelpText = Description;

	return Template;
}

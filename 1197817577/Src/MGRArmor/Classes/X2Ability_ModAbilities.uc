class X2Ability_ModAbilities extends X2Ability
	dependson (XComGameStateContext_Ability) config(MGRBlade);

var config int HFBLADE_SPEED_BONUS;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> ModWeapons;
	ModWeapons.AddItem(BluescreenT1());
	ModWeapons.AddItem(BluescreenT2());
	ModWeapons.AddItem(BluescreenT3());
	ModWeapons.AddItem(HFBladeSpeedBonus());

	return ModWeapons;
}

static function X2AbilityTemplate HFBladeSpeedBonus()
{
	local X2AbilityTemplate                 Template;	
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'HFBladeSpeedBonus');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_item_nanofibervest";

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	
	if (!class'X2Item_MGRBlade'.default.bHFBladeIsCosmetic)
	{
		PersistentStatChangeEffect = new class'X2Effect_PersistentStatChange';
		PersistentStatChangeEffect.BuildPersistentEffect(1, true, false, false);
		PersistentStatChangeEffect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage, false, , Template.AbilitySourceName);
		PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.HFBLADE_SPEED_BONUS);
		Template.AddTargetEffect(PersistentStatChangeEffect);
	}
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	
	return Template;
}

static function X2AbilityTemplate BluescreenT1()
{
	local X2AbilityTemplate              Template;
	local Astery_Effect_Bluescreen		 BluescreenEffect;

	BluescreenEffect = class'Astery_Effect_Bluescreen'.static.CreateBluescreenEffect(
		class'X2Item_MGRBlade'.default.HFBLADE_CONVENTIONAL_ROBOTIC_DMGMOD,
		class'X2Item_MGRBlade'.default.HFBLADE_CONVENTIONAL_ORGANIC_DMGMOD
	);

	Template = Passive('AsteryBluescreenT1', "img:///UILibrary_PerkIcons.UIPerk_unknown", false, BluescreenEffect);

	Template.bUniqueSource = true;

	return Template;
}

static function X2AbilityTemplate BluescreenT2()
{
	local X2AbilityTemplate              Template;
	local Astery_Effect_Bluescreen		 BluescreenEffect;

	BluescreenEffect = class'Astery_Effect_Bluescreen'.static.CreateBluescreenEffect(
		class'X2Item_MGRBlade'.default.HFBLADE_MAGNETIC_ROBOTIC_DMGMOD,
		class'X2Item_MGRBlade'.default.HFBLADE_MAGNETIC_ORGANIC_DMGMOD
	);

	Template = Passive('AsteryBluescreenT2', "img:///UILibrary_PerkIcons.UIPerk_unknown", false, BluescreenEffect);

	Template.bUniqueSource = true;

	return Template;
}


static function X2AbilityTemplate BluescreenT3()
{
	local X2AbilityTemplate              Template;
	local Astery_Effect_Bluescreen		 BluescreenEffect;

	BluescreenEffect = class'Astery_Effect_Bluescreen'.static.CreateBluescreenEffect(
		class'X2Item_MGRBlade'.default.HFBLADE_BEAM_ROBOTIC_DMGMOD,
		class'X2Item_MGRBlade'.default.HFBLADE_BEAM_ORGANIC_DMGMOD
	);

	Template = Passive('AsteryBluescreenT3', "img:///UILibrary_PerkIcons.UIPerk_unknown", false, BluescreenEffect);

	Template.bUniqueSource = true;

	return Template;
}



//static function X2AbilityTemplate AddSwordSliceAbility(optional Name AbilityName = default.SwordSliceName)
//{
//	local X2AbilityTemplate                 Template;
//	local X2AbilityCost_ActionPoints        ActionPointCost;
//	local X2AbilityToHitCalc_StandardMelee  StandardMelee;
//	local X2Effect_ApplyWeaponDamage        WeaponDamageEffect;
//	local array<name>                       SkipExclusions;
//
//	`CREATE_X2ABILITY_TEMPLATE(Template, AbilityName);
//
//	Template.AbilitySourceName = 'eAbilitySource_Standard';
//	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_AlwaysShow;
//	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
//	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;
//	Template.CinescriptCameraType = "Ranger_Reaper";
//	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_swordSlash";
//	Template.bHideOnClassUnlock = false;
//	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_SQUADDIE_PRIORITY;
//	Template.AbilityConfirmSound = "TacticalUI_SwordConfirm";
//
//	ActionPointCost = new class'X2AbilityCost_ActionPoints';
//	ActionPointCost.iNumPoints = 1;
//	ActionPointCost.bConsumeAllPoints = true;
//	Template.AbilityCosts.AddItem(ActionPointCost);
//	
//	StandardMelee = new class'X2AbilityToHitCalc_StandardMelee';
//	Template.AbilityToHitCalc = StandardMelee;
//
//	Template.AbilityTargetStyle = new class'X2AbilityTarget_MovingMelee';
//	Template.TargetingMethod = class'X2TargetingMethod_MeleePath';
//
//	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);
//	Template.AbilityTriggers.AddItem(new class'X2AbilityTrigger_EndOfMove');
//
//	// Target Conditions
//	//
//	Template.AbilityTargetConditions.AddItem(default.LivingHostileTargetProperty);
//	Template.AbilityTargetConditions.AddItem(default.MeleeVisibilityCondition);
//
//	// Shooter Conditions
//	//
//	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
//	SkipExclusions.AddItem(class'X2StatusEffects'.default.BurningName);
//	Template.AddShooterEffectExclusions(SkipExclusions);
//
//	// Damage Effect
//	//
//	WeaponDamageEffect = new class'X2Effect_ApplyWeaponDamage';
//	Template.AddTargetEffect(WeaponDamageEffect);
//
//	Template.bAllowBonusWeaponEffects = true;
//	Template.bSkipMoveStop = true;
//	
//	// Voice events
//	//
//	Template.SourceMissSpeech = 'SwordMiss';
//
//	Template.BuildNewGameStateFn = TypicalMoveEndAbility_BuildGameState;
//	Template.BuildInterruptGameStateFn = TypicalMoveEndAbility_BuildInterruptGameState;
//
static function X2AbilityTemplate Passive(name DataName, string IconImage, bool bCrossClassEligible, X2Effect_Persistent Effect, bool ShowAbility = false)
{
	local X2AbilityTemplate						Template;

	`CREATE_X2ABILITY_TEMPLATE(Template, DataName);
	Template.IconImage = IconImage;

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	Effect.BuildPersistentEffect(1, true, false, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage, ShowAbility,,Template.AbilitySourceName);
	Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	Template.bCrossClassEligible = bCrossClassEligible;

	return Template;
}
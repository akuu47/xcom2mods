class X2Ability_SecondWaveAbilities extends X2Ability config(Mint_StrategyOverhaul);

// ARMOR VALUES
var config int SWDS_Kevlar_Armor;
var config int SWDS_Kevlar_Shield;
var config int SWDS_SPARK_Armor;
var config int SWDS_SPARK_Shield;

//TEMPLATE CREATION
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;
	
	//XCOM ARMORS - only for armors with no innate abilities
	Templates.AddItem(SWDS_KevlarArmorStats());
	Templates.AddItem(SWDS_SPARKArmorStats());

	//ENEMY
	Templates.AddItem(SWDS_ReactiveArmor());
	Templates.AddItem(SWDS_ForceField());	
	Templates.AddItem(SWDS_HyperRegen());	
	Templates.AddItem(SWDS_AdrenalineRush());	
	Templates.AddItem(SWDS_ChosenActionPoints());

	return Templates;
}

/////////////////////////////////////////////////////////////////////////
//								KEVLAR
/////////////////////////////////////////////////////////////////////////

static function X2AbilityTemplate SWDS_KevlarArmorStats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_BetaStrikeArmor			ArmorStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_ArmorStats_Kevlar');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);
	
	ArmorStatChangeEffect = new class'X2Effect_BetaStrikeArmor';
	ArmorStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	ArmorStatChangeEffect.isSoldier = true;
	Template.AddTargetEffect(ArmorStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate SWDS_SPARKArmorStats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_BetaStrikeArmor			ArmorStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_ArmorStats_SPARK');

	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bDisplayInUITacticalText = false;
	
	Template.AbilityToHitCalc = default.DeadEye;
	
	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);
	
	ArmorStatChangeEffect = new class'X2Effect_BetaStrikeArmor';
	ArmorStatChangeEffect.BuildPersistentEffect(1, true, false, false);
	ArmorStatChangeEffect.isSoldier = true;
	Template.AddTargetEffect(ArmorStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

/////////////////////////////////////////////////////////////////////////
//					ENEMY DURABILITY ABILITIES
/////////////////////////////////////////////////////////////////////////


static function X2AbilityTemplate SWDS_ReactiveArmor()
{
	local X2AbilityTemplate						Template;
	local X2Effect_SWDS_ReactiveArmor			SWDS_ReactiveArmor;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_ReactiveArmor');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_absorption_fields";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	SWDS_ReactiveArmor = new class'X2Effect_SWDS_ReactiveArmor';
	SWDS_ReactiveArmor.EffectName = 'SWDS_ReactiveArmor';
	SWDS_ReactiveArmor.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(SWDS_ReactiveArmor);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate SWDS_AdrenalineRush()
{
	local X2AbilityTemplate						Template;
	local X2Effect_SWDS_AdrenalineRush			SWDS_AdrenalineRush;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_AdrenalineRush');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_adrenaline";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	SWDS_AdrenalineRush = new class'X2Effect_SWDS_AdrenalineRush';
	SWDS_AdrenalineRush.EffectName = 'SWDS_AdrenalineRush';
	SWDS_AdrenalineRush.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(SWDS_AdrenalineRush);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate SWDS_ForceField()
{
	local X2AbilityTemplate						Template;
	local X2Effect_SWDS_ForceField				SWDS_ForceField;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_ForceField');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aethershift";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	SWDS_ForceField = new class'X2Effect_SWDS_ForceField';
	SWDS_ForceField.EffectName ='SWDS_Forcefield';
	SWDS_ForceField.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(SWDS_ForceField);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate SWDS_HyperRegen()
{
	local X2AbilityTemplate						Template;
	local X2Effect_SWDS_HyperRegen				SWDS_HyperRegen;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_HyperRegen');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bioelectricskin";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	SWDS_HyperRegen = new class'X2Effect_SWDS_HyperRegen';
	SWDS_HyperRegen.EffectName = 'SWDS_HyperRegen';
	SWDS_HyperRegen.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(SWDS_HyperRegen);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate SWDS_ChosenActionPoints() {
	local X2AbilityTemplate						Template;
	local X2Effect_SWDS_ChosenActionPoints				SWDS_ChosenActionPoints;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_ChosenActionPoints');

	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_bioelectricskin";
	Template.AbilitySourceName = 'eAbilitySource_Item';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);
	SWDS_ChosenActionPoints = new class'X2Effect_SWDS_ChosenActionPoints';
	SWDS_ChosenActionPoints.EffectName = 'SWDS_ChosenActionPoints';
	SWDS_ChosenActionPoints.BuildPersistentEffect(1, true, false, false);
	Template.AddTargetEffect(SWDS_ChosenActionPoints);
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}





















/*

/////////////////////////////////////////////////////////////////////////
//								PLATED
/////////////////////////////////////////////////////////////////////////

static function X2AbilityTemplate SWDS_LightPlatedArmorStats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_LightPlatedArmorStats');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SWDS_Plated_Light_Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, default.SWDS_Plated_Light_Shield);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SWDS_Plated_Light_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.SWDS_Plated_Light_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate SWDS_MediumPlatedArmorStats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_MediumPlatedArmorStats');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SWDS_Plated_Medium_Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, default.SWDS_Plated_Medium_Shield);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SWDS_Plated_Medium_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.SWDS_Plated_Medium_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate SWDS_HeavyPlatedArmorStats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_HeavyPlatedArmorStats');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SWDS_Plated_Heavy_Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, default.SWDS_Plated_Heavy_Shield);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SWDS_Plated_Heavy_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.SWDS_Plated_Heavy_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

/////////////////////////////////////////////////////////////////////////
//								POWERED
/////////////////////////////////////////////////////////////////////////

static function X2AbilityTemplate SWDS_LightPoweredArmorStats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_LightPoweredArmorStats');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SWDS_Powered_Light_Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, default.SWDS_Powered_Light_Shield);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SWDS_Powered_Light_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.SWDS_Powered_Light_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate SWDS_MediumPoweredArmorStats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_MediumPoweredArmorStats');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SWDS_Powered_Medium_Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, default.SWDS_Powered_Medium_Shield);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SWDS_Powered_Medium_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.SWDS_Powered_Medium_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate SWDS_HeavyPoweredArmorStats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_HeavyPoweredArmorStats');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SWDS_Powered_Heavy_Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, default.SWDS_Powered_Heavy_Shield);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SWDS_Powered_Heavy_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.SWDS_Powered_Heavy_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}


/////////////////////////////////////////////////////////////////////////
//					SPARK ARMORS
/////////////////////////////////////////////////////////////////////////

static function X2AbilityTemplate SWDS_PlatedSparkArmorStats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_PlatedSparkArmorStats');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SWDS_PlatedSpark_Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, default.SWDS_PlatedSpark_Shield);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SWDS_PlatedSpark_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.SWDS_PlatedSpark_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate SWDS_PoweredSparkArmorStats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_PoweredSparkArmorStats');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SWDS_PoweredSPARK_Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, default.SWDS_PoweredSPARK_Shield);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SWDS_PoweredSPARK_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.SWDS_PoweredSPARK_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}



/////////////////////////////////////////////////////////////////////////
//					ALIEN HUNTERS ARMOR
/////////////////////////////////////////////////////////////////////////

static function X2AbilityTemplate SWDS_LightAlienArmorStats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_LightAlienArmorStats');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SWDS_Light_Alien_Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, default.SWDS_Light_Alien_Shield);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SWDS_Light_Alien_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.SWDS_Light_Alien_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate SWDS_LightAlienArmorMK2Stats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_LightAlienArmorMK2Stats');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SWDS_Light_Alien_MK2_Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, default.SWDS_Light_Alien_MK2_Shield);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SWDS_Light_Alien_MK2_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.SWDS_Light_Alien_MK2_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate SWDS_HeavyAlienArmorStats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_HeavyAlienArmorStats');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SWDS_Heavy_Alien_Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, default.SWDS_Heavy_Alien_Shield);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SWDS_Heavy_Alien_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.SWDS_Heavy_Alien_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate SWDS_HeavyAlienArmorMK2Stats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_HeavyAlienArmorMK2Stats');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SWDS_Heavy_Alien_MK2_Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, default.SWDS_Heavy_Alien_MK2_Shield);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SWDS_Heavy_Alien_MK2_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.SWDS_Heavy_Alien_MK2_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

static function X2AbilityTemplate SWDS_MediumAlienArmorStats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_MediumAlienArmorStats');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SWDS_Medium_Alien_Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, default.SWDS_Medium_Alien_Shield);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SWDS_Medium_Alien_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.SWDS_Medium_Alien_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

/////////////////////////////////////////////////////////////////////////
//								RKEVLAR
/////////////////////////////////////////////////////////////////////////

static function X2AbilityTemplate SWDS_RKevlarArmorStats()
{
	local X2AbilityTemplate                 Template;	
	local X2AbilityTrigger					Trigger;
	local X2AbilityTarget_Self				TargetStyle;
	local X2Effect_PersistentStatChange		PersistentStatChangeEffect;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SWDS_RKevlarArmorStats');

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
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ArmorMitigation, default.SWDS_RKevlar_Armor);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_ShieldHP, default.SWDS_RKevlar_Shield);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Mobility, default.SWDS_RKevlar_Mobility);
	PersistentStatChangeEffect.AddPersistentStatChange(eStat_Dodge, default.SWDS_RKevlar_Dodge);
	Template.AddTargetEffect(PersistentStatChangeEffect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;	
}

*/
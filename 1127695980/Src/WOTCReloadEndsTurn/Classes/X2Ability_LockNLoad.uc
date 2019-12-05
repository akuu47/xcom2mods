class X2Ability_LockNLoad extends X2Ability
	dependson(XComGameStateContext_Ability);
	//config(LockNLoad);
/*
static fucntion array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplates> Templates;

	Templates.AddItem(QuickReload());

	return Templates;
}

static function QuickReload()
{
	local X2AbilityTemplate             Template;
	//local X2Effect_Persistent           PersistentEffect;
	//local X2Effect						Effect;


	`CREATE_X2ABILITY_TEMPLATE(Template, 'LockNLoad');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_reload_chevron";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	//Effect = new class'X2Effect_LockNLoad';
	//Effect.BuildPersistentEffect(1, true, true, true);
	//Template.AddTargetEffect(Effect);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}
*/

/*
static function X2DataTemplate CreateBasicClipSizeUpgrade()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'ClipSizeUpgrade_Bsc');

	SetUpClipSizeBonusUpgrade(Template);
	SetUpTier1Upgrade(Template);

	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.ConvAssault_MagB_inv";
	Template.ClipSizeBonus = default.CLIP_SIZE_BSC;
	
	return Template;
}
*/
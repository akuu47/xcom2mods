class X2Item_DefaultUtilityItems_InfiniteStartingItems extends X2Item_DefaultUtilityItems;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	Items.AddItem(TutorialMedikit());

	return Items;
}

static function X2DataTemplate TutorialMedikit()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'TutorialMedikit');
	Template.ItemCat = 'heal';
	Template.WeaponCat = default.MedikitCat;

	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Medkit";
	Template.EquipSound = "StrategyUI_Medkit_Equip";

	Template.iClipSize = default.MEDIKIT_CHARGES;
	Template.iRange = default.MEDIKIT_RANGE_TILES;
	Template.bMergeAmmo = true;

	Template.Abilities.AddItem('MedikitHeal');
	Template.Abilities.AddItem('MedikitStabilize');
	Template.Abilities.AddItem('MedikitBonus');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.ChargesLabel, , default.MEDIKIT_CHARGES);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.MEDIKIT_RANGE_TILES);

	Template.GameArchetype = "WP_Medikit.WP_Medikit";
	
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 1;
	Template.PointsToComplete = 0;
	Template.Tier = 0;

	Template.bShouldCreateDifficultyVariants = false;

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 2;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.HideIfResearched = 'BattlefieldMedicine';

	Template.Requirements.SpecialRequirementsFn = IsTutorialEnabled;

	return Template;
}

static function bool IsTutorialEnabled()
{
	local XComGameState_CampaignSettings CampaignSettings;

	CampaignSettings = XComGameState_CampaignSettings(class'XComGameStateHistory'.static.GetGameStateHistory().GetSingleGameStateObjectForClass(class'XComGameState_CampaignSettings'));
	return CampaignSettings.bTutorialEnabled;
}
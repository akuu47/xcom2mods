class X2Item_RepairKit extends X2Item config(BeagleEdition);

var config int REPAIRKIT_CHARGES;
var config float REPAIRKIT_RANGE_TILES;
var config int NANOREPAIRKIT_CHARGES;
var config float NANOREPAIRKIT_RANGE_TILES;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;
	
	Items.AddItem(CreateRepairKit());
	Items.AddItem(CreateNanoRepairKit());

	return Items;
}

static function X2DataTemplate CreateRepairKit()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;
	
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'RepairKit');
	Template.ItemCat = 'repair';
	Template.WeaponCat = 'medikit';

	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.strImage = "img:///RepairKit.Inv_Repkit";
	Template.EquipSound = "StrategyUI_Medkit_Equip";

	Template.iClipSize = default.REPAIRKIT_CHARGES;
	Template.iRange = default.REPAIRKIT_RANGE_TILES;
	Template.bMergeAmmo = true;

	Template.Abilities.AddItem('RepairKit_T1');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.ChargesLabel, , default.REPAIRKIT_CHARGES); // TODO: Make the label say charges
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.REPAIRKIT_RANGE_TILES);
	
	Template.GameArchetype = "WP_Medikit.WP_Medikit";

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.StartingItem = true;
	/*
	Template.TradingPostValue = 15;
	Template.PointsToComplete = 0;
	Template.Tier = 0;
	
	Template.bShouldCreateDifficultyVariants = true;
	
	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 35;
	Template.Cost.ResourceCosts.AddItem(Resources);
	*/
	Template.HideIfResearched = 'AutopsySpectre';

	return Template;
}

static function X2DataTemplate CreateNanoRepairKit()
{
	local X2WeaponTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;
	
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'NanoRepairKit');
	Template.ItemCat = 'repair';
	Template.WeaponCat = 'medikit';

	Template.InventorySlot = eInvSlot_Utility;
	Template.StowedLocation = eSlot_RearBackPack;
	Template.strImage = "img:///RepairKit.Inv_RepkitMK2";
	Template.EquipSound = "StrategyUI_Medkit_Equip";

	Template.iClipSize = default.NANOREPAIRKIT_CHARGES;
	Template.iRange = default.NANOREPAIRKIT_RANGE_TILES;
	Template.bMergeAmmo = true;

	Template.Abilities.AddItem('RepairKit_T2');

	Template.SetUIStatMarkup(class'XLocalizedData'.default.ChargesLabel, , default.NANOREPAIRKIT_CHARGES);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.NANOREPAIRKIT_RANGE_TILES);
	
	Template.GameArchetype = "WP_Medikit.WP_Medikit_Lv2";
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.StartingItem = false;
	/*
	Template.TradingPostValue = 25;
	Template.PointsToComplete = 0;
	Template.Tier = 1;

	Template.bShouldCreateDifficultyVariants = true;

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseViper';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);
	*/
	Template.Requirements.RequiredTechs.AddItem('BattlefieldMedicine');

	Template.CreatorTemplateName = 'AutopsySpectre'; // The schematic which creates this item
	Template.BaseItem = 'RepairKit'; // Which item this will be upgraded from

	return Template;
}

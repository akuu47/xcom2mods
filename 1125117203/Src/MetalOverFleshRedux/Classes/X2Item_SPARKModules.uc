class X2Item_SPARKModules extends X2Item;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	Items.AddItem(CreateSCRounds());
	Items.AddItem(CreateHardener());
	Items.AddItem(CreateNanoweave());
	Items.AddItem(CreateCodexModule());

	
	return Items;
}


static function X2AmmoTemplate CreateSCRounds()
{
	local X2AmmoTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2AmmoTemplate', Template, 'SCRounds');
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Tracer_Rounds";
	Template.Abilities.AddItem('HyperReactiveRounds');
	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 1;
	Template.EquipSound = "StrategyUI_Ammo_Equip";

	Template.Requirements.RequiredTechs.AddItem('SPARKPCS');
	//Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel, eStat_Offense, class'RM_SPARKTechs_Helpers'.default.UpgradeTime);

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.LowSuppliesCost;
	Template.Cost.ResourceCosts.AddItem(Resources);
		
	Artifacts.ItemTemplateName = 'CorpseAdventOfficer';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	//FX Reference
	Template.GameArchetype = "Ammo_Tracer.PJ_Tracer";
	
	return Template;
}

static function X2DataTemplate CreateHardener()
{
	local X2EquipmentTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'Hardener');
	Template.ItemCat = 'utility';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Fusion_Matrix";
	Template.EquipSound = "StrategyUI_Vest_Equip";

	Template.Abilities.AddItem('ShieldHardener');

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;

	//Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.NANOFIBER_VEST_HP_BONUS);

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('SPARKShields');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.MedSuppliesCost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseAdventShieldbearer';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate CreateNanoweave()
{
	local X2EquipmentTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'Nanoweave');
	Template.ItemCat = 'defense';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Armor_Harness";
	Template.EquipSound = "StrategyUI_Vest_Equip";

	Template.Abilities.AddItem('NanoweaveBonus');

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;

	//Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.NANOFIBER_VEST_HP_BONUS);

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('SPARKRigging');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.MedSuppliesCost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseMuton';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}

static function X2DataTemplate CreateCodexModule()
{
	local X2EquipmentTemplate Template;
	local ArtifactCost Resources;
	local ArtifactCost Artifacts;

	`CREATE_X2TEMPLATE(class'X2EquipmentTemplate', Template, 'CodexModule');
	Template.ItemCat = 'defense';
	Template.InventorySlot = eInvSlot_Utility;
	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Power_Cell";
	Template.EquipSound = "StrategyUI_Vest_Equip";

	Template.Abilities.AddItem('CodexModuleBonus');

	Template.CanBeBuilt = true;
	Template.TradingPostValue = 30;
	Template.PointsToComplete = 0;
	Template.Tier = 0;

	//Template.SetUIStatMarkup(class'XLocalizedData'.default.HealthLabel, eStat_HP, class'X2Ability_ItemGrantedAbilitySet'.default.NANOFIBER_VEST_HP_BONUS);

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('CodexBrainPt1');

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = class'RM_SPARKTechs_Helpers'.default.HighSuppliesCost;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'CorpseCyberus';
	Artifacts.Quantity = 1;
	Template.Cost.ArtifactCosts.AddItem(Artifacts);

	return Template;
}
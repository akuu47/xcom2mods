class X2Item_UpgradesGREMLINs extends X2Item config(Mint_StrategyOverhaul);

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Items;

	//Suites
	Items.AddItem(CreateCombatSuite());
	Items.AddItem(CreateLogisticSuite());

	Items.AddItem(CreateAegisSuite());
	Items.AddItem(CreateMedicalSuite());
	Items.AddItem(CreateOverclockerSuite());
	Items.AddItem(CreateWrathSuite());
	Items.AddItem(CreateStealthSuite());
	Items.AddItem(CreateDischargeSuite());

	Items.AddItem(CreateNemesisSuite());

	//Modules
	Items.AddItem(CreateSystemUplinkModule());
	Items.AddItem(CreateInterdictionModule());
	Items.AddItem(CreateDecompilationModule());
	Items.AddItem(CreateMegaCapacitors());


	return Items;
}
// #######################################################################################
// -------------------- GREMLIN MODULES --------------------------------------------------
// #######################################################################################

// DEFAULT SUITES (only non-PG GREMLIN modules)
// #######################################################################################
static function X2DataTemplate CreateCombatSuite()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'CombatSuite_Gremlin');
	SetUpGremlinGraphics_FusionMatrix(Template, "Y");

	class'X2Item_DefaultUpgrades'.static.SetUpTier1Upgrade(Template);
	Template.BonusAbilities.AddItem('CombatProtocol');
	Template.BonusAbilities.AddItem('AidProtocol');

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');

	Template.ItemCat = 'utility';
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

static function X2DataTemplate CreateLogisticSuite()
{
	local X2WeaponUpgradeTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'LogisticSuite_Gremlin');
	SetUpGremlinGraphics_FusionMatrix(Template, "Y");

	class'X2Item_DefaultUpgrades'.static.SetUpTier1Upgrade(Template);
	Template.BonusAbilities.AddItem('ScanningProtocol');
	Template.BonusAbilities.AddItem('RevivalProtocol');

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('ModularWeapons');

	Template.ItemCat = 'utility';
	Template.CanBeBuilt = true;
	Template.PointsToComplete = 0;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 50;
	Template.Cost.ResourceCosts.AddItem(Resources);

	return Template;
}

// TIER TWO - SUITES
// #######################################################################################
static function X2DataTemplate CreateAegisSuite()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'AegisSuite_Gremlin');
	SetUpGremlinGraphics_FusionMatrix(Template, "G");

	class'X2Item_DefaultUpgrades'.static.SetUpTier2Upgrade(Template);
	Template.BonusAbilities.AddItem('MNT_WardenProtocol');
	Template.BonusAbilities.AddItem('MNT_ECM');

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyShieldbearer');
	Template.Requirements.RequiredTechs.AddItem('AutopsyCodex');

	return Template;
}

static function X2DataTemplate CreateMedicalSuite()
{
	local X2WeaponUpgradeTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'MedicalSuite_Gremlin');
	SetUpGremlinGraphics_FusionMatrix(Template, "W");

	class'X2Item_DefaultUpgrades'.static.SetUpTier2Upgrade(Template);
	Template.BonusAbilities.AddItem('MedicalProtocol');
	Template.BonusAbilities.AddItem('MNT_MedicalSuite_Dodge');

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('BattlefieldMedicine');
	Template.Requirements.RequiredTechs.AddItem('AutopsyViper');

	return Template;
}

static function X2DataTemplate CreateOverclockerSuite()
{
	local X2WeaponUpgradeTemplate Template;
	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'OverclockerSuite_Gremlin');
	SetUpGremlinGraphics_FusionMatrix(Template, "V");

	class'X2Item_DefaultUpgrades'.static.SetUpTier2Upgrade(Template);
	Template.BonusAbilities.AddItem('MNT_Overclock');
	Template.BonusAbilities.AddItem('MNT_UplinkProtocol');

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('Tech_Elerium');
	Template.Requirements.RequiredTechs.AddItem('AutopsySectopod');

	return Template;
}

static function X2DataTemplate CreateStealthSuite()
{
	local X2WeaponUpgradeTemplate Template;
	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'StealthSuite_Gremlin');
	SetUpGremlinGraphics_FusionMatrix(Template, "P");

	class'X2Item_DefaultUpgrades'.static.SetUpTier2Upgrade(Template);
	Template.BonusAbilities.AddItem('MNT_IllusionProtocol');
	Template.BonusAbilities.AddItem('MNT_RefractionProtocol');

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyFaceless');
	Template.Requirements.RequiredTechs.AddItem('AutopsySpectre');

	return Template;
}

static function X2DataTemplate CreateWrathSuite()
{
	local X2WeaponUpgradeTemplate Template;
	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'WrathSuite_Gremlin');
	SetUpGremlinGraphics_FusionMatrix(Template, "R");

	class'X2Item_DefaultUpgrades'.static.SetUpTier2Upgrade(Template);
	Template.BonusAbilities.AddItem('MNT_AdrenalineProtocol');
	Template.BonusAbilities.AddItem('MNT_IgnitionProtocol');

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('AutopsyBerserker');
	Template.Requirements.RequiredTechs.AddItem('AutopsyPurifier');

	return Template;
}

static function X2DataTemplate CreateDischargeSuite()
{
	local X2WeaponUpgradeTemplate Template;
	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'DischargeSuite_Gremlin');
	SetUpGremlinGraphics_FusionMatrix(Template, "O");

	class'X2Item_DefaultUpgrades'.static.SetUpTier3Upgrade(Template);
	Template.BonusAbilities.AddItem('CapacitorDischarge');

	// Requirements
	Template.Requirements.RequiredTechs.AddItem('Tech_Elerium');
	Template.Requirements.RequiredTechs.AddItem('AutopsySectopod');
	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventPurifier');

	return Template;
}

// TIER THREE - SUITES
// #######################################################################################


static function X2DataTemplate CreateNemesisSuite()
{
	local X2WeaponUpgradeTemplate Template;
	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'NemesisSuite_Gremlin');
	SetUpGremlinGraphics_FusionMatrix(Template, "B");

	class'X2Item_DefaultUpgrades'.static.SetUpTier3Upgrade(Template);
	Template.BonusAbilities.AddItem('MNT_NemesisProtocol');

	Template.Requirements.RequiredTechs.AddItem('ChosenAssassinWeapons');
	Template.Requirements.RequiredTechs.AddItem('ChosenHunterWeapons');
	Template.Requirements.RequiredTechs.AddItem('ChosenWarlockWeapons');

	return Template;
}

// ENHANCEMENTS
// #######################################################################################

static function X2DataTemplate CreateSystemUplinkModule()
{
	local X2WeaponUpgradeTemplate Template;
	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'SystemUplink_Gremlin');
	SetUpGremlinGraphics_ModuleG(Template);

	class'X2Item_DefaultUpgrades'.static.SetUpTier2Upgrade(Template);
	Template.BonusAbilities.AddItem('Holotargeting');
	Template.BonusAbilities.AddItem('MNT_SystemUplink');

	Template.MutuallyExclusiveUpgrades.AddItem('SystemUplink_Gremlin');

	return Template;
}

static function X2DataTemplate CreateInterdictionModule()
{
	local X2WeaponUpgradeTemplate Template;
	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'Interdiction_Gremlin');
	SetUpGremlinGraphics_ModuleR(Template);

	class'X2Item_DefaultUpgrades'.static.SetUpTier2Upgrade(Template);
	Template.BonusAbilities.AddItem('MNT_Interdiction');

	Template.MutuallyExclusiveUpgrades.AddItem('Interdiction_Gremlin');

	return Template;
}

static function X2DataTemplate CreateDecompilationModule()
{
	local X2WeaponUpgradeTemplate Template;
	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'Decompilation_Gremlin');
	SetUpGremlinGraphics_ModuleB(Template);

	class'X2Item_DefaultUpgrades'.static.SetUpTier2Upgrade(Template);
	Template.BonusAbilities.AddItem('MNT_Decompilation');

	Template.MutuallyExclusiveUpgrades.AddItem('Decompilation_Gremlin');

	return Template;
}

static function X2DataTemplate CreateMegaCapacitors()
{
	local X2WeaponUpgradeTemplate Template;
	`CREATE_X2TEMPLATE(class'X2WeaponUpgradeTemplate', Template, 'MegaCapacitor_Gremlin');
	SetUpGremlinGraphics_ModuleY(Template);

	class'X2Item_DefaultUpgrades'.static.SetUpTier2Upgrade(Template);
	Template.BonusAbilities.AddItem('MNT_CircuitAmp');

	Template.MutuallyExclusiveUpgrades.AddItem('MegaCapacitors_Gremlin');

	return Template;
}


// #######################################################################################
// -------------------- GRAPHICAL FUNCTIONS ----------------------------------------------
// #######################################################################################

static function SetUpGremlinGraphics_FusionMatrix(out X2WeaponUpgradeTemplate Template, string C) {
	local string Path;

	Template.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponGremlin;
	
	Template.CanBeBuilt = false;
	Template.MaxQuantity = 1;

	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;
	
	Path = Repl("img:///UILibrary_IconsMint.Fusion_Matrix_<C/>", "<C/>", C);
	Template.strImage = Path;

	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_CV', , "", Path, "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_MG', , "", Path, "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_BM', , "", Path, "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
}

static function SetUpGremlinGraphics_ModuleR(out X2WeaponUpgradeTemplate Template) {
	Template.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponGremlin;
	
	Template.CanBeBuilt = false;
	Template.MaxQuantity = 1;

	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;

	Template.strImage = "img:///UILibrary_IconsMint.Module_R";

	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_CV', , "", "img:///UILibrary_IconsMint.Module_R", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_MG', , "", "img:///UILibrary_IconsMint.Module_R", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_BM', , "", "img:///UILibrary_IconsMint.Module_R", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
}

static function SetUpGremlinGraphics_ModuleG(out X2WeaponUpgradeTemplate Template) {
	Template.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponGremlin;
	
	Template.CanBeBuilt = false;
	Template.MaxQuantity = 1;

	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;

	Template.strImage = "img:///UILibrary_IconsMint.Module_G";

	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_CV', , "", "img:///UILibrary_IconsMint.Module_G", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_MG', , "", "img:///UILibrary_IconsMint.Module_G", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_BM', , "", "img:///UILibrary_IconsMint.Module_G", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
}

static function SetUpGremlinGraphics_ModuleB(out X2WeaponUpgradeTemplate Template) {
	Template.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponGremlin;
	
	Template.CanBeBuilt = false;
	Template.MaxQuantity = 1;

	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;

	Template.strImage = "img:///UILibrary_IconsMint.Module_B";

	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_CV', , "", "img:///UILibrary_IconsMint.Module_B", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_MG', , "", "img:///UILibrary_IconsMint.Module_B", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_BM', , "", "img:///UILibrary_IconsMint.Module_B", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
}

static function SetUpGremlinGraphics_ModuleY(out X2WeaponUpgradeTemplate Template) {
	Template.CanApplyUpgradeToWeaponFn = CanApplyUpgradeToWeaponGremlin;
	
	Template.CanBeBuilt = false;
	Template.MaxQuantity = 1;

	Template.BlackMarketTexts = class'X2Item_DefaultUpgrades'.default.UpgradeBlackMarketTexts;

	Template.strImage = "img:///UILibrary_IconsMint.Module_Y";

	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_CV', , "", "img:///UILibrary_IconsMint.Module_Y", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_MG', , "", "img:///UILibrary_IconsMint.Module_Y", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
	Template.AddUpgradeAttachment('', '', "", "", 'Gremlin_BM', , "", "img:///UILibrary_IconsMint.Module_Y", "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_weaponicon_heat_sink");
}
// #######################################################################################
// -------------------- UPGRADE FUNCTIONS ------------------------------------------------
// #######################################################################################

static function bool CanApplyUpgradeToWeaponGremlin(X2WeaponUpgradeTemplate UpgradeTemplate, XComGameState_Item Weapon, int SlotIndex)
{
	local array<X2WeaponUpgradeTemplate> AttachedUpgradeTemplates;
	local X2WeaponUpgradeTemplate AttachedUpgrade; 
	local int iSlot;
		
	AttachedUpgradeTemplates = Weapon.GetMyWeaponUpgradeTemplates();
	
	if ( !Weapon.GetMyTemplate().IsA('X2GremlinTemplate') )
	{
		return false;
	}

	foreach AttachedUpgradeTemplates(AttachedUpgrade, iSlot)
	{
		// Slot Index indicates the upgrade slot the player intends to replace with this new upgrade
		if (iSlot == SlotIndex)
		{
			// The exact upgrade already equipped in a slot cannot be equipped again
			// This allows different versions of the same upgrade type to be swapped into the slot
			if (AttachedUpgrade == UpgradeTemplate)
			{
				return false;
			}
		}
		else if (UpgradeTemplate.MutuallyExclusiveUpgrades.Find(AttachedUpgrade.Name) != INDEX_NONE)
		{
			// If the new upgrade is mutually exclusive with any of the other currently equipped upgrades, it is not allowed
			return false;
		}
	}

	return true;
}

//---------------------------------------------------------------------------------------
//  FILE:    X2Item_CoilSchematics.uc
//  PURPOSE: Configures schematic upgrades for Coil Gun Weapons
//
//	Borrows HEAVILY from:
//		FILE:    X2Item_LaserSchematics.uc
//		AUTHOR:  Amineri (Long War Studios)
//           
//---------------------------------------------------------------------------------------
class X2Item_CoilSchematics extends X2Item config(WotC_CoilGuns);


var config int AssaultRifle_COIL_SCHEMATIC_SUPPLYCOST;
var config int AssaultRifle_COIL_SCHEMATIC_ALLOYCOST;
var config int AssaultRifle_COIL_SCHEMATIC_ELERIUMCOST;

var config int SMG_COIL_SCHEMATIC_SUPPLYCOST;
var config int SMG_COIL_SCHEMATIC_ALLOYCOST;
var config int SMG_COIL_SCHEMATIC_ELERIUMCOST;

var config int Shotgun_COIL_SCHEMATIC_SUPPLYCOST;
var config int Shotgun_COIL_SCHEMATIC_ALLOYCOST;
var config int Shotgun_COIL_SCHEMATIC_ELERIUMCOST;

var config int Cannon_COIL_SCHEMATIC_SUPPLYCOST;
var config int Cannon_COIL_SCHEMATIC_ALLOYCOST;
var config int Cannon_COIL_SCHEMATIC_ELERIUMCOST;

var config int SniperRifle_COIL_SCHEMATIC_SUPPLYCOST;
var config int SniperRifle_COIL_SCHEMATIC_ALLOYCOST;
var config int SniperRifle_COIL_SCHEMATIC_ELERIUMCOST;

var config int Pistol_COIL_SCHEMATIC_SUPPLYCOST;
var config int Pistol_COIL_SCHEMATIC_ALLOYCOST;
var config int Pistol_COIL_SCHEMATIC_ELERIUMCOST;

//	No Coil Sword
//	var config int Sword_COIL_SCHEMATIC_SUPPLYCOST;
//	var config int Sword_COIL_SCHEMATIC_ALLOYCOST;
//	var config int Sword_COIL_SCHEMATIC_ELERIUMCOST;

//	No Coil PsiAmp
//	var config int PsiAmp_COIL_SCHEMATIC_SUPPLYCOST;
//	var config int PsiAmp_COIL_SCHEMATIC_ALLOYCOST;
//	var config int PsiAmp_COIL_SCHEMATIC_ELERIUMCOST;

//	No Coil Gremlin
//	var config int Gremlin_COIL_SCHEMATIC_SUPPLYCOST;
//	var config int Gremlin_COIL_SCHEMATIC_ALLOYCOST;
//	var config int Gremlin_COIL_SCHEMATIC_ELERIUMCOST;

//	No Coil Grenade Launcher
//	var config int GrenadeLauncher_COIL_SCHEMATIC_SUPPLYCOST;
//	var config int GrenadeLauncher_COIL_SCHEMATIC_ALLOYCOST;
//	var config int GrenadeLauncher_COIL_SCHEMATIC_ELERIUMCOST;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Schematics;
	
	// Weapon Schematics
	Schematics.AddItem(CreateTemplate_AssaultRifle_COIL_Schematic());
	Schematics.AddItem(CreateTemplate_SMG_COIL_Schematic());
	Schematics.AddItem(CreateTemplate_Shotgun_COIL_Schematic());
	Schematics.AddItem(CreateTemplate_Cannon_COIL_Schematic());
	Schematics.AddItem(CreateTemplate_SniperRifle_COIL_Schematic());
	Schematics.AddItem(CreateTemplate_Pistol_COIL_Schematic());
	//Schematics.AddItem(CreateTemplate_Sword_Laser_Schematic());
	//Schematics.AddItem(CreateTemplate_PsiAmp_Laser_Schematic());
	//Schematics.AddItem(CreateTemplate_Gremlin_Laser_Schematic());
	//Schematics.AddItem(CreateTemplate_GrenadeLauncher_Laser_Schematic());

	return Schematics;
}

static function X2DataTemplate CreateTemplate_AssaultRifle_COIL_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'AssaultRifle_CG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_Coil_AssaultRifle"; 
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'AssaultRifle_CG';
	// Template.HideIfPurchased = 'AssaultRifle_BM';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem(class'X2StrategyElement_CoilTechs'.default.CoilGunTech_Tier[0]);
	Template.Requirements.RequiredEngineeringScore = 15;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.AssaultRifle_COIL_SCHEMATIC_SUPPLYCOST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'AlienAlloy';
	Artifacts.Quantity = default.AssaultRifle_COIL_SCHEMATIC_ALLOYCOST;
	Template.Cost.ResourceCosts.AddItem(Artifacts);
	
	// only add elerium cost if configured value greater than 0
	if (default.AssaultRifle_COIL_SCHEMATIC_ELERIUMCOST > 0) {
		Artifacts.ItemTemplateName = 'EleriumDust';
		Artifacts.Quantity = default.AssaultRifle_COIL_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(Artifacts);
	}
	return Template;
}

static function X2DataTemplate CreateTemplate_SMG_COIL_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'SMG_CG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_Coil_SMG"; 
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'SMG_CG';
	// Template.HideIfPurchased = 'SMG_BM';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem(class'X2StrategyElement_CoilTechs'.default.CoilGunTech_Tier[0]); 
	Template.Requirements.RequiredEngineeringScore = 15;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.SMG_COIL_SCHEMATIC_SUPPLYCOST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'AlienAlloy';
	Artifacts.Quantity = default.SMG_COIL_SCHEMATIC_ALLOYCOST;
	Template.Cost.ResourceCosts.AddItem(Artifacts);
	
	// only add elerium cost if configured value greater than 0
	if (default.SMG_COIL_SCHEMATIC_ELERIUMCOST > 0) {
		Artifacts.ItemTemplateName = 'EleriumDust';
		Artifacts.Quantity = default.SMG_COIL_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(Artifacts);
	}

	return Template;
}

static function X2DataTemplate CreateTemplate_Shotgun_COIL_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Shotgun_CG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_Coil_Shotgun";  
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Shotgun_CG';
	// Template.HideIfPurchased = 'Shotgun_BM';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem(class'X2StrategyElement_CoilTechs'.default.CoilGunTech_Tier[1]); 
	Template.Requirements.RequiredEngineeringScore = 15;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Shotgun_COIL_SCHEMATIC_SUPPLYCOST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'AlienAlloy';
	Artifacts.Quantity = default.Shotgun_COIL_SCHEMATIC_ALLOYCOST;
	Template.Cost.ResourceCosts.AddItem(Artifacts);
	
	// only add elerium cost if configured value greater than 0
	if (default.Shotgun_COIL_SCHEMATIC_ELERIUMCOST > 0) {
		Artifacts.ItemTemplateName = 'EleriumDust';
		Artifacts.Quantity = default.Shotgun_COIL_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(Artifacts);
	}

	return Template;
}

static function X2DataTemplate CreateTemplate_Cannon_COIL_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Cannon_CG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_Coil_Cannon";
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
	Template.PointsToComplete = 0;
	Template.Tier = 4;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Cannon_CG';
	// Template.HideIfPurchased = 'Cannon_BM';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem(class'X2StrategyElement_CoilTechs'.default.CoilGunTech_Tier[1]); 
	Template.Requirements.RequiredEngineeringScore = 15;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Cannon_COIL_SCHEMATIC_SUPPLYCOST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'AlienAlloy';
	Artifacts.Quantity = default.Cannon_COIL_SCHEMATIC_ALLOYCOST;
	Template.Cost.ResourceCosts.AddItem(Artifacts);
	
	// only add elerium cost if configured value greater than 0
	if (default.Cannon_COIL_SCHEMATIC_ELERIUMCOST > 0) {
		Artifacts.ItemTemplateName = 'EleriumDust';
		Artifacts.Quantity = default.Cannon_COIL_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(Artifacts);
	}

	return Template;
}

static function X2DataTemplate CreateTemplate_SniperRifle_COIL_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'SniperRifle_CG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_Coil_SniperRifle";
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
	Template.PointsToComplete = 0;
	Template.Tier = 4;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'SniperRifle_CG';
	// Template.HideIfPurchased = 'SniperRifle_BM';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem(class'X2StrategyElement_CoilTechs'.default.CoilGunTech_Tier[1]); 
	Template.Requirements.RequiredEngineeringScore = 15;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.SniperRifle_COIL_SCHEMATIC_SUPPLYCOST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'AlienAlloy';
	Artifacts.Quantity = default.SniperRifle_COIL_SCHEMATIC_ALLOYCOST;
	Template.Cost.ResourceCosts.AddItem(Artifacts);
	
	// only add elerium cost if configured value greater than 0
	if (default.SniperRifle_COIL_SCHEMATIC_ELERIUMCOST > 0) {
		Artifacts.ItemTemplateName = 'EleriumDust';
		Artifacts.Quantity = default.SniperRifle_COIL_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(Artifacts);
	}

	return Template;
}

static function X2DataTemplate CreateTemplate_Pistol_COIL_Schematic()
{
	local X2SchematicTemplate Template;
	local ArtifactCost Resources, Artifacts;

	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Pistol_CG_Schematic');

	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_Coil_Pistol";  
	Template.CanBeBuilt = true;
	Template.bOneTimeBuild = true;
	Template.HideInInventory = true;
	Template.HideInLootRecovered = true;
	Template.PointsToComplete = 0;
	Template.Tier = 3;
	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;

	// Reference Item
	Template.ReferenceItemTemplate = 'Pistol_CG';
	// Template.HideIfPurchased = 'Pistol_BM';

	// Requirements
	Template.Requirements.RequiredTechs.AddItem(class'X2StrategyElement_CoilTechs'.default.CoilGunTech_Tier[0]);  
	Template.Requirements.RequiredEngineeringScore = 15;
	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;

	// Cost
	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = default.Pistol_COIL_SCHEMATIC_SUPPLYCOST;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Artifacts.ItemTemplateName = 'AlienAlloy';
	Artifacts.Quantity = default.Pistol_COIL_SCHEMATIC_ALLOYCOST;
	Template.Cost.ResourceCosts.AddItem(Artifacts);
	
	// only add elerium cost if configured value greater than 0
	if (default.Pistol_COIL_SCHEMATIC_ELERIUMCOST > 0) {
		Artifacts.ItemTemplateName = 'EleriumDust';
		Artifacts.Quantity = default.Pistol_COIL_SCHEMATIC_ELERIUMCOST;
		Template.Cost.ResourceCosts.AddItem(Artifacts);
	}

	return Template;
}

//	No Coil Sword
//static function X2DataTemplate CreateTemplate_Sword_Laser_Schematic()
//{
//	local X2SchematicTemplate Template;
//	local ArtifactCost Resources, Artifacts;
//
//	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Sword_LS_Schematic');
//
//	Template.ItemCat = 'weapon';
//	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Beam_Sword";  //TODO: Update image
//	Template.CanBeBuilt = true;
//	Template.bOneTimeBuild = true;
//	Template.HideInInventory = true;
//	Template.HideInLootRecovered = true;
//	Template.PointsToComplete = 0;
//	Template.Tier = 3;
//	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
//
//	// Reference Item
//	Template.ReferenceItemTemplate = 'Sword_LS';
//	Template.HideIfPurchased = 'Sword_BM';
//
//	// Requirements
//	Template.Requirements.RequiredTechs.AddItem('AutopsyArchon');  //TODO: Add new or update tech requirement
//	Template.Requirements.RequiredEngineeringScore = 20;
//	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
//
//	// Cost
//	Resources.ItemTemplateName = 'Supplies';
//	Resources.Quantity = default.Sword_LASER_SCHEMATIC_SUPPLYCOST;
//	Template.Cost.ResourceCosts.AddItem(Resources);
//
//	Artifacts.ItemTemplateName = 'AlienAlloy';
//	Artifacts.Quantity = default.Sword_LASER_SCHEMATIC_ALLOYCOST;
//	Template.Cost.ResourceCosts.AddItem(Artifacts);
//	
//	// only add elerium cost if configured value greater than 0
//	if (default.Sword_LASER_SCHEMATIC_ELERIUMCOST > 0) {
//		Artifacts.ItemTemplateName = 'EleriumDust';
//		Artifacts.Quantity = default.Sword_LASER_SCHEMATIC_ELERIUMCOST;
//		Template.Cost.ResourceCosts.AddItem(Artifacts);
//	}
//
//	return Template;
//}

// No Coil Gremlin
//static function X2DataTemplate CreateTemplate_Gremlin_Laser_Schematic()
//{
//	local X2SchematicTemplate Template;
//	local ArtifactCost Resources, Artifacts;
//
//	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'Gremlin_LS_Schematic');
//
//	Template.ItemCat = 'weapon';
//	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Gremlin_Drone_Mk3"; //TODO: update image
//	Template.CanBeBuilt = true;
//	Template.bOneTimeBuild = true;
//	Template.HideInInventory = true;
//	Template.HideInLootRecovered = true;
//	Template.PointsToComplete = 0;
//	Template.Tier = 3;
//	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
//
//	// Reference Item
//	Template.ReferenceItemTemplate = 'Gremlin_LS';
//	Template.HideIfPurchased = 'Gremlin_BM';
//
//	// Requirements
//	Template.Requirements.RequiredTechs.AddItem('AutopsySectopod');  // TODO: Add new or update tech requirement
//	Template.Requirements.RequiredEngineeringScore = 20;
//	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
//
//	// Cost
//	Resources.ItemTemplateName = 'Supplies';
//	Resources.Quantity = default.Gremlin_LASER_SCHEMATIC_SUPPLYCOST;
//	Template.Cost.ResourceCosts.AddItem(Resources);
//
//	Artifacts.ItemTemplateName = 'AlienAlloy';
//	Artifacts.Quantity = default.Gremlin_LASER_SCHEMATIC_ALLOYCOST;
//	Template.Cost.ResourceCosts.AddItem(Artifacts);
//	
//	// only add elerium cost if configured value greater than 0
//	if (default.Gremlin_LASER_SCHEMATIC_ELERIUMCOST > 0) {
//		Artifacts.ItemTemplateName = 'EleriumDust';
//		Artifacts.Quantity = default.Gremlin_LASER_SCHEMATIC_ELERIUMCOST;
//		Template.Cost.ResourceCosts.AddItem(Artifacts);
//	}
//
//	return Template;
//}

//	No Coil PsiAmp
//static function X2DataTemplate CreateTemplate_PsiAmp_Laser_Schematic()
//{
//	local X2SchematicTemplate Template;
//	local ArtifactCost Resources, Artifacts;
//
//	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'PsiAmp_LS_Schematic');
//
//	Template.ItemCat = 'weapon';
//	Template.strImage = "img:///UILibrary_StrategyImages.X2InventoryIcons.Inv_Psi_AmpMK3"; //TODO: update image
//	Template.CanBeBuilt = true;
//	Template.bOneTimeBuild = true;
//	Template.HideInInventory = true;
//	Template.HideInLootRecovered = true;
//	Template.PointsToComplete = 0;
//	Template.Tier = 3;
//	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
//
//	// Reference Item
//	Template.ReferenceItemTemplate = 'PsiAmp_LS';
//	Template.HideIfPurchased = 'PsiAmp_BM';
//
//	// Requirements
//	Template.Requirements.RequiredTechs.AddItem('AutopsyGatekeeper');  //TODO: Update or add new tech
//	Template.Requirements.RequiredEngineeringScore = 20;
//	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
//
//	// Cost
//	Resources.ItemTemplateName = 'Supplies';
//	Resources.Quantity = default.PsiAmp_LASER_SCHEMATIC_SUPPLYCOST;
//	Template.Cost.ResourceCosts.AddItem(Resources);
//
//	Artifacts.ItemTemplateName = 'AlienAlloy';
//	Artifacts.Quantity = default.PsiAmp_LASER_SCHEMATIC_ALLOYCOST;
//	Template.Cost.ResourceCosts.AddItem(Artifacts);
//	
//	// only add elerium cost if configured value greater than 0
//	if (default.PsiAmp_LASER_SCHEMATIC_ELERIUMCOST > 0) {
//		Artifacts.ItemTemplateName = 'EleriumDust';
//		Artifacts.Quantity = default.PsiAmp_LASER_SCHEMATIC_ELERIUMCOST;
//		Template.Cost.ResourceCosts.AddItem(Artifacts);
//	}
//
//	//TODO: Review corpse requirement
//	Artifacts.ItemTemplateName = 'CorpseGatekeeper';
//	Artifacts.Quantity = 1;
//	Template.Cost.ArtifactCosts.AddItem(Artifacts);
//
//	return Template;
//}

//	No Coil Grenade Launcher
//static function X2DataTemplate CreateTemplate_GrenadeLauncher_Laser_Schematic()
//{
//	local X2SchematicTemplate Template;
//	local ArtifactCost Resources, Artifacts;
//
//	`CREATE_X2TEMPLATE(class'X2SchematicTemplate', Template, 'GrenadeLauncher_LS_Schematic');
//
//	Template.ItemCat = 'weapon'; 
//	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagLauncher";  //TODO: Updage Image
//	Template.CanBeBuilt = true;
//	Template.bOneTimeBuild = true;
//	Template.HideInInventory = true;
//	Template.HideInLootRecovered = true;
//	Template.PointsToComplete = 0;
//	Template.Tier = 1;
//	Template.OnBuiltFn = class'X2Item_DefaultSchematics'.static.UpgradeItems;
//
//	// Reference Item
//	Template.ReferenceItemTemplate = 'GrenadeLauncher_LS';
//	Template.HideIfPurchased = 'GrenadeLauncher_BM';
//
//	// Requirements
//	Template.Requirements.RequiredTechs.AddItem('AutopsyMuton');  // TODO: Update or add new tech
//	Template.Requirements.RequiredEngineeringScore = 10;
//	Template.Requirements.bVisibleIfPersonnelGatesNotMet = true;
//
//	// Cost
//	Resources.ItemTemplateName = 'Supplies';
//	Resources.Quantity = default.GrenadeLauncher_LASER_SCHEMATIC_SUPPLYCOST;
//	Template.Cost.ResourceCosts.AddItem(Resources);
//
//	Artifacts.ItemTemplateName = 'AlienAlloy';
//	Artifacts.Quantity = default.GrenadeLauncher_LASER_SCHEMATIC_ALLOYCOST;
//	Template.Cost.ResourceCosts.AddItem(Artifacts);
//	
//	// only add elerium cost if configured value greater than 0
//	if (default.GrenadeLauncher_LASER_SCHEMATIC_ELERIUMCOST > 0) {
//		Artifacts.ItemTemplateName = 'EleriumDust';
//		Artifacts.Quantity = default.GrenadeLauncher_LASER_SCHEMATIC_ELERIUMCOST;
//		Template.Cost.ResourceCosts.AddItem(Artifacts);
//	}
//
//	return Template;
//}


//---------------------------------------------------------------------------------------
//  FILE:    X2Item_CoilGunWeapons.uc
//  PURPOSE: Defines weapon templates and updates base-game upgrade templates for Coil Gun Weapons
//
//
//	Borrows HEAVILY from:
//		FILE:    X2Item_LaserWeapons.uc
//		AUTHOR:  Amineri (Long War Studios)
//         
//---------------------------------------------------------------------------------------
class X2Item_CoilGunWeapons extends X2Item config(WotC_CoilGuns);

//Variables from config file
	// Damage Arrays

var config WeaponDamageValue ASSAULTRIFLE_COIL_BASEDAMAGE;
var config WeaponDamageValue SMG_COIL_BASEDAMAGE;
var config WeaponDamageValue LMG_COIL_BASEDAMAGE;
var config WeaponDamageValue SHOTGUN_COIL_BASEDAMAGE;
var config WeaponDamageValue SNIPERRIFLE_COIL_BASEDAMAGE;
var config WeaponDamageValue PISTOL_COIL_BASEDAMAGE;


	// Core Weapon Properties
var config int ASSAULTRIFLE_COIL_AIM;
var config int ASSAULTRIFLE_COIL_CRITCHANCE;
var config int ASSAULTRIFLE_COIL_ICLIPSIZE;
var config int ASSAULTRIFLE_COIL_ISOUNDRANGE;
var config int ASSAULTRIFLE_COIL_IENVIRONMENTDAMAGE;
var config int ASSAULTRIFLE_COIL_ISUPPLIES;
var config int ASSAULTRIFLE_COIL_TRADINGPOSTVALUE;
var config int ASSAULTRIFLE_COIL_IPOINTS;
var config int ASSAULTRIFLE_COIL_UPGRADESLOTS;

var config int SMG_COIL_AIM;
var config int SMG_COIL_CRITCHANCE;
var config int SMG_COIL_ICLIPSIZE;
var config int SMG_COIL_ISOUNDRANGE;
var config int SMG_COIL_IENVIRONMENTDAMAGE;
var config int SMG_COIL_ISUPPLIES;
var config int SMG_COIL_TRADINGPOSTVALUE;
var config int SMG_COIL_IPOINTS;
var config int SMG_COIL_UPGRADESLOTS;

var config int LMG_COIL_AIM;
var config int LMG_COIL_CRITCHANCE;
var config int LMG_COIL_ICLIPSIZE;
var config int LMG_COIL_ISOUNDRANGE;
var config int LMG_COIL_IENVIRONMENTDAMAGE;
var config int LMG_COIL_ISUPPLIES;
var config int LMG_COIL_TRADINGPOSTVALUE;
var config int LMG_COIL_IPOINTS;
var config int LMG_COIL_UPGRADESLOTS;

var config int SHOTGUN_COIL_AIM;
var config int SHOTGUN_COIL_CRITCHANCE;
var config int SHOTGUN_COIL_ICLIPSIZE;
var config int SHOTGUN_COIL_ISOUNDRANGE;
var config int SHOTGUN_COIL_IENVIRONMENTDAMAGE;
var config int SHOTGUN_COIL_ISUPPLIES;
var config int SHOTGUN_COIL_TRADINGPOSTVALUE;
var config int SHOTGUN_COIL_IPOINTS;
var config int SHOTGUN_COIL_UPGRADESLOTS;

var config int SNIPERRIFLE_COIL_AIM;
var config int SNIPERRIFLE_COIL_CRITCHANCE;
var config int SNIPERRIFLE_COIL_ICLIPSIZE;
var config int SNIPERRIFLE_COIL_ISOUNDRANGE;
var config int SNIPERRIFLE_COIL_IENVIRONMENTDAMAGE;
var config int SNIPERRIFLE_COIL_ISUPPLIES;
var config int SNIPERRIFLE_COIL_TRADINGPOSTVALUE;
var config int SNIPERRIFLE_COIL_IPOINTS;
var config int SNIPERRIFLE_COIL_UPGRADESLOTS;

var config int PISTOL_COIL_AIM;
var config int PISTOL_COIL_CRITCHANCE;
var config int PISTOL_COIL_ICLIPSIZE;
var config int PISTOL_COIL_ISOUNDRANGE;
var config int PISTOL_COIL_IENVIRONMENTDAMAGE;
var config int PISTOL_COIL_ISUPPLIES;
var config int PISTOL_COIL_TRADINGPOSTVALUE;
var config int PISTOL_COIL_IPOINTS;
var config int PISTOL_COIL_UPGRADESLOTS;


var config array<int> SHORT_COIL_RANGE;
var config array<int> MIDSHORT_COIL_RANGE;
var config array<int> MEDIUM_COIL_RANGE;
var config array<int> LONG_COIL_RANGE;

var config string AssaultRifle_COIL_ImagePath;
var config string SMG_COIL_ImagePath;
var config string Cannon_COIL_ImagePath;
var config string Shotgun_COIL_ImagePath;
var config string SniperRifle_COIL_ImagePath;
var config string Pistol_COIL_ImagePath;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;
	local X2ItemTemplateManager ItemTemplateManager;

	//create weapon templates for coil tier
	Weapons.AddItem(CreateTemplate_AssaultRifle_COIL());
	Weapons.AddItem(CreateTemplate_SMG_COIL());
	Weapons.AddItem(CreateTemplate_Cannon_COIL());
	Weapons.AddItem(CreateTemplate_Shotgun_COIL());
	Weapons.AddItem(CreateTemplate_SniperRifle_COIL());
	Weapons.AddItem(CreateTemplate_Pistol_COIL());

	return Weapons;
}

// **********************************************************************************************************
// ***                                       Implementing Coil Guns                                       ***
// **********************************************************************************************************

static function X2DataTemplate CreateTemplate_AssaultRifle_COIL()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AssaultRifle_CG');

	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'beam'; // As far as I can tell, you can't edit weapon techs without doing crazy stuff
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_Base";  //Skins by Pavonis Interactive
	Template.WeaponPanelImage = "_MagneticRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.RangeAccuracy = default.MEDIUM_COIL_RANGE;
	Template.BaseDamage = default.ASSAULTRIFLE_COIL_BASEDAMAGE;
	Template.Aim = default.ASSAULTRIFLE_COIL_AIM;
	Template.CritChance = default.ASSAULTRIFLE_COIL_CRITCHANCE;
	Template.iClipSize = default.ASSAULTRIFLE_COIL_ICLIPSIZE;
	Template.iSoundRange = default.ASSAULTRIFLE_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ASSAULTRIFLE_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.ASSAULTRIFLE_COIL_UPGRADESLOTS; 

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWAssaultRifle_CG.Archetypes.WP_AssaultRifle_CG";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_MagA");
	Template.AddDefaultAttachment('Stock', "LWAccessories_CG.Meshes.LW_Coil_StockA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_StockA"); 
	Template.AddDefaultAttachment('Reargrip', "LWAccessories_CG.Meshes.LW_Coil_ReargripA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilRifle_ReargripA"); 
	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight"); //, , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");  // re-use common conventional flashlight

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	

	Template.CreatorTemplateName = 'AssaultRifle_CG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'AssaultRifle_MG'; // Which item this will be upgraded from

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';  // TODO : update with new damage type

	return Template;
}

static function X2DataTemplate CreateTemplate_SMG_COIL()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SMG_CG');

	Template.WeaponCat = 'rifle';
	Template.WeaponTech = 'beam';	// See note above
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_Base";
	Template.WeaponPanelImage = "_MagneticRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.Abilities.AddItem('SMG_CG_StatBonus');
	Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_CoilSMGAbilities'.default.SMG_COIL_MOBILITY_BONUS);

	Template.RangeAccuracy = default.MIDSHORT_COIL_RANGE;
	Template.BaseDamage = default.SMG_COIL_BASEDAMAGE;
	Template.Aim = default.SMG_COIL_AIM;
	Template.CritChance = default.SMG_COIL_CRITCHANCE;
	Template.iClipSize = default.SMG_COIL_ICLIPSIZE;
	Template.iSoundRange = default.SMG_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SMG_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.SMG_COIL_UPGRADESLOTS; 
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWSMG_CG.Archetypes.WP_SMG_CG";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "LWAssaultRifle_CG.Meshes.LW_CoilRifle_MagA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_MagA");
	Template.AddDefaultAttachment('Stock', "LWAccessories_CG.Meshes.LW_Coil_StockA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_StockA");  
	Template.AddDefaultAttachment('Reargrip', "LWAccessories_CG.Meshes.LW_Coil_ReargripA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSMG_ReargripA"); 
	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight"); //, , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");  // re-use common conventional flashlight

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.CreatorTemplateName = 'SMG_CG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'SMG_MG'; // Which item this will be upgraded from

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}

static function X2DataTemplate CreateTemplate_Cannon_COIL()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Cannon_CG');

	Template.WeaponCat = 'cannon';
	Template.WeaponTech = 'beam'; //See Above
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_Base";
	Template.WeaponPanelImage = "_MagneticCannon";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 4;

	Template.RangeAccuracy = default.MEDIUM_COIL_RANGE;
	Template.BaseDamage = default.LMG_COIL_BASEDAMAGE;
	Template.Aim = default.LMG_COIL_AIM;
	Template.CritChance = default.LMG_COIL_CRITCHANCE;
	Template.iClipSize = default.LMG_COIL_ICLIPSIZE;
	Template.iSoundRange = default.LMG_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.LMG_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.LMG_COIL_UPGRADESLOTS; 
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWCannon_CG.Archetypes.WP_Cannon_CG";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Cannon';
	Template.AddDefaultAttachment('Mag', "LWCannon_CG.Meshes.LW_CoilCannon_MagA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_MagA");
	Template.AddDefaultAttachment('Stock', "LWCannon_CG.Meshes.LW_CoilCannon_StockA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_StockA");
	Template.AddDefaultAttachment('StockSupport', "LWCannon_CG.Meshes.LW_CoilCannon_StockSupportA");  
	Template.AddDefaultAttachment('Reargrip', "LWCannon_CG.Meshes.LW_CoilCannon_ReargripA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilCannon_ReargripA"); 
	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight"); //, , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");  // re-use common conventional flashlight

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.CreatorTemplateName = 'Cannon_CG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Cannon_MG'; // Which item this will be upgraded from

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';  // TODO : update with new damage type

	return Template;
}

static function X2DataTemplate CreateTemplate_Shotgun_COIL()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Shotgun_CG');

	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'beam'; //see above
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_Base";
//	Template.strImage = "img:///UILibrary_Common.UI_MagShotgun.MagShotgun_Base";
	Template.WeaponPanelImage = "_MagneticShotgun";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 4;

	Template.RangeAccuracy = default.SHORT_COIL_RANGE;
	Template.BaseDamage = default.SHOTGUN_COIL_BASEDAMAGE;
	Template.Aim = default.SHOTGUN_COIL_AIM;
	Template.CritChance = default.SHOTGUN_COIL_CRITCHANCE;
	Template.iClipSize = default.SHOTGUN_COIL_ICLIPSIZE;
	Template.iSoundRange = default.SHOTGUN_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SHOTGUN_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.SHOTGUN_COIL_UPGRADESLOTS; 
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWShotgun_CG.Archetypes.WP_Shotgun_CG";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Shotgun';
//	Template.AddDefaultAttachment('Mag', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_MagA");
//	Template.AddDefaultAttachment('Foregrip', "LWShotgun_CG.Meshes.LW_CoilShotgun_MagB", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_ForegripA");
	Template.AddDefaultAttachment('Stock', "LWAccessories_CG.Meshes.LW_Coil_StockA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_StockA");
	Template.AddDefaultAttachment('Reargrip', "LWAccessories_CG.Meshes.LW_Coil_ReargripA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilShotgun_ReargripA");
	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight"); //, , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");  // re-use common conventional flashlight
	
	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.CreatorTemplateName = 'Shotgun_CG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Shotgun_MG'; // Which item this will be upgraded from

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';  // TODO : update with new damage type

	return Template;
}

static function X2DataTemplate CreateTemplate_SniperRifle_COIL()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'SniperRifle_CG');

	Template.WeaponCat = 'sniper_rifle';
	Template.WeaponTech = 'beam'; //see above
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_Base";
	Template.WeaponPanelImage = "_MagneticSniperRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 4;

	Template.RangeAccuracy = default.LONG_COIL_RANGE;
	Template.BaseDamage = default.SNIPERRIFLE_COIL_BASEDAMAGE;
	Template.Aim = default.SNIPERRIFLE_COIL_AIM;
	Template.CritChance = default.SNIPERRIFLE_COIL_CRITCHANCE;
	Template.iClipSize = default.SNIPERRIFLE_COIL_ICLIPSIZE;
	Template.iSoundRange = default.SNIPERRIFLE_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.SNIPERRIFLE_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = default.SNIPERRIFLE_COIL_UPGRADESLOTS; 
	Template.iTypicalActionCost = 2;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('SniperStandardFire');
	Template.Abilities.AddItem('SniperRifleOverwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWSniperRifle_CG.Archetypes.WP_SniperRifle_CG";

	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_AssaultRifle';
	Template.AddDefaultAttachment('Mag', "LWSniperRifle_CG.Meshes.LW_CoilSniper_MagA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_MagA");
	Template.AddDefaultAttachment('Optic', "BeamSniper.Meshes.SM_BeamSniper_OpticA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_OpticA");
	Template.AddDefaultAttachment('Stock', "LWAccessories_CG.Meshes.LW_Coil_StockB", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_StockB");  
	Template.AddDefaultAttachment('Reargrip', "LWAccessories_CG.Meshes.LW_Coil_ReargripA", , "img:///UILibrary_LW_Overhaul.InventoryArt.CoilSniperRifle_ReargripA");
	Template.AddDefaultAttachment('Light', "BeamAttachments.Meshes.BeamFlashLight"); //, , "img:///UILibrary_Common.ConvAssaultRifle.ConvAssault_LightA");  // re-use common conventional flashlight

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.CreatorTemplateName = 'SniperRifle_CG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'SniperRifle_MG'; // Which item this will be upgraded from

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';  // TODO : update with new damage type

	return Template;
}

static function X2DataTemplate CreateTemplate_Pistol_COIL()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Pistol_CG');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol'; //see above
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_LW_Overhaul.InventoryArt.Inv_Coil_Pistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 3;

	Template.RangeAccuracy = default.SHORT_COIL_RANGE;
	Template.BaseDamage = default.PISTOL_COIL_BASEDAMAGE;
	Template.Aim = default.PISTOL_COIL_AIM;
	Template.CritChance = default.PISTOL_COIL_CRITCHANCE;
	Template.iClipSize = default.PISTOL_COIL_ICLIPSIZE;
	Template.iSoundRange = default.PISTOL_COIL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.PISTOL_COIL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;
	
	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA'); 
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "LWPistol_CG.Archetypes.WP_Pistol_CG";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	
	Template.CreatorTemplateName = 'Pistol_CG_Schematic'; // The schematic which creates this item
	Template.BaseItem = 'Pistol_MG'; // Which item this will be upgraded from

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';  // TODO : update with new damage type

	Template.bHideClipSizeStat = true;

	return Template;
}

//No coil sword
//static function X2DataTemplate CreateTemplate_Sword_Laser()
//{
//	local X2WeaponTemplate Template;
//
//	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'Sword_LS');
//	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.
//
//	Template.ItemCat = 'weapon';
//	Template.WeaponCat = 'sword';
//	Template.WeaponTech = 'beam'; //'pulse'; // TODO: fix up any effects that rely on hard-coded techs
//	Template.strImage = "img:///" $ default.Sword_Laser_ImagePath; 
//	Template.EquipSound = "Sword_Equip_Beam";   // TODO: update with new equip sound
//	Template.InventorySlot = eInvSlot_SecondaryWeapon;
//	Template.StowedLocation = eSlot_RightBack;
//	// This all the resources; sounds, animations, models, physics, the works.
//	Template.GameArchetype = "LWSword_LS.Archetype.WP_Sword_LS";
//	Template.AddDefaultAttachment('R_Back', "BeamSword.Meshes.SM_BeamSword_Sheath", false); // TODO: update sheath if needed
//	Template.Tier = 4;
//
//	Template.iRadius = 1;
//	Template.NumUpgradeSlots = 2;
//	Template.InfiniteAmmo = true;
//	Template.iPhysicsImpulse = 5;
//
//	Template.iRange = 0;
//	Template.BaseDamage = default.SWORD_LASER_BASEDAMAGE;
//	Template.Aim = default.SWORD_LASER_AIM;
//	Template.CritChance = default.SWORD_LASER_CRITCHANCE;
//	Template.iSoundRange = default.SWORD_LASER_ISOUNDRANGE;
//	Template.iEnvironmentDamage = default.SWORD_LASER_IENVIRONMENTDAMAGE;
//	Template.BaseDamage.DamageType='Melee';
//
//	Template.BonusWeaponEffects.AddItem(class'X2StatusEffects'.static.CreateBurningStatusEffect(2, 0));
//	
//	Template.CanBeBuilt = false;
//	Template.bInfiniteItem = true;
//
//	Template.CreatorTemplateName = 'Sword_LS_Schematic'; // The schematic which creates this item
//	Template.BaseItem = 'Sword_MG'; // Which item this will be upgraded from
//
//	Template.DamageTypeTemplateName = 'Melee';
//	
//	return Template;
//}

defaultproperties
{
	bShouldCreateDifficultyVariants = true
}
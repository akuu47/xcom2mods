class X2Item_SPARKLaunchers extends X2Item config(SPARKLaunchers);

var config WeaponDamageValue MicroMissilesM1_BaseDamage;
var config WeaponDamageValue MicroMissilesM2_BaseDamage;

var config WeaponDamageValue Support_BaseDamage;


var config int MicroMissilesM1_EnviroDamage;
var config int MicroMissilesM2_EnviroDamage;

var config int SupportAmmo_Mk1;
var config int SupportAmmo_Mk2;
var config int CombatAmmo_Mk1;
var config int CombatAmmo_Mk2;

var config int StandardRange;
var config int ExtendedRange;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(CreateTemplate_SupportLauncher_Conventional());
	Weapons.AddItem(CreateTemplate_SPARKLauncher_Conventional());
	Weapons.AddItem(CreateTemplate_SupportLauncher_Magnetic());
	Weapons.AddItem(CreateTemplate_SPARKLauncher_Magnetic());
//
	Weapons.AddItem(CreateTemplate_SupportLauncher_Conventional_Paired());
	Weapons.AddItem(CreateTemplate_SPARKLauncher_Conventional_Paired());
	Weapons.AddItem(CreateTemplate_SupportLauncher_Magnetic_Paired());
	Weapons.AddItem(CreateTemplate_SPARKLauncher_Magnetic_Paired());
//
	return Weapons;
}


static function X2DataTemplate CreateTemplate_SupportLauncher_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'RM_SupportLauncher_CV');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///SPARKLaunchers_Content.AdvMecLauncher";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.Support_BaseDamage;
	Template.iClipSize = default.SupportAmmo_Mk1;
	Template.iSoundRange =  class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = 0;
	Template.iIdealRange =  class'X2Item_DefaultWeapons'.default.ADVMEC_M2_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_QuaternaryWeapon;
	Template.Abilities.AddItem('RM_SmokeRain');
	Template.Abilities.AddItem('MicroMissileFuse');
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "SPARKLaunchers_Content.WP_AdvMecLauncher";
	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.TradingPostValue = 30;
	Template.iRange = default.StandardRange;

	// This controls how much arc this projectile may have and how many times it may bounce
	Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	Template.DamageTypeTemplateName = 'Explosion';

	return Template;
}


static function X2DataTemplate CreateTemplate_SupportLauncher_Magnetic()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'RM_SupportLauncher_MG');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///SPARKLaunchers_Content.AdvMecBigSupportLauncher";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.Support_BaseDamage;
	Template.iClipSize = default.SupportAmmo_Mk2;
	Template.iSoundRange =  class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = 0;
	Template.iIdealRange =  class'X2Item_DefaultWeapons'.default.ADVMEC_M2_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_QuaternaryWeapon;
	Template.Abilities.AddItem('RM_SmokeRain');
	Template.Abilities.AddItem('RM_FlashRain');
	Template.Abilities.AddItem('MicroMissileFuse');
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "SPARKLaunchers_Content.Materials.WP_AdvMecBigSupportLauncher";
	Template.iPhysicsImpulse = 5;

	Template.AddDefaultAttachment('launcher_barrel', "SPARKLaunchers_Content.Materials.Sup_Launcher_ExtendedBarrel", , "");

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;
	Template.TradingPostValue = 45;
	Template.iRange = default.ExtendedRange;

	// This controls how much arc this projectile may have and how many times it may bounce
	Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	Template.DamageTypeTemplateName = 'Explosion';

	return Template;
}

static function X2DataTemplate CreateTemplate_SPARKLauncher_Conventional()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'RM_SPARKLauncher_CV');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///SPARKLaunchers_Content.AdvMecLauncher_Spark";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.MicroMissilesM1_BaseDamage;
	Template.iClipSize = default.CombatAmmo_Mk1;
	Template.iSoundRange =  class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.MicroMissilesM1_EnviroDamage;
	//Template.iIdealRange =  class'X2Items_DefaultWeapons'.default.ADVMEC_M2_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_QuaternaryWeapon;
	Template.Abilities.AddItem('RM_SparkMissiles');
	Template.Abilities.AddItem('MicroMissileFuse');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "SPARKLaunchers_Content.WP_AdvMecLauncher_Spark";
	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;
	Template.TradingPostValue = 30;
	Template.iRange = default.StandardRange;

	// This controls how much arc this projectile may have and how many times it may bounce
	Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	Template.DamageTypeTemplateName = 'Explosion';

	return Template;
}


static function X2DataTemplate CreateTemplate_SPARKLauncher_Magnetic()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'RM_SPARKLauncher_MG');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///SPARKLaunchers_Content.AdvMecBigLauncher";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.MicroMissilesM2_BaseDamage;
	Template.iClipSize = default.CombatAmmo_Mk2;
	Template.iSoundRange =  class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.MicroMissilesM2_EnviroDamage;
	//Template.iIdealRange =  class'X2Items_DefaultWeapons'.default.ADVMEC_M2_IDEALRANGE;
	
	Template.InventorySlot = eInvSlot_QuaternaryWeapon;
	Template.Abilities.AddItem('RM_SparkMissiles');
	Template.Abilities.AddItem('MicroMissileFuse');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "SPARKLaunchers_Content.Materials.WP_AdvMecBigLauncher";
	Template.iPhysicsImpulse = 5;

	// Default Attachments
	Template.AddDefaultAttachment('launcher_barrel', "SPARKLaunchers_Content.Materials.SK_Launcher_ExtendedBarrel", , "");
	
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = false;
	Template.TradingPostValue = 30;
	Template.iRange = default.ExtendedRange;

	// This controls how much arc this projectile may have and how many times it may bounce
	Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;

	Template.DamageTypeTemplateName = 'Explosion';

	return Template;
}

static function X2DataTemplate CreateTemplate_SupportLauncher_Conventional_Paired()
{
	local X2PairedWeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'RM_SupportLauncher_CV_Paired');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///SPARKLaunchers_Content.AdvMecLauncher";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
//
	//Template.RangeAccuracy = class'X2Items_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	//Template.BaseDamage = 0;
	//Template.iClipSize = 2;
	//Template.iSoundRange =  class'X2Items_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	//Template.iEnvironmentDamage = 0;
	//Template.iIdealRange =  class'X2Items_DefaultWeapons'.default.ADVMEC_M2_IDEALRANGE;
	//
	Template.PairedSlot = eInvSlot_QuaternaryWeapon;
	Template.PairedTemplateName = 'RM_SupportLauncher_CV';
	Template.InventorySlot = eInvSlot_Utility;
//
	//Template.Abilities.AddItem('RM_SmokeRain');
	//Template.Abilities.AddItem('MicroMissileFuse');
	
	// This all the resources; sounds, animations, models, physics, the works.
	//Template.GameArchetype = "SPARKLaunchers.WP_AdvMecLauncher";

	Template.iPhysicsImpulse = 5;
	Template.iItemSize = 99; //this is because we have to check the items ourselves

	Template.StartingItem = true;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.TradingPostValue = 30;
	Template.iRange = 20;

	// This controls how much arc this projectile may have and how many times it may bounce
	//Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	//Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	//Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;
//
	//Template.DamageTypeTemplateName = 'Explosion';
//
	return Template;
}

static function X2DataTemplate CreateTemplate_SupportLauncher_Magnetic_Paired()
{
	local X2PairedWeaponTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'RM_SupportLauncher_MG_Paired');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///SPARKLaunchers_Content.AdvMecBigSupportLauncher";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
//
	//Template.RangeAccuracy = class'X2Items_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	//Template.BaseDamage = 0;
	//Template.iClipSize = 2;
	//Template.iSoundRange =  class'X2Items_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	//Template.iEnvironmentDamage = 0;
	//Template.iIdealRange =  class'X2Items_DefaultWeapons'.default.ADVMEC_M2_IDEALRANGE;
	//
	Template.PairedSlot = eInvSlot_QuaternaryWeapon;
	Template.PairedTemplateName = 'RM_SupportLauncher_MG';
	Template.InventorySlot = eInvSlot_Utility;
//
	//Template.Abilities.AddItem('RM_SmokeRain');
	//Template.Abilities.AddItem('MicroMissileFuse');
	
	// This all the resources; sounds, animations, models, physics, the works.
	//Template.GameArchetype = "SPARKLaunchers.WP_AdvMecLauncher";

	Template.iPhysicsImpulse = 5;


	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');
	Template.Requirements.RequiredTechs.AddItem('AdvancedGrenades');

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 60;
	Template.Cost.ResourceCosts.AddItem(Resources);

	Template.CreatorTemplateName = 'AdvancedGrenades'; // The schematic which creates this item
	Template.BaseItem = 'RM_SupportLauncher_CV_Paired'; // Which item this will be upgraded from
	Template.iItemSize = 99; //this is because we have to check the items ourselves

	Template.bInfiniteItem = true;
	Template.CanBeBuilt = false;
	Template.TradingPostValue = 30;
	Template.iRange = 20;

	// This controls how much arc this projectile may have and how many times it may bounce
	//Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	//Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	//Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;
//
	//Template.DamageTypeTemplateName = 'Explosion';
//
	return Template;
}

static function X2DataTemplate CreateTemplate_SPARKLauncher_Conventional_Paired()
{
	local X2PairedWeaponTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'RM_SPARKLauncher_CV_Paired');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///SPARKLaunchers_Content.AdvMecLauncher_Spark";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
//
	//Template.RangeAccuracy = class'X2Items_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	//Template.BaseDamage = 0;
	//Template.iClipSize = 2;
	//Template.iSoundRange =  class'X2Items_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	//Template.iEnvironmentDamage = 0;
	//Template.iIdealRange =  class'X2Items_DefaultWeapons'.default.ADVMEC_M2_IDEALRANGE;
	//
	Template.PairedSlot = eInvSlot_QuaternaryWeapon;
	Template.PairedTemplateName = 'RM_SPARKLauncher_CV';
	Template.InventorySlot = eInvSlot_Utility;
//
	//Template.Abilities.AddItem('RM_SmokeRain');
	//Template.Abilities.AddItem('MicroMissileFuse');
	
	// This all the resources; sounds, animations, models, physics, the works.
	//Template.GameArchetype = "SPARKLaunchers.WP_AdvMecLauncher";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 30;
	Template.Cost.ResourceCosts.AddItem(Resources);
	Template.iItemSize = 99; //this is because we have to check the items ourselves


	//Template.TradingPostValue = 30;
	//Template.iRange = 20;

	// This controls how much arc this projectile may have and how many times it may bounce
	//Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	//Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	//Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;
//
	//Template.DamageTypeTemplateName = 'Explosion';
//
	return Template;
}

static function X2DataTemplate CreateTemplate_SPARKLauncher_Magnetic_Paired()
{
	local X2PairedWeaponTemplate Template;
	local ArtifactCost Resources;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'RM_SPARKLauncher_MG_Paired');
	
	Template.WeaponPanelImage = "_ConventionalRifle";                       // used by the UI. Probably determines iconview of the weapon.
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shoulder_launcher';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///SPARKLaunchers_Content.AdvMecBigLauncher";
	Template.RemoveTemplateAvailablility(Template.BITFIELD_GAMEAREA_Multiplayer); //invalidates multiplayer availability
//
	//Template.RangeAccuracy = class'X2Items_DefaultWeapons'.default.FLAT_CONVENTIONAL_RANGE;
	//Template.BaseDamage = 0;
	//Template.iClipSize = 2;
	//Template.iSoundRange =  class'X2Items_DefaultWeapons'.default.ASSAULTRIFLE_MAGNETIC_ISOUNDRANGE;
	//Template.iEnvironmentDamage = 0;
	//Template.iIdealRange =  class'X2Items_DefaultWeapons'.default.ADVMEC_M2_IDEALRANGE;
	//
	Template.PairedSlot = eInvSlot_QuaternaryWeapon;
	Template.PairedTemplateName = 'RM_SPARKLauncher_MG';
	Template.InventorySlot = eInvSlot_Utility;
//
	//Template.Abilities.AddItem('RM_SmokeRain');
	//Template.Abilities.AddItem('MicroMissileFuse');
	
	// This all the resources; sounds, animations, models, physics, the works.
	//Template.GameArchetype = "SPARKLaunchers.WP_AdvMecLauncher";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = true;
	Template.bInfiniteItem = false;

	Template.Requirements.RequiredTechs.AddItem('AutopsyAdventMEC');
	Template.Requirements.RequiredTechs.AddItem('PlasmaGrenade');

	Resources.ItemTemplateName = 'Supplies';
	Resources.Quantity = 75;
	Template.Cost.ResourceCosts.AddItem(Resources);
	
	Template.CreatorTemplateName = 'PlasmaGrenade'; // The schematic which creates this item
	Template.BaseItem = 'RM_SPARKLauncher_CV_Paired'; // Which item this will be upgraded from

	Template.iItemSize = 99; //this is because we have to check the items ourselves

	Template.TradingPostValue = 40;
	//Template.iRange = 20;

	// This controls how much arc this projectile may have and how many times it may bounce
	//Template.WeaponPrecomputedPathData.InitialPathTime = 1.5;
	//Template.WeaponPrecomputedPathData.MaxPathTime = 2.5;
	//Template.WeaponPrecomputedPathData.MaxNumberOfBounces = 0;
//
	//Template.DamageTypeTemplateName = 'Explosion';
//
	return Template;
}
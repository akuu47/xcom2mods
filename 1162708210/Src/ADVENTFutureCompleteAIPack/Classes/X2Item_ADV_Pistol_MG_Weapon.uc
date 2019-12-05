//---------------------------------------------------------------------------------------
//  FILE:   X2Item_ModExample_Weapon.uc
//  AUTHOR:  Ryan McFall
//           
//	Template classes define new game mechanics & items. In this example a weapon template
//  is created that can be used to add a new type of weapon to the XCom arsenal
//  
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//---------------------------------------------------------------------------------------
class X2Item_ADV_Pistol_MG_Weapon extends X2Item config(ADVENTPistol); 

//Base damage

var config WeaponDamageValue ADVCAPTAINM1_PISTOL_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVCAPTAINM2_PISTOL_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVCAPTAINM3_PISTOL_WPN_BASEDAMAGE;

var config WeaponDamageValue ADVGENERALM1_PISTOL_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVGENERALM2_PISTOL_WPN_BASEDAMAGE;
var config WeaponDamageValue ADVGENERALM3_PISTOL_WPN_BASEDAMAGE;

//ADVENT Pistol MG
var config array<int> ADV_PISTOL_SHORT_MAGNETIC_RANGE;
var config int ADV_PISTOL_MAGNETIC_AIM;
var config int ADV_PISTOL_MAGNETIC_CRITCHANCE;
var config int ADV_PISTOL_MAGNETIC_ICLIPSIZE;
var config int ADV_PISTOL_MAGNETIC_ISOUNDRANGE;
var config int ADV_PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;
var config int ADV_PISTOL_MAGNETIC_ISUPPLIES;
var config int ADV_PISTOL_MAGNETIC_TRADINGPOSTVALUE;
var config int ADV_PISTOL_MAGNETIC_IPOINTS;
var config int ADV_PISTOL_MAGNETIC_IUPGRADESLOTS;

//Template classes are searched for by the game when it starts. Any derived classes have their CreateTemplates function called
//on the class default object. The game expects CreateTemplates to return a list of templates that it will add to the manager
//reponsible for those types of templates. Later, these templates will be automatically picked up by the game mechanics and systems.
static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> ADVENTPistols;

	ADVENTPistols.AddItem(CreateTemplate_AdvCaptainM1_Pistol());
	ADVENTPistols.AddItem(CreateTemplate_AdvCaptainM2_Pistol());
	ADVENTPistols.AddItem(CreateTemplate_AdvCaptainM3_Pistol());
	ADVENTPistols.AddItem(CreateTemplate_AdvGeneralM1_Pistol());
	ADVENTPistols.AddItem(CreateTemplate_AdvGeneralM2_Pistol());
	ADVENTPistols.AddItem(CreateTemplate_AdvGeneralM3_Pistol());

	ADVENTPistols.AddItem(CreateTemplate_AdvAvengerM1_Pistol());

	return ADVENTPistols;
}

//Template creation functions form the bulk of a template class. This one builds our custom weapon.
static function X2DataTemplate CreateTemplate_AdvCaptainM1_Pistol()
{
	local X2WeaponTemplate Template;

	// Basic properties copied from the conventional assault rifle
	//=====================================================================
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvCaptainM1_Pistol');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 2;

	Template.RangeAccuracy = default.ADV_PISTOL_SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.ADVCAPTAINM1_PISTOL_WPN_BASEDAMAGE;
	Template.Aim = default.ADV_PISTOL_MAGNETIC_AIM;
	Template.CritChance = default.ADV_PISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.ADV_PISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ADV_PISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADV_PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG_Edited.WP_Pistol_MG_Advent_Edited";

	Template.iPhysicsImpulse = 5;

	Template.UpgradeItem = 'ADV_Pistol_BM';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;

	return Template;
}

//Template creation functions form the bulk of a template class. This one builds our custom weapon.
static function X2DataTemplate CreateTemplate_AdvCaptainM2_Pistol()
{
	local X2WeaponTemplate Template;

	// Basic properties copied from the conventional assault rifle
	//=====================================================================
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvCaptainM2_Pistol');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 2;

	Template.RangeAccuracy = default.ADV_PISTOL_SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.ADVCAPTAINM2_PISTOL_WPN_BASEDAMAGE;
	Template.Aim = default.ADV_PISTOL_MAGNETIC_AIM;
	Template.CritChance = default.ADV_PISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.ADV_PISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ADV_PISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADV_PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG_Edited.WP_Pistol_MG_Advent_Edited";

	Template.iPhysicsImpulse = 5;

	Template.UpgradeItem = 'ADV_Pistol_BM';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;

	return Template;
}

//Template creation functions form the bulk of a template class. This one builds our custom weapon.
static function X2DataTemplate CreateTemplate_AdvCaptainM3_Pistol()
{
	local X2WeaponTemplate Template;

	// Basic properties copied from the conventional assault rifle
	//=====================================================================
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvCaptainM3_Pistol');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 2;

	Template.RangeAccuracy = default.ADV_PISTOL_SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.ADVCAPTAINM3_PISTOL_WPN_BASEDAMAGE;
	Template.Aim = default.ADV_PISTOL_MAGNETIC_AIM;
	Template.CritChance = default.ADV_PISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.ADV_PISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ADV_PISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADV_PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG_Edited.WP_Pistol_MG_Advent_Edited";

	Template.iPhysicsImpulse = 5;

	Template.UpgradeItem = 'ADV_Pistol_BM';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvGeneralM1_Pistol()
{
	local X2WeaponTemplate Template;

	// Basic properties copied from the conventional assault rifle
	//=====================================================================
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvGeneralM1_Pistol');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 2;

	Template.RangeAccuracy = default.ADV_PISTOL_SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.ADVGENERALM1_PISTOL_WPN_BASEDAMAGE;
	Template.Aim = default.ADV_PISTOL_MAGNETIC_AIM;
	Template.CritChance = default.ADV_PISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.ADV_PISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ADV_PISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADV_PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG_Edited.WP_Pistol_MG_Advent_Edited";

	Template.iPhysicsImpulse = 5;

	Template.UpgradeItem = 'ADV_Pistol_BM';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;

	return Template;
}

//Template creation functions form the bulk of a template class. This one builds our custom weapon.
static function X2DataTemplate CreateTemplate_AdvGeneralM2_Pistol()
{
	local X2WeaponTemplate Template;

	// Basic properties copied from the conventional assault rifle
	//=====================================================================
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvGeneralM2_Pistol');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 2;

	Template.RangeAccuracy = default.ADV_PISTOL_SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.ADVGENERALM2_PISTOL_WPN_BASEDAMAGE;
	Template.Aim = default.ADV_PISTOL_MAGNETIC_AIM;
	Template.CritChance = default.ADV_PISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.ADV_PISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ADV_PISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADV_PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG_Edited.WP_Pistol_MG_Advent_Edited";

	Template.iPhysicsImpulse = 5;

	Template.UpgradeItem = 'ADV_Pistol_BM';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;

	return Template;
}

//Template creation functions form the bulk of a template class. This one builds our custom weapon.
static function X2DataTemplate CreateTemplate_AdvGeneralM3_Pistol()
{
	local X2WeaponTemplate Template;

	// Basic properties copied from the conventional assault rifle
	//=====================================================================
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvGeneralM3_Pistol');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 2;

	Template.RangeAccuracy = default.ADV_PISTOL_SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.ADVGENERALM3_PISTOL_WPN_BASEDAMAGE;
	Template.Aim = default.ADV_PISTOL_MAGNETIC_AIM;
	Template.CritChance = default.ADV_PISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.ADV_PISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ADV_PISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADV_PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_SecondaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG_Edited.WP_Pistol_MG_Advent_Edited";

	Template.iPhysicsImpulse = 5;

	Template.UpgradeItem = 'ADV_Pistol_BM';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_AdvAvengerM1_Pistol()
{
	local X2WeaponTemplate Template;

	// Basic properties copied from the conventional assault rifle
	//=====================================================================
	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvAvengerM1_Pistol');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 2;

	Template.RangeAccuracy = default.ADV_PISTOL_SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.ADVGENERALM3_PISTOL_WPN_BASEDAMAGE;
	Template.Aim = default.ADV_PISTOL_MAGNETIC_AIM;
	Template.CritChance = default.ADV_PISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.ADV_PISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.ADV_PISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADV_PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_TertiaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG_Edited.WP_Pistol_MG_Advent_Edited";

	Template.iPhysicsImpulse = 5;

	Template.UpgradeItem = 'ADV_Pistol_BM';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	Template.StowedLocation = eSlot_LeftThigh;

	Template.DamageTypeTemplateName = 'Projectile_MagAdvent';

	Template.bHideClipSizeStat = true;

	return Template;
}
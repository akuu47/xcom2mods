class X2Item_FactionWeapons extends X2Item config(GameData_WeaponData);

var config WeaponDamageValue PISTOL_CONVENTIONAL_BASEDAMAGE;
var config WeaponDamageValue PISTOL_MAGNETIC_BASEDAMAGE;
var config WeaponDamageValue PISTOL_BEAM_BASEDAMAGE;


var config int PISTOL_CONVENTIONAL_AIM;
var config int PISTOL_CONVENTIONAL_CRITCHANCE;
var config int PISTOL_CONVENTIONAL_ICLIPSIZE;
var config int PISTOL_CONVENTIONAL_ISOUNDRANGE;
var config int PISTOL_CONVENTIONAL_IENVIRONMENTDAMAGE;

var config int PISTOL_MAGNETIC_AIM;
var config int PISTOL_MAGNETIC_CRITCHANCE;
var config int PISTOL_MAGNETIC_ICLIPSIZE;
var config int PISTOL_MAGNETIC_ISOUNDRANGE;
var config int PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

var config int PISTOL_BEAM_AIM;
var config int PISTOL_BEAM_CRITCHANCE;
var config int PISTOL_BEAM_ICLIPSIZE;
var config int PISTOL_BEAM_ISOUNDRANGE;
var config int PISTOL_BEAM_IENVIRONMENTDAMAGE;


static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(CreateTemplate_VektorRifle_Faction());
	Weapons.AddItem(CreateTemplate_VektorRifle_FactionM2());

	Weapons.AddItem(CreateTemplate_ShardGauntlet_Faction());
	Weapons.AddItem(CreateTemplate_ShardGauntlet_FactionM2());

	Weapons.AddItem(CreateTemplate_ShardGauntletLeft_Faction());
	Weapons.AddItem(CreateTemplate_ShardGauntletLeft_FactionM2());

	Weapons.AddItem(CreateTemplate_Bullpup_Faction());
	Weapons.AddItem(CreateTemplate_Bullpup_FactionM2());

	Weapons.AddItem(CreateTemplate_OperativePistol_M1());
	Weapons.AddItem(CreateTemplate_OperativePistol_M2());
	Weapons.AddItem(CreateTemplate_OperativePistol_M3());

	return Weapons;
}

// **************************************************************************
// ***                          Pistol                                    ***
// **************************************************************************
static function X2DataTemplate CreateTemplate_OperativePistol_M1()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'OperativePistol_CV');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_Common.ConvSecondaryWeapons.ConvPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Conventional";
	Template.Tier = 0;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
	Template.BaseDamage = default.PISTOL_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = default.PISTOL_CONVENTIONAL_AIM;
	Template.CritChance = default.PISTOL_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = default.PISTOL_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = default.PISTOL_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.PISTOL_CONVENTIONAL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 1;

	Template.InfiniteAmmo = true;
	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotConvA');	
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_CV.WP_Pistol_CV";

	Template.iPhysicsImpulse = 5;
	
	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_OperativePistol_M2()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'OperativePistol_MG');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Magnetic";
	Template.Tier = 2;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = default.PISTOL_MAGNETIC_BASEDAMAGE;
	Template.Aim = default.PISTOL_MAGNETIC_AIM;
	Template.CritChance = default.PISTOL_MAGNETIC_CRITCHANCE;
	Template.iClipSize = default.PISTOL_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = default.PISTOL_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.PISTOL_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotMagA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_MG.WP_Pistol_MG";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	Template.bHideClipSizeStat = true;

	return Template;
}

static function X2DataTemplate CreateTemplate_OperativePistol_M3()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'OperativePistol_BM');
	Template.WeaponPanelImage = "_Pistol";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'pistol';
	Template.WeaponTech = 'beam';
	Template.strImage = "img:///UILibrary_Common.BeamSecondaryWeapons.BeamPistol";
	Template.EquipSound = "Secondary_Weapon_Equip_Beam";
	Template.Tier = 4;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_BEAM_RANGE;
	Template.BaseDamage = default.PISTOL_BEAM_BASEDAMAGE;
	Template.Aim = default.PISTOL_BEAM_AIM;
	Template.CritChance = default.PISTOL_BEAM_CRITCHANCE;
	Template.iClipSize = default.PISTOL_BEAM_ICLIPSIZE;
	Template.iSoundRange = default.PISTOL_BEAM_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.PISTOL_BEAM_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;

	Template.OverwatchActionPoint = class'X2CharacterTemplateManager'.default.PistolOverwatchReserveActionPoint;
	Template.InfiniteAmmo = true;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('PistolStandardShot');
	Template.Abilities.AddItem('PistolOverwatch');
	Template.Abilities.AddItem('PistolOverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('Reload');

	Template.SetAnimationNameForAbility('FanFire', 'FF_FireMultiShotBeamA');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_Pistol_BM.WP_Pistol_BM";

	Template.iPhysicsImpulse = 5;

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	
	Template.DamageTypeTemplateName = 'Projectile_BeamXCom';

	Template.bHideClipSizeStat = true;

	return Template;
}

// **************************************************************************
// ***                          VektorRifle                               ***
// **************************************************************************
static function X2DataTemplate CreateTemplate_VektorRifle_Faction()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'VektorFactionRifle_CV');
	Template.WeaponPanelImage = "_ConventionalSniperRifle";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'vektor_rifle';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_XPACK_Common.ConvVektor_Base";
	Template.EquipSound = "Conventional_Weapon_Equip";
	Template.Tier = 0;

	Template.RangeAccuracy = class'X2Item_XPACKWeapons'.default.VEKTOR_CONVENTIONAL_RANGE;
	Template.BaseDamage = class'X2Item_XPACKWeapons'.default.VEKTORRIFLE_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = class'X2Item_XPACKWeapons'.default.VEKTORRIFLE_CONVENTIONAL_AIM;
	Template.CritChance = class'X2Item_XPACKWeapons'.default.VEKTORRIFLE_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = class'X2Item_XPACKWeapons'.default.VEKTORRIFLE_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_XPACKWeapons'.default.VEKTORRIFLE_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_XPACKWeapons'.default.VEKTORRIFLE_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 1;
	Template.iTypicalActionCost = 2;
		
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('RemoteStart');
	
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_ReaperRifle.WP_ReaperRifle";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Sniper';
	Template.AddDefaultAttachment('Mag', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_MagA", , "img:///UILibrary_XPACK_Common.ConvVektor_MagazineA");
	Template.AddDefaultAttachment('Optic', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_OpticA", , "img:///UILibrary_XPACK_Common.ConvVektor_OpticA");
	Template.AddDefaultAttachment('Reargrip', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_ReargripA");
	Template.AddDefaultAttachment('Stock', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_StockA", , "img:///UILibrary_XPACK_Common.ConvVektor_StockA");
	Template.AddDefaultAttachment('Suppressor', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_SuppressorA", , "img:///UILibrary_XPACK_Common.ConvVektor_SuppressorA");
	Template.AddDefaultAttachment('Trigger', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_TriggerA", , "img:///UILibrary_XPACK_Common.ConvVektor_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");

	Template.iPhysicsImpulse = 5;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;
	
	Template.fKnockbackDamageAmount = 5.0f;
	Template.fKnockbackDamageRadius = 0.0f;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';
	
	return Template;
}

static function X2DataTemplate CreateTemplate_VektorRifle_FactionM2()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'VektorFactionRifle_MG');
	Template.WeaponPanelImage = "_MagneticSniperRifle";                       // used by the UI. Probably determines iconview of the weapon.

	Template.WeaponCat = 'vektor_rifle';
	Template.WeaponTech = 'magnetic';
	Template.ItemCat = 'weapon';
	Template.strImage = "img:///UILibrary_XPACK_Common.MagVektor_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.RangeAccuracy = class'X2Item_XPACKWeapons'.default.VEKTOR_MAGNETIC_RANGE;
	Template.BaseDamage = class'X2Item_XPACKWeapons'.default.VEKTORRIFLE_MAGNETIC_BASEDAMAGE;
	Template.Aim = class'X2Item_XPACKWeapons'.default.VEKTORRIFLE_MAGNETIC_AIM;
	Template.CritChance = class'X2Item_XPACKWeapons'.default.VEKTORRIFLE_MAGNETIC_CRITCHANCE;
	Template.iClipSize = class'X2Item_XPACKWeapons'.default.VEKTORRIFLE_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_XPACKWeapons'.default.VEKTORRIFLE_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_XPACKWeapons'.default.VEKTORRIFLE_MAGNETIC_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 2;
	
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');
	Template.Abilities.AddItem('RemoteStart');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_ReaperRifle_MG.WP_ReaperRifle_MG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Sniper';
	Template.AddDefaultAttachment('Mag', "MagReaperRifle.Meshes.SM_HOR_Mag_ReaperRifle_MagA", , "img:///UILibrary_XPACK_Common.MagVektor_MagazineA");
	Template.AddDefaultAttachment('Optic', "MagReaperRifle.Meshes.SM_HOR_Mag_ReaperRifle_OpticA", , "img:///UILibrary_XPACK_Common.MagVektor_OpticA");
	Template.AddDefaultAttachment('Reargrip', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_ReargripA");
	Template.AddDefaultAttachment('Stock', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_StockA", , "img:///UILibrary_XPACK_Common.MagVektor_StockA");
	Template.AddDefaultAttachment('Trigger', "CnvReaperRifle.Meshes.SM_HOR_Cnv_ReaperRifle_TriggerA", , "img:///UILibrary_XPACK_Common.MagVektor_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");
	

	Template.iPhysicsImpulse = 5;
	
//	Template.CreatorTemplateName = 'VektorRifle_MG_Schematic'; // The schematic which creates this item
//	Template.BaseItem = 'VektorRifle_CV'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}


// **************************************************************************
// ***                   Shard (Templar Gauntlet)                         ***
// **************************************************************************

static function X2DataTemplate CreateTemplate_ShardGauntlet_Faction()
{
	local X2PairedWeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'FactionShardGauntlet_CV');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.
	Template.PairedSlot = eInvSlot_TertiaryWeapon;
	Template.PairedTemplateName = 'FactionShardGauntletLeft_CV';

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'gauntlet';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_ConvTGauntlet";
	Template.EquipSound = "Sword_Equip_Conventional";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntlet";
	Template.AltGameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntlet_F";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 0;
	Template.bUseArmorAppearance = true;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_CONVENTIONAL_BASEDAMAGE;
	Template.ExtraDamage = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_CONVENTIONAL_EXTRADAMAGE;
	Template.Aim = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_CONVENTIONAL_AIM;
	Template.CritChance = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_CONVENTIONAL_CRITCHANCE;
	Template.iSoundRange = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Psi';
	Template.Abilities.AddItem('Parry');

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Psi';

	return Template;
}

static function X2DataTemplate CreateTemplate_ShardGauntlet_FactionM2()
{
	local X2PairedWeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2PairedWeaponTemplate', Template, 'FactionShardGauntlet_MG');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.
	Template.PairedSlot = eInvSlot_TertiaryWeapon;
	Template.PairedTemplateName = 'FactionShardGauntletLeft_MG';

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'gauntlet';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_MagTGauntlet";
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntlet_MG";
	Template.AltGameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntlet_F_MG";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 3;
	Template.bUseArmorAppearance = true;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_MAGNETIC_BASEDAMAGE;
	Template.ExtraDamage = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_MAGNETIC_EXTRADAMAGE;
	Template.Aim = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_MAGNETIC_AIM;
	Template.CritChance = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_MAGNETIC_CRITCHANCE;
	Template.iSoundRange = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Psi';

//	Template.CreatorTemplateName = 'ShardGauntlet_MG_Schematic'; // The schematic which creates this item
//	Template.BaseItem = 'ShardGauntlet_CV'; // Which item this will be upgraded from
	Template.Abilities.AddItem('Parry');
	Template.Abilities.AddItem('Deflect');
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Psi';

	return Template;
}


static function X2DataTemplate CreateTemplate_ShardGauntletLeft_Faction()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'FactionShardGauntletLeft_CV');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'gauntlet';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_ConvTGauntlet";
	Template.EquipSound = "Sword_Equip_Conventional";
	Template.InventorySlot = eInvSlot_TertiaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntletL";
	Template.AltGameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntletL_F";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 0;
	Template.bUseArmorAppearance = true;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_CONVENTIONAL_BASEDAMAGE;
	Template.ExtraDamage = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_CONVENTIONAL_EXTRADAMAGE;
	Template.Aim = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_CONVENTIONAL_AIM;
	Template.CritChance = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_CONVENTIONAL_CRITCHANCE;
	Template.iSoundRange = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_CONVENTIONAL_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}

static function X2DataTemplate CreateTemplate_ShardGauntletLeft_FactionM2()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'FactionShardGauntletLeft_MG');
	Template.WeaponPanelImage = "_Sword";                       // used by the UI. Probably determines iconview of the weapon.
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'gauntlet';
	Template.WeaponTech = 'magnetic';
//BEGIN AUTOGENERATED CODE: Template Overrides 'ShardGauntletLeft_MG'
	Template.strImage = "img:///UILibrary_Common.MagSecondaryWeapons.MagSword";
//END AUTOGENERATED CODE: Template Overrides 'ShardGauntletLeft_MG'
	Template.EquipSound = "Sword_Equip_Magnetic";
	Template.InventorySlot = eInvSlot_TertiaryWeapon;
	//Template.StowedLocation = eSlot_RightBack;
	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntletL_MG";
	Template.AltGameArchetype = "WP_TemplarGauntlet.WP_TemplarGauntletL_F_MG";
	Template.GenderForAltArchetype = eGender_Female;
	Template.Tier = 3;
	Template.bUseArmorAppearance = true;

	Template.iRadius = 1;
	Template.NumUpgradeSlots = 0;
	Template.InfiniteAmmo = true;
	Template.iPhysicsImpulse = 5;

	Template.iRange = 0;
	Template.BaseDamage = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_MAGNETIC_BASEDAMAGE;
	Template.ExtraDamage = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_MAGNETIC_EXTRADAMAGE;
	Template.Aim = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_MAGNETIC_AIM;
	Template.CritChance = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_MAGNETIC_CRITCHANCE;
	Template.iSoundRange = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_XPACKWeapons'.default.SHARDGAUNTLET_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.BaseDamage.DamageType = 'Melee';

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Melee';

	return Template;
}


static function X2DataTemplate CreateTemplate_Bullpup_Faction()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'FactionBullpup_CV');
	Template.WeaponPanelImage = "_ConventionalShotgun";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'bullpup';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_XPACK_Common.ConvSMG_Base";
	Template.EquipSound = "Conventional_Weapon_Equip";
	Template.Tier = 0;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_CONVENTIONAL_RANGE;
	Template.BaseDamage = class'X2Item_XPACKWeapons'.default.BULLPUP_CONVENTIONAL_BASEDAMAGE;
	Template.Aim = class'X2Item_XPACKWeapons'.default.BULLPUP_CONVENTIONAL_AIM;
	Template.CritChance = class'X2Item_XPACKWeapons'.default.BULLPUP_CONVENTIONAL_CRITCHANCE;
	Template.iClipSize = class'X2Item_XPACKWeapons'.default.BULLPUP_CONVENTIONAL_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_XPACKWeapons'.default.BULLPUP_CONVENTIONAL_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_XPACKWeapons'.default.BULLPUP_CONVENTIONAL_IENVIRONMENTDAMAGE;

	Template.NumUpgradeSlots = 1;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_SkirmisherSMG.WP_SkirmisherSMG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Shotgun';
	Template.AddDefaultAttachment('Mag', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_MagA",, "img:///UILibrary_XPACK_Common.ConvSMG_MagazineA");
	Template.AddDefaultAttachment('Reargrip', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_ReargripA");
	Template.AddDefaultAttachment('Stock', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_StockA",, "img:///UILibrary_XPACK_Common.ConvSMG_StockA");
	Template.AddDefaultAttachment('Trigger', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_TriggerA",,"img:///UILibrary_XPACK_Common.ConvSMG_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");

	Template.iPhysicsImpulse = 5;

	Template.fKnockbackDamageAmount = 10.0f;
	Template.fKnockbackDamageRadius = 16.0f;

	Template.StartingItem = false;
	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_Conventional';

	return Template;
}

static function X2DataTemplate CreateTemplate_Bullpup_FactionM2()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'FactionBullpup_MG');
	Template.WeaponPanelImage = "_MagneticShotgun";

	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'bullpup';
	Template.WeaponTech = 'magnetic';
	Template.strImage = "img:///UILibrary_XPACK_Common.MagSMG_Base";
	Template.EquipSound = "Magnetic_Weapon_Equip";
	Template.Tier = 3;

	Template.RangeAccuracy = class'X2Item_DefaultWeapons'.default.SHORT_MAGNETIC_RANGE;
	Template.BaseDamage = class'X2Item_XPACKWeapons'.default.BULLPUP_MAGNETIC_BASEDAMAGE;
	Template.Aim = class'X2Item_XPACKWeapons'.default.BULLPUP_MAGNETIC_AIM;
	Template.CritChance = class'X2Item_XPACKWeapons'.default.BULLPUP_MAGNETIC_CRITCHANCE;
	Template.iClipSize = class'X2Item_XPACKWeapons'.default.BULLPUP_MAGNETIC_ICLIPSIZE;
	Template.iSoundRange = class'X2Item_XPACKWeapons'.default.BULLPUP_MAGNETIC_ISOUNDRANGE;
	Template.iEnvironmentDamage = class'X2Item_XPACKWeapons'.default.BULLPUP_MAGNETIC_IENVIRONMENTDAMAGE;
	Template.NumUpgradeSlots = 2;

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	Template.Abilities.AddItem('StandardShot');
	Template.Abilities.AddItem('Overwatch');
	Template.Abilities.AddItem('OverwatchShot');
	Template.Abilities.AddItem('PistolReturnFire');
	Template.Abilities.AddItem('Reload');
	Template.Abilities.AddItem('HotLoadAmmo');

	// This all the resources; sounds, animations, models, physics, the works.
	Template.GameArchetype = "WP_SkirmisherSMG_MG.WP_SkirmisherSMG_MG";
	Template.UIArmoryCameraPointTag = 'UIPawnLocation_WeaponUpgrade_Shotgun';

	Template.AddDefaultAttachment('Mag', "MagSMG.Meshes.SM_HOR_Mag_SMG_MagA", , "img:///UILibrary_XPACK_Common.MagSMG_MagazineA");
	Template.AddDefaultAttachment('Reargrip', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_ReargripA");
	Template.AddDefaultAttachment('Stock', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_StockA", , "img:///UILibrary_XPACK_Common.MagSMG_StockA");
	Template.AddDefaultAttachment('Trigger', "CnvSMG.Meshes.SM_HOR_Cnv_SMG_TriggerA", , "img:///UILibrary_XPACK_Common.MagSMG_TriggerA");
	Template.AddDefaultAttachment('Light', "ConvAttachments.Meshes.SM_ConvFlashLight");

	Template.iPhysicsImpulse = 5;

	Template.fKnockbackDamageAmount = 10.0f;
	Template.fKnockbackDamageRadius = 16.0f;

	//Template.CreatorTemplateName = 'Bullpup_MG_Schematic'; // The schematic which creates this item
	//Template.BaseItem = 'Bullpup_CV'; // Which item this will be upgraded from

	Template.CanBeBuilt = false;
	Template.bInfiniteItem = true;

	Template.DamageTypeTemplateName = 'Projectile_MagXCom';

	return Template;
}
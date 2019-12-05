class X2Item_EUWeaponPack extends X2Item config(EUWeapons);

var config bool UseFlashLights;
var config bool LightPlasmaSMG;
var config bool LightPlasmaBullpup;
var config bool RemoveBeamTierWeapons;

var config WeaponDamageValue LightPlasmaRifle_BaseDamage;
var config int LightPlasmaRifle_Aim;

var array<name> Beam;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Weapons;

	Weapons.AddItem(CreateTemplate_AssaultRifle());
	Weapons.AddItem(CreateTemplate_Shotgun());
	Weapons.AddItem(CreateTemplate_Cannon());
	Weapons.AddItem(CreateTemplate_SniperRifle());
	Weapons.AddItem(CreateTemplate_Pistol());
	Weapons.AddItem(CreateTemplate_LightPlasmaRifle());

	return Weapons;
}

static function X2DataTemplate CreateTemplate_AssaultRifle(optional name NewTemplateName = 'AssaultRifle_PL')
{
	local X2WeaponTemplate BaseTemplate;
	local X2WeaponTemplate Template;

	BaseTemplate = X2WeaponTemplate(class'X2Item_DefaultWeapons'.static.CreateTemplate_AssaultRifle_Beam());
	
	Template = new(none, string(NewTemplateName)) BaseTemplate.class (BaseTemplate);
	Template.SetTemplateName(NewTemplateName);
	Template.DefaultAttachments.Length = 0;
	if (default.UseFlashLights)
		Template.AddDefaultAttachment('FlashLight', "EU_PlasmaRifle.Meshes.SM_EU_PlasmaRifle_FlashLight");

	if (default.RemoveBeamTierWeapons == false)
		Template.BaseItem = '';

	Template.strImage = "img:///UILibrary_EUWeapon.PlasmaRifle";
	Template.GameArchetype = "EU_PlasmaWeapon_Archetypes.WP_PlasmaRifle";
	Template.BaseItem = '';

	return Template;
}

static function X2DataTemplate CreateTemplate_Shotgun(optional name NewTemplateName = 'Shotgun_PL')
{
	local X2WeaponTemplate BaseTemplate;
	local X2WeaponTemplate Template;

	BaseTemplate = X2WeaponTemplate(class'X2Item_DefaultWeapons'.static.CreateTemplate_Shotgun_Beam());
	
	Template = new(none, string(NewTemplateName)) BaseTemplate.class (BaseTemplate);
	Template.SetTemplateName(NewTemplateName);
	Template.DefaultAttachments.Length = 0;
	if (default.UseFlashLights)
		Template.AddDefaultAttachment('FlashLight', "EU_AlloyCannon.Meshes.SM_EU_AlloyCannon_FlashLight");

	if (default.RemoveBeamTierWeapons == false)
		Template.BaseItem = '';

	Template.strImage = "img:///UILibrary_EUWeapon.AlloyCannon";
	Template.GameArchetype = "EU_PlasmaWeapon_Archetypes.WP_AlloyCannon";
	Template.BaseItem = '';

	return Template;
}

static function X2DataTemplate CreateTemplate_Cannon(optional name NewTemplateName = 'Cannon_PL')
{
	local X2WeaponTemplate BaseTemplate;
	local X2WeaponTemplate Template;

	BaseTemplate = X2WeaponTemplate(class'X2Item_DefaultWeapons'.static.CreateTemplate_Cannon_Beam());
	
	Template = new(none, string(NewTemplateName)) BaseTemplate.class (BaseTemplate);
	Template.SetTemplateName(NewTemplateName);
	Template.DefaultAttachments.Length = 0;
	if (default.UseFlashLights)
		Template.AddDefaultAttachment('FlashLight', "EU_HeavyPlasma.Meshes.SM_EU_HeavyPlasma_FlashLight");

	if (default.RemoveBeamTierWeapons == false)
		Template.BaseItem = '';

	Template.strImage = "img:///UILibrary_EUWeapon.HeavyPlasma";
	Template.GameArchetype = "EU_PlasmaWeapon_Archetypes.WP_HeavyPlasma";
	Template.BaseItem = '';

	return Template;
}

static function X2DataTemplate CreateTemplate_SniperRifle(optional name NewTemplateName = 'SniperRifle_PL')
{
	local X2WeaponTemplate BaseTemplate;
	local X2WeaponTemplate Template;

	BaseTemplate = X2WeaponTemplate(class'X2Item_DefaultWeapons'.static.CreateTemplate_SniperRifle_Beam());
	
	Template = new(none, string(NewTemplateName)) BaseTemplate.class (BaseTemplate);
	Template.SetTemplateName(NewTemplateName);
	Template.DefaultAttachments.Length = 0;
	if (default.UseFlashLights)
		Template.AddDefaultAttachment('FlashLight', "EU_PlasmaSniper.Meshes.SM_EU_PlasmaSniper_FlashLight");

	if (default.RemoveBeamTierWeapons == false)
		Template.BaseItem = '';

	Template.AddDefaultAttachment('Barrel', "EU_PlasmaSniper.SM_EU_PlasmaSniper_Barrel");

	Template.strImage = "img:///UILibrary_EUWeapon.PlasmaSniper";
	Template.GameArchetype = "EU_PlasmaWeapon_Archetypes.WP_PlasmaSniper";
	Template.BaseItem = '';

	return Template;
}

static function X2DataTemplate CreateTemplate_Pistol(optional name NewTemplateName = 'Pistol_PL')
{
	local X2WeaponTemplate BaseTemplate;
	local X2WeaponTemplate Template;

	BaseTemplate = X2WeaponTemplate(class'X2Item_DefaultWeapons'.static.CreateTemplate_Pistol_Beam());
	
	Template = new(none, string(NewTemplateName)) BaseTemplate.class (BaseTemplate);
	Template.SetTemplateName(NewTemplateName);
	Template.DefaultAttachments.Length = 0;

	if (default.RemoveBeamTierWeapons == false)
		Template.BaseItem = '';

	Template.strImage = "img:///UILibrary_EUWeapon.PlasmaPistol";
	Template.GameArchetype = "EU_PlasmaWeapon_Archetypes.WP_PlasmaPistol";
	Template.BaseItem = '';

	return Template;
}

static function X2DataTemplate CreateTemplate_LightPlasmaRifle(optional name NewTemplateName = 'LightPlasmaRifle_PL')
{
	local X2WeaponTemplate BaseTemplate;
	local X2WeaponTemplate Template;

	BaseTemplate = X2WeaponTemplate(class'X2Item_DefaultWeapons'.static.CreateTemplate_AssaultRifle_Beam());
	
	Template = new(none, string(NewTemplateName)) BaseTemplate.class (BaseTemplate);
	Template.SetTemplateName(NewTemplateName);
	Template.DefaultAttachments.Length = 0;

	Template.BaseDamage = default.LightPlasmaRifle_BaseDamage;
	Template.Aim = default.LightPlasmaRifle_Aim;

	if (default.RemoveBeamTierWeapons == false) {
		Template.BaseItem = '';
	} else if (default.LightPlasmaSMG == true) {
		Template.BaseItem = 'SMG_MG';
	} else if (default.LightPlasmaBullpup == true) {
		Template.BaseItem = 'Bullpup_MG';
		Template.WeaponCat = 'bullpup';
	}

	if (default.UseFlashLights)
		Template.AddDefaultAttachment('FlashLight', "EU_LightPlasma.Meshes.SM_EU_LightPlasma_FlashLight");

	Template.strImage = "img:///UILibrary_EUWeapon.LightPlasma";
	Template.GameArchetype = "EU_PlasmaWeapon_Archetypes.WP_LightPlasma";
	Template.BaseItem = '';

	return Template;
}

static function MakeLightPlasmaSomethingElse(optional bool SMGBonuses = true, optional name SMGTemplateName = 'SMG_BM', optional name LightPlasmaTemplateName = 'LightPlasmaRifle_PL')
{
	local X2ItemTemplateManager	ItemTemplateManager;
	local X2WeaponTemplate SMGTemplate;
	local X2WeaponTemplate Template;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	SMGTemplate = X2WeaponTemplate(ItemTemplateManager.FindItemTemplate(SMGTemplateName));
	if (SMGTemplate != none) {
		Template = X2WeaponTemplate(ItemTemplateManager.FindItemTemplate(LightPlasmaTemplateName));

		if (SMGBonuses == true) {
			Template.Abilities.AddItem('SMG_PL_StatBonus');
			Template.SetUIStatMarkup(class'XLocalizedData'.default.MobilityLabel, eStat_Mobility, class'X2Ability_EUWeaponPack'.default.SMG_Plasma_MOBILITY_BONUS);
		}

		Template.RangeAccuracy = SMGTemplate.RangeAccuracy;
		Template.BaseDamage = SMGTemplate.BaseDamage;
		Template.Aim = SMGTemplate.Aim;
		Template.CritChance = SMGTemplate.CritChance;
		Template.iClipSize = SMGTemplate.iClipSize;
		Template.iSoundRange = SMGTemplate.iSoundRange;
		Template.iEnvironmentDamage = SMGTemplate.iEnvironmentDamage;
		Template.NumUpgradeSlots = SMGTemplate.NumUpgradeSlots;
	}
}

static function RemoveBeamTierBaseItems() 
{
	local X2ItemTemplateManager	ItemTemplateManager;
	local array<X2DataTemplate> DifficultyVariants;
	local X2DataTemplate DataTemplate;
	local X2WeaponTemplate Template;
	local name TemplateName;

	ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

	foreach default.Beam(TemplateName) {
		ItemTemplateManager.FindDataTemplateAllDifficulties(TemplateName, DifficultyVariants);
		foreach DifficultyVariants(DataTemplate) {
			Template = X2WeaponTemplate(DataTemplate);
			if (Template != none) {
				Template.BaseItem = '';
			}
		}
	}
}

defaultproperties {
	Beam[0] = 'AssaultRifle_BM'
	Beam[1] = 'SniperRifle_BM'
	Beam[2] = 'Cannon_BM'
	Beam[3] = 'Shotgun_BM'
	Beam[4] = 'Pistol_BM'
}

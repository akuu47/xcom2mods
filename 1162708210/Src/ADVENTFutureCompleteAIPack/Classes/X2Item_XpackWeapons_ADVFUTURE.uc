class X2Item_XpackWeapons_ADVFUTURE extends X2Item_XpackWeapons;

static function array<X2DataTemplate> CreateTemplates()
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(CreateTemplate_AdvPurifierFlamethrowerMK2());
	Templates.AddItem(CreateTemplate_AdvPurifierFlamethrowerMK3());

	return Templates;
}

static function X2WeaponTemplate CreateTemplate_AdvPurifierFlamethrowerMK2()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvPurifierFlamethrowerMK2');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_Advent_Flamethrower";
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.iSoundRange = default.ADVPURIFIER_FLAMETHROWER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADVPURIFIER_FLAMETHROWER_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.ADVPURIFIER_FLAMETHROWER_ICLIPSIZE;
	Template.iRange = default.ADVPURIFIER_FLAMETHROWER_RANGE;
	Template.iRadius = default.ADVPURIFIER_FLAMETHROWER_RADIUS;
	Template.fCoverage = default.ADVPURIFIER_FLAMETHROWER_TILE_COVERAGE_PERCENT;
	
	Template.InfiniteAmmo = true;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Fire';

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	
	Template.GameArchetype = "WP_AdvFlamethrower.WP_AdvFlamethrower";
	Template.bMergeAmmo = true;
	Template.bCanBeDodged = false;

	Template.Abilities.AddItem('AdvPurifierFlamethrower');

	Template.CanBeBuilt = false;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.ADVPURIFIER_FLAMETHROWER_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.ADVPURIFIER_FLAMETHROWER_RADIUS);

	return Template;
}

static function X2WeaponTemplate CreateTemplate_AdvPurifierFlamethrowerMK3()
{
	local X2WeaponTemplate Template;

	`CREATE_X2TEMPLATE(class'X2WeaponTemplate', Template, 'AdvPurifierFlamethrowerMK3');
	
	Template.ItemCat = 'weapon';
	Template.WeaponCat = 'shotgun';
	Template.WeaponTech = 'conventional';
	Template.strImage = "img:///UILibrary_XPACK_StrategyImages.Inv_Advent_Flamethrower";
	Template.EquipSound = "Conventional_Weapon_Equip";

	Template.iSoundRange = default.ADVPURIFIER_FLAMETHROWER_ISOUNDRANGE;
	Template.iEnvironmentDamage = default.ADVPURIFIER_FLAMETHROWER_IENVIRONMENTDAMAGE;
	Template.iClipSize = default.ADVPURIFIER_FLAMETHROWER_ICLIPSIZE;
	Template.iRange = default.ADVPURIFIER_FLAMETHROWER_RANGE;
	Template.iRadius = default.ADVPURIFIER_FLAMETHROWER_RADIUS;
	Template.fCoverage = default.ADVPURIFIER_FLAMETHROWER_TILE_COVERAGE_PERCENT;
	
	Template.InfiniteAmmo = true;
	Template.PointsToComplete = 0;
	Template.DamageTypeTemplateName = 'Fire';

	Template.InventorySlot = eInvSlot_PrimaryWeapon;
	
	Template.GameArchetype = "WP_AdvFlamethrower.WP_AdvFlamethrower";
	Template.bMergeAmmo = true;
	Template.bCanBeDodged = false;

	Template.Abilities.AddItem('AdvPurifierFlamethrower');

	Template.CanBeBuilt = false;

	Template.SetUIStatMarkup(class'XLocalizedData'.default.RangeLabel, , default.ADVPURIFIER_FLAMETHROWER_RANGE);
	Template.SetUIStatMarkup(class'XLocalizedData'.default.RadiusLabel, , default.ADVPURIFIER_FLAMETHROWER_RADIUS);

	return Template;
}